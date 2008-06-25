Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYFYErf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYFYErf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYFYEhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:47 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37451 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755080AbYFYEh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 32 of 36] Add sysret/sysexit pvops for returning to 32-bit
	compatibility userspace
X-Mercurial-Node: 99077f68618e1f0e55cabae59a1e316ddb94b104
Message-Id: <99077f68618e1f0e55ca.1214367568@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:28 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a 64-bit system, we need separate sysret/sysexit operations to
return to a 32-bit userspace.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citirx.com>
---
 arch/x86/ia32/ia32entry.S           |   21 +++++++++---
 arch/x86/kernel/asm-offsets_64.c    |    4 +-
 arch/x86/kernel/entry_64.S          |    4 +-
 arch/x86/kernel/paravirt.c          |   12 ++++---
 arch/x86/kernel/paravirt_patch_64.c |    9 +++--
 include/asm-x86/irqflags.h          |   14 ++++++--
 include/asm-x86/paravirt.h          |   58 ++++++++++++++++++++++++++++-------
 7 files changed, 91 insertions(+), 31 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -60,6 +60,19 @@
 	CFI_UNDEFINED	r14
 	CFI_UNDEFINED	r15
 	.endm
+
+#ifdef CONFIG_PARAVIRT
+ENTRY(native_usergs_sysret32)
+	swapgs
+	sysretl
+ENDPROC(native_usergs_sysret32)
+
+ENTRY(native_irq_enable_sysexit)
+	swapgs
+	sti
+	sysexit
+ENDPROC(native_irq_enable_sysexit)
+#endif
 
 /*
  * 32bit SYSENTER instruction entry.
@@ -151,10 +164,7 @@
 	CFI_ADJUST_CFA_OFFSET -8
 	CFI_REGISTER rsp,rcx
 	TRACE_IRQS_ON
-	swapgs
-	sti		/* sti only takes effect after the next instruction */
-	/* sysexit */
-	.byte	0xf, 0x35
+	ENABLE_INTERRUPTS_SYSEXIT32
 
 sysenter_tracesys:
 	CFI_RESTORE_STATE
@@ -254,8 +264,7 @@
 	TRACE_IRQS_ON
 	movl RSP-ARGOFFSET(%rsp),%esp
 	CFI_RESTORE rsp
-	swapgs
-	sysretl
+	USERGS_SYSRET32
 	
 cstar_tracesys:	
 	CFI_RESTORE_STATE
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -63,7 +63,9 @@
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
 	OFFSET(PV_CPU_nmi_return, pv_cpu_ops, nmi_return);
-	OFFSET(PV_CPU_usergs_sysret, pv_cpu_ops, usergs_sysret);
+	OFFSET(PV_CPU_usergs_sysret32, pv_cpu_ops, usergs_sysret32);
+	OFFSET(PV_CPU_usergs_sysret64, pv_cpu_ops, usergs_sysret64);
+	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
 	OFFSET(PV_CPU_swapgs, pv_cpu_ops, swapgs);
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
 #endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -167,7 +167,7 @@
 #endif	
 
 #ifdef CONFIG_PARAVIRT
-ENTRY(native_usergs_sysret)
+ENTRY(native_usergs_sysret64)
 	swapgs
 	sysretq
 #endif /* CONFIG_PARAVIRT */
@@ -383,7 +383,7 @@
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
 	movq	%gs:pda_oldrsp, %rsp
-	USERGS_SYSRET
+	USERGS_SYSRET64
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -142,7 +142,8 @@
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.nmi_return) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit) ||
-		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret))
+		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret32) ||
+		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret64))
 		/* If operation requires a jmp, then jmp */
 		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
 	else
@@ -195,7 +196,8 @@
 extern void native_iret(void);
 extern void native_nmi_return(void);
 extern void native_irq_enable_sysexit(void);
