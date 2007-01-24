Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbXAXUWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbXAXUWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXAXUWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:22:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbXAXUWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:22:41 -0500
Message-ID: <45B7C019.1040209@redhat.com>
Date: Wed, 24 Jan 2007 15:22:49 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>
Subject: [patch] i386: add option to show more code in oops reports
Content-Type: multipart/mixed;
 boundary="------------070108090207040508010803"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070108090207040508010803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sometimes we may need to see more code than the default in an oops,
so add an option for that.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>


--------------070108090207040508010803
Content-Type: text/plain;
 name="i386_show_more_code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386_show_more_code.patch"

 Documentation/kernel-parameters.txt |    5 +++++
 arch/i386/kernel/traps.c            |   17 +++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

--- 2.6.20-rc5-32.orig/Documentation/kernel-parameters.txt
+++ 2.6.20-rc5-32/Documentation/kernel-parameters.txt
@@ -361,6 +361,11 @@ and is between 256 and 4096 characters. 
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
+	code_bytes	[IA32] How many bytes of object code to print in an
+			oops report.
+			Range: 64 - 1024
+			Default: 64
+
 	disable_8254_timer
 	enable_8254_timer
 			[IA32/X86_64] Disable/Enable interrupt 0 timer routing
--- 2.6.20-rc5-32.orig/arch/i386/kernel/traps.c
+++ 2.6.20-rc5-32/arch/i386/kernel/traps.c
@@ -94,6 +94,7 @@ asmlinkage void spurious_interrupt_bug(v
 asmlinkage void machine_check(void);
 
 int kstack_depth_to_print = 24;
+int code_bytes = 64;
 ATOMIC_NOTIFIER_HEAD(i386die_chain);
 
 int register_die_notifier(struct notifier_block *nb)
@@ -324,7 +325,7 @@ void show_registers(struct pt_regs *regs
 	 */
 	if (in_kernel) {
 		u8 *eip;
-		int code_bytes = 64;
+		int code_prologue = code_bytes * 43 / 64;
 		unsigned char c;
 
 		printk("\n" KERN_EMERG "Stack: ");
@@ -332,7 +333,7 @@ void show_registers(struct pt_regs *regs
 
 		printk(KERN_EMERG "Code: ");
 
-		eip = (u8 *)regs->eip - 43;
+		eip = (u8 *)regs->eip - code_prologue;
 		if (eip < (u8 *)PAGE_OFFSET ||
 			probe_kernel_address(eip, c)) {
 			/* try starting at EIP */
@@ -1191,3 +1192,15 @@ static int __init kstack_setup(char *s)
 	return 1;
 }
 __setup("kstack=", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes < 64)
+		code_bytes = 64;
+	if (code_bytes > 1024)
+		code_bytes = 1024;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);

--------------070108090207040508010803--
