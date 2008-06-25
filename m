Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbYFYEpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbYFYEpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbYFYEhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:40 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37472 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753909AbYFYEhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:23 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 30 of 36] x86/paravirt_ops: split sysret and sysexit
X-Mercurial-Node: 4c59e1f3b1cf649c279e8170dd89baad6b4579e3
Message-Id: <4c59e1f3b1cf649c279e.1214367566@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't conflate sysret and sysexit; they're different instructions with
different semantics, and may be in use at the same time (at least
within the same kernel, depending on whether its an Intel or AMD
system).

sysexit - just return to userspace, does no register restoration of
    any kind; must explicitly atomically enable interrupts.

sysret - reloads flags from r11, so no need to explicitly enable
    interrupts on 64-bit, responsible for restoring usermode %gs

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citirx.com>
---
 arch/x86/kernel/asm-offsets_32.c    |    2 +-
 arch/x86/kernel/asm-offsets_64.c    |    2 +-
 arch/x86/kernel/entry_32.S          |    8 ++++----
 arch/x86/kernel/entry_64.S          |    4 ++--
 arch/x86/kernel/paravirt.c          |   12 +++++++++---
 arch/x86/kernel/paravirt_patch_32.c |    4 ++--
 arch/x86/kernel/paravirt_patch_64.c |    4 ++--
 arch/x86/kernel/vmi_32.c            |    4 ++--
 arch/x86/xen/enlighten.c            |    2 +-
 include/asm-x86/irqflags.h          |    4 ++--
 include/asm-x86/paravirt.h          |   15 ++++++++++-----
 11 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -112,7 +112,7 @@
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
 	OFFSET(PV_CPU_nmi_return, pv_cpu_ops, nmi_return);
-	OFFSET(PV_CPU_irq_enable_syscall_ret, pv_cpu_ops, irq_enable_syscall_ret);
+	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
 	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
 #endif
 
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -63,7 +63,7 @@
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
 	OFFSET(PV_CPU_nmi_return, pv_cpu_ops, nmi_return);
-	OFFSET(PV_CPU_irq_enable_syscall_ret, pv_cpu_ops, irq_enable_syscall_ret);
+	OFFSET(PV_CPU_usersp_sysret, pv_cpu_ops, usersp_sysret);
 	OFFSET(PV_CPU_swapgs, pv_cpu_ops, swapgs);
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
 #endif
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -59,7 +59,7 @@
  * for paravirtualization.  The following will never clobber any registers:
  *   INTERRUPT_RETURN (aka. "iret")
  *   GET_CR0_INTO_EAX (aka. "movl %cr0, %eax")
- *   ENABLE_INTERRUPTS_SYSCALL_RET (aka "sti; sysexit").
+ *   ENABLE_INTERRUPTS_SYSEXIT (aka "sti; sysexit").
  *
  * For DISABLE_INTERRUPTS/ENABLE_INTERRUPTS (aka "cli"/"sti"), you must
  * specify what registers can be overwritten (CLBR_NONE, CLBR_EAX/EDX/ECX/ANY).
@@ -376,7 +376,7 @@
 	xorl %ebp,%ebp
 	TRACE_IRQS_ON
 1:	mov  PT_FS(%esp), %fs
-	ENABLE_INTERRUPTS_SYSCALL_RET
+	ENABLE_INTERRUPTS_SYSEXIT
 	CFI_ENDPROC
 .pushsection .fixup,"ax"
 2:	movl $0,PT_FS(%esp)
@@ -905,10 +905,10 @@
 	NATIVE_INTERRUPT_RETURN_NMI_SAFE # Should we deal with popf exception ?
 END(native_nmi_return)
 
-ENTRY(native_irq_enable_syscall_ret)
+ENTRY(native_irq_enable_sysexit)
 	sti
 	sysexit
-END(native_irq_enable_syscall_ret)
+END(native_irq_enable_sysexit)
 #endif
 
 KPROBE_ENTRY(int3)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -167,7 +167,7 @@
 #endif	
 
 #ifdef CONFIG_PARAVIRT
-ENTRY(native_irq_enable_syscall_ret)
+ENTRY(native_usersp_sysret)
 	movq	%gs:pda_oldrsp,%rsp
 	swapgs
 	sysretq
@@ -383,7 +383,7 @@
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	ENABLE_INTERRUPTS_SYSCALL_RET
+	USERSP_SYSRET
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -141,7 +141,8 @@
 		ret = paravirt_patch_nop();
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.nmi_return) ||
-		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret))
+		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit) ||
+		 type == PARAVIRT_PATCH(pv_cpu_ops.usersp_sysret))
 		/* If operation requires a jmp, then jmp */
 		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
 	else
@@ -193,7 +194,8 @@
 /* These are in entry.S */
 extern void native_iret(void);
 extern void native_nmi_return(void);
