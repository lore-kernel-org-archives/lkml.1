Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYFYErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYFYErR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYFYEhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:46 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37471 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754941AbYFYEh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 31 of 36] x86_64 pvops: don't restore user rsp within sysret
X-Mercurial-Node: 1436df0060823e174ace8f0b4816ac308d4f5a66
Message-Id: <1436df0060823e174ace.1214367567@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to combine restoring the user rsp within the sysret
pvop, so split it out.  This makes the pvop's semantics closer to the
machine instruction.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citirx.com>
---
 arch/x86/kernel/asm-offsets_64.c    |    2 +-
 arch/x86/kernel/entry_64.S          |    6 +++---
 arch/x86/kernel/paravirt.c          |    6 +++---
 arch/x86/kernel/paravirt_patch_64.c |    4 ++--
 include/asm-x86/irqflags.h          |    3 +--
 include/asm-x86/paravirt.h          |    8 ++++----
 6 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -63,7 +63,7 @@
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
 	OFFSET(PV_CPU_nmi_return, pv_cpu_ops, nmi_return);
-	OFFSET(PV_CPU_usersp_sysret, pv_cpu_ops, usersp_sysret);
+	OFFSET(PV_CPU_usergs_sysret, pv_cpu_ops, usergs_sysret);
 	OFFSET(PV_CPU_swapgs, pv_cpu_ops, swapgs);
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
 #endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -167,8 +167,7 @@
 #endif	
 
 #ifdef CONFIG_PARAVIRT
-ENTRY(native_usersp_sysret)
-	movq	%gs:pda_oldrsp,%rsp
+ENTRY(native_usergs_sysret)
 	swapgs
 	sysretq
 #endif /* CONFIG_PARAVIRT */
@@ -383,7 +382,8 @@
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	USERSP_SYSRET
+	movq	%gs:pda_oldrsp, %rsp
+	USERGS_SYSRET
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -142,7 +142,7 @@
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.nmi_return) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit) ||
-		 type == PARAVIRT_PATCH(pv_cpu_ops.usersp_sysret))
+		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret))
 		/* If operation requires a jmp, then jmp */
 		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
 	else
@@ -195,7 +195,7 @@
 extern void native_iret(void);
 extern void native_nmi_return(void);
 extern void native_irq_enable_sysexit(void);
-extern void native_usersp_sysret(void);
+extern void native_usergs_sysret(void);
 
 static int __init print_banner(void)
 {
@@ -334,7 +334,7 @@
 #ifdef CONFIG_X86_32
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 #else
-	.usersp_sysret = native_usersp_sysret,
+	.usergs_sysret = native_usergs_sysret,
 #endif
 	.iret = native_iret,
 	.nmi_return = native_nmi_return,
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -18,7 +18,7 @@
 DEF_NATIVE(pv_cpu_ops, wbinvd, "wbinvd");
 
 /* the three commands give us more control to how to return from a syscall */
-DEF_NATIVE(pv_cpu_ops, usersp_sysret, "movq %gs:" __stringify(pda_oldrsp) ", %rsp; swapgs; sysretq;");
+DEF_NATIVE(pv_cpu_ops, usergs_sysret, "swapgs; sysretq;");
 DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
 
 unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
@@ -39,7 +39,7 @@
 		PATCH_SITE(pv_irq_ops, irq_disable);
 		PATCH_SITE(pv_cpu_ops, iret);
 		PATCH_SITE(pv_cpu_ops, nmi_return);
-		PATCH_SITE(pv_cpu_ops, usersp_sysret);
+		PATCH_SITE(pv_cpu_ops, usergs_sysret);
 		PATCH_SITE(pv_cpu_ops, swapgs);
 		PATCH_SITE(pv_mmu_ops, read_cr2);
 		PATCH_SITE(pv_mmu_ops, read_cr3);
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -168,8 +168,7 @@
 
 #ifdef CONFIG_X86_64
 #define INTERRUPT_RETURN	iretq
-#define USERSP_SYSRET					\
-			movq	%gs:pda_oldrsp, %rsp;	\
+#define USERGS_SYSRET					\
 			swapgs;				\
 			sysretq;
 #else
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -143,7 +143,7 @@
 
 	/* These ones are jmp'ed to, not actually called. */
 	void (*irq_enable_sysexit)(void);
-	void (*usersp_sysret)(void);
+	void (*usergs_sysret)(void);
 	void (*iret)(void);
 	void (*nmi_return)(void);
 
@@ -1510,10 +1510,10 @@
 	movq %rax, %rcx;				\
 	xorq %rax, %rax;
 
-#define USERSP_SYSRET							\
-	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usersp_sysret),		\
+#define USERGS_SYSRET							\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usergs_sysret),		\
 		  CLBR_NONE,						\
-		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_usersp_sysret))
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_usergs_sysret))
 #endif
 
 #endif /* __ASSEMBLY__ */


