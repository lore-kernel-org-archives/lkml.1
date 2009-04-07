Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbZDGCUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbZDGCUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZDGCT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:19:57 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:58566 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZDGCTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UYAj6+rDoZN2hwNiaQH+Vbs2nic3XVGz2kR+EBiE6xFJ2C+X37pwLRQHjfgdv7zsx/
         +r4VtbeKFwgXncRfBaBFVAnCob3sTje3GLvEWSb0Cw1Y43QyaciqIZkmNuxCIyjUgIsm
         QdqhdA3wOMd3cXbFxiJS42011mYfr1ifPoM/4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] reiserfs: kill-the-BKL
Date: Tue,  7 Apr 2009 04:19:49 +0200
Message-Id: <1239070789-13354-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the tip:kill-the-BKL tree.

First of all, I'm sorry for such a monolithic patch. I know it doesn't make it
easy to review. But I can't really cut it in several subjects because all
bits are needed here for the "Bkl to a mutex" conversion.

Although I first thought that half of it was only there for performance
optimizations and could also be decoupled, further tests showed me that
they all contribute to correctness and not only performance.

This patch is an attempt to remove the Bkl based locking scheme from
reiserfs and is intended.
It is a bit inspired from an old attempt by Peter Zijlstra:
http://lkml.indiana.edu/hypermail/linux/kernel/0704.2/2174.html


The bkl is heavily used in this filesystem to prevent from
concurrent write accesses on the filesystem.

Reiserfs makes a deep use of the specific properties of the Bkl:

- It can be acqquired recursively by a same task
- It is released on the schedule() calls and reacquired when schedule() returns

The two properties above are a roadmap for the reiserfs write locking so it's
very hard to simply replace it with a common mutex.

- We need a recursive-able locking unless we want to restructure several blocks
  of the code.
- We need to identify the sites where the bkl was implictly relaxed
  (schedule, wait, sync, etc...) so that we can in turn release and
  reacquire our new lock explicitly.
  Such implicit releases of the lock are often required to let other
  resources producer/consumer do their job or we can suffer unexpected
  starvations or deadlocks.

So the new lock that replaces the bkl here is a per superblock mutex with a
specific property: it can be acquired recursively by a same task, like the
bkl.
For such purpose, we integrate a lock owner and a lock depth field on the
superblock information structure.

The first axis on this patch is to turn reiserfs_write_(un)lock() function
into a wrapper to manage this mutex. Also some explicit calls to
lock_kernel() have been converted to reiserfs_write_lock() helpers.

The second axis is to find the important blocking sites (schedule...(),
wait_on_buffer(), sync_dirty_buffer(), etc...) and then apply an explicit
release of the write lock on these locations before blocking. Then we can
safely wait for those who can give us resources or those who need some.
Typically this is a fight between the current writer, the reiserfs workqueue
(aka the async commiter) and the pdflush threads.

The third axis is a consequence of the second. The write lock is usually
on top of a lock dependency chain which can include the journal lock, the
flush lock or the commit lock. So it's dangerous to release and trying to
reacquire the write lock while we still hold other locks.

This is fine with the bkl:

      T1                       T2

lock_kernel()
    mutex_lock(A)
    unlock_kernel()
    // do something
                            lock_kernel()
                                mutex_lock(A) -> already locked by T1
                                schedule() (and then unlock_kernel())
    lock_kernel()
    mutex_unlock(A)
    ....

This is not fine with a mutex:

      T1                       T2

mutex_lock(write)
    mutex_lock(A)
    mutex_unlock(write)
    // do something
                           mutex_lock(write)
                              mutex_lock(A) -> already locked by T1
                              schedule()

    mutex_lock(write) -> already locked by T2
    deadlock

The solution in this patch is to provide a helper which releases the write
lock and sleep a bit if we can't lock a mutex that depend on it. It's another
simulation of the bkl behaviour.

The last axis is to locate the fs callbacks that are called with the bkl held,
according to Documentation/filesystem/Locking.

Those are:

- reiserfs_remount
- reiserfs_fill_super
- reiserfs_put_super

Reiserfs didn't need to explicitly lock because of the context of these callbacks.
But now we must take care of that with the new locking.

