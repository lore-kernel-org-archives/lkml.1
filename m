Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbYAYHaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbYAYHaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbYAYHQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:47587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbYAYHQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 045/196] kobject: add kobject_create_and_add function
Date: Thu, 24 Jan 2008 23:09:43 -0800
Message-Id: <1201245134-4876-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets users create dynamic kobjects much easier.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    3 ++
 lib/kobject.c           |   81 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index f91aeb7..33e7a61 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -91,6 +91,9 @@ extern int __must_check kobject_init_and_add(struct kobject *kobj,
 
 extern void kobject_del(struct kobject *);
 
+extern struct kobject * __must_check kobject_create_and_add(const char *name,
+						struct kobject *parent);
+
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
diff --git a/lib/kobject.c b/lib/kobject.c
index 4fb27ba..98422a3 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -619,18 +619,69 @@ void kobject_put(struct kobject * kobj)
 		kref_put(&kobj->kref, kobject_release);
 }
 
-
-static void dir_release(struct kobject *kobj)
+static void dynamic_kobj_release(struct kobject *kobj)
 {
+	pr_debug("%s: freeing %s\n", __FUNCTION__, kobject_name(kobj));
 	kfree(kobj);
 }
 
-static struct kobj_type dir_ktype = {
-	.release	= dir_release,
-	.sysfs_ops	= NULL,
-	.default_attrs	= NULL,
+static struct kobj_type dynamic_kobj_ktype = {
+	.release = dynamic_kobj_release,
 };
 
+/*
+ * kobject_create - create a struct kobject dynamically
+ *
+ * This function creates a kobject structure dynamically and sets it up
+ * to be a "dynamic" kobject with a default release function set up.
+ *
+ * If the kobject was not able to be created, NULL will be returned.
+ */
+static struct kobject *kobject_create(void)
+{
+	struct kobject *kobj;
+
+	kobj = kzalloc(sizeof(*kobj), GFP_KERNEL);
+	if (!kobj)
+		return NULL;
+
+	kobject_init_ng(kobj, &dynamic_kobj_ktype);
+	return kobj;
+}
+
+/**
+ * kobject_create_and_add - create a struct kobject dynamically and register it with sysfs
+ *
+ * @name: the name for the kset
+ * @parent: the parent kobject of this kobject, if any.
+ *
+ * This function creates a kset structure dynamically and registers it
+ * with sysfs.  When you are finished with this structure, call
+ * kobject_unregister() and the structure will be dynamically freed when
+ * it is no longer being used.
+ *
+ * If the kobject was not able to be created, NULL will be returned.
+ */
+struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
+{
+	struct kobject *kobj;
+	int retval;
+
+	kobj = kobject_create();
+	if (!kobj)
+		return NULL;
+
+	retval = kobject_add_ng(kobj, parent, "%s", name);
+	if (retval) {
+		printk(KERN_WARNING "%s: kobject_add error: %d\n",
+		       __FUNCTION__, retval);
+		kobject_put(kobj);
+		kobj = NULL;
+	}
+	return kobj;
+}
+EXPORT_SYMBOL_GPL(kobject_create_and_add);
+
 /**
  *	kobject_kset_add_dir - add sub directory of object.
  *	@kset:		kset the directory is belongs to.
@@ -645,23 +696,17 @@ struct kobject *kobject_kset_add_dir(struct kset *kset,
 	struct kobject *k;
 	int ret;
 
-	if (!parent)
-		return NULL;
-
-	k = kzalloc(sizeof(*k), GFP_KERNEL);
+	k = kobject_create();
 	if (!k)
 		return NULL;
 
 	k->kset = kset;
-	k->parent = parent;
-	k->ktype = &dir_ktype;
-	kobject_set_name(k, name);
-	ret = kobject_register(k);
+	ret = kobject_add_ng(k, parent, "%s", name);
 	if (ret < 0) {
-		printk(KERN_WARNING "%s: kobject_register error: %d\n",
+		printk(KERN_WARNING "%s: kobject_add error: %d\n",
 			__func__, ret);
-		kobject_del(k);
-		return NULL;
+		kobject_put(k);
+		k = NULL;
 	}
 
 	return k;
@@ -676,7 +721,7 @@ struct kobject *kobject_kset_add_dir(struct kset *kset,
  */
 struct kobject *kobject_add_dir(struct kobject *parent, const char *name)
 {
-	return kobject_kset_add_dir(NULL, parent, name);
+	return kobject_create_and_add(name, parent);
 }
 
 /**
-- 
1.5.3.8

