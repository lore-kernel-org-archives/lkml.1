Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXEVUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXEVUAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXEVUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:00:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:38765 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbXEVUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ifz10A5+VWZb2gRUtGr8RA+IXz5GTaiVniWljH2p4/+5MG/Eo0iAMoloA/jcYCadtRqz4pHMVbVmcXUfNpxEW0184uAbv5d2WhCQl63dweD6wW3fnUR8sIIHkLkir1qO8QxtyXonIp6MucilDYgrcEP/8cyNqbp3ZgUqzIazLJs=
Message-ID: <46534BAE.2010000@googlemail.com>
Date: Tue, 22 May 2007 21:59:42 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] local_softirq_pending storm
References: <200705091942.22920.kernel@prachanda.hub>	 <200705191525.28400.kernel@prachanda.hub>	 <1179601868.12981.127.camel@chaos>	 <200705200253.44992.kernel@prachanda.hub>	 <1179697388.6570.26.camel@chaos> <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com>
In-Reply-To: <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> Hi Thomas,
> 
> On 20/05/07, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Sun, 2007-05-20 at 02:53 +0530, Anant Nitya wrote:
>> > > 1 == TASK_INTERRUPTIBLE, so we know that ksoftirqd was not woken
>> up. At
>> > > least it is not a scheduler problem.
>> > >
>> > > I work out a more complex debug patch and pester you to test once I'm
>> > > done.
>> > No problem :)
>>
>> You asked for it :)
>>
>> Please patch 2.6.22-rc2 with
>>
>> http://tglx.de/projects/hrtimers/2.6.22-rc2/patch-2.6.22-rc2-hrt2.patch
>> and
>> http://www.tglx.de/private/tglx/ht-debug/tracer.diff
>>
>> Compile it with the config
>>
>> http://www.tglx.de/private/tglx/ht-debug/config.debug
>>
>> You should find something like:
>>
>> (         swapper-0    |#0): new 67173 us user-latency.
>>
>> along with the familiar "NOHZ ......" message in your log file.
>>
>> Once that happened please do:
>>
>> $ cat /proc/latency_trace >trace.txt
>>
>> compress it and send it to me along with the full dmesg output or put
>> both up to some place, where I can download it.
>>
>> Michal,
>>
>> IIRC you encountered the same P4/HT related wreckage. Can you do the
>> same ?
> 
> Good news - I can't reproduce this bug. It's time to remove
> "Subject    : 2.6.21-git4 BUG: soft lockup detected on CPU#1!
> References : http://lkml.org/lkml/2007/5/2/511
> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged"
> from KR.
> 
> Bad news - I hit a bug in 2.6.22-rc2-hrt3. Bug symptoms:
> - X hangs (keyboard, mouse, sound etc.)
> - only Magic SysRq works
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc2-hrt3/hrt-config
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc2-hrt3/hrt-console.log
> 
> 
> Now I'm trying to apply hrtimers debug patch ontop 2.6.22-rc2-hrt3
> http://lkml.org/lkml/2007/3/23/106
> 

It _almost_ works

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc2-hrt3/hrtimers_debug.patch

Hmmm..

[  135.206505] SysRq : Show Pending Timers
[  135.210476] Timer List Version: v0.3
[  135.214102] HRTIMER_MAX_CLOCK_BASES: 2
[  135.217899] now at 112955954742 nsecs
[  135.221651]
[  135.221662] cpu: 0
[  135.225246]  clock 0:
[  135.227588]   .index:      0
[  135.230545]   .resolution: 1 nsecs
[  135.234010]   .get_time:   ktime_get_real
[  135.238151]   .offset:     1179862680097808665 nsecs
[  135.243207] active timers:
[  135.245992]  clock 1:
[  135.248316]   .index:      1
[  135.251246]   .resolution: 1 nsecs
[  135.254722]   .get_time:   ktime_get
[  135.258473]   .offset:     0 nsecs
[  135.261923] active timers:
[  135.264683]  #0: hardirq_stack, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
[  135.273913]  # expires at 112952000000 nsecs [in 18446744073705596874 nsecs]
[  135.281194]  #1: hardirq_stack, hrtimer_wakeup, S:01, futex_wait, automount/2293
[  135.289057]  # expires at 113902202172 nsecs [in 946247430 nsecs]
[  135.295233]  #2: hardirq_stack, hrtimer_wakeup, S:01, do_nanosleep, crond/2373
[  135.302973]  # expires at 121028637388 nsecs [in 8072682646 nsecs]
[  135.309279]  #3: hardirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2171
[  135.316701]  # expires at 121465401717 nsecs [in 8509446975 nsecs]
[  135.323035]   .expires_next   : 112952000000 nsecs
[  135.327921]   .exp_prev       : 112951000000 nsecs
[  135.332786]  last expires_next stacktrace:
[  135.336944]   update_cpu_base_expires_next
[  135.341188]   hrtimer_interrupt
[  135.344430]   smp_apic_timer_interrupt
[  135.348310]   apic_timer_interrupt
[  135.351845]   __mcount
[  135.354327]   mcount
[  135.356627]   permission
[  135.359298]   vfs_permission
[  135.362305]   __link_path_walk
[  135.365497]   link_path_walk
[  135.368486]   path_walk
[  135.371044]   do_path_lookup
[  135.374086]   __user_walk_fd
[  135.377122]   vfs_stat_fd
[  135.379905]   vfs_stat
[  135.382385]   sys_stat64
[  135.385065]   syscall_call
[  135.387909]   <3>BUG: sleeping function called from invalid context at kernel/mutex.c:86
[  135.396175] in_atomic():1, irqs_disabled():1
[  135.400541] 2 locks held by readahead/2442:
[  135.404783]  #0:  (&serio->lock){++..}, at: [<c02dbf17>] serio_interrupt+0x22/0x79
[  135.412623]  #1:  (sysrq_key_table_lock){+...}, at: [<c027a4af>] __handle_sysrq+0x1b/0x10c
[  135.421208] irq event stamp: 3249062
[  135.424856] hardirqs last  enabled at (3249061): [<c0181b67>] kmem_cache_free+0x97/0xa1
[  135.433050] hardirqs last disabled at (3249062): [<c0104bd4>] common_interrupt+0x24/0x34
[  135.441350] softirqs last  enabled at (3248980): [<c012a418>] __do_softirq+0xe8/0xef
[  135.449261] softirqs last disabled at (3248975): [<c0106df7>] do_softirq+0x69/0xd6
[  135.457049]  [<c010526c>] show_trace_log_lvl+0x35/0x54
[  135.462312]  [<c0106027>] show_trace+0x2c/0x2e
[  135.466876]  [<c01060d0>] dump_stack+0x29/0x2b
[  135.471423]  [<c011de0c>] __might_sleep+0xe0/0xe2
[  135.476221]  [<c0360257>] mutex_lock+0x22/0x2e
[  135.480767]  [<c014eb96>] lookup_module_symbol_name+0x1a/0xc4
[  135.486739]  [<c014f514>] lookup_symbol_name+0x62/0x69
[  135.492021]  [<c013eb45>] print_name_offset+0x29/0x81
[  135.497200]  [<c013f4c5>] timer_list_show+0x657/0xc55
[  135.502368]  [<c013fae2>] sysrq_timer_list_show+0x1f/0x21
[  135.507859]  [<c027a5fd>] sysrq_handle_show_timers+0xd/0xf
[  135.513451]  [<c027a525>] __handle_sysrq+0x91/0x10c
[  135.518507]  [<c027a79e>] handle_sysrq+0x37/0x39
[  135.523296]  [<c0274b00>] kbd_event+0x335/0x58d
[  135.527921]  [<c02df806>] input_event+0x43e/0x460
[  135.532718]  [<c02e3766>] atkbd_interrupt+0x467/0x58d
[  135.537887]  [<c02dbf37>] serio_interrupt+0x42/0x79
[  135.542865]  [<c02dceed>] i8042_interrupt+0x1ff/0x210
[  135.548130]  [<c0160963>] handle_IRQ_event+0x24/0x54
[  135.553187]  [<c0161b2a>] handle_edge_irq+0xd7/0x11f
[  135.558253]  [<c0106f46>] do_IRQ+0xe2/0x10c
[  135.562544]  [<c0104bde>] common_interrupt+0x2e/0x34
[  135.567675]  [<c0116134>] mcount+0x14/0x18
[  135.571858]  [<c019b9ab>] mntput_no_expire+0xd/0x89
[  135.576845]  [<c018cd6a>] path_release+0x2f/0x33
[  135.581645]  [<c01893f4>] vfs_stat_fd+0x4c/0x55
[  135.586276]  [<c01894c9>] vfs_stat+0x25/0x27
[  135.590660]  [<c01894e9>] sys_stat64+0x1e/0x37
[  135.595215]  [<c01041f5>] syscall_call+0x7/0xb
[  135.599752]  =======================
[  135.603365] ---------------------------
[  135.607229] | preempt count: 00010000 ]
[  135.611146] | 0-level deep critical section nesting:
[  135.616202] ----------------------------------------
[  135.621258]
[  135.795930] (       readahead-2442 |#0): new 112512428 us user-latency.
[  135.802591] stopped custom tracer.
[  135.806058] BUG: at kernel/mutex.c:132 __mutex_lock_common()
[  135.811824]  [<c010526c>] show_trace_log_lvl+0x35/0x54
[  135.817035]  [<c0106027>] show_trace+0x2c/0x2e
[  135.821557]  [<c01060d0>] dump_stack+0x29/0x2b
[  135.826078]  [<c035fff2>] __mutex_lock_slowpath+0x64/0x2a7
[  135.831714]  [<c036025e>] mutex_lock+0x29/0x2e
[  135.836277]  [<c014eb96>] lookup_module_symbol_name+0x1a/0xc4
[  135.842121]  [<c014f514>] lookup_symbol_name+0x62/0x69
[  135.847342]  [<c013eb45>] print_name_offset+0x29/0x81
[  135.852478]  [<c013f4c5>] timer_list_show+0x657/0xc55
[  135.857611]  [<c013fae2>] sysrq_timer_list_show+0x1f/0x21
[  135.863128]  [<c027a5fd>] sysrq_handle_show_timers+0xd/0xf
[  135.868744]  [<c027a525>] __handle_sysrq+0x91/0x10c
[  135.873689]  [<c027a79e>] handle_sysrq+0x37/0x39
[  135.878383]  [<c0274b00>] kbd_event+0x335/0x58d
[  135.882991]  [<c02df806>] input_event+0x43e/0x460
[  135.887806]  [<c02e3766>] atkbd_interrupt+0x467/0x58d
[  135.892948]  [<c02dbf37>] serio_interrupt+0x42/0x79
[  135.897918]  [<c02dceed>] i8042_interrupt+0x1ff/0x210
[  135.903053]  [<c0160963>] handle_IRQ_event+0x24/0x54
[  135.908120]  [<c0161b2a>] handle_edge_irq+0xd7/0x11f
[  135.913176]  [<c0106f46>] do_IRQ+0xe2/0x10c
[  135.917449]  [<c0104bde>] common_interrupt+0x2e/0x34
[  135.922502]  [<c0116134>] mcount+0x14/0x18
[  135.926696]  [<c019b9ab>] mntput_no_expire+0xd/0x89
[  135.931657]  [<c018cd6a>] path_release+0x2f/0x33
[  135.936378]  [<c01893f4>] vfs_stat_fd+0x4c/0x55
[  135.941001]  [<c01894c9>] vfs_stat+0x25/0x27
[  135.945376]  [<c01894e9>] sys_stat64+0x1e/0x37
[  135.949931]  [<c01041f5>] syscall_call+0x7/0xb
[  135.954467]  =======================
[  135.958091] ---------------------------
[  135.962015] | preempt count: 00010000 ]
[  135.965905] | 0-level deep critical section nesting:
[  135.970927] ----------------------------------------
[  135.975931]
[  135.977468] <ffffffff>
[  135.979865]
[  135.981396]   .hres_active    : 1
[  135.984757]   .nr_events      : 91663
[  135.988465]   .nohz_mode      : 2
[  135.991820]   .idle_tick      : 112686000000 nsecs
[  135.996651]   .tick_stopped   : 0
[  136.000016]   .idle_jiffies   : 4294779982
[  136.004190]   .idle_calls     : 30792
[  136.007882]   .idle_sleeps    : 3020
[  136.011486]   .idle_entrytime : 112932690671 nsecs
[  136.016335]   .idle_sleeptime : 18007304053 nsecs
[  136.021063]   .last_jiffies   : 4294780229
[  136.025220]   .next_jiffies   : 4294780556
[  136.029352]   .idle_expires   : 112855000000 nsecs
[  136.034167] jiffies: 4294780248
[  136.037331]
[  136.037336] cpu: 1
[  136.040884]  clock 0:
[  136.043182]   .index:      0
[  136.046087]   .resolution: 1 nsecs
[  136.049535]   .get_time:   ktime_get_real
[  136.053739]   .offset:     1179862680097808665 nsecs
[  136.058751] active timers:
[  136.061501]  clock 1:
[  136.063877]   .index:      1
[  136.066781]   .resolution: 1 nsecs
[  136.070229]   .get_time:   ktime_get
[  136.073922]   .offset:     0 nsecs
[  136.077465] active timers:
[  136.080293]  #0: hardirq_stack, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
[  136.089309]  # expires at 113828250000 nsecs [in 872295258 nsecs]
[  136.095654]  #1: hardirq_stack, hrtimer_wakeup, S:01, futex_wait, automount/2294
[  136.103356]  # expires at 113902196736 nsecs [in 946241994 nsecs]
[  136.109485]  #2: hardirq_stack, hrtimer_wakeup, S:01, do_nanosleep, smartd/2640
[  136.117101]  # expires at 1897330250564 nsecs [in 1784374295822 nsecs]
[  136.123723]   .expires_next   : 113871250000 nsecs
[  136.128726]   .exp_prev       : 113875250000 nsecs
[  136.133558]  last expires_next stacktrace:
[  136.137662]   update_cpu_base_expires_next
[  136.141838]   hrtimer_interrupt
[  136.145071]   smp_apic_timer_interrupt
[  136.148935]   apic_timer_interrupt
[  136.152419]   cpu_idle
[  136.154890]   start_secondary
[  136.157967]   <00000000>
[  136.160639]   <ffffffff>
[  136.163267]
[  136.164789]   .hres_active    : 1
[  136.168143]   .nr_events      : 85123
[  136.171981]   .nohz_mode      : 2
[  136.175344]   .idle_tick      : 112682250000 nsecs
[  136.180281]   .tick_stopped   : 0
[  136.183737]   .idle_jiffies   : 4294779978
[  136.187974]   .idle_calls     : 44643
[  136.191708]   .idle_sleeps    : 1384
[  136.195424]   .idle_entrytime : 113942257992 nsecs
[  136.200421]   .idle_sleeptime : 18596870874 nsecs
[  136.205158]   .last_jiffies   : 4294780248
[  136.209316]   .next_jiffies   : 4294780261
[  136.213595]   .idle_expires   : 112778000000 nsecs
[  136.218451] jiffies: 4294780248
[  136.221650]
[  136.223163]
[  136.223168] Tick Device: mode:     1
[  136.228383] Clock Event Device: pit
[  136.231928]  max_delta_ns:   27461866
[  136.235636]  min_delta_ns:   12571
[  136.239172]  mult:           5124677
[  136.242769]  shift:          32
[  136.245965]  mode:           3
[  136.249095]  next_event:     9223372036854775807 nsecs
[  136.254282]  set_next_event: pit_next_event
[  136.258613]  set_mode:       init_pit_timer
[  136.262908]  event_handler:  tick_handle_oneshot_broadcast
[  136.268510] tick_broadcast_mask: 00000000
[  136.272583] tick_broadcast_oneshot_mask: 00000000
[  136.277310]
[  136.278840]
[  136.278845] Tick Device: mode:     1
[  136.284086] Clock Event Device: lapic
[  136.287803]  max_delta_ns:   671411430
[  136.291615]  min_delta_ns:   1200
[  136.294977]  mult:           53661274
[  136.298668]  shift:          32
[  136.301902]  mode:           3
[  136.304971]  next_event:     112952000000 nsecs
[  136.309638]  set_next_event: lapic_next_event
[  136.314177]  set_mode:       lapic_timer_setup
[  136.318680]  event_handler:  hrtimer_interrupt
[  136.323236]
[  136.323241] Tick Device: mode:     1
[  136.328404] Clock Event Device: lapic
[  136.332191]  max_delta_ns:   671411430
[  136.335977]  min_delta_ns:   1200
[  136.339367]  mult:           53661274
[  136.343075]  shift:          32
[  136.346268]  mode:           3
[  136.349375]  next_event:     114098250000 nsecs
[  136.353914]  set_next_event: lapic_next_event
[  136.358357]  set_mode:       lapic_timer_setup
[  136.362973]  event_handler:  hrtimer_interrupt

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
