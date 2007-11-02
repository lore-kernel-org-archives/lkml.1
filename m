Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbXKCADc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbXKCADc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761714AbXKCAAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:34800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761685AbXKCAAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 10/54] kset: convert main fs kset to use kset_create
Date: Fri,  2 Nov 2007 16:58:48 -0700
Message-Id: <1194047972-9850-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This also renames fs_subsys to fs_kset to catch all current users with a
build error instead of a build warning which can easily be missed.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c |    2 +-
 fs/fuse/inode.c    |    2 +-
 fs/gfs2/sys.c      |    2 +-
 fs/namespace.c     |   14 ++++++++------
 include/linux/fs.h |    2 +-
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 5bfdf96..b72a495 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -795,7 +795,7 @@ static int do_sysfs_registration(void)
 	int rc;
 
 	ecryptfs_kset = kset_create_and_register("ecryptfs", NULL,
-						 NULL, &fs_subsys);
+						 NULL, fs_kset);
 	if (IS_ERR(ecryptfs_kset)) {
 		printk(KERN_ERR "Unable to create ecryptfs kset\n");
 		rc = PTR_ERR(ecryptfs_kset);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ca80a7b..665c732 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -795,7 +795,7 @@ static int fuse_sysfs_init(void)
 {
 	int err;
 
-	fuse_kset = kset_create_and_register("fuse", NULL, NULL, &fs_subsys);
+	fuse_kset = kset_create_and_register("fuse", NULL, NULL, fs_kset);
 	if (IS_ERR(fuse_kset)) {
 		err = PTR_ERR(fuse_kset);
 		goto out_err;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index d7fa544..dab7d9d 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -549,7 +549,7 @@ int gfs2_sys_init(void)
 	gfs2_sys_margs = NULL;
 	spin_lock_init(&gfs2_sys_margs_lock);
 	kobject_set_name(&gfs2_kset.kobj, "gfs2");
-	gfs2_kset.kobj.kset = &fs_subsys;
+	gfs2_kset.kobj.kset = fs_kset;
 	return kset_register(&gfs2_kset);
 }
 
diff --git a/fs/namespace.c b/fs/namespace.c
index a4a3f70..fa352e8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -41,8 +41,8 @@ static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
-decl_subsys(fs, NULL);
-EXPORT_SYMBOL_GPL(fs_subsys);
+struct kset *fs_kset;
+EXPORT_SYMBOL_GPL(fs_kset);
 
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
@@ -1861,10 +1861,12 @@ void __init mnt_init(void)
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
 			__FUNCTION__, err);
-	err = subsystem_register(&fs_subsys);
-	if (err)
-		printk(KERN_WARNING "%s: subsystem_register error: %d\n",
-			__FUNCTION__, err);
+	fs_kset = kset_create_and_register("fs", NULL, NULL, NULL);
+	if (IS_ERR(fs_kset)) {
+		printk(KERN_WARNING "%s: kset create error: %d\n",
+			__FUNCTION__, (int)PTR_ERR(fs_kset));
+		fs_kset = NULL;
+	}
 	init_rootfs();
 	init_mount_tree();
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..e0e52c6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1476,7 +1476,7 @@ extern void drop_collected_mounts(struct vfsmount *);
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 
 /* /sys/fs */
-extern struct kset fs_subsys;
+extern struct kset *fs_kset;
 
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
-- 
1.5.3.4

