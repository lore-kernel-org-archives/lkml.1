Return-Path: <linux-kernel-owner+w=401wt.eu-S1422981AbXCBJwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422981AbXCBJwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422983AbXCBJwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:52:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:42635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422981AbXCBJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:52:16 -0500
Message-ID: <45E7F3D0.7090105@suse.de>
Date: Fri, 02 Mar 2007 10:52:16 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch] Fixes and cleanups for earlyprintk aka boot console.
References: <45DADD15.7070809@suse.de> <20070301234645.09da8484.akpm@linux-foundation.org>
In-Reply-To: <20070301234645.09da8484.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------050608090001080206050201"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050608090001080206050201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Tue, 20 Feb 2007 12:35:49 +0100 Gerd Hoffmann <kraxel@suse.de> wrote:
> 
> It blows up on powerpc:

> drivers/built-in.o(.init.text+0x2080): In function `.console_init':
> : undefined reference to `.disable_early_printk'

Hmm, I think this is just a chunk being lost due to the clash with the
older version of the patch submitted as part of the xen series.

Here is the most recent version.  No code changes, comments updated (ack
from sh and mips arch maintainers).

Last patch queue mailed by Jeremy doesn't contain this one any more, so
the conflict should be gone now.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>

--------------050608090001080206050201
Content-Type: text/x-patch;
 name="early-printk-boot-console.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="early-printk-boot-console.patch"

Fixes and cleanups for earlyprintk aka boot console.

The console subsystem already has an idea of a boot console, using the
CON_BOOT flag.  The implementation has some flaws though.  The major
problem is that presence of a boot console makes register_console()
ignore any other console devices (unless explicitly specified on the
kernel command line).

This patch fixes the console selection code to *not* consider a boot
console a full-featured one, so the first non-boot console registering
will become the default console instead.  This way the unregister call
for the boot console in the register_console() function actually
triggers and the handover from the boot console to the real console
device works smoothly.  Added a printk for the handover, so you know
which console device the output goes to when the boot console stops
printing messages.

The disable_early_printk() call is obsolete with that patch, explicitly
disabling the early console isn't needed any more as it works
automagically with that patch.

I've walked through the tree, dropped all disable_early_printk()
instances found below arch/ and tagged the consoles with CON_BOOT if
needed.  The code is tested on x86, sh (thanks to Paul) and mips
(thanks to Ralf).

Signed-off-by: Gerd Hoffmann <kraxel@suse.de>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/alpha/kernel/setup.c         |    9 ---------
 arch/alpha/kernel/srmcons.c       |    2 +-
 arch/mips/cobalt/console.c        |    5 -----
 arch/mips/dec/prom/console.c      |    5 +----
 arch/mips/sgi-ip27/ip27-console.c |    5 -----
 arch/powerpc/kernel/udbg.c        |   14 +-------------
 arch/sh/kernel/early_printk.c     |   18 ++++++------------
 arch/sh64/kernel/early_printk.c   |    8 +-------
 arch/x86_64/kernel/early_printk.c |   20 +++++---------------
 drivers/char/tty_io.c             |    5 -----
 kernel/printk.c                   |   26 ++++++++++++++++----------
 11 files changed, 31 insertions(+), 86 deletions(-)