-extern void native_usergs_sysret(void);
+extern void native_usergs_sysret32(void);
+extern void native_usergs_sysret64(void);
 
 static int __init print_banner(void)
 {
@@ -331,10 +333,10 @@
 	.write_idt_entry = native_write_idt_entry,
 	.load_sp0 = native_load_sp0,
 
-#ifdef CONFIG_X86_32
 	.irq_enable_sysexit = native_irq_enable_sysexit,
-#else
-	.usergs_sysret = native_usergs_sysret,
+#ifdef CONFIG_X86_64
+	.usergs_sysret32 = native_usergs_sysret32,
+	.usergs_sysret64 = native_usergs_sysret64,
 #endif
 	.iret = native_iret,
 	.nmi_return = native_nmi_return,
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -17,8 +17,9 @@
 DEF_NATIVE(pv_cpu_ops, clts, "clts");
 DEF_NATIVE(pv_cpu_ops, wbinvd, "wbinvd");
 
-/* the three commands give us more control to how to return from a syscall */
-DEF_NATIVE(pv_cpu_ops, usergs_sysret, "swapgs; sysretq;");
+DEF_NATIVE(pv_cpu_ops, irq_enable_sysexit, "swapgs; sti; sysexit");
+DEF_NATIVE(pv_cpu_ops, usergs_sysret64, "swapgs; sysretq");
+DEF_NATIVE(pv_cpu_ops, usergs_sysret32, "swapgs; sysretl");
 DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
 
 unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
@@ -39,7 +40,9 @@
 		PATCH_SITE(pv_irq_ops, irq_disable);
 		PATCH_SITE(pv_cpu_ops, iret);
 		PATCH_SITE(pv_cpu_ops, nmi_return);
-		PATCH_SITE(pv_cpu_ops, usergs_sysret);
+		PATCH_SITE(pv_cpu_ops, irq_enable_sysexit);
+		PATCH_SITE(pv_cpu_ops, usergs_sysret32);
+		PATCH_SITE(pv_cpu_ops, usergs_sysret64);
 		PATCH_SITE(pv_cpu_ops, swapgs);
 		PATCH_SITE(pv_mmu_ops, read_cr2);
 		PATCH_SITE(pv_mmu_ops, read_cr3);
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -168,9 +168,17 @@
 
 #ifdef CONFIG_X86_64
 #define INTERRUPT_RETURN	iretq
-#define USERGS_SYSRET					\
-			swapgs;				\
-			sysretq;
+#define USERGS_SYSRET64				\
+	swapgs;					\
+	sysretq;
+#define USERGS_SYSRET32				\
+	swapgs;					\
+	sysretl
+#define ENABLE_INTERRUPTS_SYSEXIT32		\
+	swapgs;					\
+	sti;					\
+	sysexit
+
 #else
 #define INTERRUPT_RETURN		iret
 #define ENABLE_INTERRUPTS_SYSEXIT	sti; sysexit
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -141,10 +141,35 @@
 	u64 (*read_pmc)(int counter);
 	unsigned long long (*read_tscp)(unsigned int *aux);
 
-	/* These ones are jmp'ed to, not actually called. */
+	/*
+	 * Atomically enable interrupts and return to userspace.  This
+	 * is only ever used to return to 32-bit processes; in a
+	 * 64-bit kernel, it's used for 32-on-64 compat processes, but
+	 * never native 64-bit processes.  (Jump, not call.)
+	 */
 	void (*irq_enable_sysexit)(void);
-	void (*usergs_sysret)(void);
+
+	/*
+	 * Switch to usermode gs and return to 64-bit usermode using
+	 * sysret.  Only used in 64-bit kernels to return to 64-bit
+	 * processes.  Usermode register state, including %rsp, must
+	 * already be restored.
+	 */
+	void (*usergs_sysret64)(void);
+
+	/*
+	 * Switch to usermode gs and return to 32-bit usermode using
+	 * sysret.  Used to return to 32-on-64 compat processes.
+	 * Other usermode register state, including %esp, must already
+	 * be restored.
+	 */
+	void (*usergs_sysret32)(void);
+
+	/* Normal iret.  Jump to this with the standard iret stack
+	   frame set up. */
 	void (*iret)(void);
+
+	/* Return from NMI. (?) */
 	void (*nmi_return)(void);
 
 	void (*swapgs)(void);
@@ -1486,18 +1511,24 @@
 		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_enable);	\
 		  PV_RESTORE_REGS;)
 
-#define ENABLE_INTERRUPTS_SYSEXIT					\
-	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_sysexit),	\
+#define USERGS_SYSRET32							\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usergs_sysret32),	\
 		  CLBR_NONE,						\
-		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_irq_enable_sysexit))
-
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_usergs_sysret32))
 
 #ifdef CONFIG_X86_32
 #define GET_CR0_INTO_EAX				\
 	push %ecx; push %edx;				\
 	call PARA_INDIRECT(pv_cpu_ops+PV_CPU_read_cr0);	\
 	pop %edx; pop %ecx
-#else
+
+#define ENABLE_INTERRUPTS_SYSEXIT					\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_sysexit),	\
+		  CLBR_NONE,						\
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_irq_enable_sysexit))
+
+
+#else	/* !CONFIG_X86_32 */
 #define SWAPGS								\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
 		  PV_SAVE_REGS;						\
@@ -1510,11 +1541,16 @@
 	movq %rax, %rcx;				\
 	xorq %rax, %rax;
 
-#define USERGS_SYSRET							\
-	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usergs_sysret),		\
+#define USERGS_SYSRET64							\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usergs_sysret64),	\
 		  CLBR_NONE,						\
-		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_usergs_sysret))
-#endif
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_usergs_sysret64))
+
+#define ENABLE_INTERRUPTS_SYSEXIT32					\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_sysexit),	\
+		  CLBR_NONE,						\
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_irq_enable_sysexit))
+#endif	/* CONFIG_X86_32 */
 
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_PARAVIRT */


