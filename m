Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbYAYH1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbYAYH1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbYAYHQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320AbYAYHQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 039/196] kobject: add kobject_init_ng function
Date: Thu, 24 Jan 2008 23:09:37 -0800
Message-Id: <1201245134-4876-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what the kobject_init function is going to become.

Add this to the kernel and then we can convert the tree over to use it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    1 +
 lib/kobject.c           |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 2d19a07..bdf4f7c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -79,6 +79,7 @@ static inline const char * kobject_name(const struct kobject * kobj)
 }
 
 extern void kobject_init(struct kobject *);
+extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *);
 extern void kobject_del(struct kobject *);
 
diff --git a/lib/kobject.c b/lib/kobject.c
index a152036..60586bc 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -283,6 +283,48 @@ int kobject_set_name(struct kobject *kobj, const char *fmt, ...)
 EXPORT_SYMBOL(kobject_set_name);
 
 /**
+ * kobject_init_ng - initialize a kobject structure
+ * @kobj: pointer to the kobject to initialize
+ * @ktype: pointer to the ktype for this kobject.
+ *
+ * This function will properly initialize a kobject such that it can then
+ * be passed to the kobject_add() call.
+ *
+ * After this function is called, the kobject MUST be cleaned up by a call
+ * to kobject_put(), not by a call to kfree directly to ensure that all of
+ * the memory is cleaned up properly.
+ */
+void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype)
+{
+	char *err_str;
+
+	if (!kobj) {
+		err_str = "invalid kobject pointer!";
+		goto error;
+	}
+	if (!ktype) {
+		err_str = "must have a ktype to be initialized properly!\n";
+		goto error;
+	}
+	if (atomic_read(&kobj->kref.refcount)) {
+		/* do not error out as sometimes we can recover */
+		printk(KERN_ERR "kobject: reference count is already set, "
+		       "something is seriously wrong.\n");
+		dump_stack();
+	}
+
+	kref_init(&kobj->kref);
+	INIT_LIST_HEAD(&kobj->entry);
+	kobj->ktype = ktype;
+	return;
+
+error:
+	printk(KERN_ERR "kobject: %s\n", err_str);
+	dump_stack();
+}
+EXPORT_SYMBOL(kobject_init_ng);
+
+/**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
  *	@new_name: object's new name
-- 
1.5.3.8

