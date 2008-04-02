Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbYDBSSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbYDBSSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYDBSSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:18:02 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56353 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbYDBSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:17:59 -0400
Date: Wed, 2 Apr 2008 11:13:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: mingo <mingo@redhat.com>
Subject: [RFC/PATCH] sysrq: secondary sysrq key table
Message-Id: <20080402111338.ec543389.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo noticed that the sysrq table is close to filling up.
Has anyone thought about how to handle that condition?

Here's one patch for it, although I'm not entirely thrilled with it.
Any other suggestions?

Thanks.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

We are close to running out of empty sysrq table entries, so add a way to
extend sysrq handling.  This extension takes sysrq-= + next_key to mean
"use the alternate sysrq table for handling of <next_key>".
This also works with "echo =X > /proc/sysrq-trigger".

SysRq help text now looks like this:

SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks 
SysRq-= HELP : sleep(Z)

where SysRq-=-z (for sleep) is just an example.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/sysrq.txt |   21 +++++---
 drivers/char/keyboard.c |   10 +++
 drivers/char/sysrq.c    |  122 ++++++++++++++++++++++++++++++++++++++++++------
 fs/proc/proc_misc.c     |    8 ++-
 include/linux/sysrq.h   |   15 +++++
 5 files changed, 151 insertions(+), 25 deletions(-)

