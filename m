Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbXJaWBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbXJaWBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbXJaV7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:59:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbXJaV7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:59:09 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/7] irqflags consolidation
Date: Wed, 31 Oct 2007 16:13:13 -0300
Message-Id: <11938580063444-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1193857999499-git-send-email-gcosta@redhat.com>
References: <1193857999499-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consolidates the irqflags include files containing common
paravirt definitions. The native definition for interrupt handling, halt,
and such, are the same for 32 and 64 bit, and they are kept in irqflags.h.
The differences are split in the arch-specific files.

The syscall function, irq_enable_sysexit, has a very specific i386 naming,
and its name is then changed to a more general one.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/asm-offsets_32.c |    2 +-
 arch/x86/kernel/entry_32.S       |    8 ++--
 arch/x86/kernel/paravirt_32.c    |   10 ++--
 arch/x86/kernel/vmi_32.c         |    4 +-
 arch/x86/xen/enlighten.c         |    2 +-
 include/asm-x86/irqflags.h       |  107 ++++++++++++++++++++++++++++++++++++
 include/asm-x86/irqflags_32.h    |  103 +----------------------------------
 include/asm-x86/irqflags_64.h    |  112 +++++++-------------------------------
 include/asm-x86/paravirt.h       |    9 ++--
 9 files changed, 147 insertions(+), 210 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 0e45981..c1ccfab 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -123,7 +123,7 @@ void foo(void)
 	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
-	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
+	OFFSET(PV_CPU_irq_enable_syscall_ret, pv_cpu_ops, irq_enable_syscall_ret);
 	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
 #endif
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dc7f938..d63609d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -58,7 +58,7 @@
  * for paravirtualization.  The following will never clobber any registers:
  *   INTERRUPT_RETURN (aka. "iret")
  *   GET_CR0_INTO_EAX (aka. "movl %cr0, %eax")
- *   ENABLE_INTERRUPTS_SYSEXIT (aka "sti; sysexit").
+ *   ENABLE_INTERRUPTS_SYSCALL_RET (aka "sti; sysexit").
  *
  * For DISABLE_INTERRUPTS/ENABLE_INTERRUPTS (aka "cli"/"sti"), you must
  * specify what registers can be overwritten (CLBR_NONE, CLBR_EAX/EDX/ECX/ANY).
@@ -351,7 +351,7 @@ sysenter_past_esp:
 	xorl %ebp,%ebp
 	TRACE_IRQS_ON
 1:	mov  PT_FS(%esp), %fs
-	ENABLE_INTERRUPTS_SYSEXIT
+	ENABLE_INTERRUPTS_SYSCALL_RET
 	CFI_ENDPROC
 .pushsection .fixup,"ax"
 2:	movl $0,PT_FS(%esp)
@@ -882,10 +882,10 @@ ENTRY(native_iret)
 .previous
 END(native_iret)
 
-ENTRY(native_irq_enable_sysexit)
+ENTRY(native_irq_enable_syscall_ret)
 	sti
 	sysexit
-END(native_irq_enable_sysexit)
+END(native_irq_enable_syscall_ret)
 #endif
 
 KPROBE_ENTRY(int3)
diff --git a/arch/x86/kernel/paravirt_32.c b/arch/x86/kernel/paravirt_32.c
index 6a80d67..04f51d0 100644
--- a/arch/x86/kernel/paravirt_32.c
+++ b/arch/x86/kernel/paravirt_32.c
@@ -60,7 +60,7 @@ DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
 DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
 DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
 DEF_NATIVE(pv_cpu_ops, iret, "iret");
-DEF_NATIVE(pv_cpu_ops, irq_enable_sysexit, "sti; sysexit");
+DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
 DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
 DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %cr3, %eax");
@@ -88,7 +88,7 @@ static unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
 	SITE(pv_irq_ops, restore_fl);
 	SITE(pv_irq_ops, save_fl);
 	SITE(pv_cpu_ops, iret);
-	SITE(pv_cpu_ops, irq_enable_sysexit);
+	SITE(pv_cpu_ops, irq_enable_syscall_ret);
 	SITE(pv_mmu_ops, read_cr2);
 	SITE(pv_mmu_ops, read_cr3);
 	SITE(pv_mmu_ops, write_cr3);
