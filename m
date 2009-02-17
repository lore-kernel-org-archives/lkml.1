Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBQIMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBQIMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZBQIKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:10:54 -0500
Received: from sh.osrg.net ([192.16.179.4]:55118 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZBQIKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:10:44 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 1/6] nilfs2: remove timedwait ioctl command
Date: Tue, 17 Feb 2009 16:42:01 +0900
Message-Id: <1234856526-1947-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Feb 2009 17:10:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes NILFS_IOCTL_TIMEDWAIT command from ioctl interface along
with the related flags and wait queue.

The command is terrible because it just sleeps in the ioctl.  I prefer
to avoid this by devising means of event polling in userland program.
By reconsidering the userland GC daemon, I found this is possible
without changing behaviour of the daemon and sacrificing efficiency.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c         |   95 +--------------------------------------------
 fs/nilfs2/segment.c       |    5 +--
 fs/nilfs2/the_nilfs.c     |    1 -
 fs/nilfs2/the_nilfs.h     |    6 ---
 include/linux/nilfs2_fs.h |   22 ----------
 5 files changed, 2 insertions(+), 127 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 9e4d9e6..85a291c 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -578,62 +578,9 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 				      unsigned int cmd, void __user *argp)
 {
-	int ret;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	ret = nilfs_clean_segments(inode->i_sb, argp);
-	clear_nilfs_cond_nongc_write(NILFS_SB(inode->i_sb)->s_nilfs);
-	return ret;
-}
-
-static int nilfs_ioctl_test_cond(struct the_nilfs *nilfs, int cond)
-{
-	return (cond & NILFS_TIMEDWAIT_SEG_WRITE) &&
-		nilfs_cond_nongc_write(nilfs);
-}
-
-static void nilfs_ioctl_clear_cond(struct the_nilfs *nilfs, int cond)
-{
-	if (cond & NILFS_TIMEDWAIT_SEG_WRITE)
-		clear_nilfs_cond_nongc_write(nilfs);
-}
-
-static int nilfs_ioctl_timedwait(struct inode *inode, struct file *filp,
-				 unsigned int cmd, void __user *argp)
-{
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
-	struct nilfs_wait_cond wc;
-	long ret;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (copy_from_user(&wc, argp, sizeof(wc)))
-		return -EFAULT;
-
-	unlock_kernel();
-	ret = wc.wc_flags ?
-		wait_event_interruptible_timeout(
-			nilfs->ns_cleanerd_wq,
-			nilfs_ioctl_test_cond(nilfs, wc.wc_cond),
-			timespec_to_jiffies(&wc.wc_timeout)) :
-		wait_event_interruptible(
-			nilfs->ns_cleanerd_wq,
-			nilfs_ioctl_test_cond(nilfs, wc.wc_cond));
-	lock_kernel();
-	nilfs_ioctl_clear_cond(nilfs, wc.wc_cond);
-
-	if (ret > 0) {
-		jiffies_to_timespec(ret, &wc.wc_timeout);
-		if (copy_to_user(argp, &wc, sizeof(wc)))
-			return -EFAULT;
-		return 0;
-	}
-	if (ret != 0)
-		return -EINTR;
-
-	return wc.wc_flags ? -ETIME : 0;
+	return nilfs_clean_segments(inode->i_sb, argp);
 }
 
 static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
@@ -679,8 +626,6 @@ int nilfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		return nilfs_ioctl_get_bdescs(inode, filp, cmd, argp);
 	case NILFS_IOCTL_CLEAN_SEGMENTS:
 		return nilfs_ioctl_clean_segments(inode, filp, cmd, argp);
-	case NILFS_IOCTL_TIMEDWAIT:
-		return nilfs_ioctl_timedwait(inode, filp, cmd, argp);
 	case NILFS_IOCTL_SYNC:
 		return nilfs_ioctl_sync(inode, filp, cmd, argp);
 	default:
@@ -871,41 +816,6 @@ nilfs_compat_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		inode, filp, cmd, (unsigned long)uargv);
 }
 