-extern void native_irq_enable_syscall_ret(void);
+extern void native_irq_enable_sysexit(void);
+extern void native_usersp_sysret(void);
 
 static int __init print_banner(void)
 {
@@ -329,7 +331,11 @@
 	.write_idt_entry = native_write_idt_entry,
 	.load_sp0 = native_load_sp0,
 
-	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
+#ifdef CONFIG_X86_32
+	.irq_enable_sysexit = native_irq_enable_sysexit,
+#else
+	.usersp_sysret = native_usersp_sysret,
+#endif
 	.iret = native_iret,
 	.nmi_return = native_nmi_return,
 	.swapgs = native_swapgs,
diff --git a/arch/x86/kernel/paravirt_patch_32.c b/arch/x86/kernel/paravirt_patch_32.c
--- a/arch/x86/kernel/paravirt_patch_32.c
+++ b/arch/x86/kernel/paravirt_patch_32.c
@@ -8,7 +8,7 @@
 DEF_NATIVE(pv_cpu_ops, iret, "iret");
 DEF_NATIVE(pv_cpu_ops, nmi_return,
 	__stringify(NATIVE_INTERRUPT_RETURN_NMI_SAFE));
-DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
+DEF_NATIVE(pv_cpu_ops, irq_enable_sysexit, "sti; sysexit");
 DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
 DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %cr3, %eax");
@@ -33,7 +33,7 @@
 		PATCH_SITE(pv_irq_ops, save_fl);
 		PATCH_SITE(pv_cpu_ops, iret);
 		PATCH_SITE(pv_cpu_ops, nmi_return);
-		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
+		PATCH_SITE(pv_cpu_ops, irq_enable_sysexit);
 		PATCH_SITE(pv_mmu_ops, read_cr2);
 		PATCH_SITE(pv_mmu_ops, read_cr3);
 		PATCH_SITE(pv_mmu_ops, write_cr3);
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -18,7 +18,7 @@
 DEF_NATIVE(pv_cpu_ops, wbinvd, "wbinvd");
 
 /* the three commands give us more control to how to return from a syscall */
-DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "movq %gs:" __stringify(pda_oldrsp) ", %rsp; swapgs; sysretq;");
+DEF_NATIVE(pv_cpu_ops, usersp_sysret, "movq %gs:" __stringify(pda_oldrsp) ", %rsp; swapgs; sysretq;");
 DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
 
 unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
@@ -39,7 +39,7 @@
 		PATCH_SITE(pv_irq_ops, irq_disable);
 		PATCH_SITE(pv_cpu_ops, iret);
 		PATCH_SITE(pv_cpu_ops, nmi_return);
-		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
+		PATCH_SITE(pv_cpu_ops, usersp_sysret);
 		PATCH_SITE(pv_cpu_ops, swapgs);
 		PATCH_SITE(pv_mmu_ops, read_cr2);
 		PATCH_SITE(pv_mmu_ops, read_cr3);
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -153,7 +153,7 @@
 			return patch_internal(VMI_CALL_IRET, len, insns, ip);
 		case PARAVIRT_PATCH(pv_cpu_ops.nmi_return):
 			return patch_internal(VMI_CALL_IRET, len, insns, ip);
-		case PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret):
+		case PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit):
 			return patch_internal(VMI_CALL_SYSEXIT, len, insns, ip);
 		default:
 			break;
@@ -898,7 +898,7 @@
 	 * the backend.  They are performance critical anyway, so requiring
 	 * a patch is not a big problem.
 	 */
-	pv_cpu_ops.irq_enable_syscall_ret = (void *)0xfeedbab0;
+	pv_cpu_ops.irq_enable_sysexit = (void *)0xfeedbab0;
 	pv_cpu_ops.iret = (void *)0xbadbab0;
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1087,7 +1087,7 @@
 
 	.iret = xen_iret,
 	.nmi_return = xen_iret,
-	.irq_enable_syscall_ret = xen_sysexit,
+	.irq_enable_sysexit = xen_sysexit,
 
 	.load_tr_desc = paravirt_nop,
 	.set_ldt = xen_set_ldt,
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -168,13 +168,13 @@
 
 #ifdef CONFIG_X86_64
 #define INTERRUPT_RETURN	iretq
-#define ENABLE_INTERRUPTS_SYSCALL_RET			\
+#define USERSP_SYSRET					\
 			movq	%gs:pda_oldrsp, %rsp;	\
 			swapgs;				\
 			sysretq;
 #else
 #define INTERRUPT_RETURN		iret
-#define ENABLE_INTERRUPTS_SYSCALL_RET	sti; sysexit
+#define ENABLE_INTERRUPTS_SYSEXIT	sti; sysexit
 #define GET_CR0_INTO_EAX		movl %cr0, %eax
 #endif
 
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -141,8 +141,9 @@
 	u64 (*read_pmc)(int counter);
 	unsigned long long (*read_tscp)(unsigned int *aux);
 
-	/* These three are jmp to, not actually called. */
-	void (*irq_enable_syscall_ret)(void);
+	/* These ones are jmp'ed to, not actually called. */
+	void (*irq_enable_sysexit)(void);
+	void (*usersp_sysret)(void);
 	void (*iret)(void);
 	void (*nmi_return)(void);
 
@@ -1485,10 +1486,10 @@
 		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_enable);	\
 		  PV_RESTORE_REGS;)
 
-#define ENABLE_INTERRUPTS_SYSCALL_RET					\
-	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_syscall_ret),\
+#define ENABLE_INTERRUPTS_SYSEXIT					\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_sysexit),	\
 		  CLBR_NONE,						\
-		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_irq_enable_syscall_ret))
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_irq_enable_sysexit))
 
 
 #ifdef CONFIG_X86_32
@@ -1509,6 +1510,10 @@
 	movq %rax, %rcx;				\
 	xorq %rax, %rax;
 
+#define USERSP_SYSRET							\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usersp_sysret),		\
+		  CLBR_NONE,						\
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_usersp_sysret))
 #endif
 
 #endif /* __ASSEMBLY__ */