@@ -186,7 +186,7 @@ unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
 		/* If the operation is a nop, then nop the callsite */
 		ret = paravirt_patch_nop();
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
-		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit))
+		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret))
 		/* If operation requires a jmp, then jmp */
 		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
 	else
@@ -237,7 +237,7 @@ static void native_flush_tlb_single(unsigned long addr)
 
 /* These are in entry.S */
 extern void native_iret(void);
-extern void native_irq_enable_sysexit(void);
+extern void native_irq_enable_syscall_ret(void);
 
 static int __init print_banner(void)
 {
@@ -384,7 +384,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.write_idt_entry = write_dt_entry,
 	.load_esp0 = native_load_esp0,
 
-	.irq_enable_sysexit = native_irq_enable_sysexit,
+	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
 	.iret = native_iret,
 
 	.set_iopl_mask = native_set_iopl_mask,
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index f02bad6..aacce42 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -148,7 +148,7 @@ static unsigned vmi_patch(u8 type, u16 clobbers, void *insns,
 					      insns, eip);
 		case PARAVIRT_PATCH(pv_cpu_ops.iret):
 			return patch_internal(VMI_CALL_IRET, len, insns, eip);
-		case PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit):
+		case PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret):
 			return patch_internal(VMI_CALL_SYSEXIT, len, insns, eip);
 		default:
 			break;
@@ -870,7 +870,7 @@ static inline int __init activate_vmi(void)
 	 * the backend.  They are performance critical anyway, so requiring
 	 * a patch is not a big problem.
 	 */
-	pv_cpu_ops.irq_enable_sysexit = (void *)0xfeedbab0;
+	pv_cpu_ops.irq_enable_syscall_ret = (void *)0xfeedbab0;
 	pv_cpu_ops.iret = (void *)0xbadbab0;
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 94c39aa..094b915 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -953,7 +953,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.read_pmc = native_read_pmc,
 
 	.iret = (void *)&hypercall_page[__HYPERVISOR_iret],
-	.irq_enable_sysexit = NULL,  /* never called */
+	.irq_enable_syscall_ret = NULL,  /* never called */
 
 	.load_tr_desc = paravirt_nop,
 	.set_ldt = xen_set_ldt,
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
index 1b695ff..fd0df93 100644
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -1,5 +1,112 @@
+#ifndef _X86_IRQFLAGS_H_
+#define _X86_IRQFLAGS_H_
+
+#include <asm/processor-flags.h>
+
 #ifdef CONFIG_X86_32
 # include "irqflags_32.h"
 #else
 # include "irqflags_64.h"
 #endif
+
+#ifndef __ASSEMBLY__
+static inline void native_irq_disable(void)
+{
+	asm volatile("cli": : :"memory");
+}
+
+static inline void native_irq_enable(void)
+{
+	asm volatile("sti": : :"memory");
+}
+
+static inline void native_safe_halt(void)
+{
+	asm volatile("sti; hlt": : :"memory");
+}
+
+static inline void native_halt(void)
+{
+	asm volatile("hlt": : :"memory");
+}
+#endif /* __ASSEMBLY__ */
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define ENABLE_INTERRUPTS(x)	sti
+#define DISABLE_INTERRUPTS(x)	cli
+#ifndef __ASSEMBLY__
+
+static inline unsigned long __raw_local_save_flags(void)
+{
+	return native_save_fl();
+}
+
+static inline void raw_local_irq_restore(unsigned long flags)
+{
+	native_restore_fl(flags);
+}
+
+static inline void raw_local_irq_disable(void)
+{
+	native_irq_disable();
+}
+
+static inline void raw_local_irq_enable(void)
+{
+	native_irq_enable();
+}
+
+/*
+ * Used in the idle loop; sti takes one instruction cycle
+ * to complete:
+ */
+static inline void raw_safe_halt(void)
+{
+	native_safe_halt();
+}
+
+/*
+ * Used when interrupts are already enabled or to
+ * shutdown the processor:
+ */
+static inline void halt(void)
+{
+	native_halt();
+}
+
+/*
+ * For spinlocks, etc:
+ */
+static inline unsigned long __raw_local_irq_save(void)
+{
+	unsigned long flags = __raw_local_save_flags();
+
+	raw_local_irq_disable();
+
+	return flags;
+}
+#endif /* __ASSEMBLY__ */
+#endif /* CONFIG_PARAVIRT */
+
+#ifndef __ASSEMBLY__
+#define raw_local_save_flags(flags) \
+		do { (flags) = __raw_local_save_flags(); } while (0)
+
+#define raw_local_irq_save(flags) \
+		do { (flags) = __raw_local_irq_save(); } while (0)
+
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & X86_EFLAGS_IF);
+}
+
+static inline int raw_irqs_disabled(void)
+{
+	unsigned long flags = __raw_local_save_flags();
+
+	return raw_irqs_disabled_flags(flags);
+}
+#endif /* __ASSEMBLY__ */
+#endif
diff --git a/include/asm-x86/irqflags_32.h b/include/asm-x86/irqflags_32.h
index d058b04..11cfbdd 100644
--- a/include/asm-x86/irqflags_32.h
+++ b/include/asm-x86/irqflags_32.h
@@ -26,111 +26,12 @@ static inline void native_restore_fl(unsigned long f)
 			     :"memory", "cc");
 }
 
