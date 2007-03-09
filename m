Return-Path: <linux-kernel-owner+w=401wt.eu-S1767503AbXCITDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767503AbXCITDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767504AbXCITDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:03:14 -0500
Received: from yvrmail01.intrinsyc.com ([209.139.192.246]:41881 "EHLO
	yvrmail01.intrinsyc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767503AbXCITDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:03:11 -0500
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in
	VT_AUTO/KD_GRAPHICS mode
From: Andrew Johnson <ajohnson@intrinsyc.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20070309153456.GA28664@srcf.ucam.org>
References: <1173394485.28589.17.camel@localhost.localdomain>
	 <20070309090805.GA5822@atrey.karlin.mff.cuni.cz>
	 <20070309153456.GA28664@srcf.ucam.org>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 11:02:22 -0800
Message-Id: <1173466942.29923.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2007 19:03:24.0559 (UTC) FILETIME=[9CDE31F0:01C7627D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-03 at 15:34 +0000, Matthew Garrett wrote:
> On Fri, Mar 09, 2007 at 10:08:05AM +0100, Pavel Machek wrote:
> 
> > So... if current console is graphical, we leave X accessing the
> > console... That's bad, because video state is not going to be
> > restored...?
> 
> A graphical console is not necessarily X. Is there any requirement for 
> there to be a single VT that isn't in text mode? The vt switching is 
> a hack, we shouldn't make life difficult for people who have their own 
> userspace code that's entirely capable of restoring video state on its 
> own.

I realised that the previous patch would disallow a console switch while
running X.  Attached is an updated patch with this scenario fixed.

Another approach might be to fail in vt_waitactive() if a console switch
is not going to occur.

-- Andrew

Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
---
diff -rup linux-2.6.20.1/drivers/char/vt.c linux/drivers/char/vt.c
--- linux-2.6.20.1/drivers/char/vt.c	2007-02-19 22:34:32.000000000 -0800
+++ linux/drivers/char/vt.c	2007-03-09 10:53:32.000000000 -0800
@@ -2188,10 +2188,22 @@ static void console_callback(struct work
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
+		(vc->vt_mode.mode != VT_PROCESS && vc->vc_mode == KD_GRAPHICS)) {
+
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
+++ linux/kernel/power/console.c	2007-03-08 14:15:41.000000000 -0800
@@ -27,7 +27,11 @@ int pm_prepare_console(void)
 		return 1;
 	}
 
-	set_console(SUSPEND_CONSOLE);
+	if (set_console(SUSPEND_CONSOLE)) {
+		/* Unable to change to the new console */
+		release_console_sem();
+		return 1;
+	}
 	release_console_sem();
 
 	if (vt_waitactive(SUSPEND_CONSOLE)) {


