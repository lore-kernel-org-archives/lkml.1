Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYCEUZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYCEUZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYCEUYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:24:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:52391 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYCEUYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Qrn4QQvy2Hhr/btXmdE96dYbcdt24aBavuHFpQ/4A/vn1/eJLD/N06GQZ2qsWn1RuMyX1VYSMSNetMUU651jaqHrxbK4+4GFVTjzVhtiG3XL1cjb1+/JhUkS254dHg/uzquet6++6tnUh4SN+OdgyphQ+gCxndX5JOxvqoUA6rQ=
Date: Wed, 5 Mar 2008 23:24:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: mchehab@infradead.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] V4L1 - fix v4l_compat_translate_ioctl possible NULL deref
Message-ID: <20080305202443.GC7559@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are possible NULL pointer derefs in case of kzalloc fails so fix them.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

v4l1 is deprecated now and  scheduled for removal *BUT* at December of 2008 only.

Index: linux-2.6.git/drivers/media/video/v4l1-compat.c
===================================================================
--- linux-2.6.git.orig/drivers/media/video/v4l1-compat.c	2008-01-21 19:35:14.000000000 +0300
+++ linux-2.6.git/drivers/media/video/v4l1-compat.c	2008-03-05 23:20:50.000000000 +0300
@@ -303,7 +303,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_capability *cap = arg;
 
-		cap2 = kzalloc(sizeof(*cap2),GFP_KERNEL);
+		cap2 = kzalloc(sizeof(*cap2), GFP_KERNEL);
+		if (!cap2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(cap, 0, sizeof(*cap));
 		memset(&fbuf2, 0, sizeof(fbuf2));
 
@@ -426,7 +430,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_window	*win = arg;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(win,0,sizeof(*win));
 
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
@@ -464,7 +472,11 @@ v4l_compat_translate_ioctl(struct inode 
 		struct video_window	*win = arg;
 		int err1,err2;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		drv(inode, file, VIDIOC_STREAMOFF, &fmt2->type);
 		err1 = drv(inode, file, VIDIOC_G_FMT, fmt2);
@@ -586,6 +598,12 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_picture	*pict = arg;
 
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
+
 		pict->brightness = get_v4l_control(inode, file,
 						   V4L2_CID_BRIGHTNESS,drv);
 		pict->hue = get_v4l_control(inode, file,
@@ -597,7 +615,6 @@ v4l_compat_translate_ioctl(struct inode 
 		pict->whiteness = get_v4l_control(inode, file,
 						  V4L2_CID_WHITENESS, drv);
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		if (err < 0) {
@@ -617,6 +634,11 @@ v4l_compat_translate_ioctl(struct inode 
 		struct video_picture	*pict = arg;
 		int mem_err = 0, ovl_err = 0;
 
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(&fbuf2, 0, sizeof(fbuf2));
 
 		set_v4l_control(inode, file,
@@ -636,7 +658,6 @@ v4l_compat_translate_ioctl(struct inode 
 		 * different pixel formats for memory vs overlay.
 		 */
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		/* If VIDIOC_G_FMT failed, then the driver likely doesn't
@@ -890,7 +911,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_mmap	*mm = arg;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(&buf2,0,sizeof(buf2));
 
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -986,7 +1011,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct vbi_format      *fmt = arg;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
@@ -1018,8 +1047,11 @@ v4l_compat_translate_ioctl(struct inode 
 			break;
 		}
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
-
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 		fmt2->fmt.vbi.samples_per_line = fmt->samples_per_line;
 		fmt2->fmt.vbi.sampling_rate    = fmt->sampling_rate;
