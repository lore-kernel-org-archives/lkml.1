Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXDUEnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXDUEnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 00:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXDUEnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 00:43:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34976 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752043AbXDUEm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 00:42:59 -0400
Date: Fri, 20 Apr 2007 21:42:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org
Subject: sysfs: Need ability to remove all symlinks pointing to an object
Message-ID: <Pine.LNX.4.64.0704202140380.16852@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How do I remove all references to an object in sysfs? The following patch
attempt to get that functionality in sysfs but I am not that familiar with 
it. Help....



SLUB: Remove alias before installing symlink

We cannot really track the aliases that are created when aliasing
a slab. kmem_cache_destroy only decrements a refcounter. This
means that the aliases are never removed. However, when the last
ref count to a slab is dropped then we should remove all symlinks.

Signed-off-by: Chriustoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc6/mm/slub.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slub.c	2007-04-20 16:44:14.000000000 -0700
+++ linux-2.6.21-rc6/mm/slub.c	2007-04-20 17:12:18.000000000 -0700
@@ -3315,6 +3315,7 @@ static int sysfs_slab_add(struct kmem_ca
 		/* Defer until later */
 		return 0;
 
+	sysfs_remove_link(&slab_subsys.kset.kobj, s->name);
 	kobj_set_kset_s(s, slab_subsys);
 	kobject_set_name(&s->kobj, s->name);
 	kobject_init(&s->kobj);
@@ -3329,8 +3330,18 @@ static int sysfs_slab_add(struct kmem_ca
 	return 0;
 }
 
+static void sysfs_remove_aliases(struct kmem_cache *s)
+{
+	/*
+	 * Remove all symlinks pointing to the kobject of
+	 * in the kmem_cache structure
+	 */
+	sysfs_remove_links(&slab_subsys.kset, &s->kobj);
+}
+
 static void sysfs_slab_remove(struct kmem_cache *s)
 {
+	sysfs_remove_aliases(s);
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 }
@@ -3351,9 +3362,11 @@ static int sysfs_slab_alias(struct kmem_
 {
 	struct saved_alias *al;
 
-	if (slab_state == SYSFS)
+	if (slab_state == SYSFS) {
+		sysfs_remove_link(&slab_subsys.kset.kobj, name);
 		return sysfs_create_link(&slab_subsys.kset.kobj,
 						&s->kobj, name);
+	}
 
 	al = kmalloc(sizeof(struct saved_alias), GFP_KERNEL);
 	if (!al)
Index: linux-2.6.21-rc6/fs/sysfs/symlink.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/sysfs/symlink.c	2007-04-20 17:05:00.000000000 -0700
+++ linux-2.6.21-rc6/fs/sysfs/symlink.c	2007-04-20 17:18:50.000000000 -0700
@@ -117,6 +117,38 @@ void sysfs_remove_link(struct kobject * 
 	sysfs_hash_and_remove(kobj->dentry,name);
 }
 
+/*
+ * Remove all symlinks pointing to the indicated object
+ */
+void sysfs_remove_links(struct kset *kset, struct kobject *needle)
+{
+	struct list_head *entry;
+
+restart:
+	spin_lock(&kset->list_lock);
+	list_for_each(entry,&kset->list) {
+		struct kobject * k = container_of(entry, struct kobject, entry);
+		struct sysfs_symlink *sl =
+			container_of(k, struct sysfs_symlink, target_kobj);
+
+		if (sl->target_kobj == needle) {
+			/* sysfs_remove_link needs the lock. sigh */
+			spin_unlock(&kset->list_lock);
+
+			sysfs_remove_link(k, sl->link_name);
+			/*
+			 * Somehow sysfs_remove_link does
+			 * not clean up after itself
+			 */
+			kfree(sl->link_name);
+			kfree(sl);
+			kobject_put(needle);
+			goto restart;
+		}
+        }
+        spin_unlock(&kset->list_lock);
+}
+
 static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
 				 char *path)
 {
@@ -188,5 +220,6 @@ const struct inode_operations sysfs_syml
 };
 
 
-EXPORT_SYMBOL_GPL(sysfs_create_link);
 EXPORT_SYMBOL_GPL(sysfs_remove_link);
+EXPORT_SYMBOL_GPL(sysfs_remove_links);
+EXPORT_SYMBOL_GPL(sysfs_create_link);
Index: linux-2.6.21-rc6/include/linux/kobject.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/kobject.h	2007-04-20 17:09:03.000000000 -0700
+++ linux-2.6.21-rc6/include/linux/kobject.h	2007-04-20 17:09:49.000000000 -0700
@@ -166,6 +166,9 @@ static inline struct kobj_type * get_kty
 
 extern struct kobject * kset_find_obj(struct kset *, const char *);
 
+extern void sysfs_remove_links(struct kset *kset, struct kobject *needle);
+
+
 
 /**
  * Use this when initializing an embedded kset with no other 
