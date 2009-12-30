Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZL3Umn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZL3Umn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZL3Umj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:42:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54067 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZL3Umg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=anfX7v4x3Cd9x5u8DhJSS7+mMTlJ5IQaiGd6y+wwxyNEN1H8WBN9u+Moupo7cH/zl4
         Sfl7C/zPLb1osocYwJhitlTQW7eIcD6xK4p5qNhNlgVit6fuCG35yliqjSWKJVWLdrWK
         Kro5IxGcjGdL9SrhSqyFwD9DCinDVFhTebX2s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH 3/5] reiserfs: Fix journal mutex <-> inode mutex lock inversion
Date: Wed, 30 Dec 2009 21:42:25 +0100
Message-Id: <1262205747-9208-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to relax the reiserfs lock before locking the inode mutex
from xattr_unlink(), otherwise we'll face the usual bad dependencies:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-atom #178
-------------------------------------------------------
rm/3202 is trying to acquire lock:
 (&journal->j_mutex){+.+...}, at: [<c113c234>] do_journal_begin_r+0x94/0x360

but task is already holding lock:
 (&sb->s_type->i_mutex_key#4/2){+.+...}, at: [<c1142a67>] xattr_unlink+0x57/0xb0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#4/2){+.+...}:
       [<c105ea7f>] __lock_acquire+0x11ff/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c1401a7b>] mutex_lock_nested+0x5b/0x340
       [<c1142a67>] xattr_unlink+0x57/0xb0
       [<c1143179>] delete_one_xattr+0x29/0x100
       [<c11427bb>] reiserfs_for_each_xattr+0x10b/0x290
       [<c11429ba>] reiserfs_delete_xattrs+0x1a/0x60
       [<c111ea2f>] reiserfs_delete_inode+0x9f/0x150
       [<c10c9c32>] generic_delete_inode+0xa2/0x170
       [<c10c9d4f>] generic_drop_inode+0x4f/0x70
       [<c10c8b07>] iput+0x47/0x50
       [<c10c0965>] do_unlinkat+0xd5/0x160
       [<c10c0b13>] sys_unlinkat+0x23/0x40
       [<c1002ec4>] sysenter_do_call+0x12/0x32

-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c105ea7f>] __lock_acquire+0x11ff/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c1401a7b>] mutex_lock_nested+0x5b/0x340
       [<c1143359>] reiserfs_write_lock+0x29/0x40
       [<c113c23c>] do_journal_begin_r+0x9c/0x360
       [<c113c680>] journal_begin+0x80/0x130
       [<c1127363>] reiserfs_remount+0x223/0x4e0
       [<c10b6dd6>] do_remount_sb+0xa6/0x140
       [<c10ce6a0>] do_mount+0x560/0x750
       [<c10ce914>] sys_mount+0x84/0xb0
       [<c1002ec4>] sysenter_do_call+0x12/0x32

-> #0 (&journal->j_mutex){+.+...}:
       [<c105f176>] __lock_acquire+0x18f6/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c1401a7b>] mutex_lock_nested+0x5b/0x340
       [<c113c234>] do_journal_begin_r+0x94/0x360
       [<c113c680>] journal_begin+0x80/0x130
       [<c1116d63>] reiserfs_unlink+0x83/0x2e0
       [<c1142a74>] xattr_unlink+0x64/0xb0
       [<c1143179>] delete_one_xattr+0x29/0x100
       [<c11427bb>] reiserfs_for_each_xattr+0x10b/0x290
       [<c11429ba>] reiserfs_delete_xattrs+0x1a/0x60
       [<c111ea2f>] reiserfs_delete_inode+0x9f/0x150
       [<c10c9c32>] generic_delete_inode+0xa2/0x170
       [<c10c9d4f>] generic_drop_inode+0x4f/0x70
       [<c10c8b07>] iput+0x47/0x50
       [<c10c0965>] do_unlinkat+0xd5/0x160
       [<c10c0b13>] sys_unlinkat+0x23/0x40
       [<c1002ec4>] sysenter_do_call+0x12/0x32

