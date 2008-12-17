Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760979AbYLQMhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbYLQMhq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYLQM3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53753 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbYLQM3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:31 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/24] GFS2: Fix use-after-free bug on umount
Date: Wed, 17 Dec 2008 11:30:21 +0000
Message-Id: <1229513423-19105-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-22-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-20-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-21-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-22-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There was a use-after-free with the GFS2 super block during
umount. This patch moves almost all of the umount code from
->put_super into ->kill_sb, the only bit that cannot be moved
being the glock hash clearing which has to remain as ->put_super
due to umount ordering requirements. As a result its now obvious
that the kfree is the final operation, whereas before it was
hidden in ->put_super.

Also gfs2_jindex_free is then only referenced from a single file
so thats moved and marked static too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6e298b0..5eae62e 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1547,8 +1547,9 @@ static void clear_glock(struct gfs2_glock *gl)
  * Called when unmounting the filesystem.
  */
 
-void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
+void gfs2_gl_hash_clear(struct super_block *sb)
 {
+	struct gfs2_sbd *sdp = sb->s_fs_info;
 	unsigned long t;
 	unsigned int x;
 	int cont;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 543ec7e..ce54f33 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -130,7 +130,7 @@ void gfs2_lvb_unhold(struct gfs2_glock *gl);
 
 void gfs2_glock_cb(void *cb_data, unsigned int type, void *data);
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
-void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
+void gfs2_gl_hash_clear(struct super_block *sb);
 void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
 
 int __init gfs2_glock_init(void);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 4cae60f..2e735be 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -705,6 +705,40 @@ static int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 	return error;
 }
 
