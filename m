Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYLONAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYLONAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYLOM75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:59:57 -0500
Received: from mail03.svc.cra.dublin.eircom.net ([159.134.118.19]:37581 "HELO
	mail03.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751170AbYLOM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:59:56 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/4] driver core: add root_device_register()
Date: Mon, 15 Dec 2008 12:58:26 +0000
Message-Id: <1229345909-27229-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20081212190730.GB2950@kroah.com>
References: <20081212190730.GB2950@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for allocating root device objects which group
device objects under /sys/devices directories.

Also add a sysfs 'module' symlink which points to the owner
of the root device object. This symlink will be used in virtio
to allow userspace to determine which virtio bus implementation
a given device is associated with.

[Includes suggestions from Cornelia Huck]

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/base/core.c    |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |   11 ++++++
 2 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 14aa2b6..eb1b4cb 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1196,6 +1196,95 @@ EXPORT_SYMBOL_GPL(put_device);
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
 
+struct root_device
+{
+	struct device dev;
+	struct module *owner;
+};
+
+#define to_root_device(dev) container_of(dev, struct root_device, dev)
+
+static void root_device_release(struct device *dev)
+{
+	kfree(to_root_device(dev));
+}
+
+/**
+ * __root_device_register - allocate and register a root device
+ * @name: root device name
+ * @owner: owner module of the root device, usually THIS_MODULE
+ *
+ * This function allocates a root device and registers it
+ * using device_register(). In order to free the returned
+ * device, use root_device_unregister().
+ *
+ * Root devices are dummy devices which allow other devices
+ * to be grouped under /sys/devices. Use this function to
+ * allocate a root device and then use it as the parent of
+ * any device which should appear under /sys/devices/{name}
+ *
+ * The /sys/devices/{name} directory will also contain a
+ * 'module' symlink which points to the @owner directory
+ * in sysfs.
+ *
+ * Note: You probably want to use root_device_register().
+ */
+struct device *__root_device_register(const char *name, struct module *owner)
+{
+	struct root_device *root;
+	int err = -ENOMEM;
+
+	root = kzalloc(sizeof(struct root_device), GFP_KERNEL);
+	if (!root)
+		return ERR_PTR(err);
+
+	err = dev_set_name(&root->dev, name);
+	if (err) {
+		kfree(root);
+		return ERR_PTR(err);
+	}
+
+	root->dev.release = root_device_release;
+
+	err = device_register(&root->dev);
+	if (err) {
+		put_device(&root->dev);
+		return ERR_PTR(err);
+	}
+
+	if (owner) {
+		struct module_kobject *mk = &owner->mkobj;
+
+		err = sysfs_create_link(&root->dev.kobj, &mk->kobj, "module");
+		if (err) {
+			device_unregister(&root->dev);
+			return ERR_PTR(err);
+		}
+		root->owner = owner;
+	}
+
+	return &root->dev;
+}
+EXPORT_SYMBOL_GPL(__root_device_register);
+
+/**
+ * root_device_unregister - unregister and free a root device
+ * @root: device going away.
+ *
+ * This function unregisters and cleans up a device that was created by
+ * root_device_register().
+ */
+void root_device_unregister(struct device *dev)
+{
+	struct root_device *root = to_root_device(dev);
+
+	if (root->owner)
+		sysfs_remove_link(&root->dev.kobj, "module");
+
+	device_unregister(dev);
+}
+EXPORT_SYMBOL_GPL(root_device_unregister);
+
 
 static void device_create_release(struct device *dev)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 4e14fad..9008c79 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -484,6 +484,17 @@ extern int device_rename(struct device *dev, char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent);
 
 /*
+ * Root device objects for grouping under /sys/devices
+ */
+extern struct device *__root_device_register(const char *name,
+					     struct module *owner);
+static inline struct device *root_device_register(const char *name)
+{
+	return __root_device_register(name, THIS_MODULE);
+}
+extern void root_device_unregister(struct device *root);
+
+/*
  * Manual binding of a device to driver. See drivers/base/bus.c
  * for information on use.
  */
-- 
1.5.4.3

