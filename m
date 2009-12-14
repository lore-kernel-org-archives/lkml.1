Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZLNLBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZLNLBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZLNLA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:00:59 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48707 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZLNLA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JJQ1wptFuszKso/FvkpmDj+h2ziyW0v7MALEEskcLxEtyxUztm574Qaf1Xxp8GEWYu
         7ZDHT/NTckwBhBYWJr1WyKlQV3aXAILja8bH9fA7TxGJzH5VzYH4R8MAG9tPTaqVLsg4
         dXC0oRsqnw8hLZBiS9uu8CvCkVMq243AhUo+o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] reiserfs: Fix reiserfs lock and journal lock inversion dependency
Date: Mon, 14 Dec 2009 12:00:54 +0100
Message-Id: <1260788454-5683-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <a4423d670912121251l50f52791lc776a5c88434e39b@mail.gmail.com>
References: <a4423d670912121251l50f52791lc776a5c88434e39b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we were using the bkl, we didn't care about dependencies against
other locks, but the mutex conversion created new ones, which is why
we have reiserfs_mutex_lock_safe(), which unlocks the reiserfs lock
before acquiring another mutex.

But this trick actually fails if we have acquired the reiserfs lock
recursively, as we try to unlock it to acquire the new mutex without
inverted dependency, but we eventually only decrease its depth.

This happens in the case of a nested inode creation/deletion.
Say we have no space left on the device, we create an inode
and tak the lock but fail to create its entry, then we release the
inode using iput(), which calls reiserfs_delete_inode() that takes
the reiserfs lock recursively. The path eventually ends up in
journal_begin() where we try to take the journal safely but we
fail because of the reiserfs lock recursion:

[ INFO: possible circular locking dependency detected ]
2.6.32-06486-g053fe57 #2
-------------------------------------------------------
vi/23454 is trying to acquire lock:
 (&journal->j_mutex){+.+...}, at: [<c110dac4>] do_journal_begin_r+0x64/0x2f0

but task is already holding lock:
 (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c11106a8>] reiserfs_write_lock+0x28/0x40

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c104f8f3>] validate_chain+0xa23/0xf70
       [<c1050325>] __lock_acquire+0x4e5/0xa70
       [<c105092a>] lock_acquire+0x7a/0xa0
       [<c134c78f>] mutex_lock_nested+0x5f/0x2b0
       [<c11106a8>] reiserfs_write_lock+0x28/0x40
       [<c110dacb>] do_journal_begin_r+0x6b/0x2f0
       [<c110ddcf>] journal_begin+0x7f/0x120
       [<c10f76c2>] reiserfs_remount+0x212/0x4d0
       [<c1093997>] do_remount_sb+0x67/0x140
       [<c10a9ca6>] do_mount+0x436/0x6b0
       [<c10a9f86>] sys_mount+0x66/0xa0
       [<c1002c50>] sysenter_do_call+0x12/0x36

-> #0 (&journal->j_mutex){+.+...}:
       [<c104fe38>] validate_chain+0xf68/0xf70
       [<c1050325>] __lock_acquire+0x4e5/0xa70
       [<c105092a>] lock_acquire+0x7a/0xa0
       [<c134c78f>] mutex_lock_nested+0x5f/0x2b0
       [<c110dac4>] do_journal_begin_r+0x64/0x2f0
       [<c110ddcf>] journal_begin+0x7f/0x120
       [<c10ef52f>] reiserfs_delete_inode+0x9f/0x140
       [<c10a55fc>] generic_delete_inode+0x9c/0x150
       [<c10a56ed>] generic_drop_inode+0x3d/0x60
       [<c10a4607>] iput+0x47/0x50
       [<c10e915c>] reiserfs_create+0x16c/0x1c0
       [<c109a9c1>] vfs_create+0xc1/0x130
       [<c109dbec>] do_filp_open+0x81c/0x920
       [<c109004f>] do_sys_open+0x4f/0x110
       [<c1090179>] sys_open+0x29/0x40
       [<c1002c50>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

2 locks held by vi/23454:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109d64e>]
do_filp_open+0x27e/0x920
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c11106a8>]
reiserfs_write_lock+0x28/0x40

