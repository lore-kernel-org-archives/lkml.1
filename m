Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbXKCAFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbXKCAFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761917AbXKCABL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:41130 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761901AbXKCABK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 16/54] kset: convert kernel_subsys to use kset_create
Date: Fri,  2 Nov 2007 16:58:54 -0700
Message-Id: <1194047972-9850-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
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
 fs/gfs2/locking/dlm/sysfs.c |    2 +-
 include/linux/kobject.h     |    4 ++--
 kernel/ksysfs.c             |   43 +++++++++++++++++++++++++++++++------------
 kernel/user.c               |    4 ++--
 security/inode.c            |    2 +-
 8 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 8674e6d..8e2f8e0 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -141,7 +141,7 @@ static int __init configfs_init(void)
 		goto out;
 
 	config_kset = kset_create_and_register("config", NULL,
-					       NULL, &kernel_subsys);
+					       NULL, kernel_kset);
 	if (IS_ERR(config_kset)) {
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 9f8af79..d6fe796 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -433,7 +433,7 @@ static int __init debugfs_init(void)
 	int retval;
 
 	debug_kset = kset_create_and_register("debug", NULL,
-					      NULL, &kernel_subsys);
+					      NULL, kernel_kset);
 	if (IS_ERR(debug_kset))
 		return PTR_ERR(debug_kset);
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 28c3cb4..b5f1823 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -225,7 +225,7 @@ int dlm_lockspace_init(void)
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
-	dlm_kset = kset_create_and_register("dlm", NULL, NULL, &kernel_subsys);
+	dlm_kset = kset_create_and_register("dlm", NULL, NULL, kernel_kset);
 	if (IS_ERR(dlm_kset)) {
 		error = PTR_ERR(dlm_kset);
 		printk(KERN_WARNING "%s: can not create kset %d\n",
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index 9c351db..494e00c 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -222,7 +222,7 @@ int gdlm_sysfs_init(void)
 	int error;
 
 	gdlm_kset = kset_create_and_register("lock_dlm", NULL,
-					     NULL, &kernel_subsys);
+					     NULL, kernel_kset);
 	if (IS_ERR(gdlm_kset)) {
 		error = PTR_ERR(gdlm_kset);
 		printk(KERN_WARNING "%s: can not create kset %d\n",
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 84525a6..4196ad8 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -188,8 +188,8 @@ struct kset _name##_subsys = { \
 	.uevent_ops =_uevent_ops, \
 }
 
-/* The global /sys/kernel/ subsystem for people to chain off of */
-extern struct kset kernel_subsys;
+/* The global /sys/kernel/ kset for people to chain off of */
+extern struct kset *kernel_kset;
 /* The global /sys/hypervisor/ subsystem  */
 extern struct kset hypervisor_subsys;
 
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 094e2bc..b4f5116 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/kexec.h>
 #include <linux/sched.h>
+#include <linux/err.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct subsys_attribute _name##_attr = __ATTR_RO(_name)
@@ -94,8 +95,8 @@ static struct bin_attribute notes_attr = {
 	.read = &notes_read,
 };
 
-decl_subsys(kernel, NULL);
-EXPORT_SYMBOL_GPL(kernel_subsys);
+struct kset *kernel_kset;
+EXPORT_SYMBOL_GPL(kernel_kset);
 
 static struct attribute * kernel_attrs[] = {
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
@@ -116,24 +117,42 @@ static struct attribute_group kernel_attr_group = {
 
 static int __init ksysfs_init(void)
 {
-	int error = subsystem_register(&kernel_subsys);
-	if (!error)
-		error = sysfs_create_group(&kernel_subsys.kobj,
-					   &kernel_attr_group);
+	int error;
 
-	if (!error && notes_size > 0) {
+	kernel_kset = kset_create_and_register("kernel", NULL, NULL, NULL);
+	if (IS_ERR(kernel_kset)) {
+		error = PTR_ERR(kernel_kset);
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
index 0f3aa02..75d9f9b 100644
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
index 9071d81..787b719 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -322,7 +322,7 @@ static int __init securityfs_init(void)
 	int retval;
 
 	security_kset = kset_create_and_register("security", NULL, NULL,
-						 &kernel_subsys);
+						 kernel_kset);
 	if (IS_ERR(security_kset))
 		return PTR_ERR(security_kset);
 
-- 
1.5.3.4

