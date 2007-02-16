Return-Path: <linux-kernel-owner+w=401wt.eu-S1161034AbXBPOtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbXBPOtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422643AbXBPOtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:49:18 -0500
Received: from ns1.suse.de ([195.135.220.2]:37260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422639AbXBPOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:49:17 -0500
Message-ID: <45D5C473.4010608@suse.de>
Date: Fri, 16 Feb 2007 15:49:23 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [patch] early printk and boot console fixups.
Content-Type: multipart/mixed;
 boundary="------------000904080709070802040407"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000904080709070802040407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

  Hi,

The console subsystem already has an idea of a boot console, using the
CON_BOOT flag.  The implementation has some flaws though.  The major
problem is that presence of a boot console makes register_console()
ignore any other console devices (unless explicitly specified on the
kernel command line).

This patch fixes the console selection code to *not* consider a boot
console a full-featured one, so the first "normal" console registering
will become the default boot console instead.  This way the unregister
call for the boot console in register_console() actually triggers and
the handover from the boot console to the real console device works
smoothly.

The patch also changes the x86 early_printk code to use this.  The early
console is simply tagged as boot console, the disable_early_printk()
call is gone as it isn't needed any more.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>

--------------000904080709070802040407
Content-Type: text/x-patch;
 name="early-printk-boot-console.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="early-printk-boot-console.patch"

---
 arch/x86_64/kernel/early_printk.c |   20 +++++---------------
 drivers/char/tty_io.c             |    5 -----
 kernel/printk.c                   |   26 ++++++++++++++++----------
 3 files changed, 21 insertions(+), 30 deletions(-)

Index: paravirt-2.6.20-hg770/arch/x86_64/kernel/early_printk.c
===================================================================
--- paravirt-2.6.20-hg770.orig/arch/x86_64/kernel/early_printk.c
+++ paravirt-2.6.20-hg770/arch/x86_64/kernel/early_printk.c
@@ -244,22 +244,12 @@ static int __init setup_early_printk(cha
  		early_console = &simnow_console;
  		keep_early = 1;
 	}
+
+	if (keep_early)
+		early_console->flags &= ~CON_BOOT;
+	else
+		early_console->flags |= CON_BOOT;
 	register_console(early_console);
 	return 0;
 }
-
 early_param("earlyprintk", setup_early_printk);
-
-void __init disable_early_printk(void)
-{
-	if (!early_console_initialized || !early_console)
-		return;
-	if (!keep_early) {
-		printk("disabling early console\n");
-		unregister_console(early_console);
-		early_console_initialized = 0;
-	} else {
-		printk("keeping early console\n");
-	}
-}
-
Index: paravirt-2.6.20-hg770/kernel/printk.c
===================================================================
--- paravirt-2.6.20-hg770.orig/kernel/printk.c
+++ paravirt-2.6.20-hg770/kernel/printk.c
@@ -931,8 +931,16 @@ void register_console(struct console *co
 {
 	int i;
 	unsigned long flags;
+	struct console *bootconsole = NULL;
 
-	if (preferred_console < 0)
+	if (console_drivers) {
+		if (console->flags & CON_BOOT)
+			return;
+		if (console_drivers->flags & CON_BOOT)
+			bootconsole = console_drivers;
+	}
+
+	if (preferred_console < 0 || bootconsole || !console_drivers)
 		preferred_console = selected_console;
 
 	/*
@@ -978,8 +986,11 @@ void register_console(struct console *co
 	if (!(console->flags & CON_ENABLED))
 		return;
 
-	if (console_drivers && (console_drivers->flags & CON_BOOT)) {
-		unregister_console(console_drivers);
+	if (bootconsole) {
+		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
+		       bootconsole->name, bootconsole->index,
+		       console->name, console->index);
+		unregister_console(bootconsole);
 		console->flags &= ~CON_PRINTBUFFER;
 	}
 
@@ -1030,16 +1041,11 @@ int unregister_console(struct console *c
 		}
 	}
 
-	/* If last console is removed, we re-enable picking the first
-	 * one that gets registered. Without that, pmac early boot console
-	 * would prevent fbcon from taking over.
-	 *
+	/*
 	 * If this isn't the last console and it has CON_CONSDEV set, we
 	 * need to set it on the next preferred console.
 	 */
-	if (console_drivers == NULL)
-		preferred_console = selected_console;
-	else if (console->flags & CON_CONSDEV)
+	if (console_drivers != NULL && console->flags & CON_CONSDEV)
 		console_drivers->flags |= CON_CONSDEV;
 
 	release_console_sem();
Index: paravirt-2.6.20-hg770/drivers/char/tty_io.c
===================================================================
--- paravirt-2.6.20-hg770.orig/drivers/char/tty_io.c
+++ paravirt-2.6.20-hg770/drivers/char/tty_io.c
@@ -141,8 +141,6 @@ static DECLARE_MUTEX(allocated_ptys_lock
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
-extern void disable_early_printk(void);
-
 static void initialize_tty_struct(struct tty_struct *tty);
 
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
@@ -3881,9 +3879,6 @@ void __init console_init(void)
 	 * set up the console device so that later boot sequences can 
 	 * inform about problems etc..
 	 */
-#ifdef CONFIG_EARLY_PRINTK
-	disable_early_printk();
-#endif
 	call = __con_initcall_start;
 	while (call < __con_initcall_end) {
 		(*call)();

--------------000904080709070802040407--
