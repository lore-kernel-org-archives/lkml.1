Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbZL3FWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbZL3FWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZL3FVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:21:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50412 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZL3FVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Jx/He/DAfiPfHLMDDl1TODzbb/LSqrpd4nGcKSbZzGY0du8XrCFpIMi3VbGgK61ltX
         7lbv33lHhHS3OdnPeX+duM9NteqNaAaCTPg4T+2OSjtcgsVgLRK2Y7T1G9pY0193mBC2
         O089/MnkT4eq/uIHJ+7drm7mXSLPLNxvuI4/w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/4] reiserfs: Fix reiserfs lock <-> i_mutex dependency inversion on xattr
Date: Wed, 30 Dec 2009 06:21:30 +0100
Message-Id: <1262150491-9983-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While deleting the xattrs of an inode, we hold the reiserfs lock
and grab the inode->i_mutex of the targeted inode and the root
private xattr directory.

Later on, we may relax the reiserfs lock for various reasons, this
creates inverted dependencies.

We can remove the reiserfs lock -> i_mutex dependency by relaxing
the former before calling open_xa_dir(). This is fine because the
lookup and creation of xattr private directories done in
open_xa_dir() are covered by the targeted inode mutexes. And deeper
operations in the tree are still done under the write lock.

This fixes the following lockdep report:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-atom #173
-------------------------------------------------------
cp/3204 is trying to acquire lock:
 (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c11432b9>] reiserfs_write_lock_once+0x29/0x50

but task is already holding lock:
 (&sb->s_type->i_mutex_key#4/3){+.+.+.}, at: [<c1141e18>] open_xa_dir+0xd8/0x1b0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&sb->s_type->i_mutex_key#4/3){+.+.+.}:
       [<c105ea7f>] __lock_acquire+0x11ff/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c1401a2b>] mutex_lock_nested+0x5b/0x340
       [<c1141d83>] open_xa_dir+0x43/0x1b0
       [<c1142722>] reiserfs_for_each_xattr+0x62/0x260
       [<c114299a>] reiserfs_delete_xattrs+0x1a/0x60
       [<c111ea1f>] reiserfs_delete_inode+0x9f/0x150
       [<c10c9c32>] generic_delete_inode+0xa2/0x170
       [<c10c9d4f>] generic_drop_inode+0x4f/0x70
       [<c10c8b07>] iput+0x47/0x50
       [<c10c0965>] do_unlinkat+0xd5/0x160
       [<c10c0a00>] sys_unlink+0x10/0x20
       [<c1002ec4>] sysenter_do_call+0x12/0x32

-> #0 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c105f176>] __lock_acquire+0x18f6/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c1401a2b>] mutex_lock_nested+0x5b/0x340
       [<c11432b9>] reiserfs_write_lock_once+0x29/0x50
       [<c1117012>] reiserfs_lookup+0x62/0x140
       [<c10bd85f>] __lookup_hash+0xef/0x110
       [<c10bf21d>] lookup_one_len+0x8d/0xc0
       [<c1141e2a>] open_xa_dir+0xea/0x1b0
       [<c1141fe5>] xattr_lookup+0x15/0x160
       [<c1142476>] reiserfs_xattr_get+0x56/0x2a0
       [<c1144042>] reiserfs_get_acl+0xa2/0x360
       [<c114461a>] reiserfs_cache_default_acl+0x3a/0x160
       [<c111789c>] reiserfs_mkdir+0x6c/0x2c0
       [<c10bea96>] vfs_mkdir+0xd6/0x180
       [<c10c0c10>] sys_mkdirat+0xc0/0xd0
       [<c10c0c40>] sys_mkdir+0x20/0x30
       [<c1002ec4>] sysenter_do_call+0x12/0x32

other info that might help us debug this:

2 locks held by cp/3204:
 #0:  (&sb->s_type->i_mutex_key#4/1){+.+.+.}, at: [<c10bd8d6>] lookup_create+0x26/0xa0
 #1:  (&sb->s_type->i_mutex_key#4/3){+.+.+.}, at: [<c1141e18>] open_xa_dir+0xd8/0x1b0

