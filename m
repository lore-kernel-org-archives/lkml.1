Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYLZOX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYLZOX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYLZOWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:22:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47363 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYLZOWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:22:36 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 3/4] x86: Make interrupt stack switching atomic
Date: Fri, 26 Dec 2008 16:22:23 +0200
Message-Id: <1230301344-570-4-git-send-email-avi@redhat.com>
In-Reply-To: <1230301344-570-1-git-send-email-avi@redhat.com>
References: <1230301344-570-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of relying on pda.irqcount to tell us whether we're already in an
interrupt or not, examine the stack pointer directly.  This makes the switch
atomic (since there's no window between incrementing the counter and
switching the stack where an NMI could see the new counter but the old stack),
and lets us get rid of a variable.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    1 -
 arch/x86/kernel/entry_64.S       |    9 +++++----
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 1a79e16..362fd28 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -14,7 +14,7 @@ struct x8664_pda {
 					   address */
 	unsigned long kernelstack;	/* 16 top of kernel stack for current */
 	unsigned long oldrsp;		/* 24 user rsp for system call */
-	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
+	int unused;			/* 32 for rent */
 	unsigned int cpunumber;		/* 36 Logical CPU number */
 	unsigned long stack_canary;	/* 40 stack canary value */
 					/* gcc-ABI: this canary MUST be at
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 1d41d3f..62dde96 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -52,7 +52,6 @@ int main(void)
 	ENTRY(kernelstack); 
 	ENTRY(oldrsp); 
 	ENTRY(pcurrent); 
-	ENTRY(irqcount);
 	ENTRY(cpunumber);
 	ENTRY(irqstackptr);
 	ENTRY(data_offset);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6808c3a..f0ea980 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -881,7 +881,6 @@ void __cpuinit pda_init(int cpu)
 	mb();
 
 	pda->cpunumber = cpu;
-	pda->irqcount = -1;
 	pda->kernelstack = (unsigned long)stack_thread_info() -
 				 PDA_STACKOFFSET + THREAD_SIZE;
 	pda->active_mm = &init_mm;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4f1a38f..61c54d9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -315,20 +315,21 @@ ENTRY(native_usergs_sysret64)
 	CFI_REL_OFFSET r15, R15+\offset
 	.endm
 
-	.macro call_in_irqstack func
+	.macro call_in_irqstack func, scratch=%rax
 	/* Switch to the irq stack, unless already on it, then call func */
 	push %rbp
 	CFI_ADJUST_CFA_OFFSET 8
 	mov %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	incl %gs:pda_irqcount
-	cmovz %gs:pda_irqstackptr,%rsp
+	mov %gs:pda_irqstackptr, \scratch
+	sub %rsp,\scratch
+	cmp $IRQSTACKSIZE-64,%rax
+	cmova %gs:pda_irqstackptr,%rsp
 	EMPTY_FRAME 0
 	call \func
 	leaveq
 	CFI_DEF_CFA_REGISTER rsp
 	CFI_ADJUST_CFA_OFFSET -8
-	decl %gs:pda_irqcount
 	.endm
 
 /* save partial stack frame */
-- 
1.6.0.6