-static inline void native_irq_disable(void)
-{
-	asm volatile("cli": : :"memory");
-}
-
-static inline void native_irq_enable(void)
-{
-	asm volatile("sti": : :"memory");
-}
-
-static inline void native_safe_halt(void)
-{
-	asm volatile("sti; hlt": : :"memory");
-}
-
-static inline void native_halt(void)
-{
-	asm volatile("hlt": : :"memory");
-}
-#endif	/* __ASSEMBLY__ */
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#ifndef __ASSEMBLY__
-
-static inline unsigned long __raw_local_save_flags(void)
-{
-	return native_save_fl();
-}
-
-static inline void raw_local_irq_restore(unsigned long flags)
-{
-	native_restore_fl(flags);
-}
-
-static inline void raw_local_irq_disable(void)
-{
-	native_irq_disable();
-}
-
-static inline void raw_local_irq_enable(void)
-{
-	native_irq_enable();
-}
-
-/*
- * Used in the idle loop; sti takes one instruction cycle
- * to complete:
- */
-static inline void raw_safe_halt(void)
-{
-	native_safe_halt();
-}
-
-/*
- * Used when interrupts are already enabled or to
- * shutdown the processor:
- */
-static inline void halt(void)
-{
-	native_halt();
-}
-
-/*
- * For spinlocks, etc:
- */
-static inline unsigned long __raw_local_irq_save(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	raw_local_irq_disable();
-
-	return flags;
-}
-
-#else
-#define DISABLE_INTERRUPTS(clobbers)	cli
-#define ENABLE_INTERRUPTS(clobbers)	sti
-#define ENABLE_INTERRUPTS_SYSEXIT	sti; sysexit
+#elif !defined(CONFIG_PARAVIRT)	/* __ASSEMBLY__ */
+#define ENABLE_INTERRUPTS_SYSCALL_RET	sti; sysexit
 #define INTERRUPT_RETURN		iret
 #define GET_CR0_INTO_EAX		movl %cr0, %eax
-#endif /* __ASSEMBLY__ */
 #endif /* CONFIG_PARAVIRT */
 
-#ifndef __ASSEMBLY__
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
-
-#define raw_local_irq_save(flags) \
-		do { (flags) = __raw_local_irq_save(); } while (0)
-
-static inline int raw_irqs_disabled_flags(unsigned long flags)
-{
-	return !(flags & X86_EFLAGS_IF);
-}
-
-static inline int raw_irqs_disabled(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	return raw_irqs_disabled_flags(flags);
-}
-#endif /* __ASSEMBLY__ */
-
 /*
  * Do the CPU's IRQ-state tracing from assembly code. We call a
  * C function, so save all the C-clobbered registers:
diff --git a/include/asm-x86/irqflags_64.h b/include/asm-x86/irqflags_64.h
index 5341ea1..88eb53f 100644
--- a/include/asm-x86/irqflags_64.h
+++ b/include/asm-x86/irqflags_64.h
@@ -16,7 +16,7 @@
  * Interrupt control:
  */
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long native_save_fl(void)
 {
 	unsigned long flags;
 
@@ -31,10 +31,7 @@ static inline unsigned long __raw_local_save_flags(void)
 	return flags;
 }
 
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
-
-static inline void raw_local_irq_restore(unsigned long flags)
+static inline void native_restore_fl(unsigned long flags)
 {
 	__asm__ __volatile__(
 		"pushq %0 ; popfq"
@@ -43,93 +40,7 @@ static inline void raw_local_irq_restore(unsigned long flags)
 		:"memory", "cc"
 	);
 }
