Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbXK3T4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbXK3T4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXK3T43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:56:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60234 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbXK3T42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:56:28 -0500
Date: Fri, 30 Nov 2007 11:53:00 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
	functions
Message-ID: <20071130195300.GB4659@kroah.com>
References: <20071130195150.GA4659@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130195150.GA4659@kroah.com>
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
 include/linux/kobject.h |    8 ++++
 lib/kobject.c           |   91 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -79,6 +79,14 @@ static inline const char * kobject_name(
 }
 
 extern void kobject_init(struct kobject *);
+extern int __must_check kobject_init_ng(struct kobject *kobj,
+					struct kobj_type *ktype,
+					struct kobject *parent,
+					const char *fmt, ...);
+extern int __must_check kobject_init_and_add(struct kobject *kobj,
+					     struct kobj_type *ktype,
+					     struct kobject *parent,
+					     const char *fmt, ...);
 extern void kobject_cleanup(struct kobject *);
 
 extern int __must_check kobject_add(struct kobject *);
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -347,6 +347,97 @@ int kobject_set_name(struct kobject *kob
 }
 EXPORT_SYMBOL(kobject_set_name);
 
+/*
+ * kobject_init_varg - the main kobject init function
+ *
+ * The kobject is initialized here with the needed fields.  After this
+ * function returns successfully, the kobject can not be freed directly,
+ * kobject_put must be called in order to clean it up properly.  If this
+ * function returns an error, the memory can be safely freed directly.
+ */
+static int kobject_init_varg(struct kobject *kobj, struct kobj_type *ktype,
+			     struct kobject *parent, const char *fmt,
+			     va_list vargs)
+{
+	va_list aq;
+	int retval;
+
+	if ((!kobj) || (!ktype))
+		return -EINVAL;
+
+	WARN_ON(atomic_read(&kobj->kref.refcount));
+	kref_init(&kobj->kref);
+	INIT_LIST_HEAD(&kobj->entry);
+	kobj->ktype = ktype;
+	kobj->parent = parent;
+
+	va_copy(aq, vargs);
+	retval = kobject_set_name_vargs(kobj, fmt, aq);
+	va_end(aq);
+
+	return retval;
+}
+
+/**
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
+int kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype,
+		    struct kobject *parent, const char *fmt, ...)
+{
+	va_list args;
+	int retval;
+
+	va_start(args, fmt);
+	retval = kobject_init_varg(kobj, ktype, parent, fmt, args);
+	va_end(args);
+
+	return retval;
+}
+EXPORT_SYMBOL(kobject_init_ng);
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
+ * If the function returns an error, the memory allocated by the kobject
+ * can be safely freed, no other functions need to be called.
+ */
+int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
+			 struct kobject *parent, const char *fmt, ...)
+{
+	va_list args;
+	int retval;
+
+	va_start(args, fmt);
+	retval = kobject_init_varg(kobj, ktype, parent, fmt, args);
+	va_end(args);
+	if (retval)
+		return retval;
+
+	retval = kobject_add(kobj);
+	if (retval)
+		kobject_put(kobj);
+
+	return retval;
+}
+EXPORT_SYMBOL(kobject_init_and_add);
+
 /**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
