Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZI3UQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZI3UQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZI3UQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:16:42 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43102 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZI3UQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:16:41 -0400
Message-ID: <4AC3BC89.2050404@gmail.com>
Date: Wed, 30 Sep 2009 22:16:09 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.32-rc1
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <20090930193204.GA16350@elte.hu>
In-Reply-To: <20090930193204.GA16350@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 30 Sep 2009 22:16:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
>> From 5a76986c5dd272ea16a9b8abb7349ff3d6791c2b Mon Sep 17 00:00:00 2001
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> Date: Wed, 30 Sep 2009 17:04:35 +0200
>> Subject: [PATCH] x86: Provide an alternative() based cmpxchg64()
>>
>> Based on Linus' patch, this patch provides cmpxchg64() using
>> the alternative() infrastructure.
>>
>> Note: the fallback is NOT smp safe, just like the current fallback
>> is not SMP safe.
>>
>> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>> ---
>>  arch/x86/include/asm/cmpxchg_32.h |   29 ++++++++++--------
>>  arch/x86/kernel/i386_ksyms_32.c   |    3 ++
>>  arch/x86/lib/Makefile             |    2 +-
>>  arch/x86/lib/cmpxchg8b_emu.S      |   61 +++++++++++++++++++++++++++++++++++++
>>  4 files changed, 81 insertions(+), 14 deletions(-)
>>  create mode 100644 arch/x86/lib/cmpxchg8b_emu.S
> 
> The two patches cause hangs on 32-bit, in sched_clock_cpu(). I attached 
> the hang serial log plus the two patches as i applied them. 
> 
> Bug in cmpxchg8b_emu()?
> 
> 	Ingo
> 
> [   45.800000] i2c-core: driver [tw9910] registered
> [   45.810000] initcall tw9910_module_init+0x0/0x2e returned 0 after 9765 usecs
> [   45.810000] BUG: spinlock lockup on CPU#1, swapper/1, 7be09ec0
> [   45.810000] Pid: 1, comm: swapper Tainted: G        W  2.6.32-rc2-tip-00990-g6139d57-dirty #19124
> [   45.810000] Call Trace:
> [   45.810000]  [<79ebce42>] ? printk+0x22/0x35
> [   45.810000]  [<794356c7>] _raw_spin_lock+0x103/0x13f
> [   45.810000]  [<79ebf84d>] _spin_lock+0x3c/0x55
> [   45.810000]  [<790673e0>] ? scheduler_tick+0x44/0x20e
> [   45.810000]  [<790673e0>] scheduler_tick+0x44/0x20e
> [   45.810000]  [<790793fc>] update_process_times+0x4a/0x68
> [   45.810000]  [<7909354c>] tick_periodic+0x7a/0x8d
> [   45.810000]  [<79093588>] tick_handle_periodic+0x29/0x91
> [   45.810000]  [<7909398f>] tick_do_broadcast+0x42/0x7d
> [   45.810000]  [<79093b17>] tick_do_periodic_broadcast+0x3c/0x59
> [   45.810000]  [<79093fb0>] tick_handle_periodic_broadcast+0x20/0x70
> [   45.810000]  [<7902fac1>] timer_interrupt+0x4d/0x85
> [   45.810000]  [<790ab402>] handle_IRQ_event+0x65/0x13b
> [   45.810000]  [<790ad1fc>] handle_edge_irq+0xbe/0x111
> [   45.810000]  [<7902f553>] handle_irq+0x2f/0x46
> [   45.810000]  [<7902ee8b>] do_IRQ+0x51/0xb8
> [   45.810000]  [<7902d435>] common_interrupt+0x35/0x40
> [   45.810000]  [<7906afe2>] ? vprintk+0x3a8/0x3fa
> [   45.810000]  [<79090020>] ? ntp_clear+0x22/0x7d
> [   45.810000]  [<79ebdf6c>] ? __mutex_unlock_slowpath+0x10e/0x12f
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<79ebce42>] printk+0x22/0x35
> [   45.810000]  [<790010ed>] do_one_initcall+0xc4/0x183
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<7a562474>] do_basic_setup+0x50/0x72
> [   45.810000]  [<7a562509>] kernel_init+0x73/0xc5
> [   45.810000]  [<7a562496>] ? kernel_init+0x0/0xc5
> [   45.810000]  [<7902d997>] kernel_thread_helper+0x7/0x10
> [   45.810000] sending NMI to all CPUs:
> [   45.810000] NMI backtrace for cpu 1
> [   45.810000] 
> [   45.810000] Pid: 1, comm: swapper Tainted: G        W  (2.6.32-rc2-tip-00990-g6139d57-dirty #19124) System Product Name
> [   45.810000] EIP: 0060:[<79097b38>] EFLAGS: 00000046 CPU: 1
> [   45.810000] EIP is at trace_hardirqs_off_caller+0x3f/0xbd
> [   45.810000] EAX: 82f26dd9 EBX: b78c8000 ECX: 00000000 EDX: 790412fc
> [   45.810000] ESI: 790412fc EDI: 00000002 EBP: b78c3d10 ESP: b78c3d04
> [   45.810000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   45.810000] CR0: 8005003b CR2: 00000000 CR3: 02664000 CR4: 00000690
> [   45.810000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   45.810000] DR6: ffff0ff0 DR7: 00000400
> [   45.810000] Call Trace:
> [   45.810000]  [<79097bcf>] trace_hardirqs_off+0x19/0x2c
> [   45.810000]  [<790412fc>] default_send_IPI_mask_logical+0x8f/0xb1
> [   45.810000]  [<79041084>] default_send_IPI_all+0x35/0x87
> [   45.810000]  [<790416bc>] arch_trigger_all_cpu_backtrace+0x40/0x73
> [   45.810000]  [<794356cc>] _raw_spin_lock+0x108/0x13f
> [   45.810000]  [<79ebf84d>] _spin_lock+0x3c/0x55
> [   45.810000]  [<790673e0>] ? scheduler_tick+0x44/0x20e
> [   45.810000]  [<790673e0>] scheduler_tick+0x44/0x20e
> [   45.810000]  [<790793fc>] update_process_times+0x4a/0x68
> [   45.810000]  [<7909354c>] tick_periodic+0x7a/0x8d
> [   45.810000]  [<79093588>] tick_handle_periodic+0x29/0x91
> [   45.810000]  [<7909398f>] tick_do_broadcast+0x42/0x7d
> [   45.810000]  [<79093b17>] tick_do_periodic_broadcast+0x3c/0x59
> [   45.810000]  [<79093fb0>] tick_handle_periodic_broadcast+0x20/0x70
> [   45.810000]  [<7902fac1>] timer_interrupt+0x4d/0x85
> [   45.810000]  [<790ab402>] handle_IRQ_event+0x65/0x13b
> [   45.810000]  [<790ad1fc>] handle_edge_irq+0xbe/0x111
> [   45.810000]  [<7902f553>] handle_irq+0x2f/0x46
> [   45.810000]  [<7902ee8b>] do_IRQ+0x51/0xb8
> [   45.810000]  [<7902d435>] common_interrupt+0x35/0x40
> [   45.810000]  [<7906afe2>] ? vprintk+0x3a8/0x3fa
> [   45.810000]  [<79090020>] ? ntp_clear+0x22/0x7d
> [   45.810000]  [<79ebdf6c>] ? __mutex_unlock_slowpath+0x10e/0x12f
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<79ebce42>] printk+0x22/0x35
> [   45.810000]  [<790010ed>] do_one_initcall+0xc4/0x183
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<7a562474>] do_basic_setup+0x50/0x72
> [   45.810000]  [<7a562509>] kernel_init+0x73/0xc5
> [   45.810000]  [<7a562496>] ? kernel_init+0x0/0xc5
> [   45.810000]  [<7902d997>] kernel_thread_helper+0x7/0x10
> [   45.810000] Pid: 1, comm: swapper Tainted: G        W  2.6.32-rc2-tip-00990-g6139d57-dirty #19124
> [   45.810000] Call Trace:
> [   45.810000]  [<7902bce1>] ? show_regs+0x34/0x4b
> [   45.810000]  [<7904188d>] nmi_watchdog_tick+0xa4/0x181
> [   45.810000]  [<7902e941>] default_do_nmi+0x64/0x21e
> [   45.810000]  [<790412fc>] ? default_send_IPI_mask_logical+0x8f/0xb1
> [   45.810000]  [<7902eb5d>] do_nmi+0x62/0xad
> [   45.810000]  [<79ec0080>] nmi_stack_correct+0x2f/0x34
> [   45.810000]  [<790412fc>] ? default_send_IPI_mask_logical+0x8f/0xb1
> [   45.810000]  [<790412fc>] ? default_send_IPI_mask_logical+0x8f/0xb1
> [   45.810000]  [<79097b38>] ? trace_hardirqs_off_caller+0x3f/0xbd
> [   45.810000]  [<79097bcf>] trace_hardirqs_off+0x19/0x2c
> [   45.810000]  [<790412fc>] default_send_IPI_mask_logical+0x8f/0xb1
> [   45.810000]  [<79041084>] default_send_IPI_all+0x35/0x87
> [   45.810000]  [<790416bc>] arch_trigger_all_cpu_backtrace+0x40/0x73
> [   45.810000]  [<794356cc>] _raw_spin_lock+0x108/0x13f
> [   45.810000]  [<79ebf84d>] _spin_lock+0x3c/0x55
> [   45.810000]  [<790673e0>] ? scheduler_tick+0x44/0x20e
> [   45.810000]  [<790673e0>] scheduler_tick+0x44/0x20e
> [   45.810000]  [<790793fc>] update_process_times+0x4a/0x68
> [   45.810000]  [<7909354c>] tick_periodic+0x7a/0x8d
> [   45.810000]  [<79093588>] tick_handle_periodic+0x29/0x91
> [   45.810000]  [<7909398f>] tick_do_broadcast+0x42/0x7d
> [   45.810000]  [<79093b17>] tick_do_periodic_broadcast+0x3c/0x59
> [   45.810000]  [<79093fb0>] tick_handle_periodic_broadcast+0x20/0x70
> [   45.810000]  [<7902fac1>] timer_interrupt+0x4d/0x85
> [   45.810000]  [<790ab402>] handle_IRQ_event+0x65/0x13b
> [   45.810000]  [<790ad1fc>] handle_edge_irq+0xbe/0x111
> [   45.810000]  [<7902f553>] handle_irq+0x2f/0x46
> [   45.810000]  [<7902ee8b>] do_IRQ+0x51/0xb8
> [   45.810000]  [<7902d435>] common_interrupt+0x35/0x40
> [   45.810000]  [<7906afe2>] ? vprintk+0x3a8/0x3fa
> [   45.810000]  [<79090020>] ? ntp_clear+0x22/0x7d
> [   45.810000]  [<79ebdf6c>] ? __mutex_unlock_slowpath+0x10e/0x12f
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<79ebce42>] printk+0x22/0x35
> [   45.810000]  [<790010ed>] do_one_initcall+0xc4/0x183
> [   45.810000]  [<7a5ab658>] ? tw9910_module_init+0x0/0x2e
> [   45.810000]  [<7a562474>] do_basic_setup+0x50/0x72
> [   45.810000]  [<7a562509>] kernel_init+0x73/0xc5
> [   45.810000]  [<7a562496>] ? kernel_init+0x0/0xc5
> [   45.810000]  [<7902d997>] kernel_thread_helper+0x7/0x10
> [   45.810000] NMI backtrace for cpu 0
> [   45.810000] 
> [   45.810000] Pid: 0, comm: swapper Tainted: G        W  (2.6.32-rc2-tip-00990-g6139d57-dirty #19124) System Product Name
> [   45.810000] EIP: 0060:[<7908c649>] EFLAGS: 00000086 CPU: 0
> [   45.810000] EIP is at sched_clock_cpu+0x120/0x159
> [   45.810000] EAX: aa7d20b2 EBX: aa7d20b2 ECX: 0000000a EDX: 0000000a
> [   45.810000] ESI: 7be0a450 EDI: 00000001 EBP: 7a42de1c ESP: 7a42ddd8
> [   45.810000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   45.810000] CR0: 8005003b CR2: ffcff000 CR3: 02664000 CR4: 00000690
> [   45.810000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   45.810000] DR6: ffff0ff0 DR7: 00000400
> [   45.810000] Call Trace:
> [   45.810000]  [<7905f54b>] update_rq_clock+0x24/0x45
> [   45.810000]  [<7905f5d3>] double_rq_lock+0x67/0x7d
> [   45.810000]  [<79066bc4>] load_balance+0x116/0x355
> [   45.810000]  [<79098b07>] ? trace_hardirqs_on_caller+0x106/0x159
> [   45.810000]  [<79066ec6>] rebalance_domains+0xc3/0x134
> [   45.810000]  [<79066f78>] run_rebalance_domains+0x41/0xc2
> [   45.810000]  [<79071154>] __do_softirq+0xd2/0x1a0
> [   45.810000]  [<79071260>] do_softirq+0x3e/0x68
> [   45.810000]  [<79071423>] irq_exit+0x4b/0x9f
> [   45.810000]  [<790409e3>] smp_apic_timer_interrupt+0x81/0xa0
> [   45.810000]  [<7902d7f6>] apic_timer_interrupt+0x36/0x40
> [   45.810000]  [<7903377c>] ? test_ti_thread_flag+0x1/0x30
> [   45.810000]  [<79033878>] ? need_resched+0x27/0x42
> [   45.810000]  [<790338c2>] poll_idle+0x2f/0x76
> [   45.810000]  [<7902bd98>] cpu_idle+0xa0/0xd4
> [   45.810000]  [<79e2b392>] rest_init+0x7a/0x8d
> [   45.810000]  [<7a562ab2>] start_kernel+0x33a/0x350
> [   45.810000]  [<7a56209f>] i386_start_kernel+0x9f/0xb5
> [   45.810000] Pid: 0, comm: swapper Tainted: G        W  2.6.32-rc2-tip-00990-g6139d57-dirty #19124
> [   45.810000] Call Trace:
> [   45.810000]  [<7902bce1>] ? show_regs+0x34/0x4b
> [   45.810000]  [<7904188d>] nmi_watchdog_tick+0xa4/0x181
> [   45.810000]  [<7902e941>] default_do_nmi+0x64/0x21e
> [   45.810000]  [<7902eb5d>] do_nmi+0x62/0xad
> [   45.810000]  [<79ec0080>] nmi_stack_correct+0x2f/0x34
> [   45.810000]  [<7908c649>] ? sched_clock_cpu+0x120/0x159
> [   45.810000]  [<7905f54b>] update_rq_clock+0x24/0x45
> [   45.810000]  [<7905f5d3>] double_rq_lock+0x67/0x7d
> [   45.810000]  [<79066bc4>] load_balance+0x116/0x355
> [   45.810000]  [<79098b07>] ? trace_hardirqs_on_caller+0x106/0x159
> [   45.810000]  [<79066ec6>] rebalance_domains+0xc3/0x134
> [   45.810000]  [<79066f78>] run_rebalance_domains+0x41/0xc2
> [   45.810000]  [<79071154>] __do_softirq+0xd2/0x1a0
> [   45.810000]  [<79071260>] do_softirq+0x3e/0x68
> [   45.810000]  [<79071423>] irq_exit+0x4b/0x9f
> [   45.810000]  [<790409e3>] smp_apic_timer_interrupt+0x81/0xa0
> [   45.810000]  [<7902d7f6>] apic_timer_interrupt+0x36/0x40
> [   45.810000]  [<7903377c>] ? test_ti_thread_flag+0x1/0x30
> [   45.810000]  [<79033878>] ? need_resched+0x27/0x42
> [   45.810000]  [<790338c2>] poll_idle+0x2f/0x76
> [   45.810000]  [<7902bd98>] cpu_idle+0xa0/0xd4
> [   45.810000]  [<79e2b392>] rest_init+0x7a/0x8d
> [   45.810000]  [<7a562ab2>] start_kernel+0x33a/0x350
> [   45.810000]  [<7a56209f>] i386_start_kernel+0x9f/0xb5
> 
> commit 1cb9955464ad248c79c48e9c8be6669020fe178c
> Author: Arjan van de Ven <arjan@infradead.org>
> Date:   Wed Sep 30 20:36:19 2009 +0200
> 
>     sched_clock: Fix atomicity/continuity bug by using cmpxchg64()
>     
>     Commit def0a9b2573 (sched_clock: Make it NMI safe) assumed
>     cmpxchg() of 64bit values was available on X86_32.
>     
>     That is not so - and causes some subtle scheduler misbehavior due
>     to incorrect timestamps off to up by ~4 seconds.
>     
>     Two symptoms are known right now:
>     
>      - interactivity problems seen by Arjan: up to 600 msecs
>        latencies instead of the expected 20-40 msecs. These
>        latencies are very visible on the desktop.
>     
>      - incorrect CPU stats: occasionally too high percentages in 'top',
>        and crazy CPU usage stats.
>     
>     Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
>     Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>     Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: John Stultz <johnstul@us.ibm.com>
>     Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     LKML-Reference: <20090930170754.0886ff2e@infradead.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> index ac2e1dc..479ce56 100644
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -127,7 +127,7 @@ again:
>  	clock = wrap_max(clock, min_clock);
>  	clock = wrap_min(clock, max_clock);
>  
> -	if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
> +	if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
>  		goto again;
>  
>  	return clock;
> @@ -163,7 +163,7 @@ again:
>  		val = remote_clock;
>  	}
>  
> -	if (cmpxchg(ptr, old_val, val) != old_val)
> +	if (cmpxchg64(ptr, old_val, val) != old_val)
>  		goto again;
>  
>  	return val;
> 
> commit 8da752098d4e584fbcc149046e5c716f5d356db4
> Author: Arjan van de Ven <arjan@infradead.org>
> Date:   Wed Sep 30 17:07:54 2009 +0200
> 
>     x86: Provide an alternative() based cmpxchg64()
>     
>     cmpxchg64() today generates, to quote Linus, "barf bag" code.
>     
>     cmpxchg64() is about to get used in the scheduler to a bug there,
>     but it's a prerequisite that cmpxchg64() first be made non-sucking.
>     
>     This patch turns cmpxchg64() into an efficient implementation that
>     uses the alternative() mechanism to just use the raw instruction on
>     all modern systens
>     
>     Note: the fallback is NOT smp safe, just like the current fallback
>     is not SMP safe. (Interested parties with i486 based SMP systems
>     are welcome to submit fix patches for that.)
>     
>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>     Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Eric Dumazet <eric.dumazet@gmail.com>
>     Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>     Cc: John Stultz <johnstul@us.ibm.com>
>     Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     LKML-Reference: <20090930170754.0886ff2e@infradead.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
> index 82ceb78..3b21afa 100644
> --- a/arch/x86/include/asm/cmpxchg_32.h
> +++ b/arch/x86/include/asm/cmpxchg_32.h
> @@ -312,19 +312,22 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
>  
>  extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
>  
> -#define cmpxchg64(ptr, o, n)						\
> -({									\
> -	__typeof__(*(ptr)) __ret;					\
> -	if (likely(boot_cpu_data.x86 > 4))				\
> -		__ret = (__typeof__(*(ptr)))__cmpxchg64((ptr),		\
> -				(unsigned long long)(o),		\
> -				(unsigned long long)(n));		\
> -	else								\
> -		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
> -				(unsigned long long)(o),		\
> -				(unsigned long long)(n));		\
> -	__ret;								\
> -})
> +#define cmpxchg64(ptr, o, n)					\
> +({								\
> +	__typeof__(*(ptr)) __ret;				\
> +	__typeof__(*(ptr)) __old = (o);				\
> +	__typeof__(*(ptr)) __new = (n);				\
> +	alternative_io("call cmpxchg8b_emu",			\
> +			"lock; cmpxchg8b (%%esi)" ,		\
> +		       X86_FEATURE_CX8,				\
> +		       "=A" (__ret),				\
> +		       "S" ((ptr)), "0" (__old),		\
> +		       "b" ((unsigned int)__new),		\
> +		       "c" ((unsigned int)(__new>>32)));	\

probably a "memory" clobber is needed, alternative_io() doesnt provide it.



> +	__ret; })
> +
> +
> +
>  #define cmpxchg64_local(ptr, o, n)					\
>  ({									\
>  	__typeof__(*(ptr)) __ret;					\
> diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
> index 43cec6b..1736c5a 100644
> --- a/arch/x86/kernel/i386_ksyms_32.c
> +++ b/arch/x86/kernel/i386_ksyms_32.c
> @@ -10,6 +10,14 @@
>  EXPORT_SYMBOL(mcount);
>  #endif
>  
> +/*
> + * Note, this is a prototype to get at the symbol for
> + * the export, but dont use it from C code, it is used
> + * by assembly code and is not using C calling convention!
> + */
> +extern void cmpxchg8b_emu(void);
> +EXPORT_SYMBOL(cmpxchg8b_emu);
> +
>  /* Networking helper routines. */
>  EXPORT_SYMBOL(csum_partial_copy_generic);
>  
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index 9e60920..3e549b8 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -15,7 +15,7 @@ ifeq ($(CONFIG_X86_32),y)
>          obj-y += atomic64_32.o
>          lib-y += checksum_32.o
>          lib-y += strstr_32.o
> -        lib-y += semaphore_32.o string_32.o
> +        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
>  
>          lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
>  else
> diff --git a/arch/x86/lib/cmpxchg8b_emu.S b/arch/x86/lib/cmpxchg8b_emu.S
> new file mode 100644
> index 0000000..b8af4c7
> --- /dev/null
> +++ b/arch/x86/lib/cmpxchg8b_emu.S
> @@ -0,0 +1,61 @@
> +/*
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; version 2
> + *	of the License.
> + *
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/alternative-asm.h>
> +#include <asm/frame.h>
> +#include <asm/dwarf2.h>
> +
> +
> +.text
> +
> +/*
> + * Inputs:
> + * %esi : memory location to compare
> + * %eax : low 32 bits of old value
> + * %edx : high 32 bits of old value
> + * %ebx : low 32 bits of new value
> + * %ecx : high 32 bits of new value
> + */
> +ENTRY(cmpxchg8b_emu)
> +	CFI_STARTPROC
> +
> +	push %edi
> +	push %ebx
> +	push %ecx
> +	/* disable interrupts */
> +	pushf
> +	pop %edi
> +	cli
> +
> +	cmpl %edx, 4(%esi)
> +	jne 1f
> +	cmpl %eax, (%esi)
> +	jne 1f
> +
> +	xchg (%esi), %ebx
> +	xchg 4(%esi), %ecx
> +	mov %ebx, %eax
> +	mov %ecx, %edx
> +
> +2:
> +	/* restore interrupts */
> +	push %edi
> +	popf
> +
> +	pop %ecx
> +	pop %ebx
> +	pop %edi
> +	ret
> +1:
> +	mov (%esi), %eax
> +	mov 4(%esi), %edx
> +	jmp 2b
> +	CFI_ENDPROC
> +ENDPROC(cmpxchg8b_emu)
> +
> 

