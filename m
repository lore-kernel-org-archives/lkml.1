Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZL3UnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZL3UnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZL3UnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:43:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44298 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZL3Umi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KURIXBt6r0xP54GGrRAFzzsYiDZ+ALNDptp3AVepcS6wbBxRG07mUgYkbzyQ6GiP3C
         N9jlgg9WdWQNemZFRt8BNWLWAPHDC+f7KNdf5fDYgO5Y1oTJ3cusd/X5QQBsYM+151IE
         AcZQwYEdhjDQYf3FWvr4F9MHZtb1uvD55bL/M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH 4/5] reiserfs: Safely acquire i_mutex from reiserfs_for_each_xattr
Date: Wed, 30 Dec 2009 21:42:26 +0100
Message-Id: <1262205747-9208-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relax the reiserfs lock before taking the inode mutex from
reiserfs_for_each_xattr() to avoid the usual bad dependencies:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-atom #179
-------------------------------------------------------
rm/3242 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#4/3){+.+.+.}, at: [<c11428ef>] reiserfs_for_each_xattr+0x23f/0x290

but task is already holding lock:
 (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1143389>] reiserfs_write_lock+0x29/0x40

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c105ea7f>] __lock_acquire+0x11ff/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c1401aab>] mutex_lock_nested+0x5b/0x340
       [<c1143339>] reiserfs_write_lock_once+0x29/0x50
       [<c1117022>] reiserfs_lookup+0x62/0x140
       [<c10bd85f>] __lookup_hash+0xef/0x110
       [<c10bf21d>] lookup_one_len+0x8d/0xc0
       [<c1141e3a>] open_xa_dir+0xea/0x1b0
       [<c1142720>] reiserfs_for_each_xattr+0x70/0x290
       [<c11429ba>] reiserfs_delete_xattrs+0x1a/0x60
       [<c111ea2f>] reiserfs_delete_inode+0x9f/0x150
       [<c10c9c32>] generic_delete_inode+0xa2/0x170
       [<c10c9d4f>] generic_drop_inode+0x4f/0x70
       [<c10c8b07>] iput+0x47/0x50
       [<c10c0965>] do_unlinkat+0xd5/0x160
       [<c10c0b13>] sys_unlinkat+0x23/0x40
       [<c1002ec4>] sysenter_do_call+0x12/0x32

-> #0 (&sb->s_type->i_mutex_key#4/3){+.+.+.}:
       [<c105f176>] __lock_acquire+0x18f6/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c1401aab>] mutex_lock_nested+0x5b/0x340
       [<c11428ef>] reiserfs_for_each_xattr+0x23f/0x290
       [<c11429ba>] reiserfs_delete_xattrs+0x1a/0x60
       [<c111ea2f>] reiserfs_delete_inode+0x9f/0x150
       [<c10c9c32>] generic_delete_inode+0xa2/0x170
       [<c10c9d4f>] generic_drop_inode+0x4f/0x70
       [<c10c8b07>] iput+0x47/0x50
       [<c10c0965>] do_unlinkat+0xd5/0x160
       [<c10c0b13>] sys_unlinkat+0x23/0x40
       [<c1002ec4>] sysenter_do_call+0x12/0x32

other info that might help us debug this:

1 lock held by rm/3242:
 #0:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1143389>] reiserfs_write_lock+0x29/0x40

stack backtrace:
Pid: 3242, comm: rm Not tainted 2.6.32-atom #179
Call Trace:
 [<c13ffa13>] ? printk+0x18/0x1a
 [<c105d33a>] print_circular_bug+0xca/0xd0
 [<c105f176>] __lock_acquire+0x18f6/0x19e0
 [<c105c932>] ? mark_held_locks+0x62/0x80
 [<c105cc3b>] ? trace_hardirqs_on+0xb/0x10
 [<c1401098>] ? mutex_unlock+0x8/0x10
 [<c105f2c8>] lock_acquire+0x68/0x90
 [<c11428ef>] ? reiserfs_for_each_xattr+0x23f/0x290
 [<c11428ef>] ? reiserfs_for_each_xattr+0x23f/0x290
 [<c1401aab>] mutex_lock_nested+0x5b/0x340
 [<c11428ef>] ? reiserfs_for_each_xattr+0x23f/0x290
 [<c11428ef>] reiserfs_for_each_xattr+0x23f/0x290
 [<c1143180>] ? delete_one_xattr+0x0/0x100
 [<c11429ba>] reiserfs_delete_xattrs+0x1a/0x60
 [<c1143339>] ? reiserfs_write_lock_once+0x29/0x50
 [<c111ea2f>] reiserfs_delete_inode+0x9f/0x150
 [<c11b0d4f>] ? _atomic_dec_and_lock+0x4f/0x70
 [<c111e990>] ? reiserfs_delete_inode+0x0/0x150
 [<c10c9c32>] generic_delete_inode+0xa2/0x170
 [<c10c9d4f>] generic_drop_inode+0x4f/0x70
 [<c10c8b07>] iput+0x47/0x50
 [<c10c0965>] do_unlinkat+0xd5/0x160
 [<c1401098>] ? mutex_unlock+0x8/0x10
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
 fs/reiserfs/xattr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 8b9631d..bfdac66 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -289,8 +289,9 @@ static int reiserfs_for_each_xattr(struct inode *inode,
 		err = journal_begin(&th, inode->i_sb, blocks);
 		if (!err) {
 			int jerror;
-			mutex_lock_nested(&dir->d_parent->d_inode->i_mutex,
-					  I_MUTEX_XATTR);
+			reiserfs_mutex_lock_nested_safe(
+					  &dir->d_parent->d_inode->i_mutex,
+					  I_MUTEX_XATTR, inode->i_sb);
 			err = action(dir, data);
 			jerror = journal_end(&th, inode->i_sb, blocks);
 			mutex_unlock(&dir->d_parent->d_inode->i_mutex);
-- 
1.6.2.3

