Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZCLKzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZCLKzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZCLKz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:55:28 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33073 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbZCLKz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:55:27 -0400
Message-Id: <49B8F3A2.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:36:02 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: add unwind annotations to early_idt_handler
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>

---
 arch/x86/kernel/head_64.S |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux-2.6.29-rc7/arch/x86/kernel/head_64.S	2009-03-11 17:52:10.000000000 +0100
+++ 2.6.29-rc7-x86_64-unwind-early_idt_handler/arch/x86/kernel/head_64.S	2009-02-18 13:38:09.000000000 +0100
@@ -280,6 +280,8 @@ early_idt_handlers:
 
 ENTRY(early_idt_handler)
 #ifdef CONFIG_EARLY_PRINTK
+#include <asm/calling.h>
+#include <asm/dwarf2.h>
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
@@ -295,6 +297,16 @@ ENTRY(early_idt_handler)
 	testl $0x27d00,%eax
 	je 0f
 	popq %r8		# get error code
+
+	CFI_STARTPROC	simple
+	CFI_SIGNAL_FRAME
+	CFI_DEF_CFA	rsp, SS+8-RIP
+#	CFI_REL_OFFSET	ss, SS-RIP
+	CFI_REL_OFFSET	rsp, RSP-RIP
+#	CFI_REL_OFFSET	rflags, EFLAGS-RIP
+#	CFI_REL_OFFSET	cs, CS-RIP
+	CFI_REL_OFFSET	rip, RIP-RIP
+
 0:	movq 0(%rsp),%rcx	# get ip
 	movq 8(%rsp),%rdx	# get cs
 	xorl %eax,%eax
@@ -308,6 +320,7 @@ ENTRY(early_idt_handler)
 	movq 0(%rsp),%rsi	# get rip again
 	call __print_symbol
 #endif
+	CFI_ENDPROC
 #endif /* EARLY_PRINTK */
 1:	hlt
 	jmp 1b



