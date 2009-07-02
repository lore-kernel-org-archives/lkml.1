Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZGBBF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZGBBF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZGBBFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:05:50 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:18771 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbZGBBFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:05:49 -0400
X-IronPort-AV: E=Sophos;i="4.42,329,1243828800"; 
   d="scan'208";a="975497"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>
Subject: [PATCH] - printk handling more than one CON_BOOT
Date: Wed, 1 Jul 2009 21:08:37 -0400
User-Agent: KMail/1.9.5
CC: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <200906290703.21539.rgetz@blackfin.uclinux.org>
In-Reply-To: <200906290703.21539.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907012108.38030.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 02 Jul 2009 01:05:19.0083 (UTC) FILETIME=[2ACA5BB0:01C9FAB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Today, register_console() assumes the following usage:
  - The first console to register with a flag set to CON_BOOT is the
    one and only bootconsole.
  - If another register_console() is called with an additional CON_BOOT,
    it is silently rejected.
  - As soon as a console without the CON_BOOT set calls registers
    the bootconsole is automatically unregistered.
  - Once there is a "real" console - register_console() will silently
    reject any consoles with it's CON_BOOT flag set.

In many systems (alpha, blackfin, microblaze, mips, powerpc, sh, & x86), there 
are early_printk implementations, which use the CON_BOOT which come out 
serial ports, vga, usb, & memory buffers. In many embedded systems, it would 
be nice to have two bootconsoles - in case the primary fails, you always have
access to a backup memory buffer - but this requires at least two CON_BOOT
consoles...

This patch enables that functionality.


Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>

---

With the changeset, on boot you get (if you try to re-enable a boot console
after the "real" console has been registered):

root:/> dmesg | grep console
bootconsole [early_shadow0] enabled
bootconsole [early_BFuart0] enabled
Kernel command line: root=/dev/mtdblock0 rw earlyprintk=serial,uart0,57600 console=ttyBF0,57600 nmi_debug=regs
console handover:boot [early_BFuart0] boot [early_shadow0]  -> real [ttyBF0]
Too late to register bootconsole early_shadow0

or

root:/> dmesg | grep console
Kernel command line: root=/dev/mtdblock0 rw console=ttyBF0,57600
console [ttyBF0] enabled

 printk.c |  146 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 92 insertions(+), 54 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index b4d97b5..9acc262 100644
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
@@ -412,7 +418,7 @@ static void __call_console_drivers(unsigned start, unsigned end)
 {
 	struct console *con;
 
-	for (con = console_drivers; con; con = con->next) {
+	for_each_console(con) {
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
@@ -544,7 +550,7 @@ static int have_callable_console(void)
 {
 	struct console *con;
 
-	for (con = console_drivers; con; con = con->next)
+	for_each_console(con)
 		if (con->flags & CON_ANYTIME)
 			return 1;
 
@@ -1082,7 +1088,7 @@ void console_unblank(void)
 
 	console_locked = 1;
 	console_may_schedule = 0;
-	for (c = console_drivers; c != NULL; c = c->next)
+	for_each_console(c)
 		if ((c->flags & CON_ENABLED) && c->unblank)
 			c->unblank();
 	release_console_sem();
@@ -1097,7 +1103,7 @@ struct tty_driver *console_device(int *index)
 	struct tty_driver *driver = NULL;
 
 	acquire_console_sem();
-	for (c = console_drivers; c != NULL; c = c->next) {
+	for_each_console(c) {
 		if (!c->device)
 			continue;
 		driver = c->device(c, index);
@@ -1134,25 +1140,49 @@ EXPORT_SYMBOL(console_start);
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
+	
+	if (console_drivers && console_drivers->flags & CON_BOOT)
+		bcon = console_drivers;
 
-	if (preferred_console < 0 || bootconsole || !console_drivers)
+	if (preferred_console < 0 || bcon || !console_drivers)
 		preferred_console = selected_console;
 
-	if (console->early_setup)
-		console->early_setup();
+	if (newcon->early_setup)
+		newcon->early_setup();
 
 	/*
 	 *	See if we want to use this console driver. If we
@@ -1160,13 +1190,13 @@ void register_console(struct console *console)
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
@@ -1178,47 +1208,53 @@ void register_console(struct console *console)
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
+	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV)) {
+		/* we need to iterate through twice, to make sure we print
+		 * everything out, before we unregister the console(s)
+		 */
+		printk(KERN_INFO "console handover:");
+		for_each_console(bcon)
+			printk("boot [%s%d] ", bcon->name, bcon->index);
+		printk(" -> real [%s%d]\n", newcon->name, newcon->index);
+		for_each_console(bcon)
+			unregister_console(bcon);
+		newcon->flags &= ~CON_PRINTBUFFER;
 	} else {
-		printk(KERN_INFO "console [%s%d] enabled\n",
-		       console->name, console->index);
+		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+			(newcon->flags & CON_BOOT) ? "boot" : "" ,
+			newcon->name, newcon->index);
 	}
 
 	/*
@@ -1226,16 +1262,16 @@ void register_console(struct console *console)
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
@@ -1287,11 +1323,13 @@ EXPORT_SYMBOL(unregister_console);
 
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
+			return unregister_console(con);
 		}
 	}
 	return 0;