-
-#ifdef CONFIG_X86_VSMP
-
-/*
- * Interrupt control for the VSMP architecture:
- */
-
-static inline void raw_local_irq_disable(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	raw_local_irq_restore((flags & ~X86_EFLAGS_IF) | X86_EFLAGS_AC);
-}
-
-static inline void raw_local_irq_enable(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	raw_local_irq_restore((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
-}
-
-static inline int raw_irqs_disabled_flags(unsigned long flags)
-{
-	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
-}
-
-#else /* CONFIG_X86_VSMP */
-
-static inline void raw_local_irq_disable(void)
-{
-	__asm__ __volatile__("cli" : : : "memory");
-}
-
-static inline void raw_local_irq_enable(void)
-{
-	__asm__ __volatile__("sti" : : : "memory");
-}
-
-static inline int raw_irqs_disabled_flags(unsigned long flags)
-{
-	return !(flags & X86_EFLAGS_IF);
-}
-
-#endif
-
-/*
- * For spinlocks, etc.:
- */
-
-static inline unsigned long __raw_local_irq_save(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	raw_local_irq_disable();
-
-	return flags;
-}
-
-#define raw_local_irq_save(flags) \
-		do { (flags) = __raw_local_irq_save(); } while (0)
-
-static inline int raw_irqs_disabled(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	return raw_irqs_disabled_flags(flags);
-}
-
-/*
- * Used in the idle loop; sti takes one instruction cycle
- * to complete:
- */
-static inline void raw_safe_halt(void)
-{
-	__asm__ __volatile__("sti; hlt" : : : "memory");
-}
-
-/*
- * Used when interrupts are already enabled or to
- * shutdown the processor:
- */
-static inline void halt(void)
-{
-	__asm__ __volatile__("hlt": : :"memory");
-}
-
-#else /* __ASSEMBLY__: */
+#else /* __ASSEMBLY__ */
 # ifdef CONFIG_TRACE_IRQFLAGS
 #  define TRACE_IRQS_ON		call trace_hardirqs_on_thunk
 #  define TRACE_IRQS_OFF	call trace_hardirqs_off_thunk
@@ -153,4 +64,21 @@ static inline void halt(void)
 # endif
 #endif
 
+#ifndef CONFIG_PARAVIRT
+#define INTERRUPT_RETURN	iretq
+#define ENABLE_INTERRUPTS_SYSCALL_RET			\
+			movq	%gs:pda_oldrsp, %rsp;	\
+			swapgs;				\
+			sysretq;
+#endif
+/* Currently paravirt can't handle swapgs nicely when we
+ * don't have a stack we can rely on (such as a user space
+ * stack).  So we either find a way around these or just fault
+ * and emulate if a guest tries to call swapgs directly.
+ *
+ * Either way, this is a good way to document that we don't
+ * have a reliable stack.
+ */
+#define SWAPGS_UNSAFE_STACK	swapgs
+
 #endif
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index f59d370..d81a361 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -121,7 +121,7 @@ struct pv_cpu_ops {
 	u64 (*read_pmc)(void);
 
 	/* These two are jmp to, not actually called. */
-	void (*irq_enable_sysexit)(void);
+	void (*irq_enable_syscall_ret)(void);
 	void (*iret)(void);
 
 	struct pv_lazy_ops lazy_mode;
@@ -1138,9 +1138,10 @@ static inline unsigned long __raw_local_irq_save(void)
 		  call *%cs:pv_irq_ops+PV_IRQ_irq_enable;		\
 		  popl %edx; popl %ecx; popl %eax)
 
-#define ENABLE_INTERRUPTS_SYSEXIT					       \
-	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_sysexit), CLBR_NONE,\
-		  jmp *%cs:pv_cpu_ops+PV_CPU_irq_enable_sysexit)
+#define ENABLE_INTERRUPTS_SYSCALL_RET					\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_syscall_ret),\
+		  CLBR_NONE,						\
+		  jmp *%cs:pv_cpu_ops+PV_CPU_irq_enable_syscall_ret)
 
 #define GET_CR0_INTO_EAX			\
 	push %ecx; push %edx;			\
-- 
1.4.4.2

