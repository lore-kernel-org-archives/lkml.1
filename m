Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbZL3FWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbZL3FWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZL3FWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:22:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57973 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZL3FVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X050A7/AZsXkeg3D6OXYZxZ2+1iJ+lxANV9yLNrYdoMfiNIsLT+Hk6W7+52wuVT9Ui
         F/xrNR1sW/wja/lb1Th/hFe0C2rsTOMr7GkjcvZa7F06Z92CxUFb4yApblZR3w8T6qlD
         xRHFKv/wXLwJQ6iuDSdi9urpmYYZJ9DmB4Uog=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] reiserfs: Relax reiserfs lock while freeing the journal
Date: Wed, 30 Dec 2009 06:21:31 +0100
Message-Id: <1262150491-9983-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping the reiserfs lock while freeing the journal on
umount path triggers a lock inversion between bdev->bd_mutex
and the reiserfs lock.

We don't need the reiserfs lock at this stage. The filesystem
is not usable anymore, and there are no more pending commits,
everything got flushed (even this operation was done in parallel
and didn't required the reiserfs lock from the current process).

This fixes the following lockdep report:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-atom #172
-------------------------------------------------------
umount/3904 is trying to acquire lock:
 (&bdev->bd_mutex){+.+.+.}, at: [<c10de2c2>] __blkdev_put+0x22/0x160

but task is already holding lock:
 (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1143279>] reiserfs_write_lock+0x29/0x40

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c105ea7f>] __lock_acquire+0x11ff/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c140199b>] mutex_lock_nested+0x5b/0x340
       [<c1143229>] reiserfs_write_lock_once+0x29/0x50
       [<c111c485>] reiserfs_get_block+0x85/0x1620
       [<c10e1040>] do_mpage_readpage+0x1f0/0x6d0
       [<c10e1640>] mpage_readpages+0xc0/0x100
       [<c1119b89>] reiserfs_readpages+0x19/0x20
       [<c108f1ec>] __do_page_cache_readahead+0x1bc/0x260
       [<c108f2b8>] ra_submit+0x28/0x40
       [<c1087e3e>] filemap_fault+0x40e/0x420
       [<c109b5fd>] __do_fault+0x3d/0x430
       [<c109d47e>] handle_mm_fault+0x12e/0x790
       [<c1022a65>] do_page_fault+0x135/0x330
       [<c1403663>] error_code+0x6b/0x70
       [<c10ef9ca>] load_elf_binary+0x82a/0x1a10
       [<c10ba130>] search_binary_handler+0x90/0x1d0
       [<c10bb70f>] do_execve+0x1df/0x250
       [<c1001746>] sys_execve+0x46/0x70
       [<c1002fa5>] syscall_call+0x7/0xb

-> #2 (&mm->mmap_sem){++++++}:
       [<c105ea7f>] __lock_acquire+0x11ff/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c109b1ab>] might_fault+0x8b/0xb0
       [<c11b8f52>] copy_to_user+0x32/0x70
       [<c10c3b94>] filldir64+0xa4/0xf0
       [<c1109116>] sysfs_readdir+0x116/0x210
       [<c10c3e1d>] vfs_readdir+0x8d/0xb0
       [<c10c3ea9>] sys_getdents64+0x69/0xb0
       [<c1002ec4>] sysenter_do_call+0x12/0x32

-> #1 (sysfs_mutex){+.+.+.}:
       [<c105ea7f>] __lock_acquire+0x11ff/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c140199b>] mutex_lock_nested+0x5b/0x340
       [<c110951c>] sysfs_addrm_start+0x2c/0xb0
       [<c1109aa0>] create_dir+0x40/0x90
       [<c1109b1b>] sysfs_create_dir+0x2b/0x50
       [<c11b2352>] kobject_add_internal+0xc2/0x1b0
       [<c11b2531>] kobject_add_varg+0x31/0x50
       [<c11b25ac>] kobject_add+0x2c/0x60
       [<c1258294>] device_add+0x94/0x560
       [<c11036ea>] add_partition+0x18a/0x2a0
       [<c110418a>] rescan_partitions+0x33a/0x450
       [<c10de5bf>] __blkdev_get+0x12f/0x2d0
       [<c10de76a>] blkdev_get+0xa/0x10
       [<c11034b8>] register_disk+0x108/0x130
       [<c11a87a9>] add_disk+0xd9/0x130
       [<c12998e5>] sd_probe_async+0x105/0x1d0
       [<c10528af>] async_thread+0xcf/0x230
       [<c104bfd4>] kthread+0x74/0x80
       [<c1003aab>] kernel_thread_helper+0x7/0x3c

