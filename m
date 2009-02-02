Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZBBV4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZBBV4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbZBBVzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:55:53 -0500
Received: from gw.goop.org ([64.81.55.164]:42422 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776AbZBBVzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:55:51 -0500
Message-ID: <49876BDE.1060603@goop.org>
Date: Mon, 02 Feb 2009 13:55:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 2/3] xen: make direct versions of irq_enable/disable/save/restore
 to common code
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that x86-64 has directly accessible percpu variables, it can also
implement the direct versions of these operations, which operate on a
vcpu_info structure directly embedded in the percpu area.

In fact, the 64-bit versions are more or less identical, and so can be
shared.  The only two differences are:
 1. xen_restore_fl_direct takes its argument in eax on 32-bit, and rdi on 64-bit.
    Unfortunately it isn't possible to directly refer to the 2nd lsb of rdi directly
    (as you can with %ah), so the code isn't quite as dense.
 2. check_events needs to variants to save different registers.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile     |    3 
 arch/x86/xen/xen-asm.S    |  140 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-asm.h    |   12 +++
 arch/x86/xen/xen-asm_32.S |  113 ++++--------------------------------
 arch/x86/xen/xen-asm_64.S |  136 +------------------------------------------
 5 files changed, 171 insertions(+), 233 deletions(-)

===================================================================
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -6,7 +6,8 @@
 endif
 
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
-			time.o xen-asm_$(BITS).o grant-table.o suspend.o
+			time.o xen-asm.o xen-asm_$(BITS).o \
+			grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
===================================================================
--- /dev/null
+++ b/arch/x86/xen/xen-asm.S
@@ -0,0 +1,140 @@
+/*
+	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
+	The inline versions are the same as the direct-use versions, with the
+	pre- and post-amble chopped off.
+
+	This code is encoded for size rather than absolute efficiency,
+	with a view to being able to inline as much as possible.
+
+	We only bother with direct forms (ie, vcpu in percpu data) of
+	the operations here; the indirect forms are better handled in
+	C, since they're generally too large to inline anyway.
+ */
+
+#include <asm/asm-offsets.h>
+#include <asm/percpu.h>
+#include <asm/processor-flags.h>
+
+#include "xen-asm.h"
+
+/*
+	Enable events.  This clears the event mask and tests the pending
+	event status with one and operation.  If there are pending
+	events, then enter the hypervisor to get them handled.
+ */
+ENTRY(xen_irq_enable_direct)
+	/* Unmask events */
+	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* Test for pending */
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
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
+	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
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
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
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
+#ifdef CONFIG_X86_64
+	testw $X86_EFLAGS_IF, %di
+#else
+	testb $X86_EFLAGS_IF>>8, %ah
+#endif
+	setz PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* check for unmasked and pending */
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
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
+#ifdef CONFIG_X86_32
+	push %eax
+	push %ecx
+	push %edx
+	call xen_force_evtchn_callback
+	pop %edx
+	pop %ecx
+	pop %eax
+#else
+	push %rax
+	push %rcx
+	push %rdx
+	push %rsi
+	push %rdi
+	push %r8
+	push %r9
+	push %r10
+	push %r11
+	call xen_force_evtchn_callback
+	pop %r11
+	pop %r10
+	pop %r9
+	pop %r8
+	pop %rdi
+	pop %rsi
+	pop %rdx
+	pop %rcx
+	pop %rax
+#endif
+	ret
+
===================================================================
--- /dev/null
+++ b/arch/x86/xen/xen-asm.h
@@ -0,0 +1,12 @@
+#ifndef _XEN_XEN_ASM_H
+#define _XEN_XEN_ASM_H
+
+#include <linux/linkage.h>
+
+#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
+#define ENDPATCH(x)	.globl x##_end; x##_end=.
+
+/* Pseudo-flag used for virtual NMI, which we don't implement yet */
+#define XEN_EFLAGS_NMI	0x80000000
+
+#endif
===================================================================
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -11,101 +11,28 @@
 	generally too large to inline anyway.
  */
 
-#include <linux/linkage.h>
-
-#include <asm/asm-offsets.h>
+//#include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
-#include <asm/percpu.h>
 #include <asm/processor-flags.h>
 #include <asm/segment.h>
 
 #include <xen/interface/xen.h>
 
