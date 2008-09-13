Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYIMXb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYIMXb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 19:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYIMXbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 19:31:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:47846 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYIMXbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 19:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EfTgeCg14wZNMwPflLUus+VZsDjUIDgSJFjb8OE0nBssEC0pAUClF5hph3GC3d7HlR
         mjWga4jwBo7iWlfpwCBSN8XzdCY0QuE27QcTyCiN+RASoO6vWEOhL12vHFG7pOjwO+eA
         mvYfG56Y+DRBaJRfMAOif3gk2un/1MHR9tJGk=
Date: Sun, 14 Sep 2008 03:31:38 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: 2.6.27-rc6: lockdep warning: iprune_mutex at
	shrink_icache_memory+0x38/0x1a8
Message-ID: <20080913233138.GA19576@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[ INFO: possible circular locking dependency detected ]
2.6.27-rc6-00034-gd1c6d2e #3
-------------------------------------------------------
nfsd/1766 is trying to acquire lock:
 (iprune_mutex){--..}, at: [<c01743fb>] shrink_icache_memory+0x38/0x1a8

 but task is already holding lock:
  (&(&ip->i_iolock)->mr_lock){----}, at: [<c021134f>]
  xfs_ilock+0xa2/0xd6


I read files through nfs and saw delay for few seconds.
System is x86_32, nfs, xfs.
The last working kernel is 2.6.27-rc5,
I do not know yet is it reproducible or not.



