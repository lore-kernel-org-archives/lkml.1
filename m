Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbXJGQil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbXJGQil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXJGQic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:38:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbXJGQib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:38:31 -0400
Date: Sun, 7 Oct 2007 18:38:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
Message-ID: <20071007163824.GA30063@elte.hu>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

> Colored kernel message output (1/2)
> 
> This patch makes it possible to give kernel messages a selectable 
> color. It can be chosen at compile time, overridden at boot time, and 
> changed at run time.

minor fix: i had to use the slightly modified patch below instead of the 
one you posted, so that the second patch applies fine. Color output is 
just fine with this plus your #2 one applied. Adding 
vt.printk_color=0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08 to the boot line 
worked as expected.

	Ingo

--------------->
Colored kernel message output (1/2)

This patch makes it possible to give kernel messages a selectable
color. It can be chosen at compile time, overridden at boot time,
and changed at run time.

References: http://lkml.org/lkml/2007/4/1/162
	http://lkml.org/lkml/2007/10/5/199

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/Kconfig |   42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/char/vt.c    |   24 ++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

Index: linux/drivers/char/Kconfig
===================================================================
--- linux.orig/drivers/char/Kconfig
+++ linux/drivers/char/Kconfig
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
Index: linux/drivers/char/vt.c
===================================================================
--- linux.orig/drivers/char/vt.c
+++ linux/drivers/char/vt.c
@@ -73,6 +73,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -2344,6 +2345,24 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+#ifdef CONFIG_VT_CKO
+static unsigned int printk_color __read_mostly = CONFIG_VT_PRINTK_COLOR;
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
+static unsigned int printk_color;
+static inline void vc_set_color(const struct vc_data *vc, unsigned char c)
+{
+}
+#endif
+
 /*
  *	Console on virtual terminal
  *
@@ -2384,12 +2403,14 @@ static void vt_console_print(struct cons
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
@@ -2402,6 +2423,7 @@ static void vt_console_print(struct cons
 				bs(vc);
 				start = (ushort *)vc->vc_pos;
 				myx = vc->vc_x;
+				vc_set_color(vc, printk_color);
 				continue;
 			}
 			if (c != 13)
@@ -2409,6 +2431,7 @@ static void vt_console_print(struct cons
 			cr(vc);
 			start = (ushort *)vc->vc_pos;
 			myx = vc->vc_x;
+			vc_set_color(vc, printk_color);
 			if (c == 10 || c == 13)
 				continue;
 		}
@@ -2430,6 +2453,7 @@ static void vt_console_print(struct cons
 			vc->vc_need_wrap = 1;
 		}
 	}
+	vc_set_color(vc, vc->vc_def_color);
 	set_cursor(vc);
 
 quit:
