Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbYAYIcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbYAYIcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbYAYIBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:53736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760361AbYAYIAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:00:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 180/196] kobject: add sample code for how to use ksets/ktypes/kobjects
Date: Thu, 24 Jan 2008 23:33:29 -0800
Message-Id: <1201246425-5058-101-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a more complex example showing how to create a kset and a ktype
and some default attributes for a group of kobjects.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 samples/kobject/Makefile       |    2 +-
 samples/kobject/kset-example.c |  278 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 279 insertions(+), 1 deletions(-)
 create mode 100644 samples/kobject/kset-example.c

diff --git a/samples/kobject/Makefile b/samples/kobject/Makefile
index cce16e9..4a19420 100644
--- a/samples/kobject/Makefile
+++ b/samples/kobject/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_SAMPLE_KOBJECT) += kobject-example.o
+obj-$(CONFIG_SAMPLE_KOBJECT) += kobject-example.o kset-example.o
diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
new file mode 100644
index 0000000..b0a1b4f
--- /dev/null
+++ b/samples/kobject/kset-example.c
@@ -0,0 +1,278 @@
+/*
+ * Sample kset and ktype implementation
+ *
+ * Copyright (C) 2004-2007 Greg Kroah-Hartman <greg@kroah.com>
+ * Copyright (C) 2007 Novell Inc.
+ *
+ * Released under the GPL version 2 only.
+ *
+ */
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+/*
+ * This module shows how to create a kset in sysfs called
+ * /sys/kernel/kset-example
+ * Then tree kobjects are created and assigned to this kset, "foo", "baz",
+ * and "bar".  In those kobjects, attributes of the same name are also
+ * created and if an integer is written to these files, it can be later
+ * read out of it.
+ */
+
+
+/*
+ * This is our "object" that we will create a few of and register them with
+ * sysfs.
+ */
+struct foo_obj {
+	struct kobject kobj;
+	int foo;
+	int baz;
+	int bar;
+};
+#define to_foo_obj(x) container_of(x, struct foo_obj, kobj)
+
+/* a custom attribute that works just for a struct foo_obj. */
+struct foo_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct foo_obj *foo, struct foo_attribute *attr, char *buf);
+	ssize_t (*store)(struct foo_obj *foo, struct foo_attribute *attr, const char *buf, size_t count);
+};
+#define to_foo_attr(x) container_of(x, struct foo_attribute, attr)
+
+/*
+ * The default show function that must be passed to sysfs.  This will be
+ * called by sysfs for whenever a show function is called by the user on a
+ * sysfs file associated with the kobjects we have registered.  We need to
+ * transpose back from a "default" kobject to our custom struct foo_obj and
+ * then call the show function for that specific object.
+ */
+static ssize_t foo_attr_show(struct kobject *kobj,
+			     struct attribute *attr,
+			     char *buf)
+{
+	struct foo_attribute *attribute;
+	struct foo_obj *foo;
+
+	attribute = to_foo_attr(attr);
+	foo = to_foo_obj(kobj);
+
+	if (!attribute->show)
+		return -EIO;
+
+	return attribute->show(foo, attribute, buf);
+}
+
+/*
+ * Just like the default show function above, but this one is for when the
+ * sysfs "store" is requested (when a value is written to a file.)
+ */
+static ssize_t foo_attr_store(struct kobject *kobj,
+			      struct attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct foo_attribute *attribute;
+	struct foo_obj *foo;
+
+	attribute = to_foo_attr(attr);
+	foo = to_foo_obj(kobj);
+
+	if (!attribute->store)
+		return -EIO;
+
+	return attribute->store(foo, attribute, buf, len);
+}
+
+/* Our custom sysfs_ops that we will associate with our ktype later on */
+static struct sysfs_ops foo_sysfs_ops = {
+	.show = foo_attr_show,
+	.store = foo_attr_store,
+};
+
+/*
+ * The release function for our object.  This is REQUIRED by the kernel to
+ * have.  We free the memory held in our object here.
+ *
+ * NEVER try to get away with just a "blank" release function to try to be
+ * smarter than the kernel.  Turns out, no one ever is...
+ */
+static void foo_release(struct kobject *kobj)
+{
+	struct foo_obj *foo;
+
+	foo = to_foo_obj(kobj);
+	kfree(foo);
+}
+
+/*
+ * The "foo" file where the .foo variable is read from and written to.
+ */
+static ssize_t foo_show(struct foo_obj *foo_obj, struct foo_attribute *attr,
+			char *buf)
+{
+	return sprintf(buf, "%d\n", foo_obj->foo);
+}
+
+static ssize_t foo_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
+			 const char *buf, size_t count)
+{
+	sscanf(buf, "%du", &foo_obj->foo);
+	return count;
+}
+
+static struct foo_attribute foo_attribute =
+	__ATTR(foo, 0666, foo_show, foo_store);
+
+/*
+ * More complex function where we determine which varible is being accessed by
+ * looking at the attribute for the "baz" and "bar" files.
+ */
+static ssize_t b_show(struct foo_obj *foo_obj, struct foo_attribute *attr,
+		      char *buf)
+{
+	int var;
+
+	if (strcmp(attr->attr.name, "baz") == 0)
+		var = foo_obj->baz;
+	else
+		var = foo_obj->bar;
+	return sprintf(buf, "%d\n", var);
+}
+
+static ssize_t b_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
+		       const char *buf, size_t count)
+{
+	int var;
+
+	sscanf(buf, "%du", &var);
+	if (strcmp(attr->attr.name, "baz") == 0)
+		foo_obj->baz = var;
+	else
+		foo_obj->bar = var;
+	return count;
+}
+
+static struct foo_attribute baz_attribute =
+	__ATTR(baz, 0666, b_show, b_store);
+static struct foo_attribute bar_attribute =
+	__ATTR(bar, 0666, b_show, b_store);
+
+/*
+ * Create a group of attributes so that we can create and destory them all
+ * at once.
+ */
+static struct attribute *foo_default_attrs[] = {
+	&foo_attribute.attr,
+	&baz_attribute.attr,
+	&bar_attribute.attr,
+	NULL,	/* need to NULL terminate the list of attributes */
+};
+
+/*
+ * Our own ktype for our kobjects.  Here we specify our sysfs ops, the
+ * release function, and the set of default attributes we want created
+ * whenever a kobject of this type is registered with the kernel.
+ */
+static struct kobj_type foo_ktype = {
+	.sysfs_ops = &foo_sysfs_ops,
+	.release = foo_release,
+	.default_attrs = foo_default_attrs,
+};
+
+static struct kset *example_kset;
+static struct foo_obj *foo_obj;
+static struct foo_obj *bar_obj;
+static struct foo_obj *baz_obj;
+
+static struct foo_obj *create_foo_obj(const char *name)
+{
+	struct foo_obj *foo;
+	int retval;
+
+	/* allocate the memory for the whole object */
+	foo = kzalloc(sizeof(*foo), GFP_KERNEL);
+	if (!foo)
+		return NULL;
+
+	/*
+	 * As we have a kset for this kobject, we need to set it before calling
+	 * the kobject core.
+	 */
+	foo->kobj.kset = example_kset;
+
+	/*
+	 * Initialize and add the kobject to the kernel.  All the default files
+	 * will be created here.  As we have already specified a kset for this
+	 * kobject, we don't have to set a parent for the kobject, the kobject
+	 * will be placed beneath that kset automatically.
+	 */
+	retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);
+	if (retval) {
+		kfree(foo);
+		return NULL;
+	}
+
+	/*
+	 * We are always responsible for sending the uevent that the kobject
+	 * was added to the system.
+	 */
+	kobject_uevent(&foo->kobj, KOBJ_ADD);
+
+	return foo;
+}
+
+static void destroy_foo_obj(struct foo_obj *foo)
+{
+	kobject_put(&foo->kobj);
+}
+
+static int example_init(void)
+{
+	/*
+	 * Create a kset with the name of "kset_example",
+	 * located under /sys/kernel/
+	 */
+	example_kset = kset_create_and_add("kset_example", NULL, kernel_kobj);
+	if (!example_kset)
+		return -ENOMEM;
+
+	/*
+	 * Create three objects and register them with our kset
+	 */
+	foo_obj = create_foo_obj("foo");
+	if (!foo_obj)
+		goto foo_error;
+
+	bar_obj = create_foo_obj("bar");
+	if (!bar_obj)
+		goto bar_error;
+
+	baz_obj = create_foo_obj("baz");
+	if (!baz_obj)
+		goto baz_error;
+
+	return 0;
+
+baz_error:
+	destroy_foo_obj(bar_obj);
+bar_error:
+	destroy_foo_obj(foo_obj);
+foo_error:
+	return -EINVAL;
+}
+
+static void example_exit(void)
+{
+	destroy_foo_obj(baz_obj);
+	destroy_foo_obj(bar_obj);
+	destroy_foo_obj(foo_obj);
+	kset_unregister(example_kset);
+}
+
+module_init(example_init);
+module_exit(example_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Greg Kroah-Hartman <greg@kroah.com>");
-- 
1.5.3.8

