Return-Path: <linux-kernel-owner+w=401wt.eu-S1751001AbXA2ULe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbXA2ULe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXA2ULe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:11:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXA2ULd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:11:33 -0500
Message-ID: <45BE54EB.4070200@redhat.com>
Date: Mon, 29 Jan 2007 15:11:23 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@redhat.com>
Subject: [patch] i386: add option to show more code in oops reports
Content-Type: multipart/mixed;
 boundary="------------060001000209050207030309"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060001000209050207030309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sometimes developers need to see more object code in an oops report,
e.g. when kernel may be corrupted at runtime.

Add the "code_bytes" option for this.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>



--------------060001000209050207030309
Content-Type: text/plain;
 name="i386_show_more_code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386_show_more_code.patch"

 Documentation/kernel-parameters.txt |    5 +++++
 arch/i386/kernel/traps.c            |   20 ++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

--- 2.6.20-rc6.1-32smp.orig/Documentation/kernel-parameters.txt
+++ 2.6.20-rc6.1-32smp/Documentation/kernel-parameters.txt
@@ -361,6 +361,11 @@ and is between 256 and 4096 characters. 
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
--- 2.6.20-rc6.1-32smp.orig/arch/i386/kernel/traps.c
+++ 2.6.20-rc6.1-32smp/arch/i386/kernel/traps.c
@@ -94,6 +94,7 @@ asmlinkage void spurious_interrupt_bug(v
 asmlinkage void machine_check(void);
 
 int kstack_depth_to_print = 24;
+static unsigned int code_bytes = 64;
 ATOMIC_NOTIFIER_HEAD(i386die_chain);
 
 int register_die_notifier(struct notifier_block *nb)
@@ -324,7 +325,8 @@ void show_registers(struct pt_regs *regs
 	 */
 	if (in_kernel) {
 		u8 *eip;
-		int code_bytes = 64;
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
 		unsigned char c;
 
 		printk("\n" KERN_EMERG "Stack: ");
@@ -332,14 +334,14 @@ void show_registers(struct pt_regs *regs
 
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
@@ -1191,3 +1193,13 @@ static int __init kstack_setup(char *s)
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

--------------060001000209050207030309--
