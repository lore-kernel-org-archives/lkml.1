Return-Path: <linux-kernel-owner+w=401wt.eu-S936560AbZFPF50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936560AbZFPF50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbZFPFvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:17 -0400
Received: from kroah.org ([198.145.64.141]:48366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934949AbZFPFvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/64] Driver Core: add nodename callbacks
Date: Mon, 15 Jun 2009 22:46:14 -0700
Message-Id: <1245131213-24168-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds the nodename callback for struct class, struct device_type and
struct device, to allow drivers to send userspace hints on the device
name and subdirectory that should be used for it.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |    3 ++
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4d59975..7ecb193 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -162,10 +162,18 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	struct device *dev = to_dev(kobj);
 	int retval = 0;
 
-	/* add the major/minor if present */
+	/* add device node properties if present */
 	if (MAJOR(dev->devt)) {
+		const char *tmp;
+		const char *name;
+
 		add_uevent_var(env, "MAJOR=%u", MAJOR(dev->devt));
 		add_uevent_var(env, "MINOR=%u", MINOR(dev->devt));
+		name = device_get_nodename(dev, &tmp);
+		if (name) {
+			add_uevent_var(env, "DEVNAME=%s", name);
+			kfree(tmp);
+		}
 	}
 
 	if (dev->type && dev->type->name)
@@ -1129,6 +1137,47 @@ static struct device *next_device(struct klist_iter *i)
 }
 
 /**
+ * device_get_nodename - path of device node file
+ * @dev: device
+ * @tmp: possibly allocated string
+ *
+ * Return the relative path of a possible device node.
+ * Non-default names may need to allocate a memory to compose
+ * a name. This memory is returned in tmp and needs to be
+ * freed by the caller.
+ */
+const char *device_get_nodename(struct device *dev, const char **tmp)
+{
+	char *s;
+
+	*tmp = NULL;
+
+	/* the device type may provide a specific name */
+	if (dev->type && dev->type->nodename)
+		*tmp = dev->type->nodename(dev);
+	if (*tmp)
+		return *tmp;
+
+	/* the class may provide a specific name */
+	if (dev->class && dev->class->nodename)
+		*tmp = dev->class->nodename(dev);
+	if (*tmp)
+		return *tmp;
+
+	/* return name without allocation, tmp == NULL */
+	if (strchr(dev_name(dev), '!') == NULL)
+		return dev_name(dev);
+
+	/* replace '!' in the name with '/' */
+	*tmp = kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!*tmp)
+		return NULL;
+	while ((s = strchr(*tmp, '!')))
+		s[0] = '/';
+	return *tmp;
+}
+
+/**
  * device_for_each_child - device child iterator.
  * @parent: parent struct device.
  * @data: data for the callback.
diff --git a/include/linux/device.h b/include/linux/device.h
index 4410464..ed4e39f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -194,6 +194,7 @@ struct class {
 	struct kobject			*dev_kobj;
 
 	int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
+	char *(*nodename)(struct device *dev);
 
 	void (*class_release)(struct class *class);
 	void (*dev_release)(struct device *dev);
@@ -289,6 +290,7 @@ struct device_type {
 	const char *name;
 	struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
+	char *(*nodename)(struct device *dev);
 	void (*release)(struct device *dev);
 
 	struct dev_pm_ops *pm;
@@ -488,6 +490,7 @@ extern struct device *device_find_child(struct device *dev, void *data,
 extern int device_rename(struct device *dev, char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
+extern const char *device_get_nodename(struct device *dev, const char **tmp);
 
 /*
  * Root device objects for grouping under /sys/devices
-- 
1.6.3.2

