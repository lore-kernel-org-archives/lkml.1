Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZCEQMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZCEQMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZCEQLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:11:24 -0500
Received: from sh.osrg.net ([192.16.179.4]:40820 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbZCEQLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:11:19 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm 2/5] nilfs2: clean up sketch file
Date: Fri,  6 Mar 2009 01:07:46 +0900
Message-Id: <1236269269-512-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1236269269-512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1236269269-512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Mar 2009 01:11:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sketch file is a file to mark checkpoints with user data.  It was
experimentally introduced in the original implementation, and now
obsolete.  The file was handled differently with regular files; the
file size got truncated when a checkpoint was created.

This stops the special treatment and will treat it as a regular file.
Most users are not affected because mkfs.nilfs2 no longer makes this
file.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 Documentation/filesystems/nilfs2.txt |    2 -
 fs/nilfs2/inode.c                    |   35 +-----------------------
 fs/nilfs2/segment.c                  |   49 +---------------------------------
 fs/nilfs2/segment.h                  |    8 -----
 include/linux/nilfs2_fs.h            |    2 -
 5 files changed, 3 insertions(+), 93 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 3367fc4..55c4300 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -161,8 +161,6 @@ the following meta data files:
  4) Data address translation file  -- Maps virtual block numbers to usual
     (DAT)                             block numbers.  This file serves to
                                       make on-disk blocks relocatable.
- 5) Sketch file (sketch)           -- Keeps read-only data which can be
-                                      associated with checkpoints (optional)
 
 The following figure shows a typical organization of the logs:
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index b6536bb..a1922b1 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -418,30 +418,6 @@ int nilfs_read_inode_common(struct inode *inode,
 	return 0;
 }
 
-static int nilfs_read_sketch_inode(struct inode *inode)
-{
-	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
-	int err = 0;
-
-	if (sbi->s_snapshot_cno) {
-		struct the_nilfs *nilfs = sbi->s_nilfs;
-		struct buffer_head *bh_cp;
-		struct nilfs_checkpoint *raw_cp;
-
-		err = nilfs_cpfile_get_checkpoint(
-			nilfs->ns_cpfile, sbi->s_snapshot_cno, 0, &raw_cp,
-			&bh_cp);
-		if (likely(!err)) {
-			if (!nilfs_checkpoint_sketch(raw_cp))
-				inode->i_size = 0;
-			nilfs_cpfile_put_checkpoint(
-				nilfs->ns_cpfile, sbi->s_snapshot_cno, bh_cp);
-		}
-		inode->i_flags |= S_NOCMTIME;
-	}
-	return err;
-}
-
 static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
 			      struct inode *inode)
 {
@@ -469,11 +445,6 @@ static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
 		inode->i_op = &nilfs_file_inode_operations;
 		inode->i_fop = &nilfs_file_operations;
 		inode->i_mapping->a_ops = &nilfs_aops;
-		if (unlikely(inode->i_ino == NILFS_SKETCH_INO)) {
-			err = nilfs_read_sketch_inode(inode);
-			if (unlikely(err))
-				goto failed_unmap;
-		}
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op = &nilfs_dir_inode_operations;
 		inode->i_fop = &nilfs_dir_operations;
@@ -742,8 +713,7 @@ int nilfs_set_file_dirty(struct nilfs_sb_info *sbi, struct inode *inode,
 
 	atomic_add(nr_dirty, &sbi->s_nilfs->ns_ndirtyblks);
 
-	if (test_and_set_bit(NILFS_I_DIRTY, &ii->i_state) ||
-	    unlikely(inode->i_ino == NILFS_SKETCH_INO))
+	if (test_and_set_bit(NILFS_I_DIRTY, &ii->i_state))
 		return 0;
 
 	spin_lock(&sbi->s_inode_lock);
@@ -811,7 +781,6 @@ void nilfs_dirty_inode(struct inode *inode)
 		return;
 	}
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
-	if (likely(inode->i_ino != NILFS_SKETCH_INO))
-		nilfs_mark_inode_dirty(inode);
+	nilfs_mark_inode_dirty(inode);
 	nilfs_transaction_commit(inode->i_sb); /* never fails */
 }
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9a87410..981c34a 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -67,7 +67,6 @@ enum {
 	NILFS_ST_INIT = 0,
 	NILFS_ST_GC,		/* Collecting dirty blocks for GC */
 	NILFS_ST_FILE,
-	NILFS_ST_SKETCH,
 	NILFS_ST_IFILE,
 	NILFS_ST_CPFILE,
 	NILFS_ST_SUFILE,
@@ -887,8 +886,7 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 		cpu_to_le64(sci->sc_nblk_inc + sci->sc_nblk_this_inc);
 	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
 	raw_cp->cp_cno = cpu_to_le64(nilfs->ns_cno);
-	if (sci->sc_sketch_inode && i_size_read(sci->sc_sketch_inode) > 0)
-		nilfs_checkpoint_set_sketch(raw_cp);
+
 	nilfs_write_inode_common(sbi->s_ifile, &raw_cp->cp_ifile_inode, 1);
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
 	return 0;
@@ -923,11 +921,6 @@ static void nilfs_segctor_fill_in_file_bmap(struct nilfs_sc_info *sci,
 		nilfs_fill_in_file_bmap(ifile, ii);
 		set_bit(NILFS_I_COLLECTED, &ii->i_state);
 	}
-	if (sci->sc_sketch_inode) {
-		ii = NILFS_I(sci->sc_sketch_inode);
-		if (test_bit(NILFS_I_DIRTY, &ii->i_state))
-			nilfs_fill_in_file_bmap(ifile, ii);
-	}
 }
 
 /*
@@ -1228,26 +1221,6 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 			sci->sc_stage.scnt = NILFS_ST_DONE;
 			return 0;
 		}
-		sci->sc_stage.scnt++;  /* Fall through */
-	case NILFS_ST_SKETCH:
-		if (mode == SC_LSEG_SR && sci->sc_sketch_inode) {
-			ii = NILFS_I(sci->sc_sketch_inode);
-			if (test_bit(NILFS_I_DIRTY, &ii->i_state)) {
-				sci->sc_sketch_inode->i_ctime.tv_sec
-					= sci->sc_seg_ctime;
-				sci->sc_sketch_inode->i_mtime.tv_sec
-					= sci->sc_seg_ctime;
-				err = nilfs_mark_inode_dirty(
-					sci->sc_sketch_inode);
-				if (unlikely(err))
-					goto break_or_fail;
-			}
-			err = nilfs_segctor_scan_file(sci,
-						      sci->sc_sketch_inode,
-						      &nilfs_sc_file_ops);
-			if (unlikely(err))
-				goto break_or_fail;
-		}
 		sci->sc_stage.scnt++;
 		sci->sc_stage.flags |= NILFS_CF_IFILE_STARTED;
 		/* Fall through */
