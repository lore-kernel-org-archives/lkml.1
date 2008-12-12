Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYLLI6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYLLI6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbYLLI6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:58:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37734 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537AbYLLI6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:58:31 -0500
Subject: Re: [PATCH 1/4] driver core: add root_device_register()
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20081212094246.5692d0ca@gondolin>
References: <1229012203.7968.79.camel@blaa>
	 <1229012216-4211-1-git-send-email-markmc@redhat.com>
	 <20081211175604.511fc6ae@gondolin> <1229019807.7968.87.camel@blaa>
	 <20081212094246.5692d0ca@gondolin>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 08:56:49 +0000
Message-Id: <1229072209.4041.5.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 09:42 +0100, Cornelia Huck wrote:
> On Thu, 11 Dec 2008 18:23:27 +0000,
> Mark McLoughlin <markmc@redhat.com> wrote:
> 
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 8c2cc26..20e5825 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -1196,6 +1196,93 @@ EXPORT_SYMBOL_GPL(put_device);
> >  EXPORT_SYMBOL_GPL(device_create_file);
> >  EXPORT_SYMBOL_GPL(device_remove_file);
> > 
> > +struct root_device
> > +{
> > +	struct device dev;
> > +	struct module *owner;
> > +};
> > +
> > +static void root_device_release(struct device *dev)
> > +{
> 
> You need to get the root device here and free that.
> 
> > +	kfree(dev);
> > +}

Yeah, I just figured it was a little overkill given the structure
definition is three lines away. Here it is, though.

Cheers,
Mark.

From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] driver core: add root_device_register()

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
index 8c2cc26..05320af 100644
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
1.6.0.3

