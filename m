Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZBQILc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZBQILc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZBQIKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:10:46 -0500
Received: from sh.osrg.net ([192.16.179.4]:55114 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbZBQIKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:10:42 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 5/6] nilfs2: extend nilfs_sustat ioctl struct
Date: Tue, 17 Feb 2009 16:42:05 +0900
Message-Id: <1234856526-1947-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Feb 2009 17:10:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new argument to the nilfs_sustat structure.

The extended field allows to delete volatile active state of segments,
which was needed to protect freshly-created segments from garbage
collection but has confused code dealing with segments.  This
extension alleviates the mess and gives room for further
simplifications.

The volatile active flag is not persistent, so it's eliminable on this
occasion without affecting compatibility other than the ioctl change.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/recovery.c      |   32 +++++++++++++++++---------------
 fs/nilfs2/segment.c       |   39 +++++++++------------------------------
 fs/nilfs2/sufile.c        |    8 ++++++--
 fs/nilfs2/super.c         |    4 +++-
 fs/nilfs2/the_nilfs.c     |   18 ------------------
 fs/nilfs2/the_nilfs.h     |    5 ++---
 include/linux/nilfs2_fs.h |   10 ++++------
 7 files changed, 41 insertions(+), 75 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 877dc1b..a4253f3 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -416,6 +416,7 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	struct nilfs_segment_entry *ent, *n;
 	struct inode *sufile = nilfs->ns_sufile;
 	__u64 segnum[4];
+	time_t mtime;
 	int err;
 	int i;
 
@@ -442,9 +443,9 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 
 	/*
 	 * Collecting segments written after the latest super root.
-	 * These are marked volatile active, and won't be reallocated in
-	 * the next construction.
+	 * These are marked dirty to avoid being reallocated in the next write.
 	 */