@@ -2385,13 +2358,6 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
 
-	/* Clearing sketch data */
-	if (has_sr && sci->sc_sketch_inode) {
-		if (i_size_read(sci->sc_sketch_inode) == 0)
-			clear_bit(NILFS_I_DIRTY,
-				  &NILFS_I(sci->sc_sketch_inode)->i_state);
-		i_size_write(sci->sc_sketch_inode, 0);
-	}
  out:
 	nilfs_segctor_destroy_segment_buffers(sci);
 	nilfs_segctor_check_out_files(sci, sbi);
@@ -2971,11 +2937,6 @@ static int nilfs_segctor_init(struct nilfs_sc_info *sci,
 			      struct nilfs_recovery_info *ri)
 {
 	int err;
-	struct inode *inode = nilfs_iget(sci->sc_super, NILFS_SKETCH_INO);
-
-	sci->sc_sketch_inode = IS_ERR(inode) ? NULL : inode;
-	if (sci->sc_sketch_inode)
-		i_size_write(sci->sc_sketch_inode, 0);
 
 	sci->sc_seq_done = sci->sc_seq_request;
 	if (ri)
@@ -2987,10 +2948,6 @@ static int nilfs_segctor_init(struct nilfs_sc_info *sci,
 		if (ri)
 			list_splice_init(&sci->sc_active_segments,
 					 ri->ri_used_segments.prev);
-		if (sci->sc_sketch_inode) {
-			iput(sci->sc_sketch_inode);
-			sci->sc_sketch_inode = NULL;
-		}
 	}
 	return err;
 }
@@ -3090,10 +3047,6 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	WARN_ON(!list_empty(&sci->sc_segbufs));
 
-	if (sci->sc_sketch_inode) {
-		iput(sci->sc_sketch_inode);
-		sci->sc_sketch_inode = NULL;
-	}
 	down_write(&sbi->s_nilfs->ns_segctor_sem);
 
 	kfree(sci);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 2dd39da..fbd162d 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -108,7 +108,6 @@ struct nilfs_segsum_pointer {
  * @sc_nblk_this_inc: Number of blocks included in the current logical segment
  * @sc_seg_ctime: Creation time
  * @sc_flags: Internal flags
- * @sc_sketch_inode: Inode of the sketch file
  * @sc_state_lock: spinlock for sc_state and so on
  * @sc_state: Segctord state flags
  * @sc_flush_request: inode bitmap of metadata files to be flushed
@@ -158,13 +157,6 @@ struct nilfs_sc_info {
 
 	unsigned long		sc_flags;
 
-	/*
-	 * Pointer to an inode of the sketch.
-	 * This pointer is kept only while it contains data.
-	 * We protect it with a semaphore of the segment constructor.
-	 */
-	struct inode	       *sc_sketch_inode;
-
 	spinlock_t		sc_state_lock;
 	unsigned long		sc_state;
 	unsigned long		sc_flush_request;
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index aa93f0e..e9c84aa 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -494,7 +494,6 @@ nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
 
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
 NILFS_CHECKPOINT_FNS(INVALID, invalid)
-NILFS_CHECKPOINT_FNS(SKETCH, sketch)
 
 /**
  * struct nilfs_cpinfo - checkpoint information
@@ -527,7 +526,6 @@ nilfs_cpinfo_##name(const struct nilfs_cpinfo *cpinfo)			\
 
 NILFS_CPINFO_FNS(SNAPSHOT, snapshot)
 NILFS_CPINFO_FNS(INVALID, invalid)
-NILFS_CPINFO_FNS(SKETCH, sketch)
 
 
 /**
-- 
1.5.6.5

