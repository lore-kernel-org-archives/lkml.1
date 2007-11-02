Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXKBOgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXKBOgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbXKBOgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:36:11 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:58639 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361AbXKBOgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:36:09 -0400
Date: Fri, 2 Nov 2007 16:36:04 +0200
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Subject: Re: kernel 2.6.23: what IS the VM doing?
Message-ID: <20071102143604.y6v7qiax2uv2wusn@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	Rik van Riel <riel@redhat.com>
References: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi> <46DE085F.2040306@redhat.com> <20070905114545.2hydqpasqx56afkf@m.safari.iki.fi> <46DED83A.8070104@redhat.com> <20070905173332.dzwkm5ofdvtjcal4@m.safari.iki.fi> <46DF3253.6030007@redhat.com> <20070914171746.7bbx2te5646zcdpr@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914171746.7bbx2te5646zcdpr@m.safari.iki.fi>
User-Agent: Mutt/1.5.16 (2007-10-15)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 20:17:46 +0300, Sami Farin wrote:
> On Wed, Sep 05, 2007 at 18:48:51 -0400, Rik van Riel wrote:
> > Sami Farin wrote:
> >> On Wed, Sep 05, 2007 at 12:24:26 -0400, Rik van Riel wrote:
> >> ...
> >>>> *shrug*
> >>> The attached patch should make sure kswapd does not free an
> >>> excessive number of pages in zone_normal just because the
> >>> pages in zone_highmem are difficult to free.
> >>>
> >>> It does give kswapd a large margin to continue putting equal
> >>> pressure on all zones in normal situations.
> >>>
> >>> Sami, could you try out this patch to see if it helps your
> >>> situation?
> >>
> >> Thanks, Rik.  bzImage is ready, I probably reboot inside one
> >> month for a reason or other 8-)
> >
> > The more I look at the bug, the more I see that it is probably
> > not very easy to reproduce on demand.  I have, however, a full
> 
> Well, I now booted to x86_64 kernel.
> 
> I can still reproduce this.
> When I unload ipset modules, kernel resumes "normal" operation, i.e.,
> not swapping like mad.

I now have 2GB of extra RAM, so 3GB in total, on x86_64 system.
If ipset tries to allocate 512 KB or more, kernel
goes into swapping frenzy, of which system does not recover
in over 30 minutes unless I press sysrq+k.

some kernel settings...:
vm.dirty_ratio = 4
vm.dirty_background_ratio = 2
vm.swappiness = 10
vm.vfs_cache_pressure = 10
vm.overcommit_memory = 2

SysRq : Show Blocked State
  task                        PC stack   pid father
kswapd0       D 0000000000000000     0   258      2
 ffff8100be333ca0 0000000000000046 0000000000000000 0000000000000286
 ffff8100be333c50 ffffffff00000000 ffff8100be560080 ffffffff807af3c0
 0000000000000064 00000001285af6e6 00000000000000ff ffffffff802463f8
Call Trace:
 [<ffffffff802463f8>] __mod_timer+0xb8/0xd0
 [<ffffffff80657da3>] schedule_timeout+0x63/0xd0
 [<ffffffff80246120>] process_timeout+0x0/0x10
 [<ffffffff806576f8>] io_schedule_timeout+0x28/0x40
 [<ffffffff8027f5fc>] congestion_wait+0x8c/0xb0
 [<ffffffff802524e0>] autoremove_wake_function+0x0/0x40
 [<ffffffff80279ad4>] throttle_vm_writeout+0x54/0xc0
 [<ffffffff8027d6f3>] shrink_zone+0xe3/0x140
 [<ffffffff8027dea0>] kswapd+0x510/0x5b0
 [<ffffffff802524e0>] autoremove_wake_function+0x0/0x40
 [<ffffffff8027d990>] kswapd+0x0/0x5b0
 [<ffffffff802520dd>] kthread+0x4d/0x80
 [<ffffffff8020cae8>] child_rip+0xa/0x12
 [<ffffffff80252090>] kthread+0x0/0x80
 [<ffffffff8020cade>] child_rip+0x0/0x12

irqbalance    D 0000000000aa7f00     0  2110      1
 ffff8100b8c4fcd8 0000000000000082 0000000000000000 0000000000000000
 ffff8100a5e57f00 0000000800700006 ffff8100be5f91c0 ffff810060182140
 ffff8100b8c4fc88 0000000000000282 ffff8100b8c4fcb8 ffffffff8040e1f6
