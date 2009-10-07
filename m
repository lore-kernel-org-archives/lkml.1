Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZJGDxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZJGDxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZJGDxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:53:52 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:51524 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZJGDxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sJHf1bkUOI6cXN6qICjzSH4hy3EnG/gqFyzzFdK39I7hvij7t7uwowtu7JGpMNyG2A
         DoiWLDXBkvwTvkVh9TLc4K+WDtZRatl2qlxN4aeCSc/zmRpfDHFownqItKR37pRC7NlJ
         kzyui4bp+a7o6uatmHnYJic7YGK3qAfW+QWaQ=
Date: Wed, 7 Oct 2009 07:53:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.32-rc2-xxx: bdev_lock: inconsistent {SOFTIRQ-ON-W} ->
 {IN-SOFTIRQ-W} usage
Message-ID: <20091007035310.GA30833@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happened during page allocation failure:

grep: page allocation failure. order:1, mode:0x4020
Pid: 17920, comm: grep Not tainted 2.6.32-rc2-zfs #1
Call Trace:
 <IRQ>  [<ffffffff81081d93>] __alloc_pages_nodemask+0x623/0x6c0
 [<ffffffff8130f970>] ? _spin_unlock+0x30/0x50
 [<ffffffff810aa1fb>] __slab_alloc+0x57b/0x710
 [<ffffffff81064c9c>] ? mark_held_locks+0x6c/0x90
 [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
 [<ffffffff810aa7d5>] ? kmem_cache_alloc+0xc5/0x110
 [<ffffffff810ab087>] __kmalloc_track_caller+0x117/0x150
 [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
 [<ffffffff8126ac9e>] __alloc_skb+0x6e/0x170
 [<ffffffff8126baaf>] __netdev_alloc_skb+0x1f/0x40
 [<ffffffff8123ca6b>] ? rtl8139_poll+0x4b/0x400
 [<ffffffff8123cb66>] rtl8139_poll+0x146/0x400
 [<ffffffff81272e63>] net_rx_action+0x183/0x260
 [<ffffffff81272ddc>] ? net_rx_action+0xfc/0x260
 [<ffffffff81041510>] __do_softirq+0xd0/0x180
 [<ffffffff8100c4bc>] call_softirq+0x1c/0x30
 [<ffffffff8100e81d>] do_softirq+0x7d/0xc0
 [<ffffffff81040fdd>] irq_exit+0x8d/0xb0
 [<ffffffff8100da37>] do_IRQ+0x77/0xf0
 [<ffffffff8100bc93>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8130f938>] ? _spin_unlock_irqrestore+0x68/0x70
 [<ffffffff81185bac>] ? debug_check_no_obj_freed+0x17c/0x1f0
 [<ffffffff81080b71>] ? free_hot_cold_page+0xd1/0x320
 [<ffffffff81080df9>] ? __pagevec_free+0x39/0x50
 [<ffffffff81084748>] ? release_pages+0x228/0x240
 [<ffffffff810a1d5d>] ? free_pages_and_swap_cache+0x8d/0xb0
 [<ffffffff810984e8>] ? exit_mmap+0x188/0x1a0
 [<ffffffff81038827>] ? mmput+0x57/0xe0
 [<ffffffff8103d0fc>] ? exit_mm+0xfc/0x140
 [<ffffffff8103f230>] ? do_exit+0x6f0/0x780
 [<ffffffff81057546>] ? up_read+0x26/0x30
 [<ffffffff8100bd2d>] ? retint_swapgs+0xe/0x13
 [<ffffffff8103f301>] ? do_group_exit+0x41/0xc0
 [<ffffffff8103f392>] ? sys_exit_group+0x12/0x20
 [<ffffffff8100b36b>] ? system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  77
CPU    1: hi:  186, btch:  31 usd: 158

=================================
[ INFO: inconsistent lock state ]
2.6.32-rc2-zfs #1
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
grep/17920 [HC0[0]:SC1[1]:HE0:SE0] takes:
 (bdev_lock){+.?...}, at: [<ffffffff810dd537>] nr_blockdev_pages+0x17/0x80
{SOFTIRQ-ON-W} state was registered at:
  [<ffffffff810665fa>] __lock_acquire+0x75a/0x1cf0
  [<ffffffff81067bec>] lock_acquire+0x5c/0x80
  [<ffffffff8130faf6>] _spin_lock+0x36/0x50
  [<ffffffff810dd537>] nr_blockdev_pages+0x17/0x80
  [<ffffffff8107fe68>] si_meminfo+0x38/0x60
  [<ffffffff814d5006>] eventpoll_init+0x11/0xfb
  [<ffffffff81009048>] do_one_initcall+0x38/0x190
  [<ffffffff814bf6ad>] kernel_init+0x1ba/0x23e
  [<ffffffff8100c3ba>] child_rip+0xa/0x20
irq event stamp: 4563
hardirqs last  enabled at (4562): [<ffffffff810aa7d5>] kmem_cache_alloc+0xc5/0x110
hardirqs last disabled at (4563): [<ffffffff810aafd2>] __kmalloc_track_caller+0x62/0x150
softirqs last  enabled at (4412): [<ffffffff81041567>] __do_softirq+0x127/0x180
softirqs last disabled at (4557): [<ffffffff8100c4bc>] call_softirq+0x1c/0x30

other info that might help us debug this:
2 locks held by grep/17920:
 #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81272ddc>] net_rx_action+0xfc/0x260
 #1:  (&tp->rx_lock){+.-.-.}, at: [<ffffffff8123ca6b>] rtl8139_poll+0x4b/0x400

stack backtrace:
Pid: 17920, comm: grep Not tainted 2.6.32-rc2-zfs #1
Call Trace:
 <IRQ>  [<ffffffff81064540>] print_usage_bug+0x190/0x1f0
 [<ffffffff81064a2f>] mark_lock+0x48f/0x690
 [<ffffffff810653c0>] ? check_usage_forwards+0x0/0x110
 [<ffffffff81066584>] __lock_acquire+0x6e4/0x1cf0
 [<ffffffff8103bef2>] ? vprintk+0x2e2/0x530
 [<ffffffff8130f970>] ? _spin_unlock+0x30/0x50
 [<ffffffff81063c3d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff812835f3>] ? netpoll_send_skb+0x213/0x260
 [<ffffffff8130bd3f>] ? printk+0x67/0x69
 [<ffffffff81067bec>] lock_acquire+0x5c/0x80
 [<ffffffff810dd537>] ? nr_blockdev_pages+0x17/0x80
 [<ffffffff8130faf6>] _spin_lock+0x36/0x50
 [<ffffffff810dd537>] ? nr_blockdev_pages+0x17/0x80
 [<ffffffff810dd537>] nr_blockdev_pages+0x17/0x80
 [<ffffffff8107ff29>] show_free_areas+0x99/0x7f0
 [<ffffffff81063c3d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8130f912>] ? _spin_unlock_irqrestore+0x42/0x70
 [<ffffffff8103b8e5>] ? release_console_sem+0x1e5/0x230
 [<ffffffff8103bef2>] ? vprintk+0x2e2/0x530
 [<ffffffff8106f01d>] ? __module_text_address+0xd/0x70
 [<ffffffff810102e1>] ? print_context_stack+0x81/0xf0
 [<ffffffff8130bd3f>] ? printk+0x67/0x69
 [<ffffffff8100ee98>] ? dump_trace+0x128/0x300
 [<ffffffff81010167>] ? show_trace_log_lvl+0x57/0x70
 [<ffffffff8117cd54>] show_mem+0x24/0x1e0
 [<ffffffff8130bb64>] ? dump_stack+0x72/0x7b
 [<ffffffff81081d98>] __alloc_pages_nodemask+0x628/0x6c0
 [<ffffffff8130f970>] ? _spin_unlock+0x30/0x50
 [<ffffffff810aa1fb>] __slab_alloc+0x57b/0x710
 [<ffffffff81064c9c>] ? mark_held_locks+0x6c/0x90
 [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
 [<ffffffff810aa7d5>] ? kmem_cache_alloc+0xc5/0x110
 [<ffffffff810ab087>] __kmalloc_track_caller+0x117/0x150
 [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
 [<ffffffff8126ac9e>] __alloc_skb+0x6e/0x170
 [<ffffffff8126baaf>] __netdev_alloc_skb+0x1f/0x40
 [<ffffffff8123ca6b>] ? rtl8139_poll+0x4b/0x400
 [<ffffffff8123cb66>] rtl8139_poll+0x146/0x400
 [<ffffffff81272e63>] net_rx_action+0x183/0x260
 [<ffffffff81272ddc>] ? net_rx_action+0xfc/0x260
 [<ffffffff81041510>] __do_softirq+0xd0/0x180
 [<ffffffff8100c4bc>] call_softirq+0x1c/0x30
 [<ffffffff8100e81d>] do_softirq+0x7d/0xc0
 [<ffffffff81040fdd>] irq_exit+0x8d/0xb0
 [<ffffffff8100da37>] do_IRQ+0x77/0xf0
 [<ffffffff8100bc93>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8130f938>] ? _spin_unlock_irqrestore+0x68/0x70
 [<ffffffff81185bac>] ? debug_check_no_obj_freed+0x17c/0x1f0
 [<ffffffff81080b71>] ? free_hot_cold_page+0xd1/0x320
 [<ffffffff81080df9>] ? __pagevec_free+0x39/0x50
 [<ffffffff81084748>] ? release_pages+0x228/0x240
 [<ffffffff810a1d5d>] ? free_pages_and_swap_cache+0x8d/0xb0
 [<ffffffff810984e8>] ? exit_mmap+0x188/0x1a0
 [<ffffffff81038827>] ? mmput+0x57/0xe0
 [<ffffffff8103d0fc>] ? exit_mm+0xfc/0x140
 [<ffffffff8103f230>] ? do_exit+0x6f0/0x780
 [<ffffffff81057546>] ? up_read+0x26/0x30
 [<ffffffff8100bd2d>] ? retint_swapgs+0xe/0x13
 [<ffffffff8103f301>] ? do_group_exit+0x41/0xc0
 [<ffffffff8103f392>] ? sys_exit_group+0x12/0x20
 [<ffffffff8100b36b>] ? system_call_fastpath+0x16/0x1b
active_anon:19543 inactive_anon:4195 isolated_anon:0
 active_file:270517 inactive_file:394446 isolated_file:0
 unevictable:0 dirty:3482 writeback:0 unstable:0 buffer:110281
 free:9304 slab_reclaimable:59817 slab_unreclaimable:4302
 mapped:1447 shmem:0 pagetables:960 bounce:0
DMA free:9820kB min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:9216kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3013 3013 3013
DMA32 free:26776kB min:7012kB low:8764kB high:10516kB active_anon:78320kB inactive_anon:16780kB active_file:1082068kB inactive_file:1577784kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3086052kB mlocked:0kB dirty:13928kB writeback:0kB mapped:5788kB shmem:0kB slab_reclaimable:239268kB slab_unreclaimable:17200kB kernel_stack:1104kB pagetables:3840kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 5*8kB 3*16kB 4*32kB 4*64kB 3*128kB 3*256kB 2*512kB 1*1024kB 1*2048kB 1*4096kB = 9820kB
DMA32: 6345*4kB 11*8kB 0*16kB 1*32kB 8*64kB 1*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 26652kB
664959 total pagecache pages
85 pages in swap cache
Swap cache stats: add 14715, delete 14630, find 8497/9715
Free swap  = 6428380kB
Total swap = 6434024kB
786304 pages RAM
17738 pages reserved
415071 pages shared
358313 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default order: 3, min order: 1
  kmalloc-4096 debugging increased min order, use slub_debug=O to disable.
  node 0: slabs: 63, objs: 429, free: 0
eth2: Memory squeeze, dropping packet.
grep: page allocation failure. order:1, mode:0x4020
Pid: 17920, comm: grep Not tainted 2.6.32-rc2-zfs #1
Call Trace:
 <IRQ>  [<ffffffff81081d93>] __alloc_pages_nodemask+0x623/0x6c0
 [<ffffffff810aa1fb>] __slab_alloc+0x57b/0x710
 [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
 [<ffffffff8130bd3f>] ? printk+0x67/0x69
 [<ffffffff810ab087>] __kmalloc_track_caller+0x117/0x150
 [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
 [<ffffffff8126ac9e>] __alloc_skb+0x6e/0x170
 [<ffffffff8126baaf>] __netdev_alloc_skb+0x1f/0x40
 [<ffffffff8123cb66>] rtl8139_poll+0x146/0x400
 [<ffffffff81272e63>] net_rx_action+0x183/0x260
 [<ffffffff81272ddc>] ? net_rx_action+0xfc/0x260
 [<ffffffff81041510>] __do_softirq+0xd0/0x180
 [<ffffffff8100c4bc>] call_softirq+0x1c/0x30
 [<ffffffff8100e81d>] do_softirq+0x7d/0xc0
 [<ffffffff81040fdd>] irq_exit+0x8d/0xb0
 [<ffffffff8100da37>] do_IRQ+0x77/0xf0
 [<ffffffff8100bc93>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8130f938>] ? _spin_unlock_irqrestore+0x68/0x70
 [<ffffffff81185bac>] ? debug_check_no_obj_freed+0x17c/0x1f0
 [<ffffffff81080b71>] ? free_hot_cold_page+0xd1/0x320
 [<ffffffff81080df9>] ? __pagevec_free+0x39/0x50
 [<ffffffff81084748>] ? release_pages+0x228/0x240
 [<ffffffff810a1d5d>] ? free_pages_and_swap_cache+0x8d/0xb0
 [<ffffffff810984e8>] ? exit_mmap+0x188/0x1a0
 [<ffffffff81038827>] ? mmput+0x57/0xe0
 [<ffffffff8103d0fc>] ? exit_mm+0xfc/0x140
 [<ffffffff8103f230>] ? do_exit+0x6f0/0x780
 [<ffffffff81057546>] ? up_read+0x26/0x30
 [<ffffffff8100bd2d>] ? retint_swapgs+0xe/0x13
 [<ffffffff8103f301>] ? do_group_exit+0x41/0xc0
 [<ffffffff8103f392>] ? sys_exit_group+0x12/0x20
 [<ffffffff8100b36b>] ? system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  68
CPU    1: hi:  186, btch:  31 usd: 159
active_anon:19913 inactive_anon:4195 isolated_anon:0
 active_file:270517 inactive_file:394446 isolated_file:0
 unevictable:0 dirty:3482 writeback:0 unstable:0 buffer:110281
 free:8808 slab_reclaimable:59817 slab_unreclaimable:4302
 mapped:1447 shmem:0 pagetables:960 bounce:0
DMA free:9820kB min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:9216kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3013 3013 3013
DMA32 free:25288kB min:7012kB low:8764kB high:10516kB active_anon:79800kB inactive_anon:16780kB active_file:1082068kB inactive_file:1577784kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3086052kB mlocked:0kB dirty:13928kB writeback:0kB mapped:5788kB shmem:0kB slab_reclaimable:239268kB slab_unreclaimable:17200kB kernel_stack:1104kB pagetables:3840kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 5*8kB 3*16kB 4*32kB 4*64kB 3*128kB 3*256kB 2*512kB 1*1024kB 1*2048kB 1*4096kB = 9820kB
DMA32: 6004*4kB 11*8kB 0*16kB 1*32kB 8*64kB [230203.339219] eth2: link down
