Return-Path: <linux-kernel-owner+w=401wt.eu-S935653AbZAPOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935653AbZAPOY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935815AbZAPOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:23:29 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:22923 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935787AbZAPOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:23:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vu/COf3WTBvkJgbiDr4KdXsLbKVRcVSYCIoFQDIryGgcQL6ImDSElCP3dk6kiBG519
         fmhs8fzCke1JnbxnNQJiJDGgdNaf2ZQXcjx9EJU0JUTqxGN58shluldoUFvXL/oMg5UN
         qtGM4evvhgSg7+gYr3PpoFIRq3EvFEUfM1WC0=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 09/17] x86-64: Move irqcount from PDA to per-cpu.
Date: Fri, 16 Jan 2009 09:16:28 -0500
Message-Id: <1232115396-26367-9-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-8-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
 <1232115396-26367-8-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    4 ++--
 arch/x86/kernel/entry_64.S       |   12 ++++++------
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index ae23deb..4527d70 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -15,7 +15,7 @@ struct x8664_pda {
 	unsigned long unused2;
 	unsigned long unused3;
 	unsigned long unused4;
-	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
+	int unused5;
 	unsigned int unused6;		/* 36 was cpunumber */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 6a13983..fbc6045 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -48,7 +48,6 @@ int main(void)
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	ENTRY(irqcount);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f653860..62f9665 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -888,6 +888,8 @@ DEFINE_PER_CPU(unsigned long, kernelstack) = (unsigned long)&init_thread_union -
 					      KERNELSTACK_OFFSET + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(kernelstack);
 
+DEFINE_PER_CPU(unsigned int, irqcount) = -1;
+
 void __cpuinit pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
@@ -898,8 +900,6 @@ void __cpuinit pda_init(int cpu)
 
 	load_pda_offset(cpu);
 
-	pda->irqcount = -1;
-
 	if (cpu != 0) {
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1331fd2..c97a1b5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -342,7 +342,7 @@ ENTRY(save_args)
 	 * a little cheaper to use a separate counter in the PDA (short of
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
-1:	incl %gs:pda_irqcount
+1:	incl PER_CPU_VAR(irqcount)
 	jne 2f
 	popq_cfi %rax			/* move return address... */
 	mov PER_CPU_VAR(irqstackptr),%rsp
@@ -837,7 +837,7 @@ common_interrupt:
 ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irqcount)
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	-8
@@ -1260,14 +1260,14 @@ ENTRY(call_softirq)
 	CFI_REL_OFFSET rbp,0
 	mov  %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	incl %gs:pda_irqcount
+	incl PER_CPU_VAR(irqcount)
 	cmove PER_CPU_VAR(irqstackptr),%rsp
 	push  %rbp			# backlink for old unwinder
 	call __do_softirq
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET   -8
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irqcount)
 	ret
 	CFI_ENDPROC
 END(call_softirq)
@@ -1297,7 +1297,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
 	DEFAULT_FRAME
-11:	incl %gs:pda_irqcount
+11:	incl PER_CPU_VAR(irqcount)
 	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
 	cmovzq PER_CPU_VAR(irqstackptr),%rsp
@@ -1305,7 +1305,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	call xen_evtchn_do_upcall
 	popq %rsp
 	CFI_DEF_CFA_REGISTER rsp
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irqcount)
 	jmp  error_exit
 	CFI_ENDPROC
 END(do_hypervisor_callback)
-- 
1.6.1.rc1

