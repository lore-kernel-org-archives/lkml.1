Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbYAYH3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbYAYH3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbYAYHQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:47578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbYAYHQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 044/196] kset: add kset_create_and_add function
Date: Thu, 24 Jan 2008 23:09:42 -0800
Message-Id: <1201245134-4876-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now ksets can be dynamically created on the fly, no static definitions
are required.  Thanks to Miklos for hints on how to make this work
better for the callers.

And thanks to Kay for finding some stupid bugs in my original version
and pointing out that we need to handle the fact that kobject's can have
a kset as a parent and to handle that properly in kobject_add().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    4 ++-
 lib/kobject.c           |   92 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 0b97b3a..f91aeb7 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -150,11 +150,13 @@ struct kset {
 	struct kset_uevent_ops	*uevent_ops;
 };
 
-
 extern void kset_init(struct kset * k);
 extern int __must_check kset_add(struct kset * k);
 extern int __must_check kset_register(struct kset * k);
 extern void kset_unregister(struct kset * k);
+extern struct kset * __must_check kset_create_and_add(const char *name,
+						struct kset_uevent_ops *u,
+						struct kobject *parent_kobj);
 
 static inline struct kset * to_kset(struct kobject * kobj)
 {
diff --git a/lib/kobject.c b/lib/kobject.c
index 8f24940..4fb27ba 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -186,8 +186,15 @@ int kobject_add(struct kobject * kobj)
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
 
-		if (!parent)
+		if (!parent) {
 			parent = kobject_get(&kobj->kset->kobj);
+			/*
+			 * If the kset is our parent, get a second
+			 * reference, we drop both the kset and the
+			 * parent ref on cleanup
+			 */
+			kobject_get(parent);
+		}
 
 		list_add_tail(&kobj->entry,&kobj->kset->list);
 		spin_unlock(&kobj->kset->list_lock);
@@ -787,6 +794,89 @@ int subsys_create_file(struct kset *s, struct subsys_attribute *a)
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
+ *
+ * This function creates a kset structure dynamically.  This structure can
+ * then be registered with the system and show up in sysfs with a call to
+ * kset_register().  When you are finished with this structure, if
+ * kset_register() has been called, call kset_unregister() and the
+ * structure will be dynamically freed when it is no longer being used.
+ *
+ * If the kset was not able to be created, NULL will be returned.
+ */
+static struct kset *kset_create(const char *name,
+				struct kset_uevent_ops *uevent_ops,
+				struct kobject *parent_kobj)
+{
+	struct kset *kset;
+
+	kset = kzalloc(sizeof(*kset), GFP_KERNEL);
+	if (!kset)
+		return NULL;
+	kobject_set_name(&kset->kobj, name);
+	kset->uevent_ops = uevent_ops;
+	kset->kobj.parent = parent_kobj;
+
+	/*
+	 * The kobject of this kset will have a type of kset_type and belong to
+	 * no kset itself.  That way we can properly free it when it is
+	 * finished being used.
+	 */
+	kset->kobj.ktype = &kset_type;
+	kset->kobj.kset = NULL;
+
+	return kset;
+}
+
+/**
+ * kset_create_and_add - create a struct kset dynamically and add it to sysfs
+ *
+ * @name: the name for the kset
+ * @uevent_ops: a struct kset_uevent_ops for the kset
+ * @parent_kobj: the parent kobject of this kset, if any.
+ *
+ * This function creates a kset structure dynamically and registers it
+ * with sysfs.  When you are finished with this structure, call
+ * kset_unregister() and the structure will be dynamically freed when it
+ * is no longer being used.
+ *
+ * If the kset was not able to be created, NULL will be returned.
+ */
+struct kset *kset_create_and_add(const char *name,
+				 struct kset_uevent_ops *uevent_ops,
+				 struct kobject *parent_kobj)
+{
+	struct kset *kset;
+	int error;
+
+	kset = kset_create(name, uevent_ops, parent_kobj);
+	if (!kset)
+		return NULL;
+	error = kset_register(kset);
+	if (error) {
+		kfree(kset);
+		return NULL;
+	}
+	return kset;
+}
+EXPORT_SYMBOL_GPL(kset_create_and_add);
+
 EXPORT_SYMBOL(kobject_init);
 EXPORT_SYMBOL(kobject_register);
 EXPORT_SYMBOL(kobject_unregister);
-- 
1.5.3.8

