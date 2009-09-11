Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZIKSza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZIKSza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZIKSz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:55:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZIKSz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:55:28 -0400
Date: Fri, 11 Sep 2009 20:55:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] core/printk for v2.6.32
Message-ID: <20090911185522.GA10700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-printk-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-printk-for-linus

 Thanks,

	Ingo

------------------>
Frans Pop (1):
      printk: Restore previous console_loglevel when re-enabling logging

Robin Getz (2):
      printk: Enable the use of more than one CON_BOOT (early console)
      printk: Ensure that "console enabled" messages are printed on the console

Sonic Zhang (1):
      printk: Fix "printk: Enable the use of more than one CON_BOOT (early console)"


 kernel/printk.c |  175 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 118 insertions(+), 57 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index b4d97b5..e10d193 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -37,6 +37,12 @@
 #include <asm/uaccess.h>
 
 /*
+ * for_each_console() allows you to iterate on each console
+ */
+#define for_each_console(con) \
+	for (con = console_drivers; con != NULL; con = con->next)
+
+/*
  * Architectures can override it:
  */
 void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
@@ -61,6 +67,8 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
+static int saved_console_loglevel = -1;
+
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -372,10 +380,15 @@ int do_syslog(int type, char __user *buf, int len)
 		logged_chars = 0;
 		break;
 	case 6:		/* Disable logging to console */
+		if (saved_console_loglevel == -1)
+			saved_console_loglevel = console_loglevel;
 		console_loglevel = minimum_console_loglevel;
 		break;
 	case 7:		/* Enable logging to console */
-		console_loglevel = default_console_loglevel;
+		if (saved_console_loglevel != -1) {
+			console_loglevel = saved_console_loglevel;
+			saved_console_loglevel = -1;
+		}
 		break;
 	case 8:		/* Set level of messages printed to console */
 		error = -EINVAL;
@@ -384,6 +397,8 @@ int do_syslog(int type, char __user *buf, int len)
 		if (len < minimum_console_loglevel)
 			len = minimum_console_loglevel;
 		console_loglevel = len;
+		/* Implicitly re-enable logging to console */
+		saved_console_loglevel = -1;
 		error = 0;
 		break;
 	case 9:		/* Number of chars in the log buffer */
