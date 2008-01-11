Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYAKGHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYAKGHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYAKGHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:07:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYAKGHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:07:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 early_idt_handler improvements
X-Fcc: ~/Mail/linus
X-Zippy-Says: I'm pretending I'm pulling in a TROUT!  Am I doing it correctly??
Message-Id: <20080111060705.9EAF126F9A9@magilla.localdomain>
Date: Thu, 10 Jan 2008 22:07:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not too pretty, but I found this made the "PANIC: early exception"
messages become much more reliably useful: 1. print the vector number,
2. print the %cs value, 3. handle error-code-pushing vs non-pushing vectors.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/head64.c  |    6 ++++--
 arch/x86/kernel/head_64.S |   34 ++++++++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 4a1c135..0000000 100644  
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -48,6 +48,8 @@ static void __init copy_bootdata(char *r
 	}
 }
 
+extern const char early_idt_handlers[IDT_ENTRIES][10];
+
 void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
@@ -59,7 +61,7 @@ void __init x86_64_start_kernel(char * r
 	zap_identity_mappings();
 
 	for (i = 0; i < IDT_ENTRIES; i++)
-		set_intr_gate(i, early_idt_handler);
+		set_intr_gate(i, &early_idt_handlers[i]);
 	load_idt((const struct desc_ptr *)&idt_descr);
 
 	early_printk("Kernel alive\n");
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index c31b1c9..0000000 100644  
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -267,14 +267,40 @@ init_rsp:
 bad_address:
 	jmp bad_address
 
+.macro early_idt_tramp first, last
+	.ifgt \last-\first
+	early_idt_tramp \first, \last-1
+	.endif
+	movl $\last,%esi
+	jmp early_idt_handler
+.endm
+
+	.globl early_idt_handlers
+early_idt_handlers:
+	early_idt_tramp 0, 63
+	early_idt_tramp 64, 127
+	early_idt_tramp 128, 191
+	early_idt_tramp 192, 255
+	
 ENTRY(early_idt_handler)
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
-	xorl %eax,%eax
-	movq 8(%rsp),%rsi	# get rip
-	movq (%rsp),%rdx
 	GET_CR2_INTO_RCX
+	movq %rcx,%r9
+	xorl %r8d,%r8d		# zero for error code
+	movl %esi,%ecx		# get vector number
+	# Test %ecx against mask of vectors that push error code.
+	cmpl $31,%ecx
+	ja 0f
+	movl $1,%eax
+	salq %cl,%rax
+	testl $0x27d00,%eax
+	je 0f
+	popq %r8		# get error code
+0:	movq 0(%rsp),%rcx	# get ip
+	movq 8(%rsp),%rdx	# get cs
+	xorl %eax,%eax
 	leaq early_idt_msg(%rip),%rdi
 	call early_printk
 	cmpl $2,early_recursion_flag(%rip)
@@ -291,7 +317,7 @@ early_recursion_flag:
 	.long 0
 
 early_idt_msg:
-	.asciz "PANIC: early exception rip %lx error %lx cr2 %lx\n"
+	.asciz "PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %lx\n"
 early_idt_ripmsg:
 	.asciz "RIP %s\n"
 
