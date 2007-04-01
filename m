Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXDASOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXDASOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933769AbXDASOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:14:37 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39061 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775AbXDASOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:14:32 -0400
Date: Sun, 1 Apr 2007 20:14:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/16] vt-printk-color.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012003180.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Colored kernel message output

Gives kernel messages on the console an OpenBSD-esque color to distinguish
them from regular tty (as long as that's not colored too) text.

Inspired by cko (iirc http://freshmeat.net/p/cko/), but better
implementation done by myself (handles newlines correctly).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 Kconfig |   28 ++++++++++++++++++++++++++++
 vt.c    |   22 ++++++++++++++++++++++
 2 files changed, 50 insertions(+)

Index: linux-2.6.21-rc5/drivers/char/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/char/Kconfig
+++ linux-2.6.21-rc5/drivers/char/Kconfig
@@ -57,6 +57,34 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config VT_CKO
+	hex "Colored kernel message output"
+	range 0x00 0xFF
+	depends on VT_CONSOLE
+	default 0x17
+	---help---
+	This option will give you ability to change the color of
+	kernel messages.
+
+	The value you need to enter here is the ASCII color value
+	composed (OR'ed) by one foreground color, one background
+	color and any number of attributes as follows:
+
+	Foreground:     Background:    Attributes:
+	0x01 blue       0x10 blue      0x08 highlight foreground
+	0x02 green      0x20 green     0x80 blinking foreground
+	0x03 cyan       0x30 cyan
+	0x04 red        0x40 red
+	0x05 magenta    0x50 red
+	0x06 brown      0x60 brown
+	0x07 gray       0x70 gray
+
+	Thus, 0x17 will yield gray-on-blue like you can see in
+	OpenBSD, 0x02 the green-on-black like on NetBSD.
+	Using "highlight foreground" does not work when you use
+	VGA Console and fonts with 512 glyphs.
+	VGA Framebuffer is not affected.
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
Index: linux-2.6.21-rc5/drivers/char/vt.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/char/vt.c
+++ linux-2.6.21-rc5/drivers/char/vt.c
@@ -73,6 +73,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -2234,6 +2235,17 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+static unsigned int cko_color = CONFIG_VT_CKO;
+
+static __init int set_cko(char *str)
+{
+	cko_color = simple_strtoul(str, NULL, 0);
+	return 1;
+}
+
+__setup("cko=", set_cko);
+module_param(cko_color, uint, S_IRUGO | S_IWUSR);
+
 /*
  *	Console on virtual terminal
  *
@@ -2274,12 +2286,16 @@ static void vt_console_print(struct cons
 		hide_cursor(vc);
 
 	start = (ushort *)vc->vc_pos;
+	vc->vc_color = cko_color;
+	update_attr(vc);
 
 	/* Contrived structure to try to emulate original need_wrap behaviour
 	 * Problems caused when we have need_wrap set on '\n' character */
 	while (count--) {
 		c = *b++;
 		if (c == 10 || c == 13 || c == 8 || vc->vc_need_wrap) {
+			vc->vc_color = vc->vc_def_color;
+			update_attr(vc);
 			if (cnt > 0) {
 				if (CON_IS_VISIBLE(vc))
 					vc->vc_sw->con_putcs(vc, start, cnt, vc->vc_y, vc->vc_x);
@@ -2292,6 +2308,8 @@ static void vt_console_print(struct cons
 				bs(vc);
 				start = (ushort *)vc->vc_pos;
 				myx = vc->vc_x;
+				vc->vc_color = cko_color;
+				update_attr(vc);
 				continue;
 			}
 			if (c != 13)
@@ -2299,6 +2317,8 @@ static void vt_console_print(struct cons
 			cr(vc);
 			start = (ushort *)vc->vc_pos;
 			myx = vc->vc_x;
+			vc->vc_color = cko_color;
+			update_attr(vc);
 			if (c == 10 || c == 13)
 				continue;
 		}
@@ -2320,6 +2340,8 @@ static void vt_console_print(struct cons
 			vc->vc_need_wrap = 1;
 		}
 	}
+	vc->vc_color = vc->vc_def_color;
+	update_attr(vc);
 	set_cursor(vc);
 
 quit:
#<EOF>

