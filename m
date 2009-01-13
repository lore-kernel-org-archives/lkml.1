Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZAMWrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZAMWrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZAMWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:47:11 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:60103 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZAMWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:47:08 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Tue, 13 Jan 2009 23:47:11 +0100
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <494698AF.4020204@gmail.com> <496CE55F.2080506@gmail.com> <496D09F4.40209@gmail.com>
In-Reply-To: <496D09F4.40209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901132347.11383.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19zTzlJqYfoLrbj1RwpiDrhRk8e/fA34wpq9r0S
	+01NvgUd5crL81PQiH5YwvmOYyIJSvbTLMgr+68Fn9vjkSlNAd
	j22c91+1w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added lkml - so please keep the CC!)

On Tuesday 13 January 2009 22:39:00 Artur Skawina wrote:
> Artur Skawina wrote:
> >>> The machine has 512M, ~100M should be (usually is) free, is under constant light
> >>> load (typically <2k ints/s, 60% idle) and is running fine for weeks/months between
> >>> reboots, but locks up after only a few packets go over the hostap driven
> >>> p54usb device. I need the box to be up, that limits the number of tests i can
> >>> run, at least as long as the lockups w/o any diagnostics happen...
> >> Do keyboard-leds "flash" when it locks up, or does console respond 
> >> if you press alt-sysrq-m / alt-sysrq-w on the connected keyboard?
> > 
> > most of the times it happened there was no kbd attached. At least once
> > when it _was_ connected, sysrq was working, and i saw 0*8KB; that's why
> > i initially suspected fragmentation.
> > 
> >> ( If your box has a serial port, you can try to get the logs from there...  )
> 
> after switching from SLUB to SLAB and enabling some debugging i finally caught this:

arg, that's not good... I hoped for a obvious BUG in p54, or mac80211. But not in the other part of the kernel.
I've no idea what's going on in the timer/mm part (but maybe someone else @ lkml ??!)
since "cache_free_debugcheck" has about 3 (well, there are 4, but the first one is unlikely) BUG_ON?

This smells like a memory corruption. Have you tried to enable CONFIG_DEBUG_SLAB?
Is this related to the "truesize bug", Or how long does the box survive if you don't allow named to bind/listen to wlanX ?

