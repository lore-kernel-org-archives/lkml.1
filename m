Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbXJETNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbXJETNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbXJETNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:13:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37403 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbXJETNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:13:41 -0400
Date: Fri, 5 Oct 2007 21:13:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Cute feature: colored printk output
Message-ID: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Colored kernel message output

Let's work more on Linux's cuteness! [http://lkml.org/lkml/2007/10/4/431]
The following patch makes it possible to give kernel messages a
selectable color which helps to distinguish it from other noise,
such as boot messages. NetBSD has it, OpenBSD has it, FreeBSD to some
extent, so I think Linux should too.

Inspired by cko (http://freshmeat.net/p/cko/), but independently
written, later contributed forth and back.

Already posted at: http://lkml.org/lkml/2007/4/1/162

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/char/Kconfig |   29 +++++++++++++++++++++++++++++
 drivers/char/vt.c    |   14 ++++++++++++++
 2 files changed, 43 insertions(+)

Index: linux-2.6.23/drivers/char/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/char/Kconfig
+++ linux-2.6.23/drivers/char/Kconfig
@@ -58,6 +58,35 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config VT_PRINTK_COLOR
+	hex "Colored kernel message output"
+	range 0x00 0xFF
+	depends on VT_CONSOLE
+	default 0x17
+	---help---
+	This option will give you ability to change the color of
+	kernel messages printed to the console.
+
+	The value you need to enter here is the ASCII color value
+	composed (OR'ed) by one foreground color, one background
+	color and any number of attributes as follows:
+
+	Foreground:
+	0x00=black, 0x01=blue, 0x02=green, 0x03=green,
+	0x04=red, 0x05=magenta, 0x06=brown, 0x07=gray
+
+	Background:
+	0x00=black, 0x10=blue, 0x20=green, 0x30=green,
+	0x40=red, 0x50=magenta, 0x60=brown, 0x70=gray
+
+	Attributes:
+	0x08=highlight foreground
+
+	Thus, 0x17 will yield gray-on-blue like in OpenBSD and
+	0x02 green-on-black like in NetBSD.
+	Using "highlight foreground" is said not work when you use
+	VGA Console (Framebuffer not affected) with a 512-glyph font.
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
Index: linux-2.6.23/drivers/char/vt.c
===================================================================
--- linux-2.6.23.orig/drivers/char/vt.c
+++ linux-2.6.23/drivers/char/vt.c
@@ -73,6 +73,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -2348,6 +2349,9 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+static unsigned int printk_color = CONFIG_VT_PRINTK_COLOR;
+module_param(printk_color, uint, S_IRUGO | S_IWUSR);
+
 /*
  *	Console on virtual terminal
  *
@@ -2388,12 +2392,16 @@ static void vt_console_print(struct cons
 		hide_cursor(vc);
 
 	start = (ushort *)vc->vc_pos;
+	vc->vc_color = printk_color;
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
@@ -2406,6 +2414,8 @@ static void vt_console_print(struct cons
 				bs(vc);
 				start = (ushort *)vc->vc_pos;
 				myx = vc->vc_x;
+				vc->vc_color = printk_color;
+				update_attr(vc);
 				continue;
 			}
 			if (c != 13)
@@ -2413,6 +2423,8 @@ static void vt_console_print(struct cons
 			cr(vc);
 			start = (ushort *)vc->vc_pos;
 			myx = vc->vc_x;
+			vc->vc_color = printk_color;
+			update_attr(vc);
 			if (c == 10 || c == 13)
 				continue;
 		}
@@ -2434,6 +2446,8 @@ static void vt_console_print(struct cons
 			vc->vc_need_wrap = 1;
 		}
 	}
+	vc->vc_color = vc->vc_def_color;
+	update_attr(vc);
 	set_cursor(vc);
 
 quit:
