Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbZJTSsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbZJTSsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZJTSsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:48:15 -0400
Received: from smtp.wp.pl ([212.77.101.1]:40525 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751704AbZJTSsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:48:14 -0400
Date: Tue, 20 Oct 2009 20:48:16 +0200
From: "Krzysztof Helt" <krzysztof.h1@wp.pl>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net
Subject: [PATCH] jfs: lockdep fix
Message-ID: <4ade05f0af05a2.00981454@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Mailer: Interfejs WWW nowej poczty Wirtualnej Polski
X-User-Agent: Mozilla/5.0 (X11; U; Linux i686; pl-PL; rv:1.9.0.14) Gecko/2009090216 Ubuntu/9.04 (jaunty) Firefox/3.0.14
Organization: Nowa Poczta Wirtualnej Polski S.A. http://www.wp.pl/
X-WP-IP: 93.181.133.4
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [4TNk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Release rdwrlock semaphore during memory allocation.
This fixes the locked already reported here:

http://www.mail-archive.com/jfs-discussion@lists.sourceforge.net/msg01389.html

The problem here is that memory allocation is done with rdwrlock 
semaphore taken and the VM can get into the jfs layer taking the 
rdwrlock again.

Also, the patch fixes the lockdep below. This problem is created because 
the rdwrlock semaphore acquires the commit_mutex and it is called with 
interrupts enabled. The interrupt may hit with the commit_mutex taken 
and take the rdwrlock (again) inside the interrupt context.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.32-rc3 #99
---------------------------------------------------------
kswapd0/180 just changed the state of lock:
 (&jfs_ip->rdwrlock#2){++++-.}, at: [<c02e2207>] jfs_get_block+0x47/0x280
but this lock took another, RECLAIM_FS-unsafe lock in the past:
 (&jfs_ip->commit_mutex){+.+.+.}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by kswapd0/180.

the shortest dependencies between 2nd lock and 1st lock:
 -> (&jfs_ip->commit_mutex){+.+.+.} ops: 7937 {
    HARDIRQ-ON-W at:
                          [<c0246dc6>] __lock_acquire+0x5d6/0xab0
                          [<c024731a>] lock_acquire+0x7a/0xa0
                          [<c044c125>] mutex_lock_nested+0x55/0x280
                          [<c02e1d11>] jfs_commit_inode+0x61/0x120
                          [<c02e2075>] jfs_write_inode+0x35/0x50
                          [<c029c2da>] writeback_single_inode+0x1ba/0x250
                          [<c029ca3d>] writeback_inodes_wb+0x27d/0x3b0
                          [<c029cc5c>] wb_writeback+0xec/0x180
                          [<c029cf37>] wb_do_writeback+0x1a7/0x1d0
                          [<c029cf92>] bdi_writeback_task+0x32/0xa0
                          [<c026b16d>] bdi_start_fn+0x5d/0xb0
                          [<c0234e5c>] kthread+0x6c/0x80
                          [<c0203477>] kernel_thread_helper+0x7/0x10
    SOFTIRQ-ON-W at:
                          [<c0246ded>] __lock_acquire+0x5fd/0xab0
                          [<c024731a>] lock_acquire+0x7a/0xa0
                          [<c044c125>] mutex_lock_nested+0x55/0x280
                          [<c02e1d11>] jfs_commit_inode+0x61/0x120
                          [<c02e2075>] jfs_write_inode+0x35/0x50
                          [<c029c2da>] writeback_single_inode+0x1ba/0x250
                          [<c029ca3d>] writeback_inodes_wb+0x27d/0x3b0
                          [<c029cc5c>] wb_writeback+0xec/0x180
                          [<c029cf37>] wb_do_writeback+0x1a7/0x1d0
                          [<c029cf92>] bdi_writeback_task+0x32/0xa0
                          [<c026b16d>] bdi_start_fn+0x5d/0xb0
                          [<c0234e5c>] kthread+0x6c/0x80
                          [<c0203477>] kernel_thread_helper+0x7/0x10
    RECLAIM_FS-ON-W at:
                             [<c02444f5>] mark_held_locks+0x55/0x70
                             [<c0244b42>] lockdep_trace_alloc+0xa2/0xd0
                             [<c027ed78>] kmem_cache_alloc+0x28/0x100
                             [<c032090b>] radix_tree_preload+0x1b/0x60
                             [<c025b2d1>] add_to_page_cache_locked+0x21/0xe0
                             [<c025b3b8>] add_to_page_cache_lru+0x28/0x70
                             [<c025b55a>] read_cache_page_async+0xaa/0x140
                             [<c025b602>] read_cache_page+0x12/0x60
                             [<c02fac29>] __get_metapage+0x109/0x3f0
                             [<c02ecb3d>] diWrite+0x16d/0x580
                             [<c02fe295>] txCommit+0x1b5/0x1040
                             [<c02e3fea>] jfs_create+0x26a/0x330
                             [<c028a91f>] vfs_create+0x7f/0xd0
                             [<c028d4a1>] do_filp_open+0x6c1/0x7e0
                             [<c0280711>] do_sys_open+0x51/0x120
                             [<c0280849>] sys_open+0x29/0x40
                             [<c0202c45>] syscall_call+0x7/0xb
    INITIAL USE at:
                         [<c0246a02>] __lock_acquire+0x212/0xab0
                         [<c024731a>] lock_acquire+0x7a/0xa0
                         [<c044c125>] mutex_lock_nested+0x55/0x280
                         [<c02e1d11>] jfs_commit_inode+0x61/0x120
                         [<c02e2075>] jfs_write_inode+0x35/0x50
                         [<c029c2da>] writeback_single_inode+0x1ba/0x250
                         [<c029ca3d>] writeback_inodes_wb+0x27d/0x3b0
                         [<c029cc5c>] wb_writeback+0xec/0x180
                         [<c029cf37>] wb_do_writeback+0x1a7/0x1d0
                         [<c029cf92>] bdi_writeback_task+0x32/0xa0
                         [<c026b16d>] bdi_start_fn+0x5d/0xb0
                         [<c0234e5c>] kthread+0x6c/0x80
                         [<c0203477>] kernel_thread_helper+0x7/0x10
  }
  ... key      at: [<c0a9523c>] __key.25521+0x0/0x8
  ... acquired at:
   [<c02461d5>] validate_chain+0xa25/0x1040
   [<c0246aca>] __lock_acquire+0x2da/0xab0
   [<c024731a>] lock_acquire+0x7a/0xa0
   [<c044c125>] mutex_lock_nested+0x55/0x280
   [<c02f98f9>] extAlloc+0x49/0x5c0
   [<c02e23e7>] jfs_get_block+0x227/0x280
   [<c02a45c0>] nobh_write_begin+0x130/0x3e0
   [<c02e1c2d>] jfs_write_begin+0x3d/0x50
   [<c025b9de>] generic_file_buffered_write+0xde/0x260
   [<c025bf44>] __generic_file_aio_write+0x244/0x490
   [<c025c1e8>] generic_file_aio_write+0x58/0xc0
   [<c0281f6c>] do_sync_write+0xcc/0x110
   [<c02827b6>] vfs_write+0x96/0x160
   [<c0282c9d>] sys_write+0x3d/0x70
   [<c0202c45>] syscall_call+0x7/0xb

-> (&jfs_ip->rdwrlock#2){++++-.} ops: 9669 {
   HARDIRQ-ON-W at:
                        [<c0246dc6>] __lock_acquire+0x5d6/0xab0
                        [<c024731a>] lock_acquire+0x7a/0xa0
                        [<c0238ab0>] down_write_nested+0x50/0x70
                        [<c02e2207>] jfs_get_block+0x47/0x280
                        [<c02a45c0>] nobh_write_begin+0x130/0x3e0
                        [<c02e1c2d>] jfs_write_begin+0x3d/0x50
                        [<c025b9de>] generic_file_buffered_write+0xde/0x260
                        [<c025bf44>] __generic_file_aio_write+0x244/0x490
                        [<c025c1e8>] generic_file_aio_write+0x58/0xc0
                        [<c0281f6c>] do_sync_write+0xcc/0x110
                        [<c02827b6>] vfs_write+0x96/0x160
                        [<c0282c9d>] sys_write+0x3d/0x70
                        [<c0202c45>] syscall_call+0x7/0xb
   HARDIRQ-ON-R at:
                        [<c02469cf>] __lock_acquire+0x1df/0xab0
                        [<c024731a>] lock_acquire+0x7a/0xa0
                        [<c0238c10>] down_read_nested+0x50/0x70
                        [<c02e22a6>] jfs_get_block+0xe6/0x280
                        [<c02a9c56>] do_mpage_readpage+0x3a6/0x510
                        [<c02a9ebd>] mpage_readpages+0x9d/0xd0
                        [<c02e1c59>] jfs_readpages+0x19/0x20
                        [<c0262433>] __do_page_cache_readahead+0x163/0x1f0
                        [<c02624e8>] ra_submit+0x28/0x40
                        [<c026270b>] ondemand_readahead+0x12b/0x220
                        [<c02628a8>] page_cache_sync_readahead+0x28/0x30
                        [<c025c8fa>] generic_file_aio_read+0x4ca/0x640
                        [<c028207c>] do_sync_read+0xcc/0x110
                        [<c0282914>] vfs_read+0x94/0x150
                        [<c0282c2d>] sys_read+0x3d/0x70
                        [<c0202c45>] syscall_call+0x7/0xb
   SOFTIRQ-ON-W at:
                        [<c0246ded>] __lock_acquire+0x5fd/0xab0
                        [<c024731a>] lock_acquire+0x7a/0xa0
                        [<c0238ab0>] down_write_nested+0x50/0x70
                        [<c02e2207>] jfs_get_block+0x47/0x280
                        [<c02a45c0>] nobh_write_begin+0x130/0x3e0
                        [<c02e1c2d>] jfs_write_begin+0x3d/0x50
                        [<c025b9de>] generic_file_buffered_write+0xde/0x260
                        [<c025bf44>] __generic_file_aio_write+0x244/0x490
                        [<c025c1e8>] generic_file_aio_write+0x58/0xc0
                        [<c0281f6c>] do_sync_write+0xcc/0x110
                        [<c02827b6>] vfs_write+0x96/0x160
                        [<c0282c9d>] sys_write+0x3d/0x70
                        [<c0202c45>] syscall_call+0x7/0xb
   SOFTIRQ-ON-R at:
                        [<c0246efe>] __lock_acquire+0x70e/0xab0
                        [<c024731a>] lock_acquire+0x7a/0xa0
                        [<c0238c10>] down_read_nested+0x50/0x70
                        [<c02e22a6>] jfs_get_block+0xe6/0x280
                        [<c02a9c56>] do_mpage_readpage+0x3a6/0x510
                        [<c02a9ebd>] mpage_readpages+0x9d/0xd0
                        [<c02e1c59>] jfs_readpages+0x19/0x20
                        [<c0262433>] __do_page_cache_readahead+0x163/0x1f0
                        [<c02624e8>] ra_submit+0x28/0x40
                        [<c026270b>] ondemand_readahead+0x12b/0x220
                        [<c02628a8>] page_cache_sync_readahead+0x28/0x30
                        [<c025c8fa>] generic_file_aio_read+0x4ca/0x640
                        [<c028207c>] do_sync_read+0xcc/0x110
                        [<c0282914>] vfs_read+0x94/0x150
                        [<c0282c2d>] sys_read+0x3d/0x70
                        [<c0202c45>] syscall_call+0x7/0xb
   IN-RECLAIM_FS-W at:
                           [<c0246ec7>] __lock_acquire+0x6d7/0xab0
                           [<c024731a>] lock_acquire+0x7a/0xa0
                           [<c0238ab0>] down_write_nested+0x50/0x70
                           [<c02e2207>] jfs_get_block+0x47/0x280
                           [<c02a30b3>] __block_write_full_page+0xe3/0x320
                           [<c02a33b7>] block_write_full_page_endio+0xc7/0xe0
                           [<c02a33e2>] block_write_full_page+0x12/0x20
                           [<c02e1c9f>] jfs_writepage+0xf/0x20
                           [<c0264f0c>] shrink_page_list+0x31c/0x6c0
                           [<c0265539>] shrink_list+0x289/0x630
                           [<c0265b57>] shrink_zone+0x277/0x2f0
                           [<c026649b>] kswapd+0x48b/0x4f0
                           [<c0234e5c>] kthread+0x6c/0x80
                           [<c0203477>] kernel_thread_helper+0x7/0x10
   INITIAL USE at:
                       [<c0246a02>] __lock_acquire+0x212/0xab0
                       [<c024731a>] lock_acquire+0x7a/0xa0
                       [<c0238c10>] down_read_nested+0x50/0x70
                       [<c02e22a6>] jfs_get_block+0xe6/0x280
                       [<c02a9c56>] do_mpage_readpage+0x3a6/0x510
                       [<c02a9ebd>] mpage_readpages+0x9d/0xd0
                       [<c02e1c59>] jfs_readpages+0x19/0x20
                       [<c0262433>] __do_page_cache_readahead+0x163/0x1f0
                       [<c02624e8>] ra_submit+0x28/0x40
                       [<c026270b>] ondemand_readahead+0x12b/0x220
                       [<c02628a8>] page_cache_sync_readahead+0x28/0x30
                       [<c025c8fa>] generic_file_aio_read+0x4ca/0x640
                       [<c028207c>] do_sync_read+0xcc/0x110
                       [<c0282914>] vfs_read+0x94/0x150
                       [<c0282c2d>] sys_read+0x3d/0x70
                       [<c0202c45>] syscall_call+0x7/0xb
 }
 ... key      at: [<c0a95244>] __key.25520+0x0/0x1c
 ... acquired at:
   [<c0247f3c>] check_usage_forwards+0x7c/0xd0
   [<c024406d>] mark_lock+0x17d/0x5b0
   [<c0246ec7>] __lock_acquire+0x6d7/0xab0
   [<c024731a>] lock_acquire+0x7a/0xa0
   [<c0238ab0>] down_write_nested+0x50/0x70
   [<c02e2207>] jfs_get_block+0x47/0x280
   [<c02a30b3>] __block_write_full_page+0xe3/0x320
   [<c02a33b7>] block_write_full_page_endio+0xc7/0xe0
   [<c02a33e2>] block_write_full_page+0x12/0x20
   [<c02e1c9f>] jfs_writepage+0xf/0x20
   [<c0264f0c>] shrink_page_list+0x31c/0x6c0
   [<c0265539>] shrink_list+0x289/0x630
   [<c0265b57>] shrink_zone+0x277/0x2f0
   [<c026649b>] kswapd+0x48b/0x4f0
   [<c0234e5c>] kthread+0x6c/0x80
   [<c0203477>] kernel_thread_helper+0x7/0x10


stack backtrace:
Pid: 180, comm: kswapd0 Not tainted 2.6.32-rc3 #99
Call Trace:
 [<c0243d18>] print_irq_inversion_bug+0x108/0x130
 [<c0247f3c>] check_usage_forwards+0x7c/0xd0
 [<c024406d>] mark_lock+0x17d/0x5b0
 [<c0247ec0>] ? check_usage_forwards+0x0/0xd0
 [<c0246ec7>] __lock_acquire+0x6d7/0xab0
 [<c024731a>] lock_acquire+0x7a/0xa0
 [<c02e2207>] ? jfs_get_block+0x47/0x280
 [<c0238ab0>] down_write_nested+0x50/0x70
 [<c02e2207>] ? jfs_get_block+0x47/0x280
 [<c02e2207>] jfs_get_block+0x47/0x280
 [<c044d7dd>] ? _spin_unlock+0x1d/0x20
 [<c02a17c7>] ? create_empty_buffers+0x77/0x90
 [<c02a30b3>] __block_write_full_page+0xe3/0x320
 [<c02e21c0>] ? jfs_get_block+0x0/0x280
 [<c02a33b7>] block_write_full_page_endio+0xc7/0xe0
 [<c02a3f50>] ? end_buffer_async_write+0x0/0x160
 [<c02e21c0>] ? jfs_get_block+0x0/0x280
 [<c024463c>] ? trace_hardirqs_on_caller+0x12c/0x180
 [<c02a33e2>] block_write_full_page+0x12/0x20
 [<c02a3f50>] ? end_buffer_async_write+0x0/0x160
 [<c02e1c9f>] jfs_writepage+0xf/0x20
 [<c0264f0c>] shrink_page_list+0x31c/0x6c0
 [<c0265539>] shrink_list+0x289/0x630
 [<c0265b57>] shrink_zone+0x277/0x2f0
 [<c026649b>] kswapd+0x48b/0x4f0
 [<c0264170>] ? isolate_pages_global+0x0/0x1f0
 [<c0234f30>] ? autoremove_wake_function+0x0/0x40
 [<c0266010>] ? kswapd+0x0/0x4f0
 [<c0234e5c>] kthread+0x6c/0x80
 [<c0234df0>] ? kthread+0x0/0x80
 [<c0203477>] kernel_thread_helper+0x7/0x10

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---

I am not sure if this is the right fix to the problem. The heavy use of 
the jfs volume can lock up a machine (e.g. hit me in Ubuntu 9.04).

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index b2ae190..de18324 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -244,9 +244,22 @@ int jfs_get_block(struct inode *ip, sector_t lblock,
 #ifdef _JFS_4K
 	if ((rc = extHint(ip, lblock64 << ip->i_sb->s_blocksize_bits, &xad)))
 		goto unlock;
+
+	/* release lock to avoid lockdep with jfs_ip->commit_mutex */
+	if (create)
+		IWRITE_UNLOCK(ip);
+	else
+		IREAD_UNLOCK(ip);
+
 	rc = extAlloc(ip, xlen, lblock64, &xad, false);
+
 	if (rc)
-		goto unlock;
+		return rc;
+
+	if (create)
+		IWRITE_LOCK(ip, RDWRLOCK_NORMAL);
+	else
+		IREAD_LOCK(ip, RDWRLOCK_NORMAL);
 
 	set_buffer_new(bh_result);
 	map_bh(bh_result, ip->i_sb, addressXAD(&xad));

----------------------------------------------------
25 pa¼dziernika na stadionie Polonii w Warszawie 
b±d¼ z bia³o-czerwonymi. Zas³uguj± na to...
Zobacz wiêcej: http://klik.wp.pl/?adr=http%3A%2F%2Fcorto.www.wp.pl%2Fas%2Frugby.html&sid=892


