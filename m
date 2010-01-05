Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179Ab0AEHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0AEHC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195Ab0AEHCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:02:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52849 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0AEHCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:02:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G8nyd4ziEzDd28vePQdziCXLIOLw0iTwQH6ugfvWI8cKskYds8+Hxsyb4wkbalgCqo
         F3QUE9X0/r/QNTHvXm/bHXa/ODxDPAwTkf+M8bbBVBAtEx5Js1YM3+qCS/MJyfRy5KTY
         JhN+kuhh9iydvbwy2ZnuWdXgs+ZW6T5SWsmZo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] reiserfs: Relax the lock before truncating pages
Date: Tue,  5 Jan 2010 08:02:37 +0100
Message-Id: <1262674958-23312-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262674958-23312-1-git-send-regression-fweisbec@gmail.com>
References: <1262674958-23312-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While truncating a file, reiserfs_setattr() calls inode_setattr()
that will truncate the mapping for the given inode, but for that
it needs the pages locks.

In order to release these, the owners need the reiserfs lock to
complete their jobs. But they can't, as we don't release it before
calling inode_setattr().

We need to do that to fix the following softlockups:

INFO: task flush-8:0:2149 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:0     D f51af998     0  2149      2 0x00000000
 f51af9ac 00000092 00000002 f51af998 c2803304 00000000 c1894ad0 010f3000
 f51af9cc c1462604 c189ef80 f51af974 c1710304 f715b450 f715b5ec c2807c40
 00000000 0005bb00 c2803320 c102c55b c1710304 c2807c50 c2803304 00000246
Call Trace:
 [<c1462604>] ? schedule+0x434/0xb20
 [<c102c55b>] ? resched_task+0x4b/0x70
 [<c106fa22>] ? mark_held_locks+0x62/0x80
 [<c146414d>] ? mutex_lock_nested+0x1fd/0x350
 [<c14640b9>] mutex_lock_nested+0x169/0x350
 [<c1178cde>] ? reiserfs_write_lock+0x2e/0x40
 [<c1178cde>] reiserfs_write_lock+0x2e/0x40
 [<c11719a2>] do_journal_end+0xc2/0xe70
 [<c1172912>] journal_end+0xb2/0x120
 [<c11686b3>] ? pathrelse+0x33/0xb0
 [<c11729e4>] reiserfs_end_persistent_transaction+0x64/0x70
 [<c1153caa>] reiserfs_get_block+0x12ba/0x15f0
 [<c106fa22>] ? mark_held_locks+0x62/0x80
 [<c1154b24>] reiserfs_writepage+0xa74/0xe80
 [<c1465a27>] ? _raw_spin_unlock_irq+0x27/0x50
 [<c11f3d25>] ? radix_tree_gang_lookup_tag_slot+0x95/0xc0
 [<c10b5377>] ? find_get_pages_tag+0x127/0x1a0
 [<c106fa22>] ? mark_held_locks+0x62/0x80
 [<c106fcd4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c10bc1e0>] __writepage+0x10/0x40
 [<c10bc9ab>] write_cache_pages+0x16b/0x320
 [<c10bc1d0>] ? __writepage+0x0/0x40
 [<c10bcb88>] generic_writepages+0x28/0x40
 [<c10bcbd5>] do_writepages+0x35/0x40
 [<c11059f7>] writeback_single_inode+0xc7/0x330
 [<c11067b2>] writeback_inodes_wb+0x2c2/0x490
 [<c1106a86>] wb_writeback+0x106/0x1b0
 [<c1106cf6>] wb_do_writeback+0x106/0x1e0
 [<c1106c18>] ? wb_do_writeback+0x28/0x1e0
 [<c1106e0a>] bdi_writeback_task+0x3a/0xb0
 [<c10cbb13>] bdi_start_fn+0x63/0xc0
 [<c10cbab0>] ? bdi_start_fn+0x0/0xc0
 [<c105d1f4>] kthread+0x74/0x80
 [<c105d180>] ? kthread+0x0/0x80
 [<c100327a>] kernel_thread_helper+0x6/0x10
3 locks held by flush-8:0/2149:
 #0:  (&type->s_umount_key#30){+++++.}, at: [<c110676f>] writeback_inodes_wb+0x27f/0x490
 #1:  (&journal->j_mutex){+.+...}, at: [<c117199a>] do_journal_end+0xba/0xe70
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1178cde>] reiserfs_write_lock+0x2e/0x40
INFO: task fstest:3813 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fstest        D 00000002     0  3813   3812 0x00000000
 f5103c94 00000082 f5103c40 00000002 f5ad5450 00000007 f5103c28 011f3000
 00000006 f5ad5450 c10bb005 00000480 c1710304 f5ad5450 f5ad55ec c2907c40
 00000001 f5ad5450 f5103c74 00000046 00000002 f5ad5450 00000007 f5103c6c
Call Trace:
 [<c10bb005>] ? free_hot_cold_page+0x1d5/0x280
 [<c1462d64>] io_schedule+0x74/0xc0
 [<c10b5a45>] sync_page+0x35/0x60
 [<c146325a>] __wait_on_bit_lock+0x4a/0x90
 [<c10b5a10>] ? sync_page+0x0/0x60
 [<c10b59e5>] __lock_page+0x85/0x90
 [<c105d660>] ? wake_bit_function+0x0/0x60
 [<c10bf654>] truncate_inode_pages_range+0x1e4/0x2d0
 [<c10bf75f>] truncate_inode_pages+0x1f/0x30
 [<c10bf7cf>] truncate_pagecache+0x5f/0xa0
 [<c10bf86a>] vmtruncate+0x5a/0x70
 [<c10fdb7d>] inode_setattr+0x5d/0x190
 [<c1150117>] reiserfs_setattr+0x1f7/0x2f0
 [<c1464569>] ? down_write+0x49/0x70
 [<c10fde01>] notify_change+0x151/0x330
 [<c10e6f3d>] do_truncate+0x6d/0xa0
 [<c10f4ce2>] do_filp_open+0x9a2/0xcf0
 [<c1465aec>] ? _raw_spin_unlock+0x2c/0x50
 [<c10fec50>] ? alloc_fd+0xe0/0x100
 [<c10e602d>] do_sys_open+0x6d/0x130
 [<c1002cfb>] ? sysenter_exit+0xf/0x16
 [<c10e615e>] sys_open+0x2e/0x40
 [<c1002ccc>] sysenter_do_call+0x12/0x32
3 locks held by fstest/3813:
 #0:  (&sb->s_type->i_mutex_key#4){+.+.+.}, at: [<c10e6f33>] do_truncate+0x63/0xa0
 #1:  (&sb->s_type->i_alloc_sem_key#3){+.+.+.}, at: [<c10fdf07>] notify_change+0x257/0x330
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1178c8e>] reiserfs_write_lock_once+0x2e/0x50

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/inode.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 47dbfb1..c876341 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3140,8 +3140,17 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 				    journal_end(&th, inode->i_sb, jbegin_count);
 			}
 		}
-		if (!error)
+		if (!error) {
+			/*
+			 * Relax the lock here, as it might truncate the
+			 * inode pages and wait for inode pages locks.
+			 * To release such page lock, the owner needs the
+			 * reiserfs lock
+			 */
+			reiserfs_write_unlock_once(inode->i_sb, depth);
 			error = inode_setattr(inode, attr);
+			depth = reiserfs_write_lock_once(inode->i_sb);
+		}
 	}
 
 	if (!error && reiserfs_posixacl(inode->i_sb)) {
-- 
1.6.2.3

