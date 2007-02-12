Return-Path: <linux-kernel-owner+w=401wt.eu-S965002AbXBLQzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002AbXBLQzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964992AbXBLQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:51:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982AbXBLQvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:32 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [11/29] i386: add option to show more code in oops reports
Message-Id: <20070212165131.56C0313F45@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chuck Ebbert <cebbert@redhat.com>

Sometimes developers need to see more object code in an oops report,
e.g. when kernel may be corrupted at runtime.

Add the "code_bytes" option for this.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 arch/i386/kernel/traps.c            |   20 ++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -364,6 +364,11 @@ and is between 256 and 4096 characters. 
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
+	code_bytes	[IA32] How many bytes of object code to print in an
+			oops report.
+			Range: 0 - 8192
+			Default: 64
+
 	disable_8254_timer
 	enable_8254_timer
 			[IA32/X86_64] Disable/Enable interrupt 0 timer routing
Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -94,6 +94,7 @@ asmlinkage void spurious_interrupt_bug(v
 asmlinkage void machine_check(void);
 
 int kstack_depth_to_print = 24;
+static unsigned int code_bytes = 64;
 ATOMIC_NOTIFIER_HEAD(i386die_chain);
 
 int register_die_notifier(struct notifier_block *nb)
@@ -325,7 +326,8 @@ void show_registers(struct pt_regs *regs
 	 */
 	if (in_kernel) {
 		u8 *eip;
-		int code_bytes = 64;
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
 		unsigned char c;
 
 		printk("\n" KERN_EMERG "Stack: ");
@@ -333,14 +335,14 @@ void show_registers(struct pt_regs *regs
 
 		printk(KERN_EMERG "Code: ");
 
-		eip = (u8 *)regs->eip - 43;
+		eip = (u8 *)regs->eip - code_prologue;
 		if (eip < (u8 *)PAGE_OFFSET ||
 			probe_kernel_address(eip, c)) {
 			/* try starting at EIP */
 			eip = (u8 *)regs->eip;
-			code_bytes = 32;
+			code_len = code_len - code_prologue + 1;
 		}
-		for (i = 0; i < code_bytes; i++, eip++) {
+		for (i = 0; i < code_len; i++, eip++) {
 			if (eip < (u8 *)PAGE_OFFSET ||
 				probe_kernel_address(eip, c)) {
 				printk(" Bad EIP value.");
@@ -1190,3 +1192,13 @@ static int __init kstack_setup(char *s)
 	return 1;
 }
 __setup("kstack=", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);
