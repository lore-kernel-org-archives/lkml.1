Return-Path: <linux-kernel-owner+w=401wt.eu-S933919AbXJQPW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbXJQPW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760396AbXJQPWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:22:21 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:16967 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758574AbXJQPWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=obTUV6KbVcHC2qCXXt4/BELWIQeP1568yHwachCln4qQ3ZAefTOup7YDkB1BHsvXe9SiwCXZg88oIC/5ImrhpDWY7wrRQTGqUf0+A3fNXfAf/P18Bp+XryU77sCK7DHNIGpIg7b8gnzEh1Goaw1YCs3o+VHi2NPbfcHIqS0AJ2E=
Message-ID: <471628D2.8010903@gmail.com>
Date: Wed, 17 Oct 2007 23:22:58 +0800
From: Yi Yang <yang.y.yi@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@osdl.org
CC: mj@atrey.karlin.mff.cuni.cz, crutcher+kernel@datastacks.com, pavel@ucw.cz,
       schwab@suse.de
Subject: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef key,
 try 2
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compared with last patch, this has a little change according to 
Andreas and Pavel's feedbacks.

For SysRq, we just can get hot key list from Documentation/sysrq.txt
, but in the most of cases, the user can't access it by hand on
using SysRq to debug, so it is better for SysRq to provide an online
help for the users.

SysRq has already provided a similiar help before this patch, but it
is not so clear that the user doesn't know what happened and what
he/she should do.

In addition, that funtion has a big loop with another big loop
embedded which is very inefficient, it is intended to skip some hot
key help info for such a function as "Changing Loglevel", just print
a help info for this, that is very unnecessary. In fact, the key '0'
 - '8' have different results the user should know.

This patch adds this online help function, it'll print the whole hot
key list and corresponding function descriptions, it can print the new
defined hot key without any changed needed.

The output is below on pressing an undefined hot key before this patch:

SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem
Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount
shoW-blocked-tasks

But after applying this patch, the output is:

SysRq : 
this hot key isn't defined.

SysRq Help Information:

Hot Key    Function Description
=======    ====================
   0       Changing Loglevel to this value
   1       Changing Loglevel to this value
   2       Changing Loglevel to this value
   3       Changing Loglevel to this value
   4       Changing Loglevel to this value
   5       Changing Loglevel to this value
   6       Changing Loglevel to this value
   7       Changing Loglevel to this value
   8       Changing Loglevel to this value
   9       Changing Loglevel to this value
   a       Not defined
   b       Resetting
   c       Trigger a crashdump
   d       Not defined
   e       Terminate All Tasks
   f       Manual OOM execution
   g       Not defined
   h       Not defined
   i       Kill All Tasks
   j       Not defined
   k       SAK
   l       Not defined
   m       Show Memory
   n       Nice All RT Tasks
   o       Power Off
   p       Show Regs
   q       Show Pending Timers
   r       Keyboard mode set to XLATE
   s       Emergency Sync
   t       Show State
   u       Emergency Remount R/O
   v       Not defined
   w       Show Blocked State
   x       Not defined
   y       Not defined
   z       Not defined

Signed-off-by: Yi Yang <yang.y.yi@gmail.com>
---
 sysrq.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)


--- a/drivers/char/sysrq.c	2007-10-16 18:32:58.000000000 +0800
+++ b/drivers/char/sysrq.c	2007-10-17 17:52:45.000000000 +0800
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
+	printk(KERN_INFO "SysRq : \n");
 
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
+		printk(KERN_INFO "this hot key isn't defined.\n\n");
+		printk(KERN_INFO "SysRq Help Information:\n\n");
+		printk(KERN_INFO "Hot Key    Function Description\n");
+		printk(KERN_INFO "=======    ====================\n");
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
+				printk(KERN_INFO "   %c       %s\n",
+					sysrq_hot_key_table[i],
+					sysrq_key_table[i]->action_msg);
+			} else {
+				printk(KERN_INFO "   %c       %s\n",
+					sysrq_hot_key_table[i],
+					"Not defined");
 			}
 		}
 		printk("\n");


