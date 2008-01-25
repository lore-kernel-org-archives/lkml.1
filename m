Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbYAYITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbYAYITy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYAYIAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760987AbYAYH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 173/196] Kobject: convert fs/* from kobject_unregister() to kobject_put()
Date: Thu, 24 Jan 2008 23:33:22 -0800
Message-Id: <1201246425-5058-94-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for kobject_unregister() anymore, thanks to Kay's
kobject cleanup changes, so replace all instances of it with
kobject_put().


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/configfs/mount.c         |    6 +++---
 fs/debugfs/inode.c          |    4 ++--
 fs/dlm/lockspace.c          |    4 ++--
 fs/ecryptfs/main.c          |    4 ++--
 fs/fuse/inode.c             |    6 +++---
 fs/gfs2/locking/dlm/sysfs.c |    2 +-
 fs/gfs2/sys.c               |    4 ++--
 fs/partitions/check.c       |    6 +++---
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 54bf0db..de3b31d 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -150,7 +150,7 @@ static int __init configfs_init(void)
 	err = register_filesystem(&configfs_fs_type);
 	if (err) {
 		printk(KERN_ERR "configfs: Unable to register filesystem!\n");
-		kobject_unregister(config_kobj);
+		kobject_put(config_kobj);
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 		goto out;
@@ -159,7 +159,7 @@ static int __init configfs_init(void)
 	err = configfs_inode_init();
 	if (err) {
 		unregister_filesystem(&configfs_fs_type);
-		kobject_unregister(config_kobj);
+		kobject_put(config_kobj);
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 	}
@@ -170,7 +170,7 @@ out:
 static void __exit configfs_exit(void)
 {
 	unregister_filesystem(&configfs_fs_type);
-	kobject_unregister(config_kobj);
+	kobject_put(config_kobj);
 	kmem_cache_destroy(configfs_dir_cachep);
 	configfs_dir_cachep = NULL;
 	configfs_inode_exit();
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 97f6381..d26e282 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -438,7 +438,7 @@ static int __init debugfs_init(void)
 
 	retval = register_filesystem(&debug_fs_type);
 	if (retval)
-		kobject_unregister(debug_kobj);
+		kobject_put(debug_kobj);
 	return retval;
 }
 
@@ -446,7 +446,7 @@ static void __exit debugfs_exit(void)
 {
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	unregister_filesystem(&debug_fs_type);
-	kobject_unregister(debug_kobj);
+	kobject_put(debug_kobj);
 }
 
 core_initcall(debugfs_init);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index b750f13..5c108c4 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -579,7 +579,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	kfree(ls->ls_rsbtbl);
  out_lsfree:
 	if (do_unreg)
-		kobject_unregister(&ls->ls_kobj);
+		kobject_put(&ls->ls_kobj);
 	else
 		kfree(ls);
  out:
@@ -728,7 +728,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	dlm_clear_members(ls);
 	dlm_clear_members_gone(ls);
 	kfree(ls->ls_node_array);
-	kobject_unregister(&ls->ls_kobj);
+	kobject_put(&ls->ls_kobj);
 	/* The ls structure will be freed when the kobject is done with */
 
 	mutex_lock(&ls_lock);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 4f13321..0249aa4 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -767,7 +767,7 @@ static int do_sysfs_registration(void)
 	if (rc) {
 		printk(KERN_ERR
 		       "Unable to create ecryptfs version attributes\n");
-		kobject_unregister(ecryptfs_kobj);
+		kobject_put(ecryptfs_kobj);
 	}
 out:
 	return rc;
@@ -776,7 +776,7 @@ out:
 static void do_sysfs_unregistration(void)
 {
 	sysfs_remove_group(ecryptfs_kobj, &attr_group);
-	kobject_unregister(ecryptfs_kobj);
+	kobject_put(ecryptfs_kobj);
 }
 
 static int __init ecryptfs_init(void)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index e6e23a2..e5e80d1 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -810,15 +810,15 @@ static int fuse_sysfs_init(void)
 	return 0;
 
  out_fuse_unregister:
-	kobject_unregister(fuse_kobj);
+	kobject_put(fuse_kobj);
  out_err:
 	return err;
 }
 
 static void fuse_sysfs_cleanup(void)
 {
-	kobject_unregister(connections_kobj);
-	kobject_unregister(fuse_kobj);
+	kobject_put(connections_kobj);
+	kobject_put(fuse_kobj);
 }
 
 static int __init fuse_init(void)
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index a7336b9..a87b098 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -207,7 +207,7 @@ int gdlm_kobject_setup(struct gdlm_ls *ls, struct kobject *fskobj)
 
 void gdlm_kobject_release(struct gdlm_ls *ls)
 {
-	kobject_unregister(&ls->kobj);
+	kobject_put(&ls->kobj);
 }
 
 int gdlm_sysfs_init(void)
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 8d9cd5b..3a3176b 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -525,7 +525,7 @@ fail_counters:
 fail_lockstruct:
 	sysfs_remove_group(&sdp->sd_kobj, &lockstruct_group);
 fail_reg:
-	kobject_unregister(&sdp->sd_kobj);
+	kobject_put(&sdp->sd_kobj);
 fail:
 	fs_err(sdp, "error %d adding sysfs files", error);
 	return error;
@@ -537,7 +537,7 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 	sysfs_remove_group(&sdp->sd_kobj, &args_group);
 	sysfs_remove_group(&sdp->sd_kobj, &counters_group);
 	sysfs_remove_group(&sdp->sd_kobj, &lockstruct_group);
-	kobject_unregister(&sdp->sd_kobj);
+	kobject_put(&sdp->sd_kobj);
 }
 
 int gfs2_sys_init(void)
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 97f3f5f..739da70 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -314,7 +314,7 @@ void delete_partition(struct gendisk *disk, int part)
 	p->nr_sects = 0;
 	p->ios[0] = p->ios[1] = 0;
 	p->sectors[0] = p->sectors[1] = 0;
-	kobject_unregister(p->holder_dir);
+	kobject_put(p->holder_dir);
 	device_del(&p->dev);
 	put_device(&p->dev);
 }
@@ -505,8 +505,8 @@ void del_gendisk(struct gendisk *disk)
 	disk_stat_set_all(disk, 0);
 	disk->stamp = 0;
 
-	kobject_unregister(disk->holder_dir);
-	kobject_unregister(disk->slave_dir);
+	kobject_put(disk->holder_dir);
+	kobject_put(disk->slave_dir);
 	disk->driverfs_dev = NULL;
 #ifndef CONFIG_SYSFS_DEPRECATED
 	sysfs_remove_link(block_depr, disk->dev.bus_id);
-- 
1.5.3.8

