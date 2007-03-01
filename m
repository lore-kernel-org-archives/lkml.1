Return-Path: <linux-kernel-owner+w=401wt.eu-S1030238AbXCAUzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbXCAUzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030246AbXCAUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:55:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39274 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030238AbXCAUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:55:20 -0500
Date: Thu, 1 Mar 2007 20:55:17 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@hotpop.com>,
       Dave Airlie <airlied@linux.ie>, Greg KH <greg@kroah.com>
Subject: [PATCH] sysfs improvements for fbdev
Message-ID: <Pine.LNX.4.64.0702281518120.1757@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch dooes a little house cleaning for the syfs registering. The 
goal to be able to share the graphics hardware between more than one 
interfaces i.e fbdev, drm, backlight. I'm hoping that when a parent 
device is powered down i.e pci device, that all the child devices get 
powered down first. The two very important things it does is:

1) Have struct fb_info be data for the created sysfs device for fbX.
   This enables moving away from device on the bus. 

2) Have suspend and resume functions for the fb class.

3) Have dev_release method for the class for cleanup.

The is a inital patch. What I needed to know is do we need hooks for fbdev 
drivers for power management and for unregistering the framebuffer. I CC 
Dave for his input on splitting up the release/power management functions.


diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 2822526..2cff39c 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1268,8 +1268,6 @@ static const struct file_operations fb_fops = {
 #endif
 };
 
-struct class *fb_class;
-EXPORT_SYMBOL(fb_class);
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1295,14 +1293,9 @@ register_framebuffer(struct fb_info *fb_info)
 			break;
 	fb_info->node = i;
 
-	fb_info->dev = device_create(fb_class, fb_info->device,
-				     MKDEV(FB_MAJOR, i), "fb%d", i);
-	if (IS_ERR(fb_info->dev)) {
-		/* Not fatal */
+	/* Not fatal */
+	if (fb_init_device(fb_info))
 		printk(KERN_WARNING "Unable to create device for framebuffer %d; errno = %ld\n", i, PTR_ERR(fb_info->dev));
-		fb_info->dev = NULL;
-	} else
-		fb_init_device(fb_info);
 
 	if (fb_info->pixmap.addr == NULL) {
 		fb_info->pixmap.addr = kmalloc(FBPIXMAPSIZE, GFP_KERNEL);
@@ -1356,7 +1349,6 @@ unregister_framebuffer(struct fb_info *fb_info)
 	registered_fb[i]=NULL;
 	num_registered_fb--;
 	fb_cleanup_device(fb_info);
-	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
 	return 0;
@@ -1402,11 +1394,7 @@ fbmem_init(void)
 	if (register_chrdev(FB_MAJOR,"fb",&fb_fops))
 		printk("unable to get major %d for fb devs\n", FB_MAJOR);
 
-	fb_class = class_create(THIS_MODULE, "graphics");
-	if (IS_ERR(fb_class)) {
-		printk(KERN_WARNING "Unable to create fb class; errno = %ld\n", PTR_ERR(fb_class));
-		fb_class = NULL;
-	}
+	fb_create_class();
 	return 0;
 }
 
@@ -1415,8 +1403,8 @@ module_init(fbmem_init);
 static void __exit
 fbmem_exit(void)
 {
-	class_destroy(fb_class);
 	unregister_chrdev(FB_MAJOR, "fb");
+	fb_destroy_class();
 }
 
 module_exit(fbmem_exit);
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 40c80c8..30279e2 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -505,42 +505,95 @@ static struct device_attribute device_attrs[] = {
 #endif
 };
 
+struct class *fb_class;
+EXPORT_SYMBOL(fb_class);
+
 int fb_init_device(struct fb_info *fb_info)
 {
-	int i, error = 0;
+	int error = 0;
 
-	dev_set_drvdata(fb_info->dev, fb_info);
+	fb_info->dev = device_create(fb_class, fb_info->device,
+                                     MKDEV(FB_MAJOR, fb_info->node),
+				     "fb%d", fb_info->node);
+        if (IS_ERR(fb_info->dev)) {
+		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+		fb_info->dev = NULL;
+		error = -EINVAL;
+	} else {
+		dev_set_drvdata(fb_info->dev, fb_info);
+		fb_info->class_flag |= FB_SYSFS_FLAG_ATTR;
+	}
+	return error;
+}
 
-	fb_info->class_flag |= FB_SYSFS_FLAG_ATTR;
+void fb_cleanup_device(struct fb_info *fb_info)
+{
+	fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+	dev_set_drvdata(fb_info->dev, NULL);
+	device_destroy(fb_class, MKDEV(FB_MAJOR, fb_info->node));
+}
 
-	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
-		error = device_create_file(fb_info->dev, &device_attrs[i]);
+static int fb_class_suspend(struct device *dev, pm_message_t state)
+{
+	struct fb_info *fb_info = dev_get_drvdata(dev);
 
-		if (error)
-			break;
-	}
+	acquire_console_sem();
+	fb_set_suspend(fb_info, 1);
 
-	if (error) {
-		while (--i >= 0)
-			device_remove_file(fb_info->dev, &device_attrs[i]);
-		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
-	}
+	// Should we have private driver hooks?
 
+	release_console_sem();
 	return 0;
 }
 
-void fb_cleanup_device(struct fb_info *fb_info)
+static int fb_class_resume(struct device *dev)
 {
-	unsigned int i;
+	struct fb_info *fb_info = dev_get_drvdata(dev);
+
+	acquire_console_sem();
+	fb_set_suspend(fb_info, 0);
 
-	if (fb_info->class_flag & FB_SYSFS_FLAG_ATTR) {
-		for (i = 0; i < ARRAY_SIZE(device_attrs); i++)
-			device_remove_file(fb_info->dev, &device_attrs[i]);
+	// Should we have private driver hooks?
 
-		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+	release_console_sem();
+	return 0;
+}
+
+static void fb_class_device_release(struct device *dev)
+{
+	struct fb_info *fb_info = dev_get_drvdata(dev);
+
+	if (fb_info) {
+		acquire_console_sem();
+		// Should we have a private hook here ?
+
+		fb_dealloc_cmap(&fb_info->cmap);
+		unregister_framebuffer(fb_info);
+		//framebuffer_release(info); Not every driver does this yet
+		release_console_sem();
+	}
+}
+
+void fb_create_class()
+{
+	fb_class = class_create(THIS_MODULE, "graphics");
+	if (IS_ERR(fb_class)) {
+		printk(KERN_WARNING "Unable to create fb class; errno = %ld\n", PTR_ERR(fb_class));
+		fb_class = NULL;
+	} else {
+		fb_class->dev_release = fb_class_device_release;
+		fb_class->suspend = fb_class_suspend;
+		fb_class->resume = fb_class_resume;
+		fb_class->dev_attrs = device_attrs;
 	}
 }
 
+void fb_destroy_class()
+{
+	if (fb_class)
+		class_destroy(fb_class);
+}
+
 #ifdef CONFIG_FB_BACKLIGHT
 /* This function generates a linear backlight curve
  *
diff --git a/include/linux/fb.h b/include/linux/fb.h
index be913ec..30d76ad 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -919,6 +919,8 @@ extern void framebuffer_release(struct fb_info *info);
 extern int fb_init_device(struct fb_info *fb_info);
 extern void fb_cleanup_device(struct fb_info *head);
 extern void fb_bl_default_curve(struct fb_info *fb_info, u8 off, u8 min, u8 max);
+extern void fb_destroy_class(void);
+extern void fb_create_class(void);
 
 /* drivers/video/fbmon.c */
 #define FB_MAXTIMINGS		0

