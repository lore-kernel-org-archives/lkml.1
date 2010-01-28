Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336Ab0A1Mxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0A1Mxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702Ab0A1Mxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:53:38 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60162 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab0A1Mxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZLTVT19vaZwL+hvr+AENCtclLBSzrvq6YMHF3JWgDml0cLf3eniV/JNmrEF2UHgiQR
         f9QNL7Kpz+bZs4BRnneaBTdbps6eHvUiGBvXklYX5UdAZd/OizxntRSneIuazWNZDt2F
         q1eCFkmL/KSapj5+dNYWXK0hKRsFHvA4gim9Q=
Date: Thu, 28 Jan 2010 13:53:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] reiserfs: Fix vmalloc call under reiserfs lock
Message-ID: <20100128125332.GC5074@nowhere>
References: <a4423d671001241044k4435417dt11aa2e0e9259fe93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d671001241044k4435417dt11aa2e0e9259fe93@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 09:44:25PM +0300, Alexander Beregalov wrote:
> Hi Frederic
> 
> Here is another warning:
> 
> [ INFO: inconsistent lock state ]
> 2.6.33-rc5 #1
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> kswapd0/313 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c11118c8>]
> reiserfs_write_lock_once+0x28/0x50
> {RECLAIM_FS-ON-W} state was registered at:
>   [<c104ee32>] mark_held_locks+0x62/0x90
>   [<c104eefa>] lockdep_trace_alloc+0x9a/0xc0
>   [<c108f7b6>] kmem_cache_alloc+0x26/0xf0
>   [<c108621c>] __get_vm_area_node+0x6c/0xf0
>   [<c108690e>] __vmalloc_node+0x7e/0xa0
>   [<c1086aab>] vmalloc+0x2b/0x30
>   [<c110e1fb>] journal_init+0x6cb/0xa10
>   [<c10f90a2>] reiserfs_fill_super+0x342/0xb80
>   [<c1095665>] get_sb_bdev+0x145/0x180
>   [<c10f68e1>] get_super_block+0x21/0x30
>   [<c1094520>] vfs_kern_mount+0x40/0xd0
>   [<c1094609>] do_kern_mount+0x39/0xd0
>   [<c10aaa97>] do_mount+0x2c7/0x6d0
>   [<c10aaf06>] sys_mount+0x66/0xa0
>   [<c16198a7>] mount_block_root+0xc4/0x245
>   [<c1619a81>] mount_root+0x59/0x5f
>   [<c1619b98>] prepare_namespace+0x111/0x14b
>   [<c1619269>] kernel_init+0xcf/0xdb
>   [<c100303a>] kernel_thread_helper+0x6/0x1c
> irq event stamp: 63236801
> hardirqs last  enabled at (63236801): [<c134e7fa>]
> __mutex_unlock_slowpath+0x9a/0x120
> hardirqs last disabled at (63236800): [<c134e799>]
> __mutex_unlock_slowpath+0x39/0x120
> softirqs last  enabled at (63218800): [<c102f451>] __do_softirq+0xc1/0x110
> softirqs last disabled at (63218789): [<c102f4ed>] do_softirq+0x4d/0x60
> 
> other info that might help us debug this:
> 2 locks held by kswapd0/313:
>  #0:  (shrinker_rwsem){++++..}, at: [<c1074bb4>] shrink_slab+0x24/0x170
>  #1:  (&type->s_umount_key#19){++++..}, at: [<c10a2edd>]
> shrink_dcache_memory+0xfd/0x1a0
> 
> stack backtrace:
> Pid: 313, comm: kswapd0 Not tainted 2.6.33-rc5 #1
> Call Trace:
>  [<c134db2c>] ? printk+0x18/0x1c
>  [<c104e7ef>] print_usage_bug+0x15f/0x1a0
>  [<c104ebcf>] mark_lock+0x39f/0x5a0
>  [<c104d66b>] ? trace_hardirqs_off+0xb/0x10
>  [<c1052c50>] ? check_usage_forwards+0x0/0xf0
>  [<c1050c24>] __lock_acquire+0x214/0xa70
>  [<c10438c5>] ? sched_clock_cpu+0x95/0x110
>  [<c10514fa>] lock_acquire+0x7a/0xa0
>  [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
>  [<c134f03f>] mutex_lock_nested+0x5f/0x2b0
>  [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
>  [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
>  [<c11118c8>] reiserfs_write_lock_once+0x28/0x50
>  [<c10f05b0>] reiserfs_delete_inode+0x50/0x140
>  [<c10a653f>] ? generic_delete_inode+0x5f/0x150
>  [<c10f0560>] ? reiserfs_delete_inode+0x0/0x140
>  [<c10a657c>] generic_delete_inode+0x9c/0x150
>  [<c10a666d>] generic_drop_inode+0x3d/0x60
>  [<c10a5597>] iput+0x47/0x50
>  [<c10a2a4f>] dentry_iput+0x6f/0xf0
>  [<c10a2af4>] d_kill+0x24/0x50
>  [<c10a2d3d>] __shrink_dcache_sb+0x21d/0x2b0
>  [<c10a2f0f>] shrink_dcache_memory+0x12f/0x1a0
>  [<c1074c9e>] shrink_slab+0x10e/0x170
>  [<c1075177>] kswapd+0x477/0x6a0
>  [<c1072d10>] ? isolate_pages_global+0x0/0x1b0
>  [<c103e160>] ? autoremove_wake_function+0x0/0x40
>  [<c1074d00>] ? kswapd+0x0/0x6a0
>  [<c103de6c>] kthread+0x6c/0x80
>  [<c103de00>] ? kthread+0x0/0x80
>  [<c100303a>] kernel_thread_helper+0x6/0x1c


Ok, I think this patch fixes the issues. Unfortunately I
can't reproduce this lockdep warning, even by booting with
low memory and then stress testing.

I hope you can give it a try.

Thanks a lot!

---
>From bbec919150037b8a2e58e32d3ba642ba3b6582a5 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 28 Jan 2010 13:43:50 +0100
Subject: [PATCH] reiserfs: Fix vmalloc call under reiserfs lock

Vmalloc is called to allocate journal->j_cnode_free_list but
we hold the reiserfs lock at this time, which raises a
{RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} lock inversion.

Just drop the reiserfs lock at this time, as it's not even
needed but kept for paranoid reasons.

This fixes:

[ INFO: inconsistent lock state ]
2.6.33-rc5 #1
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/313 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c11118c8>]
reiserfs_write_lock_once+0x28/0x50
{RECLAIM_FS-ON-W} state was registered at:
  [<c104ee32>] mark_held_locks+0x62/0x90
  [<c104eefa>] lockdep_trace_alloc+0x9a/0xc0
  [<c108f7b6>] kmem_cache_alloc+0x26/0xf0
  [<c108621c>] __get_vm_area_node+0x6c/0xf0
  [<c108690e>] __vmalloc_node+0x7e/0xa0
  [<c1086aab>] vmalloc+0x2b/0x30
  [<c110e1fb>] journal_init+0x6cb/0xa10
  [<c10f90a2>] reiserfs_fill_super+0x342/0xb80
  [<c1095665>] get_sb_bdev+0x145/0x180
  [<c10f68e1>] get_super_block+0x21/0x30
  [<c1094520>] vfs_kern_mount+0x40/0xd0
  [<c1094609>] do_kern_mount+0x39/0xd0
  [<c10aaa97>] do_mount+0x2c7/0x6d0
  [<c10aaf06>] sys_mount+0x66/0xa0
  [<c16198a7>] mount_block_root+0xc4/0x245
  [<c1619a81>] mount_root+0x59/0x5f
  [<c1619b98>] prepare_namespace+0x111/0x14b
  [<c1619269>] kernel_init+0xcf/0xdb
  [<c100303a>] kernel_thread_helper+0x6/0x1c
irq event stamp: 63236801
hardirqs last  enabled at (63236801): [<c134e7fa>]
__mutex_unlock_slowpath+0x9a/0x120
hardirqs last disabled at (63236800): [<c134e799>]
__mutex_unlock_slowpath+0x39/0x120
softirqs last  enabled at (63218800): [<c102f451>] __do_softirq+0xc1/0x110
softirqs last disabled at (63218789): [<c102f4ed>] do_softirq+0x4d/0x60

other info that might help us debug this:
2 locks held by kswapd0/313:
 #0:  (shrinker_rwsem){++++..}, at: [<c1074bb4>] shrink_slab+0x24/0x170
 #1:  (&type->s_umount_key#19){++++..}, at: [<c10a2edd>]
shrink_dcache_memory+0xfd/0x1a0

stack backtrace:
Pid: 313, comm: kswapd0 Not tainted 2.6.33-rc5 #1
Call Trace:
 [<c134db2c>] ? printk+0x18/0x1c
 [<c104e7ef>] print_usage_bug+0x15f/0x1a0
 [<c104ebcf>] mark_lock+0x39f/0x5a0
 [<c104d66b>] ? trace_hardirqs_off+0xb/0x10
 [<c1052c50>] ? check_usage_forwards+0x0/0xf0
 [<c1050c24>] __lock_acquire+0x214/0xa70
 [<c10438c5>] ? sched_clock_cpu+0x95/0x110
 [<c10514fa>] lock_acquire+0x7a/0xa0
 [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c134f03f>] mutex_lock_nested+0x5f/0x2b0
 [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c11118c8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f05b0>] reiserfs_delete_inode+0x50/0x140
 [<c10a653f>] ? generic_delete_inode+0x5f/0x150
 [<c10f0560>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a657c>] generic_delete_inode+0x9c/0x150
 [<c10a666d>] generic_drop_inode+0x3d/0x60
 [<c10a5597>] iput+0x47/0x50
 [<c10a2a4f>] dentry_iput+0x6f/0xf0
 [<c10a2af4>] d_kill+0x24/0x50
 [<c10a2d3d>] __shrink_dcache_sb+0x21d/0x2b0
 [<c10a2f0f>] shrink_dcache_memory+0x12f/0x1a0
 [<c1074c9e>] shrink_slab+0x10e/0x170
 [<c1075177>] kswapd+0x477/0x6a0
 [<c1072d10>] ? isolate_pages_global+0x0/0x1b0
 [<c103e160>] ? autoremove_wake_function+0x0/0x40
 [<c1074d00>] ? kswapd+0x0/0x6a0
 [<c103de6c>] kthread+0x6c/0x80
 [<c103de00>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/reiserfs/journal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 83ac4d3..ba98546 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2913,7 +2913,9 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	journal->j_mount_id = 10;
 	journal->j_state = 0;
 	atomic_set(&(journal->j_jlock), 0);
+	reiserfs_write_unlock(sb);
 	journal->j_cnode_free_list = allocate_cnodes(num_cnodes);
+	reiserfs_write_lock(sb);
 	journal->j_cnode_free_orig = journal->j_cnode_free_list;
 	journal->j_cnode_free = journal->j_cnode_free_list ? num_cnodes : 0;
 	journal->j_cnode_used = 0;
-- 
1.6.2.3


