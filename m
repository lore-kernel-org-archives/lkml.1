Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZGMPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZGMPTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZGMPTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:19:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:44068 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbZGMPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tsq0KtDV1Uox2X4anlC067g/CeQKNdJpSGAgvIba+8T9QNLeJUq5f3OaHl/yzfJJrd
         JxL0FvLbUvu4JCR4kw+TWaADlMZbljHesV/6D2XvYUW8jYe8beXN4p6i9Zya5fJYxJ4v
         LGEU6c+Qyt0WXPFFB7H5CFyyXxTDYZ/CLkcMg=
Date: Mon, 13 Jul 2009 19:48:41 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: fbdev <linux-fbdev-devel@lists.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] fbdev: add FBIOFILLRECT ioctl
Message-ID: <20090713151841.GB1297@lilem.mirepesht>
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
index a85c818..a90cd0f 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1016,6 +1016,25 @@ fb_blank(struct fb_info *info, int blank)
  	return ret;
 }
 
+static int fb_fillrect_user(struct fb_info *info,
+			    struct fb_fillrect *fill)
+{
+	int ret = 0;
+	if (fill->rop != ROP_COPY && fill->rop != ROP_XOR)
+		return -EINVAL;
+	if (!lock_fb_info(info))
+		return -ENODEV;
+	if (fill->dx + fill->width > info->var.xres ||
+	    fill->dy + fill->height > info->var.yres) {
+		ret = -EINVAL;
+		goto out;
+	}
+	info->fbops->fb_fillrect(info, fill);
+out:
+	unlock_fb_info(info);
+	return ret;
+}
+
 static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			unsigned long arg)
 {
@@ -1026,6 +1045,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	struct fb_cmap cmap_from;
 	struct fb_cmap_user cmap;
 	struct fb_event event;
+	struct fb_fillrect fill;
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
@@ -1133,6 +1153,11 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 		release_console_sem();
 		unlock_fb_info(info);
 		break;
+	case FBIOFILLRECT:
+		if (copy_from_user(&fill, argp, sizeof(fill)))
+			return -EFAULT;
+		ret = fb_fillrect_user(info, &fill);
+		break;
 	default:
 		if (!lock_fb_info(info))
 			return -ENODEV;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index f847df9..40cc99a 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -37,6 +37,7 @@ struct dentry;
 #define FBIOGET_HWCINFO         0x4616
 #define FBIOPUT_MODEINFO        0x4617
 #define FBIOGET_DISPINFO        0x4618
+#define FBIOFILLRECT		0x4619
 
 
 #define FB_TYPE_PACKED_PIXELS		0	/* Packed Pixels	*/
