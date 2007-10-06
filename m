Return-Path: <linux-kernel-owner+w=401wt.eu-S1765314AbXJFUKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765314AbXJFUKD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763803AbXJFUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:09:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59029 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762657AbXJFUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:09:53 -0400
Date: Sat, 6 Oct 2007 22:09:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] Colored kernel output (run3)
In-Reply-To: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Colored kernel message output (1/2)

This patch makes it possible to give kernel messages a selectable
color. It can be chosen at compile time, overridden at boot time,
and changed at run time.

References: http://lkml.org/lkml/2007/4/1/162
	http://lkml.org/lkml/2007/10/5/199

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/char/Kconfig |   42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/char/vt.c    |   23 +++++++++++++++++++++++
 2 files changed, 65 insertions(+)

Index: linux-2.6.23/drivers/char/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/char/Kconfig
+++ linux-2.6.23/drivers/char/Kconfig
@@ -58,6 +58,48 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config VT_CKO
+	bool "Colored kernel message output"
+	depends on VT_CONSOLE
+	---help---
+	This option enables kernel messages to be emitted in
+	colors other than the default.
+
+	If unsure, say N.
+
+config VT_PRINTK_COLOR
+	hex "Colored kernel message output"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	This option defines with which color kernel messages will be
+	printed to the console.
+
+	The value you need to enter here is the value is composed
+	(OR-ed) of a foreground and a background color.
+
+	Foreground:
+	0x00 = black,   0x08 = dark gray,
+	0x01 = red,     0x09 = light red,
+	0x02 = green,   0x0A = light green,
+	0x03 = brown,   0x0B = yellow,
+	0x04 = blue,    0x0C = light blue,
+	0x05 = magenta, 0x0D = light magenta,
+	0x06 = cyan,    0x0E = light cyan,
+	0x07 = gray,    0x0F = white,
+
+	(Foreground colors 0x08 to 0x0F do not work when a VGA
+	console font with 512 glyphs is used.)
+
+	Background:
+	0x00 = black,   0x40 = blue,
+	0x10 = red,     0x50 = magenta,
+	0x20 = green,   0x60 = cyan,
+	0x30 = brown,   0x70 = gray,
+
+	For example, 0x1F would yield white on red.
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
@@ -2344,6 +2345,23 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+static unsigned int printk_color __read_mostly = CONFIG_VT_PRINTK_COLOR;
+#ifdef CONFIG_VT_CKO
+module_param(printk_color, uint, S_IRUGO | S_IWUSR);
+
+static inline void vc_set_color(struct vc_data *vc, unsigned char color)
+{
+	vc->vc_color = color_table[color & 0xF] |
+	               (color_table[(color >> 4) & 0x7] << 4) |
+	               (color & 0x80);
+	update_attr(vc);
+}
+#else
+static inline void vc_set_color(const struct vc_data *vc, unsigned char c)
+{
+}
+#endif
+
 /*
  *	Console on virtual terminal
  *
@@ -2384,12 +2402,14 @@ static void vt_console_print(struct cons
 		hide_cursor(vc);
 
 	start = (ushort *)vc->vc_pos;
+	vc_set_color(vc, printk_color);
 
 	/* Contrived structure to try to emulate original need_wrap behaviour
 	 * Problems caused when we have need_wrap set on '\n' character */
 	while (count--) {
 		c = *b++;
 		if (c == 10 || c == 13 || c == 8 || vc->vc_need_wrap) {
+			vc_set_color(vc, vc->vc_def_color);
 			if (cnt > 0) {
 				if (CON_IS_VISIBLE(vc))
 					vc->vc_sw->con_putcs(vc, start, cnt, vc->vc_y, vc->vc_x);
@@ -2402,6 +2422,7 @@ static void vt_console_print(struct cons
 				bs(vc);
 				start = (ushort *)vc->vc_pos;
 				myx = vc->vc_x;
+				vc_set_color(vc, printk_color);
 				continue;
 			}
 			if (c != 13)
@@ -2409,6 +2430,7 @@ static void vt_console_print(struct cons
 			cr(vc);
 			start = (ushort *)vc->vc_pos;
 			myx = vc->vc_x;
+			vc_set_color(vc, printk_color);
 			if (c == 10 || c == 13)
 				continue;
 		}
@@ -2430,6 +2452,7 @@ static void vt_console_print(struct cons
 			vc->vc_need_wrap = 1;
 		}
 	}
+	vc_set_color(vc, vc->vc_def_color);
 	set_cursor(vc);
 
 quit:
