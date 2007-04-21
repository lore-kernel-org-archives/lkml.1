Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbXDUPqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbXDUPqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXDUPqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:46:11 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:11044 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751205AbXDUPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:46:09 -0400
Subject: [RFC][PATCH] reiserfs vs BKL
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>, reiserfs-list@namesys.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Nikita Danilov <nikita@clusterfs.com>, Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 17:46:04 +0200
Message-Id: <1177170364.7316.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Obviously nobody still uses reiserfs; or at least not with
PREEMPT_BKL=n.

We seem to have grown all kinds of scheduling assumptions all over that
code. A excerpt from my bootlog when I tried:


 | preempt count: 00000001 ]
 | 1-level deep critical section nesting:
 ----------------------------------------
 .. [_spin_lock+16/112] .... _spin_lock+0x10/0x70
 .....[__rcu_process_callbacks+397/432] ..   ( <= __rcu_process_callbacks+0x18d/0x1b0)

  [show_trace_log_lvl+33/80] show_trace_log_lvl+0x21/0x50
  [show_trace+18/32] show_trace+0x12/0x20
  [dump_stack+22/32] dump_stack+0x16/0x20
  [schedule+1903/2096] schedule+0x76f/0x830
  [io_schedule+34/48] io_schedule+0x22/0x30
  [sync_buffer+53/64] sync_buffer+0x35/0x40
  [__wait_on_bit+69/112] __wait_on_bit+0x45/0x70
  [out_of_line_wait_on_bit+109/128] out_of_line_wait_on_bit+0x6d/0x80
  [__wait_on_buffer+39/48] __wait_on_buffer+0x27/0x30
  [pg0+944846854/1069073408] search_by_key+0x156/0x11d0 [reiserfs]
  [pg0+944764484/1069073408] reiserfs_read_locked_inode+0x64/0x550 [reiserfs]
  [pg0+944765867/1069073408] reiserfs_iget+0x7b/0x90 [reiserfs]
  [pg0+944752186/1069073408] reiserfs_lookup+0xca/0x130 [reiserfs]
  [do_lookup+305/368] do_lookup+0x131/0x170
  [__link_path_walk+2077/3600] __link_path_walk+0x81d/0xe10
  [link_path_walk+70/208] link_path_walk+0x46/0xd0
  [do_path_lookup+139/464] do_path_lookup+0x8b/0x1d0
  [__path_lookup_intent_open+74/144] __path_lookup_intent_open+0x4a/0x90
  [path_lookup_open+33/48] path_lookup_open+0x21/0x30
  [open_namei+98/1568] open_namei+0x62/0x620
  [do_filp_open+44/80] do_filp_open+0x2c/0x50
  [do_sys_open+71/224] do_sys_open+0x47/0xe0
  [sys_open+28/32] sys_open+0x1c/0x20
  [sysenter_past_esp+106/149] sysenter_past_esp+0x6a/0x95
  =======================


 ---------------------------
 | preempt count: 00000001 ]
 | 1-level deep critical section nesting:
 ----------------------------------------
 .. [lock_kernel+28/176] .... lock_kernel+0x1c/0xb0
 .....[pg0+944752069/1069073408] ..   ( <= reiserfs_lookup+0x55/0x130 [reiserfs])

  [show_trace_log_lvl+33/80] show_trace_log_lvl+0x21/0x50
  [show_trace+18/32] show_trace+0x12/0x20
  [dump_stack+22/32] dump_stack+0x16/0x20
  [schedule+1903/2096] schedule+0x76f/0x830
  [__cond_resched+18/48] __cond_resched+0x12/0x30
  [cond_resched+42/64] cond_resched+0x2a/0x40
  [pg0+944846892/1069073408] search_by_key+0x17c/0x11d0 [reiserfs]
  [pg0+944766152/1069073408] reiserfs_update_sd_size+0x108/0x320 [reiserfs]
  [pg0+944811796/1069073408] reiserfs_dirty_inode+0x74/0xa0 [reiserfs]
  [__mark_inode_dirty+48/400] __mark_inode_dirty+0x30/0x190
  [touch_atime+142/240] touch_atime+0x8e/0xf0
  [__link_path_walk+2980/3600] __link_path_walk+0xba4/0xe10
  [link_path_walk+70/208] link_path_walk+0x46/0xd0
  [do_path_lookup+139/464] do_path_lookup+0x8b/0x1d0
  [__path_lookup_intent_open+74/144] __path_lookup_intent_open+0x4a/0x90
  [path_lookup_open+33/48] path_lookup_open+0x21/0x30
  [open_exec+39/176] open_exec+0x27/0xb0
  [do_execve+56/544] do_execve+0x38/0x220
  [sys_execve+46/144] sys_execve+0x2e/0x90
  [sysenter_past_esp+106/149] sysenter_past_esp+0x6a/0x95
  =======================



