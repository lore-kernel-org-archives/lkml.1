Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZBPUej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZBPUej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZBPUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:34:31 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:61451 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZBPUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:34:30 -0500
Message-ID: <4999CDCF.9040908@oracle.com>
Date: Mon, 16 Feb 2009 12:34:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC/PATCH] sysrq: add extension char/table handling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4999CDA4.016B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, [repeat from April-2008]

Ingo noticed that the sysrq table is close to filling up.
[It's full now, counting the optional & proposed/new entries.]
Has anyone thought about how to handle that condition?

Here's one patch for it, although I'm not entirely thrilled with it.
Any other suggestions?

Thanks.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

We are close to running out of empty sysrq table entries, so add a way to
extend sysrq handling.  This extension takes "SysRq=" + next_key to mean
"use the alternate sysrq table for handling of <next_key>".
This also works with "echo =X > /proc/sysrq-trigger".

SysRq help text now looks like this:

SysRq : HELP : loglevel(0-9) reBoot terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) 
SysRq-= HELP : sleep(Z) 

and SysRq=z produces:
SysRq : go to sleep (STR)
kernel wants to sleep

where SysRq=z (for sleep) is just an example.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/sysrq.txt |   19 +++++--
 drivers/char/keyboard.c |   10 +++
 drivers/char/sysrq.c    |  130 ++++++++++++++++++++++++++++++++++++++++++------
 include/linux/sysrq.h   |   15 ++++-
 4 files changed, 150 insertions(+), 24 deletions(-)

--- lnx2629-rc5.orig/include/linux/sysrq.h
+++ lnx2629-rc5/include/linux/sysrq.h
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
--- lnx2629-rc5.orig/drivers/char/keyboard.c
+++ lnx2629-rc5/drivers/char/keyboard.c
@@ -161,6 +161,7 @@ unsigned char kbd_sysrq_xlate[KEY_MAX + 
         "\r\000/";                                      /* 0x60 - 0x6f */
 static int sysrq_down;
 static int sysrq_alt_use;
+static int sysrq_extend;
 #endif
 static int sysrq_alt;
 
@@ -1191,7 +1192,14 @@ static void kbd_keycode(unsigned int key
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
--- lnx2629-rc5.orig/drivers/char/sysrq.c
+++ lnx2629-rc5/drivers/char/sysrq.c
@@ -372,7 +372,7 @@ static struct sysrq_key_op sysrq_unrt_op
 /* Key Operations table and lock */
 static DEFINE_SPINLOCK(sysrq_key_table_lock);
 
-static struct sysrq_key_op *sysrq_key_table[36] = {
+struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_loglevel_op,		/* 0 */
 	&sysrq_loglevel_op,		/* 1 */
 	&sysrq_loglevel_op,		/* 2 */
@@ -425,6 +425,56 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_ftrace_dump_op,		/* z */
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
@@ -442,30 +492,32 @@ static int sysrq_key_table_key2index(int
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
@@ -483,7 +535,7 @@ void __handle_sysrq(int key, struct tty_
 	console_loglevel = 7;
 	printk(KERN_INFO "SysRq : ");
 
-        op_p = __sysrq_get_key_op(key);
+        op_p = __sysrq_get_key_op(op_table, key);
         if (op_p) {
 		/*
 		 * Should we check for enabled operations (/proc/sysrq-trigger
@@ -498,7 +550,7 @@ void __handle_sysrq(int key, struct tty_
 		}
 	} else {
 		printk("HELP : ");
-		/* Only print the help msg once per handler */
+		/* Only print the help msg once per handler (per table) */
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
 			if (sysrq_key_table[i]) {
 				int j;
@@ -512,6 +564,22 @@ void __handle_sysrq(int key, struct tty_
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
@@ -524,20 +592,32 @@ void __handle_sysrq(int key, struct tty_
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
@@ -548,16 +628,28 @@ static int __sysrq_swap_key_ops(int key,
 
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
+
 #ifdef CONFIG_PROC_FS
 /*
  * writing 'C' to /proc/sysrq-trigger is like sysrq-C
@@ -570,7 +662,13 @@ static ssize_t write_sysrq_trigger(struc
 
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
--- lnx2629-rc5.orig/Documentation/sysrq.txt
+++ lnx2629-rc5/Documentation/sysrq.txt
@@ -38,13 +38,18 @@ allowed (by a user with admin privileges
 
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
@@ -57,9 +62,13 @@ On PowerPC - Press 'ALT - Print Screen (
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
@@ -180,10 +189,10 @@ for ten seconds.
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
