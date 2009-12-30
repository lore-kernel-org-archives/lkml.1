Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZL3UnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZL3UnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZL3Umg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:42:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54067 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbZL3Umd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vuFtt9wiGuevCSks10R1wxFRKP8GBk7ePlG9RiXMK+6pqpzeMLZiiLPBf0Ow56wLV6
         3zyawBYFZYMH/EhqDAYLQ9sIwRdiZgVq8BPnu/GsyVHvwC+KJDYr/9kXDIBwzwyc0ixl
         okqb/3A+KwhBvV7lk6SBqwEjtF4NAuRanZjX4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH 1/5] reiserfs: Relax lock before open xattr dir in reiserfs_xattr_set_handle()
Date: Wed, 30 Dec 2009 21:42:23 +0100
Message-Id: <1262205747-9208-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call xattr_lookup() from reiserfs_xattr_get(). We then hold
the reiserfs lock when we grab the i_mutex. But later, we may
relax the reiserfs lock, creating dependency inversion between
both locks.

The lookups and creation jobs ar already protected by the
inode mutex, so we can safely relax the reiserfs lock, dropping
the unwanted reiserfs lock -> i_mutex dependency, as shown
in the following lockdep report:

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
Cc: Christian Kujau <lists@nerdbynature.de>
---
 fs/reiserfs/xattr.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index c320c77..78a3f24 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -485,11 +485,16 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 	if (!buffer)
 		return lookup_and_delete_xattr(inode, name);
 
+	reiserfs_write_unlock(inode->i_sb);
 	dentry = xattr_lookup(inode, name, flags);
-	if (IS_ERR(dentry))
+	if (IS_ERR(dentry)) {
+		reiserfs_write_lock(inode->i_sb);
 		return PTR_ERR(dentry);
+	}
 
-	reiserfs_down_read_safe(&REISERFS_I(inode)->i_xattr_sem, inode->i_sb);
+	down_read(&REISERFS_I(inode)->i_xattr_sem);
+
+	reiserfs_write_lock(inode->i_sb);
 
 	xahash = xattr_hash(buffer, buffer_size);
 	while (buffer_pos < buffer_size || buffer_pos == 0) {
-- 
1.6.2.3

