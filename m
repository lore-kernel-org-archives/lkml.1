Return-Path: <linux-kernel-owner+w=401wt.eu-S1422858AbXBGTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422858AbXBGTxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422890AbXBGTxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:53:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54119 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422858AbXBGTxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:17 -0500
Date: Wed, 7 Feb 2007 19:53:09 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Greg KH <greg@kroah.com>
cc: Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] class device cleanup for fbdev
Message-ID: <Pine.LNX.4.64.0702071950110.9071@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Let me know if this is the right approach. This patch uses the class field 
in struct device.

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 3cfea31..c3a9222 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1296,14 +1296,9 @@ register_framebuffer(struct fb_info *fb_info)
 			break;
 	fb_info->node = i;
 
-	fb_info->dev = device_create(fb_class, fb_info->device,
-				     MKDEV(FB_MAJOR, i), "fb%d", i);
-	if (IS_ERR(fb_info->dev)) {
-		/* Not fatal */
+	/* Not fatal */
+	if (fb_init_device(fb_info, fb_class))
 		printk(KERN_WARNING "Unable to create device for framebuffer %d; errno = %ld\n", i, PTR_ERR(fb_info->dev));
-		fb_info->dev = NULL;
-	} else
-		fb_init_device(fb_info);
 
 	if (fb_info->pixmap.addr == NULL) {
 		fb_info->pixmap.addr = kmalloc(FBPIXMAPSIZE, GFP_KERNEL);
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 323bdf6..ce3804c 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -505,40 +505,32 @@ static struct device_attribute device_attrs[] = {
 #endif
 };
 
-int fb_init_device(struct fb_info *fb_info)
+int fb_init_device(struct fb_info *fb_info, struct class *fb_class)
 {
-	int i, error = 0;
+	int error = 0;
 
-	dev_set_drvdata(fb_info->dev, fb_info);
+	if (!fb_class->dev_attrs)
+		fb_class->dev_attrs = device_attrs;
 
-	fb_info->class_flag |= FB_SYSFS_FLAG_ATTR;
-
-	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
-		error = device_create_file(fb_info->dev, &device_attrs[i]);
-
-		if (error)
-			break;
-	}
-
-	if (error) {
-		while (--i >= 0)
-			device_remove_file(fb_info->dev, &device_attrs[i]);
+	fb_info->dev = device_create(fb_class, fb_info->device,
+                                     MKDEV(FB_MAJOR, fb_info->node),
+				     "fb%d", fb_info->node);
+        if (IS_ERR(fb_info->dev)) {
 		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+		fb_info->dev = NULL;
+		error = -EINVAL;
+	} else {
+		dev_set_drvdata(fb_info->dev, fb_info);
+		fb_info->class_flag |= FB_SYSFS_FLAG_ATTR;
 	}
-
-	return 0;
+	return error;
 }
 
 void fb_cleanup_device(struct fb_info *fb_info)
 {
-	unsigned int i;
-
-	if (fb_info->class_flag & FB_SYSFS_FLAG_ATTR) {
-		for (i = 0; i < ARRAY_SIZE(device_attrs); i++)
-			device_remove_file(fb_info->dev, &device_attrs[i]);
-
-		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
-	}
+	fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+	dev_set_drvdata(fb_info->dev, NULL);
+	device_unregister(fb_info->dev);
 }
 
 #ifdef CONFIG_FB_BACKLIGHT
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 64177ec..37c4819 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -910,7 +910,7 @@ static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 /* drivers/video/fbsysfs.c */
 extern struct fb_info *framebuffer_alloc(size_t size, struct device *dev);
 extern void framebuffer_release(struct fb_info *info);
-extern int fb_init_device(struct fb_info *fb_info);
+extern int fb_init_device(struct fb_info *fb_info, struct class *fb_class);
 extern void fb_cleanup_device(struct fb_info *head);
 extern void fb_bl_default_curve(struct fb_info *fb_info, u8 off, u8 min, u8 max);
 