-#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
-#define ENDPATCH(x)	.globl x##_end; x##_end=.
-
-/* Pseudo-flag used for virtual NMI, which we don't implement yet */
-#define XEN_EFLAGS_NMI	0x80000000
-
+#include "xen-asm.h"
+
 /*
-	Enable events.  This clears the event mask and tests the pending
-	event status with one and operation.  If there are pending
-	events, then enter the hypervisor to get them handled.
+	Force an event check by making a hypercall,
+	but preserve regs before making the call.
  */
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
+check_events:
+	push %eax
+	push %ecx
+	push %edx
+	call xen_force_evtchn_callback
+	pop %edx
+	pop %ecx
+	pop %eax
 	ret
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
 
 /*
 	We can't use sysexit directly, because we're not running in ring0.
@@ -289,17 +216,3 @@
 	lea 4(%edi),%esp		/* point esp to new frame */
 2:	jmp xen_do_upcall
 
-
-/*
-	Force an event check by making a hypercall,
-	but preserve regs before making the call.
- */
-check_events:
-	push %eax
-	push %ecx
-	push %edx
-	call xen_force_evtchn_callback
-	pop %edx
-	pop %ecx
-	pop %eax
-	ret
===================================================================
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -11,143 +11,15 @@
 	generally too large to inline anyway.
  */
 
-#include <linux/linkage.h>
-
-#include <asm/asm-offsets.h>
+#include <asm/errno.h>
+#include <asm/percpu.h>
 #include <asm/processor-flags.h>
-#include <asm/errno.h>
 #include <asm/segment.h>
-#include <asm/percpu.h>
 
 #include <xen/interface/xen.h>
 
-#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
-#define ENDPATCH(x)	.globl x##_end; x##_end=.
-
-/* Pseudo-flag used for virtual NMI, which we don't implement yet */
-#define XEN_EFLAGS_NMI	0x80000000
-
-#if 1
-/*
-	FIXME: x86_64 now can support direct access to percpu variables
-	via a segment override.  Update xen accordingly.
- */
-#define BUG			ud2a
-#endif
-
-/*
-	Enable events.  This clears the event mask and tests the pending
-	event status with one and operation.  If there are pending
-	events, then enter the hypervisor to get them handled.
- */
-ENTRY(xen_irq_enable_direct)
-	BUG
-
-	/* Unmask events */
-	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
-
-	/* Preempt here doesn't matter because that will deal with
-	   any pending interrupts.  The pending check may end up being
-	   run on the wrong CPU, but that doesn't hurt. */
-
-	/* Test for pending */
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
-	jz 1f
-
-2:	call check_events
-1:
-ENDPATCH(xen_irq_enable_direct)
-	ret
-	ENDPROC(xen_irq_enable_direct)
-	RELOC(xen_irq_enable_direct, 2b+1)
-
-/*
-	Disabling events is simply a matter of making the event mask
-	non-zero.
- */
-ENTRY(xen_irq_disable_direct)
-	BUG
-
-	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
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
-	BUG
-
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
-	setz %ah
-	addb %ah,%ah
-ENDPATCH(xen_save_fl_direct)
-	ret
-	ENDPROC(xen_save_fl_direct)
-	RELOC(xen_save_fl_direct, 0)
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
-	BUG
-
-	testb $X86_EFLAGS_IF>>8, %ah
-	setz PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
-	/* Preempt here doesn't matter because that will deal with
-	   any pending interrupts.  The pending check may end up being
-	   run on the wrong CPU, but that doesn't hurt. */
-
-	/* check for unmasked and pending */
-	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
-	jz 1f
-2:	call check_events
-1:
-ENDPATCH(xen_restore_fl_direct)
-	ret
-	ENDPROC(xen_restore_fl_direct)
-	RELOC(xen_restore_fl_direct, 2b+1)
-
-
-/*
-	Force an event check by making a hypercall,
-	but preserve regs before making the call.
- */
-check_events:
-	push %rax
-	push %rcx
-	push %rdx
-	push %rsi
-	push %rdi
-	push %r8
-	push %r9
-	push %r10
-	push %r11
-	call xen_force_evtchn_callback
-	pop %r11
-	pop %r10
-	pop %r9
-	pop %r8
-	pop %rdi
-	pop %rsi
-	pop %rdx
-	pop %rcx
-	pop %rax
-	ret
-
+#include "xen-asm.h"
+
 ENTRY(xen_adjust_exception_frame)
 	mov 8+0(%rsp),%rcx
 	mov 8+8(%rsp),%r11


