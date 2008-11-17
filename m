Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYKQUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYKQUES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYKQUEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:04:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYKQUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:04:02 -0500
Date: Mon, 17 Nov 2008 15:03:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
In-Reply-To: <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811171458200.8722@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <18720.42209.880409.297291@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Steven Rostedt wrote:
> On Mon, 17 Nov 2008, Paul Mackerras wrote:
> > 
> > > I've tested the following patches on both PPC64 and PPC32. I will
> > > admit that the PPC64 does not seem that stable, but neither does the
> > > code when all this is not enabled ;-)  I'll debug it more to see if
> > > I can find the cause of my crashes, which may or may not be related
> > > to the dynamic ftrace code. But the use of TOCS in PPC64 make me
> > > a bit nervious that I did not do this correctly. Any help in reviewing
> > > my code for mistakes would be greatly appreciated.
> > 
> > Hmmm.  What sort of crashes are you seeing?
> 
> This code is in tip, which is mainly used to develop for x86. I've hit a 
> few crashes, and I think I hit a couple without this code. But here's an 
> example:
> 
> huh, entered softirq 4 c000000000846ad8 preempt_count 10000103, exited 
> with fffefffe?
> ------------[ cut here ]------------
> Badness at kernel/sched_fair.c:875
> NIP: c00000000004bfb8 LR: c00000000004bf7c CTR: c0000000000b5830
> REGS: c00000003929cce0 TRAP: 0700   Not tainted  (2.6.28-rc4-tip)
> MSR: 9000000000021032 <ME,IR,DR>  CR: 28822842  XER: 20000000
> TASK = c00000003d93cd10[2061] 'remove-trailing' THREAD: c00000003929c000 
> CPU: 1
> GPR00: 0000000000000001 c00000003929cf60 c000000000887070 c000000000ae2d00 
> GPR04: c00000000004c2c0 0000000000003320 c00000003929cb70 000000000000080d 
> GPR08: c00000000079333c 000000000002ffff c000000000903380 c000000000903380 
> GPR12: 0000000048822848 c000000000903580 c000000000794000 0000000000000000 
> GPR16: c000000000903380 0000000000000001 c000000000909f7c 7fffffffffffffff 
> GPR20: c00000003929d8e0 c000000000ae2f20 00000086b6e84cc0 0000000000000001 
> GPR24: 0000000000000001 c000000000794000 c00000003d93cd10 c00000003d934f20 
> GPR28: c000000000ae4000 c00000003d93cd48 c000000000803550 c00000003929cf60 
> cpu 0x1: Vector: 400 (Instruction Access) at [c00000003929be1f]
>     pc: 01c0000000000ae8
>     lr: 01c0000000000aeb
>     sp: c00000003929c09f
>    msr: 9000000040001032
>   current = 0xc00000003d93cd10
>   paca    = 0xc000000000903580
>     pid   = 2061, comm = remove-trailing
> 
> 
> Then it went into the monitor that is loaded. When I fix the rest of my 
> patches, I'll see if it is not my code that is crashing this, and then 
> I'll see if I can figure out what is causing some of these crashes.
> 


Paul,

I'm thinking that I'm hitting stack overflows. I just got this crash:

Badness at net/core/skbuff.c:393
NIP: c0000000004c805c LR: c0000000004c800c CTR: c0000000000b57d0
------------[ cut here ]------------
kernel BUG at kernel/sched.c:1155!
cpu 0x1: Vector: 700 (Program Check) at [c00000002ad18500]
    pc: c000000000049884: .resched_task+0x54/0xe0
    lr: c000000000049858: .resched_task+0x28/0xe0
    sp: c00000002ad18780
   msr: 9000000000021032
  current = 0xc00000002a516c30
  paca    = 0xc000000000903580
    pid   = 17578, comm = fixdep