Call Trace:
 [<ffffffff8040e1f6>] __up_read+0x46/0xb0
 [<ffffffff806579d8>] io_schedule+0x28/0x40
 [<ffffffff802736e7>] sync_page+0x37/0x50
 [<ffffffff80657e9e>] __wait_on_bit_lock+0x4e/0x80
 [<ffffffff802736b0>] sync_page+0x0/0x50
 [<ffffffff80273695>] __lock_page+0x65/0x70
 [<ffffffff80252520>] wake_bit_function+0x0/0x30
 [<ffffffff80282289>] handle_mm_fault+0x269/0x870
 [<ffffffff802261b4>] do_page_fault+0x1a4/0x900
 [<ffffffff8028cafe>] free_pages_and_swap_cache+0x9e/0xd0
 [<ffffffff80285b86>] unmap_region+0x136/0x150
 [<ffffffff80285bfe>] remove_vma+0x5e/0x70
 [<ffffffff8040e330>] __up_write+0xd0/0x130
 [<ffffffff80659d9d>] error_exit+0x0/0x84

svscan        D 0000000000df7900     0  2438      1
 ffff8100b6607cd8 0000000000000082 0000000000000000 0000000000000000
 ffff81005f81fd80 0000000800700006 ffff8100bb516180 ffff810060182140
 ffff8100b6607c88 0000000000000282 ffff8100b6607cb8 ffffffff8040e1f6
Call Trace:
 [<ffffffff8040e1f6>] __up_read+0x46/0xb0
 [<ffffffff806579d8>] io_schedule+0x28/0x40
 [<ffffffff802736e7>] sync_page+0x37/0x50
 [<ffffffff80657e9e>] __wait_on_bit_lock+0x4e/0x80
 [<ffffffff802736b0>] sync_page+0x0/0x50
 [<ffffffff80273695>] __lock_page+0x65/0x70
 [<ffffffff80252520>] wake_bit_function+0x0/0x30
 [<ffffffff80282289>] handle_mm_fault+0x269/0x870
 [<ffffffff803acc2c>] xfs_vn_getattr+0x4c/0x140
 [<ffffffff802261b4>] do_page_fault+0x1a4/0x900
 [<ffffffff8029cf80>] vfs_getattr+0x60/0x90
 [<ffffffff8029d515>] vfs_fstat+0x45/0x60
 [<ffffffff8022b35e>] sys32_fstat64+0x2e/0x40
 [<ffffffff80659d9d>] error_exit+0x0/0x84
...
ipset         D 0000000000000000     0  3713   3574
 ffff8100566237a8 0000000000000086 ffff810056623748 ffffffff802335e2
 ffff810056623748 0000000000000010 ffff8100b085e0c0 ffff810060182140
 ffff810056623758 0000000000000282 ffff810056623788 ffffffff8040e1f6
Call Trace:
 [<ffffffff802335e2>] enqueue_entity+0x42/0x60
 [<ffffffff8040e1f6>] __up_read+0x46/0xb0
 [<ffffffff806579d8>] io_schedule+0x28/0x40
 [<ffffffff802736e7>] sync_page+0x37/0x50
 [<ffffffff80657fb5>] __wait_on_bit+0x55/0x80
 [<ffffffff802736b0>] sync_page+0x0/0x50
 [<ffffffff802738bf>] wait_on_page_bit+0x6f/0x80
 [<ffffffff80252520>] wake_bit_function+0x0/0x30
 [<ffffffff8027ccd4>] shrink_page_list+0x164/0x680
 [<ffffffff8024632a>] del_timer_sync+0x1a/0x30
 [<ffffffff80657dab>] schedule_timeout+0x6b/0xd0
 [<ffffffff80246120>] process_timeout+0x0/0x10
 [<ffffffff8027f60a>] congestion_wait+0x9a/0xb0
 [<ffffffff8027d5fa>] shrink_inactive_list+0x40a/0x420
 [<ffffffff8027d6df>] shrink_zone+0xcf/0x140
 [<ffffffff8027e3f4>] try_to_free_pages+0x174/0x270
 [<ffffffff802786c0>] __alloc_pages+0x160/0x350
 [<ffffffff8023cc77>] printk+0x67/0x70
 [<ffffffff80295d53>] cache_alloc_refill+0x2e3/0x570
 [<ffffffff802960f3>] __kmalloc+0x113/0x120
 [<ffffffff882f9283>] :ip_set_nethash:retry+0x183/0x500
 [<ffffffff882ad7af>] :ip_set:__ip_set_addip+0x6f/0x90
 [<ffffffff882aea2d>] :ip_set:ip_set_sockfn_get+0x93d/0xd50
 [<ffffffff805cb1b2>] nf_sockopt+0x142/0x150
 [<ffffffff805cb1cf>] nf_getsockopt+0xf/0x20
 [<ffffffff805d9398>] ip_getsockopt+0x98/0xc0
 [<ffffffff805f4391>] raw_getsockopt+0x11/0x30
 [<ffffffff805a20af>] sock_common_getsockopt+0xf/0x20
 [<ffffffff8059fe8c>] sys_getsockopt+0x9c/0xd0
 [<ffffffff8020be4c>] tracesys+0xdc/0xe1


SysRq : Show Memory
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  55
CPU    1: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   4
Active:10058 inactive:2274 dirty:1 writeback:106 unstable:0
 free:691389 slab:15936 mapped:1584 pagetables:4579 bounce:0
