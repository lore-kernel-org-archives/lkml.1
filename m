Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbXIMXvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbXIMXvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932967AbXIMXpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57156 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbXIMXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:22 -0400
Date: Thu, 13 Sep 2007 16:44:35 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: kobject: remove the static array for the name
Message-ID: <20070913234435.GM10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Due to historical reasons, struct kobject contained a static array for
the name, and a dynamic pointer in case the name got bigger than the
array.  That's just dumb, as people didn't always know which variable to
reference, even with the accessor for the kobject name.

This patch removes the static array, potentially saving a lot of memory
as the majority of kobjects do not have a very long name.

Thanks to Kay for the idea to do this.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kobject.h |    7 ++--
 lib/kobject.c           |   71 ++++++++++++++++++++++--------------------------
 2 files changed, 36 insertions(+), 42 deletions(-)

--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -63,7 +63,6 @@ extern const char *kobject_actions[];
 
 struct kobject {
 	const char		* k_name;
-	char			name[KOBJ_NAME_LEN];
 	struct kref		kref;
 	struct list_head	entry;
 	struct kobject		* parent;
@@ -188,18 +187,18 @@ extern struct kobject * kset_find_obj(st
  * Use this when initializing an embedded kset with no other 
  * fields to initialize.
  */
-#define set_kset_name(str)	.kset = { .kobj = { .name = str } }
+#define set_kset_name(str)	.kset = { .kobj = { .k_name = str } }
 
 
 #define decl_subsys(_name,_type,_uevent_ops) \
 struct kset _name##_subsys = { \
-	.kobj = { .name = __stringify(_name) }, \
+	.kobj = { .k_name = __stringify(_name) }, \
 	.ktype = _type, \
 	.uevent_ops =_uevent_ops, \
 }
 #define decl_subsys_name(_varname,_name,_type,_uevent_ops) \
 struct kset _varname##_subsys = { \
-	.kobj = { .name = __stringify(_name) }, \
+	.kobj = { .k_name = __stringify(_name) }, \
 	.ktype = _type, \
 	.uevent_ops =_uevent_ops, \
 }
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -170,7 +170,7 @@ int kobject_shadow_add(struct kobject *k
 	if (!(kobj = kobject_get(kobj)))
 		return -ENOENT;
 	if (!kobj->k_name)
-		kobj->k_name = kobj->name;
+		kobject_set_name(kobj, "NO_NAME");
 	if (!*kobj->k_name) {
 		pr_debug("kobject attempted to be registered with no name!\n");
 		WARN_ON(1);
@@ -181,7 +181,7 @@ int kobject_shadow_add(struct kobject *k
 
 	pr_debug("kobject %s: registering. parent: %s, set: %s\n",
 		 kobject_name(kobj), parent ? kobject_name(parent) : "<NULL>", 
-		 kobj->kset ? kobj->kset->kobj.name : "<NULL>" );
+		 kobj->kset ? kobject_name(&kobj->kset->kobj) : "<NULL>" );
 
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
@@ -255,54 +255,50 @@ int kobject_register(struct kobject * ko
 int kobject_set_name(struct kobject * kobj, const char * fmt, ...)
 {
 	int error = 0;
-	int limit = KOBJ_NAME_LEN;
+	int limit;
 	int need;
 	va_list args;
-	char * name;
+	char *name;
 
-	/* 
-	 * First, try the static array 
-	 */
-	va_start(args,fmt);
-	need = vsnprintf(kobj->name,limit,fmt,args);
+	/* find out how big a buffer we need */
+	name = kmalloc(1024, GFP_KERNEL);
+	if (!name) {
+		error = -ENOMEM;
+		goto done;
+	}
+	va_start(args, fmt);
+	need = vsnprintf(name, 1024, fmt, args);
 	va_end(args);
-	if (need < limit) 
-		name = kobj->name;
-	else {
-		/* 
-		 * Need more space? Allocate it and try again 
-		 */
-		limit = need + 1;
-		name = kmalloc(limit,GFP_KERNEL);
-		if (!name) {
-			error = -ENOMEM;
-			goto Done;
-		}
-		va_start(args,fmt);
-		need = vsnprintf(name,limit,fmt,args);
-		va_end(args);
-
-		/* Still? Give up. */
-		if (need >= limit) {
-			kfree(name);
-			error = -EFAULT;
-			goto Done;
-		}
+	kfree(name);
+
+	/* Allocate the new space and copy the string in */
+	limit = need + 1;
+	name = kmalloc(limit, GFP_KERNEL);
+	if (!name) {
+		error = -ENOMEM;
+		goto done;
+	}
+	va_start(args, fmt);
+	need = vsnprintf(name, limit, fmt, args);
+	va_end(args);
+
+	/* something wrong with the string we copied? */
+	if (need >= limit) {
+		kfree(name);
+		error = -EFAULT;
+		goto done;
 	}
 
 	/* Free the old name, if necessary. */
-	if (kobj->k_name && kobj->k_name != kobj->name)
-		kfree(kobj->k_name);
+	kfree(kobj->k_name);
 
 	/* Now, set the new name */
 	kobj->k_name = name;
- Done:
+done:
 	return error;
 }
-
 EXPORT_SYMBOL(kobject_set_name);
 
-
 /**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
@@ -479,8 +475,7 @@ void kobject_cleanup(struct kobject * ko
 	struct kobject * parent = kobj->parent;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	if (kobj->k_name != kobj->name)
-		kfree(kobj->k_name);
+	kfree(kobj->k_name);
 	kobj->k_name = NULL;
 	if (t && t->release)
 		t->release(kobj);
