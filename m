Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZEIOnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZEIOnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZEIOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:53 -0400
Received: from kroah.org ([198.145.64.141]:54165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZEIOmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:52 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:31 2009
Message-Id: <20090509143631.276407654@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:02 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 01/13] Driver Core: add nodename callbacks
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-add-nodename-callbacks.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
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
 drivers/base/core.c    |   51 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |    4 +++
 2 files changed, 54 insertions(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -161,10 +161,18 @@ static int dev_uevent(struct kset *kset,
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
@@ -1125,6 +1133,47 @@ static struct device *next_device(struct
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
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -196,6 +196,7 @@ struct class {
 	struct kobject			*dev_kobj;
 
 	int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
+	char *(*nodename)(struct device *dev);
 
 	void (*class_release)(struct class *class);
 	void (*dev_release)(struct device *dev);
@@ -291,6 +292,7 @@ struct device_type {
 	const char *name;
 	struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
+	char *(*nodename)(struct device *dev);
 	void (*release)(struct device *dev);
 
 	int (*suspend)(struct device *dev, pm_message_t state);
@@ -371,6 +373,7 @@ struct device_dma_parameters {
 
 struct device {
 	struct device		*parent;
+	char *(*nodename)(struct device *dev);
 
 	struct device_private	*p;
 
@@ -493,6 +496,7 @@ extern struct device *device_find_child(
 extern int device_rename(struct device *dev, char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
+extern const char *device_get_nodename(struct device *dev, const char **tmp);
 
 /*
  * Root device objects for grouping under /sys/devices


