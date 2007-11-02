Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbXKCABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbXKCABU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbXKCAAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:34779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbXKCAAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 04/54] kset: add kset_create_and_register function
Date: Fri,  2 Nov 2007 16:58:42 -0700
Message-Id: <1194047972-9850-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now ksets can be dynamically created on the fly, no static definitions
are required.  Thanks to Miklos for hints on how to make this work
better for the callers.

And thanks to Kay for finding some stupid bugs in my original version.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    5 ++-
 lib/kobject.c           |   91 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 4e8a542..205d186 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -143,11 +143,14 @@ struct kset {
 	struct kset_uevent_ops	*uevent_ops;
 };
 
-
 extern void kset_init(struct kset * k);
 extern int __must_check kset_add(struct kset * k);
 extern int __must_check kset_register(struct kset * k);
 extern void kset_unregister(struct kset * k);
+extern struct kset * __must_check kset_create_and_register(const char *name,
+							   struct kset_uevent_ops *u,
+							   struct kobject *parent_kobj,
+							   struct kset *parent_kset);
 
 static inline struct kset * to_kset(struct kobject * kobj)
 {
diff --git a/lib/kobject.c b/lib/kobject.c
index a7e3bf4..725fe2e 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kobject.h>
+#include <linux/err.h>
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/stat.h>
@@ -662,6 +663,96 @@ int subsys_create_file(struct kset *s, struct subsys_attribute *a)
 	return error;
 }
 
+static void kset_release(struct kobject *kobj)
+{
+	struct kset *kset = container_of(kobj, struct kset, kobj);
+	pr_debug("kset %s: now freed\n", kobject_name(kobj));
+	kfree(kset);
+}
+
+static struct kobj_type kset_type = {
+	.release = kset_release,
+};
+
+/**
+ * kset_create - create a struct kset dynamically
+ *
+ * @name: the name for the kset
+ * @uevent_ops: a struct kset_uevent_ops for the kset
+ * @parent_kobj: the parent kobject of this kset, if any.
+ * @parent_kset: the parent kset of this kset, if any.
+ *
+ * This function creates a kset structure dynamically.  This structure can
+ * then be registered with the system and show up in sysfs with a call to
+ * kset_register().  When you are finished with this structure, if
+ * kset_register() has been called, call kset_unregister() and the
+ * structure will be dynamically freed when it is no longer being used.
+ *
+ * NOTE, you can not have both a @parent_kobj and a @parent_kset, pick one
+ * or the other.
+ */
+static struct kset *kset_create(const char *name,
+				struct kset_uevent_ops *uevent_ops,
+				struct kobject *parent_kobj,
+				struct kset *parent_kset)
+{
+	struct kset *kset;
+
+	if ((parent_kobj) && (parent_kset)) {
+		printk(KERN_WARNING "Can not specify both a parent kset and a "
+		       "parent kobject for %s\n", __FUNCTION__);
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
+	}
+
+	kset = kzalloc(sizeof(*kset), GFP_KERNEL);
+	if (!kset)
+		return ERR_PTR(-ENOMEM);
+	kobject_set_name(&kset->kobj, name);
+	kset->uevent_ops = uevent_ops;
+	kset->kobj.parent = parent_kobj;
+	kset->kobj.kset = parent_kset;
+	kset->kobj.ktype = &kset_type;
+
+	return kset;
+}
+
+/**
+ * kset_create_and_register - create a struct kset dynamically and register it with sysfs
+ *
+ * @name: the name for the kset
+ * @uevent_ops: a struct kset_uevent_ops for the kset
+ * @parent_kobj: the parent kobject of this kset, if any.
+ * @parent_kset: the parent kset of this kset, if any.
+ *
+ * This function creates a kset structure dynamically and registers it
+ * with sysfs.  When you are finished with this structure, call
+ * kset_unregister() and the structure will be dynamically freed when it
+ * is no longer being used.
+ *
+ * NOTE, you can not have both a @parent_kobj and a @parent_kset, pick one
+ * or the other.
+ */
+struct kset *kset_create_and_register(const char *name,
+				      struct kset_uevent_ops *uevent_ops,
+				      struct kobject *parent_kobj,
+				      struct kset *parent_kset)
+{
+	struct kset *kset;
+	int error;
+
+	kset = kset_create(name, uevent_ops, parent_kobj, parent_kset);
+	if (IS_ERR(kset))
+		return kset;
+	error = kset_register(kset);
+	if (error) {
+		kfree(kset);
+		return ERR_PTR(error);
+	}
+	return kset;
+}
+EXPORT_SYMBOL_GPL(kset_create_and_register);
+
 EXPORT_SYMBOL(kobject_init);
 EXPORT_SYMBOL(kobject_register);
 EXPORT_SYMBOL(kobject_unregister);
-- 
1.5.3.4

