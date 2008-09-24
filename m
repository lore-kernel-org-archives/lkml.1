Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYIXTJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYIXTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYIXTJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:09:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:36855 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXTJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=NqtyV8T9wO3YOy5rdnIAXMUBzevi7jU7slep/BD5nKTUqMvEqNKLkwSuAqF7Q/f43Y
         2LP/jHVp9KYuFphrjDuPPx1ztmEO3Q/QXNvh6pAquWae/A4KC4ctW+9+UcCjQRA5M0AD
         9bLdDWA9J2oJoj1biAyxh2DoedIYCbocSB/E4=
Date: Wed, 24 Sep 2008 21:08:32 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net, krzysztof.h1@poczta.fm,
       Andrew Morton <akpm@linux-foundation.org>, bonbons@linux-vserver.org
Subject: [PATCH v2] fbdev: ignore VESA modes if framebuffer does not
	support them
Message-ID: <20080924190832.GA19141@spock.one.pl>
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
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 401ad99..961a163 100644
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
@@ -133,10 +130,12 @@ static int vesa_set_mode(struct mode_info *mode)
 	if ((vminfo.mode_attr & 0x15) == 0x05) {
 		/* It's a supported text mode */
 		is_graphic = 0;
+#if FB_SUPPORTS_BOOT_VESA
 	} else if ((vminfo.mode_attr & 0x99) == 0x99) {
 		/* It's a graphics mode with linear frame buffer */
 		is_graphic = 1;
 		vesa_mode |= 0x4000; /* Request linear frame buffer */
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
