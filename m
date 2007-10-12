Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXJLW0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXJLW0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758442AbXJLWSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:49641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761212AbXJLWSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 15/75] kobject: remove the static array for the name
Date: Fri, 12 Oct 2007 15:16:19 -0700
Message-Id: <11922275074080-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275031518-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
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
 lib/kobject.c           |   79 +++++++++++++++++++++++------------------------
 2 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index c0fb535..8b45946 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -63,7 +63,6 @@ extern const char *kobject_actions[];
 
 struct kobject {
 	const char		* k_name;
-	char			name[KOBJ_NAME_LEN];
 	struct kref		kref;
 	struct list_head	entry;
 	struct kobject		* parent;
@@ -188,18 +187,18 @@ extern struct kobject * kset_find_obj(struct kset *, const char *);
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
diff --git a/lib/kobject.c b/lib/kobject.c
index 1326041..10ae2eb 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -170,7 +170,7 @@ int kobject_shadow_add(struct kobject *kobj, struct sysfs_dirent *shadow_parent)
 	if (!(kobj = kobject_get(kobj)))
 		return -ENOENT;
 	if (!kobj->k_name)
-		kobj->k_name = kobj->name;
+		kobject_set_name(kobj, "NO_NAME");
 	if (!*kobj->k_name) {
 		pr_debug("kobject attempted to be registered with no name!\n");
 		WARN_ON(1);
@@ -181,7 +181,7 @@ int kobject_shadow_add(struct kobject *kobj, struct sysfs_dirent *shadow_parent)
 
 	pr_debug("kobject %s: registering. parent: %s, set: %s\n",
 		 kobject_name(kobj), parent ? kobject_name(parent) : "<NULL>", 
-		 kobj->kset ? kobj->kset->kobj.name : "<NULL>" );
+		 kobj->kset ? kobject_name(&kobj->kset->kobj) : "<NULL>" );
 
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
@@ -255,54 +255,50 @@ int kobject_register(struct kobject * kobj)
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
@@ -477,13 +473,16 @@ void kobject_cleanup(struct kobject * kobj)
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
 	struct kobject * parent = kobj->parent;
+	const char *name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	if (kobj->k_name != kobj->name)
-		kfree(kobj->k_name);
-	kobj->k_name = NULL;
-	if (t && t->release)
+	if (t && t->release) {
 		t->release(kobj);
+		/* If we have a release function, we can guess that this was
+		 * not a statically allocated kobject, so we should be safe to
+		 * free the name */
+		kfree(name);
+	}
 	if (s)
 		kset_put(s);
 	kobject_put(parent);
-- 
1.5.3.4

