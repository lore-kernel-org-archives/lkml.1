Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbXLABDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbXLABDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbXLABDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:03:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39923 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758398AbXLABDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:03:24 -0500
Date: Fri, 30 Nov 2007 17:01:23 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [RFC] kobject: add kobject_init_ng, kobject_add_ng, and
	kobject_init_and_add functions
Message-ID: <20071201010123.GC4745@kroah.com>
References: <20071201010038.GB4745@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201010038.GB4745@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is what the kobject_init function is going to become.  Add it to
the kernel and then we can convert over the current kobject_init() users
before renaming it.

Also add a kobject_init_and_add function which bundles up what a lot of
the current callers want to do all at once, and it properly handles the
memory usages, unlike kobject_register();

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kobject.h |   11 ++-
 lib/kobject.c           |  152 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 156 insertions(+), 7 deletions(-)

--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -79,9 +79,16 @@ static inline const char * kobject_name(
 }
 
 extern void kobject_init(struct kobject *);
-extern void kobject_cleanup(struct kobject *);
-
+extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *);
+extern int __must_check kobject_add_ng(struct kobject *kobj,
+				       struct kobject *parent,
+				       const char *fmt, ...);
+extern int __must_check kobject_init_and_add(struct kobject *kobj,
+					     struct kobj_type *ktype,
+					     struct kobject *parent,
+					     const char *fmt, ...);
+
 extern void kobject_del(struct kobject *);
 
 extern struct kobject * __must_check kobject_create(const char *name,
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -348,6 +348,149 @@ int kobject_set_name(struct kobject *kob
 EXPORT_SYMBOL(kobject_set_name);
 
 /**
+ * kobject_init_ng - initialize a kobject structure
+ * @kobj: pointer to the kobject to initialize
+ * @ktype: pointer to the ktype for this kobject.
+ * @parent: pointer to the parent of this kobject.
+ * @fmt: the name of the kobject.
+ *
+ * This function will properly initialize a kobject such that it can then
+ * be passed to the kobject_add() call.
+ *
+ * If the function returns an error, the memory allocated by the kobject
+ * can be safely freed, no other functions need to be called.
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
+ * memory is with a call to kobject_del().
+ *
+ * Under no instance should the kobject that is passed to this function
+ * be directly freed with a call to kfree(), that can leak memory.
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
+	retval = kobject_set_name_vargs(kobj, fmt, args);
+	va_end(args);
+	if (retval) {
+		printk(KERN_ERR "kobject: can not set name properly!\n");
+		return retval;
+	}
+	kobj->parent = parent;
+	return kobject_add(kobj);
+}
+EXPORT_SYMBOL(kobject_add_ng);
+
+/**
+ * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
+ * @kobj: pointer to the kobject to initialize
+ * @ktype: pointer to the ktype for this kobject.
+ * @parent: pointer to the parent of this kobject.
+ * @fmt: the name of the kobject.
+ *
+ * This function will properly initialize a kobject and then call
+ * kobject_add().
+ *
+ * If the function returns an error, the kobject passed to this function
+ * must be cleaned up by calling kobject_put(), and not by directly
+ * trying to call kfree() on the kobject.
+ *
+ * If this function succeeds, the only way to properly clean up the
+ * kobject is to call kobject_destroy(), which will clean up all of the
+ * needed sysfs objects, and the kobject itself (by calling back to the
+ * ktype->release() function.)
+ *
+ * Note that the kobject_uevent() call should be called after this
+ * function succeeds, so that userspace can properly know that the
+ * kobject was created.
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
+EXPORT_SYMBOL(kobject_init_and_add);
+
+/**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
  *	@new_name: object's new name
@@ -502,12 +645,11 @@ struct kobject * kobject_get(struct kobj
 	return kobj;
 }
 
-/**
- *	kobject_cleanup - free kobject resources. 
- *	@kobj:	object.
+/*
+ * kobject_cleanup - free kobject resources.
+ * @kobj: object.
  */
-
-void kobject_cleanup(struct kobject * kobj)
+static void kobject_cleanup(struct kobject *kobj)
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
