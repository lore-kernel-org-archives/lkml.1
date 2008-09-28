Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYI1Mzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYI1Mzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 08:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYI1Mzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 08:55:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:31648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYI1Mze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 08:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=YL/QgyHurE4Jdqsp2YxtwiSc4lm3T1dgWWalwY9c0C4esFuVyRrdybqSohnDXixiON
         4x/PzLwukS+G2aifcVYNhcG5sSG1NHCJD4NfiTdwxWdcv+JT2D9vJOClYm3n/hoG03Jl
         iNSXZswt+BHyCOlQtwoSOAlvO/eHDHfXphAzo=
Date: Sun, 28 Sep 2008 14:54:15 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net, krzysztof.h1@poczta.fm,
       akpm@linux-foundation.org, bonbons@linux-vserver.org, hpa@zytor.com
Subject: [PATCH v3] fbdev: ignore VESA modes if framebuffer does not
	support them
Message-ID: <20080928125414.GA27703@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, it is possible to set a graphics VESA mode at boot time via
the vga= parameter even when no framebuffer driver supporting this is
configured.  This could lead to the system booting with a black screen,
without a usable console.

Fix this problem by only allowing to set graphics modes at boot time
if a supporting framebuffer driver is configured.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
This version of the patch replaces the FB_SUPPORTS_BOOT_VESA macro from
screen-info.h with a config option in drivers/video/Kconfig.

diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 401ad99..47e5080 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -88,14 +88,11 @@ static int vesa_probe(void)
 			   (vminfo.memory_layout == 4 ||
 			    vminfo.memory_layout == 6) &&
 			   vminfo.memory_planes == 1) {
-#ifdef CONFIG_FB
+#ifdef CONFIG_FB_BOOT_VESA_SUPPORT
 			/* Graphics mode, color, linear frame buffer
 			   supported.  Only register the mode if
 			   if framebuffer is configured, however,
-			   otherwise the user will be left without a screen.
-			   We don't require CONFIG_FB_VESA, however, since
-			   some of the other framebuffer drivers can use
-			   this mode-setting, too. */
+			   otherwise the user will be left without a screen. */
 			mi = GET_HEAP(struct mode_info, 1);
 			mi->mode = mode + VIDEO_FIRST_VESA;
 			mi->depth = vminfo.bpp;
@@ -133,10 +130,12 @@ static int vesa_set_mode(struct mode_info *mode)
 	if ((vminfo.mode_attr & 0x15) == 0x05) {
 		/* It's a supported text mode */
 		is_graphic = 0;
+#ifdef CONFIG_FB_BOOT_VESA_SUPPORT
 	} else if ((vminfo.mode_attr & 0x99) == 0x99) {
 		/* It's a graphics mode with linear frame buffer */
 		is_graphic = 1;
 		vesa_mode |= 0x4000; /* Request linear frame buffer */
+#endif
 	} else {
 		return -1;	/* Invalid mode */
 	}
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 70d135e..651249d 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -76,6 +76,14 @@ config FB_DDC
        select I2C
        default n
 
+config FB_BOOT_VESA_SUPPORT
+	bool
+	depends on FB
+	default n
+	---help---
+	  If true, at least one selected framebuffer driver can take advantage
+	  of VESA video modes set at an early boot stage via the vga= parameter.
+
 config FB_CFB_FILLRECT
 	tristate
 	depends on FB
@@ -679,6 +687,7 @@ config FB_VESA
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select VIDEO_SELECT
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
 	  compliant graphic cards. The older VESA 1.2 cards are not supported.
@@ -702,6 +711,7 @@ config FB_IMAC
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This is the frame buffer device driver for the Intel-based Macintosh
 
@@ -1124,6 +1134,7 @@ config FB_INTEL
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This driver supports the on-board graphics built in to the Intel
           830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
@@ -1476,6 +1487,7 @@ config FB_SIS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This is the frame buffer device driver for the SiS 300, 315, 330
 	  and 340 series as well as XGI V3XT, V5, V8, Z7 graphics chipsets.