> ------------[ cut here ]------------
> Kernel BUG at c016a8a3 [verbose debug info unavailable]
> invalid opcode: 0000 [#1] 
> last sysfs file: /sys/devices/pci0000:00/0000:00:07.2/usb1/1-1/1-1.1/uevent
> Modules linked in: netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 budget videobuf_dma_sg budget_ci budget_core saa7146 ttpci_eeprom videobuf_core tveeprom serio_raw ir_common [last unloaded: netconsole]
> 
> Pid: 1885, comm: named Not tainted (2.6.28-rc8-00519-g90435df #42) 
> EIP: 0060:[<c016a8a3>] EFLAGS: 00210012 CPU: 0
> EIP is at cache_free_debugcheck+0x203/0x250
> EAX: dfb6c71f EBX: df803d20 ECX: dfb6c03f EDX: 00000002
> ESI: dfb6c720 EDI: 00000370 EBP: c1000000 ESP: c0669f74
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process named (pid: 1885, ti=c0669000 task=df8443d0 task.ti=deb85000)
> Stack:
>  00000000 df809660 d31d4528 00000003 00000000 00000002 c137c440 c060e2dc
>  c01483e2 dfb6c000 df808d38 df803d20 c069cb40 00200286 c016a911 00000000
>  00000005 c069cb40 00000009 c01483e2 00000020 00000001 00000100 c014850f
> Call Trace:
>  [<c01483e2>] __rcu_process_callbacks+0xd2/0x1f0
>  [<c016a911>] kmem_cache_free+0x21/0x60
>  [<c01483e2>] __rcu_process_callbacks+0xd2/0x1f0
>  [<c014850f>] rcu_process_callbacks+0xf/0x20
>  [<c0127a37>] __do_softirq+0x57/0xf0
>  [<c01279e0>] __do_softirq+0x0/0xf0
>  <IRQ> <0> [<c01277e5>] irq_exit+0x45/0x70
>  [<c0112590>] smp_apic_timer_interrupt+0x40/0x70
>  [<c0103d9c>] apic_timer_interrupt+0x28/0x30
> Code: 8b 44 24 24 b9 fe ff ff ff 89 4c 90 1c f6 43 19 08 74 0e b9 6b 00 00 00 89 f2 89 d8 e8 e7 fa ff ff 83 c4 28 89 f0 5b 5e 5f 5d c3 <0f> 0b eb fe 0f 0b eb fe 8b 43 10 8d 44 06 f8 8d b6 00 00 00 00 
> EIP: [<c016a8a3>] cache_free_debugcheck+0x203/0x250 SS:ESP 0068:c0669f74
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> followed after some time by lots of page alloc failures [1].
> 
> artur
> 
> [1]
> [...]
> __ratelimit: 1551 callbacks suppressed
> named: page allocation failure. order:0, mode:0x20
> Pid: 1885, comm: named Tainted: G      D    2.6.28-rc8-00519-g90435df #42
> Call Trace:
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
> named: page allocation failure. order:0, mode:0x20
> Pid: 1885, comm: named Tainted: G      D    2.6.28-rc8-00519-g90435df #42
> Call Trace:
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c016b573>] cache_alloc_refill+0x363/0x710
>  [<c03a52c4>] __alloc_skb+0x34/0x120
>  [<c016bcc1>] kmem_cache_alloc+0xe1/0xf0
>  [<c03a52c4>] __alloc_skb+0x34/0x120
>  [<c03b8205>] find_skb+0x35/0x90
>  [<c03b840e>] netpoll_send_udp+0x2e/0x200
>  [<e33661ad>] write_msg+0x9d/0xe0 [netconsole]
>  [<e3366110>] write_msg+0x0/0xe0 [netconsole]
>  [<c0123443>] __call_console_drivers+0x43/0x50
>  [<c01238bb>] release_console_sem+0x13b/0x1c0
>  [<c0123dd7>] vprintk+0x227/0x2d0
>  [<c0123443>] __call_console_drivers+0x43/0x50
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c04c30c0>] printk+0x17/0x1f
>  [<c0105909>] print_trace_address+0x49/0x60
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c01059a4>] dump_trace+0x84/0x100
>  [<c0105fde>] show_trace+0x4e/0x60
>  [<c04c2fc1>] dump_stack+0x6e/0x73
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c016b573>] cache_alloc_refill+0x363/0x710
>  [<c03a52c4>] __alloc_skb+0x34/0x120
>  [<c03a539e>] __alloc_skb+0x10e/0x120
>  [<c016ba6e>] __kmalloc_track_caller+0x14e/0x160
>  [<c016bc53>] kmem_cache_alloc+0x73/0xf0
>  [<c03a5da9>] dev_alloc_skb+0x19/0x30
>  [<c03a52e5>] __alloc_skb+0x55/0x120
>  [<c03a5da9>] dev_alloc_skb+0x19/0x30
>  [<c02ced8e>] boomerang_rx+0x15e/0x520
>  [<c02d04cf>] boomerang_interrupt+0x13f/0x480
>  [<e109d6a9>] budget_ci_irq+0xa9/0x100 [budget_ci]
>  [<c0103d9c>] apic_timer_interrupt+0x28/0x30
>  [<c0146348>] handle_IRQ_event+0x28/0x50
>  [<c0147600>] handle_level_irq+0x0/0xb0
>  [<c014764b>] handle_level_irq+0x4b/0xb0
>  <IRQ>  [<c0103d6f>] common_interrupt+0x23/0x28
>  [<c024007b>] prio_tree_right+0xab/0x100
>  [<c02442f7>] delay_tsc+0x17/0x20
>  [<c0244298>] __const_udelay+0x18/0x20
>  [<c04c304a>] panic+0x84/0xe3
>  [<c010584c>] oops_end+0x7c/0x90
>  [<c01045d0>] do_invalid_op+0x0/0xa0
>  [<c0104651>] do_invalid_op+0x81/0xa0
>  [<c016a8a3>] cache_free_debugcheck+0x203/0x250
>  [<c011d233>] __wake_up_common+0x43/0x70
>  [<c04c4b82>] error_code+0x6a/0x70
>  [<c016a8a3>] cache_free_debugcheck+0x203/0x250
>  [<c01483e2>] __rcu_process_callbacks+0xd2/0x1f0
>  [<c016a911>] kmem_cache_free+0x21/0x60
>  [<c01483e2>] __rcu_process_callbacks+0xd2/0x1f0
>  [<c014850f>] rcu_process_callbacks+0xf/0x20
>  [<c0127a37>] __do_softirq+0x57/0xf0
>  [<c01279e0>] __do_softirq+0x0/0xf0
>  <IRQ>  [<c01277e5>] irq_exit+0x45/0x70
>  [<c0112590>] smp_apic_timer_interrupt+0x40/0x70
>  [<c0103d9c>] apic_timer_interrupt+0x28/0x30
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> Normal per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 174
> Active_anon:13626 active_file:3702 inactive_anon:11682
>  inactive_file:91928 unevictable:5 dirty:48 writeback:0 unstable:0
>  free:737 slab:3377 mapped:2606 pagetables:219 bounce:0
> DMA free:2004kB min:84kB low:104kB high:124kB active_anon:24kB inactive_anon:28kB active_file:104kB inactive_file:8164kB unevictable:0kB present:15872kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 492 492
> Normal free:944kB min:2792kB low:3488kB high:4188kB active_anon:54480kB inactive_anon:46700kB active_file:14704kB inactive_file:359548kB unevictable:20kB present:503928kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0
> DMA: 1*4kB 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2004kB
> Normal: 0*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 944kB
> 95760 total pagecache pages
> 0 pages in swap cache
> Swap cache stats: add 0, delete 0, find 0/0
> Free swap  = 530104kB
> Total swap = 530104kB
> 131070 pages RAM
> 2635 pages reserved
> 10978 pages shared
> 121856 pages non-shared
> named: page allocation failure. order:0, mode:0x20
> Pid: 1885, comm: named Tainted: G      D    2.6.28-rc8-00519-g90435df #42
> Call Trace:
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c016b573>] cache_alloc_refill+0x363/0x710
>  [<c03a52c4>] __alloc_skb+0x34/0x120
>  [<c016bcc1>] kmem_cache_alloc+0xe1/0xf0
>  [<c03a52c4>] __alloc_skb+0x34/0x120
>  [<c03b739b>] refill_skbs+0x5b/0x70
>  [<c03b81e9>] find_skb+0x19/0x90
>  [<c0266d90>] bit_cursor+0x0/0x610
>  [<c03b840e>] netpoll_send_udp+0x2e/0x200
>  [<e33661ad>] write_msg+0x9d/0xe0 [netconsole]
>  [<e3366110>] write_msg+0x0/0xe0 [netconsole]
>  [<c0123443>] __call_console_drivers+0x43/0x50
>  [<c01238bb>] release_console_sem+0x13b/0x1c0
>  [<c0123dd7>] vprintk+0x227/0x2d0
>  [<c0123443>] __call_console_drivers+0x43/0x50
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c04c30c0>] printk+0x17/0x1f
>  [<c0105909>] print_trace_address+0x49/0x60
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c01059a4>] dump_trace+0x84/0x100
>  [<c0105fde>] show_trace+0x4e/0x60
>  [<c04c2fc1>] dump_stack+0x6e/0x73
>  [<c01505cd>] __alloc_pages_internal+0x35d/0x470
>  [<c016b573>] cache_alloc_refill+0x363/0x710
>  [<c03a52c4>] __alloc_skb+0x34/0x120
>  [<c03a539e>] __alloc_skb+0x10e/0x120
>  [<c016ba6e>] __kmalloc_track_caller+0x14e/0x160
>  [<c016bc53>] kmem_cache_alloc+0x73/0xf0
>  [<c03a5da9>] dev_alloc_skb+0x19/0x30
>  [<c03a52e5>] __alloc_skb+0x55/0x120
>  [<c03a5da9>] dev_alloc_skb+0x19/0x30
>  [<c02ced8e>] boomerang_rx+0x15e/0x520
>  [<c02d04cf>] boomerang_interrupt+0x13f/0x480
>  [<e109d6a9>] budget_ci_irq+0xa9/0x100 [budget_ci]
>  [<c0103d9c>] apic_timer_interrupt+0x28/0x30
>  [<c0146348>] handle_IRQ_event+0x28/0x50
>  [<c0147600>] handle_level_irq+0x0/0xb0
>  [<c014764b>] handle_level_irq+0x4b/0xb0
>  <IRQ>  [<c0103d6f>] common_interrupt+0x23/0x28
>  [<c024007b>] prio_tree_right+0xab/0x100
>  [<c02442f7>] delay_tsc+0x17/0x20
>  [<c0244298>] __const_udelay+0x18/0x20
>  [<c04c304a>] panic+0x84/0xe3
>  [<c010584c>] oops_end+0x7c/0x90
>  [<c01045d0>] do_invalid_op+0x0/0xa0
>  [<c0104651>] do_invalid_op+0x81/0xa0
>  [<c016a8a3>] cache_free_debugcheck+0x203/0x250
>  [<c011d233>] __wake_up_common+0x43/0x70
>  [<c04c4b82>] error_code+0x6a/0x70
>  [<c016a8a3>] cache_free_debugcheck+0x203/0x250
>  [<c01483e2>] __rcu_process_callbacks+0xd2/0x1f0
>  [<c016a911>] kmem_cache_free+0x21/0x60
>  [<c01483e2>] __rcu_process_callbacks+0xd2/0x1f0
>  [<c014850f>] rcu_process_callbacks+0xf/0x20
>  [<c0127a37>] __do_softirq+0x57/0xf0
>  [<c01279e0>] __do_softirq+0x0/0xf0
>  <IRQ>  [<c01277e5>] irq_exit+0x45/0x70
>  [<c0112590>] smp_apic_timer_interrupt+0x40/0x70
>  [<c0103d9c>] apic_timer_interrupt+0x28/0x30
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> Normal per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 174
> Active_anon:13626 active_file:3702 inactive_anon:11682
>  inactive_file:91928 unevictable:5 dirty:48 writeback:0 unstable:0
>  free:737 slab:3377 mapped:2606 pagetables:219 bounce:0
> DMA free:2004kB min:84kB low:104kB high:124kB active_anon:24kB inactive_anon:28kB active_file:104kB inactive_file:8164kB unevictable:0kB present:15872kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 492 492
> Normal free:944kB min:2792kB low:3488kB high:4188kB active_anon:54480kB inactive_anon:46700kB active_file:14704kB inactive_file:359548kB unevictable:20kB present:503928kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0
> DMA: 1*4kB 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2004kB
> Normal: 0*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 944kB
> 95760 total pagecache pages
> 0 pages in swap cache
> Swap cache stats: add 0, delete 0, find 0/0
> Free swap  = 530104kB
> Total swap = 530104kB
> 131070 pages RAM
> 2635 pages reserved
> 10978 pages shared
> 121856 pages non-shared
> named: page allocation failure. order:0, mode:0x20
> [...]
> 