===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/x86_64/kernel/early_printk.c
+++ paravirt-2.6.20-git14-hg791/arch/x86_64/kernel/early_printk.c
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
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/kernel/printk.c
+++ paravirt-2.6.20-git14-hg791/kernel/printk.c
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
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/drivers/char/tty_io.c
+++ paravirt-2.6.20-git14-hg791/drivers/char/tty_io.c
@@ -141,8 +141,6 @@ static DECLARE_MUTEX(allocated_ptys_lock
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
-extern void disable_early_printk(void);
-
 static void initialize_tty_struct(struct tty_struct *tty);
 
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
@@ -3880,9 +3878,6 @@ void __init console_init(void)
 	 * set up the console device so that later boot sequences can 
 	 * inform about problems etc..
 	 */
-#ifdef CONFIG_EARLY_PRINTK
-	disable_early_printk();
-#endif
 	call = __con_initcall_start;
 	while (call < __con_initcall_end) {
 		(*call)();
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/alpha/kernel/setup.c
+++ paravirt-2.6.20-git14-hg791/arch/alpha/kernel/setup.c
@@ -744,15 +744,6 @@ setup_arch(char **cmdline_p)
 	paging_init();
 }
 
-void __init
-disable_early_printk(void)
-{
-	if (alpha_using_srm && srmcons_output) {
-		unregister_srm_console();
-		srmcons_output = 0;
-	}
-}
-
 static char sys_unknown[] = "Unknown";
 static char systype_names[][16] = {
 	"0",
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/alpha/kernel/srmcons.c
+++ paravirt-2.6.20-git14-hg791/arch/alpha/kernel/srmcons.c
@@ -300,7 +300,7 @@ static struct console srmcons = {
 	.write		= srm_console_write,
 	.device		= srm_console_device,
 	.setup		= srm_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER | CON_BOOT,
 	.index		= -1,
 };
 
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/mips/cobalt/console.c
+++ paravirt-2.6.20-git14-hg791/arch/mips/cobalt/console.c
@@ -40,8 +40,3 @@ void __init cobalt_early_console(void)
 
 	printk("Cobalt: early console registered\n");
 }
-
-void __init disable_early_printk(void)
-{
-	unregister_console(&cons_info);
-}
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/mips/dec/prom/console.c
+++ paravirt-2.6.20-git14-hg791/arch/mips/dec/prom/console.c
@@ -29,7 +29,7 @@ static void __init prom_console_write(st
 static struct console promcons __initdata = {
 	.name	= "prom",
 	.write	= prom_console_write,
-	.flags	= CON_PRINTBUFFER,
+	.flags	= CON_PRINTBUFFER | CON_BOOT,
 	.index	= -1,
 };
 
@@ -50,6 +50,3 @@ void __init unregister_prom_console(void
 		promcons_output = 0;
 	}
 }
-
-void disable_early_printk(void)
-	__attribute__((alias("unregister_prom_console")));
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/mips/sgi-ip27/ip27-console.c
+++ paravirt-2.6.20-git14-hg791/arch/mips/sgi-ip27/ip27-console.c
@@ -67,8 +67,3 @@ __init void ip27_setup_console(void)
 {
 	register_console(&ioc3_console);
 }
-
-void __init disable_early_printk(void)
-{
-	unregister_console(&ioc3_console);
-}
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/powerpc/kernel/udbg.c
+++ paravirt-2.6.20-git14-hg791/arch/powerpc/kernel/udbg.c
@@ -142,24 +142,12 @@ static void udbg_console_write(struct co
 static struct console udbg_console = {
 	.name	= "udbg",
 	.write	= udbg_console_write,
-	.flags	= CON_PRINTBUFFER | CON_ENABLED,
+	.flags	= CON_PRINTBUFFER | CON_ENABLED | CON_BOOT,
 	.index	= -1,
 };
 
 static int early_console_initialized;
 
-void __init disable_early_printk(void)
-{
-	if (!early_console_initialized)
-		return;
-	if (strstr(boot_command_line, "udbg-immortal")) {
-		printk(KERN_INFO "early console immortal !\n");
-		return;
-	}
-	unregister_console(&udbg_console);
-	early_console_initialized = 0;
-}
-
 /* called by setup_system */
 void register_early_udbg_console(void)
 {
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/sh/kernel/early_printk.c
+++ paravirt-2.6.20-git14-hg791/arch/sh/kernel/early_printk.c
@@ -192,20 +192,14 @@ int __init setup_early_printk(char *buf)
 	}
 #endif
 
-	if (likely(early_console))
+	if (likely(early_console)) {
+		if (keep_early)
+			early_console->flags &= ~CON_BOOT;
+		else
+			early_console->flags |= CON_BOOT;
 		register_console(early_console);
+	}
 
 	return 0;
 }
 early_param("earlyprintk", setup_early_printk);
-
-void __init disable_early_printk(void)
-{
-	if (!early_console_initialized || !early_console)
-		return;
-	if (!keep_early) {
-		printk("disabling early console\n");
-		unregister_console(early_console);
-	} else
-		printk("keeping early console\n");
-}
===================================================================
--- paravirt-2.6.20-git14-hg791.orig/arch/sh64/kernel/early_printk.c
+++ paravirt-2.6.20-git14-hg791/arch/sh64/kernel/early_printk.c
@@ -79,7 +79,7 @@ static struct console sh_console = {
 	.name		= "scifcon",
 	.write		= sh_console_write,
 	.setup		= sh_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER | CON_BOOT,
 	.index		= -1,
 };
 
@@ -97,9 +97,3 @@ void __init enable_early_printk(void)
 
 	register_console(&sh_console);
 }
-
-void disable_early_printk(void)
-{
-	unregister_console(&sh_console);
-}
-

--------------050608090001080206050201--
