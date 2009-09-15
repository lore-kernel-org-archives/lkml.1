Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZIOQUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZIOQUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZIOQUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:20:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56233 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZIOQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:20:07 -0400
From: Matthew Garrett <mjg@redhat.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] backlight: Provide two stage registration
Date: Tue, 15 Sep 2009 17:19:41 +0100
Message-Id: <1253031583-11286-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 212.183.134.211
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backlight class currently allocates and registers a backlight device
in a single function, making it impossible for certain backlight parameters
to be set before the device becomes visible to userspace. This can cause
problems if userspace wins the race and manages to read any of these values
before they've been set, and also makes it harder to extend information
that we may wish to provide to the rest of the kernel at registration time.

This patch breaks the register and unregister functions into two,
separating allocation and registration. The old functions are left to ease
transition.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/video/backlight/backlight.c |  121 ++++++++++++++++++++++++++++------
 include/linux/backlight.h           |    7 ++
 2 files changed, 106 insertions(+), 22 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 157057c..9048a28 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -214,8 +214,7 @@ static struct device_attribute bl_device_attributes[] = {
 };
 
 /**
- * backlight_device_register - create and register a new object of
- *   backlight_device class.
+ * backlight_alloc - create a new object of backlight_device class.
  * @name: the name of the new object(must be the same as the name of the
  *   respective framebuffer device).
  * @parent: a pointer to the parent device
@@ -223,16 +222,16 @@ static struct device_attribute bl_device_attributes[] = {
  *   methods may retrieve it by using bl_get_data(bd).
  * @ops: the backlight operations structure.
  *
- * Creates and registers new backlight device. Returns either an
+ * Creates a new backlight device. Returns either an
  * ERR_PTR() or a pointer to the newly allocated device.
  */
-struct backlight_device *backlight_device_register(const char *name,
-		struct device *parent, void *devdata, struct backlight_ops *ops)
+struct backlight_device *backlight_alloc(const char *name,
+					 struct device *parent, void *devdata,
+					 struct backlight_ops *ops)
 {
 	struct backlight_device *new_bd;
-	int rc;
 
-	pr_debug("backlight_device_register: name=%s\n", name);
+	pr_debug("backlight_alloc: name=%s\n", name);
 
 	new_bd = kzalloc(sizeof(struct backlight_device), GFP_KERNEL);
 	if (!new_bd)
@@ -247,20 +246,37 @@ struct backlight_device *backlight_device_register(const char *name,
 	dev_set_name(&new_bd->dev, name);
 	dev_set_drvdata(&new_bd->dev, devdata);
 
-	rc = device_register(&new_bd->dev);
-	if (rc) {
-		kfree(new_bd);
-		return ERR_PTR(rc);
-	}
+	device_initialize(&new_bd->dev);
+
+	new_bd->ops = ops;
+
+	return new_bd;
+}
+EXPORT_SYMBOL(backlight_alloc);
+
+/**
+ * backlight_register - register an object of backlight_device class.
+ * @bd: the backlight device to register
+ *
+ * Registers a backlight_device that has previously been allocated via
+ * backlight_alloc()
+ */
+
+int backlight_register(struct backlight_device *bd)
+{
+	int rc;
+
+	rc = device_add(&bd->dev);
+
+	if (rc)
+		return rc;
 
-	rc = backlight_register_fb(new_bd);
+	rc = backlight_register_fb(bd);
 	if (rc) {
-		device_unregister(&new_bd->dev);
-		return ERR_PTR(rc);
+		device_del(&bd->dev);
+		return rc;
 	}
 
-	new_bd->ops = ops;
-
 #ifdef CONFIG_PMAC_BACKLIGHT
 	mutex_lock(&pmac_backlight_mutex);
 	if (!pmac_backlight)
@@ -268,17 +284,62 @@ struct backlight_device *backlight_device_register(const char *name,
 	mutex_unlock(&pmac_backlight_mutex);
 #endif
 
+	return 0;
+}
+EXPORT_SYMBOL(backlight_register);
+
+/**
+ * backlight_device_register - create and register a new object of
+ *   backlight_device class.
+ * @name: the name of the new object(must be the same as the name of the
+ *   respective framebuffer device).
+ * @parent: a pointer to the parent device
+ * @devdata: an optional pointer to be stored for private driver use. The
+ *   methods may retrieve it by using bl_get_data(bd).
+ * @ops: the backlight operations structure.
+ *
+ * Creates and registers new backlight device. Returns either an
+ * ERR_PTR() or a pointer to the newly allocated device.
+ */
+struct backlight_device *backlight_device_register(const char *name,
+		struct device *parent, void *devdata, struct backlight_ops *ops)
+{
+	struct backlight_device *new_bd;
+	int rc;
+
+	new_bd = backlight_alloc(name, parent, devdata, ops);
+
+	if (IS_ERR(new_bd))
+		return new_bd;
+
+	rc = backlight_register(new_bd);
+	if (rc)
+		return ERR_PTR(rc);
+
 	return new_bd;
 }
 EXPORT_SYMBOL(backlight_device_register);
 
 /**
- * backlight_device_unregister - unregisters a backlight device object.
- * @bd: the backlight device object to be unregistered and freed.
+ * backlight_destroy - frees a backlight device object
+ * @bd: the backlight device object to be freed.
  *
- * Unregisters a previously registered via backlight_device_register object.
+ * Frees a backligt_device allocated via backlight_alloc
  */
-void backlight_device_unregister(struct backlight_device *bd)
+void backlight_destroy(struct backlight_device *bd)
+{
+	if (bd)
+		put_device(&bd->dev);
+}
+EXPORT_SYMBOL(backlight_destroy);
+
+/**
+ * backlight_unregister - unregisters a backlight device object.
+ * @bd: the backlight device object to be unregistered.
+ *
+ * Unregisters a previously registered via backlight_register object.
+ */
+void backlight_unregister(struct backlight_device *bd)
 {
 	if (!bd)
 		return;
@@ -294,7 +355,23 @@ void backlight_device_unregister(struct backlight_device *bd)
 	mutex_unlock(&bd->ops_lock);
 
 	backlight_unregister_fb(bd);
-	device_unregister(&bd->dev);
+	device_del(&bd->dev);
+}
+EXPORT_SYMBOL(backlight_unregister);
+
+/**
+ * backlight_device_unregister - unregisters a backlight device object.
+ * @bd: the backlight device object to be unregistered and freed.
+ *
+ * Unregisters a previously registered via backlight_device_register object.
+ */
+void backlight_device_unregister(struct backlight_device *bd)
+{
+	if (!bd)
+		return;
+
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 79ca2da..9e17ff0 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -97,9 +97,16 @@ static inline void backlight_update_status(struct backlight_device *bd)
 	mutex_unlock(&bd->update_lock);
 }
 
+
 extern struct backlight_device *backlight_device_register(const char *name,
 	struct device *dev, void *devdata, struct backlight_ops *ops);
+extern struct backlight_device *backlight_alloc(const char *name,
+	struct device *dev, void *devdata, struct backlight_ops *ops);
+extern int backlight_register(struct backlight_device *bd);
+
 extern void backlight_device_unregister(struct backlight_device *bd);
+extern void backlight_unregister(struct backlight_device *bd);
+extern void backlight_destroy(struct backlight_device *bd);
 
 #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
 
-- 
1.6.2.5

