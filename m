Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbXJLWdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbXJLWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbXJLWTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:49721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbXJLWTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "tonyj@suse.de" <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/75] Convert from class_device to device for drivers/video
Date: Fri, 12 Oct 2007 15:16:32 -0700
Message-Id: <11922275693989-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275642378-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: tonyj@suse.de <tonyj@suse.de>

Convert from class_device to device for drivers/video.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/video.c         |    4 ++--
 drivers/video/output.c       |   29 ++++++++++++++++-------------
 include/linux/video_output.h |    4 ++--
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index d05891f..b8a2095 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -316,7 +316,7 @@ static int acpi_video_output_get(struct output_device *od)
 {
 	unsigned long state;
 	struct acpi_video_device *vd =
-		(struct acpi_video_device *)class_get_devdata(&od->class_dev);
+		(struct acpi_video_device *)dev_get_drvdata(&od->dev);
 	acpi_video_device_get_state(vd, &state);
 	return (int)state;
 }
@@ -325,7 +325,7 @@ static int acpi_video_output_set(struct output_device *od)
 {
 	unsigned long state = od->request_state;
 	struct acpi_video_device *vd=
-		(struct acpi_video_device *)class_get_devdata(&od->class_dev);
+		(struct acpi_video_device *)dev_get_drvdata(&od->dev);
 	return acpi_video_device_set_state(vd, state);
 }
 
diff --git a/drivers/video/output.c b/drivers/video/output.c
index 1473f2c..f2df551 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -31,7 +31,8 @@ MODULE_DESCRIPTION("Display Output Switcher Lowlevel Control Abstraction");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luming Yu <luming.yu@intel.com>");
 
-static ssize_t video_output_show_state(struct class_device *dev,char *buf)
+static ssize_t video_output_show_state(struct device *dev,
+				       struct device_attribute *attr, char *buf)
 {
 	ssize_t ret_size = 0;
 	struct output_device *od = to_output_device(dev);
@@ -40,8 +41,9 @@ static ssize_t video_output_show_state(struct class_device *dev,char *buf)
 	return ret_size;
 }
 
-static ssize_t video_output_store_state(struct class_device *dev,
-	const char *buf,size_t count)
+static ssize_t video_output_store_state(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf,size_t count)
 {
 	char *endp;
 	struct output_device *od = to_output_device(dev);
@@ -60,21 +62,22 @@ static ssize_t video_output_store_state(struct class_device *dev,
 	return count;
 }
 
-static void video_output_class_release(struct class_device *dev)
+static void video_output_release(struct device *dev)
 {
 	struct output_device *od = to_output_device(dev);
 	kfree(od);
 }
 
-static struct class_device_attribute video_output_attributes[] = {
+static struct device_attribute video_output_attributes[] = {
 	__ATTR(state, 0644, video_output_show_state, video_output_store_state),
 	__ATTR_NULL,
 };
 
+
 static struct class video_output_class = {
 	.name = "video_output",
-	.release = video_output_class_release,
-	.class_dev_attrs = video_output_attributes,
+	.dev_release = video_output_release,
+	.dev_attrs = video_output_attributes,
 };
 
 struct output_device *video_output_register(const char *name,
@@ -91,11 +94,11 @@ struct output_device *video_output_register(const char *name,
 		goto error_return;
 	}
 	new_dev->props = op;
-	new_dev->class_dev.class = &video_output_class;
-	new_dev->class_dev.dev = dev;
-	strlcpy(new_dev->class_dev.class_id,name,KOBJ_NAME_LEN);
-	class_set_devdata(&new_dev->class_dev,devdata);
-	ret_code = class_device_register(&new_dev->class_dev);
+	new_dev->dev.class = &video_output_class;
+	new_dev->dev.parent = dev;
+	strlcpy(new_dev->dev.bus_id,name, BUS_ID_SIZE);
+	dev_set_drvdata(&new_dev->dev, devdata);
+	ret_code = device_register(&new_dev->dev);
 	if (ret_code) {
 		kfree(new_dev);
 		goto error_return;
@@ -111,7 +114,7 @@ void video_output_unregister(struct output_device *dev)
 {
 	if (!dev)
 		return;
-	class_device_unregister(&dev->class_dev);
+	device_unregister(&dev->dev);
 }
 EXPORT_SYMBOL(video_output_unregister);
 
diff --git a/include/linux/video_output.h b/include/linux/video_output.h
index e63e0c0..2fb46bc 100644
--- a/include/linux/video_output.h
+++ b/include/linux/video_output.h
@@ -31,9 +31,9 @@ struct output_properties {
 struct output_device {
 	int request_state;
 	struct output_properties *props;
-	struct class_device class_dev;
+	struct device dev;
 };
-#define to_output_device(obj) container_of(obj, struct output_device, class_dev)
+#define to_output_device(obj) container_of(obj, struct output_device, dev)
 struct output_device *video_output_register(const char *name,
 	struct device *dev,
 	void *devdata,
-- 
1.5.3.4