And the sole reason I tried that was because I managed to get >1 second
(yes _second_) latencies due to BKL priority inversion.

Since this is not really a workable situation I propose we do something
about it, below my attempt. However, since I know absolutely nothing
about reiserfs, it might well be very wrong and will eat all your data
(babies and favourite pets too while we're at it).

---
Replace all the lock_kernel() instances with reiserfs_write_lock(sb),
and make that use an actual per super-block mutex instead of
lock_kernel().

This should make reiserfs safe from PREEMPT_BKL=n, since it seems to
rely on being able to schedule. Also, it removes the dependency on the
BKL, and thereby is not prone to cause prio inversion with remaining BKL
users (notably tty).

Compile tested only, since I didn't dare boot it.

NOT-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/reiserfs/inode.c            |    4 ++--
 fs/reiserfs/journal.c          |   12 ++++++------
 fs/reiserfs/super.c            |    1 +
 fs/reiserfs/xattr.c            |   16 ++++++++--------
 include/linux/reiserfs_fs.h    |    4 ++--
 include/linux/reiserfs_fs_sb.h |    2 ++
 6 files changed, 21 insertions(+), 18 deletions(-)

Index: linux-2.6-twins/fs/reiserfs/inode.c
===================================================================
--- linux-2.6-twins.orig/fs/reiserfs/inode.c
+++ linux-2.6-twins/fs/reiserfs/inode.c
@@ -485,10 +485,10 @@ static int reiserfs_get_blocks_direct_io
 	   disappeared */
 	if (REISERFS_I(inode)->i_flags & i_pack_on_close_mask) {
 		int err;
-		lock_kernel();
+		reiserfs_write_lock(inode->i_sb);
 		err = reiserfs_commit_for_inode(inode);
 		REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
-		unlock_kernel();
+		reiserfs_write_unlock(inode->i_sb);
 		if (err < 0)
 			ret = err;
 	}
Index: linux-2.6-twins/fs/reiserfs/journal.c
===================================================================
--- linux-2.6-twins.orig/fs/reiserfs/journal.c
+++ linux-2.6-twins/fs/reiserfs/journal.c
@@ -1035,12 +1035,12 @@ static int flush_commit_list(struct supe
 
 	if (!list_empty(&jl->j_bh_list)) {
 		int ret;
-		unlock_kernel();
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
@@ -3456,14 +3456,14 @@ static void flush_async_commits(struct w
 	struct reiserfs_journal_list *jl;
 	struct list_head *entry;
 
-	lock_kernel();
+	reiserfs_write_lock(p_s_sb);
 	if (!list_empty(&journal->j_journal_list)) {
 		/* last entry is the youngest, commit it and you get everything */
 		entry = journal->j_journal_list.prev;
 		jl = JOURNAL_LIST_ENTRY(entry);
 		flush_commit_list(p_s_sb, jl, 1);
 	}
-	unlock_kernel();
+	reiserfs_write_unlock(p_s_sb);
 }
 
 /*
@@ -4155,10 +4155,10 @@ static int do_journal_end(struct reiserf
 	 * is lost.
 	 */
 	if (!list_empty(&jl->j_tail_bh_list)) {
-		unlock_kernel();
+		reiserfs_write_unlock(p_s_sb);
 		write_ordered_buffers(&journal->j_dirty_buffers_lock,
 				      journal, jl, &jl->j_tail_bh_list);
-		lock_kernel();
+		reiserfs_write_lock(p_s_sb);
 	}
 	BUG_ON(!list_empty(&jl->j_tail_bh_list));
 	up(&jl->j_commit_lock);
Index: linux-2.6-twins/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6-twins.orig/fs/reiserfs/xattr.c
+++ linux-2.6-twins/fs/reiserfs/xattr.c
@@ -428,9 +428,9 @@ int xattr_readdir(struct file *file, fil
 //        down(&inode->i_zombie);
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		lock_kernel();
+		reiserfs_write_lock(inode->i_sb);
 		res = __xattr_readdir(file, buf, filler);
-		unlock_kernel();
+		reiserfs_write_unlock(inode->i_sb);
 	}
 //        up(&inode->i_zombie);
 	mutex_unlock(&inode->i_mutex);
@@ -812,10 +812,10 @@ int reiserfs_delete_xattrs(struct inode 
 		goto out;
 	}
 
-	lock_kernel();
+	reiserfs_write_lock(inode->i_sb);
 	err = xattr_readdir(fp, reiserfs_delete_xattrs_filler, dir);
 	if (err) {
-		unlock_kernel();
+		reiserfs_write_unlock(inode->i_sb);
 		goto out_dir;
 	}
 
@@ -830,7 +830,7 @@ int reiserfs_delete_xattrs(struct inode 
 		reiserfs_warning(inode->i_sb,
 				 "Couldn't remove all entries in directory");
 	}
-	unlock_kernel();
+	reiserfs_write_unlock(inode->i_sb);
 
       out_dir:
 	fput(fp);
@@ -906,7 +906,7 @@ int reiserfs_chown_xattrs(struct inode *
 		goto out;
 	}
 
-	lock_kernel();
+	reiserfs_write_lock(inode->i_sb);
 
 	attrs->ia_valid &= (ATTR_UID | ATTR_GID | ATTR_CTIME);
 	buf.xadir = dir;
@@ -915,12 +915,12 @@ int reiserfs_chown_xattrs(struct inode *
 
 	err = xattr_readdir(fp, reiserfs_chown_xattrs_filler, &buf);
 	if (err) {
-		unlock_kernel();
+		reiserfs_write_unlock(inode->i_sb);
 		goto out_dir;
 	}
 
 	err = notify_change(dir, attrs);
-	unlock_kernel();
+	reiserfs_write_unlock(inode->i_sb);
 
       out_dir:
 	fput(fp);
Index: linux-2.6-twins/include/linux/reiserfs_fs.h
===================================================================
--- linux-2.6-twins.orig/include/linux/reiserfs_fs.h
+++ linux-2.6-twins/include/linux/reiserfs_fs.h
@@ -2187,8 +2187,8 @@ long reiserfs_compat_ioctl(struct file *
 /* Locking primitives */
 /* Right now we are still falling back to (un)lock_kernel, but eventually that
    would evolve into real per-fs locks */
-#define reiserfs_write_lock( sb ) lock_kernel()
-#define reiserfs_write_unlock( sb ) unlock_kernel()
+#define reiserfs_write_lock( sb ) mutex_lock(&REISERFS_SB(sb)->s_mutex)
+#define reiserfs_write_unlock( sb ) mutex_unlock(&REISERFS_SB(sb)->s_mutex)
 
 /* xattr stuff */
 #define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
Index: linux-2.6-twins/include/linux/reiserfs_fs_sb.h
===================================================================
--- linux-2.6-twins.orig/include/linux/reiserfs_fs_sb.h
+++ linux-2.6-twins/include/linux/reiserfs_fs_sb.h
@@ -7,6 +7,7 @@
 #ifdef __KERNEL__
 #include <linux/workqueue.h>
 #include <linux/rwsem.h>
+#include <linux/mutex.h>
 #endif
 
 typedef enum {
@@ -346,6 +347,7 @@ typedef struct reiserfs_proc_info_data {
 
 /* reiserfs union of in-core super block data */
 struct reiserfs_sb_info {
+	struct mutex s_mutex;
 	struct buffer_head *s_sbh;	/* Buffer containing the super block */
 	/* both the comment and the choice of
 	   name are unclear for s_rs -Hans */
Index: linux-2.6-twins/fs/reiserfs/super.c
===================================================================
--- linux-2.6-twins.orig/fs/reiserfs/super.c
+++ linux-2.6-twins/fs/reiserfs/super.c
@@ -1555,6 +1555,7 @@ static int reiserfs_fill_super(struct su
 		goto error;
 	}
 	s->s_fs_info = sbi;
+	mutex_init(&REISERFS_SB(s)->s_mutex);
 	/* Set default values for options: non-aggressive tails, RO on errors */
 	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_SMALLTAIL);
 	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_ERROR_RO);


