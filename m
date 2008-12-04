Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYLDD2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYLDD2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 22:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYLDD15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 22:27:57 -0500
Received: from colobus.isomerica.net ([216.93.242.10]:53788 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYLDD1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 22:27:54 -0500
Date: Wed, 3 Dec 2008 22:27:50 -0500
From: Dan =?UTF-8?B?Tm/DqQ==?= <dpn@isomerica.net>
To: linux-kernel@vger.kernel.org
Subject: Page alloc failures under network/disk IO load
Message-ID: <20081203222750.391e8890@tuna>
Organization: isomerica.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on Linux 2.6.28-rc7, on a Core 2 Duo.  The system has plenty of
memory:

             total       used       free     shared    buffers
cached
Mem:          1893       1822         70          0          0
1573
-/+ buffers/cache:        249       1644
Swap:         1906         37       1868

I am using rsync to transfer data onto this system.  The filesystem is
XFS, and the target drive is a 1TB Western Digital on ata_piix.  The
system files are on a RAID 1 (Linux md, also on ata_piix).

Periodically I get page allocation failures, from __netdev_alloc_skb.
I suppose this causes the driver to drop packets and thus hurts
performance.

Below are the logs from the entire event.

Cheers,
Dan

[112854.339298] rsync: page allocation failure. order:1, mode:0x4020
[112854.339338] Pid: 20229, comm: rsync Not tainted 2.6.28-rc7 #3
[112854.339365] Call Trace:
[112854.339387]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[112854.339433]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[112854.339461]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[112854.339498]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[112854.339527]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[112854.339555]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[112854.339583]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[112854.339610]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[112854.339637]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[112854.339684]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[112854.339716]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[112854.339747]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[112854.339775]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[112854.339801]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[112854.339829]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[112854.339866]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[112854.339895]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[112854.339923]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[112854.339949]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[112854.339979]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[112854.340004]  <EOI>  [<ffffffff8030fbb1>] ? touch_atime+0x21/0x140
[112854.340008]  [<ffffffff80313a57>] ? mnt_want_write+0x7/0xa0
[112854.340008]  [<ffffffff802b8fa8>] ? stack_trace_call+0x68/0x1c0
[112854.340008]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[112854.340008]  [<ffffffff80313a5c>] ? mnt_want_write+0xc/0xa0
[112854.340008]  [<ffffffff8030fbb1>] ? touch_atime+0x21/0x140
[112854.340008]  [<ffffffff802bceed>] ?
generic_file_aio_read+0x22d/0x6c0
[112854.340008]  [<ffffffffa01fcae5>] ? xfs_ilock+0x75/0xb0 [xfs]
[112854.340008]  [<ffffffffa0229aff>] ? xfs_read+0x12f/0x2c0 [xfs]
[112854.340008]  [<ffffffffa0224e46>] ? xfs_file_aio_read+0x56/0x60
[xfs]
[112854.340008]  [<ffffffff802faa99>] ? do_sync_read+0xf9/0x140
[112854.340008]  [<ffffffff802661c0>] ?
autoremove_wake_function+0x0/0x40
[112854.340008]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[112854.340008]  [<ffffffff80374e29>] ? cap_file_permission+0x9/0x10
[112854.340008]  [<ffffffff80373d66>] ?
security_file_permission+0x16/0x20
[112854.340008]  [<ffffffff802fb2d8>] ? vfs_read+0xc8/0x180
[112854.340008]  [<ffffffff802fb495>] ? sys_read+0x55/0x90
[112854.340008]  [<ffffffff8020c6ab>] ? system_call_fastpath+0x16/0x1b
[112854.340008] Mem-Info:
[112854.340008] Node 0 DMA per-cpu:
[112854.340008] CPU    0: hi:    0, btch:   1 usd:   0
[112854.340008] CPU    1: hi:    0, btch:   1 usd:   0
[112854.340008] Node 0 DMA32 per-cpu:
[112854.340008] CPU    0: hi:  186, btch:  31 usd:  49
[112854.340008] CPU    1: hi:  186, btch:  31 usd: 170
[112854.340008] Active_anon:11937 active_file:27370 inactive_anon:4025
[112854.340008]  inactive_file:227401 unevictable:0 dirty:12448
writeback:4774 unstable:0
[112854.340008]  free:2168 slab:201706 mapped:1364 pagetables:1914
bounce:0
[112854.340008] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? yes
[112854.340008] lowmem_reserve[]: 0 1976 1976 1976
[112854.340008] Node 0 DMA32 free:7180kB min:5664kB low:7080kB
high:8496kB active_anon:47748kB inactive_anon:16100kB
active_file:109480kB inactive_file:909604kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[112854.340008] lowmem_reserve[]: 0 0 0 0
[112854.340008] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[112854.340008] Node 0 DMA32: 1465*4kB 13*8kB 31*16kB 12*32kB 0*64kB
1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7228kB
[112854.340008] 255838 total pagecache pages
[112854.340008] 948 pages in swap cache
[112854.340008] Swap cache stats: add 10447, delete 9499, find
82578/82707
[112854.340008] Free swap  = 1913948kB
[112854.340008] Total swap = 1951800kB
[112854.340008] 522160 pages RAM
[112854.340008] 37425 pages reserved
[112854.340008] 180511 pages shared
[112854.340008] 308921 pages non-shared
[116409.444195] rsync: page allocation failure. order:1, mode:0x4020
[116409.444242] Pid: 20801, comm: rsync Not tainted 2.6.28-rc7 #3
[116409.444269] Call Trace:
[116409.444290]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116409.444339]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116409.444366]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116409.444395]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116409.444423]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116409.444450]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116409.444478]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116409.444507]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116409.444536]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116409.444585]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116409.444617]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116409.444649]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116409.444679]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116409.444705]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116409.444736]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116409.444763]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116409.444788]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116409.444814]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116409.444840]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116409.444868]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116409.444893]  <EOI> <6>Mem-Info:
[116409.444924] Node 0 DMA per-cpu:
[116409.444956] CPU    0: hi:    0, btch:   1 usd:   0
[116409.444979] CPU    1: hi:    0, btch:   1 usd:   0
[116409.445003] Node 0 DMA32 per-cpu:
[116409.445032] CPU    0: hi:  186, btch:  31 usd:  14
[116409.445055] CPU    1: hi:  186, btch:  31 usd:  39
[116409.445082] Active_anon:10553 active_file:44722 inactive_anon:4935
[116409.445084]  inactive_file:342297 unevictable:0 dirty:20031
writeback:5988 unstable:0
[116409.445087]  free:37099 slab:34695 mapped:775 pagetables:2327
bounce:0
[116409.445168] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116409.445832] lowmem_reserve[]: 0 1976 1976 1976
[116409.445892] Node 0 DMA32 free:146736kB min:5664kB low:7080kB
high:8496kB active_anon:42212kB inactive_anon:19740kB
active_file:178888kB inactive_file:1369188kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116409.445966] lowmem_reserve[]: 0 0 0 0
[116409.446026] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116409.446164] Node 0 DMA32: 36391*4kB 18*8kB 7*16kB 0*32kB 0*64kB
4*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 146588kB
[116409.446349] 387905 total pagecache pages
[116409.446372] 704 pages in swap cache
[116409.446395] Swap cache stats: add 10504, delete 9800, find
88920/89050
[116409.446422] Free swap  = 1913748kB
[116409.446443] Total swap = 1951800kB
[116409.449229] 522160 pages RAM
[116409.449229] 37425 pages reserved
[116409.449229] 314570 pages shared
[116409.449229] 140539 pages non-shared
[116409.463369] rsync: page allocation failure. order:1, mode:0x4020
[116409.463402] Pid: 20801, comm: rsync Not tainted 2.6.28-rc7 #3
[116409.463427] Call Trace:
[116409.463447]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116409.463491]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116409.463517]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116409.463544]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116409.463571]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116409.463598]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116409.463625]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116409.463652]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116409.463678]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116409.463720]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116409.463749]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116409.463780]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116409.463808]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116409.463833]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116409.463872]  [<ffffffff8047d157>] ? __kfree_skb+0x47/0xa0
[116409.463901]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116409.463927]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116409.463959]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116409.463984]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116409.464009]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116409.464040]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116409.464064]  <EOI> <6>Mem-Info:
[116409.464098] Node 0 DMA per-cpu:
[116409.464123] CPU    0: hi:    0, btch:   1 usd:   0
[116409.464123] CPU    1: hi:    0, btch:   1 usd:   0
[116409.464123] Node 0 DMA32 per-cpu:
[116409.464123] CPU    0: hi:  186, btch:  31 usd:  25
[116409.464123] CPU    1: hi:  186, btch:  31 usd:   0
[116409.464123] Active_anon:10553 active_file:44690 inactive_anon:4935
[116409.464123]  inactive_file:342106 unevictable:0 dirty:19659
writeback:6360 unstable:0
[116409.464123]  free:36903 slab:35099 mapped:775 pagetables:2327
bounce:0
[116409.464123] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116409.464123] lowmem_reserve[]: 0 1976 1976 1976
[116409.464123] Node 0 DMA32 free:146120kB min:5664kB low:7080kB
high:8496kB active_anon:42212kB inactive_anon:19740kB
active_file:178760kB inactive_file:1368424kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116409.464516] lowmem_reserve[]: 0 0 0 0
[116409.464516] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116409.464516] Node 0 DMA32: 36259*4kB 22*8kB 16*16kB 0*32kB 0*64kB
3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 146108kB
[116409.464516] 387719 total pagecache pages
[116409.464516] 704 pages in swap cache
[116409.464516] Swap cache stats: add 10504, delete 9800, find
88920/89050
[116409.464516] Free swap  = 1913748kB
[116409.464516] Total swap = 1951800kB
[116409.476530] 522160 pages RAM
[116409.476530] 37425 pages reserved
[116409.476530] 314464 pages shared
[116409.476530] 140767 pages non-shared
[116419.900921] pdflush: page allocation failure. order:1, mode:0x4020
[116419.900965] Pid: 20863, comm: pdflush Not tainted 2.6.28-rc7 #3
[116419.900993] Call Trace:
[116419.901014]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116419.901063]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116419.901090]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116419.901119]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116419.901148]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116419.901178]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116419.901208]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116419.901237]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116419.901265]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116419.901319]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116419.901349]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116419.901381]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116419.901410]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116419.901437]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116419.901465]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116419.901493]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116419.901519]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116419.901547]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116419.901577]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116419.901605]  [<ffffffff802bdbd6>] ? mempool_alloc_slab+0x16/0x20
[116419.901634]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116419.901658]  <EOI>  [<ffffffff802f2985>] ?
kmem_cache_alloc+0xb5/0xe0
[116419.901696]  [<ffffffff802f2988>] ? kmem_cache_alloc+0xb8/0xe0
[116419.901724]  [<ffffffff802bdbd6>] ? mempool_alloc_slab+0x16/0x20
[116419.901752]  [<ffffffff802bdd3b>] ? mempool_alloc+0x5b/0x150
[116419.901778]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[116419.901807]  [<ffffffff80324cd4>] ? bvec_alloc_bs+0x74/0x150
[116419.901835]  [<ffffffff80324e0e>] ? bio_alloc_bioset+0x5e/0x100
[116419.901864]  [<ffffffff80324f65>] ? bio_alloc+0x15/0x30
[116419.901929]  [<ffffffffa02202ce>] ? xfs_alloc_ioend_bio+0x2e/0x60
[xfs]
[116419.901973]  [<ffffffffa0220423>] ? xfs_submit_ioend+0xe3/0xf0 [xfs]
[116419.902014]  [<ffffffffa0221520>] ?
xfs_page_state_convert+0x3a0/0x760 [xfs]
[116419.902058]  [<ffffffffa0221a41>] ? xfs_vm_writepage+0x71/0x120
[xfs]
[116419.902087]  [<ffffffff802c364a>] ? __writepage+0x1a/0x60
[116419.902115]  [<ffffffff802c4a1d>] ? write_cache_pages+0x2dd/0x450
[116419.902145]  [<ffffffff802c3630>] ? __writepage+0x0/0x60
[116419.902176]  [<ffffffff802c4bb7>] ? generic_writepages+0x27/0x30
[116419.902218]  [<ffffffffa022056b>] ? xfs_vm_writepages+0x5b/0x70
[xfs]
[116419.902248]  [<ffffffff802c4bf0>] ? do_writepages+0x30/0x50
[116419.902276]  [<ffffffff8031a706>] ?
__writeback_single_inode+0xa6/0x3f0
[116419.902305]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[116419.902332]  [<ffffffff8031aeac>] ?
generic_sync_sb_inodes+0x29c/0x3a0
[116419.902361]  [<ffffffff8031b1f5>] ? writeback_inodes+0x75/0x110
[116419.902388]  [<ffffffff802c3fa8>] ? background_writeout+0xb8/0xf0
[116419.902416]  [<ffffffff802c53c1>] ? pdflush+0x151/0x230
[116419.902443]  [<ffffffff802c3ef0>] ? background_writeout+0x0/0xf0
[116419.902472]  [<ffffffff802c5270>] ? pdflush+0x0/0x230
[116419.902502]  [<ffffffff80265d6e>] ? kthread+0x4e/0x90
[116419.902528]  [<ffffffff8020d849>] ? child_rip+0xa/0x11
[116419.902559]  [<ffffffff8052e1c0>] ? _spin_unlock_irq+0x30/0x40
[116419.902588]  [<ffffffff8020cd64>] ? restore_args+0x0/0x30
[116419.902615]  [<ffffffff80265d20>] ? kthread+0x0/0x90
[116419.902640]  [<ffffffff8020d83f>] ? child_rip+0x0/0x11
[116419.902664] Mem-Info:
[116419.902685] Node 0 DMA per-cpu:
[116419.902713] CPU    0: hi:    0, btch:   1 usd:   0
[116419.902738] CPU    1: hi:    0, btch:   1 usd:   0
[116419.902761] Node 0 DMA32 per-cpu:
[116419.902791] CPU    0: hi:  186, btch:  31 usd:  28
[116419.902815] CPU    1: hi:  186, btch:  31 usd:  27
[116419.902841] Active_anon:10553 active_file:47172 inactive_anon:4935
[116419.902844]  inactive_file:342800 unevictable:0 dirty:35963
writeback:5148 unstable:0
[116419.902847]  free:36055 slab:32747 mapped:753 pagetables:2327
bounce:0
[116419.902931] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116419.903010] lowmem_reserve[]: 0 1976 1976 1976
[116419.903079] Node 0 DMA32 free:142728kB min:5664kB low:7080kB
high:8496kB active_anon:42212kB inactive_anon:19740kB
active_file:188688kB inactive_file:1371200kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116419.903155] lowmem_reserve[]: 0 0 0 0
[116419.903225] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116419.903396] Node 0 DMA32: 35413*4kB 1*8kB 8*16kB 4*32kB 3*64kB
3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 142748kB
[116419.903531] 390851 total pagecache pages
[116419.903553] 704 pages in swap cache
[116419.903577] Swap cache stats: add 10504, delete 9800, find
88920/89050
[116419.903603] Free swap  = 1913748kB
[116419.903625] Total swap = 1951800kB
[116419.916522] 522160 pages RAM
[116419.916522] 37425 pages reserved
[116419.916522] 326518 pages shared
[116419.916522] 129291 pages non-shared
[116809.273641] swapper: page allocation failure. order:1, mode:0x4020
[116809.273684] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116809.273709] Call Trace:
[116809.273748]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.273794]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.273820]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.273849]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.273875]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.273902]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.273931]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.273958]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.273984]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.274033]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.274064]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.274103]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.274133]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.274736]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.274764]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.274791]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.274817]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.274843]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.274868]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.274894]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.274918]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.274955]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116809.274989]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.275015]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116809.275043]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116809.275069] Mem-Info:
[116809.275088] Node 0 DMA per-cpu:
[116809.275116] CPU    0: hi:    0, btch:   1 usd:   0
[116809.275139] CPU    1: hi:    0, btch:   1 usd:   0
[116809.275163] Node 0 DMA32 per-cpu:
[116809.275192] CPU    0: hi:  186, btch:  31 usd:  28
[116809.275215] CPU    1: hi:  186, btch:  31 usd:   0
[116809.275248] Active_anon:14659 active_file:1394 inactive_anon:5119
[116809.275250]  inactive_file:390025 unevictable:0 dirty:18876
writeback:3071 unstable:0
[116809.275253]  free:18660 slab:44429 mapped:757 pagetables:2291
bounce:0
[116809.275333] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116809.275402] lowmem_reserve[]: 0 1976 1976 1976
[116809.275458] Node 0 DMA32 free:73148kB min:5664kB low:7080kB
high:8496kB active_anon:58636kB inactive_anon:20476kB
active_file:5576kB inactive_file:1560100kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116809.275539] lowmem_reserve[]: 0 0 0 0
[116809.275596] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116809.275738] Node 0 DMA32: 18028*4kB 112*8kB 1*16kB 0*32kB 0*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 73152kB
[116809.275889] 392307 total pagecache pages
[116809.275926] 704 pages in swap cache
[116809.275948] Swap cache stats: add 10504, delete 9800, find
89821/89951
[116809.275973] Free swap  = 1913748kB
[116809.276000] Total swap = 1951800kB
[116809.276039] 522160 pages RAM
[116809.276039] 37425 pages reserved
[116809.276039] 394179 pages shared
[116809.276039] 78983 pages non-shared
[116809.289171] swapper: page allocation failure. order:1, mode:0x4020
[116809.289207] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116809.289231] Call Trace:
[116809.289251]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.289299]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.289326]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.289359]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.289385]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.289412]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.289446]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.289473]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.289499]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.289553]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.289583]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.289613]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.289646]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.289671]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.289699]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.289732]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.289758]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.289784]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.289815]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.289841]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.289864]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.289914]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116809.289940]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.289971]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116809.289997]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116809.290021] Mem-Info:
[116809.290046] Node 0 DMA per-cpu:
[116809.290073] CPU    0: hi:    0, btch:   1 usd:   0
[116809.290103] CPU    1: hi:    0, btch:   1 usd:   0
[116809.290127] Node 0 DMA32 per-cpu:
[116809.290168] CPU    0: hi:  186, btch:  31 usd:   2
[116809.290192] CPU    1: hi:  186, btch:  31 usd:  17
[116809.290216] Active_anon:14659 active_file:1394 inactive_anon:5119
[116809.290218]  inactive_file:390025 unevictable:0 dirty:18876
writeback:3071 unstable:0
[116809.290221]  free:18616 slab:44493 mapped:757 pagetables:2291
bounce:0
[116809.290307] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116809.290381] lowmem_reserve[]: 0 1976 1976 1976
[116809.290463] Node 0 DMA32 free:72888kB min:5664kB low:7080kB
high:8496kB active_anon:58636kB inactive_anon:20476kB
active_file:5576kB inactive_file:1560100kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116809.290540] lowmem_reserve[]: 0 0 0 0
[116809.290606] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116809.290763] Node 0 DMA32: 17966*4kB 95*8kB 1*16kB 0*32kB 0*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 72768kB
[116809.290932] 392307 total pagecache pages
[116809.290955] 704 pages in swap cache
[116809.290982] Swap cache stats: add 10504, delete 9800, find
89821/89951
[116809.291008] Free swap  = 1913748kB
[116809.291029] Total swap = 1951800kB
[116809.293012] 522160 pages RAM
[116809.293012] 37425 pages reserved
[116809.293012] 394088 pages shared
[116809.293012] 79069 pages non-shared
[116809.308343] swapper: page allocation failure. order:1, mode:0x4020
[116809.308377] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116809.308402] Call Trace:
[116809.308423]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.308467]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.308493]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.308523]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.308550]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.308577]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.308605]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.308634]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.308661]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.308702]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.308733]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.308764]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.308793]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.308819]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.308847]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.308875]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.308901]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.308927]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.308953]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.308980]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.309005]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.309043]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116809.309070]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.309095]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116809.309122]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116809.309147] Mem-Info:
[116809.309167] Node 0 DMA per-cpu:
[116809.309196] CPU    0: hi:    0, btch:   1 usd:   0
[116809.309219] CPU    1: hi:    0, btch:   1 usd:   0
[116809.309242] Node 0 DMA32 per-cpu:
[116809.309270] CPU    0: hi:  186, btch:  31 usd:  49
[116809.309294] CPU    1: hi:  186, btch:  31 usd:   0
[116809.309319] Active_anon:14659 active_file:1394 inactive_anon:5119
[116809.309321]  inactive_file:389905 unevictable:0 dirty:18876
writeback:3071 unstable:0
[116809.309324]  free:18635 slab:44515 mapped:757 pagetables:2291
bounce:0
[116809.309412] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116809.309480] lowmem_reserve[]: 0 1976 1976 1976
[116809.309538] Node 0 DMA32 free:73048kB min:5664kB low:7080kB
high:8496kB active_anon:58636kB inactive_anon:20476kB
active_file:5576kB inactive_file:1559620kB unevictable:0kB
present:2023748kB pages_scanned:33 all_unreclaimable? no
[116809.309616] lowmem_reserve[]: 0 0 0 0
[116809.309673] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116809.309814] Node 0 DMA32: 17997*4kB 119*8kB 1*16kB 0*32kB 0*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 73084kB
[116809.309960] 392214 total pagecache pages
[116809.309987] 704 pages in swap cache
[116809.310016] Swap cache stats: add 10504, delete 9800, find
89821/89951
[116809.310042] Free swap  = 1913748kB
[116809.310068] Total swap = 1951800kB
[116809.312229] 522160 pages RAM
[116809.312229] 37425 pages reserved
[116809.312229] 394111 pages shared
[116809.312229] 79071 pages non-shared
[116809.323440] swapper: page allocation failure. order:1, mode:0x4020
[116809.323476] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116809.323501] Call Trace:
[116809.323521]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.323571]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.323596]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.323629]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.323656]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.323683]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.323717]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.323743]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.323770]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.323814]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.323845]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.323876]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.323909]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.324491]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.324520]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.324553]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.324586]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.324612]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.324643]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.324669]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.324693]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.324737]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116809.324763]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.324794]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116809.324820]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116809.324844] Mem-Info:
[116809.324869] Node 0 DMA per-cpu:
[116809.324905] CPU    0: hi:    0, btch:   1 usd:   0
[116809.324934] CPU    1: hi:    0, btch:   1 usd:   0
[116809.324958] Node 0 DMA32 per-cpu:
[116809.324992] CPU    0: hi:  186, btch:  31 usd:  25
[116809.325015] CPU    1: hi:  186, btch:  31 usd:  53
[116809.325040] Active_anon:14659 active_file:1394 inactive_anon:5119
[116809.325042]  inactive_file:389905 unevictable:0 dirty:18876
writeback:3071 unstable:0
[116809.325045]  free:18571 slab:44558 mapped:757 pagetables:2291
bounce:0
[116809.325130] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116809.325213] lowmem_reserve[]: 0 1976 1976 1976
[116809.325280] Node 0 DMA32 free:72792kB min:5664kB low:7080kB
high:8496kB active_anon:58636kB inactive_anon:20476kB
active_file:5576kB inactive_file:1559620kB unevictable:0kB
present:2023748kB pages_scanned:33 all_unreclaimable? no
[116809.325358] lowmem_reserve[]: 0 0 0 0
[116809.325432] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116809.325595] Node 0 DMA32: 17935*4kB 108*8kB 1*16kB 0*32kB 0*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 72748kB
[116809.325761] 392214 total pagecache pages
[116809.325783] 704 pages in swap cache
[116809.325811] Swap cache stats: add 10504, delete 9800, find
89821/89951
[116809.325838] Free swap  = 1913748kB
[116809.325858] Total swap = 1951800kB
[116809.337024] 522160 pages RAM
[116809.337024] 37425 pages reserved
[116809.337024] 394113 pages shared
[116809.337024] 79132 pages non-shared
[116809.339350] swapper: page allocation failure. order:1, mode:0x4020
[116809.339381] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116809.339423] Call Trace:
[116809.339444]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.339494]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.339520]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.339549]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.339581]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.339608]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.339636]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.339669]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.339695]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.339736]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.339781]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.339812]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.339841]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.339873]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.339902]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.339929]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.339961]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.339986]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.340011]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.340043]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.340067]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.340118]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116809.340144]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.340169]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116809.340201]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116809.340226] Mem-Info:
[116809.340246] Node 0 DMA per-cpu:
[116809.340282] CPU    0: hi:    0, btch:   1 usd:   0
[116809.340306] CPU    1: hi:    0, btch:   1 usd:   0
[116809.340334] Node 0 DMA32 per-cpu:
[116809.340363] CPU    0: hi:  186, btch:  31 usd:  16
[116809.340401] CPU    1: hi:  186, btch:  31 usd:   0
[116809.340426] Active_anon:14659 active_file:1394 inactive_anon:5119
[116809.340429]  inactive_file:389815 unevictable:0 dirty:18876
writeback:3071 unstable:0
[116809.340431]  free:18611 slab:44665 mapped:757 pagetables:2291
bounce:0
[116809.340517] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116809.340592] lowmem_reserve[]: 0 1976 1976 1976
[116809.340668] Node 0 DMA32 free:72952kB min:5664kB low:7080kB
high:8496kB active_anon:58636kB inactive_anon:20476kB
active_file:5576kB inactive_file:1559260kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116809.340740] lowmem_reserve[]: 0 0 0 0
[116809.340807] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116809.340975] Node 0 DMA32: 17945*4kB 114*8kB 1*16kB 0*32kB 0*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 72836kB
[116809.341160] 392121 total pagecache pages
[116809.341183] 704 pages in swap cache
[116809.341205] Swap cache stats: add 10504, delete 9800, find
89821/89951
[116809.341237] Free swap  = 1913748kB
[116809.341259] Total swap = 1951800kB
[116809.342446] 522160 pages RAM
[116809.342446] 37425 pages reserved
[116809.342446] 394015 pages shared
[116809.342446] 79247 pages non-shared
[116809.354340] swapper: page allocation failure. order:1, mode:0x4020
[116809.354371] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116809.354397] Call Trace:
[116809.354426]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.354477]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.354503]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.354536]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.354563]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.354590]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.354625]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.354653]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.354680]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.354725]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.354755]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.354795]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.354829]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.354856]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.354884]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.354916]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.354942]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.354969]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.355000]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.355027]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.355050]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.355094]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116809.355128]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.355161]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116809.355187]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116809.355212] Mem-Info:
[116809.355238] Node 0 DMA per-cpu:
[116809.355266] CPU    0: hi:    0, btch:   1 usd:   0
[116809.355295] CPU    1: hi:    0, btch:   1 usd:   0
[116809.355319] Node 0 DMA32 per-cpu:
[116809.355352] CPU    0: hi:  186, btch:  31 usd:   7
[116809.355377] CPU    1: hi:  186, btch:  31 usd:  30
[116809.355409] Active_anon:14659 active_file:1394 inactive_anon:5119
[116809.355411]  inactive_file:389815 unevictable:0 dirty:18876
writeback:3071 unstable:0
[116809.355414]  free:18546 slab:44729 mapped:757 pagetables:2291
bounce:0
[116809.355501] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116809.355576] lowmem_reserve[]: 0 1976 1976 1976
[116809.355644] Node 0 DMA32 free:72692kB min:5664kB low:7080kB
high:8496kB active_anon:58636kB inactive_anon:20476kB
active_file:5576kB inactive_file:1559260kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116809.355731] lowmem_reserve[]: 0 0 0 0
[116809.355805] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116809.355969] Node 0 DMA32: 17883*4kB 101*8kB 1*16kB 0*32kB 0*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 72484kB
[116809.356130] 392121 total pagecache pages
[116809.356152] 704 pages in swap cache
[116809.356190] Swap cache stats: add 10504, delete 9800, find
89821/89951
[116809.356216] Free swap  = 1913748kB
[116809.356238] Total swap = 1951800kB
[116809.357787] 522160 pages RAM
[116809.357787] 37425 pages reserved
[116809.357787] 393894 pages shared
[116809.357787] 79340 pages non-shared
[116809.369472] swapper: page allocation failure. order:1, mode:0x4020
[116809.369502] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116809.369529] Call Trace:
[116809.369560]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.369604]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.369636]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.369664]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.369690]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.369724]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.369753]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.369780]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.369813]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.369854]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.369884]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.369921]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.369949]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.370551]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.370583]  [<ffffffff8047d157>] ? __kfree_skb+0x47/0xa0
[116809.370611]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.370639]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.370671]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.370705]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.370731]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.370763]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.370787]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.370831]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116809.370858]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116809.370883]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116809.370916]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116809.370940] Mem-Info:
[116809.370960] Node 0 DMA per-cpu:
[116809.371001] CPU    0: hi:    0, btch:   1 usd:   0
[116809.371024] CPU    1: hi:    0, btch:   1 usd:   0
[116809.371053] Node 0 DMA32 per-cpu:
[116809.371082] CPU    0: hi:  186, btch:  31 usd:  17
[116809.371111] CPU    1: hi:  186, btch:  31 usd:   0
[116809.371136] Active_anon:14659 active_file:1394 inactive_anon:5119
[116809.371139]  inactive_file:389780 unevictable:0 dirty:18876
writeback:3071 unstable:0
[116809.371142]  free:18524 slab:44815 mapped:757 pagetables:2291
bounce:0
[116809.371228] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116809.371303] lowmem_reserve[]: 0 1976 1976 1976
[116809.371381] Node 0 DMA32 free:72604kB min:5664kB low:7080kB
high:8496kB active_anon:58636kB inactive_anon:20476kB
active_file:5576kB inactive_file:1559120kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116809.371454] lowmem_reserve[]: 0 0 0 0
[116809.371528] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116809.371696] Node 0 DMA32: 17893*4kB 114*8kB 1*16kB 0*32kB 0*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 72628kB
[116809.371873] 392059 total pagecache pages
[116809.371896] 704 pages in swap cache
[116809.371918] Swap cache stats: add 10504, delete 9800, find
89821/89951
[116809.371950] Free swap  = 1913748kB
[116809.371971] Total swap = 1951800kB
[116809.372831] 522160 pages RAM
[116809.372831] 37425 pages reserved
[116809.372831] 393797 pages shared
[116809.372831] 79424 pages non-shared
[116809.389158] events/0: page allocation failure. order:1, mode:0x4020
[116809.389195] Pid: 9, comm: events/0 Not tainted 2.6.28-rc7 #3
[116809.389221] Call Trace:
[116809.389243]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116809.389296]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116809.389333]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116809.389370]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.389397]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.389424]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116809.389459]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116809.389486]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116809.389513]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116809.389562]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116809.389592]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116809.389623]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116809.389656]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116809.389682]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116809.389719]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116809.389753]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116809.389779]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116809.389804]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116809.389836]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116809.389862]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116809.389886]  <EOI>  [<ffffffff80495f05>] ? queue_process+0xe5/0x160
[116809.389930]  [<ffffffff80495f09>] ? queue_process+0xe9/0x160
[116809.389957]  [<ffffffff80495e20>] ? queue_process+0x0/0x160
[116809.389990]  [<ffffffff80261534>] ? run_workqueue+0x104/0x240
[116809.390018]  [<ffffffff802614e2>] ? run_workqueue+0xb2/0x240
[116809.390053]  [<ffffffff8026189f>] ? worker_thread+0xaf/0x130
[116809.390087]  [<ffffffff802661c0>] ?
autoremove_wake_function+0x0/0x40
[116809.390114]  [<ffffffff802617f0>] ? worker_thread+0x0/0x130
[116809.390141]  [<ffffffff80265d6e>] ? kthread+0x4e/0x90
[116809.390172]  [<ffffffff8020d849>] ? child_rip+0xa/0x11
[116809.390198]  [<ffffffff8020cd64>] ? restore_args+0x0/0x30
[116809.390224]  [<ffffffff80265d20>] ? kthread+0x0/0x90
[116809.390254]  [<ffffffff8020d83f>] ? child_rip+0x0/0x11
[116969.994551] swapper: page allocation failure. order:1, mode:0x4020
[116969.994595] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116969.994621] Call Trace:
[116969.994642]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116969.994687]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116969.994713]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116969.994741]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116969.994769]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116969.994796]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116969.994823]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116969.994850]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116969.994877]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116969.994923]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116969.994953]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116969.994984]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116969.995012]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116969.995039]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116969.995069]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116969.995096]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116969.995122]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116969.995147]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116969.995172]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116969.995200]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116969.995225]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116969.995262]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116969.995289]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116969.995315]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116969.995341]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116969.995365] Mem-Info:
[116969.995386] Node 0 DMA per-cpu:
[116969.995415] CPU    0: hi:    0, btch:   1 usd:   0
[116969.995439] CPU    1: hi:    0, btch:   1 usd:   0
[116969.995462] Node 0 DMA32 per-cpu:
[116969.995490] CPU    0: hi:  186, btch:  31 usd:   0
[116969.995514] CPU    1: hi:  186, btch:  31 usd:   0
[116969.995540] Active_anon:15548 active_file:2650 inactive_anon:5247
[116969.995542]  inactive_file:370800 unevictable:0 dirty:20048
writeback:3434 unstable:0
[116969.995545]  free:39798 slab:40301 mapped:725 pagetables:2297
bounce:0
[116969.995626] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116969.995695] lowmem_reserve[]: 0 1976 1976 1976
[116969.995770] Node 0 DMA32 free:157616kB min:5664kB low:7080kB
high:8496kB active_anon:62192kB inactive_anon:20988kB
active_file:10600kB inactive_file:1483200kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116969.995842] lowmem_reserve[]: 0 0 0 0
[116969.995910] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116969.996072] Node 0 DMA32: 39144*4kB 28*8kB 13*16kB 1*32kB 1*64kB
2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 157616kB
[116969.996237] 374321 total pagecache pages
[116969.996259] 704 pages in swap cache
[116969.996280] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116969.996312] Free swap  = 1913748kB
[116969.996334] Total swap = 1951800kB
[116969.998448] 522160 pages RAM
[116969.998448] 37425 pages reserved
[116969.998448] 342755 pages shared
[116969.998448] 109288 pages non-shared
[116970.009917] swapper: page allocation failure. order:1, mode:0x4020
[116970.009948] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116970.009973] Call Trace:
[116970.009999]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116970.010043]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116970.010075]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116970.010104]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.010130]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.010164]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116970.010192]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.010219]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116970.010252]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116970.010291]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116970.010322]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116970.010359]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116970.010388]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116970.010414]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116970.010447]  [<ffffffff802a98b0>] ?
__rcu_process_callbacks+0x10/0x330
[116970.010477]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116970.010504]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116970.010537]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116970.010562]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116970.010587]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116970.010619]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116970.010643]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.010686]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116970.010713]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.010739]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116970.010771]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116970.010796] Mem-Info:
[116970.010815] Node 0 DMA per-cpu:
[116970.010849] CPU    0: hi:    0, btch:   1 usd:   0
[116970.010873] CPU    1: hi:    0, btch:   1 usd:   0
[116970.010902] Node 0 DMA32 per-cpu:
[116970.010930] CPU    0: hi:  186, btch:  31 usd:   4
[116970.010959] CPU    1: hi:  186, btch:  31 usd:  17
[116970.010985] Active_anon:15548 active_file:2650 inactive_anon:5247
[116970.010987]  inactive_file:370800 unevictable:0 dirty:20048
writeback:3434 unstable:0
[116970.010990]  free:39756 slab:40301 mapped:725 pagetables:2297
bounce:0
[116970.011077] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116970.011152] lowmem_reserve[]: 0 1976 1976 1976
[116970.011227] Node 0 DMA32 free:157448kB min:5664kB low:7080kB
high:8496kB active_anon:62192kB inactive_anon:20988kB
active_file:10600kB inactive_file:1483200kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116970.011300] lowmem_reserve[]: 0 0 0 0
[116970.011367] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116970.011525] Node 0 DMA32: 39128*4kB 13*8kB 9*16kB 2*32kB 1*64kB
2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 157400kB
[116970.011685] 374352 total pagecache pages
[116970.011708] 704 pages in swap cache
[116970.011730] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116970.011761] Free swap  = 1913748kB
[116970.011783] Total swap = 1951800kB
[116970.013440] 522160 pages RAM
[116970.013440] 37425 pages reserved
[116970.013440] 342660 pages shared
[116970.013440] 109324 pages non-shared
[116970.025833] swapper: page allocation failure. order:1, mode:0x4020
[116970.025867] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116970.025893] Call Trace:
[116970.025927]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116970.025974]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116970.026006]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116970.026035]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.026062]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.026097]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116970.026126]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.026155]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116970.026188]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116970.026232]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116970.026263]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116970.026301]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116970.026331]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116970.026357]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116970.026389]  [<ffffffff8047d157>] ? __kfree_skb+0x47/0xa0
[116970.026419]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116970.026446]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116970.026478]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116970.026506]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116970.026532]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116970.026564]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116970.026590]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.026633]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116970.026661]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.026687]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116970.026720]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116970.026746] Mem-Info:
[116970.026766] Node 0 DMA per-cpu:
[116970.026801] CPU    0: hi:    0, btch:   1 usd:   0
[116970.026824] CPU    1: hi:    0, btch:   1 usd:   0
[116970.026853] Node 0 DMA32 per-cpu:
[116970.026882] CPU    0: hi:  186, btch:  31 usd:  19
[116970.026911] CPU    1: hi:  186, btch:  31 usd:   0
[116970.026936] Active_anon:15548 active_file:2650 inactive_anon:5247
[116970.026939]  inactive_file:370686 unevictable:0 dirty:20048
writeback:3434 unstable:0
[116970.026941]  free:39750 slab:40417 mapped:725 pagetables:2297
bounce:0
[116970.027028] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116970.027101] lowmem_reserve[]: 0 1976 1976 1976
[116970.027170] Node 0 DMA32 free:157508kB min:5664kB low:7080kB
high:8496kB active_anon:62192kB inactive_anon:20988kB
active_file:10600kB inactive_file:1482744kB unevictable:0kB
present:2023748kB pages_scanned:32 all_unreclaimable? no
[116970.027243] lowmem_reserve[]: 0 0 0 0
[116970.027311] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116970.027475] Node 0 DMA32: 39113*4kB 15*8kB 12*16kB 5*32kB 1*64kB
2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 157500kB
[116970.027639] 374259 total pagecache pages
[116970.027662] 704 pages in swap cache
[116970.027685] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116970.027716] Free swap  = 1913748kB
[116970.027738] Total swap = 1951800kB
[116970.028490] 522160 pages RAM
[116970.028490] 37425 pages reserved
[116970.028490] 342682 pages shared
[116970.028490] 109426 pages non-shared
[116970.042001] swapper: page allocation failure. order:1, mode:0x4020
[116970.042032] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116970.042063] Call Trace:
[116970.042084]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116970.042133]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116970.042160]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116970.042188]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.042221]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.042249]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116970.042277]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.042310]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116970.042337]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116970.042377]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116970.042414]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116970.042445]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116970.042472]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116970.042504]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116970.042533]  [<ffffffff802a98b0>] ?
__rcu_process_callbacks+0x10/0x330
[116970.042563]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116970.042596]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116970.042622]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116970.042648]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116970.042680]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116970.042707]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116970.042732]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.042776]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116970.042803]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.042835]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116970.042863]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116970.042889] Mem-Info:
[116970.042915] Node 0 DMA per-cpu:
[116970.042944] CPU    0: hi:    0, btch:   1 usd:   0
[116970.042974] CPU    1: hi:    0, btch:   1 usd:   0
[116970.042998] Node 0 DMA32 per-cpu:
[116970.043032] CPU    0: hi:  186, btch:  31 usd:  19
[116970.043056] CPU    1: hi:  186, btch:  31 usd:  23
[116970.043082] Active_anon:15548 active_file:2650 inactive_anon:5247
[116970.043084]  inactive_file:370686 unevictable:0 dirty:20048
writeback:3434 unstable:0
[116970.043087]  free:39708 slab:40438 mapped:725 pagetables:2297
bounce:0
[116970.043177] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116970.043252] lowmem_reserve[]: 0 1976 1976 1976
[116970.043323] Node 0 DMA32 free:157340kB min:5664kB low:7080kB
high:8496kB active_anon:62192kB inactive_anon:20988kB
active_file:10600kB inactive_file:1482744kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116970.043403] lowmem_reserve[]: 0 0 0 0
[116970.043471] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116970.043630] Node 0 DMA32: 39081*4kB 16*8kB 10*16kB 5*32kB 1*64kB
2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 157348kB
[116970.043797] 374259 total pagecache pages
[116970.043819] 704 pages in swap cache
[116970.043847] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116970.043875] Free swap  = 1913748kB
[116970.043896] Total swap = 1951800kB
[116970.045209] 522160 pages RAM
[116970.045209] 37425 pages reserved
[116970.045209] 342683 pages shared
[116970.045209] 109433 pages non-shared
[116970.056966] swapper: page allocation failure. order:1, mode:0x4020
[116970.056997] Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #3
[116970.057037] Call Trace:
[116970.057058]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116970.057122]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116970.057149]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116970.057176]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.057203]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.057231]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116970.057260]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.057288]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116970.057315]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116970.057356]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116970.057387]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116970.057419]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[116970.057448]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[116970.057475]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[116970.057501]  [<ffffffff8047d157>] ? __kfree_skb+0x47/0xa0
[116970.057529]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[116970.057557]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[116970.057583]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116970.057610]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116970.057635]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[116970.057660]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[116970.057685]  <EOI>  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.057723]  [<ffffffff80214aac>] ? mwait_idle+0x4c/0x60
[116970.057749]  [<ffffffff80214aa3>] ? mwait_idle+0x43/0x60
[116970.057775]  [<ffffffff8020b00b>] ? cpu_idle+0x6b/0xc0
[116970.057802]  [<ffffffff80519386>] ? rest_init+0x66/0x70
[116970.057828] Mem-Info:
[116970.057848] Node 0 DMA per-cpu:
[116970.057897] CPU    0: hi:    0, btch:   1 usd:   0
[116970.057922] CPU    1: hi:    0, btch:   1 usd:   0
[116970.057945] Node 0 DMA32 per-cpu:
[116970.057973] CPU    0: hi:  186, btch:  31 usd:  30
[116970.057996] CPU    1: hi:  186, btch:  31 usd:  53
[116970.058022] Active_anon:15548 active_file:2650 inactive_anon:5247
[116970.058024]  inactive_file:370686 unevictable:0 dirty:20048
writeback:3434 unstable:0
[116970.058027]  free:39644 slab:40459 mapped:725 pagetables:2297
bounce:0
[116970.058108] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[116970.058178] lowmem_reserve[]: 0 1976 1976 1976
[116970.058238] Node 0 DMA32 free:157084kB min:5664kB low:7080kB
high:8496kB active_anon:62192kB inactive_anon:20988kB
active_file:10600kB inactive_file:1482744kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116970.058312] lowmem_reserve[]: 0 0 0 0
[116970.058368] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116970.058527] Node 0 DMA32: 39019*4kB 16*8kB 10*16kB 3*32kB 1*64kB
2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 157036kB
[116970.058692] 374259 total pagecache pages
[116970.058714] 704 pages in swap cache
[116970.058736] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116970.058768] Free swap  = 1913748kB
[116970.058790] Total swap = 1951800kB
[116970.060600] 522160 pages RAM
[116970.060600] 37425 pages reserved
[116970.060600] 342683 pages shared
[116970.060600] 109462 pages non-shared
[116970.072341] events/0: page allocation failure. order:1, mode:0x4020
[116970.072376] Pid: 9, comm: events/0 Not tainted 2.6.28-rc7 #3
[116970.072401] Call Trace:
[116970.072424]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116970.072474]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116970.072500]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116970.072535]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.072561]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.072589]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
0*512kB 0*1024kB 0*2048kB 0*4096kB = 156968kB
[116970.074985] 374188 total pagecache pages
[116970.075007] 704 pages in swap cache
[116970.075028] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116970.075055] Free swap  = 1913748kB
[116970.075075] Total swap = 1951800kB
[116970.076005] 522160 pages RAM
[116970.076005] 37425 pages reserved
[116970.076005] 342574 pages shared
[116970.076005] 109495 pages non-shared
[116970.088825] events/0: page allocation failure. order:1, mode:0x4020
[116970.088903]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116970.088947]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116970.088974]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116970.089127]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[116970.089154]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[116970.089196]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[116970.089225]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[116970.089430]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[116970.089456]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[116970.089482]  [<ffffffff8022286d>] smp_apic_timer_interrupt+0x8d/0xd0
[116970.089510]  [<ffffffff8020d5c0>] apic_timer_interrupt+0x70/0x80
[116970.089535]  <EOI>  [<ffffffff8052e214>] ?
_spin_unlock_irqrestore+0x44/0x70
[116970.089575]  [<ffffffff8052e217>] ?
_spin_unlock_irqrestore+0x47/0x70
[116970.089602]  [<ffffffff8047cca3>] ? skb_dequeue+0x63/0x80
[116970.089628]  [<ffffffff80495e61>] ? queue_process+0x41/0x160
[116970.089655]  [<ffffffff80495e20>] ? queue_process+0x0/0x160
[116970.089682]  [<ffffffff80261534>] ? run_workqueue+0x104/0x240
[116970.089709]  [<ffffffff802614e2>] ? run_workqueue+0xb2/0x240
[116970.089735]  [<ffffffff8026189f>] ? worker_thread+0xaf/0x130
[116970.089763]  [<ffffffff802661c0>] ?
autoremove_wake_function+0x0/0x40
[116970.089789]  [<ffffffff802617f0>] ? worker_thread+0x0/0x130
DMA per-cpu:
[116970.089991] CPU    0: hi:    0, btch:   1 usd:   0
[116970.090026] CPU    1: hi:    0, btch:   1 usd:   0
[116970.090050] Node 0 DMA32 per-cpu:
[116970.090078] CPU    0: hi:  186, btch:  31 usd:  30
[116970.090108] CPU    1: hi:  186, btch:  31 usd:   0
[116970.090132] Active_anon:15548 active_file:2650 inactive_anon:5247
[116970.090135]  inactive_file:370640 unevictable:0 dirty:20067
writeback:3453 unstable:0
[116970.090138]  free:39658 slab:40558 mapped:728 pagetables:2297
bounce:0
[116970.090224] Node 0 [116970.090293] lowmem_reserve[]: 0 1976 1976
[116970.090362] Node 0 DMA32 free:157140kB min:5664kB low:7080kB
high:8496kB active_anon:62192kB inactive_anon:20988kB
active_file:10600kB inactive_file:1482560kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[116970.090441] lowmem_reserve[]: 0
[116970.090519] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[116970.090679] Node 0 DMA32: 39016*4kB 13*8kB 15*16kB 4*32kB 1*64kB
2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 157112kB
[116970.090845] 374188 total pagecache pages
[116970.090873] 704 pages in swap cache
[116970.090895] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116970.090920] Free swap  = 1913748kB
[116970.090947] Total swap = 1951800kB
[116970.092005] 522160 pages RAM
[116970.092005] 37425 pages reserved
[116970.092005] 342574 pages shared
[116970.092005] 109605 pages non-shared
[116970.104297] events/0: page allocation failure. order:1, mode:0x4020
[116970.104329] Pid: 9, comm: events/0 Not tainted 2.6.28-rc7 #3
[116970.104354] Call Trace:
[116970.104374]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[116970.104419]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[116970.104445]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[116970.104474]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.104500]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[116970.104528]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[116970.104557]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
38894*4kB 18*8kB 22*16kB 0*32kB 0*64kB 2*128kB 1*256kB 0*512kB 0*1024kB
0*2048kB 0*4096kB = 156584kB
[116970.143154] 373816 total pagecache pages
[116970.143183] 704 pages in swap cache
[116970.143204] Swap cache stats: add 10504, delete 9800, find
89979/90109
[116970.143238] Free swap  = 1913748kB
[116970.143267] Total swap = 1951800kB
[116970.144013] 522160 pages RAM
[116970.144013] 37425 pages reserved
[116970.144013] 342191 pages shared
[116970.144013] 110098 pages non-shared
[117077.504668] __ratelimit: 820 callbacks suppressed
[117077.504708] xfsbufd: page allocation failure. order:1, mode:0x4020
[117077.504737] Pid: 2584, comm: xfsbufd Not tainted 2.6.28-rc7 #3
[117077.504762] Call Trace:
[117077.504784]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[117077.504830]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[117077.504857]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[117077.504885]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117077.504912]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117077.504939]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[117077.504967]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117077.504994]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[117077.505020]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[117077.505064]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[117077.505095]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[117077.505125]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[117077.505153]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[117077.505179]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[117077.505208]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[117077.505235]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[117077.505261]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[117077.505287]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[117077.505312]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[117077.505338]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[117077.505363]  <EOI>  [<ffffffff8052e1c0>] ?
_spin_unlock_irq+0x30/0x40
[117077.505405]  [<ffffffff8052e1c5>] ? _spin_unlock_irq+0x35/0x40
[117077.505435]  [<ffffffff802425cf>] ? finish_task_switch+0x5f/0x120
[117077.505462]  [<ffffffff80242570>] ? finish_task_switch+0x0/0x120
[117077.505492]  [<ffffffff8052b25b>] ? thread_return+0x3d/0x5b2
[117077.505520]  [<ffffffff8027864d>] ? trace_hardirqs_on+0xd/0x10
[117077.505547]  [<ffffffff80259503>] ? __mod_timer+0xc3/0xe0
[117077.505576]  [<ffffffff8052bc23>] ? schedule_timeout+0x63/0xd0
[117077.505602]  [<ffffffff80258db0>] ? process_timeout+0x0/0x10
[117077.505628]  [<ffffffff8052bc1e>] ? schedule_timeout+0x5e/0xd0
[117077.505655]  [<ffffffff8052bcee>] ?
schedule_timeout_interruptible+0x1e/0x20
[117077.505709]  [<ffffffffa0223b22>] ? xfsbufd+0x82/0x190 [xfs]
[117077.505749]  [<ffffffffa0223aa0>] ? xfsbufd+0x0/0x190 [xfs]
[117077.505777]  [<ffffffff80265d6e>] ? kthread+0x4e/0x90
[117077.505802]  [<ffffffff8020d849>] ? child_rip+0xa/0x11
[117077.505828]  [<ffffffff8020cd64>] ? restore_args+0x0/0x30
[117077.505854]  [<ffffffff80265d20>] ? kthread+0x0/0x90
[117077.505879]  [<ffffffff8020d83f>] ? child_rip+0x0/0x11
[117077.505905] Mem-Info:
[117077.505925] Node 0 DMA per-cpu:
[117077.505955] CPU    0: hi:    0, btch:   1 usd:   0
[117077.505978] CPU    1: hi:    0, btch:   1 usd:   0
[117077.506001] Node 0 DMA32 per-cpu:
[117077.506031] CPU    0: hi:  186, btch:  31 usd:   0
[117077.506054] CPU    1: hi:  186, btch:  31 usd: 174
[117077.506080] Active_anon:16054 active_file:4050 inactive_anon:5410
[117077.506082]  inactive_file:411093 unevictable:0 dirty:22417
writeback:6875 unstable:0
[117077.506085]  free:6782 slab:30625 mapped:1893 pagetables:2433
bounce:0
[117077.506165] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? yes
[117077.506233] lowmem_reserve[]: 0 1976 1976 1976
[117077.506292] Node 0 DMA32 free:25888kB min:5664kB low:7080kB
high:8496kB active_anon:64216kB inactive_anon:21640kB
active_file:16200kB inactive_file:1644116kB unevictable:0kB
present:2023748kB pages_scanned:32 all_unreclaimable? no
[117077.506966] lowmem_reserve[]: 0 0 0 0
[117077.507051] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[117077.507185] Node 0 DMA32: 6005*4kB 3*8kB 13*16kB 51*32kB 4*64kB
1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 26780kB
[117077.507318] 415715 total pagecache pages
[117077.507365] 704 pages in swap cache
[117077.507388] Swap cache stats: add 10504, delete 9800, find
90392/90522
[117077.507415] Free swap  = 1913748kB
[117077.507436] Total swap = 1951800kB
[117077.512528] 522160 pages RAM
[117077.512528] 37425 pages reserved
[117077.512528] 346257 pages shared
[117077.512528] 138798 pages non-shared
[117077.565103] ssh: page allocation failure. order:1, mode:0x4020
[117077.565148] Pid: 20780, comm: ssh Not tainted 2.6.28-rc7 #3
[117077.565174] Call Trace:
[117077.565197]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[117077.565247]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[117077.565274]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[117077.565304]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117077.565332]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117077.565360]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[117077.565389]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117077.565417]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[117077.565443]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[117077.565492]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[117077.565523]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[117077.565555]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[117077.565584]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[117077.565611]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[117077.565641]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[117077.565669]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[117077.565697]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[117077.565722]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[117077.565748]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[117077.565774]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[117077.565800]  <EOI> <6>Mem-Info:
[117077.565833] Node 0 DMA per-cpu:
[117077.565863] CPU    0: hi:    0, btch:   1 usd:   0
[117077.565886] CPU    1: hi:    0, btch:   1 usd:   0
[117077.565910] Node 0 DMA32 per-cpu:
[117077.565940] CPU    0: hi:  186, btch:  31 usd:   0
[117077.565965] CPU    1: hi:  186, btch:  31 usd:  23
[117077.565991] Active_anon:16054 active_file:4050 inactive_anon:5410
[117077.565993]  inactive_file:410537 unevictable:0 dirty:19038
writeback:10471 unstable:0
[117077.565996]  free:6178 slab:31959 mapped:1893 pagetables:2433
bounce:0
[117077.566079] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? no
[117077.566150] lowmem_reserve[]: 0 1976 1976 1976
[117077.566212] Node 0 DMA32 free:23220kB min:5664kB low:7080kB
high:8496kB active_anon:64216kB inactive_anon:21640kB
active_file:16200kB inactive_file:1642148kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[117077.566286] lowmem_reserve[]: 0 0 0 0
[117077.566347] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[117077.566487] Node 0 DMA32: 5520*4kB 8*8kB 26*16kB 0*32kB 0*64kB
0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 23072kB
[117077.566629] 415467 total pagecache pages
[117077.566652] 704 pages in swap cache
[117077.566676] Swap cache stats: add 10504, delete 9800, find
90392/90522
[117077.566701] Free swap  = 1913748kB
[117077.566724] Total swap = 1951800kB
[117077.576525] 522160 pages RAM
[117077.576525] 37425 pages reserved
[117077.576525] 345789 pages shared
[117077.576525] 140102 pages non-shared
[117209.360180] ssh: page allocation failure. order:1, mode:0x4020
[117209.360224] Pid: 20780, comm: ssh Not tainted 2.6.28-rc7 #3
[117209.360251] Call Trace:
[117209.360273]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[117209.360320]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[117209.360347]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[117209.360375]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117209.360403]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117209.360431]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[117209.360460]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117209.360488]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[117209.360515]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[117209.360563]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[117209.360595]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[117209.360627]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[117209.360656]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[117209.360683]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[117209.360713]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[117209.360742]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[117209.360770]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[117209.360798]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[117209.360823]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[117209.360850]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[117209.360875]  <EOI> <6>Mem-Info:
[117209.360906] Node 0 DMA per-cpu:
[117209.360936] CPU    0: hi:    0, btch:   1 usd:   0
[117209.360960] CPU    1: hi:    0, btch:   1 usd:   0
[117209.360983] Node 0 DMA32 per-cpu:
[117209.361013] CPU    0: hi:  186, btch:  31 usd:  42
[117209.361038] CPU    1: hi:  186, btch:  31 usd: 139
[117209.361063] Active_anon:15649 active_file:3981 inactive_anon:6258
[117209.361066]  inactive_file:409677 unevictable:0 dirty:20193
writeback:7616 unstable:0
[117209.361068]  free:6964 slab:31456 mapped:1974 pagetables:2449
bounce:0
[117209.361152] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? yes
[117209.361222] lowmem_reserve[]: 0 1976 1976 1976
[117209.361283] Node 0 DMA32 free:26364kB min:5664kB low:7080kB
high:8496kB active_anon:62596kB inactive_anon:25032kB
active_file:15924kB inactive_file:1638708kB unevictable:0kB
present:2023748kB pages_scanned:0 all_unreclaimable? no
[117209.361357] lowmem_reserve[]: 0 0 0 0
[117209.361415] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[117209.361580] Node 0 DMA32: 6292*4kB 1*8kB 0*16kB 1*32kB 7*64kB
4*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 26168kB
[117209.361715] 414482 total pagecache pages
[117209.361738] 704 pages in swap cache
[117209.361760] Swap cache stats: add 10504, delete 9800, find
90724/90854
[117209.361786] Free swap  = 1913748kB
[117209.361808] Total swap = 1951800kB
[117209.372521] 522160 pages RAM
[117209.372521] 37425 pages reserved
[117209.372521] 333733 pages shared
[117209.372521] 151557 pages non-shared
[117214.136641] rsync: page allocation failure. order:1, mode:0x4020
[117214.136690] Pid: 20801, comm: rsync Not tainted 2.6.28-rc7 #3
[117214.136716] Call Trace:
[117214.136737]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[117214.136783]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[117214.136809]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[117214.136838]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117214.136865]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117214.136892]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[117214.136920]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117214.136946]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[117214.136972]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[117214.137024]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[117214.137055]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[117214.137087]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[117214.137116]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[117214.137141]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[117214.137171]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[117214.137200]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[117214.137229]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[117214.137257]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[117214.137283]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[117214.137310]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[117214.137334]  <EOI>  [<ffffffff802c1635>] ?
get_page_from_freelist+0x575/0x830
[117214.137381]  [<ffffffff802c1638>] ?
get_page_from_freelist+0x578/0x830
[117214.137411]  [<ffffffff802c19e3>] ?
__alloc_pages_internal+0xf3/0x530
[117214.137438]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[117214.137467]  [<ffffffff802e698d>] ? alloc_pages_current+0xad/0x110
[117214.137494]  [<ffffffff802bae97>] ? __page_cache_alloc+0x67/0x80
[117214.137522]  [<ffffffff802c5788>] ?
__do_page_cache_readahead+0x138/0x250
[117214.137550]  [<ffffffff802c571a>] ?
__do_page_cache_readahead+0xca/0x250
[117214.137580]  [<ffffffff802c5c5b>] ? ondemand_readahead+0x1cb/0x250
[117214.137608]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[117214.137635]  [<ffffffff802c5d89>] ?
page_cache_async_readahead+0xa9/0xc0
[117214.137664]  [<ffffffff802bd107>] ?
generic_file_aio_read+0x447/0x6c0
[117214.137722]  [<ffffffffa01fcae5>] ? xfs_ilock+0x75/0xb0 [xfs]
[117214.137764]  [<ffffffffa0229aff>] ? xfs_read+0x12f/0x2c0 [xfs]
[117214.137806]  [<ffffffffa0224e46>] ? xfs_file_aio_read+0x56/0x60
[xfs]
[117214.137834]  [<ffffffff802faa99>] ? do_sync_read+0xf9/0x140
[117214.137863]  [<ffffffff802661c0>] ?
autoremove_wake_function+0x0/0x40
[117214.137891]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[117214.137919]  [<ffffffff80374e29>] ? cap_file_permission+0x9/0x10
[117214.137948]  [<ffffffff80373d66>] ?
security_file_permission+0x16/0x20
[117214.137978]  [<ffffffff802fb2d8>] ? vfs_read+0xc8/0x180
[117214.138003]  [<ffffffff802fb495>] ? sys_read+0x55/0x90
[117214.138029]  [<ffffffff8020c6ab>] ? system_call_fastpath+0x16/0x1b
[117214.138056] Mem-Info:
[117214.138076] Node 0 DMA per-cpu:
[117214.138108] CPU    0: hi:    0, btch:   1 usd:   0
[117214.138133] CPU    1: hi:    0, btch:   1 usd:   0
[117214.138157] Node 0 DMA32 per-cpu:
[117214.138186] CPU    0: hi:  186, btch:  31 usd:  95
[117214.138210] CPU    1: hi:  186, btch:  31 usd:  29
[117214.138236] Active_anon:15649 active_file:4166 inactive_anon:6258
[117214.138239]  inactive_file:408129 unevictable:0 dirty:20418
writeback:7053 unstable:0
[117214.138241]  free:9497 slab:30282 mapped:1975 pagetables:2449
bounce:0
[117214.138921] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? yes
[117214.138992] lowmem_reserve[]: 0 1976 1976 1976
[117214.139049] Node 0 DMA32 free:36412kB min:5664kB low:7080kB
high:8496kB active_anon:62596kB inactive_anon:25032kB
active_file:16664kB inactive_file:1632516kB unevictable:0kB
present:2023748kB pages_scanned:64 all_unreclaimable? no
[117214.139125] lowmem_reserve[]: 0 0 0 0
[117214.139195] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[117214.139354] Node 0 DMA32: 8817*4kB 1*8kB 0*16kB 8*32kB 1*64kB
1*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 36236kB
[117214.139519] 413193 total pagecache pages
[117214.139542] 704 pages in swap cache
[117214.139569] Swap cache stats: add 10504, delete 9800, find
90724/90854
[117214.139596] Free swap  = 1913748kB
[117214.139618] Total swap = 1951800kB
[117214.140011] 522160 pages RAM
[117214.140011] 37425 pages reserved
[117214.140011] 333560 pages shared
[117214.140011] 149934 pages non-shared
[117509.829709] ssh: page allocation failure. order:1, mode:0x4020
[117509.829758] Pid: 20780, comm: ssh Not tainted 2.6.28-rc7 #3
[117509.829784] Call Trace:
[117509.829806]  <IRQ>  [<ffffffff802c1cfe>]
__alloc_pages_internal+0x40e/0x530
[117509.829856]  [<ffffffff802f14a4>] new_slab+0x274/0x350
[117509.829882]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
[117509.829911]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117509.829939]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117509.829966]  [<ffffffff802f3b14>]
__kmalloc_node_track_caller+0x94/0x110
[117509.829995]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
[117509.830022]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
[117509.830049]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
[117509.830107]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
[117509.830139]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
[r8169]
[117509.830171]  [<ffffffffa00dad31>] rtl8169_poll+0x41/0x260 [r8169]
[117509.830202]  [<ffffffff80487feb>] net_rx_action+0x17b/0x290
[117509.830228]  [<ffffffff80487f72>] ? net_rx_action+0x102/0x290
[117509.830258]  [<ffffffff8025399c>] __do_softirq+0xac/0x190
[117509.830287]  [<ffffffff8020dbac>] call_softirq+0x1c/0x50
[117509.830314]  [<ffffffff8020efb5>] do_softirq+0x75/0xb0
[117509.830339]  [<ffffffff80253515>] irq_exit+0xa5/0xb0
[117509.830366]  [<ffffffff8020f2c1>] do_IRQ+0x111/0x1d0
[117509.830393]  [<ffffffff8020ccbb>] ret_from_intr+0x0/0xf
[117509.830421]  <EOI>  [<ffffffff802c2a33>] ?
free_hot_cold_page+0x1d3/0x2a0
[117509.830461]  [<ffffffff802c2920>] ? free_hot_cold_page+0xc0/0x2a0
[117509.830490]  [<ffffffff802c2b41>] ? __pagevec_free+0x41/0x60
[117509.830518]  [<ffffffff802c8ded>] ? shrink_page_list+0x40d/0x870
[117509.830547]  [<ffffffff802c9c84>] ? shrink_list+0x274/0x620
[117509.830578]  [<ffffffff802ca62b>] ? shrink_zone+0x1eb/0x370
[117509.830605]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[117509.830631]  [<ffffffff802ca8d8>] ? do_try_to_free_pages+0x128/0x460
[117509.830660]  [<ffffffff802cad07>] ? try_to_free_pages+0x67/0x70
[117509.830686]  [<ffffffff802c9340>] ? isolate_pages_global+0x0/0x260
[117509.830715]  [<ffffffff802c1b2a>] ?
__alloc_pages_internal+0x23a/0x530
[117509.830744]  [<ffffffff802eff5f>] ? kmalloc_large_node+0x6f/0xd0
[117509.830772]  [<ffffffff802f3b84>] ?
__kmalloc_node_track_caller+0x104/0x110
[117509.830801]  [<ffffffff8047a035>] ? sock_alloc_send_skb+0x1d5/0x210
[117509.830829]  [<ffffffff8047dafc>] ? __alloc_skb+0x7c/0x160
[117509.830856]  [<ffffffff8047a035>] ? sock_alloc_send_skb+0x1d5/0x210
[117509.830888]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[117509.830920]  [<ffffffff805038fb>] ? unix_stream_sendmsg+0x23b/0x3b0
[117509.830948]  [<ffffffff80475aca>] ? sock_aio_write+0x17a/0x190
[117509.830975]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[117509.831003]  [<ffffffff802fa959>] ? do_sync_write+0xf9/0x140
[117509.831032]  [<ffffffff802661c0>] ?
autoremove_wake_function+0x0/0x40
[117509.831061]  [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
[117509.831089]  [<ffffffff80374e29>] ? cap_file_permission+0x9/0x10
[117509.831120]  [<ffffffff80373d66>] ?
security_file_permission+0x16/0x20
[117509.831150]  [<ffffffff802fb0c9>] ? vfs_write+0x179/0x190
[117509.831178]  [<ffffffff802fb1d5>] ? sys_write+0x55/0x90
[117509.831206]  [<ffffffff8020c6ab>] ? system_call_fastpath+0x16/0x1b
[117509.831232] Mem-Info:
[117509.831253] Node 0 DMA per-cpu:
[117509.831284] CPU    0: hi:    0, btch:   1 usd:   0
[117509.831309] CPU    1: hi:    0, btch:   1 usd:   0
[117509.831335] Node 0 DMA32 per-cpu:
[117509.831365] CPU    0: hi:  186, btch:  31 usd: 156
[117509.831389] CPU    1: hi:  186, btch:  31 usd: 162
[117509.831415] Active_anon:5792 active_file:4070 inactive_anon:6244
[117509.831417]  inactive_file:417150 unevictable:0 dirty:19545
writeback:3074 unstable:0
[117509.831420]  free:7527 slab:33159 mapped:2002 pagetables:2328
bounce:0
[117509.831505] Node 0 DMA free:1492kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15144kB pages_scanned:0 all_unreclaimable? yes
[117509.831576] lowmem_reserve[]: 0 1976 1976 1976
[117509.831637] Node 0 DMA32 free:28616kB min:5664kB low:7080kB
high:8496kB active_anon:23168kB inactive_anon:24976kB active_file:16280kB inactive_file:1668600kB unevictable:0kB present:2023748kB pages_scanned:0 all_unreclaimable? no
[117509.831710] lowmem_reserve[]: 0 0 0 0
[117509.831811] Node 0 DMA: 1*4kB 0*8kB 3*16kB 3*32kB 3*64kB 1*128kB
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[117509.831949] Node 0 DMA32: 6888*4kB 10*8kB 8*16kB 6*32kB 1*64kB
0*128kB 3*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28784kB
[117509.832018] 422106 total pagecache pages
[117509.832018] 704 pages in swap cache
[117509.832018] Swap cache stats: add 10504, delete 9800, find
91119/91249
[117509.832018] Free swap  = 1913748kB
[117509.832018] Total swap = 1951800kB
[117509.844522] 522160 pages RAM
[117509.844522] 37425 pages reserved
[117509.844522] 427262 pages shared
[117509.844522] 56583 pages non-shared





-- 
                    /--------------- - -  -  -   -   -
                   |  Dan Noé
                   |  http://isomerica.net/~dpn/