kernel BUG at kernel/sched.c:1155!
enter ? for help
[c00000002ad18810] c000000000054494 .task_tick_fair+0xc4/0x120
[c00000002ad188a0] c000000000056188 .scheduler_tick+0x108/0x2d0
[c00000002ad18940] c00000000006b1d4 .update_process_times+0x74/0xb0
[c00000002ad189e0] c00000000008bb4c .tick_sched_timer+0x8c/0x120
[c00000002ad18a90] c000000000080f88 .__run_hrtimer+0xd8/0x130
[c00000002ad18b30] c000000000081fac .hrtimer_interrupt+0x16c/0x220
[c00000002ad18c20] c000000000023a0c .timer_interrupt+0xcc/0x110
[c00000002ad18cc0] c0000000000034e0 decrementer_common+0xe0/0x100
--- Exception: 901 (Decrementer) at c00000000000b978 
.raw_local_irq_restore+0x58/0x60
[link register   ] c00000000005b8d8 .vprintk+0x318/0x4b0
[c00000002ad18fb0] c00000000005b7e0 .vprintk+0x220/0x4b0 (unreliable)
[c00000002ad19110] c00000000005bac4 .printk+0x54/0x70
[c00000002ad191b0] c0000000000119d0 .show_regs+0x50/0x380
[c00000002ad19260] c000000000244150 .report_bug+0xb0/0x130
[c00000002ad19300] c0000000000253c0 .program_check_exception+0x1e0/0x610
[c00000002ad19390] c0000000000043e0 program_check_common+0xe0/0x100
--- Exception: 700 (Program Check) at c0000000004c805c 
.skb_release_head_state+0x7c/0xe0
[c00000002ad19710] c0000000004c8f0c .skb_release_all+0x2c/0x50
[c00000002ad197a0] c0000000004c80f4 .__kfree_skb+0x34/0x120
[c00000002ad19830] c0000000004c8224 .kfree_skb+0x44/0x90
[c00000002ad198c0] c0000000004d31f4 .dev_hard_start_xmit+0x224/0x390
[c00000002ad19980] c0000000004ed1d0 .__qdisc_run+0x240/0x340
[c00000002ad19a50] c0000000004d7778 .dev_queue_xmit+0x328/0x630
[c00000002ad19b00] c000000000501940 .ip_finish_output+0x160/0x3d0
[c00000002ad19bc0] c0000000005022c4 .ip_output+0xc4/0xf0
[c00000002ad19c60] c000000000501c88 .ip_local_out+0x58/0x80
[c00000002ad19cf0] c000000000502824 .ip_queue_xmit+0x254/0x480
[c00000002ad19e00] c00000000051ace8 .tcp_transmit_skb+0x498/0x970
[c00000002ad19ef0] c00000000051cf98 .__tcp_push_pending_frames+0x248/0x9a0
[c00000002ad19fe0] c000000000518ec0 .tcp_rcv_established+0x180/0x710
[c00000002ad1a0a0] c0000000005219cc .tcp_v4_do_rcv+0x11c/0x2b0
[c00000002ad1a160] c000000000524084 .tcp_v4_rcv+0x6d4/0x870
[c00000002ad1a230] c0000000004fc0e8 .ip_local_deliver+0xf8/0x2b0
[c00000002ad1a2d0] c0000000004fc614 .ip_rcv+0x374/0x670
[c00000002ad1a3a0] c0000000004d28a8 .netif_receive_skb+0x298/0x380
[c00000002ad1a470] c00000000054a528 .lro_receive_skb+0x68/0xa0
[c00000002ad1a510] c00000000031a8d4 .pasemi_mac_clean_rx+0x2e4/0x500
[c00000002ad1a610] c00000000031b534 .pasemi_mac_poll+0x54/0x150
[c00000002ad1a6b0] c0000000004d5f90 .net_rx_action+0x150/0x290
[c00000002ad1a790] c000000000062438 .__do_softirq+0xe8/0x1e0
[c00000002ad1a850] c00000000000d2c4 .do_softirq+0xa4/0xd0
[c00000002ad1a8e0] c000000000062104 .irq_exit+0xb4/0xf0
[c00000002ad1a970] c00000000000d6a4 .do_IRQ+0x114/0x150
[c00000002ad1aa10] c000000000004160 hardware_interrupt_entry+0x1c/0x3c
--- Exception: 501 (Hardware Interrupt) at c000000000193d84 
.journal_dirty_metadata+0x254/0x260
[c00000002ad1ad00] c00000000018e05c 
.__ext3_journal_dirty_metadata+0x4c/0xa0 (unreliable)
[c00000002ad1ada0] c00000000017bcf4 .ext3_mark_iloc_dirty+0x2a4/0x590
[c00000002ad1ae70] c00000000017c5ec .ext3_mark_inode_dirty+0x5c/0x80
[c00000002ad1af30] c000000000180dec .ext3_dirty_inode+0xac/0xf0
[c00000002ad1afd0] c00000000012454c .__mark_inode_dirty+0x7c/0x210
[c00000002ad1b080] c000000000178174 .ext3_new_blocks+0xd4/0x770
[c00000002ad1b1b0] c00000000017d194 .ext3_get_blocks_handle+0x2a4/0xcd0
[c00000002ad1b380] c00000000017dee0 .ext3_get_block+0xa0/0x170
[c00000002ad1b440] c00000000012ca6c .__block_prepare_write+0x32c/0x510
[c00000002ad1b580] c00000000012cd80 .block_write_begin+0x90/0x160
[c00000002ad1b640] c0000000001800e0 .ext3_write_begin+0x130/0x2c0
[c00000002ad1b760] c0000000000b9d30 
.generic_file_buffered_write+0x180/0x3c0
[c00000002ad1b8b0] c0000000000ba510 
.__generic_file_aio_write_nolock+0x2c0/0x450
[c00000002ad1b9c0] c0000000000ba730 .generic_file_aio_write+0x90/0x130
[c00000002ad1ba80] c000000000179b00 .ext3_file_write+0x60/0x130
[c00000002ad1bb30] c0000000000f8fd4 .do_sync_write+0xf4/0x160
[c00000002ad1bcd0] c0000000000f99dc .vfs_write+0xdc/0x1e0
[c00000002ad1bd80] c0000000000fa48c .sys_write+0x6c/0xd0
[c00000002ad1be30] c0000000000074b0 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 000000000ff470c4
SP (ffb8be40) is in userspace
1:mon> X