-> #0 (&bdev->bd_mutex){+.+.+.}:
       [<c105f176>] __lock_acquire+0x18f6/0x19e0
       [<c105f2c8>] lock_acquire+0x68/0x90
       [<c140199b>] mutex_lock_nested+0x5b/0x340
       [<c10de2c2>] __blkdev_put+0x22/0x160
       [<c10de40a>] blkdev_put+0xa/0x10
       [<c113ce22>] free_journal_ram+0xd2/0x130
       [<c113ea18>] do_journal_release+0x98/0x190
       [<c113eb2a>] journal_release+0xa/0x10
       [<c1128eb6>] reiserfs_put_super+0x36/0x130
       [<c10b776f>] generic_shutdown_super+0x4f/0xe0
       [<c10b7825>] kill_block_super+0x25/0x40
       [<c11255df>] reiserfs_kill_sb+0x7f/0x90
       [<c10b7f4a>] deactivate_super+0x7a/0x90
       [<c10cccd8>] mntput_no_expire+0x98/0xd0
       [<c10ccfcc>] sys_umount+0x4c/0x310
       [<c10cd2a9>] sys_oldumount+0x19/0x20
       [<c1002ec4>] sysenter_do_call+0x12/0x32

other info that might help us debug this:

2 locks held by umount/3904:
 #0:  (&type->s_umount_key#30){+++++.}, at: [<c10b7f45>] deactivate_super+0x75/0x90
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1143279>] reiserfs_write_lock+0x29/0x40

stack backtrace:
Pid: 3904, comm: umount Not tainted 2.6.32-atom #172
Call Trace:
 [<c13ff903>] ? printk+0x18/0x1a
 [<c105d33a>] print_circular_bug+0xca/0xd0
 [<c105f176>] __lock_acquire+0x18f6/0x19e0
 [<c108b66f>] ? free_pcppages_bulk+0x1f/0x250
 [<c105f2c8>] lock_acquire+0x68/0x90
 [<c10de2c2>] ? __blkdev_put+0x22/0x160
 [<c10de2c2>] ? __blkdev_put+0x22/0x160
 [<c140199b>] mutex_lock_nested+0x5b/0x340
 [<c10de2c2>] ? __blkdev_put+0x22/0x160
 [<c105c932>] ? mark_held_locks+0x62/0x80
 [<c10afe12>] ? kfree+0x92/0xd0
 [<c10de2c2>] __blkdev_put+0x22/0x160
 [<c105cc3b>] ? trace_hardirqs_on+0xb/0x10
 [<c10de40a>] blkdev_put+0xa/0x10
 [<c113ce22>] free_journal_ram+0xd2/0x130
 [<c113ea18>] do_journal_release+0x98/0x190
 [<c113eb2a>] journal_release+0xa/0x10
 [<c1128eb6>] reiserfs_put_super+0x36/0x130
 [<c1050596>] ? up_write+0x16/0x30
 [<c10b776f>] generic_shutdown_super+0x4f/0xe0
 [<c10b7825>] kill_block_super+0x25/0x40
 [<c10f41e0>] ? vfs_quota_off+0x0/0x20
 [<c11255df>] reiserfs_kill_sb+0x7f/0x90
 [<c10b7f4a>] deactivate_super+0x7a/0x90
 [<c10cccd8>] mntput_no_expire+0x98/0xd0
 [<c10ccfcc>] sys_umount+0x4c/0x310
 [<c10cd2a9>] sys_oldumount+0x19/0x20
 [<c1002ec4>] sysenter_do_call+0x12/0x32

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/journal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index a059879..83ac4d3 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2009,10 +2009,11 @@ static int do_journal_release(struct reiserfs_transaction_handle *th,
 		destroy_workqueue(commit_wq);
 		commit_wq = NULL;
 	}
-	reiserfs_write_lock(sb);
 
 	free_journal_ram(sb);
 
+	reiserfs_write_lock(sb);
+
 	return 0;
 }
 
-- 
1.6.2.3

