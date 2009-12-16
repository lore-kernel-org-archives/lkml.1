Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbZLPWfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbZLPWfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762871AbZLPWfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:35:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:30503 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbZLPWf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:35:28 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] reiserfs: Fix reiserfs lock <-> inode mutex dependency inversion
Date: Wed, 16 Dec 2009 23:35:24 +0100
Message-Id: <1261002924-5218-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <a4423d670912141211q3e63011ftfd526ec541b09d44@mail.gmail.com>
References: <a4423d670912141211q3e63011ftfd526ec541b09d44@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reiserfs lock -> inode mutex dependency gets inverted when we
relax the lock while walking to the tree.

To fix this, use a specialized version of reiserfs_mutex_lock_safe
that takes care of mutex subclasses. Then we can grab the inode
mutex with I_MUTEX_XATTR subclass without any reiserfs lock
dependency.

This fixes the following report:

[ INFO: possible circular locking dependency detected ]
2.6.32-06793-gf405425-dirty #2
-------------------------------------------------------
mv/18566 is trying to acquire lock:
 (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110708>] reiserfs_write_lock+0x28=
/0x40

but task is already holding lock:
 (&sb->s_type->i_mutex_key#5/3){+.+.+.}, at: [<c111033c>]
reiserfs_for_each_xattr+0x10c/0x380

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&sb->s_type->i_mutex_key#5/3){+.+.+.}:
       [<c104f723>] validate_chain+0xa23/0xf70
       [<c1050155>] __lock_acquire+0x4e5/0xa70
       [<c105075a>] lock_acquire+0x7a/0xa0
       [<c134c76f>] mutex_lock_nested+0x5f/0x2b0
       [<c11102b4>] reiserfs_for_each_xattr+0x84/0x380
       [<c1110615>] reiserfs_delete_xattrs+0x15/0x50
       [<c10ef57f>] reiserfs_delete_inode+0x8f/0x140
       [<c10a565c>] generic_delete_inode+0x9c/0x150
       [<c10a574d>] generic_drop_inode+0x3d/0x60
       [<c10a4667>] iput+0x47/0x50
       [<c109cc0b>] do_unlinkat+0xdb/0x160
       [<c109cca0>] sys_unlink+0x10/0x20
       [<c1002c50>] sysenter_do_call+0x12/0x36

-> #0 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c104fc68>] validate_chain+0xf68/0xf70
       [<c1050155>] __lock_acquire+0x4e5/0xa70
       [<c105075a>] lock_acquire+0x7a/0xa0
       [<c134c76f>] mutex_lock_nested+0x5f/0x2b0
       [<c1110708>] reiserfs_write_lock+0x28/0x40
       [<c1103d6b>] search_by_key+0x1f7b/0x21b0
       [<c10e73ef>] search_by_entry_key+0x1f/0x3b0
       [<c10e77f7>] reiserfs_find_entry+0x77/0x400
       [<c10e81e5>] reiserfs_lookup+0x85/0x130
       [<c109a144>] __lookup_hash+0xb4/0x110
       [<c109b763>] lookup_one_len+0xb3/0x100
       [<c1110350>] reiserfs_for_each_xattr+0x120/0x380
       [<c1110615>] reiserfs_delete_xattrs+0x15/0x50
       [<c10ef57f>] reiserfs_delete_inode+0x8f/0x140
       [<c10a565c>] generic_delete_inode+0x9c/0x150
       [<c10a574d>] generic_drop_inode+0x3d/0x60
       [<c10a4667>] iput+0x47/0x50
       [<c10a1c4f>] dentry_iput+0x6f/0xf0
       [<c10a1d74>] d_kill+0x24/0x50
       [<c10a396b>] dput+0x5b/0x120
       [<c109ca89>] sys_renameat+0x1b9/0x230
       [<c109cb28>] sys_rename+0x28/0x30
       [<c1002c50>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

2 locks held by mv/18566:
 #0:  (&sb->s_type->i_mutex_key#5/1){+.+.+.}, at: [<c109b6ac>]
lock_rename+0xcc/0xd0
 #1:  (&sb->s_type->i_mutex_key#5/3){+.+.+.}, at: [<c111033c>]
reiserfs_for_each_xattr+0x10c/0x380

stack backtrace:
Pid: 18566, comm: mv Tainted: G         C 2.6.32-06793-gf405425-dirty #2
Call Trace:
 [<c134b252>] ? printk+0x18/0x1e
 [<c104e790>] print_circular_bug+0xc0/0xd0
 [<c104fc68>] validate_chain+0xf68/0xf70
 [<c104c8cb>] ? trace_hardirqs_off+0xb/0x10
 [<c1050155>] __lock_acquire+0x4e5/0xa70
 [<c105075a>] lock_acquire+0x7a/0xa0
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c134c76f>] mutex_lock_nested+0x5f/0x2b0
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c134b60a>] ? schedule+0x27a/0x440
 [<c1110708>] reiserfs_write_lock+0x28/0x40
 [<c1103d6b>] search_by_key+0x1f7b/0x21b0
 [<c1050176>] ? __lock_acquire+0x506/0xa70
 [<c1051267>] ? lock_release_non_nested+0x1e7/0x340
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c104e354>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e3ab>] ? trace_hardirqs_on+0xb/0x10
 [<c1042a55>] ? T.316+0x15/0x1a0
 [<c1042d2d>] ? sched_clock_cpu+0x9d/0x100
 [<c10e73ef>] search_by_entry_key+0x1f/0x3b0
 [<c134bf2a>] ? __mutex_unlock_slowpath+0x9a/0x120
 [<c104e354>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c10e77f7>] reiserfs_find_entry+0x77/0x400
 [<c10e81e5>] reiserfs_lookup+0x85/0x130
 [<c1042d2d>] ? sched_clock_cpu+0x9d/0x100
 [<c109a144>] __lookup_hash+0xb4/0x110
 [<c109b763>] lookup_one_len+0xb3/0x100
 [<c1110350>] reiserfs_for_each_xattr+0x120/0x380
 [<c110ffe0>] ? delete_one_xattr+0x0/0x1c0
 [<c1003342>] ? math_error+0x22/0x150
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c1110615>] reiserfs_delete_xattrs+0x15/0x50
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c10ef57f>] reiserfs_delete_inode+0x8f/0x140
 [<c10a561f>] ? generic_delete_inode+0x5f/0x150
 [<c10ef4f0>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a565c>] generic_delete_inode+0x9c/0x150
 [<c10a574d>] generic_drop_inode+0x3d/0x60
 [<c10a4667>] iput+0x47/0x50
 [<c10a1c4f>] dentry_iput+0x6f/0xf0
 [<c10a1d74>] d_kill+0x24/0x50
 [<c10a396b>] dput+0x5b/0x120
 [<c109ca89>] sys_renameat+0x1b9/0x230
 [<c1042d2d>] ? sched_clock_cpu+0x9d/0x100
 [<c104c8cb>] ? trace_hardirqs_off+0xb/0x10
 [<c1042dde>] ? cpu_clock+0x4e/0x60
 [<c1350825>] ? do_page_fault+0x155/0x370
 [<c1041816>] ? up_read+0x16/0x30
 [<c1350825>] ? do_page_fault+0x155/0x370
 [<c109cb28>] sys_rename+0x28/0x30
 [<c1002c50>] sysenter_do_call+0x12/0x36

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/reiserfs/xattr.c         |    3 ++-
 include/linux/reiserfs_fs.h |    9 +++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 58aa8e7..8891cd8 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -243,7 +243,8 @@ static int reiserfs_for_each_xattr(struct inode *inode,
 		goto out_dir;
 	}
 
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_XATTR);
+	reiserfs_mutex_lock_nested_safe(&dir->d_inode->i_mutex, I_MUTEX_XATTR,
+					inode->i_sb);
 	buf.xadir = dir;
 	err = reiserfs_readdir_dentry(dir, &buf, fill_with_dentries, &pos);
 	while ((err == 0 || err == -ENOSPC) && buf.count) {
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index a05b4a2..4351b49 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -97,6 +97,15 @@ static inline void reiserfs_mutex_lock_safe(struct mutex *m,
 	reiserfs_write_lock(s);
 }
 
+static inline void
+reiserfs_mutex_lock_nested_safe(struct mutex *m, unsigned int subclass,
+			       struct super_block *s)
+{
+	reiserfs_write_unlock(s);
+	mutex_lock_nested(m, subclass);
+	reiserfs_write_lock(s);
+}
+
 /*
  * When we schedule, we usually want to also release the write lock,
  * according to the previous bkl based locking scheme of reiserfs.
-- 
1.6.2.3

