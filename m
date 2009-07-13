Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZGMPTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZGMPTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbZGMPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:19:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:30583 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZGMPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OrRyjCvn2MHfJ7pdqDj5cj2rjkJTVVBbcaoSXO1JgnQmNEaDHlwnZGpDz7gt3vZVoe
         s5rxkjcGhBvED2O5j3Cn7+thsBoGRZHBBkiHvteHtuz/4I/fjX7iyYp6eHr0h+hZ/KgZ
         76XVjALHBaAuByO/Unm/cBhYxPswlQe1SM54M=
Date: Mon, 13 Jul 2009 19:50:04 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: fbdev <linux-fbdev-devel@lists.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fbdev: add FBIOCOPYAREA ioctl
Message-ID: <20090713152004.GC1297@lilem.mirepesht>
References: <20090713151709.GA1297@lilem.mirepesht>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713151709.GA1297@lilem.mirepesht>
User-Agent: Mutt/1.5.20 (2009-06-26)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
---
 drivers/video/fbmem.c |   25 +++++++++++++++++++++++++
 include/linux/fb.h    |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index a90cd0f..518119a 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1035,6 +1035,25 @@ out:
 	return ret;
 }
 
+static int fb_copyarea_user(struct fb_info *info,
+			    struct fb_copyarea *copy)
+{
+	int ret = 0;
+	if (!lock_fb_info(info))
+		return -ENODEV;
+	if (copy->dx + copy->width > info->var.xres ||
+	    copy->sx + copy->width > info->var.xres ||
+	    copy->dy + copy->height > info->var.yres ||
+	    copy->sy + copy->height > info->var.yres) {
+		ret = -EINVAL;
+		goto out;
+	}
+	info->fbops->fb_copyarea(info, copy);
+out:
+	unlock_fb_info(info);
+	return ret;
+}
+
 static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			unsigned long arg)
 {
@@ -1046,6 +1065,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	struct fb_cmap_user cmap;
 	struct fb_event event;
 	struct fb_fillrect fill;
+	struct fb_copyarea copy;
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
@@ -1158,6 +1178,11 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EFAULT;
 		ret = fb_fillrect_user(info, &fill);
 		break;
+	case FBIOCOPYAREA:
+		if (copy_from_user(&copy, argp, sizeof(copy)))
+			return -EFAULT;
+		ret = fb_copyarea_user(info, &copy);
+		break;
 	default:
 		if (!lock_fb_info(info))
 			return -ENODEV;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 40cc99a..f1cf8df 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -38,6 +38,7 @@ struct dentry;
 #define FBIOPUT_MODEINFO        0x4617
 #define FBIOGET_DISPINFO        0x4618
 #define FBIOFILLRECT		0x4619
+#define FBIOCOPYAREA		0x461A
 
 
 #define FB_TYPE_PACKED_PIXELS		0	/* Packed Pixels	*/
