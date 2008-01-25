Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbYAYHc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbYAYHc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758785AbYAYHR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:27 -0500
Received: from ns.suse.de ([195.135.220.2]:52765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759172AbYAYHR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 053/196] kobject: convert main fs kobject to use kobject_create
Date: Thu, 24 Jan 2008 23:09:51 -0800
Message-Id: <1201245134-4876-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also renames fs_subsys to fs_kobj to catch all current users with a
build error instead of a build warning which can easily be missed.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c |    2 +-
 fs/fuse/inode.c    |    2 +-
 fs/gfs2/sys.c      |    2 +-
 fs/namespace.c     |   11 +++++------
 include/linux/fs.h |    2 +-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 4750d82..bdeac38 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -798,7 +798,7 @@ static int do_sysfs_registration(void)
 {
 	int rc;
 
-	ecryptfs_kset = kset_create_and_add("ecryptfs", NULL, &fs_subsys.kobj);
+	ecryptfs_kset = kset_create_and_add("ecryptfs", NULL, fs_kobj);
 	if (!ecryptfs_kset) {
 		printk(KERN_ERR "Unable to create ecryptfs kset\n");
 		rc = -ENOMEM;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 9211806..e6e23a2 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -795,7 +795,7 @@ static int fuse_sysfs_init(void)
 {
 	int err;
 
-	fuse_kobj = kobject_create_and_add("fuse", &fs_subsys.kobj);
+	fuse_kobj = kobject_create_and_add("fuse", fs_kobj);
 	if (!fuse_kobj) {
 		err = -ENOMEM;
 		goto out_err;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index d7fa544..a0bdc4a 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -549,7 +549,7 @@ int gfs2_sys_init(void)
 	gfs2_sys_margs = NULL;
 	spin_lock_init(&gfs2_sys_margs_lock);
 	kobject_set_name(&gfs2_kset.kobj, "gfs2");
-	gfs2_kset.kobj.kset = &fs_subsys;
+	gfs2_kset.kobj.parent = fs_kobj;
 	return kset_register(&gfs2_kset);
 }
 
diff --git a/fs/namespace.c b/fs/namespace.c
index a4a3f70..61bf376 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -41,8 +41,8 @@ static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
-decl_subsys(fs, NULL);
-EXPORT_SYMBOL_GPL(fs_subsys);
+struct kobject *fs_kobj;
+EXPORT_SYMBOL_GPL(fs_kobj);
 
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
@@ -1861,10 +1861,9 @@ void __init mnt_init(void)
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
 			__FUNCTION__, err);
-	err = subsystem_register(&fs_subsys);
-	if (err)
-		printk(KERN_WARNING "%s: subsystem_register error: %d\n",
-			__FUNCTION__, err);
+	fs_kobj = kobject_create_and_add("fs", NULL);
+	if (!fs_kobj)
+		printk(KERN_WARNING "%s: kobj create error\n", __FUNCTION__);
 	init_rootfs();
 	init_mount_tree();
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..21398a5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1476,7 +1476,7 @@ extern void drop_collected_mounts(struct vfsmount *);
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 
 /* /sys/fs */
-extern struct kset fs_subsys;
+extern struct kobject *fs_kobj;
 
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
-- 
1.5.3.8

