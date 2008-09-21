Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbYIUVDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbYIUVDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYIUVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:03:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:56349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYIUVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=m5suWd93/8M82kDEeZaoT1GT92xSJqb+c6W4lV/RbtIJzqdnvTwEHDkGb5jdFPOVXH
         vVZz9uClIG3nlz/r9fBHlZypt3tq/nbQguBCavioe5peBq+STNu8RVD8i1a+vsUm14A3
         mJp07oNVPGDkVFaJRGJV9m3Ay8IFg7b/m0V1c=
Date: Sun, 21 Sep 2008 23:02:19 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] fbdev: don't allow to set a video mode via vga= if FB
	doesn't support it
Message-ID: <20080921210219.GC21215@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>

Currently, it is possible to set a VESA graphics mode at boot time via
the vga= parameter even when no framebuffer driver supporting this is
configured.  This could lead to the system booting with a black screen,
without a usable console.

Fix this problem by only allowing to set graphics modes at boot time
if a supporting framebuffer driver is configured.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 401ad99..32a6045 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -88,14 +88,11 @@ static int vesa_probe(void)
 			   (vminfo.memory_layout == 4 ||
 			    vminfo.memory_layout == 6) &&
 			   vminfo.memory_planes == 1) {
-#ifdef CONFIG_FB
+#if FB_SUPPORTS_BOOT_VESA
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
@@ -134,9 +131,13 @@ static int vesa_set_mode(struct mode_info *mode)
 		/* It's a supported text mode */
 		is_graphic = 0;
 	} else if ((vminfo.mode_attr & 0x99) == 0x99) {
+#if FB_SUPPORTS_BOOT_VESA
 		/* It's a graphics mode with linear frame buffer */
 		is_graphic = 1;
 		vesa_mode |= 0x4000; /* Request linear frame buffer */
+#else
+		return -1;
+#endif
 	} else {
 		return -1;	/* Invalid mode */
 	}
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 1ee2c05..20fdc2f 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -76,6 +76,10 @@ extern struct screen_info screen_info;
 #define ORIG_VIDEO_LINES	(screen_info.orig_video_lines)
 #define ORIG_VIDEO_ISVGA	(screen_info.orig_video_isVGA)
 #define ORIG_VIDEO_POINTS       (screen_info.orig_video_points)
+
+#define FB_SUPPORTS_BOOT_VESA (defined(CONFIG_FB_VESA) || \
+		defined(CONFIG_FB_SIS) || defined(CONFIG_FB_IMAC) || \
+		defined(CONFIG_FB_INTEL))
 #endif /* __KERNEL__ */
 
 #endif /* _SCREEN_INFO_H */