DMA free:9108kB min:16kB low:20kB high:24kB active:0kB inactive:0kB present:8604kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2988 2988 2988
DMA32 free:2756448kB min:6984kB low:8728kB high:10476kB active:40232kB inactive:9096kB present:3060476kB pages_scanned:166 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 4*8kB 2*16kB 4*32kB 3*64kB 2*128kB 1*256kB 0*512kB 2*1024kB 1*2048kB 1*4096kB = 9108kB
DMA32: 14501*4kB 15671*8kB 13250*16kB 10866*32kB 8172*64kB 4993*128kB 2039*256kB 501*512kB 51*1024kB 10*2048kB 0*4096kB = 2756396kB
Swap cache: add 320914, delete 319423, find 5260/12831, race 0+3
Free swap  = 2853404kB
Total swap = 3911784kB
Free swap:       2853404kB
780032 pages of RAM
14430 reserved pages
52938 pages shared
1491 pages swap cached
SysRq : Show Memory
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  27   Cold: hi:   62, btch:  15 usd:  54
CPU    1: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:   1
Active:10223 inactive:2151 dirty:0 writeback:122 unstable:0
 free:691292 slab:16134 mapped:1645 pagetables:4494 bounce:0
DMA free:9108kB min:16kB low:20kB high:24kB active:0kB inactive:0kB present:8604kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2988 2988 2988
DMA32 free:2756060kB min:6984kB low:8728kB high:10476kB active:40892kB inactive:8604kB present:3060476kB pages_scanned:39 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 4*8kB 2*16kB 4*32kB 3*64kB 2*128kB 1*256kB 0*512kB 2*1024kB 1*2048kB 1*4096kB = 9108kB
DMA32: 13655*4kB 15211*8kB 12903*16kB 10596*32kB 8005*64kB 4982*128kB 2094*256kB 522*512kB 59*1024kB 10*2048kB 0*4096kB = 2756068kB
Swap cache: add 412691, delete 411114, find 12357/32547, race 0+4
Free swap  = 2853920kB
Total swap = 3911784kB
Free swap:       2853920kB
780032 pages of RAM
14430 reserved pages
52619 pages shared
1577 pages swap cached


5 min later...

kswapd0       D 0000000000000000     0   258      2
 ffff8100be333d30 0000000000000046 0000000000000000 0000000000000286
 ffff8100be333ce0 ffffffff00000000 ffff8100be560080 ffffffff807af3c0
 0000000000000064 00000001286155f2 00000000000000ff ffffffff802463f8
Call Trace:
 [<ffffffff802463f8>] __mod_timer+0xb8/0xd0
 [<ffffffff80657da3>] schedule_timeout+0x63/0xd0
 [<ffffffff80246120>] process_timeout+0x0/0x10
 [<ffffffff806576f8>] io_schedule_timeout+0x28/0x40
 [<ffffffff8027f5fc>] congestion_wait+0x8c/0xb0
 [<ffffffff802524e0>] autoremove_wake_function+0x0/0x40
 [<ffffffff8027ded5>] kswapd+0x545/0x5b0
 [<ffffffff802524e0>] autoremove_wake_function+0x0/0x40
 [<ffffffff8027d990>] kswapd+0x0/0x5b0
 [<ffffffff802520dd>] kthread+0x4d/0x80
 [<ffffffff8020cae8>] child_rip+0xa/0x12
 [<ffffffff80252090>] kthread+0x0/0x80
 [<ffffffff8020cade>] child_rip+0x0/0x12




Before this ipset test, I had around 100 KB swap used,
after ipset finished and I restarted Xorg I had 500 MB.

vmstat after I restarted Xorg:

nr_free_pages 614862
nr_inactive 27488
nr_active 62666
nr_anon_pages 37065
nr_mapped 7015
nr_file_pages 66637
nr_dirty 3
nr_writeback 0
nr_slab_reclaimable 4257
nr_slab_unreclaimable 10737
nr_page_table_pages 2652
nr_unstable 0
nr_bounce 0
nr_vmscan_write 340956
pgpgin 78462562
pgpgout 67868956
pswpin 625227
pswpout 338578
pgalloc_dma 0
pgalloc_dma32 399577709
pgalloc_normal 0
pgalloc_movable 0
pgfree 400192776
pgactivate 19916454
pgdeactivate 18092870
pgfault 472557115
pgmajfault 291798
pgrefill_dma 0
pgrefill_dma32 97774325
pgrefill_normal 0
pgrefill_movable 0
pgsteal_dma 0
pgsteal_dma32 24633836
pgsteal_normal 0
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_dma32 28206694
pgscan_kswapd_normal 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 574376
pgscan_direct_normal 0
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 4761472
kswapd_steal 24497549
kswapd_inodesteal 232
pageoutrun 392180
allocstall 949
pgrotated 315045


-- 
Do what you love because life is too short for anything else.