+	mtime = get_seconds();
 	list_for_each_entry_safe(ent, n, head, list) {
 		if (ent->segnum == segnum[0]) {
 			list_del(&ent->list);
@@ -454,17 +455,16 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 		err = nilfs_open_segment_entry(ent, sufile);
 		if (unlikely(err))
 			goto failed;
-		if (nilfs_segment_usage_clean(ent->raw_su)) {
-			nilfs_segment_usage_set_volatile_active(ent->raw_su);
-			/* Keep it open */
-		} else {
-			/* Removing duplicated entries */
-			list_del(&ent->list);
-			nilfs_close_segment_entry(ent, sufile);
-			nilfs_free_segment_entry(ent);
+		if (!nilfs_segment_usage_dirty(ent->raw_su)) {
+			/* make the segment garbage */
+			ent->raw_su->su_nblocks = cpu_to_le32(0);
+			ent->raw_su->su_lastmod = cpu_to_le32(mtime);
+			nilfs_segment_usage_set_dirty(ent->raw_su);
 		}
+		list_del(&ent->list);
+		nilfs_close_segment_entry(ent, sufile);
+		nilfs_free_segment_entry(ent);
 	}
-	list_splice_init(head, nilfs->ns_used_segments.prev);
 
 	/*
 	 * The segment having the latest super root is active, and
@@ -882,10 +882,12 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 
 		if (scan_newer)
 			ri->ri_need_recovery = NILFS_RECOVERY_SR_UPDATED;
-		else if (nilfs->ns_mount_state & NILFS_VALID_FS)
-			goto super_root_found;
-
-		scan_newer = 1;
+		else {
+			nilfs->ns_prot_seq = ssi.seg_seq;
+			if (nilfs->ns_mount_state & NILFS_VALID_FS)
+				goto super_root_found;
+			scan_newer = 1;
+		}
 
 		/* reset region for roll-forward */
 		pseg_start += ssi.nblocks;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 5db12d7..24d0fbd 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2229,13 +2229,6 @@ static void nilfs_segctor_reactivate_segments(struct nilfs_sc_info *sci,
 		nilfs_segment_usage_set_active(ent->raw_su);
 		nilfs_close_segment_entry(ent, sufile);
 	}
-
-	down_write(&nilfs->ns_sem);
-	head = &nilfs->ns_used_segments;
-	list_for_each_entry(ent, head, list) {
-		nilfs_segment_usage_set_volatile_active(ent->raw_su);
-	}
-	up_write(&nilfs->ns_sem);
 }
 
 static int nilfs_segctor_deactivate_segments(struct nilfs_sc_info *sci,
@@ -2244,7 +2237,6 @@ static int nilfs_segctor_deactivate_segments(struct nilfs_sc_info *sci,
 	struct nilfs_segment_buffer *segbuf, *last;
 	struct nilfs_segment_entry *ent;
 	struct inode *sufile = nilfs->ns_sufile;
-	struct list_head *head;
 	int err;
 
 	last = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
@@ -2265,22 +2257,13 @@ static int nilfs_segctor_deactivate_segments(struct nilfs_sc_info *sci,
 		BUG_ON(!buffer_dirty(ent->bh_su));
 	}
 
-	head = &sci->sc_active_segments;
-	list_for_each_entry(ent, head, list) {
+	list_for_each_entry(ent, &sci->sc_active_segments, list) {
 		err = nilfs_open_segment_entry(ent, sufile);
 		if (unlikely(err))
 			goto failed;
 		nilfs_segment_usage_clear_active(ent->raw_su);
 		BUG_ON(!buffer_dirty(ent->bh_su));
 	}
-
-	down_write(&nilfs->ns_sem);
-	head = &nilfs->ns_used_segments;
-	list_for_each_entry(ent, head, list) {
-		/* clear volatile active for segments of older generations */
-		nilfs_segment_usage_clear_volatile_active(ent->raw_su);
-	}
-	up_write(&nilfs->ns_sem);
 	return 0;
 
  failed:
@@ -2304,19 +2287,15 @@ static void nilfs_segctor_bead_completed_segments(struct nilfs_sc_info *sci)
 	}
 }
 
-static void
-__nilfs_segctor_commit_deactivate_segments(struct nilfs_sc_info *sci,
-					   struct the_nilfs *nilfs)
-
+static void nilfs_segctor_commit_deactivate_segments(struct nilfs_sc_info *sci,
+						     struct the_nilfs *nilfs)
 {
-	struct nilfs_segment_entry *ent;
-
-	list_splice_init(&sci->sc_active_segments,
-			 nilfs->ns_used_segments.prev);
+	struct nilfs_segment_entry *ent, *n;
 
-	list_for_each_entry(ent, &nilfs->ns_used_segments, list) {
-		nilfs_segment_usage_set_volatile_active(ent->raw_su);
-		/* These segments are kept open */
+	list_for_each_entry_safe(ent, n, &sci->sc_active_segments, list) {
+		list_del(&ent->list);
+		nilfs_close_segment_entry(ent, nilfs->ns_sufile);
+		nilfs_free_segment_entry(ent);
 	}
 }
 
@@ -2405,8 +2384,8 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		if (has_sr) {
 			down_write(&nilfs->ns_sem);
 			nilfs_update_last_segment(sbi, 1);
-			__nilfs_segctor_commit_deactivate_segments(sci, nilfs);
 			up_write(&nilfs->ns_sem);
+			nilfs_segctor_commit_deactivate_segments(sci, nilfs);
 			nilfs_segctor_commit_free_segments(sci);
 			nilfs_segctor_clear_metadata_dirty(sci);
 		}
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index b3674a8..cc714c7 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -446,6 +446,7 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 {
 	struct buffer_head *header_bh;
 	struct nilfs_sufile_header *header;
+	struct the_nilfs *nilfs = NILFS_MDT(sufile)->mi_nilfs;
 	void *kaddr;
 	int ret;
 
@@ -460,8 +461,11 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 	sustat->ss_nsegs = nilfs_sufile_get_nsegments(sufile);
 	sustat->ss_ncleansegs = le64_to_cpu(header->sh_ncleansegs);
 	sustat->ss_ndirtysegs = le64_to_cpu(header->sh_ndirtysegs);
-	sustat->ss_ctime = NILFS_MDT(sufile)->mi_nilfs->ns_ctime;
-	sustat->ss_nongc_ctime = NILFS_MDT(sufile)->mi_nilfs->ns_nongc_ctime;
+	sustat->ss_ctime = nilfs->ns_ctime;
+	sustat->ss_nongc_ctime = nilfs->ns_nongc_ctime;
+	spin_lock(&nilfs->ns_last_segment_lock);
+	sustat->ss_prot_seq = nilfs->ns_prot_seq;
+	spin_unlock(&nilfs->ns_last_segment_lock);
 	kunmap_atomic(kaddr, KM_USER0);
 	brelse(header_bh);
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 268b563..2f0e9f7 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -262,8 +262,10 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi)
 		printk(KERN_ERR
 		       "NILFS: unable to write superblock (err=%d)\n", err);
 	else {
-		nilfs_dispose_used_segments(nilfs);
 		clear_nilfs_discontinued(nilfs);
+		spin_lock(&nilfs->ns_last_segment_lock);
+		nilfs->ns_prot_seq = le64_to_cpu(nilfs->ns_sbp->s_last_seq);
+		spin_unlock(&nilfs->ns_last_segment_lock);
 	}
 
 	return err;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 69b6255..661ab76 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -71,7 +71,6 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	INIT_LIST_HEAD(&nilfs->ns_supers);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_gc_inodes_h = NULL;
-	INIT_LIST_HEAD(&nilfs->ns_used_segments);
 	init_rwsem(&nilfs->ns_segctor_sem);
 
 	return nilfs;
@@ -95,7 +94,6 @@ void put_nilfs(struct the_nilfs *nilfs)
 	 */
 	might_sleep();
 	if (nilfs_loaded(nilfs)) {
-		nilfs_dispose_used_segments(nilfs);
 		nilfs_mdt_clear(nilfs->ns_sufile);
 		nilfs_mdt_destroy(nilfs->ns_sufile);
 		nilfs_mdt_clear(nilfs->ns_cpfile);
@@ -463,22 +461,6 @@ int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
 	return err;
 }
 
-void nilfs_dispose_used_segments(struct the_nilfs *nilfs)
-{
-	struct nilfs_segment_entry *ent, *n;
-
-	/* nilfs->sem must be locked by the caller. */
-	if (!nilfs_loaded(nilfs))
-		return;
-
-	list_for_each_entry_safe(ent, n, &nilfs->ns_used_segments, list) {
-		list_del_init(&ent->list);
-		nilfs_segment_usage_clear_volatile_active(ent->raw_su);
-		nilfs_close_segment_entry(ent, nilfs->ns_sufile);
-		nilfs_free_segment_entry(ent);
-	}
-}
-
 int nilfs_near_disk_full(struct the_nilfs *nilfs)
 {
 	struct inode *sufile = nilfs->ns_sufile;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 75da373..af566e7 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -51,7 +51,6 @@ enum {
  * @ns_writer_refcount: number of referrers on ns_writer
  * @ns_sbh: buffer head of the on-disk super block
  * @ns_sbp: pointer to the super block data
- * @ns_used_segments: list of full segments in volatile active state
  * @ns_supers: list of nilfs super block structs
  * @ns_seg_seq: segment sequence counter
  * @ns_segnum: index number of the latest full segment.
@@ -65,6 +64,7 @@ enum {
  * @ns_last_pseg: start block number of the latest segment
  * @ns_last_seq: sequence value of the latest segment
  * @ns_last_cno: checkpoint number of the latest segment
+ * @ns_prot_seq: least sequence number of segments which must not be reclaimed
  * @ns_free_segments_count: counter of free segments
  * @ns_segctor_sem: segment constructor semaphore
  * @ns_dat: DAT file inode
@@ -103,7 +103,6 @@ struct the_nilfs {
 	 */
 	struct buffer_head     *ns_sbh;
 	struct nilfs_super_block *ns_sbp;
-	struct list_head	ns_used_segments;
 	unsigned		ns_mount_state;
 	struct list_head	ns_supers;
 
@@ -132,6 +131,7 @@ struct the_nilfs {
 	sector_t		ns_last_pseg;
 	u64			ns_last_seq;
 	__u64			ns_last_cno;
+	u64			ns_prot_seq;
 	unsigned long		ns_free_segments_count;
 
 	struct rw_semaphore	ns_segctor_sem;
@@ -188,7 +188,6 @@ void put_nilfs(struct the_nilfs *);
 int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
 int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
-void nilfs_dispose_used_segments(struct the_nilfs *);
 int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
 int nilfs_near_disk_full(struct the_nilfs *);
 
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 306c446..aa93f0e 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -565,8 +565,6 @@ enum {
 	NILFS_SEGMENT_USAGE_DIRTY,
 	NILFS_SEGMENT_USAGE_ERROR,
 
-	/* on-memory only */
-	NILFS_SEGMENT_USAGE_VOLATILE_ACTIVE,
 	/* ... */
 };
 
@@ -594,7 +592,6 @@ nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
 NILFS_SEGMENT_USAGE_FNS(ACTIVE, active)
 NILFS_SEGMENT_USAGE_FNS(DIRTY, dirty)
 NILFS_SEGMENT_USAGE_FNS(ERROR, error)
-NILFS_SEGMENT_USAGE_FNS(VOLATILE_ACTIVE, volatile_active)
 
 static inline void
 nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
@@ -650,7 +647,6 @@ nilfs_suinfo_##name(const struct nilfs_suinfo *si)			\
 NILFS_SUINFO_FNS(ACTIVE, active)
 NILFS_SUINFO_FNS(DIRTY, dirty)
 NILFS_SUINFO_FNS(ERROR, error)
-NILFS_SUINFO_FNS(VOLATILE_ACTIVE, volatile_active)
 
 static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
 {
@@ -717,8 +713,9 @@ struct nilfs_cpstat {
  * @ss_nsegs: number of segments
  * @ss_ncleansegs: number of clean segments
  * @ss_ndirtysegs: number of dirty segments
- * @ss_ctime:
- * @ss_nongc_ctime:
+ * @ss_ctime: creation time of the last segment
+ * @ss_nongc_ctime: creation time of the last segment not for GC
+ * @ss_prot_seq: least sequence number of segments which must not be reclaimed
  */
 struct nilfs_sustat {
 	__u64 ss_nsegs;
@@ -726,6 +723,7 @@ struct nilfs_sustat {
 	__u64 ss_ndirtysegs;
 	__u64 ss_ctime;
 	__u64 ss_nongc_ctime;
+	__u64 ss_prot_seq;
 };
 
 /**
-- 
1.5.6.5

