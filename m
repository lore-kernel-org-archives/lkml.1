Return-Path: <linux-kernel-owner+w=401wt.eu-S1765988AbXJROtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765988AbXJROtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXJROtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:49:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:12912 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbXJROtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=YJKOUwTuKgRo3HW/ohiif+Xj9cX90ALj2w51odOXIDJ9sM8+qS/BgByxZUIGg70Peku9/3pKzV8DvyxeCwqHl2NIm6L9KNcDmp1T4+f1aC0mdT0d4eATmuNKH7woxAnko438XleUtS3yTYtHyUOojl9kOxkAwklI/hE+2HCKl/E=
Message-ID: <4717728C.2070401@gmail.com>
Date: Thu, 18 Oct 2007 22:49:48 +0800
From: Yi Yang <yang.y.yi@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@osdl.org
CC: mj@atrey.karlin.mff.cuni.cz, pavel@atrey.karlin.mff.cuni.cz,
       Valdis.Kletnieks@vt.edu, elendil@planet.nl
Subject: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef key,
 try 3
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compared to try 2, there are some little changes according to Valdis and Frans' 
feedbacks.

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
  0-8      Changing Loglevel To 0-8
   b       Resetting
   c       Trigger a crashdump
   e       Terminate All Tasks
   f       Manual OOM execution
   i       Kill All Tasks
   k       SAK
   m       Show Memory
   n       Nice All RT Tasks
   o       Power Off
   p       Show Regs
   q       Show Pending Timers
   r       Keyboard mode set to XLATE
   s       Emergency Sync
   t       Show State
   u       Emergency Remount R/O
   w       Show Blocked State

Signed-off-by: Yi Yang <yang.y.yi@gmail.com>
---
 sysrq.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/char/sysrq.c	2007-10-16 18:32:58.000000000 +0800
+++ b/drivers/char/sysrq.c	2007-10-18 19:32:13.000000000 +0800
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
@@ -410,7 +420,7 @@ void __handle_sysrq(int key, struct tty_
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
 	orig_log_level = console_loglevel;
 	console_loglevel = 7;
-	printk(KERN_INFO "SysRq : ");
+	printk(KERN_INFO "SysRq : \n");
 
         op_p = __sysrq_get_key_op(key);
         if (op_p) {
@@ -426,19 +436,23 @@ void __handle_sysrq(int key, struct tty_
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
+		printk(KERN_INFO "  0-8      %s To 0-8\n",
+			sysrq_loglevel_op.action_msg);
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
-			if (sysrq_key_table[i]) {
-				int j;
+			if (sysrq_key_table[i] == &sysrq_loglevel_op)
+				continue;
 
-				for (j = 0; sysrq_key_table[i] !=
-						sysrq_key_table[j]; j++)
-					;
-				if (j != i)
-					continue;
-				printk("%s ", sysrq_key_table[i]->help_msg);
-			}
+			if (sysrq_key_table[i])
+				printk(KERN_INFO "   %c       %s\n",
+					sysrq_hot_key_table[i],
+					sysrq_key_table[i]->action_msg);
 		}
 		printk("\n");
 		console_loglevel = orig_log_level;


