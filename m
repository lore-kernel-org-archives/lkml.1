Return-Path: <linux-kernel-owner+w=401wt.eu-S936160AbXEVPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936160AbXEVPaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934890AbXEVPTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:50 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:5013
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965786AbXEVPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:17 -0400
Message-Id: <20070522141253.803995823@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:10:14 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir@xensource.com>
Subject: [patch 33/33] xen: Attempt to patch inline versions of common operations
Content-Disposition: inline; filename=xen-patch-inline.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the mechanism to allow us to patch inline versions of
common operations.

The implementations of the direct-access versions save_fl, restore_fl,
irq_enable and irq_disable are now in assembler, and the same code is
used for both out of line and inline uses.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Keir Fraser <keir@xensource.com>
---
 arch/i386/kernel/asm-offsets.c |    7 ++
 arch/i386/xen/Makefile         |    2 
 arch/i386/xen/enlighten.c      |  108 +++++++++++++++++++------------------
 arch/i386/xen/xen-asm.S        |  114 ++++++++++++++++++++++++++++++++++++++++
 arch/i386/xen/xen-ops.h        |   13 ++++
 5 files changed, 190 insertions(+), 54 deletions(-)

===================================================================
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -16,6 +16,7 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/elf.h>
+#include <xen/interface/xen.h>
 #ifdef CONFIG_LGUEST_GUEST
 #include <linux/lguest.h>
 #include "../../../drivers/lguest/lg.h"
@@ -134,4 +135,10 @@ void foo(void)
 	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
 	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
 #endif
+
+#ifdef CONFIG_XEN
+	BLANK();
+	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
+	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
+#endif
 }
===================================================================
--- a/arch/i386/xen/Makefile
+++ b/arch/i386/xen/Makefile
@@ -1,4 +1,4 @@ obj-y		:= enlighten.o setup.o features.o
 obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
-			events.o time.o manage.o
+			events.o time.o manage.o xen-asm.o
 
 obj-$(CONFIG_SMP)	+= smp.o
===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -107,9 +107,11 @@ void xen_vcpu_setup(int cpu)
 	if (err == 0) {
 		have_vcpu_info_placement = 1;
 		per_cpu(xen_vcpu, cpu) = vcpup;
+
 		printk("cpu %d using vcpu_info at %p\n",
 		       cpu, vcpup);
 	}
+
 }
 
 static void __init xen_banner(void)
@@ -169,20 +171,6 @@ static unsigned long xen_save_fl(void)
 	return (-flags) & X86_EFLAGS_IF;
 }
 
-static unsigned long xen_save_fl_direct(void)
-{
-	unsigned long flags;
-
-	/* flag has opposite sense of mask */
-	flags = !x86_read_percpu(xen_vcpu_info.evtchn_upcall_mask);
-
-	/* convert to IF type flag
-	   -0 -> 0x00000000
-	   -1 -> 0xffffffff
-	*/
-	return (-flags) & X86_EFLAGS_IF;
-}
-
 static void xen_restore_fl(unsigned long flags)
 {
 	struct vcpu_info *vcpu;
@@ -209,25 +197,6 @@ static void xen_restore_fl(unsigned long
 	}
 }
 
-static void xen_restore_fl_direct(unsigned long flags)
-{
-	/* convert from IF type flag */
-	flags = !(flags & X86_EFLAGS_IF);
-
-	/* This is an atomic update, so no need to worry about
-	   preemption. */
-	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, flags);
-
-	/* If we get preempted here, then any pending event will be
-	   handled anyway. */
-
-	if (flags == 0) {
-		barrier(); /* unmask then check (avoid races) */
-		if (unlikely(x86_read_percpu(xen_vcpu_info.evtchn_upcall_pending)))
-			force_evtchn_callback();
-	}
-}
-
 static void xen_irq_disable(void)
 {
 	/* There's a one instruction preempt window here.  We need to
@@ -236,12 +205,6 @@ static void xen_irq_disable(void)
 	preempt_disable();
 	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
 	preempt_enable_no_resched();
-}
-
-static void xen_irq_disable_direct(void)
-{
-	/* Atomic update, so preemption not a concern. */
-	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, 1);
 }
 
 static void xen_irq_enable(void)
@@ -261,19 +224,6 @@ static void xen_irq_enable(void)
 
 	barrier(); /* unmask then check (avoid races) */
 	if (unlikely(vcpu->evtchn_upcall_pending))
