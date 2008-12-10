Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYLJRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYLJRrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYLJRrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:47:07 -0500
Received: from mail27.svc.cra.dublin.eircom.net ([159.134.118.223]:40343 "HELO
	mail27.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752783AbYLJRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:47:05 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 2/6] virtio: add register_virtio_root_device()
Date: Wed, 10 Dec 2008 17:45:35 +0000
Message-Id: <1228931139-12956-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1228931139-12956-1-git-send-email-markmc@redhat.com>
References: <1228931096.5384.63.camel@blaa>
 <1228931139-12956-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to allocate a root device object to group the
devices from a given virtio implementation.

Also add a 'module' sysfs symlink to allow so that userspace
can generically determine which virtio implementation a
device is associated with. This will be used by Fedora
mkinitrd to generically determine e.g. that virtio_pci is
needed to mount a given root filesystem.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h  |   10 ++++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 018c070..61e6597 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -1,6 +1,7 @@
 #include <linux/virtio.h>
 #include <linux/spinlock.h>
 #include <linux/virtio_config.h>
+#include <linux/err.h>
 
 /* Unique numbering for virtio devices. */
 static unsigned int dev_index;
@@ -200,6 +201,76 @@ void unregister_virtio_device(struct virtio_device *dev)
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
+/* A root device for virtio devices from a given backend.  This makes them
+ * appear as /sys/devices/{name}/0,1,2 not /sys/devices/0,1,2. It also allows
+ * us to have a /sys/devices/{name}/module symlink to the backend module. */
+struct virtio_root_device
+{
+	struct device dev;
+	struct module *owner;
+};
+
+static struct virtio_root_device *to_virtio_root(struct device *dev)
+{
+        return container_of(dev, struct virtio_root_device, dev);
+}
+
+static void release_virtio_root_device(struct device *dev)
+{
+	struct virtio_root_device *root = to_virtio_root(dev);
+	if (root->owner)
+		sysfs_remove_link(&root->dev.kobj, "module");
+	kfree(root);
+}
+
+struct device *__register_virtio_root_device(const char *name,
+					     struct module *owner)
+{
+	struct virtio_root_device *root;
+	int err = -ENOMEM;
+
+	root = kzalloc(sizeof(struct virtio_root_device), GFP_KERNEL);
+	if (!root)
+		goto out;
+
+	err = dev_set_name(&root->dev, name);
+	if (err)
+		goto free_root;
+
+	err = device_register(&root->dev);
+	if (err)
+		goto free_root;
+
+	root->dev.parent  = NULL;
+	root->dev.release = release_virtio_root_device;
+
+	if (owner) {
+		struct module_kobject *mk = &owner->mkobj;
+
+		err = sysfs_create_link(&root->dev.kobj, &mk->kobj, "module");
+                if (err) {
+			device_unregister(&root->dev);
+			return ERR_PTR(err);
+		}
+
+		root->owner = owner;
+	}
+
+	return &root->dev;
+
+free_root:
+	kfree(root);
+out:
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(__register_virtio_root_device);
+
+void unregister_virtio_root_device(struct device *root)
+{
+	device_unregister(root);
+}
+EXPORT_SYMBOL_GPL(unregister_virtio_root_device);
+
 static int virtio_init(void)
 {
 	if (bus_register(&virtio_bus) != 0)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 06005fa..66e6c67 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -93,6 +93,16 @@ struct virtio_device
 int register_virtio_device(struct virtio_device *dev);
 void unregister_virtio_device(struct virtio_device *dev);
 
+/* A root device is a dummy device used to group virtio devices from each
+ * implementation. */
+struct device *__register_virtio_root_device(const char *name,
+					     struct module *owner);
+static inline struct device *register_virtio_root_device(const char *name)
+{
+	return __register_virtio_root_device(name, THIS_MODULE);
+}
+void unregister_virtio_root_device(struct device *root);
+
 /**
  * virtio_driver - operations for a virtio I/O driver
  * @driver: underlying device driver (populate name and owner).
-- 
1.5.4.3

