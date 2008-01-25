Return-Path: <linux-kernel-owner+w=401wt.eu-S1761829AbYAYHfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761829AbYAYHfC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbYAYHRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:53 -0500
Received: from ns1.suse.de ([195.135.220.2]:52807 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759323AbYAYHRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 059/196] kset: convert kernel_subsys to use kset_create
Date: Thu, 24 Jan 2008 23:09:57 -0800
Message-Id: <1201245134-4876-59-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.  We also
rename kernel_subsys to kernel_kset to catch all users of this symbol
with a build error instead of an easy-to-ignore build warning.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/configfs/mount.c         |    2 +-
 fs/debugfs/inode.c          |    2 +-
 fs/dlm/lockspace.c          |    2 +-
 fs/gfs2/locking/dlm/sysfs.c |    3 +--
 include/linux/kobject.h     |    4 ++--
 kernel/ksysfs.c             |   42 ++++++++++++++++++++++++++++++------------
 kernel/user.c               |    4 ++--
 security/inode.c            |    2 +-
 8 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 1330046..c4ee7f0 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -140,7 +140,7 @@ static int __init configfs_init(void)
 	if (!configfs_dir_cachep)
 		goto out;
 
-	config_kobj = kobject_create_and_add("config", &kernel_subsys.kobj);
+	config_kobj = kobject_create_and_add("config", &kernel_kset->kobj);
 	if (!config_kobj) {
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 6672142..5ce92c3 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -432,7 +432,7 @@ static int __init debugfs_init(void)
 {
 	int retval;
 
-	debug_kobj = kobject_create_and_add("debug", &kernel_subsys.kobj);
+	debug_kobj = kobject_create_and_add("debug", &kernel_kset->kobj);
 	if (!debug_kobj)
 		return -EINVAL;
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 83a9c4d..0828beb 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -223,7 +223,7 @@ int dlm_lockspace_init(void)
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
-	dlm_kset = kset_create_and_add("dlm", NULL, &kernel_subsys.kobj);
+	dlm_kset = kset_create_and_add("dlm", NULL, &kernel_kset->kobj);
 	if (!dlm_kset) {
 		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
 		return -ENOMEM;
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index 0a86140..1a92b6f 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -219,8 +219,7 @@ void gdlm_kobject_release(struct gdlm_ls *ls)
 
 int gdlm_sysfs_init(void)
 {
-	gdlm_kset = kset_create_and_add("lock_dlm", NULL,
-					&kernel_subsys.kobj);
+	gdlm_kset = kset_create_and_add("lock_dlm", NULL, &kernel_kset->kobj);
 	if (!gdlm_kset) {
 		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
 		return -ENOMEM;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 390ae14..bd741e8 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -194,8 +194,8 @@ struct kset _name##_subsys = { \
 	.uevent_ops =_uevent_ops, \
 }
 
-/* The global /sys/kernel/ subsystem for people to chain off of */
-extern struct kset kernel_subsys;
+/* The global /sys/kernel/ kset for people to chain off of */
+extern struct kset *kernel_kset;
 /* The global /sys/hypervisor/ subsystem  */
 extern struct kset hypervisor_subsys;
 
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 094e2bc..cf02d4b 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -94,8 +94,8 @@ static struct bin_attribute notes_attr = {
 	.read = &notes_read,
 };
 
-decl_subsys(kernel, NULL);
-EXPORT_SYMBOL_GPL(kernel_subsys);
+struct kset *kernel_kset;
+EXPORT_SYMBOL_GPL(kernel_kset);
 
 static struct attribute * kernel_attrs[] = {
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
@@ -116,24 +116,42 @@ static struct attribute_group kernel_attr_group = {
 
 static int __init ksysfs_init(void)
 {
-	int error = subsystem_register(&kernel_subsys);
-	if (!error)
-		error = sysfs_create_group(&kernel_subsys.kobj,
-					   &kernel_attr_group);
+	int error;
 
-	if (!error && notes_size > 0) {
+	kernel_kset = kset_create_and_add("kernel", NULL, NULL);
+	if (!kernel_kset) {
+		error = -ENOMEM;
+		goto exit;
+	}
+	error = sysfs_create_group(&kernel_kset->kobj, &kernel_attr_group);
+	if (error)
+		goto kset_exit;
+
+	if (notes_size > 0) {
 		notes_attr.size = notes_size;
-		error = sysfs_create_bin_file(&kernel_subsys.kobj,
-					      &notes_attr);
+		error = sysfs_create_bin_file(&kernel_kset->kobj, &notes_attr);
+		if (error)
+			goto group_exit;
 	}
 
 	/*
 	 * Create "/sys/kernel/uids" directory and corresponding root user's
 	 * directory under it.
 	 */
-	if (!error)
-		error = uids_kobject_init();
-
+	error = uids_kobject_init();
+	if (error)
+		goto notes_exit;
+
+	return 0;
+
+notes_exit:
+	if (notes_size > 0)
+		sysfs_remove_bin_file(&kernel_kset->kobj, &notes_attr);
+group_exit:
+	sysfs_remove_group(&kernel_kset->kobj, &kernel_attr_group);
+kset_exit:
+	kset_unregister(kernel_kset);
+exit:
 	return error;
 }
 
diff --git a/kernel/user.c b/kernel/user.c
index 8320a87..80f1116 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -198,8 +198,8 @@ int __init uids_kobject_init(void)
 	int error;
 
 	/* create under /sys/kernel dir */
-	uids_kobject.parent = &kernel_subsys.kobj;
-	uids_kobject.kset = &kernel_subsys;
+	uids_kobject.parent = &kernel_kset->kobj;
+	uids_kobject.kset = kernel_kset;
 	kobject_set_name(&uids_kobject, "uids");
 	kobject_init(&uids_kobject);
 
diff --git a/security/inode.c b/security/inode.c
index dfc5978..dbe040a 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -321,7 +321,7 @@ static int __init securityfs_init(void)
 {
 	int retval;
 
-	security_kobj = kobject_create_and_add("security", &kernel_subsys.kobj);
+  	security_kobj = kobject_create_and_add("security", &kernel_kset->kobj);
 	if (!security_kobj)
 		return -EINVAL;
 
-- 
1.5.3.8

