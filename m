Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbYLKQSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbYLKQSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbYLKQSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:18:23 -0500
Received: from mail06.svc.cra.dublin.eircom.net ([159.134.118.22]:43063 "HELO
	mail06.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756433AbYLKQSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:18:23 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/4] driver core: add root_device_register()
Date: Thu, 11 Dec 2008 16:16:53 +0000
Message-Id: <1229012216-4211-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1229012203.7968.79.camel@blaa>
References: <1229012203.7968.79.camel@blaa>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for allocating root device objects which group
device objects under /sys/devices directories.

Also add a sysfs 'module' symlink which points to the owner
of the root device object. This will be used in virtio to
allow userspace to determine which virtio bus implementation
a given device is associated with.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/base/core.c    |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |   11 ++++++
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8c2cc26..db160a2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1196,6 +1196,94 @@ EXPORT_SYMBOL_GPL(put_device);
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
 
+struct root_device
+{
+	struct device dev;
+	struct module *owner;
+};
+
+static void root_device_release(struct device *dev)
+{
+	struct root_device *root = container_of(dev, struct root_device, dev);
+
+	if (root->owner)
+		sysfs_remove_link(&root->dev.kobj, "module");
+
+	kfree(root);
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
+		if (err) {;
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
+ * We simply release @root using device_unregister(). If @root
+ * has a reference count of one, the device will be freed
+ * after it has been unregistered. Otherwise, the structure
+ * will stick around until the final reference is dropped
+ * using put_device().
+ */
+void root_device_unregister(struct device *root)
+{
+	device_unregister(root);
+}
+EXPORT_SYMBOL_GPL(root_device_unregister);
+
 
 static void device_create_release(struct device *dev)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 1a3686d..9e02980 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -483,6 +483,17 @@ extern int device_rename(struct device *dev, char *new_name);
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