--- linux-2.6.25-rc7-git6.orig/include/linux/sysrq.h
+++ linux-2.6.25-rc7-git6/include/linux/sysrq.h
@@ -37,6 +37,9 @@ struct sysrq_key_op {
 
 #ifdef CONFIG_MAGIC_SYSRQ
 
+/* used to extend primary sysrq key table to secondary key table */
+#define SYSRQ_EXTEND_KEY	'='
+
 extern int sysrq_on(void);
 
 /*
@@ -50,10 +53,15 @@ extern int __sysrq_enabled;
  */
 
 void handle_sysrq(int key, struct tty_struct *tty);
-void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
+void handle_sysrq_extend(int key, struct tty_struct *tty);
+void __handle_sysrq(struct sysrq_key_op **op_table, int key,
+			struct tty_struct *tty, int check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
-struct sysrq_key_op *__sysrq_get_key_op(int key);
+struct sysrq_key_op *__sysrq_get_key_op(struct sysrq_key_op **op_table, int key);
+
+extern struct sysrq_key_op *sysrq_key_table[36];
+extern struct sysrq_key_op *sysrq_key_table2[36];
 
 #else
 
@@ -68,6 +76,9 @@ static inline int __reterr(void)
 static inline void handle_sysrq(int key, struct tty_struct *tty)
 {
 }
+static inline void handle_sysrq_extend(int key, struct tty_struct *tty)
+{
+}
 
 #define register_sysrq_key(ig,nore) __reterr()
 #define unregister_sysrq_key(ig,nore) __reterr()
--- linux-2.6.25-rc7-git6.orig/drivers/char/keyboard.c
+++ linux-2.6.25-rc7-git6/drivers/char/keyboard.c
@@ -157,6 +157,7 @@ unsigned char kbd_sysrq_xlate[KEY_MAX + 
         "\r\000/";                                      /* 0x60 - 0x6f */
 static int sysrq_down;
 static int sysrq_alt_use;
+static int sysrq_extend;
 #endif
 static int sysrq_alt;
 
@@ -1189,7 +1190,14 @@ static void kbd_keycode(unsigned int key
 	if (sysrq_down && !down && keycode == sysrq_alt_use)
 		sysrq_down = 0;
 	if (sysrq_down && down && !rep) {
-		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
+		if (sysrq_extend) {
+			handle_sysrq_extend(kbd_sysrq_xlate[keycode], tty);
+			sysrq_extend = 0;
+		}
+		else if (kbd_sysrq_xlate[keycode] == SYSRQ_EXTEND_KEY)
+			sysrq_extend = 1;
+		else
+			handle_sysrq(kbd_sysrq_xlate[keycode], tty);
 		return;
 	}
 #endif
--- linux-2.6.25-rc7-git6.orig/drivers/char/sysrq.c
+++ linux-2.6.25-rc7-git6/drivers/char/sysrq.c
@@ -313,7 +313,7 @@ static struct sysrq_key_op sysrq_unrt_op
 /* Key Operations table and lock */
 static DEFINE_SPINLOCK(sysrq_key_table_lock);
 
-static struct sysrq_key_op *sysrq_key_table[36] = {
+struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_loglevel_op,		/* 0 */
 	&sysrq_loglevel_op,		/* 1 */
 	&sysrq_loglevel_op,		/* 2 */
@@ -361,6 +361,56 @@ static struct sysrq_key_op *sysrq_key_ta
 	NULL				/* z */
 };
 
+static void sysrq2_handle_sleep(int key, struct tty_struct *tty)
+{
+	printk(KERN_DEBUG "kernel wants to sleep\n");
+}
+static struct sysrq_key_op sysrq2_sleep_op = {
+	.handler	= sysrq2_handle_sleep,
+	.help_msg	= "sleep(Z)",
+	.action_msg	= "go to sleep (STR)",
+};
+
+struct sysrq_key_op *sysrq_key_table2[36] = {
+	NULL,				/* 0 */
+	NULL,				/* 1 */
+	NULL,				/* 2 */
+	NULL,				/* 3 */
+	NULL,				/* 4 */
+	NULL,				/* 5 */
+	NULL,				/* 6 */
+	NULL,				/* 7 */
+	NULL,				/* 8 */
+	NULL,				/* 9 */
+
+	NULL,				/* a */
+	NULL,				/* b */
+	NULL,				/* c */
+	NULL,				/* d */
+	NULL,				/* e */
+	NULL,				/* f */
+	NULL,				/* g */
+	NULL,				/* h */
+	NULL,				/* i */
+	NULL,				/* j */
+	NULL,				/* k */
+	NULL,				/* l */
+	NULL,				/* m */
+	NULL,				/* n */
+	NULL,				/* o */
+	NULL,				/* p */
+	NULL,				/* q */
+	NULL,				/* r */
+	NULL,				/* s */
+	NULL,				/* t */
+	NULL,				/* u */
+	NULL,				/* v */
+	NULL,				/* w */
+	NULL,				/* x */
+	NULL,				/* y */
+	&sysrq2_sleep_op		/* z */
+};
+
 /* key2index calculation, -1 on invalid index */
 static int sysrq_key_table_key2index(int key)
 {
@@ -378,30 +428,32 @@ static int sysrq_key_table_key2index(int
 /*
  * get and put functions for the table, exposed to modules.
  */
-struct sysrq_key_op *__sysrq_get_key_op(int key)
+struct sysrq_key_op *__sysrq_get_key_op(struct sysrq_key_op **op_table, int key)
 {
         struct sysrq_key_op *op_p = NULL;
         int i;
 
 	i = sysrq_key_table_key2index(key);
 	if (i != -1)
-	        op_p = sysrq_key_table[i];
+	        op_p = op_table[i];
         return op_p;
 }
 
-static void __sysrq_put_key_op(int key, struct sysrq_key_op *op_p)
+static void __sysrq_put_key_op(struct sysrq_key_op **op_table, int key,
+				struct sysrq_key_op *op_p)
 {
         int i = sysrq_key_table_key2index(key);
 
         if (i != -1)
-                sysrq_key_table[i] = op_p;
+                op_table[i] = op_p;
 }
 
 /*
  * This is the non-locking version of handle_sysrq.  It must/can only be called
  * by sysrq key handlers, as they are inside of the lock
  */
-void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
+void __handle_sysrq(struct sysrq_key_op **op_table, int key,
+			struct tty_struct *tty, int check_mask)
 {
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
@@ -413,7 +465,7 @@ void __handle_sysrq(int key, struct tty_
 	console_loglevel = 7;
 	printk(KERN_INFO "SysRq : ");
 
-        op_p = __sysrq_get_key_op(key);
+        op_p = __sysrq_get_key_op(op_table, key);
         if (op_p) {
 		/*
 		 * Should we check for enabled operations (/proc/sysrq-trigger
@@ -428,7 +480,7 @@ void __handle_sysrq(int key, struct tty_
 		}
 	} else {
 		printk("HELP : ");
-		/* Only print the help msg once per handler */
+		/* Only print the help msg once per handler (per table) */
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
 			if (sysrq_key_table[i]) {
 				int j;
@@ -442,6 +494,22 @@ void __handle_sysrq(int key, struct tty_
 			}
 		}
 		printk("\n");
+
+		/* Help from table2 */
+		printk("SysRq-%c HELP : ", SYSRQ_EXTEND_KEY);
+		for (i = 0; i < ARRAY_SIZE(sysrq_key_table2); i++) {
+			if (sysrq_key_table2[i]) {
+				int j;
+
+				for (j = 0; sysrq_key_table2[i] !=
+						sysrq_key_table2[j]; j++)
+					;
+				if (j != i)
+					continue;
+				printk("%s ", sysrq_key_table2[i]->help_msg);
+			}
+		}
+		printk("\n");
 		console_loglevel = orig_log_level;
 	}
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
@@ -454,20 +522,32 @@ void __handle_sysrq(int key, struct tty_
 void handle_sysrq(int key, struct tty_struct *tty)
 {
 	if (sysrq_on())
-		__handle_sysrq(key, tty, 1);
+		__handle_sysrq(sysrq_key_table, key, tty, 1);
 }
 EXPORT_SYMBOL(handle_sysrq);
 
-static int __sysrq_swap_key_ops(int key, struct sysrq_key_op *insert_op_p,
-                                struct sysrq_key_op *remove_op_p)
+/*
+ * This function is called by the keyboard handler when SysRq+EXTEND_KEY is pressed
+ * and any other keycode arrives.
+ */
+void handle_sysrq_extend(int key, struct tty_struct *tty)
+{
+	if (sysrq_on())
+		__handle_sysrq(sysrq_key_table2, key, tty, 1);
+}
+EXPORT_SYMBOL(handle_sysrq_extend);
+
+static int __sysrq_swap_key_ops(struct sysrq_key_op **op_table, int key,
+				struct sysrq_key_op *insert_op_p,
+				struct sysrq_key_op *remove_op_p)
 {
 
 	int retval;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
-	if (__sysrq_get_key_op(key) == remove_op_p) {
-		__sysrq_put_key_op(key, insert_op_p);
+	if (__sysrq_get_key_op(op_table, key) == remove_op_p) {
+		__sysrq_put_key_op(op_table, key, insert_op_p);
 		retval = 0;
 	} else {
 		retval = -1;
@@ -478,12 +558,24 @@ static int __sysrq_swap_key_ops(int key,
 
 int register_sysrq_key(int key, struct sysrq_key_op *op_p)
 {
-	return __sysrq_swap_key_ops(key, op_p, NULL);
+	return __sysrq_swap_key_ops(sysrq_key_table, key, op_p, NULL);
 }
 EXPORT_SYMBOL(register_sysrq_key);
 
 int unregister_sysrq_key(int key, struct sysrq_key_op *op_p)
 {
-	return __sysrq_swap_key_ops(key, NULL, op_p);
+	return __sysrq_swap_key_ops(sysrq_key_table, key, NULL, op_p);
 }
 EXPORT_SYMBOL(unregister_sysrq_key);
+
+int register_sysrq_key_extend(int key, struct sysrq_key_op *op_p)
+{
+	return __sysrq_swap_key_ops(sysrq_key_table2, key, op_p, NULL);
+}
+EXPORT_SYMBOL(register_sysrq_key_extend);
+
+int unregister_sysrq_key_extend(int key, struct sysrq_key_op *op_p)
+{
+	return __sysrq_swap_key_ops(sysrq_key_table2, key, NULL, op_p);
+}
+EXPORT_SYMBOL(unregister_sysrq_key_extend);
--- linux-2.6.25-rc7-git6.orig/fs/proc/proc_misc.c
+++ linux-2.6.25-rc7-git6/fs/proc/proc_misc.c
@@ -669,7 +669,13 @@ static ssize_t write_sysrq_trigger(struc
 
 		if (get_user(c, buf))
 			return -EFAULT;
-		__handle_sysrq(c, NULL, 0);
+		if (c == SYSRQ_EXTEND_KEY) {
+			if (count <= 1 || get_user(c, buf + 1))
+				return -EFAULT;
+			__handle_sysrq(sysrq_key_table2, c, NULL, 0);
+		}
+		else
+			__handle_sysrq(sysrq_key_table, c, NULL, 0);
 	}
 	return count;
 }
--- linux-2.6.25-rc7-git6.orig/Documentation/sysrq.txt
+++ linux-2.6.25-rc7-git6/Documentation/sysrq.txt
@@ -1,6 +1,6 @@
 Linux Magic System Request Key Hacks
 Documentation for sysrq.c
-Last update: 2007-AUG-04
+Last update: 2008-APR-01
 
 *  What is the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -39,13 +39,18 @@ allowed (by a user with admin privileges
 
 *  How do I use the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-On x86   - You press the key combo 'ALT-SysRq-<command key>'. Note - Some
+On x86   - You press the key combo 'ALT-SysRq-<command key>'. Note: Some
            keyboards may not have a key labeled 'SysRq'. The 'SysRq' key is
            also known as the 'Print Screen' key. Also some keyboards cannot
 	   handle so many keys being pressed at the same time, so you might
 	   have better luck with "press Alt", "press SysRq", "release SysRq",
 	   "press <command key>", release everything.
 
+	   Extended SysRq key handling is indicated by using
+	   'ALT-SysRq-=-<command key>'.  The Alt and SysRq keys should be
+	   held down while pressing the '=' key and the following
+	   command key.
+
 On SPARC - You press 'ALT-STOP-<command key>', I believe.
 
 On the serial console (PC style standard serial ports only) -
@@ -58,9 +63,13 @@ On PowerPC - Press 'ALT - Print Screen (
 On other - If you know of the key combos for other architectures, please
            let me know so I can add them to this section.
 
-On all -  write a character to /proc/sysrq-trigger.  e.g.:
+On all -  write a character(s) to /proc/sysrq-trigger.  E.g.:
 
 		echo t > /proc/sysrq-trigger
+	  or
+		echo =z > /proc/sysrq-trigger
+
+	  for extended SysRq key handling.
 
 *  What are the 'command' keys?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -177,10 +186,10 @@ for ten seconds.
 *  I want to add SysRQ key events to a module, how does it work?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 In order to register a basic function with the table, you must first include
-the header 'include/linux/sysrq.h', this will define everything else you need.
+the header 'include/linux/sysrq.h'. This will define everything else you need.
 Next, you must create a sysrq_key_op struct, and populate it with A) the key
-handler function you will use, B) a help_msg string, that will print when SysRQ
-prints help, and C) an action_msg string, that will print right before your
+handler function you will use, B) a help_msg string that will print when SysRQ
+prints help, and C) an action_msg string that will print right before your
 handler is called. Your handler must conform to the prototype in 'sysrq.h'.
 
 After the sysrq_key_op is created, you can call the kernel function