other info that might help us debug this:

2 locks held by rm/3202:
 #0:  (&sb->s_type->i_mutex_key#4/3){+.+.+.}, at: [<c114274b>] reiserfs_for_each_xattr+0x9b/0x290
 #1:  (&sb->s_type->i_mutex_key#4/2){+.+...}, at: [<c1142a67>] xattr_unlink+0x57/0xb0

stack backtrace:
Pid: 3202, comm: rm Not tainted 2.6.32-atom #178
Call Trace:
 [<c13ff9e3>] ? printk+0x18/0x1a
 [<c105d33a>] print_circular_bug+0xca/0xd0
 [<c105f176>] __lock_acquire+0x18f6/0x19e0
 [<c1142a67>] ? xattr_unlink+0x57/0xb0
 [<c105f2c8>] lock_acquire+0x68/0x90
 [<c113c234>] ? do_journal_begin_r+0x94/0x360
 [<c113c234>] ? do_journal_begin_r+0x94/0x360
 [<c1401a7b>] mutex_lock_nested+0x5b/0x340
 [<c113c234>] ? do_journal_begin_r+0x94/0x360
 [<c113c234>] do_journal_begin_r+0x94/0x360
 [<c10411b6>] ? run_timer_softirq+0x1a6/0x220
 [<c103cb00>] ? __do_softirq+0x50/0x140
 [<c113c680>] journal_begin+0x80/0x130
 [<c103cba2>] ? __do_softirq+0xf2/0x140
 [<c104f72f>] ? hrtimer_interrupt+0xdf/0x220
 [<c1116d63>] reiserfs_unlink+0x83/0x2e0
 [<c105c932>] ? mark_held_locks+0x62/0x80
 [<c11b8d08>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002fd8>] ? restore_all_notrace+0x0/0x18
 [<c1142a67>] ? xattr_unlink+0x57/0xb0
 [<c1142a74>] xattr_unlink+0x64/0xb0
 [<c1143179>] delete_one_xattr+0x29/0x100
 [<c11427bb>] reiserfs_for_each_xattr+0x10b/0x290
 [<c1143150>] ? delete_one_xattr+0x0/0x100
 [<c1401cb9>] ? mutex_lock_nested+0x299/0x340
 [<c11429ba>] reiserfs_delete_xattrs+0x1a/0x60
 [<c1143309>] ? reiserfs_write_lock_once+0x29/0x50
 [<c111ea2f>] reiserfs_delete_inode+0x9f/0x150
 [<c11b0d1f>] ? _atomic_dec_and_lock+0x4f/0x70
 [<c111e990>] ? reiserfs_delete_inode+0x0/0x150
 [<c10c9c32>] generic_delete_inode+0xa2/0x170
 [<c10c9d4f>] generic_drop_inode+0x4f/0x70
 [<c10c8b07>] iput+0x47/0x50
 [<c10c0965>] do_unlinkat+0xd5/0x160
 [<c1401068>] ? mutex_unlock+0x8/0x10
 [<c10c3e0d>] ? vfs_readdir+0x7d/0xb0
 [<c10c3af0>] ? filldir64+0x0/0xf0
 [<c1002ef3>] ? sysenter_exit+0xf/0x16
 [<c105cbe4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c10c0b13>] sys_unlinkat+0x23/0x40
 [<c1002ec4>] sysenter_do_call+0x12/0x32

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christian Kujau <lists@nerdbynature.de>
---
 fs/reiserfs/xattr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 78a3f24..8b9631d 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -82,7 +82,8 @@ static int xattr_unlink(struct inode *dir, struct dentry *dentry)
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
 	vfs_dq_init(dir);
 
-	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+	reiserfs_mutex_lock_nested_safe(&dentry->d_inode->i_mutex,
+					I_MUTEX_CHILD, dir->i_sb);
 	error = dir->i_op->unlink(dir, dentry);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-- 
1.6.2.3

