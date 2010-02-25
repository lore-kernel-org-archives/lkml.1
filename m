Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab0BYWQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:16:15 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:44258 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934185Ab0BYWQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:16:13 -0500
From: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Message-Id: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
Date: Thu, 25 Feb 2010 15:15:49 -0700
To: linux-kernel@vger.kernel.org
Cc: npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       FlorianSchandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org, jkosina@suse.cz, bonbons@linux-vserver.org
Subject: [PATCH] Add sysfs support for fbdefio delay
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for examining and modifying the fbdefio delay
parameter through sysfs. It also adds two driver definable minimum
and maximum bounds.

The default behavior is to not permit modifications if delay_max is 0,
thus preventing modification of the delay if the driver does not
explicitly permit modification.

Signed-off-by: Rick L. Vinyard, Jr <rvinyard@cs.nmsu.edu>
---
 .../ABI/testing/sysfs-class-graphics-defio         |   35 ++++++++
 drivers/video/fbsysfs.c                            |   87 ++++++++++++++++++++
 include/linux/fb.h                                 |    9 ++-
 3 files changed, 130 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-graphics-defio

diff --git a/Documentation/ABI/testing/sysfs-class-graphics-defio b/Documentation/ABI/testing/sysfs-class-graphics-defio
new file mode 100644
index 0000000..e0ef924
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-graphics-defio
@@ -0,0 +1,35 @@
+What:		/sys/class/graphics/<fb>/defio_delay
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Rick L Vinyard Jr <rvinyard@cs.nmsu.edu>
+Description:
+		Set the deferred I/O delay of the framebuffer in ms.
+		This value can be used to throttle deferred I/O updates.
+		Most framebuffer devices do not have or need support for
+		deferred I/O. Accessing a framebuffer without deferred I/O
+		support will return -ENODEV. Can be read but not modified if
+		/sys/class/graphics/<fb>/defio_delay_max is 0. When modifying,
+		the value must be greater than or equal to
+		/sys/class/graphics/<fb>/defio_delay_min and less than or equal
+		to /sys/class/graphics/<fb>/defio_delay_max.
+
+What:		/sys/class/graphics/<fb>/defio_delay_min
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Rick L Vinyard Jr <rvinyard@cs.nmsu.edu>
+Description:
+		Minimum deferred I/O value in ms for this framebuffer.
+		This value is specified by the driver and cannot be modified
+		from sysfs. Default is 0.
+
+What:		/sys/class/graphics/<fb>/defio_delay_min
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Rick L Vinyard Jr <rvinyard@cs.nmsu.edu>
+Description:
+		Maximum deferred I/O value in ms for this framebuffer.
+		This value is specified by the driver and cannot be modified
+		from sysfs. Default is 0.
+		If this value is 0 /sys/class/graphics/<fb>/defio_delay cannot
+		be modified, but can be read.
+
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index d4a2c11..d00ea2d 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -484,6 +484,87 @@ static ssize_t show_bl_curve(struct device *device,
 }
 #endif
 
+#ifdef CONFIG_FB_DEFERRED_IO
+static ssize_t store_defio_delay(struct device *device,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms = 0;
+	unsigned long delay;
+	int error;
+	char *last = NULL;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	/* Check whether delay_max permits setting of delay */
+	if (fb_info->fbdefio->delay_max == 0)
+		return -EPERM;
+
+	error = strict_strtoul(buf, 10, &delay_ms);
+	if (error < 0)
+		return error;
+
+	delay = delay_ms * HZ / 1000;
+
+	if (delay < fb_info->fbdefio->delay_min ||
+	    delay > fb_info->fbdefio->delay_max)
+		return -EINVAL;
+
+	fb_info->fbdefio->delay = delay;
+
+	return count;
+}
+
+static ssize_t show_defio_delay(struct device *device,
+				struct device_attribute *attr, char *buf)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	delay_ms = fb_info->fbdefio->delay * 1000 / HZ;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", delay_ms);
+}
+
+static ssize_t show_defio_delay_min(struct device *device,
+				    struct device_attribute *attr, char *buf)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	delay_ms = fb_info->fbdefio->delay_min * 1000 / HZ;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", delay_ms);
+}
+
+static ssize_t show_defio_delay_max(struct device *device,
+				    struct device_attribute *attr, char *buf)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	delay_ms = fb_info->fbdefio->delay_max * 1000 / HZ;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", delay_ms);
+}
+
+#endif
+
 /* When cmap is added back in it should be a binary attribute
  * not a text one. Consideration should also be given to converting
  * fbdev to use configfs instead of sysfs */
@@ -503,6 +584,12 @@ static struct device_attribute device_attrs[] = {
 #ifdef CONFIG_FB_BACKLIGHT
 	__ATTR(bl_curve, S_IRUGO|S_IWUSR, show_bl_curve, store_bl_curve),
 #endif
+#ifdef CONFIG_FB_DEFERRED_IO
+	__ATTR(defio_delay, S_IRUGO|S_IWUSR,
+	       show_defio_delay, store_defio_delay),
+	__ATTR(defio_delay_min, S_IRUGO, show_defio_delay_min, NULL),
+	__ATTR(defio_delay_max, S_IRUGO, show_defio_delay_max, NULL),
+#endif
 };
 
 int fb_init_device(struct fb_info *fb_info)
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 369767b..76f35fd 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -591,8 +591,15 @@ struct fb_pixmap {
 
 #ifdef CONFIG_FB_DEFERRED_IO
 struct fb_deferred_io {
-	/* delay between mkwrite and deferred handler */
+	/* delay in jiffies between mkwrite and deferred handler */
 	unsigned long delay;
+	/* The minimum delay in jiffies that may be set through sysfs */
+	unsigned long delay_min;
+	/*
+	 * The maximum delay in jiffies that may be set through sysfs.
+	 * If delay_max is 0, delay cannot be set through sysfs.
+	 */
+	unsigned long delay_max;
 	struct mutex lock; /* mutex that protects the page list */
 	struct list_head pagelist; /* list of touched pages */
 	/* callback */
-- 
1.6.6.1

