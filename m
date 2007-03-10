Return-Path: <linux-kernel-owner+w=401wt.eu-S1767607AbXCJAGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767607AbXCJAGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767659AbXCJAGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:06:33 -0500
Received: from yvrmail01.intrinsyc.com ([209.139.192.246]:18835 "EHLO
	yvrmail01.intrinsyc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767607AbXCJAGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:06:32 -0500
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in
	VT_AUTO/KD_GRAPHICS mode
From: Andrew Johnson <ajohnson@intrinsyc.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070309211910.GD6374@ucw.cz>
References: <1173394485.28589.17.camel@localhost.localdomain>
	 <20070309090805.GA5822@atrey.karlin.mff.cuni.cz>
	 <20070309153456.GA28664@srcf.ucam.org>
	 <1173466942.29923.6.camel@localhost.localdomain>
	 <20070309211910.GD6374@ucw.cz>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 16:05:42 -0800
Message-Id: <1173485142.30345.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2007 00:06:45.0671 (UTC) FILETIME=[FD937B70:01C762A7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-03 at 13:19 -0800, Pavel Machek wrote:
> Hi!
> 
> > 
> > -void set_console(int nr)
> > +extern char vt_dont_switch;
> > +
> 
> What does this variable do and why do we want to use it here?
> 
It's needed in set_console().  Console switch will fail if this is true.

> 'if ('
> 
> > +             (vc->vt_mode.mode != VT_PROCESS && vc->vc_mode ==
> KD_GRAPHICS)) {
> > +
> > +             return -EINVAL;
> > +     }
> > +
> 
> I assume you want ...mode == VT_AUTO here?
> 
> And big comment explaining why we want this behaviour?
> 
> And another big comment explaining why this will not break existing
> set_console() users?
> 
See updated comment in attached patch.

> > -     set_console(SUSPEND_CONSOLE);
> > +     if (set_console(SUSPEND_CONSOLE)) {
> > +             /* Unable to change to the new console */
> 
> That's not what the comment should say.
> 
> It should explain why it is okay to proceed when we can't change to
> text console.
> 
See updated comment in attached patch.  It's really up to the caller to
decide what to do if we can't switch the console - currently all callers
ignore the return code so I assume that it's okay to proceed anyway.

-- Andrew


Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
---
diff -rup linux-2.6.20.1/drivers/char/vt.c linux/drivers/char/vt.c
--- linux-2.6.20.1/drivers/char/vt.c	2007-02-19 22:34:32.000000000 -0800
+++ linux/drivers/char/vt.c	2007-03-09 15:48:29.000000000 -0800
@@ -2188,10 +2188,30 @@ static void console_callback(struct work
 	release_console_sem();
 }
 
-void set_console(int nr)
+extern char vt_dont_switch;
+
+int set_console(int nr)
 {
+	struct vc_data *vc = vc_cons[fg_console].d;
+
+	if(!vc_cons_allocated(nr) || vt_dont_switch || 
+		(vc->vt_mode.mode == VT_AUTO && vc->vc_mode == KD_GRAPHICS)) {
+
+		/* 
+		 * Console switch will fail in console_callback() or 
+		 * change_console() so there is no point scheduling 
+		 * the callback
+		 *
+		 * Existing set_console() users don't check the return
+		 * value so this shouldn't break anything 
+		 */ 
+		return -EINVAL;
+	}
+
 	want_console = nr;
 	schedule_console_callback();
+
+	return 0;
 }
 
 struct tty_driver *console_driver;
diff -rup linux-2.6.20.1/drivers/char/vt_ioctl.c
linux/drivers/char/vt_ioctl.c
--- linux-2.6.20.1/drivers/char/vt_ioctl.c	2007-02-19 22:34:32.000000000
-0800
+++ linux/drivers/char/vt_ioctl.c	2007-03-08 14:15:41.000000000 -0800
@@ -34,7 +34,7 @@
 #include <linux/kbd_diacr.h>
 #include <linux/selection.h>
 
-static char vt_dont_switch;
+char vt_dont_switch;
 extern struct tty_driver *console_driver;
 
 #define VT_IS_IN_USE(i)	(console_driver->ttys[i] &&
console_driver->ttys[i]->count)
diff -rup linux-2.6.20.1/include/linux/kbd_kern.h
linux/include/linux/kbd_kern.h
--- linux-2.6.20.1/include/linux/kbd_kern.h	2007-02-19
22:34:32.000000000 -0800
+++ linux/include/linux/kbd_kern.h	2007-03-08 14:15:41.000000000 -0800
@@ -75,7 +75,7 @@ extern int do_poke_blanked_console;
 
 extern void (*kbd_ledfunc)(unsigned int led);
 
-extern void set_console(int nr);
+extern int set_console(int nr);
 extern void schedule_console_callback(void);
 
 static inline void set_leds(void)
diff -rup linux-2.6.20.1/kernel/power/console.c
linux/kernel/power/console.c
--- linux-2.6.20.1/kernel/power/console.c	2007-02-19 22:34:32.000000000
-0800
+++ linux/kernel/power/console.c	2007-03-09 15:52:32.000000000 -0800
@@ -27,7 +27,15 @@ int pm_prepare_console(void)
 		return 1;
 	}
 
-	set_console(SUSPEND_CONSOLE);
+	if (set_console(SUSPEND_CONSOLE)) {
+		/*
+		 * We're unable to switch to the SUSPEND_CONSOLE. 
+		 * Let the calling function know so it can decide 
+		 * what to do.
+		 */ 
+		release_console_sem();
+		return 1;
+	}
 	release_console_sem();
 
 	if (vt_waitactive(SUSPEND_CONSOLE)) {