stack backtrace:
Pid: 23454, comm: vi Not tainted 2.6.32-06486-g053fe57 #2
Call Trace:
 [<c134b202>] ? printk+0x18/0x1e
 [<c104e960>] print_circular_bug+0xc0/0xd0
 [<c104fe38>] validate_chain+0xf68/0xf70
 [<c104ca9b>] ? trace_hardirqs_off+0xb/0x10
 [<c1050325>] __lock_acquire+0x4e5/0xa70
 [<c105092a>] lock_acquire+0x7a/0xa0
 [<c110dac4>] ? do_journal_begin_r+0x64/0x2f0
 [<c134c78f>] mutex_lock_nested+0x5f/0x2b0
 [<c110dac4>] ? do_journal_begin_r+0x64/0x2f0
 [<c110dac4>] ? do_journal_begin_r+0x64/0x2f0
 [<c110ff80>] ? delete_one_xattr+0x0/0x1c0
 [<c110dac4>] do_journal_begin_r+0x64/0x2f0
 [<c110ddcf>] journal_begin+0x7f/0x120
 [<c11105b5>] ? reiserfs_delete_xattrs+0x15/0x50
 [<c10ef52f>] reiserfs_delete_inode+0x9f/0x140
 [<c10a55bf>] ? generic_delete_inode+0x5f/0x150
 [<c10ef490>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a55fc>] generic_delete_inode+0x9c/0x150
 [<c10a56ed>] generic_drop_inode+0x3d/0x60
 [<c10a4607>] iput+0x47/0x50
 [<c10e915c>] reiserfs_create+0x16c/0x1c0
 [<c1099a5d>] ? inode_permission+0x7d/0xa0
 [<c109a9c1>] vfs_create+0xc1/0x130
 [<c10e8ff0>] ? reiserfs_create+0x0/0x1c0
 [<c109dbec>] do_filp_open+0x81c/0x920
 [<c104ca9b>] ? trace_hardirqs_off+0xb/0x10
 [<c134dc0d>] ? _spin_unlock+0x1d/0x20
 [<c10a6eea>] ? alloc_fd+0xba/0xf0
 [<c109004f>] do_sys_open+0x4f/0x110
 [<c1090179>] sys_open+0x29/0x40
 [<c1002c50>] sysenter_do_call+0x12/0x36

To fix this, use reiserfs_lock_once() from reiserfs_delete_inode()
which prevents from adding reiserfs lock recursion.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/reiserfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 3a28e77..bd615df 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -31,11 +31,12 @@ void reiserfs_delete_inode(struct inode *inode)
 	    JOURNAL_PER_BALANCE_CNT * 2 +
 	    2 * REISERFS_QUOTA_INIT_BLOCKS(inode->i_sb);
 	struct reiserfs_transaction_handle th;
+	int depth;
 	int err;
 
 	truncate_inode_pages(&inode->i_data, 0);
 
-	reiserfs_write_lock(inode->i_sb);
+	depth = reiserfs_write_lock_once(inode->i_sb);
 
 	/* The = 0 happens when we abort creating a new inode for some reason like lack of space.. */
 	if (!(inode->i_state & I_NEW) && INODE_PKEY(inode)->k_objectid != 0) {	/* also handles bad_inode case */
@@ -74,7 +75,7 @@ void reiserfs_delete_inode(struct inode *inode)
       out:
 	clear_inode(inode);	/* note this must go after the journal_end to prevent deadlock */
 	inode->i_blocks = 0;
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, depth);
 }
 
 static void _make_cpu_key(struct cpu_key *key, int version, __u32 dirid,
-- 
1.6.2.3

