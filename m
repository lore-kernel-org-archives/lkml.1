Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbYGHX2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbYGHX2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbYGHXPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:12 -0400
Received: from gw.goop.org ([64.81.55.164]:51220 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbYGHXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 52 of 55] xen64: set up syscall and sysenter entrypoints for
	64-bit
X-Mercurial-Node: cbecd5041ab1ad7111f75189c54fb13d8216c16a
Message-Id: <cbecd5041ab1ad7111f7.1215554834@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We set up entrypoints for syscall and sysenter.  sysenter is only used
for 32-bit compat processes, whereas syscall can be used in by both 32
and 64-bit processes.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c  |    4 +
 arch/x86/xen/setup.c      |   42 +++++++++++++-
 arch/x86/xen/smp.c        |    1
 arch/x86/xen/xen-asm_64.S |  131 +++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/xen/xen-ops.h    |    3 +
 5 files changed, 175 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1139,6 +1139,10 @@
 
 	.iret = xen_iret,
 	.irq_enable_sysexit = xen_sysexit,
+#ifdef CONFIG_X86_64
+	.usergs_sysret32 = xen_sysret32,
+	.usergs_sysret64 = xen_sysret64,
+#endif
 
 	.load_tr_desc = paravirt_nop,
 	.set_ldt = xen_set_ldt,
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -86,9 +86,11 @@
  */
 static void __init fiddle_vdso(void)
 {
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 	extern const char vdso32_default_start;
 	u32 *mask = VDSO32_SYMBOL(&vdso32_default_start, NOTE_MASK);
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
+#endif
 }
 
 static __cpuinit int register_callback(unsigned type, const void *func)
@@ -106,13 +108,46 @@
 {
 	int cpu = smp_processor_id();
 	extern void xen_sysenter_target(void);
+	int ret;
 
-	if (!boot_cpu_has(X86_FEATURE_SEP) ||
-	    register_callback(CALLBACKTYPE_sysenter,
-			      xen_sysenter_target) != 0) {
+#ifdef CONFIG_X86_32
+	if (!boot_cpu_has(X86_FEATURE_SEP)) {
+		return;
+	}
+#else
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL &&
+	    boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR) {
+		return;
+	}
+#endif
+
+	ret = register_callback(CALLBACKTYPE_sysenter, xen_sysenter_target);
+	if(ret != 0) {
 		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SEP);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
 	}
+}
+
+void __cpuinit xen_enable_syscall(void)
+{
+#ifdef CONFIG_X86_64
+	int cpu = smp_processor_id();
+	int ret;
+	extern void xen_syscall_target(void);
+	extern void xen_syscall32_target(void);
+
+	ret = register_callback(CALLBACKTYPE_syscall, xen_syscall_target);
+	if (ret != 0) {
+		printk("failed to set syscall: %d\n", ret);
+		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SYSCALL);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SYSCALL);
+	} else {
+		ret = register_callback(CALLBACKTYPE_syscall32,
+					xen_syscall32_target);
+		if (ret != 0)
+			printk("failed to set 32-bit syscall: %d\n", ret);
+	}
+#endif /* CONFIG_X86_64 */
 }
 
 void __init xen_arch_setup(void)
@@ -131,6 +166,7 @@
 		BUG();
 
 	xen_enable_sysenter();
+	xen_enable_syscall();
 
 	set_iopl.iopl = 1;
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -69,6 +69,7 @@
 	preempt_disable();
 
 	xen_enable_sysenter();
+	xen_enable_syscall();
 
 	cpu = smp_processor_id();
 	smp_store_cpu_info(cpu);
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -15,6 +15,8 @@
 
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/errno.h>
+#include <asm/segment.h>
 
 #include <xen/interface/xen.h>
 
@@ -138,9 +140,132 @@
 	mov 8+8(%rsp),%r11
 	ret $16
 
+hypercall_iret = hypercall_page + __HYPERVISOR_iret * 32
+/*
+	Xen64 iret frame:
+
+	ss
+	rsp
+	rflags
+	cs
+	rip		<-- standard iret frame
+
+	flags
+
+	rcx		}
+	r11		}<-- pushed by hypercall page
+rsp ->	rax		}
+ */
 ENTRY(xen_iret)
 	pushq $0
