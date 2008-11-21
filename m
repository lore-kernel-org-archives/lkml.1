Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYKUPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYKUPrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbYKUPol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:41 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:25232 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbYKUPoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:39 -0500
Date: Fri, 21 Nov 2008 16:41:55 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86: Introduce save_rest and restructure the PTREGSCALL macro in entry_64.S
Message-ID: <20081121154155.GA12999@mailshack.com>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120153954.GA22511@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 21 Nov 2008 16:43:48 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.120; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_rest function completes a partial stack frame for use
by the PTREGSCALL macro. This also avoid the indirect call in
PTREGSCALLs.

This adds the macro movq_cfi_restore to hide the CFI_RESTORE
annotation when restoring a register from the stack frame.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_64.S |   91 +++++++++++++++++++++++++------------------
 1 files changed, 53 insertions(+), 38 deletions(-)

Hello Ingo,

Here are three more patches cleaning up entry_64.S. They apply to
current tip/x86/irq. Thanks again for your help on the binutils
problems!

Greetings,
    Alexander

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 92c5e18..ef95c45 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -78,6 +78,11 @@
 	CFI_REL_OFFSET \reg, \offset
 	.endm
 
+	.macro movq_cfi_restore offset reg
+	movq \offset(%rsp), %\reg
+	CFI_RESTORE \reg
+	.endm
+
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
@@ -186,21 +191,21 @@ ENTRY(native_usergs_sysret64)
  */
 
 	/* %rsp:at FRAMEEND */
-	.macro FIXUP_TOP_OF_STACK tmp
-	movq	%gs:pda_oldrsp,\tmp
-	movq  	\tmp,RSP(%rsp)
-	movq    $__USER_DS,SS(%rsp)
-	movq    $__USER_CS,CS(%rsp)
-	movq 	$-1,RCX(%rsp)
-	movq	R11(%rsp),\tmp  /* get eflags */
-	movq	\tmp,EFLAGS(%rsp)
+	.macro FIXUP_TOP_OF_STACK tmp offset=0
+	movq %gs:pda_oldrsp,\tmp
+	movq \tmp,RSP+\offset(%rsp)
+	movq $__USER_DS,SS+\offset(%rsp)
+	movq $__USER_CS,CS+\offset(%rsp)
+	movq $-1,RCX+\offset(%rsp)
+	movq R11+\offset(%rsp),\tmp  /* get eflags */
+	movq \tmp,EFLAGS+\offset(%rsp)
 	.endm
 
-	.macro RESTORE_TOP_OF_STACK tmp,offset=0
-	movq   RSP-\offset(%rsp),\tmp
-	movq   \tmp,%gs:pda_oldrsp
-	movq   EFLAGS-\offset(%rsp),\tmp
-	movq   \tmp,R11-\offset(%rsp)
+	.macro RESTORE_TOP_OF_STACK tmp offset=0
+	movq RSP+\offset(%rsp),\tmp
+	movq \tmp,%gs:pda_oldrsp
+	movq EFLAGS+\offset(%rsp),\tmp
+	movq \tmp,R11+\offset(%rsp)
 	.endm
 
 	.macro FAKE_STACK_FRAME child_rip
@@ -333,6 +338,21 @@ ENTRY(save_args)
 	CFI_ENDPROC
 END(save_args)
 
+ENTRY(save_rest)
+	PARTIAL_FRAME 1 REST_SKIP+8
+	movq 5*8+16(%rsp), %r11	/* save return address */
+	movq_cfi rbx, RBX+16
+	movq_cfi rbp, RBP+16
+	movq_cfi r12, R12+16
+	movq_cfi r13, R13+16
+	movq_cfi r14, R14+16
+	movq_cfi r15, R15+16
+	movq %r11, 8(%rsp)	/* return address */
+	FIXUP_TOP_OF_STACK %r11, 16
+	ret
+	CFI_ENDPROC
+END(save_rest)
+
 /*
  * A newly forked process directly context switches into this.
  */
@@ -353,7 +373,7 @@ rff_action:
 	je   int_ret_from_sys_call
 	testl $_TIF_IA32,TI_flags(%rcx)
 	jnz  int_ret_from_sys_call
-	RESTORE_TOP_OF_STACK %rdi,ARGOFFSET
+	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
 	jmp ret_from_sys_call
 rff_trace:
 	movq %rsp,%rdi
@@ -626,18 +646,20 @@ END(system_call)
 /*
  * Certain special system calls that need to save a complete full stack frame.
  */
-
 	.macro PTREGSCALL label,func,arg
-	.globl \label
-\label:
-	leaq	\func(%rip),%rax
-	leaq    -ARGOFFSET+8(%rsp),\arg /* 8 for return address */
-	jmp	ptregscall_common
+ENTRY(\label)
+	PARTIAL_FRAME 1 8		/* offset 8: return address */
+	subq $REST_SKIP, %rsp
+	CFI_ADJUST_CFA_OFFSET REST_SKIP
+	call save_rest
+	DEFAULT_FRAME 0 8		/* offset 8: return address */
+	leaq 8(%rsp), \arg	/* pt_regs pointer */
+	call \func
+	jmp ptregscall_common
+	CFI_ENDPROC
 END(\label)
 	.endm
 
-	CFI_STARTPROC
-
 	PTREGSCALL stub_clone, sys_clone, %r8
 	PTREGSCALL stub_fork, sys_fork, %rdi
 	PTREGSCALL stub_vfork, sys_vfork, %rdi
@@ -645,22 +667,15 @@ END(\label)
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
 
 ENTRY(ptregscall_common)
-	popq %r11
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_REGISTER rip, r11
-	SAVE_REST
-	movq %r11, %r15
-	CFI_REGISTER rip, r15
-	FIXUP_TOP_OF_STACK %r11
-	call *%rax
-	RESTORE_TOP_OF_STACK %r11
-	movq %r15, %r11
-	CFI_REGISTER rip, r11
-	RESTORE_REST
-	pushq %r11
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rip, 0
-	ret
+	DEFAULT_FRAME 1 8	/* offset 8: return address */
+	RESTORE_TOP_OF_STACK %r11, 8
+	movq_cfi_restore R15+8, r15
+	movq_cfi_restore R14+8, r14
+	movq_cfi_restore R13+8, r13
+	movq_cfi_restore R12+8, r12
+	movq_cfi_restore RBP+8, rbp
+	movq_cfi_restore RBX+8, rbx
+	ret $REST_SKIP		/* pop extended registers */
 	CFI_ENDPROC
 END(ptregscall_common)
 
-- 
1.5.4.3