stack backtrace:
Pid: 3204, comm: cp Not tainted 2.6.32-atom #173
Call Trace:
 [<c13ff993>] ? printk+0x18/0x1a
 [<c105d33a>] print_circular_bug+0xca/0xd0
 [<c105f176>] __lock_acquire+0x18f6/0x19e0
 [<c105d3aa>] ? check_usage+0x6a/0x460
 [<c105f2c8>] lock_acquire+0x68/0x90
 [<c11432b9>] ? reiserfs_write_lock_once+0x29/0x50
 [<c11432b9>] ? reiserfs_write_lock_once+0x29/0x50
 [<c1401a2b>] mutex_lock_nested+0x5b/0x340
 [<c11432b9>] ? reiserfs_write_lock_once+0x29/0x50
 [<c11432b9>] reiserfs_write_lock_once+0x29/0x50
 [<c1117012>] reiserfs_lookup+0x62/0x140
 [<c105ccca>] ? debug_check_no_locks_freed+0x8a/0x140
 [<c105cbe4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c10bd85f>] __lookup_hash+0xef/0x110
 [<c10bf21d>] lookup_one_len+0x8d/0xc0
 [<c1141e2a>] open_xa_dir+0xea/0x1b0
 [<c1141fe5>] xattr_lookup+0x15/0x160
 [<c1142476>] reiserfs_xattr_get+0x56/0x2a0
 [<c1144042>] reiserfs_get_acl+0xa2/0x360
 [<c10ca2e7>] ? new_inode+0x27/0xa0
 [<c114461a>] reiserfs_cache_default_acl+0x3a/0x160
 [<c1402eb7>] ? _spin_unlock+0x27/0x40
 [<c111789c>] reiserfs_mkdir+0x6c/0x2c0
 [<c10c7cb8>] ? __d_lookup+0x108/0x190
 [<c105c932>] ? mark_held_locks+0x62/0x80
 [<c1401c8d>] ? mutex_lock_nested+0x2bd/0x340
 [<c10bd17a>] ? generic_permission+0x1a/0xa0
 [<c11788fe>] ? security_inode_permission+0x1e/0x20
 [<c10bea96>] vfs_mkdir+0xd6/0x180
 [<c10c0c10>] sys_mkdirat+0xc0/0xd0
 [<c10505c6>] ? up_read+0x16/0x30
 [<c1002fd8>] ? restore_all_notrace+0x0/0x18
 [<c10c0c40>] sys_mkdir+0x20/0x30
 [<c1002ec4>] sysenter_do_call+0x12/0x32

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/xattr.c         |    9 +++++++--
 include/linux/reiserfs_fs.h |   10 ----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index a0e2e7a..c320c77 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -234,17 +234,22 @@ static int reiserfs_for_each_xattr(struct inode *inode,
 	if (IS_PRIVATE(inode) || get_inode_sd_version(inode) == STAT_DATA_V1)
 		return 0;
 
+	reiserfs_write_unlock(inode->i_sb);
 	dir = open_xa_dir(inode, XATTR_REPLACE);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
+		reiserfs_write_lock(inode->i_sb);
 		goto out;
 	} else if (!dir->d_inode) {
 		err = 0;
+		reiserfs_write_lock(inode->i_sb);
 		goto out_dir;
 	}
 
-	reiserfs_mutex_lock_nested_safe(&dir->d_inode->i_mutex, I_MUTEX_XATTR,
-					inode->i_sb);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_XATTR);
+
+	reiserfs_write_lock(inode->i_sb);
+
 	buf.xadir = dir;
 	err = reiserfs_readdir_dentry(dir, &buf, fill_with_dentries, &pos);
 	while ((err == 0 || err == -ENOSPC) && buf.count) {
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 793bf83..99db5ce 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -105,16 +105,6 @@ static inline void reiserfs_mutex_lock_safe(struct mutex *m,
 }
 
 static inline void
-reiserfs_mutex_lock_nested_safe(struct mutex *m, unsigned int subclass,
-			       struct super_block *s)
-{
-	reiserfs_lock_check_recursive(s);
-	reiserfs_write_unlock(s);
-	mutex_lock_nested(m, subclass);
-	reiserfs_write_lock(s);
-}
-
-static inline void
 reiserfs_down_read_safe(struct rw_semaphore *sem, struct super_block *s)
 {
 	reiserfs_lock_check_recursive(s);
-- 
1.6.2.3

