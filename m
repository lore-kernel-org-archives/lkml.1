Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXCLUad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXCLUad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXCLUad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:30:33 -0400
Received: from yvrmail01.intrinsyc.com ([209.139.192.246]:23836 "EHLO
	yvrmail01.intrinsyc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXCLUac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:30:32 -0400
Subject: [PATCH] Software Suspend: Fix suspend when console is in
	VT_AUTO+KD_GRAPHICS mode
From: Andrew Johnson <ajohnson@intrinsyc.com>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, akpm@osdl.org
Content-Type: text/plain
Date: Mon, 12 Mar 2007 13:29:40 -0700
Message-Id: <1173731380.30345.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2007 20:30:50.0789 (UTC) FILETIME=[531A9D50:01C764E5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

When the console is in VT_AUTO+KD_GRAPHICS mode, switching to the
SUSPEND_CONSOLE fails, resulting in vt_waitactive() waiting indefinitely
or until the task is interrupted.  This patch tests if a console switch
can occur in set_console() and returns early if a console switch is not
possible.

-- Andrew

Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
---
diff -rup linux-2.6.20.1/drivers/char/vt.c linux/drivers/char/vt.c
--- linux-2.6.20.1/drivers/char/vt.c	2007-02-19 22:34:32.000000000 -0800
+++ linux/drivers/char/vt.c	2007-03-12 12:37:44.000000000 -0700
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
+	if (!vc_cons_allocated(nr) || vt_dont_switch || 
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
diff -rup linux-2.6.20.1/drivers/char/vt_ioctl.c linux/drivers/char/vt_ioctl.c
--- linux-2.6.20.1/drivers/char/vt_ioctl.c	2007-02-19 22:34:32.000000000 -0800
+++ linux/drivers/char/vt_ioctl.c	2007-03-08 14:15:41.000000000 -0800
@@ -34,7 +34,7 @@
 #include <linux/kbd_diacr.h>
 #include <linux/selection.h>
 
-static char vt_dont_switch;
+char vt_dont_switch;
 extern struct tty_driver *console_driver;
 
 #define VT_IS_IN_USE(i)	(console_driver->ttys[i] && console_driver->ttys[i]->count)
diff -rup linux-2.6.20.1/include/linux/kbd_kern.h linux/include/linux/kbd_kern.h
--- linux-2.6.20.1/include/linux/kbd_kern.h	2007-02-19 22:34:32.000000000 -0800
+++ linux/include/linux/kbd_kern.h	2007-03-08 14:15:41.000000000 -0800
@@ -75,7 +75,7 @@ extern int do_poke_blanked_console;
 
 extern void (*kbd_ledfunc)(unsigned int led);
 
-extern void set_console(int nr);
+extern int set_console(int nr);
 extern void schedule_console_callback(void);
 
 static inline void set_leds(void)
diff -rup linux-2.6.20.1/kernel/power/console.c linux/kernel/power/console.c
--- linux-2.6.20.1/kernel/power/console.c	2007-02-19 22:34:32.000000000 -0800
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


