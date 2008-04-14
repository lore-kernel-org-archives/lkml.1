Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbYDNG5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbYDNG5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYDNG52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:57:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38604 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbYDNG51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:57:27 -0400
Date: Mon, 14 Apr 2008 08:57:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG/PATCH] x86 mmiotrace: dynamically disable non-boot CPUs
Message-ID: <20080414065713.GB16163@elte.hu>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi> <20080413230552.33ca587a@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413230552.33ca587a@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


thanks Pekka, i've applied your patches.

i'm wondering about this though:

> Mmiotrace is not reliable with multiple CPUs and may miss events. Drop 
> to single CPU when mmiotrace is activated.

we should fix this restriction ASAP. Forcibly dropping to UP will cause 
mmiotrace to be much less useful for diagnostic purposes of Linux 
drivers. We want to enable the mmiotrace-ing of specific devices via 
some /sys flag. For example via:

   cat /sys/devices/pci0000\:00/0000\:00\:1f.2/mmiotrace

this should start mmiotracing of that specific device - or something 
like that. Hm?

> When I tested this patch on Intel Core 2 Duo, enter_uniprocessor() 
> triggered the following kernel bug:
> 
> Linux version 2.6.25-rc8-sched-devel.git-x86-latest.git (paalanen@ct200006)
> (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #2 SMP PREEMPT Sun Apr 13
> 22:09:03 EEST 2008
> ...
> in mmio_trace_init
> mmiotrace: Disabling non-boot CPUs...
> CPU 1 is now offline
> lockdep: fixing up alternatives.
> SMP alternatives: switching to UP code
> BUG: sleeping function called from invalid context at mm/slab.c:3053
> in_atomic():1, irqs_disabled():0
> 5 locks held by bash/4423:
>  #0:  (trace_types_lock){--..}, at: [<ffffffff8026442f>] tracing_set_trace_write+0x93/0x11a
>  #1:  (mmiotrace_mutex){--..}, at: [<ffffffff802251e0>] enable_mmiotrace+0x17/0x142
>  #2:  (cpu_add_remove_lock){--..}, at: [<ffffffff802580e5>] cpu_maps_update_begin+0x12/0x14
>  #3:  (&cpu_hotplug.lock){--..}, at: [<ffffffff8025814f>] cpu_hotplug_begin+0x39/0x9f
>  #4:  (smp_alt){--..}, at: [<ffffffff80211bd9>] alternatives_smp_switch+0x66/0x1ab
> Pid: 4423, comm: bash Not tainted 2.6.25-rc8-sched-devel.git-x86-latest.git #2
> 
> Call Trace:
>  [<ffffffff802520c0>] ? __debug_show_held_locks+0x22/0x24
>  [<ffffffff8022d292>] __might_sleep+0xd9/0xdb
>  [<ffffffff80287326>] cache_alloc_debugcheck_before+0x23/0x32
>  [<ffffffff80287a32>] __kmalloc+0x34/0xa5
>  [<ffffffff80209393>] ? clear_ti_thread_flag+0x10/0x17
>  [<ffffffff8027d7f6>] kmalloc_node+0x9/0xb
>  [<ffffffff8027d8e0>] __get_vm_area_node+0xa2/0x1cb
>  [<ffffffff80209393>] ? clear_ti_thread_flag+0x10/0x17
>  [<ffffffff8027da41>] __get_vm_area+0x13/0x15
>  [<ffffffff8027da60>] get_vm_area+0x1d/0x1f
>  [<ffffffff8027e14c>] vmap+0x2a/0x5c
>  [<ffffffff8021191b>] text_poke+0xaa/0x136
>  [<ffffffff804cba2b>] ? _etext+0x0/0x5
>  [<ffffffff802119f6>] alternatives_smp_unlock+0x4f/0x63
>  [<ffffffff80211ce1>] alternatives_smp_switch+0x16e/0x1ab
>  [<ffffffff8021b163>] __cpu_die+0x53/0x7d
>  [<ffffffff802583e2>] _cpu_down+0x195/0x26c
>  [<ffffffff802585ca>] cpu_down+0x26/0x36
>  [<ffffffff80225270>] enable_mmiotrace+0xa7/0x142
>  [<ffffffff80266b8d>] mmio_trace_init+0x3c/0x40
>  [<ffffffff8026448e>] tracing_set_trace_write+0xf2/0x11a
>  [<ffffffff80327fac>] ? security_file_permission+0x11/0x13
>  [<ffffffff8028b047>] vfs_write+0xa7/0xe1
>  [<ffffffff8028b13b>] sys_write+0x47/0x6d
>  [<ffffffff8020b4db>] system_call_after_swapgs+0x7b/0x80
> 
> mmiotrace: CPU1 is down.
> mmiotrace: enabled.
> 
> Is this my fault, or is there a bug somewhere else? The kernel tree is 
> sched-devel/latest git from 12th April, IIRC.

there's no known bug of sched-devel/latest of this kind (or any known 
bug for that matter).

i suspect the bug is that you bring the CPU down from an atomic 
(spinlocked or irq disabled) context.

	Ingo
