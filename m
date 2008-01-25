Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbYAYH2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbYAYH2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbYAYHQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:33 -0500
Received: from ns1.suse.de ([195.135.220.2]:52657 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758791AbYAYHQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 040/196] kobject: add kobject_add_ng function
Date: Thu, 24 Jan 2008 23:09:38 -0800
Message-Id: <1201245134-4876-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what the kobject_add function is going to become.

Add this to the kernel and then we can convert the tree over to use it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    3 ++
 lib/kobject.c           |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index bdf4f7c..57eea4c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -81,6 +81,9 @@ static inline const char * kobject_name(const struct kobject * kobj)
 extern void kobject_init(struct kobject *);
 extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *);
+extern int __must_check kobject_add_ng(struct kobject *kobj,
+				       struct kobject *parent,
+				       const char *fmt, ...);
 extern void kobject_del(struct kobject *);
 
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
diff --git a/lib/kobject.c b/lib/kobject.c
index 60586bc..329fd11 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -324,6 +324,72 @@ error:
 }
 EXPORT_SYMBOL(kobject_init_ng);
 
+static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
+			    const char *fmt, va_list vargs)
+{
+	va_list aq;
+	int retval;
+
+	va_copy(aq, vargs);
+	retval = kobject_set_name_vargs(kobj, fmt, aq);
+	va_end(aq);
+	if (retval) {
+		printk(KERN_ERR "kobject: can not set name properly!\n");
+		return retval;
+	}
+	kobj->parent = parent;
+	return kobject_add(kobj);
+}
+
+/**
+ * kobject_add_ng - the main kobject add function
+ * @kobj: the kobject to add
+ * @parent: pointer to the parent of the kobject.
+ * @fmt: format to name the kobject with.
+ *
+ * The kobject name is set and added to the kobject hierarchy in this
+ * function.
+ *
+ * If @parent is set, then the parent of the @kobj will be set to it.
+ * If @parent is NULL, then the parent of the @kobj will be set to the
+ * kobject associted with the kset assigned to this kobject.  If no kset
+ * is assigned to the kobject, then the kobject will be located in the
+ * root of the sysfs tree.
+ *
+ * If this function returns an error, kobject_put() must be called to
+ * properly clean up the memory associated with the object.
+ *
+ * If the function is successful, the only way to properly clean up the
+ * memory is with a call to kobject_del(), in which case, a call to
+ * kobject_put() is not necessary (kobject_del() does the final
+ * kobject_put() to call the release function in the ktype's release
+ * pointer.)
+ *
+ * Under no instance should the kobject that is passed to this function
+ * be directly freed with a call to kfree(), that can leak memory.
+ *
+ * Note, no uevent will be created with this call, the caller should set
+ * up all of the necessary sysfs files for the object and then call
+ * kobject_uevent() with the UEVENT_ADD parameter to ensure that
+ * userspace is properly notified of this kobject's creation.
+ */
+int kobject_add_ng(struct kobject *kobj, struct kobject *parent,
+		   const char *fmt, ...)
+{
+	va_list args;
+	int retval;
+
+	if (!kobj)
+		return -EINVAL;
+
+	va_start(args, fmt);
+	retval = kobject_add_varg(kobj, parent, fmt, args);
+	va_end(args);
+
+	return retval;
+}
+EXPORT_SYMBOL(kobject_add_ng);
+
 /**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
-- 
1.5.3.8

