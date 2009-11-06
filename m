Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbZKFOzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbZKFOzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 09:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbZKFOzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 09:55:20 -0500
Received: from 88-97-16-53.dsl.zen.co.uk ([88.97.16.53]:45135 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754959AbZKFOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:55:14 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2009 09:55:12 EST
Message-ID: <4AF437A1.4020509@kingswood-consulting.co.uk>
Date: Fri, 06 Nov 2009 14:50:09 +0000
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: linux-kernel@vger.kernel.org, shaggy@linux.vnet.ibm.com
Subject: Re: JFS inconsistent lock state
References: <h7jln4$mcn$1@ger.gmane.org>
In-Reply-To: <h7jln4$mcn$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank A. Kingswood wrote:
>>> I'm running jfs on md and got this error. The system is still usable 
>>> afterwards (and has not been rebooted yet) so I could provide more 
>>> information if needed.
>>> 
>>> The system has occasionally had hard crashes during file access (perhaps 
>>> starting with about 2.6.29) and these may be related.
 >>
 >> The same happens with 2.6.31-rc8
 >>
 >> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
 >> ... MAX_LOCKDEP_SUBCLASSES:  8
 >> ... MAX_LOCK_DEPTH:          48
 >> ... MAX_LOCKDEP_KEYS:        8191
 >> ... CLASSHASH_SIZE:          4096
 >> ... MAX_LOCKDEP_ENTRIES:     16384
 >> ... MAX_LOCKDEP_CHAINS:      32768
 >> ... CHAINHASH_SIZE:          16384
 >>   memory used by lock dependency info: 6207 kB
 >>   per task-struct memory footprint: 2688 bytes
 >>
 >> ...a while later...
 >>

Dave Kleikamp wrote:
 >
 > I looked at this a while back:
 >
 > http://lkml.org/lkml/2009/5/18/358
 >
 > I didn't get a response to that, and I didn't follow up.  I guess it's
 > time to get back on it.  I'll try to recreate the warning and see if
 > this patch helps:
 >
 > diff --git a/mm/filemap.c b/mm/filemap.c
 > index ccea3b6..59f5406 100644
 > --- a/mm/filemap.c
 > +++ b/mm/filemap.c
 > @@ -1702,7 +1702,8 @@ repeat:
 >          page = page_cache_alloc_cold(mapping);
 >          if (!page)
 >              return ERR_PTR(-ENOMEM);
 > -        err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
 > +        err = add_to_page_cache_lru(page, mapping, index,
 > +                        mapping_gfp_mask(mapping));
 >          if (unlikely(err)) {
 >              page_cache_release(page);
 >              if (err == -EEXIST)
 >

With this patch on 2.6.31.5 a lock trace still happens. I only booted into 
this kernel yesterday, so it happens pretty soon. I guess after the first 
trace no further are reported?

  [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff81183e18>] txUnlock+0xb8/0x2b0
   [<ffffffff81186e85>] txCommit+0xd55/0xe90
   [<ffffffff8116921e>] jfs_rename+0x42e/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff8107f8f4>] __set_page_dirty_nobuffers+0x54/0x180
   [<ffffffff8107e0c5>] set_page_dirty+0x35/0x70
   [<ffffffff81180848>] release_metapage+0x108/0x1a0
   [<ffffffff81180f8e>] put_metapage+0x6e/0x180
   [<ffffffff81183e77>] txUnlock+0x117/0x2b0
   [<ffffffff81186e85>] txCommit+0xd55/0xe90
   [<ffffffff8116921e>] jfs_rename+0x42e/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> (key#44){......} ops: 81174 {
       INITIAL USE at:
                               [<ffffffff81061321>] __lock_acquire+0x1b1/0x1250
                               [<ffffffff81062451>] lock_acquire+0x91/0xc0
                               [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
                               [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
                               [<ffffffff8118447d>] txEnd+0xbd/0x170
                               [<ffffffff81184e27>] jfs_lazycommit+0x257/0x260
                               [<ffffffff8104e416>] kthread+0xa6/0xc0
                               [<ffffffff8100c53a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff8677500c>] __key.24083+0x0/0x8
    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff8118447d>] txEnd+0xbd/0x170
   [<ffffffff8116922c>] jfs_rename+0x43c/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff8104e78c>] __wake_up_bit+0x2c/0x30
   [<ffffffff810776c2>] unlock_page+0x22/0x30
   [<ffffffff81180d6f>] __get_metapage+0x30f/0x4c0
   [<ffffffff81178a9b>] find_index+0x12b/0x150
   [<ffffffff81179c30>] modify_index+0x40/0xf0
   [<ffffffff8117a123>] dtDelete+0x213/0xb10
   [<ffffffff8116911a>] jfs_rename+0x32a/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff81146808>] nfsd_rename+0x3f8/0x470
   [<ffffffff8114fd9c>] nfsd3_proc_rename+0xcc/0x190
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810a77d5>] __slab_alloc+0x425/0x5b0
   [<ffffffff810a7a66>] kmem_cache_alloc+0x106/0x110
   [<ffffffff81079a51>] mempool_alloc_slab+0x11/0x20
   [<ffffffff81079b76>] mempool_alloc+0x56/0x150
   [<ffffffff81180b39>] __get_metapage+0xd9/0x4c0
   [<ffffffff8116bcda>] xtSearch+0x30a/0x5b0
   [<ffffffff8116c014>] xtLookup+0x94/0x180
   [<ffffffff81178a6a>] find_index+0xfa/0x150
   [<ffffffff8117a1ff>] dtDelete+0x2ef/0xb10
   [<ffffffff8116911a>] jfs_rename+0x32a/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff81146808>] nfsd_rename+0x3f8/0x470
   [<ffffffff8114fd9c>] nfsd3_proc_rename+0xcc/0x190
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff81169035>] jfs_rename+0x245/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> (&jfs_ip->commit_mutex/2){+.+...} ops: 52 {
      HARDIRQ-ON-W at:
                              [<ffffffff81061711>] __lock_acquire+0x5a1/0x1250
                              [<ffffffff81062451>] lock_acquire+0x91/0xc0
                              [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
                              [<ffffffff81169017>] jfs_rename+0x227/0x900
                              [<ffffffff810b61a9>] vfs_rename+0x199/0x410
                              [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
                              [<ffffffff810b8d36>] sys_rename+0x16/0x20
                              [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
                              [<ffffffffffffffff>] 0xffffffffffffffff
      SOFTIRQ-ON-W at:
                              [<ffffffff81061745>] __lock_acquire+0x5d5/0x1250
                              [<ffffffff81062451>] lock_acquire+0x91/0xc0
                              [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
                              [<ffffffff81169017>] jfs_rename+0x227/0x900
                              [<ffffffff810b61a9>] vfs_rename+0x199/0x410
                              [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
                              [<ffffffff810b8d36>] sys_rename+0x16/0x20
                              [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
                              [<ffffffffffffffff>] 0xffffffffffffffff
      INITIAL USE at:
                             [<ffffffff81061321>] __lock_acquire+0x1b1/0x1250
                             [<ffffffff81062451>] lock_acquire+0x91/0xc0
                             [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
                             [<ffffffff81169017>] jfs_rename+0x227/0x900
                             [<ffffffff810b61a9>] vfs_rename+0x199/0x410
                             [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
                             [<ffffffff810b8d36>] sys_rename+0x16/0x20
                             [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff86774c26>] __key.25249+0x2/0x8
    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810cce7b>] __mark_inode_dirty+0x6b/0x140
   [<ffffffff8117dbf1>] dtInsert+0x1e1/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff81185495>] txLock+0x35/0x7a0
   [<ffffffff8117db3b>] dtInsert+0x12b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff811807a4>] release_metapage+0x64/0x1a0
   [<ffffffff811727a6>] diWrite+0x2e6/0x5a0
   [<ffffffff8118631c>] txCommit+0x1ec/0xe90
   [<ffffffff8116921e>] jfs_rename+0x42e/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff81182d4e>] lmLog+0x3e/0x1f0
   [<ffffffff811869a4>] txCommit+0x874/0xe90
   [<ffffffff8116921e>] jfs_rename+0x42e/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff81181eb1>] lmGroupCommit+0x31/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff8116921e>] jfs_rename+0x42e/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff81080b37>] activate_page+0x47/0x160
   [<ffffffff81080cb5>] mark_page_accessed+0x65/0x80
   [<ffffffff81078c02>] read_cache_page_async+0xb2/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff81169035>] jfs_rename+0x245/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff8107780e>] add_to_page_cache_locked+0x5e/0xe0
   [<ffffffff810778bc>] add_to_page_cache_lru+0x2c/0x80
   [<ffffffff81078bcd>] read_cache_page_async+0x7d/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff812ad06e>] wait_barrier+0x2e/0x130
   [<ffffffff812b00b1>] make_request+0x81/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff8117ffb4>] metapage_readpage+0x164/0x220
   [<ffffffff81078be1>] read_cache_page_async+0x91/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff811a3d40>] __make_request+0x60/0x3f0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff8117ffb4>] metapage_readpage+0x164/0x220
   [<ffffffff81078be1>] read_cache_page_async+0x91/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8104e9a5>] prepare_to_wait_exclusive+0x25/0x80
   [<ffffffff81392cb0>] __wait_on_bit_lock+0x40/0xb0
   [<ffffffff81077564>] __lock_page+0x64/0x70
   [<ffffffff81078c3c>] read_cache_page_async+0xec/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff812395b4>] scsi_request_fn+0x154/0x4d0
   [<ffffffff811a20c0>] __generic_unplug_device+0x30/0x40
   [<ffffffff811a20f9>] generic_unplug_device+0x29/0x40
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff812acd89>] unplug_slaves+0xd9/0x160
   [<ffffffff812ace28>] raid10_unplug+0x18/0x30
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff811a143d>] blk_backing_dev_unplug+0xd/0x10
   [<ffffffff810d19d9>] block_sync_page+0x39/0x70
   [<ffffffff810775b3>] sync_page+0x33/0x70
   [<ffffffff81392cc2>] __wait_on_bit_lock+0x52/0xb0
   [<ffffffff81077564>] __lock_page+0x64/0x70
   [<ffffffff81078c3c>] read_cache_page_async+0xec/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff8124fbc4>] ata_scsi_queuecmd+0x44/0x2e0
   [<ffffffff81233c79>] scsi_dispatch_cmd+0xe9/0x240
   [<ffffffff81239826>] scsi_request_fn+0x3c6/0x4d0
   [<ffffffff811a20c0>] __generic_unplug_device+0x30/0x40
   [<ffffffff811a20f9>] generic_unplug_device+0x29/0x40
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff812acd89>] unplug_slaves+0xd9/0x160
   [<ffffffff812ace28>] raid10_unplug+0x18/0x30
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff811a143d>] blk_backing_dev_unplug+0xd/0x10
   [<ffffffff810d19d9>] block_sync_page+0x39/0x70
   [<ffffffff810775b3>] sync_page+0x33/0x70
   [<ffffffff81392cc2>] __wait_on_bit_lock+0x52/0xb0
   [<ffffffff81077564>] __lock_page+0x64/0x70
   [<ffffffff81078c3c>] read_cache_page_async+0xec/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff812b1ea7>] md_wakeup_thread+0x27/0x30
   [<ffffffff812ace34>] raid10_unplug+0x24/0x30
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff811a143d>] blk_backing_dev_unplug+0xd/0x10
   [<ffffffff810d19d9>] block_sync_page+0x39/0x70
   [<ffffffff810775b3>] sync_page+0x33/0x70
   [<ffffffff81392cc2>] __wait_on_bit_lock+0x52/0xb0
   [<ffffffff81077564>] __lock_page+0x64/0x70
   [<ffffffff81078c3c>] read_cache_page_async+0xec/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff81391f4c>] schedule+0xcc/0x350
   [<ffffffff81392907>] io_schedule+0x37/0x50
   [<ffffffff810775bd>] sync_page+0x3d/0x70
   [<ffffffff81392cc2>] __wait_on_bit_lock+0x52/0xb0
   [<ffffffff81077564>] __lock_page+0x64/0x70
   [<ffffffff81078c3c>] read_cache_page_async+0xec/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810a77d5>] __slab_alloc+0x425/0x5b0
   [<ffffffff810a7a66>] kmem_cache_alloc+0x106/0x110
   [<ffffffff81079a51>] mempool_alloc_slab+0x11/0x20
   [<ffffffff81079b76>] mempool_alloc+0x56/0x150
   [<ffffffff81180b39>] __get_metapage+0xd9/0x4c0
   [<ffffffff8117ac62>] add_index+0x242/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116956f>] jfs_rename+0x77f/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810b03e9>] inode_sub_bytes+0x29/0xa0
   [<ffffffff8117a4c4>] dtDelete+0x5b4/0xb10
   [<ffffffff8116911a>] jfs_rename+0x32a/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff81169017>] jfs_rename+0x227/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff810b8cde>] sys_renameat+0x20e/0x250
   [<ffffffff810b8d36>] sys_rename+0x16/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810a77d5>] __slab_alloc+0x425/0x5b0
   [<ffffffff810a7a66>] kmem_cache_alloc+0x106/0x110
   [<ffffffff81079a51>] mempool_alloc_slab+0x11/0x20
   [<ffffffff81079b76>] mempool_alloc+0x56/0x150
   [<ffffffff81180b39>] __get_metapage+0xd9/0x4c0
   [<ffffffff8116bcda>] xtSearch+0x30a/0x5b0
   [<ffffffff8116c014>] xtLookup+0x94/0x180
   [<ffffffff8117ab04>] add_index+0xe4/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116a719>] jfs_create+0x1c9/0x2c0
   [<ffffffff810b6e8a>] vfs_create+0x9a/0xb0
   [<ffffffff810ba1e1>] do_filp_open+0x9e1/0xad0
   [<ffffffff810aa5ef>] do_sys_open+0x7f/0x140
   [<ffffffff810aa6db>] sys_open+0x1b/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff8118447d>] txEnd+0xbd/0x170
   [<ffffffff81169c1c>] jfs_unlink+0x2cc/0x3c0
   [<ffffffff810b5f36>] vfs_unlink+0x96/0xe0
   [<ffffffff810b8efb>] do_unlinkat+0x1bb/0x1d0
   [<ffffffff810b907d>] sys_unlinkat+0x1d/0x40
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff812b0414>] make_request+0x3e4/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff8116921e>] jfs_rename+0x42e/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff81146808>] nfsd_rename+0x3f8/0x470
   [<ffffffff8114fd9c>] nfsd3_proc_rename+0xcc/0x190
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff812b0474>] make_request+0x444/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff8116921e>] jfs_rename+0x42e/0x900
   [<ffffffff810b61a9>] vfs_rename+0x199/0x410
   [<ffffffff81146808>] nfsd_rename+0x3f8/0x470
   [<ffffffff8114fd9c>] nfsd3_proc_rename+0xcc/0x190
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81052c50>] down_read_nested+0x50/0x90
   [<ffffffff811777a6>] dbAlloc+0x156/0x520
   [<ffffffff8117058e>] xtInsert+0x26e/0x3e0
   [<ffffffff8117abdd>] add_index+0x1bd/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff8116a719>] jfs_create+0x1c9/0x2c0
   [<ffffffff810b6e8a>] vfs_create+0x9a/0xb0
   [<ffffffff81148ccb>] nfsd_create_v3+0x46b/0x560
   [<ffffffff81150529>] nfsd3_proc_create+0x119/0x1a0
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff812b54cf>] md_write_start+0x12f/0x1d0
   [<ffffffff812b00a5>] make_request+0x75/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81169c12>] jfs_unlink+0x2c2/0x3c0
   [<ffffffff810b5f36>] vfs_unlink+0x96/0xe0
   [<ffffffff811492cc>] nfsd_unlink+0x20c/0x2c0
   [<ffffffff8114ffa7>] nfsd3_proc_remove+0x77/0xd0
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff81104060>] sysfs_notify_dirent+0x20/0x70
   [<ffffffff812b54b4>] md_write_start+0x114/0x1d0
   [<ffffffff812b00a5>] make_request+0x75/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81169c12>] jfs_unlink+0x2c2/0x3c0
   [<ffffffff810b5f36>] vfs_unlink+0x96/0xe0
   [<ffffffff811492cc>] nfsd_unlink+0x20c/0x2c0
   [<ffffffff8114ffa7>] nfsd3_proc_remove+0x77/0xd0
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8104ea25>] prepare_to_wait+0x25/0x80
   [<ffffffff812b546d>] md_write_start+0xcd/0x1d0
   [<ffffffff812b00a5>] make_request+0x75/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81169c12>] jfs_unlink+0x2c2/0x3c0
   [<ffffffff810b5f36>] vfs_unlink+0x96/0xe0
   [<ffffffff811492cc>] nfsd_unlink+0x20c/0x2c0
   [<ffffffff8114ffa7>] nfsd3_proc_remove+0x77/0xd0
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff8117758d>] dbNextAG+0x2d/0xf0
   [<ffffffff81177868>] dbAlloc+0x218/0x520
   [<ffffffff8117dcf6>] dtInsert+0x2e6/0x18d0
   [<ffffffff8116a719>] jfs_create+0x1c9/0x2c0
   [<ffffffff810b6e8a>] vfs_create+0x9a/0xb0
   [<ffffffff81148ccb>] nfsd_create_v3+0x46b/0x560
   [<ffffffff81150529>] nfsd3_proc_create+0x119/0x1a0
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8104ea9c>] remove_wait_queue+0x1c/0x60
   [<ffffffff81185a0c>] txLock+0x5ac/0x7a0
   [<ffffffff8117261a>] diWrite+0x15a/0x5a0
   [<ffffffff8118631c>] txCommit+0x1ec/0xe90
   [<ffffffff81169c12>] jfs_unlink+0x2c2/0x3c0
   [<ffffffff810b5f36>] vfs_unlink+0x96/0xe0
   [<ffffffff810b8efb>] do_unlinkat+0x1bb/0x1d0
   [<ffffffff810b8f21>] sys_unlink+0x11/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff81082f26>] wakeup_kswapd+0x86/0x90
   [<ffffffff8107cadb>] __alloc_pages_nodemask+0x1bb/0x670
   [<ffffffff810792f6>] find_or_create_page+0x56/0xb0
   [<ffffffff81180b0c>] __get_metapage+0xac/0x4c0
   [<ffffffff8117b02b>] add_index+0x60b/0x720
   [<ffffffff8117c507>] dtInsertEntry+0x117/0x4b0
   [<ffffffff8117db6b>] dtInsert+0x15b/0x18d0
   [<ffffffff81169e58>] jfs_link+0x148/0x220
   [<ffffffff810b710b>] vfs_link+0xfb/0x150
   [<ffffffff810b97c1>] sys_linkat+0x131/0x150
   [<ffffffff810b97f9>] sys_link+0x19/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff8116a619>] jfs_create+0xc9/0x2c0
   [<ffffffff810b6e8a>] vfs_create+0x9a/0xb0
   [<ffffffff810ba1e1>] do_filp_open+0x9e1/0xad0
   [<ffffffff810aa5ef>] do_sys_open+0x7f/0x140
   [<ffffffff810aa6db>] sys_open+0x1b/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81052c50>] down_read_nested+0x50/0x90
   [<ffffffff811777a6>] dbAlloc+0x156/0x520
   [<ffffffff8117f962>] extAlloc+0x162/0x430
   [<ffffffff8116892c>] jfs_get_block+0x1ec/0x250
   [<ffffffff810d600a>] nobh_write_begin+0x1ca/0x470
   [<ffffffff811683ee>] jfs_write_begin+0x1e/0x20
   [<ffffffff81077d70>] generic_file_buffered_write+0x130/0x320
   [<ffffffff810795b1>] __generic_file_aio_write_nolock+0x261/0x470
   [<ffffffff810798c9>] generic_file_aio_write+0x69/0xe0
   [<ffffffff810ac461>] do_sync_write+0xf1/0x130
   [<ffffffff810aca5b>] vfs_write+0xcb/0x180
   [<ffffffff810acc00>] sys_write+0x50/0x90
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff811b3da3>] __up_read+0x23/0xb0
   [<ffffffff81052d26>] up_read+0x26/0x30
   [<ffffffff81177838>] dbAlloc+0x1e8/0x520
   [<ffffffff8117f962>] extAlloc+0x162/0x430
   [<ffffffff8116892c>] jfs_get_block+0x1ec/0x250
   [<ffffffff810d600a>] nobh_write_begin+0x1ca/0x470
   [<ffffffff811683ee>] jfs_write_begin+0x1e/0x20
   [<ffffffff81077d70>] generic_file_buffered_write+0x130/0x320
   [<ffffffff810795b1>] __generic_file_aio_write_nolock+0x261/0x470
   [<ffffffff810798c9>] generic_file_aio_write+0x69/0xe0
   [<ffffffff810ac461>] do_sync_write+0xf1/0x130
   [<ffffffff810aca5b>] vfs_write+0xcb/0x180
   [<ffffffff810acc00>] sys_write+0x50/0x90
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (&jfs_ip->ag_lock){....-.} ops: 1444792 {
     IN-RECLAIM_FS-W at:
                               [<ffffffff8106156d>] __lock_acquire+0x3fd/0x1250
                               [<ffffffff81062451>] lock_acquire+0x91/0xc0
                               [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
                               [<ffffffff81167725>] jfs_destroy_inode+0x35/0xa0
                               [<ffffffff810c221a>] destroy_inode+0x2a/0x50
                               [<ffffffff810c2884>] 
generic_delete_inode+0xf4/0x150
                               [<ffffffff810c2a95>] 
generic_drop_inode+0x1b5/0x230
                               [<ffffffff810c1b9d>] iput+0x5d/0x70
                               [<ffffffff810be688>] dentry_iput+0x98/0x110
                               [<ffffffff810be80a>] d_kill+0x4a/0x70
                               [<ffffffff810bead4>] 
__shrink_dcache_sb+0x2a4/0x3c0
                               [<ffffffff810bed4b>] 
shrink_dcache_memory+0x15b/0x1e0
                               [<ffffffff81084725>] shrink_slab+0x125/0x180
                               [<ffffffff81084cdd>] kswapd+0x55d/0x740
                               [<ffffffff8104e416>] kthread+0xa6/0xc0
                               [<ffffffff8100c53a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff81061321>] __lock_acquire+0x1b1/0x1250
                           [<ffffffff81062451>] lock_acquire+0x91/0xc0
                           [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
                           [<ffffffff81168153>] jfs_release+0x23/0x80
                           [<ffffffff810adfde>] __fput+0xfe/0x260
                           [<ffffffff810ae15d>] fput+0x1d/0x30
                           [<ffffffff81092baa>] remove_vma+0x4a/0x80
                           [<ffffffff81094822>] do_munmap+0x342/0x3a0
                           [<ffffffff810948cb>] sys_munmap+0x4b/0x70
                           [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff86774c14>] __key.25251+0x0/0x8
  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff8117fbb0>] extAlloc+0x3b0/0x430
   [<ffffffff8116892c>] jfs_get_block+0x1ec/0x250
   [<ffffffff810d600a>] nobh_write_begin+0x1ca/0x470
   [<ffffffff811683ee>] jfs_write_begin+0x1e/0x20
   [<ffffffff81077d70>] generic_file_buffered_write+0x130/0x320
   [<ffffffff810795b1>] __generic_file_aio_write_nolock+0x261/0x470
   [<ffffffff810798c9>] generic_file_aio_write+0x69/0xe0
   [<ffffffff810ac461>] do_sync_write+0xf1/0x130
   [<ffffffff810aca5b>] vfs_write+0xcb/0x180
   [<ffffffff810acc00>] sys_write+0x50/0x90
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810cce7b>] __mark_inode_dirty+0x6b/0x140
   [<ffffffff8116d5ce>] xtTruncate+0xc9e/0xd90
   [<ffffffff8116860e>] jfs_truncate_nolock+0x6e/0x140
   [<ffffffff81168728>] jfs_truncate+0x48/0x60
   [<ffffffff8108faf5>] vmtruncate+0xa5/0x110
   [<ffffffff810c38d0>] inode_setattr+0x30/0x180
   [<ffffffff81189ed4>] jfs_setattr+0x34/0x160
   [<ffffffff810c3b39>] notify_change+0x119/0x320
   [<ffffffff810ab5d5>] do_truncate+0x65/0x90
   [<ffffffff810b66eb>] may_open+0x1db/0x210
   [<ffffffff810b9e6c>] do_filp_open+0x66c/0xad0
   [<ffffffff810aa5ef>] do_sys_open+0x7f/0x140
   [<ffffffff810aa6db>] sys_open+0x1b/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff8117758d>] dbNextAG+0x2d/0xf0
   [<ffffffff81177868>] dbAlloc+0x218/0x520
   [<ffffffff8117f962>] extAlloc+0x162/0x430
   [<ffffffff8116892c>] jfs_get_block+0x1ec/0x250
   [<ffffffff810d600a>] nobh_write_begin+0x1ca/0x470
   [<ffffffff811683ee>] jfs_write_begin+0x1e/0x20
   [<ffffffff81077d70>] generic_file_buffered_write+0x130/0x320
   [<ffffffff810795b1>] __generic_file_aio_write_nolock+0x261/0x470
   [<ffffffff810798c9>] generic_file_aio_write+0x69/0xe0
   [<ffffffff810ac461>] do_sync_write+0xf1/0x130
   [<ffffffff810aca5b>] vfs_write+0xcb/0x180
   [<ffffffff810acc00>] sys_write+0x50/0x90
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff812ad06e>] wait_barrier+0x2e/0x130
   [<ffffffff812b00b1>] make_request+0x81/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff812b0414>] make_request+0x3e4/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff812b0474>] make_request+0x444/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff812b1ea7>] md_wakeup_thread+0x27/0x30
   [<ffffffff812b048f>] make_request+0x45f/0x680
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff811819f2>] lbmStartIO+0x92/0xc0
   [<ffffffff81181cb4>] lbmWrite+0xd4/0x130
   [<ffffffff811814f4>] lmGCwrite+0x94/0xd0
   [<ffffffff81181f16>] lmGroupCommit+0x96/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff81391f4c>] schedule+0xcc/0x350
   [<ffffffff81392907>] io_schedule+0x37/0x50
   [<ffffffff81181ffd>] lmGroupCommit+0x17d/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff8107f8f4>] __set_page_dirty_nobuffers+0x54/0x180
   [<ffffffff8107e0c5>] set_page_dirty+0x35/0x70
   [<ffffffff8118070d>] force_metapage+0x6d/0xa0
   [<ffffffff8118658e>] txCommit+0x45e/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8104ea25>] prepare_to_wait+0x25/0x80
   [<ffffffff81392df3>] __wait_on_bit+0x43/0x90
   [<ffffffff8107779f>] wait_on_page_bit+0x6f/0x80
   [<ffffffff8107e585>] write_one_page+0x125/0x140
   [<ffffffff8118071a>] force_metapage+0x7a/0xa0
   [<ffffffff8118658e>] txCommit+0x45e/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff811a3d40>] __make_request+0x60/0x3f0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff8117ffb4>] metapage_readpage+0x164/0x220
   [<ffffffff81078be1>] read_cache_page_async+0x91/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117812a>] dbUpdatePMap+0x3aa/0x4b0
   [<ffffffff8118438a>] txFreeMap+0x23a/0x270
   [<ffffffff81184a54>] txUpdateMap+0xe4/0x260
   [<ffffffff81186bb5>] txCommit+0xa85/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff812395b4>] scsi_request_fn+0x154/0x4d0
   [<ffffffff811a20c0>] __generic_unplug_device+0x30/0x40
   [<ffffffff811a20f9>] generic_unplug_device+0x29/0x40
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff812acd89>] unplug_slaves+0xd9/0x160
   [<ffffffff812ace28>] raid10_unplug+0x18/0x30
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff811a143d>] blk_backing_dev_unplug+0xd/0x10
   [<ffffffff810d19d9>] block_sync_page+0x39/0x70
   [<ffffffff810775b3>] sync_page+0x33/0x70
   [<ffffffff81392cc2>] __wait_on_bit_lock+0x52/0xb0
   [<ffffffff81077564>] __lock_page+0x64/0x70
   [<ffffffff81078c3c>] read_cache_page_async+0xec/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117812a>] dbUpdatePMap+0x3aa/0x4b0
   [<ffffffff8118438a>] txFreeMap+0x23a/0x270
   [<ffffffff81184a54>] txUpdateMap+0xe4/0x260
   [<ffffffff81186bb5>] txCommit+0xa85/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff8124fbc4>] ata_scsi_queuecmd+0x44/0x2e0
   [<ffffffff81233c79>] scsi_dispatch_cmd+0xe9/0x240
   [<ffffffff81239826>] scsi_request_fn+0x3c6/0x4d0
   [<ffffffff811a20c0>] __generic_unplug_device+0x30/0x40
   [<ffffffff811a20f9>] generic_unplug_device+0x29/0x40
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff812acd89>] unplug_slaves+0xd9/0x160
   [<ffffffff812ace28>] raid10_unplug+0x18/0x30
   [<ffffffff811a1422>] blk_unplug+0x12/0x20
   [<ffffffff811a143d>] blk_backing_dev_unplug+0xd/0x10
   [<ffffffff810d19d9>] block_sync_page+0x39/0x70
   [<ffffffff810775b3>] sync_page+0x33/0x70
   [<ffffffff81392cc2>] __wait_on_bit_lock+0x52/0xb0
   [<ffffffff81077564>] __lock_page+0x64/0x70
   [<ffffffff81078c3c>] read_cache_page_async+0xec/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff8117812a>] dbUpdatePMap+0x3aa/0x4b0
   [<ffffffff8118438a>] txFreeMap+0x23a/0x270
   [<ffffffff81184a54>] txUpdateMap+0xe4/0x260
   [<ffffffff81186bb5>] txCommit+0xa85/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff81177f6f>] dbUpdatePMap+0x1ef/0x4b0
   [<ffffffff8118438a>] txFreeMap+0x23a/0x270
   [<ffffffff81184a54>] txUpdateMap+0xe4/0x260
   [<ffffffff81186bb5>] txCommit+0xa85/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810a4271>] add_partial+0x21/0x80
   [<ffffffff810a6cc1>] __slab_free+0x191/0x340
   [<ffffffff810a7358>] kmem_cache_free+0x98/0xf0
   [<ffffffff81079a72>] mempool_free_slab+0x12/0x20
   [<ffffffff81079b0a>] mempool_free+0x8a/0xa0
   [<ffffffff811808a1>] release_metapage+0x161/0x1a0
   [<ffffffff81180f8e>] put_metapage+0x6e/0x180
   [<ffffffff81183e77>] txUnlock+0x117/0x2b0
   [<ffffffff81186e85>] txCommit+0xd55/0xe90
   [<ffffffff81171e12>] diFree+0x6e2/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff8118447d>] txEnd+0xbd/0x170
   [<ffffffff81171e1b>] diFree+0x6eb/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395358>] _spin_lock_irq+0x38/0x70
   [<ffffffff812a87ae>] wait_barrier+0x2e/0x140
   [<ffffffff812ab8c4>] make_request+0x54/0x8a0
   [<ffffffff812b5718>] md_make_request+0x138/0x1a0
   [<ffffffff811a2d25>] generic_make_request+0x265/0x330
   [<ffffffff811a2e4e>] submit_bio+0x5e/0xe0
   [<ffffffff8117ffb4>] metapage_readpage+0x164/0x220
   [<ffffffff81078be1>] read_cache_page_async+0x91/0x1a0
   [<ffffffff81078cfe>] read_cache_page+0xe/0x70
   [<ffffffff81180cba>] __get_metapage+0x25a/0x4c0
   [<ffffffff811725eb>] diWrite+0x12b/0x5a0
   [<ffffffff8118631c>] txCommit+0x1ec/0xe90
   [<ffffffff8116851f>] jfs_commit_inode+0xaf/0x130
   [<ffffffff81168a35>] jfs_write_inode+0x35/0x50
   [<ffffffff810cc455>] writeback_single_inode+0x385/0x490
   [<ffffffff810cca09>] generic_sync_sb_inodes+0x359/0x4d0
   [<ffffffff810ccc75>] writeback_inodes+0x65/0x100
   [<ffffffff8107ec2c>] wb_kupdate+0xbc/0x140
   [<ffffffff8107fe98>] pdflush+0x148/0x270
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff81027056>] pgd_free+0x16/0x80
   [<ffffffff81034abe>] __mmdrop+0x1e/0x60
   [<ffffffff8102f708>] finish_task_switch+0x118/0x140
   [<ffffffff8139220e>] thread_return+0x3e/0x700
   [<ffffffff81392907>] io_schedule+0x37/0x50
   [<ffffffff81181ffd>] lmGroupCommit+0x17d/0x1e0
   [<ffffffff811864d6>] txCommit+0x3a6/0xe90
   [<ffffffff8116851f>] jfs_commit_inode+0xaf/0x130
   [<ffffffff811682a5>] jfs_fsync+0x25/0x60
   [<ffffffff810d0822>] vfs_fsync+0x92/0x100
   [<ffffffff810d08c9>] do_fsync+0x39/0x60
   [<ffffffff810d091b>] sys_fsync+0xb/0x10
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff8107c21c>] rmqueue_bulk+0x3c/0xe0
   [<ffffffff8107c6a6>] get_page_from_freelist+0x3e6/0x580
   [<ffffffff8107ca44>] __alloc_pages_nodemask+0x124/0x670
   [<ffffffff810a7565>] __slab_alloc+0x1b5/0x5b0
   [<ffffffff810a7a66>] kmem_cache_alloc+0x106/0x110
   [<ffffffff81079a51>] mempool_alloc_slab+0x11/0x20
   [<ffffffff81079b76>] mempool_alloc+0x56/0x150
   [<ffffffff81180b39>] __get_metapage+0xd9/0x4c0
   [<ffffffff811725eb>] diWrite+0x12b/0x5a0
   [<ffffffff8118631c>] txCommit+0x1ec/0xe90
   [<ffffffff8116851f>] jfs_commit_inode+0xaf/0x130
   [<ffffffff81168a35>] jfs_write_inode+0x35/0x50
   [<ffffffff810cc455>] writeback_single_inode+0x385/0x490
   [<ffffffff810cca09>] generic_sync_sb_inodes+0x359/0x4d0
   [<ffffffff810ccc75>] writeback_inodes+0x65/0x100
   [<ffffffff8107ec2c>] wb_kupdate+0xbc/0x140
   [<ffffffff8107fe98>] pdflush+0x148/0x270
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8104ea9c>] remove_wait_queue+0x1c/0x60
   [<ffffffff81185a0c>] txLock+0x5ac/0x7a0
   [<ffffffff8117261a>] diWrite+0x15a/0x5a0
   [<ffffffff8118631c>] txCommit+0x1ec/0xe90
   [<ffffffff8116851f>] jfs_commit_inode+0xaf/0x130
   [<ffffffff81168a35>] jfs_write_inode+0x35/0x50
   [<ffffffff810cc455>] writeback_single_inode+0x385/0x490
   [<ffffffff810cca09>] generic_sync_sb_inodes+0x359/0x4d0
   [<ffffffff810ccc75>] writeback_inodes+0x65/0x100
   [<ffffffff8107ec2c>] wb_kupdate+0xbc/0x140
   [<ffffffff8107fe98>] pdflush+0x148/0x270
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff8139328c>] mutex_lock_nested+0x5c/0x340
   [<ffffffff81171d83>] diFree+0x653/0xb80
   [<ffffffff811689df>] jfs_delete_inode+0x4f/0x70
   [<ffffffff810c281f>] generic_delete_inode+0x8f/0x150
   [<ffffffff810c2a95>] generic_drop_inode+0x1b5/0x230
   [<ffffffff810c1b9d>] iput+0x5d/0x70
   [<ffffffff81184b51>] txUpdateMap+0x1e1/0x260
   [<ffffffff81184d68>] jfs_lazycommit+0x198/0x260
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff813953d4>] _spin_lock_irqsave+0x44/0x90
   [<ffffffff8102c5bd>] __wake_up+0x2d/0x70
   [<ffffffff8104e78c>] __wake_up_bit+0x2c/0x30
   [<ffffffff810776c2>] unlock_page+0x22/0x30
   [<ffffffff811807f8>] release_metapage+0xb8/0x1a0
   [<ffffffff811741b3>] diAlloc+0x573/0x700
   [<ffffffff8117f41f>] ialloc+0x6f/0x2e0
   [<ffffffff8116a5b4>] jfs_create+0x64/0x2c0
   [<ffffffff810b6e8a>] vfs_create+0x9a/0xb0
   [<ffffffff81148ccb>] nfsd_create_v3+0x46b/0x560
   [<ffffffff81150529>] nfsd3_proc_create+0x119/0x1a0
   [<ffffffff81141c2b>] nfsd_dispatch+0xbb/0x260
   [<ffffffff8137a3c9>] svc_process+0x499/0x770
   [<ffffffff8114238d>] nfsd+0xdd/0x160
   [<ffffffff8104e416>] kthread+0xa6/0xc0
   [<ffffffff8100c53a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

... acquired at:
   [<ffffffff81061f75>] __lock_acquire+0xe05/0x1250
   [<ffffffff81062451>] lock_acquire+0x91/0xc0
   [<ffffffff81395271>] _spin_lock+0x31/0x70
   [<ffffffff810a4271>] add_partial+0x21/0x80
   [<ffffffff810a6cc1>] __slab_free+0x191/0x340
   [<ffffffff810a7358>] kmem_cache_free+0x98/0xf0
   [<ffffffff81079a72>] mempool_free_slab+0x12/0x20
   [<ffffffff81079b0a>] mempool_free+0x8a/0xa0
   [<ffffffff811808a1>] release_metapage+0x161/0x1a0
   [<ffffffff81173f3a>] diAlloc+0x2fa/0x700
   [<ffffffff8117f41f>] ialloc+0x6f/0x2e0
   [<ffffffff8116a5b4>] jfs_create+0x64/0x2c0
   [<ffffffff810b6e8a>] vfs_create+0x9a/0xb0
   [<ffffffff810ba1e1>] do_filp_open+0x9e1/0xad0
   [<ffffffff810aa5ef>] do_sys_open+0x7f/0x140
   [<ffffffff810aa6db>] sys_open+0x1b/0x20
   [<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff


stack backtrace:
Pid: 22862, comm: rsync Not tainted 2.6.31.5 #4
Call Trace:
[<ffffffff8105f460>] print_irq_inversion_bug+0x140/0x160
[<ffffffff8105f5a7>] check_usage_backwards+0x67/0xc0
[<ffffffff81060177>] mark_lock+0x1c7/0x420
[<ffffffff8105f540>] ? check_usage_backwards+0x0/0xc0
[<ffffffff8117e55a>] ? dtInsert+0xb4a/0x18d0
[<ffffffff81060438>] mark_held_locks+0x68/0x90
[<ffffffff81060555>] lockdep_trace_alloc+0xf5/0x100
[<ffffffff810a7995>] kmem_cache_alloc+0x35/0x110
[<ffffffff8117e55a>] dtInsert+0xb4a/0x18d0
[<ffffffff81185594>] ? txLock+0x134/0x7a0
[<ffffffff81185594>] ? txLock+0x134/0x7a0
[<ffffffff81178d88>] ? dtInitRoot+0x88/0x160
[<ffffffff8116a44f>] jfs_mkdir+0x1df/0x2e0
[<ffffffff810c0001>] ? d_move_locked+0x2f1/0x300
[<ffffffff810c0412>] ? __d_lookup+0x142/0x1d0
[<ffffffff810c02d0>] ? __d_lookup+0x0/0x1d0
[<ffffffff81060795>] ? trace_hardirqs_on_caller+0x155/0x1b0
[<ffffffff810b6f2e>] vfs_mkdir+0x8e/0xd0
[<ffffffff810b91be>] sys_mkdirat+0xfe/0x110
[<ffffffff8100b4dc>] ? sysret_check+0x27/0x62
[<ffffffff81060795>] ? trace_hardirqs_on_caller+0x155/0x1b0
[<ffffffff810b91e3>] sys_mkdir+0x13/0x20
[<ffffffff8100b4ab>] system_call_fastpath+0x16/0x1b

This happened when an rsync --link-dest ... backup job was running.
As before, the system is still running afterwards.

Frank

-- 
------------------------------------------------------------------------
Frank A. Kingswood                      frank@kingswood-consulting.co.uk
Cambridge, United Kingdom                               +44-870-095 0000
