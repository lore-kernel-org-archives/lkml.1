Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbZC3WMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbZC3WMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762266AbZC3WMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:12:16 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:63008 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762298AbZC3WMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent;
        b=mk3808w+UCA8J0saTanJLYb79fcefwRjWX0OX+vs0T/znooat51NUsk9Iv0lsrCp4e
         VHIRwUJOQjOQ0QtK4OOqhsN8fTJrau+49YWbGxpS1AvKMSSpODF54UYE+PBEKsQt4TuN
         GlyIjBiHm5nLRr/2acTYkWVgHx+SvQJIVT5Rg=
Date: Tue, 31 Mar 2009 00:12:05 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] sa1100fb: fix color component length for pseudocolor modes
Message-ID: <20090330221205.GE6993@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sa1100fb incorrectly sets the length of the color fields to 8 bits
for PSEUDOCOLOR modes for which only 4 bits are used per pixel.
Fix this by setting the length to 4 bits for these modes.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index fad58cf..10ddad8 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -199,16 +199,20 @@
 extern void (*sa1100fb_backlight_power)(int on);
 extern void (*sa1100fb_lcd_power)(int on);
 
-/*
- * IMHO this looks wrong.  In 8BPP, length should be 8.
- */
-static struct sa1100fb_rgb rgb_8 = {
+static struct sa1100fb_rgb rgb_4 = {
 	.red	= { .offset = 0,  .length = 4, },
 	.green	= { .offset = 0,  .length = 4, },
 	.blue	= { .offset = 0,  .length = 4, },
 	.transp	= { .offset = 0,  .length = 0, },
 };
 
+static struct sa1100fb_rgb rgb_8 = {
+	.red	= { .offset = 0,  .length = 8, },
+	.green	= { .offset = 0,  .length = 8, },
+	.blue	= { .offset = 0,  .length = 8, },
+	.transp	= { .offset = 0,  .length = 0, },
+};
+
 static struct sa1100fb_rgb def_rgb_16 = {
 	.red	= { .offset = 11, .length = 5, },
 	.green	= { .offset = 5,  .length = 6, },
@@ -613,7 +617,7 @@ sa1100fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	DPRINTK("var->bits_per_pixel=%d\n", var->bits_per_pixel);
 	switch (var->bits_per_pixel) {
 	case 4:
-		rgbidx = RGB_8;
+		rgbidx = RGB_4;
 		break;
 	case 8:
 		rgbidx = RGB_8;
@@ -1382,6 +1386,7 @@ static struct sa1100fb_info * __init sa1100fb_init_fbinfo(struct device *dev)
 	fbi->fb.monspecs	= monspecs;
 	fbi->fb.pseudo_palette	= (fbi + 1);
 
+	fbi->rgb[RGB_4]		= &rgb_4;
 	fbi->rgb[RGB_8]		= &rgb_8;
 	fbi->rgb[RGB_16]	= &def_rgb_16;
 
diff --git a/drivers/video/sa1100fb.h b/drivers/video/sa1100fb.h
index 86831db..1c3b459 100644
--- a/drivers/video/sa1100fb.h
+++ b/drivers/video/sa1100fb.h
@@ -57,9 +57,10 @@ struct sa1100fb_lcd_reg {
 	unsigned long lccr3;
 };
 
-#define RGB_8	(0)
-#define RGB_16	(1)
-#define NR_RGB	2
+#define RGB_4	(0)
+#define RGB_8	(1)
+#define RGB_16	(2)
+#define NR_RGB	3
 
 struct sa1100fb_info {
 	struct fb_info		fb;