-	jmp hypercall_page + __HYPERVISOR_iret * 32
+1:	jmp hypercall_iret
+ENDPATCH(xen_iret)
+RELOC(xen_iret, 1b+1)
 
+/*
+	sysexit is not used for 64-bit processes, so it's
+	only ever used to return to 32-bit compat userspace.
+ */
 ENTRY(xen_sysexit)
-	ud2a
+	pushq $__USER32_DS
+	pushq %rcx
+	pushq $X86_EFLAGS_IF
+	pushq $__USER32_CS
+	pushq %rdx
+
+	pushq $VGCF_in_syscall
+1:	jmp hypercall_iret
+ENDPATCH(xen_sysexit)
+RELOC(xen_sysexit, 1b+1)
+
+ENTRY(xen_sysret64)
+	/* We're already on the usermode stack at this point, but still
+	   with the kernel gs, so we can easily switch back */
+	movq %rsp, %gs:pda_oldrsp
+	movq %gs:pda_kernelstack,%rsp
+
+	pushq $__USER_DS
+	pushq %gs:pda_oldrsp
+	pushq %r11
+	pushq $__USER_CS
+	pushq %rcx
+
+	pushq $VGCF_in_syscall
+1:	jmp hypercall_iret
+ENDPATCH(xen_sysret64)
+RELOC(xen_sysret64, 1b+1)
+
+ENTRY(xen_sysret32)
+	/* We're already on the usermode stack at this point, but still
+	   with the kernel gs, so we can easily switch back */
+	movq %rsp, %gs:pda_oldrsp
+	movq %gs:pda_kernelstack, %rsp
+
+	pushq $__USER32_DS
+	pushq %gs:pda_oldrsp
+	pushq %r11
+	pushq $__USER32_CS
+	pushq %rcx
+
+	pushq $VGCF_in_syscall
+1:	jmp hypercall_iret
+ENDPATCH(xen_sysret32)
+RELOC(xen_sysret32, 1b+1)
+
+/*
+	Xen handles syscall callbacks much like ordinary exceptions,
+	which means we have:
+	 - kernel gs
+	 - kernel rsp
+	 - an iret-like stack frame on the stack (including rcx and r11):
+		ss
+		rsp
+		rflags
+		cs
+		rip
+		r11
+	rsp->	rcx
+
+	In all the entrypoints, we undo all that to make it look
+	like a CPU-generated syscall/sysenter and jump to the normal
+	entrypoint.
+ */
+
+.macro undo_xen_syscall
+	mov 0*8(%rsp),%rcx
+	mov 1*8(%rsp),%r11
+	mov 5*8(%rsp),%rsp
+.endm
+
+/* Normal 64-bit system call target */
+ENTRY(xen_syscall_target)
+	undo_xen_syscall
+	jmp system_call_after_swapgs
+ENDPROC(xen_syscall_target)
+
+#ifdef CONFIG_IA32_EMULATION
+
+/* 32-bit compat syscall target */
+ENTRY(xen_syscall32_target)
+	undo_xen_syscall
+	jmp ia32_cstar_target
+ENDPROC(xen_syscall32_target)
+
+/* 32-bit compat sysenter target */
+ENTRY(xen_sysenter_target)
+	undo_xen_syscall
+	jmp ia32_sysenter_target
+ENDPROC(xen_sysenter_target)
+
+#else /* !CONFIG_IA32_EMULATION */
+
+ENTRY(xen_syscall32_target)
+ENTRY(xen_sysenter_target)
+	lea 16(%rsp), %rsp	/* strip %rcx,%r11 */
+	mov $-ENOSYS, %rax
+	pushq $VGCF_in_syscall
+	jmp hypercall_iret
+ENDPROC(xen_syscall32_target)
+ENDPROC(xen_sysenter_target)
+
+#endif	/* CONFIG_IA32_EMULATION */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -26,6 +26,7 @@
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);
 void xen_enable_sysenter(void);
+void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
@@ -70,6 +71,8 @@
 /* These are not functions, and cannot be called normally */
 void xen_iret(void);
 void xen_sysexit(void);
+void xen_sysret32(void);
+void xen_sysret64(void);
 void xen_adjust_exception_frame(void);
 
 #endif /* XEN_OPS_H */


