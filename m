Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYFCNqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYFCNqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYFCNp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:45:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYFCNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:45:56 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48447615.5050806@am.sony.com>
References: <48447615.5050806@am.sony.com>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 14:45:50 +0100
Message-Id: <1212500751.16924.322.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 15:37 -0700, Tim Bird wrote:
> With CONSOLE_TRANSLATIONS turned off, this saves about 6K
> on my kernel configured for an ARM development board (OMAP
> 5912 OSK).  In embedded products I'm familiar with,
> console translations are not needed.
> 
> This was taken from the Linux-tiny project and updated slightly
> for 2.6.25.

I prefer it like this... we can drop consolemap.o and
consolemap_deftbl.o from the build completely. It saves 7.2KiB on a
ppc32 build here.

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 595a925..f740190 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -36,6 +36,13 @@ config VT
 	  If unsure, say Y, or else you won't be able to do much with your new
 	  shiny Linux system :-)
 
+config CONSOLE_TRANSLATIONS
+	default y
+	bool "Enable character translations in console" if EMBEDDED
+	---help---
+	  This enables support for font mapping and Unicode translation
+	  on virtual consoles.
+
 config VT_CONSOLE
 	bool "Support for console on virtual terminal" if EMBEDDED
 	depends on VT
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 4c1c584..6ef173c 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -12,8 +12,8 @@ obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
-obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o consolemap.o \
-				   consolemap_deftbl.o selection.o keyboard.o
+obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
+obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
 obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
 obj-$(CONFIG_AUDIT)		+= tty_audit.o
 obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
diff --git a/include/linux/consolemap.h b/include/linux/consolemap.h
index e2bf7e5..c4811da 100644
--- a/include/linux/consolemap.h
+++ b/include/linux/consolemap.h
@@ -3,6 +3,9 @@
  *
  * Interface between console.c, selection.c  and consolemap.c
  */
+#ifndef __LINUX_CONSOLEMAP_H__
+#define __LINUX_CONSOLEMAP_H__
+
 #define LAT1_MAP 0
 #define GRAF_MAP 1
 #define IBMPC_MAP 2
@@ -10,6 +13,7 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_CONSOLE_TRANSLATIONS
 struct vc_data;
 
 extern u16 inverse_translate(struct vc_data *conp, int glyph, int use_unicode);
@@ -18,3 +22,13 @@ extern int conv_uni_to_pc(struct vc_data *conp, long ucs);
 extern u32 conv_8bit_to_uni(unsigned char c);
 extern int conv_uni_to_8bit(u32 uni);
 void console_map_init(void);
+#else
+#define inverse_translate(conp, glyph, uni) ((uint16_t)glyph)
+#define set_translate(m, vc) ((unsigned short *)NULL)
+#define conv_uni_to_pc(conp, ucs) ((int) (ucs > 0xff ? -1: ucs))
+#define conv_8bit_to_uni(c) ((uint32_t)(c))
+#define conv_uni_to_8bit(c) ((int) ((c) & 0xff))
+#define console_map_init(c) do { ; } while (0)
+#endif /* CONFIG_CONSOLE_TRANSLATIONS */
+
+#endif /* __LINUX_CONSOLEMAP_H__ */
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 9448ffb..81ed155 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/console_struct.h>
 #include <linux/mm.h>
+#include <linux/consolemap.h>
 
 /*
  * Presently, a lot of graphics programs do not restore the contents of
@@ -54,6 +55,7 @@ void redraw_screen(struct vc_data *vc, int is_switch);
 struct tty_struct;
 int tioclinux(struct tty_struct *tty, unsigned long arg);
 
+#ifdef CONFIG_CONSOLE_TRANSLATIONS
 /* consolemap.c */
 
 struct unimapinit;
@@ -70,6 +72,18 @@ int con_set_default_unimap(struct vc_data *vc);
 void con_free_unimap(struct vc_data *vc);
 void con_protect_unimap(struct vc_data *vc, int rdonly);
 int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
+#else
+#define con_set_trans_old(arg) (0)
+#define con_get_trans_old(arg) (-EINVAL)
+#define con_set_trans_new(arg) (0)
+#define con_get_trans_new(arg) (-EINVAL)
+#define con_clear_unimap(vc, ui) (0)
+#define con_set_unimap(vc, ct, list) (0)
+#define con_set_default_unimap(vc) (0)
+#define con_copy_unimap(d, s) (0)
+#define con_get_unimap(vc, ct, uct, list) (-EINVAL)
+#define con_free_unimap(vc) do { ; } while (0)
+#endif
 
 /* vt.c */
 int vt_waitactive(int vt);

-- 
dwmw2

