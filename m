Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbYD0DJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbYD0DJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 23:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYD0DJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 23:09:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44692 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYD0DJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 23:09:34 -0400
Date: Sun, 27 Apr 2008 05:09:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [1/3] Re: Colored Kernel Output for 2.6.25
In-Reply-To: <alpine.LNX.1.10.0804270450031.20150@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LNX.1.10.0804270509010.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804270450031.20150@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 15e3809bd3b6596158263301a344c1fdf281e11d
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Apr 27 03:17:51 2008 +0200

    Colored kernel message output (1/3)
    
    This patch makes it possible to give kernel messages a selectable
    color. It can be chosen at compile time, overridden at boot time,
    and changed at run time.
    
    References:
    	http://lkml.org/lkml/2007/4/1/162
    	http://lkml.org/lkml/2007/10/5/199
    	http://lkml.org/lkml/2007/10/6/88
    	http://lkml.org/lkml/2007/10/6/89
    
    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
---
 drivers/char/Kconfig |   43 ++++++++++++++++++++++++++++++++++++++++++
 drivers/char/vt.c    |   21 ++++++++++++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 47c6be8..a55a1c9 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -58,6 +58,49 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config VT_CKO
+	bool "Colored kernel message output"
+	depends on VT_CONSOLE
+	---help---
+	This option enables kernel messages to be emitted in
+	colors other than the default.
+	This option enlarges your kernel by approximately 1/2 KB.
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
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 159c9e2..cf61236 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -73,6 +73,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -2392,6 +2393,24 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+#ifdef CONFIG_VT_CKO
+static unsigned int printk_color __read_mostly = CONFIG_VT_PRINTK_COLOR;
+module_param(printk_color, uint, S_IRUGO | S_IWUSR);
+
+static void vc_set_color(struct vc_data *vc, unsigned char color)
+{
+	vc->vc_color = color_table[color & 0xF] |
+		       (color_table[(color >> 4) & 0x7] << 4) |
+		       (color & 0x80);
+	update_attr(vc);
+}
+#else
+static const unsigned int printk_color;
+static inline void vc_set_color(const struct vc_data *vc, unsigned char c)
+{
+}
+#endif
+
 /*
  *	Console on virtual terminal
  *
@@ -2434,6 +2453,7 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 		hide_cursor(vc);
 
 	start = (ushort *)vc->vc_pos;
+	vc_set_color(vc, printk_color);
 
 	/* Contrived structure to try to emulate original need_wrap behaviour
 	 * Problems caused when we have need_wrap set on '\n' character */
@@ -2482,6 +2502,7 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 		}
 	}
 	set_cursor(vc);
+	vc_set_color(vc, vc->vc_def_color);
 	notify_update(vc);
 
 quit:
