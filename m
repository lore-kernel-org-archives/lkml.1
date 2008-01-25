Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbYAYH2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbYAYH2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYAYHQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:47558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbYAYHQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 041/196] kobject: add kobject_init_and_add function
Date: Thu, 24 Jan 2008 23:09:39 -0800
Message-Id: <1201245134-4876-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add a kobject_init_and_add function which bundles up what a lot of
the current callers want to do all at once, and it properly handles the
memory usages, unlike kobject_register();

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    5 +++++
 lib/kobject.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 57eea4c..e2b8c3d 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -84,6 +84,11 @@ extern int __must_check kobject_add(struct kobject *);
 extern int __must_check kobject_add_ng(struct kobject *kobj,
 				       struct kobject *parent,
 				       const char *fmt, ...);
+extern int __must_check kobject_init_and_add(struct kobject *kobj,
+					     struct kobj_type *ktype,
+					     struct kobject *parent,
+					     const char *fmt, ...);
+
 extern void kobject_del(struct kobject *);
 
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
diff --git a/lib/kobject.c b/lib/kobject.c
index 329fd11..8f24940 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -391,6 +391,33 @@ int kobject_add_ng(struct kobject *kobj, struct kobject *parent,
 EXPORT_SYMBOL(kobject_add_ng);
 
 /**
+ * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
+ * @kobj: pointer to the kobject to initialize
+ * @ktype: pointer to the ktype for this kobject.
+ * @parent: pointer to the parent of this kobject.
+ * @fmt: the name of the kobject.
+ *
+ * This function combines the call to kobject_init_ng() and
+ * kobject_add_ng().  The same type of error handling after a call to
+ * kobject_add_ng() and kobject lifetime rules are the same here.
+ */
+int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
+			 struct kobject *parent, const char *fmt, ...)
+{
+	va_list args;
+	int retval;
+
+	kobject_init_ng(kobj, ktype);
+
+	va_start(args, fmt);
+	retval = kobject_add_varg(kobj, parent, fmt, args);
+	va_end(args);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(kobject_init_and_add);
+
+/**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
  *	@new_name: object's new name
-- 
1.5.3.8

