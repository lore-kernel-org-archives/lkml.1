Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbYKQVAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbYKQVAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYKQVAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:00:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYKQVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:00:03 -0500
Date: Mon, 17 Nov 2008 15:59:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Steven Rostedt wrote:
> 
> Note, I was using a default config that had CONFIG_IRQSTACKS off and
> CONFIG_PPC_64K_PAGES on.

Here's my stack after boot up with CONFIG_IRQSTACKS set. Seems that 
softirqs still use the same stack as the process.

root@electra ~> cat /debug/tracing/stack_trace 
        Depth   Size      Location    (59 entries)
        -----   ----      --------
  0)    12384     192   ftrace_call+0x4/0x14
  1)    12192     128   .sched_clock+0x20/0x60
  2)    12064     128   .sched_clock_cpu+0x34/0x50
  3)    11936     144   .cpu_clock+0x3c/0xa0
  4)    11792     144   .get_timestamp+0x2c/0x50
  5)    11648     144   .__touch_softlockup_watchdog+0x3c/0x60
  6)    11504     192   .softlockup_tick+0xe4/0x220
  7)    11312     128   .run_local_timers+0x34/0x50
  8)    11184     160   .update_process_times+0x44/0xb0
  9)    11024     176   .tick_sched_timer+0x8c/0x120
 10)    10848     160   .__run_hrtimer+0xd8/0x130
 11)    10688     240   .hrtimer_interrupt+0x16c/0x220
 12)    10448     160   .timer_interrupt+0xcc/0x110
 13)    10288      96   decrementer_common+0xe0/0x100
 14)    10192     784   .ftrace_test_stop_func+0x4c/0x70
 15)     9408     112   ftrace_call+0x4/0x14
 16)     9296     144   .init_buffer_head+0x20/0x60
 17)     9152     256   .cache_alloc_refill+0x5a0/0x740
 18)     8896     160   .kmem_cache_alloc+0xfc/0x140
 19)     8736     144   .alloc_buffer_head+0x3c/0xc0
 20)     8592     176   .alloc_page_buffers+0xb0/0x130
 21)     8416     160   .create_empty_buffers+0x44/0x1a0
 22)     8256    1280   .block_read_full_page+0x3b0/0x430
 23)     6976     144   .blkdev_readpage+0x38/0x60
 24)     6832     176   .read_cache_page_async+0x124/0x230
 25)     6656     160   .read_cache_page+0x50/0xe0
 26)     6496     160   .read_dev_sector+0x58/0x100
 27)     6336     272   .msdos_partition+0xa4/0x880
 28)     6064     240   .rescan_partitions+0x1f0/0x430
 29)     5824     208   .__blkdev_get+0x124/0x3d0
 30)     5616     144   .blkdev_get+0x3c/0x60
 31)     5472     192   .register_disk+0x194/0x1f0
 32)     5280     160   .add_disk+0xe8/0x160
 33)     5120     224   .sd_probe+0x2f0/0x440
 34)     4896     176   .driver_probe_device+0x14c/0x380
 35)     4720     144   .__device_attach+0x38/0x60
 36)     4576     192   .bus_for_each_drv+0xb8/0x120
 37)     4384     160   .device_attach+0x94/0xe0
 38)     4224     144   .bus_attach_device+0x78/0xb0
 39)     4080     240   .device_add+0x54c/0x730
 40)     3840     160   .scsi_sysfs_add_sdev+0x7c/0x2e0
 41)     3680     336   .scsi_probe_and_add_lun+0xb7c/0xc60
 42)     3344     192   .__scsi_add_device+0x11c/0x150
 43)     3152     176   .ata_scsi_scan_host+0x238/0x330
 44)     2976     208   .ata_host_register+0x320/0x3c0
 45)     2768     192   .ata_host_activate+0xf8/0x190
 46)     2576     224   .mv_pci_init_one+0x284/0x430
 47)     2352     160   .pci_device_probe+0x98/0xf0
 48)     2192     176   .driver_probe_device+0x14c/0x380
 49)     2016     160   .__driver_attach+0xd4/0x110
 50)     1856     192   .bus_for_each_dev+0xa8/0x100
 51)     1664     144   .driver_attach+0x40/0x60
 52)     1520     192   .bus_add_driver+0x268/0x340
 53)     1328     176   .driver_register+0x88/0x1d0
 54)     1152     176   .__pci_register_driver+0x90/0x100
 55)      976     144   .mv_init+0x38/0xa0
 56)      832     544   .do_one_initcall+0x78/0x240
 57)      288     192   .kernel_init+0x21c/0x2b0
 58)       96      96   .kernel_thread+0x54/0x70

This is still 12K. Kind of big even for a 16K stack.

-- Steve

