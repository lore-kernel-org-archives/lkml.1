Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbXJPPtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbXJPPtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933405AbXJPPtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:49:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:26593 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442AbXJPPtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=FFp/WYtfvlPo5NGAXnLOK6aPkEymsoXhU/F3sgLofqpTSPmFovQ0izq7/QL0Hdj4fp8MSYWx8RY7ngNSy/ncC123WIgIzPHejBansAYUhiiIoE4dUpKS2XGydf2V/pze4SLm2NtiFi0jLE1Rtb+ChZ4B6h1aFr+NIC+eXAoX/CE=
Message-ID: <4714DDA8.8030204@gmail.com>
Date: Tue, 16 Oct 2007 23:50:00 +0800
From: Yi Yang <yang.y.yi@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@osdl.org
CC: mj@atrey.karlin.mff.cuni.cz, pavel@atrey.karlin.mff.cuni.cz,
       crutcher+kernel@datastacks.com
Subject: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef key
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For SysRq, we just can get hot key list from Documentation/sysrq.txt
, but in the most of cases, the user can't access it by hand on
using SysRq to debug, so it is better for SysRq to provide an online
help for the users.

SysRq has already provided a similiar help before this patch, but it
is not so definite that the user doesn't know what happened and how
to do on pressing an undefined hot key.

In addition, that funtion has a big loop with another big loop
embedded which is very inefficient, it is intended to skip some hot
key help info for such a function as "Changing Loglevel", just print
a help info for this, that is very unnecessary. In fact, the key '0'
 - '8' have different results the user should know.

This patch add this online help function, it'll print thw whole hot
key list and corresponding function descriptions, it can print the new
defined hot key without any changed needed.

The output is the below on pressing an undefined hot key:

SysRq : <6>this hot key isn't defined.

SysRq Help Information:

  Hot Key      Function Description
===========    ====================
ALT+SysRq+0    Changing Loglevel to this value
ALT+SysRq+1    Changing Loglevel to this value
ALT+SysRq+2    Changing Loglevel to this value
ALT+SysRq+3    Changing Loglevel to this value
ALT+SysRq+4    Changing Loglevel to this value
ALT+SysRq+5    Changing Loglevel to this value
ALT+SysRq+6    Changing Loglevel to this value
ALT+SysRq+7    Changing Loglevel to this value
ALT+SysRq+8    Changing Loglevel to this value
ALT+SysRq+9    Changing Loglevel to this value
ALT+SysRq+a    Not defined
ALT+SysRq+b    Resetting
ALT+SysRq+c    Trigger a crashdump
ALT+SysRq+d    Not defined
ALT+SysRq+e    Terminate All Tasks
ALT+SysRq+f    Manual OOM execution
ALT+SysRq+g    Not defined
ALT+SysRq+h    Not defined
ALT+SysRq+i    Kill All Tasks
ALT+SysRq+j    Not defined
ALT+SysRq+k    SAK
ALT+SysRq+l    Not defined
ALT+SysRq+m    Show Memory
ALT+SysRq+n    Nice All RT Tasks
ALT+SysRq+o    Power Off
ALT+SysRq+p    Show Regs
ALT+SysRq+q    Show Pending Timers
ALT+SysRq+r    Keyboard mode set to XLATE
ALT+SysRq+s    Emergency Sync
ALT+SysRq+t    Show State
ALT+SysRq+u    Emergency Remount R/O
ALT+SysRq+v    Not defined
ALT+SysRq+w    Show Blocked State
ALT+SysRq+x    Not defined
ALT+SysRq+y    Not defined
ALT+SysRq+z    Not defined

Signed-off-by: Yi Yang <yang.y.yi@gmail.com>
---
 sysrq.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/char/sysrq.c	2007-10-16 18:32:58.000000000 +0800
+++ b/drivers/char/sysrq.c	2007-10-16 23:21:59.000000000 +0800
@@ -45,6 +45,16 @@ int __read_mostly __sysrq_enabled = 1;
 
 static int __read_mostly sysrq_always_enabled;
 
+/*
+ * Hot key table SysRq supports
+ */
+static char __read_mostly sysrq_hot_key_table[36] = {
+	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
+	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
+	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
+	'u', 'v', 'w', 'x', 'y', 'z'
+};
+
 int sysrq_on(void)
 {
 	return __sysrq_enabled || sysrq_always_enabled;
@@ -81,7 +91,7 @@ static void sysrq_handle_loglevel(int ke
 static struct sysrq_key_op sysrq_loglevel_op = {
 	.handler	= sysrq_handle_loglevel,
 	.help_msg	= "loglevel0-8",
-	.action_msg	= "Changing Loglevel",
+	.action_msg	= "Changing Loglevel to this value",
 	.enable_mask	= SYSRQ_ENABLE_LOG,
 };
 
@@ -410,7 +420,7 @@ void __handle_sysrq(int key, struct tty_
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
 	orig_log_level = console_loglevel;
 	console_loglevel = 7;
-	printk(KERN_INFO "SysRq : ");
+	printk(KERN_INFO "\nSysRq : ");
 
         op_p = __sysrq_get_key_op(key);
         if (op_p) {
@@ -426,18 +436,22 @@ void __handle_sysrq(int key, struct tty_
 			printk("This sysrq operation is disabled.\n");
 		}
 	} else {
-		printk("HELP : ");
-		/* Only print the help msg once per handler */
+		/*
+		 * Print SysRq hot key list
+		 */
+		printk(KERN_INFO "this hot key isn't defined.\n");
+		printk(KERN_INFO "\nSysRq Help Information:\n");
+		printk(KERN_INFO "\n  Hot Key      Function Description\n");
+		printk(KERN_INFO "===========    ====================\n");
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
 			if (sysrq_key_table[i]) {
-				int j;
-
-				for (j = 0; sysrq_key_table[i] !=
-						sysrq_key_table[j]; j++)
-					;
-				if (j != i)
-					continue;
-				printk("%s ", sysrq_key_table[i]->help_msg);
+				printk(KERN_INFO "ALT+SysRq+%c    %s\n",
+					sysrq_hot_key_table[i],
+					sysrq_key_table[i]->action_msg);
+			} else {
+				printk(KERN_INFO "ALT+SysRq+%c    %s\n",
+					sysrq_hot_key_table[i],
+					"Not defined");
 			}
 		}
 		printk("\n");