@@ -412,7 +427,7 @@ static void __call_console_drivers(unsigned start, unsigned end)
 {
 	struct console *con;
 
-	for (con = console_drivers; con; con = con->next) {
+	for_each_console(con) {
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
@@ -544,7 +559,7 @@ static int have_callable_console(void)
 {
 	struct console *con;
 
-	for (con = console_drivers; con; con = con->next)
+	for_each_console(con)
 		if (con->flags & CON_ANYTIME)
 			return 1;
 
@@ -1082,7 +1097,7 @@ void console_unblank(void)
 
 	console_locked = 1;
 	console_may_schedule = 0;
-	for (c = console_drivers; c != NULL; c = c->next)
+	for_each_console(c)
 		if ((c->flags & CON_ENABLED) && c->unblank)
 			c->unblank();
 	release_console_sem();
@@ -1097,7 +1112,7 @@ struct tty_driver *console_device(int *index)
 	struct tty_driver *driver = NULL;
 
 	acquire_console_sem();
-	for (c = console_drivers; c != NULL; c = c->next) {
+	for_each_console(c) {
 		if (!c->device)
 			continue;
 		driver = c->device(c, index);
@@ -1134,25 +1149,49 @@ EXPORT_SYMBOL(console_start);
  * to register the console printing procedure with printk() and to
  * print any messages that were printed by the kernel before the
  * console driver was initialized.
+ *
+ * This can happen pretty early during the boot process (because of
+ * early_printk) - sometimes before setup_arch() completes - be careful
+ * of what kernel features are used - they may not be initialised yet.
+ *
+ * There are two types of consoles - bootconsoles (early_printk) and
+ * "real" consoles (everything which is not a bootconsole) which are
+ * handled differently.
+ *  - Any number of bootconsoles can be registered at any time.
+ *  - As soon as a "real" console is registered, all bootconsoles
+ *    will be unregistered automatically.
+ *  - Once a "real" console is registered, any attempt to register a
+ *    bootconsoles will be rejected
  */
-void register_console(struct console *console)
+void register_console(struct console *newcon)
 {
 	int i;
 	unsigned long flags;
-	struct console *bootconsole = NULL;
+	struct console *bcon = NULL;
 
-	if (console_drivers) {
-		if (console->flags & CON_BOOT)
-			return;
-		if (console_drivers->flags & CON_BOOT)
-			bootconsole = console_drivers;
+	/*
+	 * before we register a new CON_BOOT console, make sure we don't
+	 * already have a valid console
+	 */
+	if (console_drivers && newcon->flags & CON_BOOT) {
+		/* find the last or real console */
+		for_each_console(bcon) {
+			if (!(bcon->flags & CON_BOOT)) {
+				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
+					newcon->name, newcon->index);
+				return;
+			}
+		}
 	}
 
-	if (preferred_console < 0 || bootconsole || !console_drivers)
+	if (console_drivers && console_drivers->flags & CON_BOOT)
+		bcon = console_drivers;
+
+	if (preferred_console < 0 || bcon || !console_drivers)
 		preferred_console = selected_console;
 
-	if (console->early_setup)
-		console->early_setup();
+	if (newcon->early_setup)
+		newcon->early_setup();
 
 	/*
 	 *	See if we want to use this console driver. If we
@@ -1160,13 +1199,13 @@ void register_console(struct console *console)
 	 *	that registers here.
 	 */
 	if (preferred_console < 0) {
-		if (console->index < 0)
-			console->index = 0;
-		if (console->setup == NULL ||
-		    console->setup(console, NULL) == 0) {
-			console->flags |= CON_ENABLED;
-			if (console->device) {
-				console->flags |= CON_CONSDEV;
+		if (newcon->index < 0)
+			newcon->index = 0;
+		if (newcon->setup == NULL ||
+		    newcon->setup(newcon, NULL) == 0) {
+			newcon->flags |= CON_ENABLED;
+			if (newcon->device) {
+				newcon->flags |= CON_CONSDEV;
 				preferred_console = 0;
 			}
 		}
@@ -1178,64 +1217,62 @@ void register_console(struct console *console)
 	 */
 	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
 			i++) {
-		if (strcmp(console_cmdline[i].name, console->name) != 0)
+		if (strcmp(console_cmdline[i].name, newcon->name) != 0)
 			continue;
-		if (console->index >= 0 &&
-		    console->index != console_cmdline[i].index)
+		if (newcon->index >= 0 &&
+		    newcon->index != console_cmdline[i].index)
 			continue;
-		if (console->index < 0)
-			console->index = console_cmdline[i].index;
+		if (newcon->index < 0)
+			newcon->index = console_cmdline[i].index;
 #ifdef CONFIG_A11Y_BRAILLE_CONSOLE
 		if (console_cmdline[i].brl_options) {
-			console->flags |= CON_BRL;
-			braille_register_console(console,
+			newcon->flags |= CON_BRL;
+			braille_register_console(newcon,
 					console_cmdline[i].index,
 					console_cmdline[i].options,
 					console_cmdline[i].brl_options);
 			return;
 		}
 #endif
-		if (console->setup &&
-		    console->setup(console, console_cmdline[i].options) != 0)
+		if (newcon->setup &&
+		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
-		console->flags |= CON_ENABLED;
-		console->index = console_cmdline[i].index;
+		newcon->flags |= CON_ENABLED;
+		newcon->index = console_cmdline[i].index;
 		if (i == selected_console) {
-			console->flags |= CON_CONSDEV;
+			newcon->flags |= CON_CONSDEV;
 			preferred_console = selected_console;
 		}
 		break;
 	}
 
-	if (!(console->flags & CON_ENABLED))
+	if (!(newcon->flags & CON_ENABLED))
 		return;
 
-	if (bootconsole && (console->flags & CON_CONSDEV)) {
-		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
-		       bootconsole->name, bootconsole->index,
-		       console->name, console->index);
-		unregister_console(bootconsole);
-		console->flags &= ~CON_PRINTBUFFER;
-	} else {
-		printk(KERN_INFO "console [%s%d] enabled\n",
-		       console->name, console->index);
-	}
+	/*
+	 * If we have a bootconsole, and are switching to a real console,
+	 * don't print everything out again, since when the boot console, and
+	 * the real console are the same physical device, it's annoying to
+	 * see the beginning boot messages twice
+	 */
+	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV))
+		newcon->flags &= ~CON_PRINTBUFFER;
 
 	/*
 	 *	Put this console in the list - keep the
 	 *	preferred driver at the head of the list.
 	 */
 	acquire_console_sem();
-	if ((console->flags & CON_CONSDEV) || console_drivers == NULL) {
-		console->next = console_drivers;
-		console_drivers = console;
-		if (console->next)
-			console->next->flags &= ~CON_CONSDEV;
+	if ((newcon->flags & CON_CONSDEV) || console_drivers == NULL) {
+		newcon->next = console_drivers;
+		console_drivers = newcon;
+		if (newcon->next)
+			newcon->next->flags &= ~CON_CONSDEV;
 	} else {
-		console->next = console_drivers->next;
-		console_drivers->next = console;
+		newcon->next = console_drivers->next;
+		console_drivers->next = newcon;
 	}
-	if (console->flags & CON_PRINTBUFFER) {
+	if (newcon->flags & CON_PRINTBUFFER) {
 		/*
 		 * release_console_sem() will print out the buffered messages
 		 * for us.
@@ -1245,6 +1282,28 @@ void register_console(struct console *console)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+
+	/*
+	 * By unregistering the bootconsoles after we enable the real console
+	 * we get the "console xxx enabled" message on all the consoles -
+	 * boot consoles, real consoles, etc - this is to ensure that end
+	 * users know there might be something in the kernel's log buffer that
+	 * went to the bootconsole (that they do not see on the real console)
+	 */
+	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV)) {
+		/* we need to iterate through twice, to make sure we print
+		 * everything out, before we unregister the console(s)
+		 */
+		printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
+			newcon->name, newcon->index);
+		for_each_console(bcon)
+			if (bcon->flags & CON_BOOT)
+				unregister_console(bcon);
+	} else {
+		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+			(newcon->flags & CON_BOOT) ? "boot" : "" ,
+			newcon->name, newcon->index);
+	}
 }
 EXPORT_SYMBOL(register_console);
 
@@ -1287,11 +1346,13 @@ EXPORT_SYMBOL(unregister_console);
 
 static int __init disable_boot_consoles(void)
 {
-	if (console_drivers != NULL) {
-		if (console_drivers->flags & CON_BOOT) {
+	struct console *con;
+
+	for_each_console(con) {
+		if (con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
-				console_drivers->name, console_drivers->index);
-			return unregister_console(console_drivers);
+				con->name, con->index);
+			unregister_console(con);
 		}
 	}
 	return 0;