-static int
-nilfs_compat_ioctl_timedwait(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
-{
-	struct nilfs_wait_cond __user *uwcond;
-	struct nilfs_wait_cond32 __user *uwcond32;
-	struct timespec ts;
-	int cond, flags, ret;
-
-	uwcond = compat_alloc_user_space(sizeof(struct nilfs_wait_cond));
-	uwcond32 = compat_ptr(arg);
-	if (get_user(cond, &uwcond32->wc_cond) ||
-	    put_user(cond, &uwcond->wc_cond) ||
-	    get_user(flags, &uwcond32->wc_flags) ||
-	    put_user(flags, &uwcond->wc_flags) ||
-	    get_user(ts.tv_sec, &uwcond32->wc_timeout.tv_sec) ||
-	    get_user(ts.tv_nsec, &uwcond32->wc_timeout.tv_nsec) ||
-	    put_user(ts.tv_sec, &uwcond->wc_timeout.tv_sec) ||
-	    put_user(ts.tv_nsec, &uwcond->wc_timeout.tv_nsec))
-		return -EFAULT;
-
-	ret = nilfs_compat_locked_ioctl(inode, filp, cmd,
-					(unsigned long)uwcond);
-	if (ret < 0)
-		return ret;
-
-	if (get_user(ts.tv_sec, &uwcond->wc_timeout.tv_sec) ||
-	    get_user(ts.tv_nsec, &uwcond->wc_timeout.tv_nsec) ||
-	    put_user(ts.tv_sec, &uwcond32->wc_timeout.tv_sec) ||
-	    put_user(ts.tv_nsec, &uwcond32->wc_timeout.tv_nsec))
-		return -EFAULT;
-
-	return 0;
-}
-
 static int nilfs_compat_ioctl_sync(struct inode *inode, struct file *filp,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -943,9 +853,6 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL32_CLEAN_SEGMENTS:
 		return nilfs_compat_ioctl_clean_segments(
 			inode, filp, NILFS_IOCTL_CLEAN_SEGMENTS, arg);
-	case NILFS_IOCTL32_TIMEDWAIT:
-		return nilfs_compat_ioctl_timedwait(
-			inode, filp, NILFS_IOCTL_TIMEDWAIT, arg);
 	case NILFS_IOCTL_SYNC:
 		return nilfs_compat_ioctl_sync(inode, filp, cmd, arg);
 	default:
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 6d66c5c..5db12d7 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2114,11 +2114,8 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 		nilfs_drop_collected_inodes(&sci->sc_gc_inodes);
 		if (update_sr)
 			nilfs_commit_gcdat_inode(nilfs);
-	} else {
+	} else
 		nilfs->ns_nongc_ctime = sci->sc_seg_ctime;
-		set_nilfs_cond_nongc_write(nilfs);
-		wake_up(&nilfs->ns_cleanerd_wq);
-	}
 
 	sci->sc_nblk_inc += sci->sc_nblk_this_inc;
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 852e0bf..69b6255 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -73,7 +73,6 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	nilfs->ns_gc_inodes_h = NULL;
 	INIT_LIST_HEAD(&nilfs->ns_used_segments);
 	init_rwsem(&nilfs->ns_segctor_sem);
-	init_waitqueue_head(&nilfs->ns_cleanerd_wq);
 
 	return nilfs;
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 9cd3c11..75da373 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -37,7 +37,6 @@ enum {
 	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
 				   the latest checkpoint was loaded */
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
-	THE_NILFS_COND_NONGC_WRITE,	/* Condition to wake up cleanerd */
 };
 
 /**
@@ -74,7 +73,6 @@ enum {
  * @ns_gc_dat: shadow inode of the DAT file inode for GC
  * @ns_gc_inodes: dummy inodes to keep live blocks
  * @ns_gc_inodes_h: hash list to keep dummy inode holding live blocks
- * @ns_cleanerd_wq: wait queue for cleanerd
  * @ns_blocksize_bits: bit length of block size
  * @ns_nsegments: number of segments in filesystem
  * @ns_blocks_per_segment: number of blocks per segment
@@ -151,9 +149,6 @@ struct the_nilfs {
 	struct list_head	ns_gc_inodes;
 	struct hlist_head      *ns_gc_inodes_h;
 
-	/* cleanerd */
-	wait_queue_head_t	ns_cleanerd_wq;
-
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;
 	unsigned long		ns_nsegments;
@@ -186,7 +181,6 @@ static inline int nilfs_##name(struct the_nilfs *nilfs)			\
 THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(LOADED, loaded)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
-THE_NILFS_FNS(COND_NONGC_WRITE, cond_nongc_write)
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
 struct the_nilfs *alloc_nilfs(struct block_device *);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index e38fad2..b0a6b39 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -763,18 +763,6 @@ struct nilfs_bdesc {
 	__u32 bd_level;
 };
 
-#define	NILFS_TIMEDWAIT_WRITE_LOCKED	0x1
-#define	NILFS_TIMEDWAIT_SEG_WRITE	0x2
-
-/**
- * struct nilfs_wait_cond -
- */
-struct nilfs_wait_cond {
-	int wc_cond;
-	int wc_flags;
-	struct timespec wc_timeout;
-};
-
 #define NILFS_IOCTL_IDENT		'n'
 
 #define NILFS_IOCTL_CHANGE_CPMODE  \
@@ -795,8 +783,6 @@ struct nilfs_wait_cond {
 	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv)
 #define NILFS_IOCTL_CLEAN_SEGMENTS  \
 	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv[5])
-#define NILFS_IOCTL_TIMEDWAIT  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x89, struct nilfs_wait_cond)
 #define NILFS_IOCTL_SYNC  \
 	_IOR(NILFS_IOCTL_IDENT, 0x8A, __u64)
 #define NILFS_IOCTL_RESIZE  \
@@ -827,12 +813,6 @@ struct nilfs_sustat32 {
 	compat_time_t ss_nongc_ctime;
 };
 
-struct nilfs_wait_cond32 {
-	compat_int_t wc_cond;
-	compat_int_t wc_flags;
-	struct compat_timespec wc_timeout;
-};
-
 #define NILFS_IOCTL32_CHANGE_CPMODE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x80, struct nilfs_cpmode32)
 #define NILFS_IOCTL32_GET_CPINFO  \
@@ -847,8 +827,6 @@ struct nilfs_wait_cond32 {
 	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv32)
 #define NILFS_IOCTL32_CLEAN_SEGMENTS  \
 	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv32[5])
-#define NILFS_IOCTL32_TIMEDWAIT  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x89, struct nilfs_wait_cond32)
 #endif	/* CONFIG_COMPAT */
 
 #endif	/* _LINUX_NILFS_FS_H */
-- 
1.5.6.5

