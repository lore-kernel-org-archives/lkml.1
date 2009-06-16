Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbZFPUVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbZFPUVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762884AbZFPUTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:19:23 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:50552 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763913AbZFPUTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:19:20 -0400
Message-ID: <4A37FE48.6070306@msgid.tls.msk.ru>
Date: Wed, 17 Jun 2009 00:19:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel problem?
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Package: nfs-kernel-server
> Version: 1.1.6-1
> Distribution: Debian Testing
> Architecture: 64-bit
> 
> [6042655.755870] Pid: 7093, comm: nfsd Not tainted 2.6.29.1 #4
> [6042655.755872] Call Trace:
> [6042655.755874]  <IRQ>  [<ffffffff802850fd>]  __alloc_pages_internal+0x3dd/0x4e0
> [6042655.755885]  [<ffffffff802a738b>] cache_alloc_refill+0x2fb/0x570
> [6042655.755887]  [<ffffffff802a76db>] __kmalloc+0xdb/0xe0

Was about to send this same report.

The thing continues servicing files it seems, but after some quite
good delay.

This happens after massive amount of writes.  2.6.29.4 does the
same thing.  Here it is, for comparison:

Jun 13 17:06:42 gnome vmunix: nfsd: page allocation failure. order:0, mode:0x20
Jun 13 17:06:42 gnome vmunix: Pid: 17812, comm: nfsd Tainted: G        W  2.6.29-x86-64 #2.6.29.4
Jun 13 17:06:42 gnome vmunix: Call Trace:
Jun 13 17:06:42 gnome vmunix:  <IRQ>  [<ffffffff8029559d>] __alloc_pages_internal+0x3fd/0x500
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802bd4c3>] cache_alloc_refill+0x313/0x5c0
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802bd873>] __kmalloc+0x103/0x110
Jun 13 17:06:42 gnome vmunix:  [<ffffffff803dca6d>] __alloc_skb+0x6d/0x150
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8040b550>] ip_local_deliver_finish+0x0/0x2a0
Jun 13 17:06:42 gnome vmunix:  [<ffffffff803dd7f7>] __netdev_alloc_skb+0x17/0x40
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa049c42c>] rtl8169_rx_fill+0xcc/0x230 [r8169]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa049c95e>] rtl8169_rx_interrupt+0x3ce/0x5a0 [r8169]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa00064c2>] scsi_run_queue+0xd2/0x3b0 [scsi_mod]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa04a009b>] rtl8169_poll+0x3b/0x250 [r8169]
Jun 13 17:06:42 gnome vmunix:  [<ffffffff803e207c>] net_rx_action+0xfc/0x1c0
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802511ab>] __do_softirq+0x9b/0x140
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80212d1c>] call_softirq+0x1c/0x30
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802149fd>] do_softirq+0x4d/0x90
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80250e55>] irq_exit+0x75/0x90
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80214c63>] do_IRQ+0x83/0x110
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80212493>] ret_from_intr+0x0/0x29
Jun 13 17:06:42 gnome vmunix:  <EOI>  [<ffffffff8029afc3>] shrink_list+0x273/0x690
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802100a8>] __switch_to+0x3f8/0x4a0
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802468da>] finish_task_switch+0x2a/0xe0
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8046d8c5>] thread_return+0x3d/0x6d8
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8029b64b>] shrink_zone+0x26b/0x380
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8046f91e>] _spin_lock_irqsave+0x2e/0x40
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8029c658>] try_to_free_pages+0x328/0x3e0
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8046e0f3>] schedule_timeout+0x53/0xd0
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802994c0>] isolate_pages_global+0x0/0x280
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80261e90>] autoremove_wake_function+0x0/0x30
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802953cd>] __alloc_pages_internal+0x22d/0x500
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8028ef86>] grab_cache_page_write_begin+0x96/0xe0
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa022ea46>] ext4_da_write_begin+0x116/0x230 [ext4]
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8028fae8>] generic_file_buffered_write+0x128/0x320
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802d50da>] file_update_time+0x11a/0x140
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8046fa25>] _spin_lock+0x5/0x10
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80290188>] __generic_file_aio_write_nolock+0x278/0x480
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8046fb41>] _spin_lock_bh+0x11/0x20
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80290d04>] generic_file_aio_write+0x64/0xe0
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa0229d65>] ext4_file_write+0x55/0x180 [ext4]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa0229d10>] ext4_file_write+0x0/0x180 [ext4]
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802c09cb>] do_sync_readv_writev+0xcb/0x110
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa03875f0>] find_acceptable_alias+0x20/0x110 [exportfs]
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80261e90>] autoremove_wake_function+0x0/0x30
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802c07f6>] rw_copy_check_uvector+0x86/0x140
Jun 13 17:06:42 gnome vmunix:  [<ffffffff802c1142>] do_readv_writev+0xe2/0x230
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa0214f2f>] jbd2_journal_stop+0x16f/0x2a0 [jbd2]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa0390c89>] nfsd_vfs_write+0xc9/0x410 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa039167d>] nfsd_open+0x14d/0x1f0 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa0391ad4>] nfsd_write+0x114/0x120 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa039a0f0>] nfsd3_proc_write+0xb0/0x150 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa038b27a>] nfsd_dispatch+0xba/0x270 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa02e3efb>] svc_process+0x4ab/0x810 [sunrpc]
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80244640>] default_wake_function+0x0/0x10
Jun 13 17:06:42 gnome vmunix:  [<ffffffff8046f879>] __down_read+0xb9/0xc4
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa038b9f4>] nfsd+0x184/0x2b0 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa038b870>] nfsd+0x0/0x2b0 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffffa038b870>] nfsd+0x0/0x2b0 [nfsd]
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80261a57>] kthread+0x47/0x90
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80212c1a>] child_rip+0xa/0x20
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80261a10>] kthread+0x0/0x90
Jun 13 17:06:42 gnome vmunix:  [<ffffffff80212c10>] child_rip+0x0/0x20
Jun 13 17:06:42 gnome vmunix: Mem-Info:
Jun 13 17:06:42 gnome vmunix: DMA per-cpu:
Jun 13 17:06:42 gnome vmunix: CPU    0: hi:    0, btch:   1 usd:   0
Jun 13 17:06:42 gnome vmunix: DMA32 per-cpu:
Jun 13 17:06:42 gnome vmunix: CPU    0: hi:  186, btch:  31 usd: 170
Jun 13 17:06:42 gnome vmunix: Active_anon:4641 active_file:35865 inactive_anon:16138
Jun 13 17:06:42 gnome vmunix:  inactive_file:417340 unevictable:451 dirty:1330 writeback:13820 unstable:0
Jun 13 17:06:42 gnome vmunix:  free:2460 slab:16669 mapped:3659 pagetables:304 bounce:0
Jun 13 17:06:42 gnome vmunix: DMA free:7760kB min:24kB low:28kB high:36kB active_anon:0kB inactive_anon:84kB active_file:760kB inactive_file
Jun 13 17:06:42 gnome vmunix: lowmem_reserve[]: 0 1938 1938 1938
Jun 13 17:06:42 gnome vmunix: DMA32 free:2080kB min:5620kB low:7024kB high:8428kB active_anon:18564kB inactive_anon:64468kB active_file:1427
Jun 13 17:06:42 gnome vmunix: lowmem_reserve[]: 0 0 0 0
Jun 13 17:06:42 gnome vmunix: DMA: 6*4kB 7*8kB 6*16kB 9*32kB 6*64kB 4*128kB 3*256kB 1*512kB 1*1024kB 0*2048kB 1*4096kB = 7760kB
Jun 13 17:06:42 gnome vmunix: DMA32: 1*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2060kB
Jun 13 17:06:42 gnome vmunix: 454746 total pagecache pages
Jun 13 17:06:42 gnome vmunix: 570 pages in swap cache
Jun 13 17:06:42 gnome vmunix: Swap cache stats: add 3988, delete 3418, find 355269/355411
Jun 13 17:06:42 gnome vmunix: Free swap  = 4185552kB
Jun 13 17:06:42 gnome vmunix: Total swap = 4192956kB
Jun 13 17:06:42 gnome vmunix: 507360 pages RAM
Jun 13 17:06:42 gnome vmunix: 9169 pages reserved
Jun 13 17:06:42 gnome vmunix: 277152 pages shared
Jun 13 17:06:42 gnome vmunix: 222889 pages non-shared

