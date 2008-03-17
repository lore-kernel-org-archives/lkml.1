Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYCRF0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYCRF0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYCRFYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:15 -0400
Received: from gw.goop.org ([64.81.55.164]:37845 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbYCRFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 26 of 31] xen: support sysenter/sysexit if hypervisor does
X-Mercurial-Node: 0d8fccf8ab611b9f9b914a3e332dea50ab288daf
Message-Id: <0d8fccf8ab611b9f9b91.1205797037@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit Xen supports sysenter for 32-bit guests, so support its
use.  (sysenter is faster than int $0x80 in 32-on-64.)

sysexit is still not supported, so we fake it up using iret.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_32.S |   18 +++++++++++++-
 arch/x86/xen/enlighten.c   |    3 --
 arch/x86/xen/setup.c       |   21 ++++++++++++++++
 arch/x86/xen/smp.c         |    1
 arch/x86/xen/xen-asm.S     |   56 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h     |    3 ++
 6 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1024,6 +1024,13 @@
 ENDPROC(kernel_thread_helper)
 
 #ifdef CONFIG_XEN
+/* Xen doesn't set %esp to be precisely what the normal sysenter
+   entrypoint expects, so fix it up before using the normal path. */
+ENTRY(xen_sysenter_target)
+	RING0_INT_FRAME
+	addl $5*4, %esp		/* remove xen-provided frame */
+	jmp sysenter_past_esp
+
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC
 	pushl $0
@@ -1043,8 +1050,17 @@
 	jae  1f
 
 	call xen_iret_crit_fixup
+	jmp  2f
 
-1:	mov %esp, %eax
+1:	cmpl $xen_sysexit_start_crit,%eax
+	jb   2f
+	cmpl $xen_sysexit_end_crit,%eax
+	jae  2f
+
+	jmp xen_sysexit_crit_fixup
+
+ENTRY(xen_do_upcall)
+2:	mov %esp, %eax
 	call xen_evtchn_do_upcall
 	jmp  ret_from_intr
 	CFI_ENDPROC
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -155,7 +155,6 @@
 	if (*ax == 1)
 		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
 			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
-			    (1 << X86_FEATURE_SEP)  |  /* disable SEP */
 			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
@@ -981,7 +980,7 @@
 	.read_pmc = native_read_pmc,
 
 	.iret = xen_iret,
-	.irq_enable_syscall_ret = NULL,  /* never called */
+	.irq_enable_syscall_ret = xen_sysexit,
 
 	.load_tr_desc = paravirt_nop,
 	.set_ldt = xen_set_ldt,
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -16,6 +16,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
+#include <xen/interface/callback.h>
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
 
@@ -68,6 +69,24 @@
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 }
 
+void xen_enable_sysenter(void)
+{
+	int cpu = smp_processor_id();
+	extern void xen_sysenter_target(void);
+	/* Mask events on entry, even though they get enabled immediately */
+	static struct callback_register sysenter = {
+		.type = CALLBACKTYPE_sysenter,
+		.address = { __KERNEL_CS, (unsigned long)xen_sysenter_target },
+		.flags = CALLBACKF_mask_events,
+	};
+
+	if (!boot_cpu_has(X86_FEATURE_SEP) ||
+	    HYPERVISOR_callback_op(CALLBACKOP_register, &sysenter) != 0) {
+		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SEP);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
+	}
+}
+
 void __init xen_arch_setup(void)
 {
 	struct physdev_set_iopl set_iopl;
@@ -81,6 +100,8 @@
 
 	HYPERVISOR_set_callbacks(__KERNEL_CS, (unsigned long)xen_hypervisor_callback,
 				 __KERNEL_CS, (unsigned long)xen_failsafe_callback);
+
+	xen_enable_sysenter();
 
 	set_iopl.iopl = 1;
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -72,6 +72,7 @@
 	int cpu = smp_processor_id();
 
 	cpu_init();
+	xen_enable_sysenter();
 
 	preempt_disable();
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -280,6 +280,62 @@
 2:	ret
 
 
+ENTRY(xen_sysexit)
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
+	/* We can't actually use sysexit in a pv guest,
+	   so fake it up with iret */
+	pushl $__USER_DS		/* user stack segment */
+	pushl %ecx			/* user esp */
+	pushl PT_EFLAGS+2*4(%esp)	/* user eflags */
+	pushl $__USER_CS		/* user code segment */
+	pushl %edx			/* user eip */
+
+xen_sysexit_start_crit:
+	/* Unmask events... */
+	movb $0, XEN_vcpu_info_mask(%eax)
+	/* ...and test for pending.
+	   There's a preempt window here, but it doesn't
+	   matter because we're within the critical section. */
+	testb $0xff, XEN_vcpu_info_pending(%eax)
+
+	/* If there's something pending, mask events again so we
+	   can directly inject it back into the kernel. */
+	jnz   1f
+
+	movl PT_EAX+5*4(%esp),%eax
+2:	iret
+1:	movb $1, XEN_vcpu_info_mask(%eax)
+xen_sysexit_end_crit:
+	addl $5*4, %esp		/* remove iret frame */
+	/* no need to re-save regs, but need to restore kernel %fs */
+	mov $__KERNEL_PERCPU, %eax
+	mov %eax, %fs
+	jmp xen_do_upcall
+.section __ex_table,"a"
+	.align 4
+	.long 2b,iret_exc
+.previous
+
+	.globl xen_sysexit_start_crit, xen_sysexit_end_crit
+/*
+	sysexit fixup is easy, since the old frame is still sitting there
+	on the stack.  We just need to remove the new recursive
+	interrupt and return.
+ */
+ENTRY(xen_sysexit_crit_fixup)
+	addl $PT_OLDESP+5*4, %esp		/* remove frame+iret */
+	jmp xen_do_upcall
+
 /*
 	Force an event check by making a hypercall,
 	but preserve regs before making the call.
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -19,6 +19,7 @@
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);
+void xen_enable_sysenter(void);
 
 void xen_setup_timer(int cpu);
 void xen_setup_cpu_clockevents(void);
@@ -64,4 +65,6 @@
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
 void xen_iret(void);
+void xen_sysexit(void);
+
 #endif /* XEN_OPS_H */