After this patch, reiserfs suffers from a slight performance regression (for now).
On UP, a high volume write with dd reports an average of 27 MB/s instead
of 30 MB/s without the patch applied.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/Makefile           |    2 +-
 fs/reiserfs/bitmap.c           |    2 +
 fs/reiserfs/dir.c              |    8 +++
 fs/reiserfs/fix_node.c         |   10 +++
 fs/reiserfs/inode.c            |   23 +++++--
 fs/reiserfs/ioctl.c            |    6 +-
 fs/reiserfs/journal.c          |  134 +++++++++++++++++++++++++++++++---------
 fs/reiserfs/lock.c             |   63 +++++++++++++++++++
 fs/reiserfs/resize.c           |    2 +
 fs/reiserfs/stree.c            |    2 +
 fs/reiserfs/super.c            |   41 ++++++++++++-
 include/linux/reiserfs_fs.h    |   12 ++--
 include/linux/reiserfs_fs_sb.h |    9 +++
 13 files changed, 271 insertions(+), 43 deletions(-)
 create mode 100644 fs/reiserfs/lock.c

diff --git a/fs/reiserfs/Makefile b/fs/reiserfs/Makefile
index 7c5ab63..6a9e30c 100644
--- a/fs/reiserfs/Makefile
+++ b/fs/reiserfs/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_REISERFS_FS) += reiserfs.o
 reiserfs-objs := bitmap.o do_balan.o namei.o inode.o file.o dir.o fix_node.o \
 		 super.o prints.o objectid.o lbalance.o ibalance.o stree.o \
 		 hashes.o tail_conversion.o journal.o resize.o \
-		 item_ops.o ioctl.o procfs.o xattr.o
+		 item_ops.o ioctl.o procfs.o xattr.o lock.o
 
 ifeq ($(CONFIG_REISERFS_FS_XATTR),y)
 reiserfs-objs += xattr_user.o xattr_trusted.o
diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index e716161..1470334 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -1256,7 +1256,9 @@ struct buffer_head *reiserfs_read_bitmap_block(struct super_block *sb,
 	else {
 		if (buffer_locked(bh)) {
 			PROC_INFO_INC(sb, scan_bitmap.wait);
+			reiserfs_write_unlock(sb);
 			__wait_on_buffer(bh);
+			reiserfs_write_lock(sb);
 		}
 		BUG_ON(!buffer_uptodate(bh));
 		BUG_ON(atomic_read(&bh->b_count) == 0);
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 67a80d7..6d71aa0 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -174,14 +174,22 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 				// user space buffer is swapped out. At that time
 				// entry can move to somewhere else
 				memcpy(local_buf, d_name, d_reclen);
+
+				/*
+				 * Since filldir might sleep, we can release
+				 * the write lock here for other waiters
+				 */
+				reiserfs_write_unlock(inode->i_sb);
 				if (filldir
 				    (dirent, local_buf, d_reclen, d_off, d_ino,
 				     DT_UNKNOWN) < 0) {
+					reiserfs_write_lock(inode->i_sb);
 					if (local_buf != small_buf) {
 						kfree(local_buf);
 					}
 					goto end;
 				}
+				reiserfs_write_lock(inode->i_sb);
 				if (local_buf != small_buf) {
 					kfree(local_buf);
 				}
diff --git a/fs/reiserfs/fix_node.c b/fs/reiserfs/fix_node.c
index 5e5a4e6..bf5f2cb 100644
--- a/fs/reiserfs/fix_node.c
+++ b/fs/reiserfs/fix_node.c
@@ -1022,7 +1022,11 @@ static int get_far_parent(struct tree_balance *tb,
 	/* Check whether the common parent is locked. */
 
 	if (buffer_locked(*pcom_father)) {
+
+		/* Release the write lock while the buffer is busy */
+		reiserfs_write_unlock(tb->tb_sb);
 		__wait_on_buffer(*pcom_father);
+		reiserfs_write_lock(tb->tb_sb);
 		if (FILESYSTEM_CHANGED_TB(tb)) {
 			brelse(*pcom_father);
 			return REPEAT_SEARCH;
@@ -1927,7 +1931,9 @@ static int get_direct_parent(struct tree_balance *tb, int h)
 		return REPEAT_SEARCH;
 
 	if (buffer_locked(bh)) {
+		reiserfs_write_unlock(tb->tb_sb);
 		__wait_on_buffer(bh);
+		reiserfs_write_lock(tb->tb_sb);
 		if (FILESYSTEM_CHANGED_TB(tb))
 			return REPEAT_SEARCH;
 	}
@@ -2278,7 +2284,9 @@ static int wait_tb_buffers_until_unlocked(struct tree_balance *tb)
 				    REPEAT_SEARCH : CARRY_ON;
 			}
 #endif
+			reiserfs_write_unlock(tb->tb_sb);
 			__wait_on_buffer(locked);
+			reiserfs_write_lock(tb->tb_sb);
 			if (FILESYSTEM_CHANGED_TB(tb))
 				return REPEAT_SEARCH;
 		}
@@ -2349,7 +2357,9 @@ int fix_nodes(int op_mode, struct tree_balance *tb,
 
 	/* if it possible in indirect_to_direct conversion */
 	if (buffer_locked(tbS0)) {
+		reiserfs_write_unlock(tb->tb_sb);
 		__wait_on_buffer(tbS0);
+		reiserfs_write_lock(tb->tb_sb);
 		if (FILESYSTEM_CHANGED_TB(tb))
 			return REPEAT_SEARCH;
 	}
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 6fd0f47..88ef0b7 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -489,10 +489,14 @@ static int reiserfs_get_blocks_direct_io(struct inode *inode,
 	   disappeared */
 	if (REISERFS_I(inode)->i_flags & i_pack_on_close_mask) {
 		int err;
-		lock_kernel();
+
+		reiserfs_write_lock(inode->i_sb);
+
 		err = reiserfs_commit_for_inode(inode);
 		REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
-		unlock_kernel();
+
+		reiserfs_write_unlock(inode->i_sb);
+
 		if (err < 0)
 			ret = err;
 	}
@@ -616,7 +620,6 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 	loff_t new_offset =
 	    (((loff_t) block) << inode->i_sb->s_blocksize_bits) + 1;
 
-	/* bad.... */
 	reiserfs_write_lock(inode->i_sb);
 	version = get_inode_item_key_version(inode);
 
@@ -997,10 +1000,14 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 			if (retval)
 				goto failure;
 		}
-		/* inserting indirect pointers for a hole can take a
-		 ** long time.  reschedule if needed
+		/*
+		 * inserting indirect pointers for a hole can take a
+		 * long time.  reschedule if needed and also release the write
+		 * lock for others.
 		 */
+		reiserfs_write_unlock(inode->i_sb);
 		cond_resched();
+		reiserfs_write_lock(inode->i_sb);
 
 		retval = search_for_position_by_key(inode->i_sb, &key, &path);
 		if (retval == IO_ERROR) {
@@ -2612,7 +2619,10 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
 	int ret;
 	int old_ref = 0;
 
+	reiserfs_write_unlock(inode->i_sb);
 	reiserfs_wait_on_write_block(inode->i_sb);
+	reiserfs_write_lock(inode->i_sb);
+
 	fix_tail_page_for_writing(page);
 	if (reiserfs_transaction_running(inode->i_sb)) {
 		struct reiserfs_transaction_handle *th;
@@ -2762,7 +2772,10 @@ int reiserfs_commit_write(struct file *f, struct page *page,
 	int update_sd = 0;
 	struct reiserfs_transaction_handle *th = NULL;
 
+	reiserfs_write_unlock(inode->i_sb);
 	reiserfs_wait_on_write_block(inode->i_sb);
+	reiserfs_write_lock(inode->i_sb);
+
 	if (reiserfs_transaction_running(inode->i_sb)) {
 		th = current->journal_info;
 	}
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 0ccc3fd..5e40b0c 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -141,9 +141,11 @@ long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
+
+	reiserfs_write_lock(inode->i_sb);
 	ret = reiserfs_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
+	reiserfs_write_unlock(inode->i_sb);
+
 	return ret;
 }
 #endif
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 77f5bb7..64dcabd 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -429,21 +429,6 @@ static void clear_prepared_bits(struct buffer_head *bh)
 	clear_buffer_journal_restore_dirty(bh);
 }
 
-/* utility function to force a BUG if it is called without the big
-** kernel lock held.  caller is the string printed just before calling BUG()
-*/
-void reiserfs_check_lock_depth(struct super_block *sb, char *caller)
-{
-#ifdef CONFIG_SMP
-	if (current->lock_depth < 0) {
-		reiserfs_panic(sb, "journal-1", "%s called without kernel "
-			       "lock held", caller);
-	}
-#else
-	;
-#endif
-}
-
 /* return a cnode with same dev, block number and size in table, or null if not found */
 static inline struct reiserfs_journal_cnode *get_journal_hash_dev(struct
 								  super_block
@@ -552,11 +537,48 @@ static inline void insert_journal_hash(struct reiserfs_journal_cnode **table,
 	journal_hash(table, cn->sb, cn->blocknr) = cn;
 }
 
+/*
+ * Several mutexes depend on the write lock.
+ * However sometimes we want to relax the write lock while we hold
+ * these mutexes, according to the release/reacquire on schedule()
+ * properties of the Bkl that were used.
+ * Reiserfs performances and locking were based on this scheme.
+ * Now that the write lock is a mutex and not the bkl anymore, doing so
+ * may result in a deadlock:
+ *
+ * A acquire write_lock
+ * A acquire j_commit_mutex
+ * A release write_lock and wait for something
+ * B acquire write_lock
+ * B can't acquire j_commit_mutex and sleep
+ * A can't acquire write lock anymore
+ * deadlock
+ *
+ * What we do here is avoiding such deadlock by playing the same game
+ * than the Bkl: if we can't acquire a mutex that depends on the write lock,
+ * we release the write lock, wait a bit and then retry.
+ *
+ * The mutexes concerned by this hack are:
+ * - The commit mutex of a journal list
+ * - The flush mutex
+ * - The journal lock
+ */
+static inline void reiserfs_mutex_lock_safe(struct mutex *m,
+			       struct super_block *s)
+{
+	while (!mutex_trylock(m)) {
+		reiserfs_write_unlock(s);
+		schedule();
+		reiserfs_write_lock(s);
+	}
+}
+
 /* lock the current transaction */
 static inline void lock_journal(struct super_block *sb)
 {
 	PROC_INFO_INC(sb, journal.lock_journal);
-	mutex_lock(&SB_JOURNAL(sb)->j_mutex);
+
+	reiserfs_mutex_lock_safe(&SB_JOURNAL(sb)->j_mutex, sb);
 }
 
 /* unlock the current transaction */
@@ -708,7 +730,9 @@ static void check_barrier_completion(struct super_block *s,
 		disable_barrier(s);
 		set_buffer_uptodate(bh);
 		set_buffer_dirty(bh);
+		reiserfs_write_unlock(s);
 		sync_dirty_buffer(bh);
+		reiserfs_write_lock(s);
 	}
 }
 
@@ -996,8 +1020,13 @@ static int reiserfs_async_progress_wait(struct super_block *s)
 {
 	DEFINE_WAIT(wait);
 	struct reiserfs_journal *j = SB_JOURNAL(s);
-	if (atomic_read(&j->j_async_throttle))
+
+	if (atomic_read(&j->j_async_throttle)) {
+		reiserfs_write_unlock(s);
 		congestion_wait(WRITE, HZ / 10);
+		reiserfs_write_lock(s);
+	}
+
 	return 0;
 }
 
@@ -1043,7 +1072,8 @@ static int flush_commit_list(struct super_block *s,
 	}
 
 	/* make sure nobody is trying to flush this one at the same time */
-	mutex_lock(&jl->j_commit_mutex);
+	reiserfs_mutex_lock_safe(&jl->j_commit_mutex, s);
+
 	if (!journal_list_still_alive(s, trans_id)) {
 		mutex_unlock(&jl->j_commit_mutex);
 		goto put_jl;
@@ -1061,12 +1091,17 @@ static int flush_commit_list(struct super_block *s,
 
 	if (!list_empty(&jl->j_bh_list)) {
 		int ret;
-		unlock_kernel();
+
+		/*
+		 * We might sleep in numerous places inside
+		 * write_ordered_buffers. Relax the write lock.
+		 */
+		reiserfs_write_unlock(s);
 		ret = write_ordered_buffers(&journal->j_dirty_buffers_lock,
 					    journal, jl, &jl->j_bh_list);
 		if (ret < 0 && retval == 0)
 			retval = ret;
-		lock_kernel();
+		reiserfs_write_lock(s);
 	}
 	BUG_ON(!list_empty(&jl->j_bh_list));
 	/*
@@ -1114,12 +1149,19 @@ static int flush_commit_list(struct super_block *s,
 		bn = SB_ONDISK_JOURNAL_1st_BLOCK(s) +
 		    (jl->j_start + i) % SB_ONDISK_JOURNAL_SIZE(s);
 		tbh = journal_find_get_block(s, bn);
+
+		reiserfs_write_unlock(s);
 		wait_on_buffer(tbh);
+		reiserfs_write_lock(s);
 		// since we're using ll_rw_blk above, it might have skipped over
 		// a locked buffer.  Double check here
 		//
-		if (buffer_dirty(tbh))	/* redundant, sync_dirty_buffer() checks */
+		/* redundant, sync_dirty_buffer() checks */
+		if (buffer_dirty(tbh)) {
+			reiserfs_write_unlock(s);
 			sync_dirty_buffer(tbh);
+			reiserfs_write_lock(s);
+		}
 		if (unlikely(!buffer_uptodate(tbh))) {
 #ifdef CONFIG_REISERFS_CHECK
 			reiserfs_warning(s, "journal-601",
@@ -1143,10 +1185,15 @@ static int flush_commit_list(struct super_block *s,
 			if (buffer_dirty(jl->j_commit_bh))
 				BUG();
 			mark_buffer_dirty(jl->j_commit_bh) ;
+			reiserfs_write_unlock(s);
 			sync_dirty_buffer(jl->j_commit_bh) ;
+			reiserfs_write_lock(s);
 		}
-	} else
+	} else {
+		reiserfs_write_unlock(s);
 		wait_on_buffer(jl->j_commit_bh);
+		reiserfs_write_lock(s);
+	}
 
 	check_barrier_completion(s, jl->j_commit_bh);
 
@@ -1286,7 +1333,9 @@ static int _update_journal_header_block(struct super_block *sb,
 
 	if (trans_id >= journal->j_last_flush_trans_id) {
 		if (buffer_locked((journal->j_header_bh))) {
+			reiserfs_write_unlock(sb);
 			wait_on_buffer((journal->j_header_bh));
+			reiserfs_write_lock(sb);
 			if (unlikely(!buffer_uptodate(journal->j_header_bh))) {
 #ifdef CONFIG_REISERFS_CHECK
 				reiserfs_warning(sb, "journal-699",
@@ -1312,12 +1361,16 @@ static int _update_journal_header_block(struct super_block *sb,
 				disable_barrier(sb);
 				goto sync;
 			}
+			reiserfs_write_unlock(sb);
 			wait_on_buffer(journal->j_header_bh);
+			reiserfs_write_lock(sb);
 			check_barrier_completion(sb, journal->j_header_bh);
 		} else {
 		      sync:
 			set_buffer_dirty(journal->j_header_bh);
+			reiserfs_write_unlock(sb);
 			sync_dirty_buffer(journal->j_header_bh);
+			reiserfs_write_lock(sb);
 		}
 		if (!buffer_uptodate(journal->j_header_bh)) {
 			reiserfs_warning(sb, "journal-837",
@@ -1409,7 +1462,7 @@ static int flush_journal_list(struct super_block *s,
 
 	/* if flushall == 0, the lock is already held */
 	if (flushall) {
-		mutex_lock(&journal->j_flush_mutex);
+		reiserfs_mutex_lock_safe(&journal->j_flush_mutex, s);
 	} else if (mutex_trylock(&journal->j_flush_mutex)) {
 		BUG();
 	}
@@ -1553,7 +1606,11 @@ static int flush_journal_list(struct super_block *s,
 					reiserfs_panic(s, "journal-1011",
 						       "cn->bh is NULL");
 				}
+
+				reiserfs_write_unlock(s);
 				wait_on_buffer(cn->bh);
+				reiserfs_write_lock(s);
+
 				if (!cn->bh) {
 					reiserfs_panic(s, "journal-1012",
 						       "cn->bh is NULL");
@@ -1973,11 +2030,19 @@ static int do_journal_release(struct reiserfs_transaction_handle *th,
 	reiserfs_mounted_fs_count--;
 	/* wait for all commits to finish */
 	cancel_delayed_work(&SB_JOURNAL(sb)->j_work);
+
+	/*
+	 * We must release the write lock here because
+	 * the workqueue job (flush_async_commit) needs this lock
+	 */
+	reiserfs_write_unlock(sb);
 	flush_workqueue(commit_wq);
+
 	if (!reiserfs_mounted_fs_count) {
 		destroy_workqueue(commit_wq);
 		commit_wq = NULL;
 	}
+	reiserfs_write_lock(sb);
 
 	free_journal_ram(sb);
 
@@ -2243,7 +2308,11 @@ static int journal_read_transaction(struct super_block *sb,
 	/* read in the log blocks, memcpy to the corresponding real block */
 	ll_rw_block(READ, get_desc_trans_len(desc), log_blocks);
 	for (i = 0; i < get_desc_trans_len(desc); i++) {
+
+		reiserfs_write_unlock(sb);
 		wait_on_buffer(log_blocks[i]);
+		reiserfs_write_lock(sb);
+
 		if (!buffer_uptodate(log_blocks[i])) {
 			reiserfs_warning(sb, "journal-1212",
 					 "REPLAY FAILURE fsck required! "
@@ -2964,8 +3033,11 @@ static void queue_log_writer(struct super_block *s)
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(&journal->j_join_wait, &wait);
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	if (test_bit(J_WRITERS_QUEUED, &journal->j_state))
+	if (test_bit(J_WRITERS_QUEUED, &journal->j_state)) {
+		reiserfs_write_unlock(s);
 		schedule();
+		reiserfs_write_lock(s);
+	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&journal->j_join_wait, &wait);
 }
@@ -2982,7 +3054,9 @@ static void let_transaction_grow(struct super_block *sb, unsigned int trans_id)
 	struct reiserfs_journal *journal = SB_JOURNAL(sb);
 	unsigned long bcount = journal->j_bcount;
 	while (1) {
+		reiserfs_write_unlock(sb);
 		schedule_timeout_uninterruptible(1);
+		reiserfs_write_lock(sb);
 		journal->j_current_jl->j_state |= LIST_COMMIT_PENDING;
 		while ((atomic_read(&journal->j_wcount) > 0 ||
 			atomic_read(&journal->j_jlock)) &&
@@ -3033,7 +3107,9 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 
 	if (test_bit(J_WRITERS_BLOCKED, &journal->j_state)) {
 		unlock_journal(sb);
+		reiserfs_write_unlock(sb);
 		reiserfs_wait_on_write_block(sb);
+		reiserfs_write_lock(sb);
 		PROC_INFO_INC(sb, journal.journal_relock_writers);
 		goto relock;
 	}
@@ -3506,14 +3582,14 @@ static void flush_async_commits(struct work_struct *work)
 	struct reiserfs_journal_list *jl;
 	struct list_head *entry;
 
-	lock_kernel();
+	reiserfs_write_lock(sb);
 	if (!list_empty(&journal->j_journal_list)) {
 		/* last entry is the youngest, commit it and you get everything */
 		entry = journal->j_journal_list.prev;
 		jl = JOURNAL_LIST_ENTRY(entry);
 		flush_commit_list(sb, jl, 1);
 	}
-	unlock_kernel();
+	reiserfs_write_unlock(sb);
 }
 
 /*
@@ -4041,7 +4117,7 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	 * the new transaction is fully setup, and we've already flushed the
 	 * ordered bh list
 	 */
-	mutex_lock(&jl->j_commit_mutex);
+	reiserfs_mutex_lock_safe(&jl->j_commit_mutex, sb);
 
 	/* save the transaction id in case we need to commit it later */
 	commit_trans_id = jl->j_trans_id;
@@ -4203,10 +4279,10 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	 * is lost.
 	 */
 	if (!list_empty(&jl->j_tail_bh_list)) {
-		unlock_kernel();
+		reiserfs_write_unlock(sb);
 		write_ordered_buffers(&journal->j_dirty_buffers_lock,
 				      journal, jl, &jl->j_tail_bh_list);
-		lock_kernel();
+		reiserfs_write_lock(sb);
 	}
 	BUG_ON(!list_empty(&jl->j_tail_bh_list));
 	mutex_unlock(&jl->j_commit_mutex);
diff --git a/fs/reiserfs/lock.c b/fs/reiserfs/lock.c
new file mode 100644
index 0000000..cdd8d9e
--- /dev/null
+++ b/fs/reiserfs/lock.c
@@ -0,0 +1,63 @@
+#include <linux/reiserfs_fs.h>
+#include <linux/mutex.h>
+
+/*
+ * The previous reiserfs locking scheme was heavily based on
+ * the tricky properties of the Bkl:
+ *
+ * - it was acquired recursively by a same task
+ * - the performances relied on the release-while-schedule() property
+ *
+ * Now that we replace it by a mutex, we still want to keep the same
+ * recursive property to avoid big changes in the code structure.
+ * We use our own lock_owner here because the owner field on a mutex
+ * is only available in SMP or mutex debugging, also we only need this field
+ * for this mutex, no need for a system wide mutex facility.
+ *
+ * Also this lock is often released before a call that could block because
+ * reiserfs performances were partialy based on the release while schedule()
+ * property of the Bkl.
+ */
+void reiserfs_write_lock(struct super_block *s)
+{
+	struct reiserfs_sb_info *sb_i = REISERFS_SB(s);
+
+	if (sb_i->lock_owner != current) {
+		mutex_lock(&sb_i->lock);
+		sb_i->lock_owner = current;
+	}
+
+	/* No need to protect it, only the current task touches it */
+	sb_i->lock_depth++;
+}
+
+void reiserfs_write_unlock(struct super_block *s)
+{
+	struct reiserfs_sb_info *sb_i = REISERFS_SB(s);
+
+	/*
+	 * Are we unlocking without even holding the lock?
+	 * Such a situation could even raise a BUG() if we don't
+	 * want the data become corrupted
+	 */
+	WARN_ONCE(sb_i->lock_owner != current,
+		  "Superblock write lock imbalance");
+
+	if (--sb_i->lock_depth == -1) {
+		sb_i->lock_owner = NULL;
+		mutex_unlock(&sb_i->lock);
+	}
+}
+
+/*
+ * Utility function to force a BUG if it is called without the superblock
+ * write lock held.  caller is the string printed just before calling BUG()
+ */
+void reiserfs_check_lock_depth(struct super_block *sb, char *caller)
+{
+	struct reiserfs_sb_info *sb_i = REISERFS_SB(sb);
+
+	if (sb_i->lock_depth < 0)
+		reiserfs_panic(sb, "%s called without kernel lock held %d",
+			       caller);
+}
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index 238e9d9..6a7bfb3 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -142,7 +142,9 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
+			reiserfs_write_unlock(s);
 			sync_dirty_buffer(bh);
+			reiserfs_write_lock(s);
 			// update bitmap_info stuff
 			bitmap[i].free_count = sb_blocksize(sb) * 8 - 1;
 			brelse(bh);
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index d036ee5..6bd99a9 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -629,7 +629,9 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
 				search_by_key_reada(sb, reada_bh,
 						    reada_blocks, reada_count);
 			ll_rw_block(READ, 1, &bh);
+			reiserfs_write_unlock(sb);
 			wait_on_buffer(bh);
+			reiserfs_write_lock(sb);
 			if (!buffer_uptodate(bh))
 				goto io_error;
 		} else {
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 0ae6486..1ac4fcb 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -470,6 +470,13 @@ static void reiserfs_put_super(struct super_block *s)
 	struct reiserfs_transaction_handle th;
 	th.t_trans_id = 0;
 
+	/*
+	 * We didn't need to explicitly lock here before, because put_super
+	 * is called with the bkl held.
+	 * Now that we have our own lock, we must explicitly lock.
+	 */
+	reiserfs_write_lock(s);
+
 	/* change file system state to current state if it was mounted with read-write permissions */
 	if (!(s->s_flags & MS_RDONLY)) {
 		if (!journal_begin(&th, s, 10)) {
@@ -499,6 +506,8 @@ static void reiserfs_put_super(struct super_block *s)
 
 	reiserfs_proc_info_done(s);
 
+	reiserfs_write_unlock(s);
+	mutex_destroy(&REISERFS_SB(s)->lock);
 	kfree(s->s_fs_info);
 	s->s_fs_info = NULL;
 
@@ -1191,7 +1200,15 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	unsigned int qfmt = 0;
 #ifdef CONFIG_QUOTA
 	int i;
+#endif
 
+	/*
+	 * We used to protect using the implicitly acquired bkl here.
+	 * Now we must explictly acquire our own lock
+	 */
+	reiserfs_write_lock(s);
+
+#ifdef CONFIG_QUOTA
 	memcpy(qf_names, REISERFS_SB(s)->s_qf_names, sizeof(qf_names));
 #endif
 
@@ -1316,11 +1333,13 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	}
 
 out_ok:
+	reiserfs_write_unlock(s);
 	kfree(s->s_options);
 	s->s_options = new_opts;
 	return 0;
 
 out_err:
+	reiserfs_write_unlock(s);
 	kfree(new_opts);
 	return err;
 }
@@ -1425,7 +1444,9 @@ static int read_super_block(struct super_block *s, int offset)
 static int reread_meta_blocks(struct super_block *s)
 {
 	ll_rw_block(READ, 1, &(SB_BUFFER_WITH_SB(s)));
+	reiserfs_write_unlock(s);
 	wait_on_buffer(SB_BUFFER_WITH_SB(s));
+	reiserfs_write_lock(s);
 	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
 		reiserfs_warning(s, "reiserfs-2504", "error reading the super");
 		return 1;
@@ -1634,7 +1655,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
 	if (!sbi) {
 		errval = -ENOMEM;
-		goto error;
+		goto error_alloc;
 	}
 	s->s_fs_info = sbi;
 	/* Set default values for options: non-aggressive tails, RO on errors */
@@ -1648,6 +1669,20 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	/* setup default block allocator options */
 	reiserfs_init_alloc_options(s);
 
+	mutex_init(&REISERFS_SB(s)->lock);
+	REISERFS_SB(s)->lock_depth = -1;
+
+	/*
+	 * This function is called with the bkl, which also was the old
+	 * locking used here.
+	 * do_journal_begin() will soon check if we hold the lock (ie: was the
+	 * bkl). This is likely because do_journal_begin() has several another
+	 * callers because at this time, it doesn't seem to be necessary to
+	 * protect against anything.
+	 * Anyway, let's be conservative and lock for now.
+	 */
+	reiserfs_write_lock(s);
+
 	jdev_name = NULL;
 	if (reiserfs_parse_options
 	    (s, (char *)data, &(sbi->s_mount_opt), &blocks, &jdev_name,
@@ -1871,9 +1906,13 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	init_waitqueue_head(&(sbi->s_wait));
 	spin_lock_init(&sbi->bitmap_lock);
 
+	reiserfs_write_unlock(s);
+
 	return (0);
 
 error:
+	reiserfs_write_unlock(s);
+error_alloc:
 	if (jinit_done) {	/* kill the commit thread, free journal ram */
 		journal_release_error(NULL, s);
 	}
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 2245c78..f6b7b7b 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -52,11 +52,13 @@
 #define REISERFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
 #define REISERFS_IOC32_SETVERSION	FS_IOC32_SETVERSION
 
-/* Locking primitives */
-/* Right now we are still falling back to (un)lock_kernel, but eventually that
-   would evolve into real per-fs locks */
-#define reiserfs_write_lock( sb ) lock_kernel()
-#define reiserfs_write_unlock( sb ) unlock_kernel()
+/*
+ * Locking primitives. The write lock is a per superblock
+ * special mutex that has properties close to the Big Kernel Lock
+ * which was used in the previous locking scheme.
+ */
+void reiserfs_write_lock(struct super_block *s);
+void reiserfs_write_unlock(struct super_block *s);
 
 struct fid;
 
diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 5621d87..cec8319 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -7,6 +7,8 @@
 #ifdef __KERNEL__
 #include <linux/workqueue.h>
 #include <linux/rwsem.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
 #endif
 
 typedef enum {
@@ -355,6 +357,13 @@ struct reiserfs_sb_info {
 	struct reiserfs_journal *s_journal;	/* pointer to journal information */
 	unsigned short s_mount_state;	/* reiserfs state (valid, invalid) */
 
+	/* Serialize writers access, replace the old bkl */
+	struct mutex lock;
+	/* Owner of the lock (can be recursive) */
+	struct task_struct *lock_owner;
+	/* Depth of the lock, start from -1 like the bkl */
+	int lock_depth;
+
 	/* Comment? -Hans */
 	void (*end_io_handler) (struct buffer_head *, int);
 	hashf_t s_hash_function;	/* pointer to function which is used
-- 
1.6.1