the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_iolock)->mr_lock){----}:
       [<c0137b3f>] __lock_acquire+0x970/0xae8
       [<c0137d12>] lock_acquire+0x5b/0x77
       [<c012e803>] down_write_nested+0x35/0x6c
       [<c0211328>] xfs_ilock+0x7b/0xd6
       [<c02114a1>] xfs_ireclaim+0x1d/0x59
       [<c022e056>] xfs_finish_reclaim+0x12a/0x134
       [<c022e1d8>] xfs_reclaim+0xbc/0x125
       [<c023aba9>] xfs_fs_clear_inode+0x55/0x8e
       [<c01742aa>] clear_inode+0x7a/0xc9
       [<c0174335>] dispose_list+0x3c/0xca
       [<c017453e>] shrink_icache_memory+0x17b/0x1a8
       [<c014e5be>] shrink_slab+0xd3/0x12e
       [<c014e8e4>] kswapd+0x2cb/0x3ac
       [<c012b404>] kthread+0x39/0x5e
       [<c0103933>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (iprune_mutex){--..}:
       [<c0137a14>] __lock_acquire+0x845/0xae8
       [<c0137d12>] lock_acquire+0x5b/0x77
       [<c037a03e>] __mutex_lock_common+0xa0/0x2d0
       [<c037a2f7>] mutex_lock_nested+0x29/0x31
       [<c01743fb>] shrink_icache_memory+0x38/0x1a8
       [<c014e5be>] shrink_slab+0xd3/0x12e
       [<c014eded>] try_to_free_pages+0x1cf/0x287
       [<c014a665>] __alloc_pages_internal+0x257/0x3c6
       [<c014be50>] __do_page_cache_readahead+0xb7/0x16f
       [<c014c141>] ondemand_readahead+0x115/0x123
       [<c014c1c6>] page_cache_sync_readahead+0x16/0x1c
       [<c017e7be>] __generic_file_splice_read+0xe0/0x3f7
       [<c017eb3b>] generic_file_splice_read+0x66/0x80
       [<c023914c>] xfs_splice_read+0x46/0x71
       [<c0236573>] xfs_file_splice_read+0x24/0x29
       [<c017d686>] do_splice_to+0x4e/0x5f
       [<c017da41>] splice_direct_to_actor+0xc1/0x185
       [<c01d0e19>] nfsd_vfs_read+0x21d/0x310
       [<c01d1387>] nfsd_read+0x84/0x9b
       [<c01d63e5>] nfsd3_proc_read+0xb9/0x104
       [<c01cd1b7>] nfsd_dispatch+0xcf/0x1a2
       [<c035f6d6>] svc_process+0x379/0x587
       [<c01cd6db>] nfsd+0x106/0x153
       [<c012b404>] kthread+0x39/0x5e
       [<c0103933>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by nfsd/1766:
 #0:  (hash_sem){..--}, at: [<c01d3fbf>] exp_readlock+0xd/0xf
 #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<c021134f>] xfs_ilock+0xa2/0xd6
 #2:  (shrinker_rwsem){----}, at: [<c014e50f>] shrink_slab+0x24/0x12e

stack backtrace:
Pid: 1766, comm: nfsd Not tainted 2.6.27-rc6-00034-gd1c6d2e #3
 [<c03793b5>] ? printk+0xf/0x12
 [<c0136fb8>] print_circular_bug_tail+0x5c/0x67
 [<c0137a14>] __lock_acquire+0x845/0xae8
 [<c0137d12>] lock_acquire+0x5b/0x77
 [<c01743fb>] ? shrink_icache_memory+0x38/0x1a8
 [<c037a03e>] __mutex_lock_common+0xa0/0x2d0
 [<c01743fb>] ? shrink_icache_memory+0x38/0x1a8
 [<c037a2f7>] mutex_lock_nested+0x29/0x31
 [<c01743fb>] ? shrink_icache_memory+0x38/0x1a8
 [<c01743fb>] shrink_icache_memory+0x38/0x1a8
 [<c012e7c4>] ? down_read_trylock+0x38/0x42
 [<c014e5be>] shrink_slab+0xd3/0x12e
 [<c014eded>] try_to_free_pages+0x1cf/0x287
 [<c014d53f>] ? isolate_pages_global+0x0/0x3e
 [<c014a665>] __alloc_pages_internal+0x257/0x3c6
 [<c0136bff>] ? trace_hardirqs_on_caller+0xe6/0x10d
 [<c014be50>] __do_page_cache_readahead+0xb7/0x16f
 [<c014c141>] ondemand_readahead+0x115/0x123
 [<c014c1c6>] page_cache_sync_readahead+0x16/0x1c
 [<c017e7be>] __generic_file_splice_read+0xe0/0x3f7
 [<c0135a86>] ? register_lock_class+0x17/0x26a
 [<c0137ca8>] ? __lock_acquire+0xad9/0xae8
 [<c0135a86>] ? register_lock_class+0x17/0x26a
 [<c0137ca8>] ? __lock_acquire+0xad9/0xae8
 [<c017d896>] ? spd_release_page+0x0/0xf
 [<c017eb3b>] generic_file_splice_read+0x66/0x80
 [<c023914c>] xfs_splice_read+0x46/0x71
 [<c0236573>] xfs_file_splice_read+0x24/0x29
 [<c017d686>] do_splice_to+0x4e/0x5f
 [<c017da41>] splice_direct_to_actor+0xc1/0x185
 [<c01d0f3c>] ? nfsd_direct_splice_actor+0x0/0xf
 [<c01d0e19>] nfsd_vfs_read+0x21d/0x310
 [<c01d1387>] nfsd_read+0x84/0x9b
 [<c01d63e5>] nfsd3_proc_read+0xb9/0x104
 [<c01cd1b7>] nfsd_dispatch+0xcf/0x1a2
 [<c035f6d6>] svc_process+0x379/0x587
 [<c01cd6db>] nfsd+0x106/0x153
 [<c01cd5d5>] ? nfsd+0x0/0x153
 [<c012b404>] kthread+0x39/0x5e
 [<c012b3cb>] ? kthread+0x0/0x5e
 [<c0103933>] kernel_thread_helper+0x7/0x10
 =======================
e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
  Tx Queue             <0>
  TDH                  <86>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <dc>
buffer_info[next_to_clean]
  time_stamp           <1f7dc5>
  next_to_watch        <dc>
  jiffies              <1f8034>
  next_to_watch.status <1>