And running my stack_trace in ftrace, I've been seeing large hits on the 
stack:

root@electra ~> cat /debug/tracing/stack_trace 
        Depth   Size      Location    (56 entries)
        -----   ----      --------
  0)    14032     112   ftrace_call+0x4/0x14
  1)    13920     128   .sched_clock+0x20/0x60
  2)    13792     128   .sched_clock_cpu+0x34/0x50
  3)    13664     144   .cpu_clock+0x3c/0xa0
  4)    13520     144   .get_timestamp+0x2c/0x50
  5)    13376     192   .softlockup_tick+0x100/0x220
  6)    13184     128   .run_local_timers+0x34/0x50
  7)    13056     160   .update_process_times+0x44/0xb0
  8)    12896     176   .tick_sched_timer+0x8c/0x120
  9)    12720     160   .__run_hrtimer+0xd8/0x130
 10)    12560     240   .hrtimer_interrupt+0x16c/0x220
 11)    12320     160   .timer_interrupt+0xcc/0x110
 12)    12160     240   decrementer_common+0xe0/0x100
 13)    11920     576   0x80
 14)    11344     160   .usb_hcd_irq+0x94/0x150
 15)    11184     160   .handle_IRQ_event+0x80/0x120
 16)    11024     160   .handle_fasteoi_irq+0xd8/0x1e0
 17)    10864     160   .do_IRQ+0xbc/0x150
 18)    10704     144   hardware_interrupt_entry+0x1c/0x3c
 19)    10560     672   0x0
 20)     9888     144   ._spin_unlock_irqrestore+0x84/0xd0
 21)     9744     160   .scsi_dispatch_cmd+0x170/0x360
 22)     9584     208   .scsi_request_fn+0x324/0x5e0
 23)     9376     144   .blk_invoke_request_fn+0xc8/0x1b0
 24)     9232     144   .__blk_run_queue+0x48/0x60
 25)     9088     144   .blk_run_queue+0x40/0x70
 26)     8944     192   .scsi_run_queue+0x3a8/0x3e0
 27)     8752     160   .scsi_next_command+0x58/0x90
 28)     8592     176   .scsi_end_request+0xd4/0x130
 29)     8416     208   .scsi_io_completion+0x15c/0x500
 30)     8208     160   .scsi_finish_command+0x15c/0x190
 31)     8048     160   .scsi_softirq_done+0x138/0x1e0
 32)     7888     160   .blk_done_softirq+0xd0/0x100
 33)     7728     192   .__do_softirq+0xe8/0x1e0
 34)     7536     144   .do_softirq+0xa4/0xd0
 35)     7392     144   .irq_exit+0xb4/0xf0
 36)     7248     160   .do_IRQ+0x114/0x150
 37)     7088     752   hardware_interrupt_entry+0x1c/0x3c
 38)     6336     144   .blk_rq_init+0x28/0xc0
 39)     6192     208   .get_request+0x13c/0x3d0
 40)     5984     240   .get_request_wait+0x60/0x170
 41)     5744     192   .__make_request+0xd4/0x560
 42)     5552     192   .generic_make_request+0x210/0x300
 43)     5360     208   .submit_bio+0x168/0x1a0
 44)     5152     160   .submit_bh+0x188/0x1e0
 45)     4992    1280   .block_read_full_page+0x23c/0x430
 46)     3712    1280   .do_mpage_readpage+0x43c/0x740
 47)     2432     352   .mpage_readpages+0x130/0x1c0
 48)     2080     160   .ext3_readpages+0x50/0x80
 49)     1920     256   .__do_page_cache_readahead+0x1e4/0x340
 50)     1664     160   .do_page_cache_readahead+0x94/0xe0
 51)     1504     240   .filemap_fault+0x360/0x530
 52)     1264     256   .__do_fault+0xb8/0x600
 53)     1008     240   .handle_mm_fault+0x190/0x920
 54)      768     320   .do_page_fault+0x3d4/0x5f0
 55)      448     448   handle_page_fault+0x20/0x5c

This is one of the ftrace features, it tests the stack at every function 
call and if it is a new max, then it records the stack. This dump was what 
was recorded right after boot up. That is about 14K of stack use, and I 
hear that the stack is 16K. That looks like it is getting pretty close.

I'm also told that most PPC64 configs should have CONFIG_IRQSTACKS set, 
but I see that I do not. I am in the process of building my box without it 
and see if I still have these crashes.

-- Steve