No idea why it is tainted - probably the r8169 lockups.
The same page allocation failure happens on a freshly
booted kernel too (untainted) - after about half a
hour of constant writing to the same file (i were tarring
a large filesystem to the remote server), on a 2gb machine
which does nothing else.

Thanks.

/mjt

> [6042655.755891]  [<ffffffff8059a98d>] __alloc_skb+0x6d/0x150
> [6042655.755893]  [<ffffffff8059b727>] __netdev_alloc_skb+0x17/0x40
> [6042655.755897]  [<ffffffff804d8c8b>] e1000_alloc_rx_buffers+0x23b/0x2c0
> [6042655.755899]  [<ffffffff804d8fbd>] e1000_clean_rx_irq+0x25d/0x3a0
> [6042655.755901]  [<ffffffff804dad70>] e1000_clean+0x180/0x2d0
> [6042655.755904]  [<ffffffff8059f5a7>] net_rx_action+0x87/0x130
> [6042655.755907]  [<ffffffff80259cd3>] __do_softirq+0x93/0x160
> [6042655.755910]  [<ffffffff8022c9fc>] call_softirq+0x1c/0x30
> [6042655.755912]  [<ffffffff8022e455>] do_softirq+0x35/0x80
> [6042655.755914]  [<ffffffff8022e523>] do_IRQ+0x83/0x110
> [6042655.755917]  [<ffffffff8022c2d3>] ret_from_intr+0x0/0xa
> [6042655.755918]  <EOI>  [<ffffffff80632190>] _spin_lock+0x10/0x20
> [6042655.755924]  [<ffffffff802bb2fc>] d_find_alias+0x1c/0x40
> [6042655.755926]  [<ffffffff802bd96d>] d_obtain_alias+0x4d/0x140
> [6042655.755930]  [<ffffffff8033ffd3>] exportfs_decode_fh+0x63/0x2a0
> [6042655.755932]  [<ffffffff80343970>] nfsd_acceptable+0x0/0x110
> [6042655.755935]  [<ffffffff8061e74a>] cache_check+0x4a/0x4d0
> [6042655.755937]  [<ffffffff80349437>] exp_find_key+0x57/0xe0
> [6042655.755941]  [<ffffffff80592a35>] sock_recvmsg+0xd5/0x110
> [6042655.755943]  [<ffffffff80349552>] exp_find+0x92/0xa0
> [6042655.755945]  [<ffffffff80343e59>] fh_verify+0x369/0x680
> [6042655.755948]  [<ffffffff8024add9>] check_preempt_wakeup+0xf9/0x120
> [6042655.755950]  [<ffffffff803460be>] nfsd_open+0x2e/0x180
> [6042655.755952]  [<ffffffff80346574>] nfsd_write+0xc4/0x120
> [6042655.755955]  [<ffffffff8034dac0>] nfsd3_proc_write+0xb0/0x150
> [6042655.755957]  [<ffffffff8034040a>] nfsd_dispatch+0xba/0x270
> [6042655.755960]  [<ffffffff80615a1e>] svc_process+0x49e/0x800
> [6042655.755962]  [<ffffffff8024dc80>] default_wake_function+0x0/0x10
> [6042655.755965]  [<ffffffff80631fd7>] __down_read+0x17/0xae
> [6042655.755966]  [<ffffffff80340b79>] nfsd+0x199/0x2b0
> [6042655.755968]  [<ffffffff803409e0>] nfsd+0x0/0x2b0
> [6042655.755971]  [<ffffffff802691d7>] kthread+0x47/0x90
> [6042655.755973]  [<ffffffff8022c8fa>] child_rip+0xa/0x20
> [6042655.755975]  [<ffffffff80269190>] kthread+0x0/0x90
> [6042655.755977]  [<ffffffff8022c8f0>] child_rip+0x0/0x20
> [6042655.755979] Mem-Info:
> [6042655.755980] DMA per-cpu:
> [6042655.755982] CPU    0: hi:    0, btch:   1 usd:   0
> [6042655.755983] CPU    1: hi:    0, btch:   1 usd:   0
> [6042655.755985] CPU    2: hi:    0, btch:   1 usd:   0
> [6042655.755986] CPU    3: hi:    0, btch:   1 usd:   0
> [6042655.755987] DMA32 per-cpu:
> [6042655.755988] CPU    0: hi:  186, btch:  31 usd: 168
> [6042655.755990] CPU    1: hi:  186, btch:  31 usd:  30
> [6042655.755991] CPU    2: hi:  186, btch:  31 usd: 161
> [6042655.755992] CPU    3: hi:  186, btch:  31 usd: 221
> [6042655.755993] Normal per-cpu:
> [6042655.755995] CPU    0: hi:  186, btch:  31 usd: 156
> [6042655.755996] CPU    1: hi:  186, btch:  31 usd:  30
> [6042655.755997] CPU    2: hi:  186, btch:  31 usd: 187
> [6042655.755998] CPU    3: hi:  186, btch:  31 usd: 202
> [6042655.756001] Active_anon:108072 active_file:103321 inactive_anon:31621
> [6042655.756002]  inactive_file:984722 unevictable:0 dirty:71104 
> writeback:0 unstable:0
> [6042655.756003]  free:8659 slab:746182 mapped:8842 pagetables:5374 
> bounce:0
> [6042655.756005] DMA free:9736kB min:16kB low:20kB high:24kB 
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
> unevictable:0kB present:8744kB pages_scanned:0 all_unreclaimable? yes
> [6042655.756008] lowmem_reserve[]: 0 3246 7980 7980
> [6042655.756012] DMA32 free:21420kB min:6656kB low:8320kB high:9984kB 
> active_anon:52420kB inactive_anon:38552kB active_file:146252kB 
> inactive_file:1651512kB unevictable:0kB present:3324312kB 
> pages_scanned:0 all_unreclaimable? no
> [6042655.756014] lowmem_reserve[]: 0 0 4734 4734
> [6042655.756018] Normal free:3480kB min:9708kB low:12132kB high:14560kB 
> active_anon:379868kB inactive_anon:87932kB active_file:267032kB 
> inactive_file:2287376kB unevictable:0kB present:4848000kB 
> pages_scanned:0 all_unreclaimable? no
> [6042655.756020] lowmem_reserve[]: 0 0 0 0
> [6042655.756023] DMA: 4*4kB 5*8kB 3*16kB 3*32kB 1*64kB 2*128kB 2*256kB 
> 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9736kB
> [6042655.756030] DMA32: 3123*4kB 77*8kB 3*16kB 1*32kB 1*64kB 0*128kB 
> 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21188kB
> [6042655.756036] Normal: 1*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 
> 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3436kB
> [6042655.756042] 1090130 total pagecache pages
> [6042655.756044] 2059 pages in swap cache
> [6042655.756046] Swap cache stats: add 125946, delete 123887, find 
> 3279355/3285565
> [6042655.756047] Free swap  = 16734964kB
> [6042655.756048] Total swap = 16787768kB
> [6042655.756125] 2277376 pages RAM
> [6042655.756125] 252195 pages reserved
> [6042655.756125] 790472 pages shared
> [6042655.756125] 1269664 pages non-shared
> [6042655.794633] nfsd: page allocation failure. order:0, mode:0x20
> [6042655.794637] Pid: 7093, comm: nfsd Not tainted 2.6.29.1 #4
> [6042655.794638] Call Trace:
> [6042655.794640]  <IRQ>  [<ffffffff802850fd>] 
> __alloc_pages_internal+0x3dd/0x4e0
> [6042655.794649]  [<ffffffff802a738b>] cache_alloc_refill+0x2fb/0x570
> [6042655.794652]  [<ffffffff802a7085>] kmem_cache_alloc+0x95/0xa0
> [6042655.794655]  [<ffffffff8059a969>] __alloc_skb+0x49/0x150
> [6042655.794658]  [<ffffffff805dee06>] tcp_send_ack+0x26/0x120
> [6042655.794660]  [<ffffffff805dcbd2>] tcp_rcv_established+0x7a2/0x920
> [6042655.794663]  [<ffffffff805e417d>] tcp_v4_do_rcv+0xdd/0x210
> [6042655.794665]  [<ffffffff805e4926>] tcp_v4_rcv+0x676/0x710
> [6042655.794668]  [<ffffffff805c6a5c>] ip_local_deliver_finish+0x8c/0x160
> [6042655.794670]  [<ffffffff805c6551>] ip_rcv_finish+0x191/0x330
> [6042655.794672]  [<ffffffff805c6936>] ip_rcv+0x246/0x2e0
> [6042655.794676]  [<ffffffff804d8e74>] e1000_clean_rx_irq+0x114/0x3a0
> [6042655.794678]  [<ffffffff804dad70>] e1000_clean+0x180/0x2d0
> [6042655.794681]  [<ffffffff8059f5a7>] net_rx_action+0x87/0x130
> [6042655.794683]  [<ffffffff80259cd3>] __do_softirq+0x93/0x160
> [6042655.794687]  [<ffffffff8022c9fc>] call_softirq+0x1c/0x30
> [6042655.794689]  [<ffffffff8022e455>] do_softirq+0x35/0x80
> [6042655.794691]  [<ffffffff8022e523>] do_IRQ+0x83/0x110
> [6042655.794693]  [<ffffffff8022c2d3>] ret_from_intr+0x0/0xa
> [6042655.794694]  <EOI>  [<ffffffff80632190>] _spin_lock+0x10/0x20
> [6042655.794700]  [<ffffffff802bb2fc>] d_find_alias+0x1c/0x40
> [6042655.794703]  [<ffffffff802bd96d>] d_obtain_alias+0x4d/0x140
> [6042655.794706]  [<ffffffff8033ffd3>] exportfs_decode_fh+0x63/0x2a0
> [6042655.794708]  [<ffffffff80343970>] nfsd_acceptable+0x0/0x110
> [6042655.794711]  [<ffffffff8061e74a>] cache_check+0x4a/0x4d0
> [6042655.794714]  [<ffffffff80349437>] exp_find_key+0x57/0xe0
> [6042655.794717]  [<ffffffff80592a35>] sock_recvmsg+0xd5/0x110
> [6042655.794719]  [<ffffffff80349552>] exp_find+0x92/0xa0
> [6042655.794721]  [<ffffffff80343e59>] fh_verify+0x369/0x680
> [6042655.794724]  [<ffffffff8024add9>] check_preempt_wakeup+0xf9/0x120
> [6042655.794726]  [<ffffffff803460be>] nfsd_open+0x2e/0x180
> [6042655.794728]  [<ffffffff80346574>] nfsd_write+0xc4/0x120
> [6042655.794730]  [<ffffffff8034dac0>] nfsd3_proc_write+0xb0/0x150
> [6042655.794732]  [<ffffffff8034040a>] nfsd_dispatch+0xba/0x270
> [6042655.794736]  [<ffffffff80615a1e>] svc_process+0x49e/0x800
> [6042655.794738]  [<ffffffff8024dc80>] default_wake_function+0x0/0x10
> [6042655.794740]  [<ffffffff80631fd7>] __down_read+0x17/0xae
> [6042655.794742]  [<ffffffff80340b79>] nfsd+0x199/0x2b0
> [6042655.794743]  [<ffffffff803409e0>] nfsd+0x0/0x2b0
> [6042655.794747]  [<ffffffff802691d7>] kthread+0x47/0x90
> [6042655.794749]  [<ffffffff8022c8fa>] child_rip+0xa/0x20
> [6042655.794751]  [<ffffffff80269190>] kthread+0x0/0x90
> [6042655.794753]  [<ffffffff8022c8f0>] child_rip+0x0/0x20
> [6042655.794754] Mem-Info:
> [6042655.794755] DMA per-cpu:
> [6042655.794757] CPU    0: hi:    0, btch:   1 usd:   0
> [6042655.794758] CPU    1: hi:    0, btch:   1 usd:   0
> [6042655.794760] CPU    2: hi:    0, btch:   1 usd:   0
> [6042655.794761] CPU    3: hi:    0, btch:   1 usd:   0
> [6042655.794762] DMA32 per-cpu:
> [6042655.794763] CPU    0: hi:  186, btch:  31 usd: 168
> [6042655.794765] CPU    1: hi:  186, btch:  31 usd:  30
> [6042655.794766] CPU    2: hi:  186, btch:  31 usd: 161
> [6042655.794767] CPU    3: hi:  186, btch:  31 usd: 221
> [6042655.794768] Normal per-cpu:
> [6042655.794770] CPU    0: hi:  186, btch:  31 usd: 156
> [6042655.794771] CPU    1: hi:  186, btch:  31 usd:  30
> [6042655.794772] CPU    2: hi:  186, btch:  31 usd: 187
> [6042655.794773] CPU    3: hi:  186, btch:  31 usd: 202
> [6042655.794776] Active_anon:108072 active_file:103321 inactive_anon:31621
> [6042655.794777]  inactive_file:984722 unevictable:0 dirty:71104 
> writeback:0 unstable:0
> [6042655.794778]  free:8659 slab:746182 mapped:8842 pagetables:5374 
> bounce:0
> [6042655.794780] DMA free:9736kB min:16kB low:20kB high:24kB 
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
> unevictable:0kB present:8744kB pages_scanned:0 all_unreclaimable? yes
> [6042655.794783] lowmem_reserve[]: 0 3246 7980 7980
> [6042655.794787] DMA32 free:21420kB min:6656kB low:8320kB high:9984kB 
> active_anon:52420kB inactive_anon:38552kB active_file:146252kB 
> inactive_file:1651512kB unevictable:0kB present:3324312kB 
> pages_scanned:0 all_unreclaimable? no
> [6042655.794789] lowmem_reserve[]: 0 0 4734 4734
> [6042655.794793] Normal free:3480kB min:9708kB low:12132kB high:14560kB 
> active_anon:379868kB inactive_anon:87932kB active_file:267032kB 
> inactive_file:2287376kB unevictable:0kB present:4848000kB 
> pages_scanned:0 all_unreclaimable? no
> [6042655.794795] lowmem_reserve[]: 0 0 0 0
> [6042655.794798] DMA: 4*4kB 5*8kB 3*16kB 3*32kB 1*64kB 2*128kB 2*256kB 
> 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9736kB
> [6042655.794805] DMA32: 3123*4kB 77*8kB 3*16kB 1*32kB 1*64kB 0*128kB 
> 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21188kB
> [6042655.794811] Normal: 1*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 
> 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3436kB
> [6042655.794818] 1090130 total pagecache pages
> [6042655.794819] 2059 pages in swap cache
> [6042655.794821] Swap cache stats: add 125946, delete 123887, find 
> 3279355/3285565
> [6042655.794822] Free swap  = 16734964kB
> [6042655.794823] Total swap = 16787768kB
> [6042655.795578] 2277376 pages RAM
> [6042655.795578] 252195 pages reserved
> [6042655.795578] 790472 pages shared
> [6042655.795578] 1269664 pages non-shared
> [6042655.828540] nfsd: page allocation failure. order:0, mode:0x20
> [6042655.828544] Pid: 7093, comm: nfsd Not tainted 2.6.29.1 #4
> [6042655.828545] Call Trace:
> [6042655.828547]  <IRQ>  [<ffffffff802850fd>] 
> __alloc_pages_internal+0x3dd/0x4e0
> [6042655.828555]  [<ffffffff802a738b>] cache_alloc_refill+0x2fb/0x570
> [6042655.828557]  [<ffffffff802a7085>] kmem_cache_alloc+0x95/0xa0
> [6042655.828561]  [<ffffffff8059a969>] __alloc_skb+0x49/0x150
> [6042655.828564]  [<ffffffff8059b727>] __netdev_alloc_skb+0x17/0x40
> [6042655.828567]  [<ffffffff804d8c8b>] e1000_alloc_rx_buffers+0x23b/0x2c0
> [6042655.828570]  [<ffffffff804d8fbd>] e1000_clean_rx_irq+0x25d/0x3a0
> [6042655.828572]  [<ffffffff804dad70>] e1000_clean+0x180/0x2d0
> [6042655.828574]  [<ffffffff8059f5a7>] net_rx_action+0x87/0x130
> [6042655.828578]  [<ffffffff80259cd3>] __do_softirq+0x93/0x160
> [6042655.828581]  [<ffffffff8022c9fc>] call_softirq+0x1c/0x30
> [6042655.828583]  [<ffffffff8022e455>] do_softirq+0x35/0x80
> [6042655.828585]  [<ffffffff8022e523>] do_IRQ+0x83/0x110
> [6042655.828587]  [<ffffffff8022c2d3>] ret_from_intr+0x0/0xa
> [6042655.828589]  <EOI>  [<ffffffff80632190>] _spin_lock+0x10/0x20
> [6042655.828595]  [<ffffffff802bb2fc>] d_find_alias+0x1c/0x40
> [6042655.828598]  [<ffffffff802bd96d>] d_obtain_alias+0x4d/0x140
> [6042655.828601]  [<ffffffff8033ffd3>] exportfs_decode_fh+0x63/0x2a0
> [6042655.828604]  [<ffffffff80343970>] nfsd_acceptable+0x0/0x110
> [6042655.828606]  [<ffffffff8061e74a>] cache_check+0x4a/0x4d0
> [6042655.828609]  [<ffffffff80349437>] exp_find_key+0x57/0xe0
> [6042655.828612]  [<ffffffff80592a35>] sock_recvmsg+0xd5/0x110
> [6042655.828614]  [<ffffffff80349552>] exp_find+0x92/0xa0
> [6042655.828616]  [<ffffffff80343e59>] fh_verify+0x369/0x680
> [6042655.828619]  [<ffffffff8024add9>] check_preempt_wakeup+0xf9/0x120
> [6042655.828622]  [<ffffffff803460be>] nfsd_open+0x2e/0x180
> [6042655.828623]  [<ffffffff80346574>] nfsd_write+0xc4/0x120
> [6042655.828626]  [<ffffffff8034dac0>] nfsd3_proc_write+0xb0/0x150
> [6042655.828628]  [<ffffffff8034040a>] nfsd_dispatch+0xba/0x270
> [6042655.828631]  [<ffffffff80615a1e>] svc_process+0x49e/0x800
> [6042655.828634]  [<ffffffff8024dc80>] default_wake_function+0x0/0x10
> [6042655.828636]  [<ffffffff80631fd7>] __down_read+0x17/0xae
> [6042655.828638]  [<ffffffff80340b79>] nfsd+0x199/0x2b0
> [6042655.828639]  [<ffffffff803409e0>] nfsd+0x0/0x2b0
> [6042655.828643]  [<ffffffff802691d7>] kthread+0x47/0x90
> [6042655.828645]  [<ffffffff8022c8fa>] child_rip+0xa/0x20
> [6042655.828647]  [<ffffffff80269190>] kthread+0x0/0x90
> [6042655.828649]  [<ffffffff8022c8f0>] child_rip+0x0/0x20
> [6042655.828650] Mem-Info:
> [6042655.828651] DMA per-cpu:
> [6042655.828653] CPU    0: hi:    0, btch:   1 usd:   0
> [6042655.828655] CPU    1: hi:    0, btch:   1 usd:   0
> [6042655.828656] CPU    2: hi:    0, btch:   1 usd:   0
> [6042655.828657] CPU    3: hi:    0, btch:   1 usd:   0
> [6042655.828658] DMA32 per-cpu:
> [6042655.828659] CPU    0: hi:  186, btch:  31 usd: 168
> [6042655.828661] CPU    1: hi:  186, btch:  31 usd:  30
> [6042655.828662] CPU    2: hi:  186, btch:  31 usd: 161
> [6042655.828663] CPU    3: hi:  186, btch:  31 usd: 221
> [6042655.828665] Normal per-cpu:
> [6042655.828666] CPU    0: hi:  186, btch:  31 usd: 156
> [6042655.828667] CPU    1: hi:  186, btch:  31 usd:  30
> [6042655.828668] CPU    2: hi:  186, btch:  31 usd: 187
> [6042655.828670] CPU    3: hi:  186, btch:  31 usd: 202
> [6042655.828672] Active_anon:108072 active_file:103321 inactive_anon:31621
> [6042655.828673]  inactive_file:984722 unevictable:0 dirty:71104 
> writeback:0 unstable:0
> [6042655.828674]  free:8659 slab:746182 mapped:8842 pagetables:5374 
> bounce:0
> [6042655.828677] DMA free:9736kB min:16kB low:20kB high:24kB 
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
> unevictable:0kB present:8744kB pages_scanned:0 all_unreclaimable? yes
> [6042655.828679] lowmem_reserve[]: 0 3246 7980 7980
> [6042655.828683] DMA32 free:21420kB min:6656kB low:8320kB high:9984kB 
> active_anon:52420kB inactive_anon:38552kB active_file:146252kB 
> inactive_file:1651512kB unevictable:0kB present:3324312kB 
> pages_scanned:0 all_unreclaimable? no
> [6042655.828685] lowmem_reserve[]: 0 0 4734 4734
> [6042655.828689] Normal free:3480kB min:9708kB low:12132kB high:14560kB 
> active_anon:379868kB inactive_anon:87932kB active_file:267032kB 
> inactive_file:2287376kB unevictable:0kB present:4848000kB 
> pages_scanned:0 all_unreclaimable? no
> [6042655.828692] lowmem_reserve[]: 0 0 0 0
> [6042655.828694] DMA: 4*4kB 5*8kB 3*16kB 3*32kB 1*64kB 2*128kB 2*256kB 
> 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9736kB
> [6042655.828701] DMA32: 3123*4kB 77*8kB 3*16kB 1*32kB 1*64kB 0*128kB 
> 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21188kB
> [6042655.828707] Normal: 1*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 
> 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3436kB
> [6042655.828714] 1090130 total pagecache pages
> [6042655.828715] 2059 pages in swap cache
> [6042655.828717] Swap cache stats: add 125946, delete 123887, find 
> 3279355/3285565
> [6042655.828718] Free swap  = 16734964kB
> [6042655.828719] Total swap = 16787768kB
> [6042655.830324] 2277376 pages RAM
> [6042655.830324] 252195 pages reserved
> [6042655.830324] 790472 pages shared
> [6042655.830324] 1269089 pages non-shared
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

