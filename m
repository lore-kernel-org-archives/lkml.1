Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbYAYHxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbYAYHxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbYAYHgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:49939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760488AbYAYHgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 096/196] kobject: convert kernel_kset to be a kobject
Date: Thu, 24 Jan 2008 23:32:05 -0800
Message-Id: <1201246425-5058-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_kset does not need to be a kset, but a much simpler kobject now
that we have kobj_attributes.

We also rename kernel_kset to kernel_kobj to catch all users of this
symbol with a build error instead of an easy-to-ignore build warning.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/configfs/mount.c         |    2 +-
 fs/debugfs/inode.c          |    2 +-
 fs/dlm/lockspace.c          |    2 +-
 fs/gfs2/locking/dlm/sysfs.c |    2 +-
 include/linux/kobject.h     |    4 ++--
 kernel/ksysfs.c             |   18 +++++++++---------
 kernel/user.c               |    2 +-
 mm/slub.c                   |    3 +--
 security/inode.c            |    2 +-
 9 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index c4ee7f0..54bf0db 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -140,7 +140,7 @@ static int __init configfs_init(void)
 	if (!configfs_dir_cachep)
 		goto out;
 
-	config_kobj = kobject_create_and_add("config", &kernel_kset->kobj);
+	config_kobj = kobject_create_and_add("config", kernel_kobj);
 	if (!config_kobj) {
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 5ce92c3..97f6381 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -432,7 +432,7 @@ static int __init debugfs_init(void)
 {
 	int retval;
 
-	debug_kobj = kobject_create_and_add("debug", &kernel_kset->kobj);
+	debug_kobj = kobject_create_and_add("debug", kernel_kobj);
 	if (!debug_kobj)
 		return -EINVAL;
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 0828beb..e64b0dc 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -223,7 +223,7 @@ int dlm_lockspace_init(void)
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
-	dlm_kset = kset_create_and_add("dlm", NULL, &kernel_kset->kobj);
+	dlm_kset = kset_create_and_add("dlm", NULL, kernel_kobj);
 	if (!dlm_kset) {
 		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
 		return -ENOMEM;
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index 1a92b6f..e5a4fbf 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -219,7 +219,7 @@ void gdlm_kobject_release(struct gdlm_ls *ls)
 
 int gdlm_sysfs_init(void)
 {
-	gdlm_kset = kset_create_and_add("lock_dlm", NULL, &kernel_kset->kobj);
+	gdlm_kset = kset_create_and_add("lock_dlm", NULL, kernel_kobj);
 	if (!gdlm_kset) {
 		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
 		return -ENOMEM;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 9da3523..0930efd 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -198,8 +198,8 @@ extern struct kobject * kset_find_obj(struct kset *, const char *);
 #define set_kset_name(str)	.kset = { .kobj = { .k_name = str } }
 
 
-/* The global /sys/kernel/ kset for people to chain off of */
-extern struct kset *kernel_kset;
+/* The global /sys/kernel/ kobject for people to chain off of */
+extern struct kobject *kernel_kobj;
 /* The global /sys/hypervisor/ kobject for people to chain off of */
 extern struct kobject *hypervisor_kobj;
 /* The global /sys/power/ kset for people to chain off of */
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 45e6465..1081aff 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -101,8 +101,8 @@ static struct bin_attribute notes_attr = {
 	.read = &notes_read,
 };
 
-struct kset *kernel_kset;
-EXPORT_SYMBOL_GPL(kernel_kset);
+struct kobject *kernel_kobj;
+EXPORT_SYMBOL_GPL(kernel_kobj);
 
 static struct attribute * kernel_attrs[] = {
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
@@ -125,18 +125,18 @@ static int __init ksysfs_init(void)
 {
 	int error;
 
-	kernel_kset = kset_create_and_add("kernel", NULL, NULL);
-	if (!kernel_kset) {
+	kernel_kobj = kobject_create_and_add("kernel", NULL);
+	if (!kernel_kobj) {
 		error = -ENOMEM;
 		goto exit;
 	}
-	error = sysfs_create_group(&kernel_kset->kobj, &kernel_attr_group);
+	error = sysfs_create_group(kernel_kobj, &kernel_attr_group);
 	if (error)
 		goto kset_exit;
 
 	if (notes_size > 0) {
 		notes_attr.size = notes_size;
-		error = sysfs_create_bin_file(&kernel_kset->kobj, &notes_attr);
+		error = sysfs_create_bin_file(kernel_kobj, &notes_attr);
 		if (error)
 			goto group_exit;
 	}
@@ -150,11 +150,11 @@ static int __init ksysfs_init(void)
 
 notes_exit:
 	if (notes_size > 0)
-		sysfs_remove_bin_file(&kernel_kset->kobj, &notes_attr);
+		sysfs_remove_bin_file(kernel_kobj, &notes_attr);
 group_exit:
-	sysfs_remove_group(&kernel_kset->kobj, &kernel_attr_group);
+	sysfs_remove_group(kernel_kobj, &kernel_attr_group);
 kset_exit:
-	kset_unregister(kernel_kset);
+	kobject_unregister(kernel_kobj);
 exit:
 	return error;
 }
diff --git a/kernel/user.c b/kernel/user.c
index 5a106f3..7f17e6e 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -201,7 +201,7 @@ done:
  */
 int __init uids_sysfs_init(void)
 {
-	uids_kset = kset_create_and_add("uids", NULL, &kernel_kset->kobj);
+	uids_kset = kset_create_and_add("uids", NULL, kernel_kobj);
 	if (!uids_kset)
 		return -ENOMEM;
 
diff --git a/mm/slub.c b/mm/slub.c
index b6c7946..d26177f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4091,8 +4091,7 @@ static int __init slab_sysfs_init(void)
 	struct kmem_cache *s;
 	int err;
 
-	slab_kset = kset_create_and_add("slab", &slab_uevent_ops,
-					&kernel_kset->kobj);
+	slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
 	if (!slab_kset) {
 		printk(KERN_ERR "Cannot register slab subsystem.\n");
 		return -ENOSYS;
diff --git a/security/inode.c b/security/inode.c
index dbe040a..def0cc1 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -321,7 +321,7 @@ static int __init securityfs_init(void)
 {
 	int retval;
 
-  	security_kobj = kobject_create_and_add("security", &kernel_kset->kobj);
+	security_kobj = kobject_create_and_add("security", kernel_kobj);
 	if (!security_kobj)
 		return -EINVAL;
 
-- 
1.5.3.8