-		force_evtchn_callback();
-}
-
-static void xen_irq_enable_direct(void)
-{
-	/* Atomic update, so preemption not a concern. */
-	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, 0);
-
-	/* Doesn't matter if we get preempted here, because any
-	   pending event will get dealt with anyway. */
-
-	barrier(); /* unmask then check (avoid races) */
-	if (unlikely(x86_read_percpu(xen_vcpu_info.evtchn_upcall_pending)))
 		force_evtchn_callback();
 }
 
@@ -850,6 +800,57 @@ static __init void xen_pagetable_setup_d
 	xen_vcpu_setup(smp_processor_id());
 }
 
+static unsigned xen_patch(u8 type, u16 clobbers, void *insns, unsigned len)
+{
+	char *start, *end, *reloc;
+	unsigned ret;
+
+	start = end = reloc = NULL;
+
+#define SITE(x)								\
+	case PARAVIRT_PATCH(x):						\
+	if (have_vcpu_info_placement) {					\
+		start = (char *)xen_##x##_direct;			\
+		end = xen_##x##_direct_end;				\
+		reloc = xen_##x##_direct_reloc;				\
+	}								\
+	goto patch_site
+
+	switch(type) {
+		SITE(irq_enable);
+		SITE(irq_disable);
+		SITE(save_fl);
+		SITE(restore_fl);
+#undef SITE
+
+	patch_site:
+		if (start == NULL || (end-start) > len)
+			goto default_patch;
+
+		ret = paravirt_patch_insns(insns, len, start, end);
+
+		/* Note: because reloc is assigned from something that
+		   appears to be an array, gcc assumes it's non-null,
+		   but doesn't know its relationship with start and
+		   end. */
+		if (reloc > start && reloc < end) {
+			int reloc_off = reloc - start;
+			long *relocp = (long *)(insns + reloc_off);
+			long delta = start - (char *)insns;
+
+			*relocp += delta;
+		}
+		break;
+
+	default_patch:
+	default:
+		ret = paravirt_patch_default(type, clobbers, insns, len);
+		break;
+	}
+
+	return ret;
+}
+
 static const struct paravirt_ops xen_paravirt_ops __initdata = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
@@ -857,7 +858,7 @@ static const struct paravirt_ops xen_par
 	.name = "Xen",
 	.banner = xen_banner,
 
-	.patch = paravirt_patch_default,
+	.patch = xen_patch,
 
 	.memory_setup = xen_memory_setup,
 	.arch_setup = xen_arch_setup,
@@ -1033,6 +1034,7 @@ static const struct machine_ops __initda
 	.crash_shutdown = xen_crash_shutdown,
 	.emergency_restart = xen_emergency_restart,
 };
+
 
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
===================================================================
--- /dev/null
+++ b/arch/i386/xen/xen-asm.S
@@ -0,0 +1,114 @@
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
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/percpu.h>
+#include <asm/asm-offsets.h>
+#include <asm/processor-flags.h>
+
+#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
+#define ENDPATCH(x)	.globl x##_end; x##_end=.
+
+/*
+	Enable events.  This clears the event mask and tests the pending
+	event status with one and operation.  If there are pending
+	events, then enter the hypervisor to get them handled.
+ */
+ENTRY(xen_irq_enable_direct)
+	/* Clear mask and test pending */
+	andw $0x00ff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+	jz 1f
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
+	setz %al
+	movb %al, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* check for pending but unmasked */
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	jz 1f
+2:	call check_events
+1:
+ENDPATCH(xen_restore_fl_direct)
+	ret
+	ENDPROC(xen_restore_fl_direct)
+	RELOC(xen_restore_fl_direct, 2b+1)
+
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
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -55,4 +55,17 @@ int xen_smp_call_function_mask(cpumask_t
 int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 			       void *info, int wait);
 
+
+/* Declare an asm function, along with symbols needed to make it
+   inlineable */
+#define DECL_ASM(ret, name, ...)		\
+	ret name(__VA_ARGS__);			\
+	extern char name##_end[];		\
+	extern char name##_reloc[]		\
+
+DECL_ASM(void, xen_irq_enable_direct, void);
+DECL_ASM(void, xen_irq_disable_direct, void);
+DECL_ASM(unsigned long, xen_save_fl_direct, void);
+DECL_ASM(void, xen_restore_fl_direct, unsigned long);
+
 #endif /* XEN_OPS_H */

-- 

