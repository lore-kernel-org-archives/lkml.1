Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXCBHqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXCBHqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbXCBHqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:46:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47348 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbXCBHqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:46:51 -0500
Date: Thu, 1 Mar 2007 23:46:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch] Fixes and cleanups for earlyprintk aka boot console.
Message-Id: <20070301234645.09da8484.akpm@linux-foundation.org>
In-Reply-To: <45DADD15.7070809@suse.de>
References: <45DADD15.7070809@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 12:35:49 +0100 Gerd Hoffmann <kraxel@suse.de> wrote:

> The console subsystem already has an idea of a boot console, using the
> CON_BOOT flag.  The implementation has some flaws though.  The major
> problem is that presence of a boot console makes register_console()
> ignore any other console devices (unless explicitly specified on the
> kernel command line).
> 
> This patch fixes the console selection code to *not* consider a boot
> console a full-featured one, so the first non-boot console registering
> will become the default console instead.  This way the unregister call
> for the boot console in the register_console() function actually
> triggers and the handover from the boot console to the real console
> device works smoothly.  Added a printk for the handover, so you know
> which console device the output goes to when the boot console stops
> printing messages.
> 
> The disable_early_printk() call is obsolete with that patch, explicitly
> disabling the early console isn't needed any more as it works
> automagically with that patch.
> 
> I've walked through the tree, dropped all disable_early_printk()
> instances found below arch/ and tagged the consoles with CON_BOOT if
> needed.
> 
> The code is tested on x86 only so far.  It is probably a good idea to
> run it in -mm for a while to shake out any architecture issues which
> might show up.  Comments?

It blows up on powerpc:

drivers/built-in.o(.init.text+0x2080): In function `.console_init':
: undefined reference to `.disable_early_printk'

and the below patch might help.

But my confidence level isn't high so I'll drop it for now.  I have a feeling
this will need careful testing.

--- a/arch/x86_64/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console-fix
+++ a/arch/x86_64/kernel/early_printk.c
@@ -249,17 +249,3 @@ static int __init setup_early_printk(cha
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
-		early_console_initialized = 0;
-	} else {
-		printk("keeping early console\n");
-	}
-}
-
diff -puN drivers/char/tty_io.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console-fix drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console-fix
+++ a/drivers/char/tty_io.c
@@ -141,8 +141,6 @@ static DECLARE_MUTEX(allocated_ptys_lock
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
-extern void disable_early_printk(void);
-
 static void initialize_tty_struct(struct tty_struct *tty);
 
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
@@ -3889,13 +3887,6 @@ void __init console_init(void)
 	/* Setup the default TTY line discipline. */
 	(void) tty_register_ldisc(N_TTY, &tty_ldisc_N_TTY);
 
-	/*
-	 * set up the console device so that later boot sequences can 
-	 * inform about problems etc..
-	 */
-#ifdef CONFIG_EARLY_PRINTK
-	disable_early_printk();
-#endif
 	call = __con_initcall_start;
 	while (call < __con_initcall_end) {
 		(*call)();
_