+/**
+ * gfs2_jindex_free - Clear all the journal index information
+ * @sdp: The GFS2 superblock
+ *
+ */
+
+static void gfs2_jindex_free(struct gfs2_sbd *sdp)
+{
+	struct list_head list, *head;
+	struct gfs2_jdesc *jd;
+	struct gfs2_journal_extent *jext;
+
+	spin_lock(&sdp->sd_jindex_spin);
+	list_add(&list, &sdp->sd_jindex_list);
+	list_del_init(&sdp->sd_jindex_list);
+	sdp->sd_journals = 0;
+	spin_unlock(&sdp->sd_jindex_spin);
+
+	while (!list_empty(&list)) {
+		jd = list_entry(list.next, struct gfs2_jdesc, jd_list);
+		head = &jd->extent_list;
+		while (!list_empty(head)) {
+			jext = list_entry(head->next,
+					  struct gfs2_journal_extent,
+					  extent_list);
+			list_del(&jext->extent_list);
+			kfree(jext);
+		}
+		list_del(&jd->jd_list);
+		iput(jd->jd_inode);
+		kfree(jd);
+	}
+}
+
 static int init_journal(struct gfs2_sbd *sdp, int undo)
 {
 	struct inode *master = sdp->sd_master_dir->d_inode;
@@ -1203,7 +1237,7 @@ fail_sb:
 fail_locking:
 	init_locking(sdp, &mount_gh, UNDO);
 fail_lm:
-	gfs2_gl_hash_clear(sdp);
+	gfs2_gl_hash_clear(sb);
 	gfs2_lm_unmount(sdp);
 	while (invalidate_inodes(sb))
 		yield();
@@ -1263,17 +1297,61 @@ static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
 static void gfs2_kill_sb(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	if (sdp) {
-		gfs2_meta_syncfs(sdp);
-		dput(sdp->sd_root_dir);
-		dput(sdp->sd_master_dir);
-		sdp->sd_root_dir = NULL;
-		sdp->sd_master_dir = NULL;
+
+	if (sdp == NULL) {
+		kill_block_super(sb);
+		return;
 	}
-	shrink_dcache_sb(sb);
+	gfs2_meta_syncfs(sdp);
+	dput(sdp->sd_root_dir);
+	dput(sdp->sd_master_dir);
+	sdp->sd_root_dir = NULL;
+	sdp->sd_master_dir = NULL;
+
+	/*  Unfreeze the filesystem, if we need to  */
+	mutex_lock(&sdp->sd_freeze_lock);
+	if (sdp->sd_freeze_count)
+		gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
+	mutex_unlock(&sdp->sd_freeze_lock);
+
+	kthread_stop(sdp->sd_quotad_process);
+	kthread_stop(sdp->sd_logd_process);
+	kthread_stop(sdp->sd_recoverd_process);
+
+	if (!(sb->s_flags & MS_RDONLY)) {
+		int error = gfs2_make_fs_ro(sdp);
+		if (error)
+			gfs2_io_error(sdp);
+	}
+
+	/* At this point, we're through modifying the disk */
+	gfs2_jindex_free(sdp);
+	gfs2_clear_rgrpd(sdp);
+	iput(sdp->sd_jindex);
+	iput(sdp->sd_inum_inode);
+	iput(sdp->sd_statfs_inode);
+	iput(sdp->sd_rindex);
+	iput(sdp->sd_quota_inode);
+
+	gfs2_glock_put(sdp->sd_rename_gl);
+	gfs2_glock_put(sdp->sd_trans_gl);
+
+	if (!sdp->sd_args.ar_spectator) {
+		gfs2_glock_dq_uninit(&sdp->sd_journal_gh);
+		gfs2_glock_dq_uninit(&sdp->sd_jinode_gh);
+		gfs2_glock_dq_uninit(&sdp->sd_ir_gh);
+		gfs2_glock_dq_uninit(&sdp->sd_sc_gh);
+		gfs2_glock_dq_uninit(&sdp->sd_qc_gh);
+		iput(sdp->sd_ir_inode);
+		iput(sdp->sd_sc_inode);
+		iput(sdp->sd_qc_inode);
+	}
+	gfs2_glock_dq_uninit(&sdp->sd_live_gh);
 	kill_block_super(sb);
-	if (sdp)
-		gfs2_delete_debugfs_file(sdp);
+	gfs2_lm_unmount(sdp);
+	gfs2_sys_fs_del(sdp);
+	gfs2_delete_debugfs_file(sdp);
+	kfree(sdp);
 }
 
 struct file_system_type gfs2_fs_type = {
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 08837a7..bd08a0a 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -95,7 +95,7 @@ do_flush:
  * Returns: errno
  */
 
-static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
+int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 {
 	struct gfs2_holder t_gh;
 	int error;
@@ -122,70 +122,6 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 }
 
 /**
- * gfs2_put_super - Unmount the filesystem
- * @sb: The VFS superblock
- *
- */
-
-static void gfs2_put_super(struct super_block *sb)
-{
-	struct gfs2_sbd *sdp = sb->s_fs_info;
-	int error;
-
-	/*  Unfreeze the filesystem, if we need to  */
-
-	mutex_lock(&sdp->sd_freeze_lock);
-	if (sdp->sd_freeze_count)
-		gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
-	mutex_unlock(&sdp->sd_freeze_lock);
-
-	kthread_stop(sdp->sd_quotad_process);
-	kthread_stop(sdp->sd_logd_process);
-	kthread_stop(sdp->sd_recoverd_process);
-
-	if (!(sb->s_flags & MS_RDONLY)) {
-		error = gfs2_make_fs_ro(sdp);
-		if (error)
-			gfs2_io_error(sdp);
-	}
-	/*  At this point, we're through modifying the disk  */
-
-	/*  Release stuff  */
-
-	iput(sdp->sd_jindex);
-	iput(sdp->sd_inum_inode);
-	iput(sdp->sd_statfs_inode);
-	iput(sdp->sd_rindex);
-	iput(sdp->sd_quota_inode);
-
-	gfs2_glock_put(sdp->sd_rename_gl);
-	gfs2_glock_put(sdp->sd_trans_gl);
-
-	if (!sdp->sd_args.ar_spectator) {
-		gfs2_glock_dq_uninit(&sdp->sd_journal_gh);
-		gfs2_glock_dq_uninit(&sdp->sd_jinode_gh);
-		gfs2_glock_dq_uninit(&sdp->sd_ir_gh);
-		gfs2_glock_dq_uninit(&sdp->sd_sc_gh);
-		gfs2_glock_dq_uninit(&sdp->sd_qc_gh);
-		iput(sdp->sd_ir_inode);
-		iput(sdp->sd_sc_inode);
-		iput(sdp->sd_qc_inode);
-	}
-
-	gfs2_glock_dq_uninit(&sdp->sd_live_gh);
-	gfs2_clear_rgrpd(sdp);
-	gfs2_jindex_free(sdp);
-	/*  Take apart glock structures and buffer lists  */
-	gfs2_gl_hash_clear(sdp);
-	/*  Unmount the locking protocol  */
-	gfs2_lm_unmount(sdp);
-
-	/*  At this point, we're through participating in the lockspace  */
-	gfs2_sys_fs_del(sdp);
-	kfree(sdp);
-}
-
-/**
  * gfs2_write_super
  * @sb: the superblock
  *
@@ -686,7 +622,7 @@ const struct super_operations gfs2_super_ops = {
 	.destroy_inode		= gfs2_destroy_inode,
 	.write_inode		= gfs2_write_inode,
 	.delete_inode		= gfs2_delete_inode,
-	.put_super		= gfs2_put_super,
+	.put_super		= gfs2_gl_hash_clear,
 	.write_super		= gfs2_write_super,
 	.sync_fs		= gfs2_sync_fs,
 	.write_super_lockfs 	= gfs2_write_super_lockfs,
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 141b781..f14658b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -33,40 +33,6 @@
 #include "trans.h"
 #include "util.h"
 
-/**
- * gfs2_jindex_free - Clear all the journal index information
- * @sdp: The GFS2 superblock
- *
- */
-
-void gfs2_jindex_free(struct gfs2_sbd *sdp)
-{
-	struct list_head list, *head;
-	struct gfs2_jdesc *jd;
-	struct gfs2_journal_extent *jext;
-
-	spin_lock(&sdp->sd_jindex_spin);
-	list_add(&list, &sdp->sd_jindex_list);
-	list_del_init(&sdp->sd_jindex_list);
-	sdp->sd_journals = 0;
-	spin_unlock(&sdp->sd_jindex_spin);
-
-	while (!list_empty(&list)) {
-		jd = list_entry(list.next, struct gfs2_jdesc, jd_list);
-		head = &jd->extent_list;
-		while (!list_empty(head)) {
-			jext = list_entry(head->next,
-					  struct gfs2_journal_extent,
-					  extent_list);
-			list_del(&jext->extent_list);
-			kfree(jext);
-		}
-		list_del(&jd->jd_list);
-		iput(jd->jd_inode);
-		kfree(jd);
-	}
-}
-
 static struct gfs2_jdesc *jdesc_find_i(struct list_head *head, unsigned int jid)
 {
 	struct gfs2_jdesc *jd;
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index f6b8b00..4d2492b 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -25,8 +25,6 @@ static inline unsigned int gfs2_jindex_size(struct gfs2_sbd *sdp)
 	return x;
 }
 
-void gfs2_jindex_free(struct gfs2_sbd *sdp);
-
 struct gfs2_jdesc *gfs2_jdesc_find(struct gfs2_sbd *sdp, unsigned int jid);
 int gfs2_jdesc_check(struct gfs2_jdesc *jd);
 
@@ -34,6 +32,7 @@ int gfs2_lookup_in_master_dir(struct gfs2_sbd *sdp, char *filename,
 			      struct gfs2_inode **ipp);
 
 int gfs2_make_fs_rw(struct gfs2_sbd *sdp);
+int gfs2_make_fs_ro(struct gfs2_sbd *sdp);
 
 int gfs2_statfs_init(struct gfs2_sbd *sdp);
 void gfs2_statfs_change(struct gfs2_sbd *sdp,
-- 
1.6.0.3

