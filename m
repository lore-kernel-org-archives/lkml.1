Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbYGHXXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbYGHXXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYGHXO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:57 -0400
Received: from gw.goop.org ([64.81.55.164]:51218 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 24 of 55] xen64: add 64-bit assembler
X-Mercurial-Node: 318b51353f054866698f3a9f547a7307b3a1e2e8
Message-Id: <318b51353f054866698f.1215554806@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split xen-asm into 32- and 64-bit files, and implement the 64-bit
variants.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile     |    2
 arch/x86/xen/xen-asm.S    |  305 ---------------------------------------------
 arch/x86/xen/xen-asm_32.S |  305 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-asm_64.S |  141 ++++++++++++++++++++
 4 files changed, 447 insertions(+), 306 deletions(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
-			time.o xen-asm.o grant-table.o suspend.o
+			time.o xen-asm_$(BITS).o grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
deleted file mode 100644
--- a/arch/x86/xen/xen-asm.S
+++ /dev/null
@@ -1,305 +0,0 @@
-/*
-	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
-	The inline versions are the same as the direct-use versions, with the
-	pre- and post-amble chopped off.
-
-	This code is encoded for size rather than absolute efficiency,
-	with a view to being able to inline as much as possible.
-
-	We only bother with direct forms (ie, vcpu in pda) of the operations
-	here; the indirect forms are better handled in C, since they're
-	generally too large to inline anyway.
- */
-
-#include <linux/linkage.h>
-
-#include <asm/asm-offsets.h>
-#include <asm/thread_info.h>
-#include <asm/percpu.h>
-#include <asm/processor-flags.h>
-#include <asm/segment.h>
-
-#include <xen/interface/xen.h>
-
-#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
-#define ENDPATCH(x)	.globl x##_end; x##_end=.
-
-/* Pseudo-flag used for virtual NMI, which we don't implement yet */
-#define XEN_EFLAGS_NMI	0x80000000
-
-/*
-	Enable events.  This clears the event mask and tests the pending
-	event status with one and operation.  If there are pending
-	events, then enter the hypervisor to get them handled.
- */
-ENTRY(xen_irq_enable_direct)
-	/* Unmask events */
-	movb $0, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
-
-	/* Preempt here doesn't matter because that will deal with
-	   any pending interrupts.  The pending check may end up being
-	   run on the wrong CPU, but that doesn't hurt. */
-
-	/* Test for pending */
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
-	jz 1f
-
-2:	call check_events
-1:
-ENDPATCH(xen_irq_enable_direct)
-	ret
-	ENDPROC(xen_irq_enable_direct)
-	RELOC(xen_irq_enable_direct, 2b+1)
-
-
-/*
-	Disabling events is simply a matter of making the event mask
-	non-zero.
- */
-ENTRY(xen_irq_disable_direct)
-	movb $1, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
-ENDPATCH(xen_irq_disable_direct)
-	ret
-	ENDPROC(xen_irq_disable_direct)
-	RELOC(xen_irq_disable_direct, 0)
-
-/*
-	(xen_)save_fl is used to get the current interrupt enable status.
-	Callers expect the status to be in X86_EFLAGS_IF, and other bits
-	may be set in the return value.  We take advantage of this by
-	making sure that X86_EFLAGS_IF has the right value (and other bits
-	in that byte are 0), but other bits in the return value are
-	undefined.  We need to toggle the state of the bit, because
-	Xen and x86 use opposite senses (mask vs enable).
- */
-ENTRY(xen_save_fl_direct)
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
-	setz %ah
-	addb %ah,%ah
-ENDPATCH(xen_save_fl_direct)
-	ret
-	ENDPROC(xen_save_fl_direct)
-	RELOC(xen_save_fl_direct, 0)
-
-
-/*
-	In principle the caller should be passing us a value return
-	from xen_save_fl_direct, but for robustness sake we test only
-	the X86_EFLAGS_IF flag rather than the whole byte. After
-	setting the interrupt mask state, it checks for unmasked
-	pending events and enters the hypervisor to get them delivered
-	if so.
- */
-ENTRY(xen_restore_fl_direct)
-	testb $X86_EFLAGS_IF>>8, %ah
-	setz PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
-	/* Preempt here doesn't matter because that will deal with
-	   any pending interrupts.  The pending check may end up being
-	   run on the wrong CPU, but that doesn't hurt. */
-
-	/* check for unmasked and pending */
-	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
-	jz 1f
-2:	call check_events
-1:
-ENDPATCH(xen_restore_fl_direct)
-	ret
-	ENDPROC(xen_restore_fl_direct)
-	RELOC(xen_restore_fl_direct, 2b+1)
-
-/*
-	We can't use sysexit directly, because we're not running in ring0.
-	But we can easily fake it up using iret.  Assuming xen_sysexit
-	is jumped to with a standard stack frame, we can just strip it
-	back to a standard iret frame and use iret.
- */
-ENTRY(xen_sysexit)
-	movl PT_EAX(%esp), %eax			/* Shouldn't be necessary? */
-	orl $X86_EFLAGS_IF, PT_EFLAGS(%esp)
-	lea PT_EIP(%esp), %esp
-
-	jmp xen_iret
-ENDPROC(xen_sysexit)
-
-/*
-	This is run where a normal iret would be run, with the same stack setup:
-	      8: eflags
-	      4: cs
-	esp-> 0: eip
-
-	This attempts to make sure that any pending events are dealt
-	with on return to usermode, but there is a small window in
-	which an event can happen just before entering usermode.  If
-	the nested interrupt ends up setting one of the TIF_WORK_MASK
-	pending work flags, they will not be tested again before
-	returning to usermode. This means that a process can end up
-	with pending work, which will be unprocessed until the process
-	enters and leaves the kernel again, which could be an
-	unbounded amount of time.  This means that a pending signal or
-	reschedule event could be indefinitely delayed.
-
-	The fix is to notice a nested interrupt in the critical
-	window, and if one occurs, then fold the nested interrupt into
-	the current interrupt stack frame, and re-process it
-	iteratively rather than recursively.  This means that it will
-	exit via the normal path, and all pending work will be dealt
-	with appropriately.
-
-	Because the nested interrupt handler needs to deal with the
-	current stack state in whatever form its in, we keep things
-	simple by only using a single register which is pushed/popped
-	on the stack.
- */
-ENTRY(xen_iret)
-	/* test eflags for special cases */
-	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
-	jnz hyper_iret
-
-	push %eax
-	ESP_OFFSET=4	# bytes pushed onto stack
-
-	/* Store vcpu_info pointer for easy access.  Do it this
-	   way to avoid having to reload %fs */
-#ifdef CONFIG_SMP
-	GET_THREAD_INFO(%eax)
-	movl TI_cpu(%eax),%eax
-	movl __per_cpu_offset(,%eax,4),%eax
-	mov per_cpu__xen_vcpu(%eax),%eax
-#else
-	movl per_cpu__xen_vcpu, %eax
-#endif
-
-	/* check IF state we're restoring */
-	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
-
-	/* Maybe enable events.  Once this happens we could get a
-	   recursive event, so the critical region starts immediately
-	   afterwards.  However, if that happens we don't end up
-	   resuming the code, so we don't have to be worried about
-	   being preempted to another CPU. */
-	setz XEN_vcpu_info_mask(%eax)
-xen_iret_start_crit:
-
-	/* check for unmasked and pending */
-	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
-
-	/* If there's something pending, mask events again so we
-	   can jump back into xen_hypervisor_callback */
-	sete XEN_vcpu_info_mask(%eax)
-
-	popl %eax
-
-	/* From this point on the registers are restored and the stack
-	   updated, so we don't need to worry about it if we're preempted */
-iret_restore_end:
-
-	/* Jump to hypervisor_callback after fixing up the stack.
-	   Events are masked, so jumping out of the critical
-	   region is OK. */
-	je xen_hypervisor_callback
-
-1:	iret
-xen_iret_end_crit:
-.section __ex_table,"a"
-	.align 4
-	.long 1b,iret_exc
-.previous
-
-hyper_iret:
-	/* put this out of line since its very rarely used */
-	jmp hypercall_page + __HYPERVISOR_iret * 32
-
-	.globl xen_iret_start_crit, xen_iret_end_crit
-
-/*
-   This is called by xen_hypervisor_callback in entry.S when it sees
-   that the EIP at the time of interrupt was between xen_iret_start_crit
-   and xen_iret_end_crit.  We're passed the EIP in %eax so we can do
-   a more refined determination of what to do.
-
-   The stack format at this point is:
-	----------------
-	 ss		: (ss/esp may be present if we came from usermode)
-	 esp		:
-	 eflags		}  outer exception info
-	 cs		}
-	 eip		}
-	---------------- <- edi (copy dest)
-	 eax		:  outer eax if it hasn't been restored
-	----------------
-	 eflags		}  nested exception info
-	 cs		}   (no ss/esp because we're nested
-	 eip		}    from the same ring)
-	 orig_eax	}<- esi (copy src)
-	 - - - - - - - -
-	 fs		}
-	 es		}
-	 ds		}  SAVE_ALL state
-	 eax		}
-	  :		:
-	 ebx		}<- esp
-	----------------
-
-   In order to deliver the nested exception properly, we need to shift
-   everything from the return addr up to the error code so it
-   sits just under the outer exception info.  This means that when we
-   handle the exception, we do it in the context of the outer exception
-   rather than starting a new one.
-
-   The only caveat is that if the outer eax hasn't been
-   restored yet (ie, it's still on stack), we need to insert
-   its value into the SAVE_ALL state before going on, since
-   it's usermode state which we eventually need to restore.
- */
-ENTRY(xen_iret_crit_fixup)
-	/*
-	   Paranoia: Make sure we're really coming from kernel space.
-	   One could imagine a case where userspace jumps into the
-	   critical range address, but just before the CPU delivers a GP,
-	   it decides to deliver an interrupt instead.  Unlikely?
-	   Definitely.  Easy to avoid?  Yes.  The Intel documents
-	   explicitly say that the reported EIP for a bad jump is the
-	   jump instruction itself, not the destination, but some virtual
-	   environments get this wrong.
-	 */
-	movl PT_CS(%esp), %ecx
-	andl $SEGMENT_RPL_MASK, %ecx
-	cmpl $USER_RPL, %ecx
-	je 2f
-
-	lea PT_ORIG_EAX(%esp), %esi
-	lea PT_EFLAGS(%esp), %edi
-
-	/* If eip is before iret_restore_end then stack
-	   hasn't been restored yet. */
-	cmp $iret_restore_end, %eax
-	jae 1f
-
-	movl 0+4(%edi),%eax		/* copy EAX (just above top of frame) */
-	movl %eax, PT_EAX(%esp)
-
-	lea ESP_OFFSET(%edi),%edi	/* move dest up over saved regs */
-
-	/* set up the copy */
-1:	std
-	mov $PT_EIP / 4, %ecx		/* saved regs up to orig_eax */
-	rep movsl
-	cld
-
-	lea 4(%edi),%esp		/* point esp to new frame */
-2:	jmp xen_do_upcall
-
-
-/*
-	Force an event check by making a hypercall,
-	but preserve regs before making the call.
- */
-check_events:
-	push %eax
-	push %ecx
-	push %edx
-	call force_evtchn_callback
-	pop %edx
-	pop %ecx
-	pop %eax
-	ret
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/xen-asm_32.S
@@ -0,0 +1,305 @@
+/*
+	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
+	The inline versions are the same as the direct-use versions, with the
+	pre- and post-amble chopped off.
+
+	This code is encoded for size rather than absolute efficiency,
+	with a view to being able to inline as much as possible.
+
+	We only bother with direct forms (ie, vcpu in pda) of the operations
+	here; the indirect forms are better handled in C, since they're
+	generally too large to inline anyway.
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/percpu.h>
+#include <asm/processor-flags.h>
+#include <asm/segment.h>
+
+#include <xen/interface/xen.h>
+
+#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
+#define ENDPATCH(x)	.globl x##_end; x##_end=.
+
+/* Pseudo-flag used for virtual NMI, which we don't implement yet */
+#define XEN_EFLAGS_NMI	0x80000000
+
+/*
+	Enable events.  This clears the event mask and tests the pending
+	event status with one and operation.  If there are pending
+	events, then enter the hypervisor to get them handled.
+ */
+ENTRY(xen_irq_enable_direct)
+	/* Unmask events */
+	movb $0, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* Test for pending */
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	jz 1f
+
+2:	call check_events
+1:
+ENDPATCH(xen_irq_enable_direct)
+	ret
+	ENDPROC(xen_irq_enable_direct)
+	RELOC(xen_irq_enable_direct, 2b+1)
+
+
+/*
+	Disabling events is simply a matter of making the event mask
+	non-zero.
+ */
+ENTRY(xen_irq_disable_direct)
+	movb $1, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+ENDPATCH(xen_irq_disable_direct)
+	ret
+	ENDPROC(xen_irq_disable_direct)
+	RELOC(xen_irq_disable_direct, 0)
+
+/*
+	(xen_)save_fl is used to get the current interrupt enable status.
+	Callers expect the status to be in X86_EFLAGS_IF, and other bits
+	may be set in the return value.  We take advantage of this by
+	making sure that X86_EFLAGS_IF has the right value (and other bits
+	in that byte are 0), but other bits in the return value are
+	undefined.  We need to toggle the state of the bit, because
+	Xen and x86 use opposite senses (mask vs enable).
+ */
+ENTRY(xen_save_fl_direct)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+	setz %ah
+	addb %ah,%ah
+ENDPATCH(xen_save_fl_direct)
+	ret
+	ENDPROC(xen_save_fl_direct)
+	RELOC(xen_save_fl_direct, 0)
+
+
+/*
+	In principle the caller should be passing us a value return
+	from xen_save_fl_direct, but for robustness sake we test only
+	the X86_EFLAGS_IF flag rather than the whole byte. After
+	setting the interrupt mask state, it checks for unmasked
+	pending events and enters the hypervisor to get them delivered
+	if so.
+ */
+ENTRY(xen_restore_fl_direct)
+	testb $X86_EFLAGS_IF>>8, %ah
+	setz PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* check for unmasked and pending */
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	jz 1f
+2:	call check_events
+1:
+ENDPATCH(xen_restore_fl_direct)
+	ret
+	ENDPROC(xen_restore_fl_direct)
+	RELOC(xen_restore_fl_direct, 2b+1)
+
+/*
+	We can't use sysexit directly, because we're not running in ring0.
+	But we can easily fake it up using iret.  Assuming xen_sysexit
+	is jumped to with a standard stack frame, we can just strip it
+	back to a standard iret frame and use iret.
+ */
+ENTRY(xen_sysexit)
+	movl PT_EAX(%esp), %eax			/* Shouldn't be necessary? */
+	orl $X86_EFLAGS_IF, PT_EFLAGS(%esp)
+	lea PT_EIP(%esp), %esp
+
+	jmp xen_iret
+ENDPROC(xen_sysexit)
+
+/*
+	This is run where a normal iret would be run, with the same stack setup:
+	      8: eflags
+	      4: cs
+	esp-> 0: eip
+
+	This attempts to make sure that any pending events are dealt
+	with on return to usermode, but there is a small window in
+	which an event can happen just before entering usermode.  If
+	the nested interrupt ends up setting one of the TIF_WORK_MASK
+	pending work flags, they will not be tested again before
+	returning to usermode. This means that a process can end up
+	with pending work, which will be unprocessed until the process
+	enters and leaves the kernel again, which could be an
+	unbounded amount of time.  This means that a pending signal or
+	reschedule event could be indefinitely delayed.
+
+	The fix is to notice a nested interrupt in the critical
+	window, and if one occurs, then fold the nested interrupt into
+	the current interrupt stack frame, and re-process it
+	iteratively rather than recursively.  This means that it will
+	exit via the normal path, and all pending work will be dealt
+	with appropriately.
+
+	Because the nested interrupt handler needs to deal with the
+	current stack state in whatever form its in, we keep things
+	simple by only using a single register which is pushed/popped
+	on the stack.
+ */
+ENTRY(xen_iret)
+	/* test eflags for special cases */
+	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
+	jnz hyper_iret
+
+	push %eax
+	ESP_OFFSET=4	# bytes pushed onto stack
+
+	/* Store vcpu_info pointer for easy access.  Do it this
+	   way to avoid having to reload %fs */
+#ifdef CONFIG_SMP
+	GET_THREAD_INFO(%eax)
+	movl TI_cpu(%eax),%eax
+	movl __per_cpu_offset(,%eax,4),%eax
+	mov per_cpu__xen_vcpu(%eax),%eax
+#else
+	movl per_cpu__xen_vcpu, %eax
+#endif
+
+	/* check IF state we're restoring */
+	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
+
+	/* Maybe enable events.  Once this happens we could get a
+	   recursive event, so the critical region starts immediately
+	   afterwards.  However, if that happens we don't end up
+	   resuming the code, so we don't have to be worried about
+	   being preempted to another CPU. */
+	setz XEN_vcpu_info_mask(%eax)
+xen_iret_start_crit:
+
+	/* check for unmasked and pending */
+	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
+
+	/* If there's something pending, mask events again so we
+	   can jump back into xen_hypervisor_callback */
+	sete XEN_vcpu_info_mask(%eax)
+
+	popl %eax
+
+	/* From this point on the registers are restored and the stack
+	   updated, so we don't need to worry about it if we're preempted */
+iret_restore_end:
+
+	/* Jump to hypervisor_callback after fixing up the stack.
+	   Events are masked, so jumping out of the critical
+	   region is OK. */
+	je xen_hypervisor_callback
+
+1:	iret
+xen_iret_end_crit:
+.section __ex_table,"a"
+	.align 4
+	.long 1b,iret_exc
+.previous
+
+hyper_iret:
+	/* put this out of line since its very rarely used */
+	jmp hypercall_page + __HYPERVISOR_iret * 32
+
+	.globl xen_iret_start_crit, xen_iret_end_crit
+
+/*
+   This is called by xen_hypervisor_callback in entry.S when it sees
+   that the EIP at the time of interrupt was between xen_iret_start_crit
+   and xen_iret_end_crit.  We're passed the EIP in %eax so we can do
+   a more refined determination of what to do.
+
+   The stack format at this point is:
+	----------------
+	 ss		: (ss/esp may be present if we came from usermode)
+	 esp		:
+	 eflags		}  outer exception info
+	 cs		}
+	 eip		}
+	---------------- <- edi (copy dest)
+	 eax		:  outer eax if it hasn't been restored
+	----------------
+	 eflags		}  nested exception info
+	 cs		}   (no ss/esp because we're nested
+	 eip		}    from the same ring)
+	 orig_eax	}<- esi (copy src)
+	 - - - - - - - -
+	 fs		}
+	 es		}
+	 ds		}  SAVE_ALL state
+	 eax		}
+	  :		:
+	 ebx		}<- esp
+	----------------
+
+   In order to deliver the nested exception properly, we need to shift
+   everything from the return addr up to the error code so it
+   sits just under the outer exception info.  This means that when we
+   handle the exception, we do it in the context of the outer exception
+   rather than starting a new one.
+
+   The only caveat is that if the outer eax hasn't been
+   restored yet (ie, it's still on stack), we need to insert
+   its value into the SAVE_ALL state before going on, since
+   it's usermode state which we eventually need to restore.
+ */
+ENTRY(xen_iret_crit_fixup)
+	/*
+	   Paranoia: Make sure we're really coming from kernel space.
+	   One could imagine a case where userspace jumps into the
+	   critical range address, but just before the CPU delivers a GP,
+	   it decides to deliver an interrupt instead.  Unlikely?
+	   Definitely.  Easy to avoid?  Yes.  The Intel documents
+	   explicitly say that the reported EIP for a bad jump is the
+	   jump instruction itself, not the destination, but some virtual
+	   environments get this wrong.
+	 */
+	movl PT_CS(%esp), %ecx
+	andl $SEGMENT_RPL_MASK, %ecx
+	cmpl $USER_RPL, %ecx
+	je 2f
+
+	lea PT_ORIG_EAX(%esp), %esi
+	lea PT_EFLAGS(%esp), %edi
+
+	/* If eip is before iret_restore_end then stack
+	   hasn't been restored yet. */
+	cmp $iret_restore_end, %eax
+	jae 1f
+
+	movl 0+4(%edi),%eax		/* copy EAX (just above top of frame) */
+	movl %eax, PT_EAX(%esp)
+
+	lea ESP_OFFSET(%edi),%edi	/* move dest up over saved regs */
+
+	/* set up the copy */
+1:	std
+	mov $PT_EIP / 4, %ecx		/* saved regs up to orig_eax */
+	rep movsl
+	cld
+
+	lea 4(%edi),%esp		/* point esp to new frame */
+2:	jmp xen_do_upcall
+
+
+/*
+	Force an event check by making a hypercall,
+	but preserve regs before making the call.
+ */
+check_events:
+	push %eax
+	push %ecx
+	push %edx
+	call force_evtchn_callback
+	pop %edx
+	pop %ecx
+	pop %eax
+	ret
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/xen-asm_64.S
@@ -0,0 +1,141 @@
+/*
+	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
+	The inline versions are the same as the direct-use versions, with the
+	pre- and post-amble chopped off.
+
+	This code is encoded for size rather than absolute efficiency,
+	with a view to being able to inline as much as possible.
+
+	We only bother with direct forms (ie, vcpu in pda) of the operations
+	here; the indirect forms are better handled in C, since they're
+	generally too large to inline anyway.
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/asm-offsets.h>
+#include <asm/processor-flags.h>
+
+#include <xen/interface/xen.h>
+
+#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
+#define ENDPATCH(x)	.globl x##_end; x##_end=.
+
+/* Pseudo-flag used for virtual NMI, which we don't implement yet */
+#define XEN_EFLAGS_NMI	0x80000000
+
+#if 0
+#include <asm/percpu.h>
+
+/*
+	Enable events.  This clears the event mask and tests the pending
+	event status with one and operation.  If there are pending
+	events, then enter the hypervisor to get them handled.
+ */
+ENTRY(xen_irq_enable_direct)
+	/* Unmask events */
+	movb $0, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* Test for pending */
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_pending)
+	jz 1f
+
+2:	call check_events
+1:
+ENDPATCH(xen_irq_enable_direct)
+	ret
+	ENDPROC(xen_irq_enable_direct)
+	RELOC(xen_irq_enable_direct, 2b+1)
+
+/*
+	Disabling events is simply a matter of making the event mask
+	non-zero.
+ */
+ENTRY(xen_irq_disable_direct)
+	movb $1, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+ENDPATCH(xen_irq_disable_direct)
+	ret
+	ENDPROC(xen_irq_disable_direct)
+	RELOC(xen_irq_disable_direct, 0)
+
+/*
+	(xen_)save_fl is used to get the current interrupt enable status.
+	Callers expect the status to be in X86_EFLAGS_IF, and other bits
+	may be set in the return value.  We take advantage of this by
+	making sure that X86_EFLAGS_IF has the right value (and other bits
+	in that byte are 0), but other bits in the return value are
+	undefined.  We need to toggle the state of the bit, because
+	Xen and x86 use opposite senses (mask vs enable).
+ */
+ENTRY(xen_save_fl_direct)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	setz %ah
+	addb %ah,%ah
+ENDPATCH(xen_save_fl_direct)
+	ret
+	ENDPROC(xen_save_fl_direct)
+	RELOC(xen_save_fl_direct, 0)
+
+/*
+	In principle the caller should be passing us a value return
+	from xen_save_fl_direct, but for robustness sake we test only
+	the X86_EFLAGS_IF flag rather than the whole byte. After
+	setting the interrupt mask state, it checks for unmasked
+	pending events and enters the hypervisor to get them delivered
+	if so.
+ */
+ENTRY(xen_restore_fl_direct)
+	testb $X86_EFLAGS_IF>>8, %ah
+	setz PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* check for unmasked and pending */
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_pending)
+	jz 1f
+2:	call check_events
+1:
+ENDPATCH(xen_restore_fl_direct)
+	ret
+	ENDPROC(xen_restore_fl_direct)
+	RELOC(xen_restore_fl_direct, 2b+1)
+
+
+/*
+	Force an event check by making a hypercall,
+	but preserve regs before making the call.
+ */
+check_events:
+	push %rax
+	push %rcx
+	push %rdx
+	push %rsi
+	push %rdi
+	push %r8
+	push %r9
+	push %r10
+	push %r11
+	call force_evtchn_callback
+	pop %r11
+	pop %r10
+	pop %r9
+	pop %r8
+	pop %rdi
+	pop %rsi
+	pop %rdx
+	pop %rcx
+	pop %rax
+	ret
+#endif
+
+ENTRY(xen_iret)
+	pushq $0
+	jmp hypercall_page + __HYPERVISOR_iret * 32
+
+ENTRY(xen_sysexit)
+	ud2a


