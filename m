Return-Path: <linux-kernel-owner+w=401wt.eu-S1762557AbXHPJnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762557AbXHPJnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbXHPJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:43:42 -0400
Received: from 87-127-95-194.no-dns-yet.enta.net ([87.127.95.194]:35569 "EHLO
	oxford.xeocode.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753318AbXHPJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:43:40 -0400
X-Greylist: delayed 2974 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 05:43:39 EDT
To: linux-kernel@vger.kernel.org
Subject: soft lockup detected
From: Gregory Stark <stark@enterprisedb.com>
X-Draft-From: ("nnimap+mail01.enterprisedb.com:INBOX.patches" 2308)
Date: Thu, 16 Aug 2007 09:54:02 +0100
Message-ID: <87ps1nx3kl.fsf@oxford.xeocode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm running a program which does lots of semop calls. After a while something
strange starts happening. sleep hangs forever and if I run date I see the
clock on the machine not advancing.

In fact if I run "while : ; do date +%s,%N" I see the clock advancing find for
4.684 seconds then warping back that far. Repeatedly. It always warps back to
the same point too.

I'm getting tons of "soft lockup detected" in random places. Often in
update_process_times or in try_atomic_semop which is what the program spends
all its time doing so I guess it's not too surprising.

This is on 2.6.21-1.3194.fc7. I've been trying different kernels but this is
the first point where I've narrowed down the symptoms to something
reproducible.

Likely related (though surely this isn't the expected symptom?) there are also
memory errors in the logs. I'm not sure how to tell which DIMM this is on
though. MC1 means the memory controller on the second processor? Or the second
core on the first processor? And row 1 channel 1 means the second DIMM?

EDAC k8 MC1: general bus error: participating processor(local node origin), time-out(no timeout) memory transaction type(generic read), mem or i/o(mem access), cache level(generic)
EDAC MC1: CE page 0xaf42f, offset 0xfe0, grain 8, syndrome 0xf9b2, row 1, channel 1, label "": k8_edac
EDAC MC1: CE - no information available: k8_edac Error Overflow set
EDAC k8 MC1: extended error code: ECC chipkill x4 error

The memory errors don't occur at the same time as the soft lockup and timer
problems though.


[root@edbnj-jumpin log]# while read x ; do date ; done
Tue Aug 14 17:30:46 EDT 2007
Tue Aug 14 17:30:46 EDT 2007
Tue Aug 14 17:30:47 EDT 2007
Tue Aug 14 17:30:48 EDT 2007
Tue Aug 14 17:30:48 EDT 2007
Tue Aug 14 17:30:45 EDT 2007
Tue Aug 14 17:30:45 EDT 2007
Tue Aug 14 17:30:46 EDT 2007
Tue Aug 14 17:30:47 EDT 2007
Tue Aug 14 17:30:47 EDT 2007
Tue Aug 14 17:30:48 EDT 2007
Tue Aug 14 17:30:48 EDT 2007
Tue Aug 14 17:30:44 EDT 2007
Tue Aug 14 17:30:45 EDT 2007
...

$ while : ; do date +%s,%N ; done
...
1187127049,398740671
1187127049,400855143
1187127049,402963469
1187127049,404834931
1187127044,720649164
1187127044,722776205
1187127044,724720011
1187127044,726728620
...

BUG: soft lockup detected on CPU#1!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 =======================
BUG: soft lockup detected on CPU#3!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c04b4d42>] try_atomic_semop+0xce/0x10e
 [<c04b4dda>] update_queue+0x28/0x7d
 [<c04b544f>] sys_semtimedop+0x46f/0x635
 [<c043ad9a>] clocksource_get_next+0x39/0x3f
 [<c042e38b>] do_timer+0x4f2/0x6f3
 [<c043dc75>] timer_stats_update_stats+0x142/0x14d
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0420bea>] enqueue_task+0x29/0x39
 [<c0420e47>] __activate_task+0x1c/0x29
 [<c043ad9a>] clocksource_get_next+0x39/0x3f
 [<c043ad9a>] clocksource_get_next+0x39/0x3f
 [<c042e38b>] do_timer+0x4f2/0x6f3
 [<c043ad9a>] clocksource_get_next+0x39/0x3f
 [<c042e38b>] do_timer+0x4f2/0x6f3
 [<c043dc75>] timer_stats_update_stats+0x142/0x14d
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c042d6e7>] getnstimeofday+0x30/0xb6
 [<c042d6e7>] getnstimeofday+0x30/0xb6
 [<c043c220>] clockevents_program_event+0xb2/0xb9
 [<c040592c>] reschedule_interrupt+0x28/0x30
 [<c04e4f08>] rb_insert_color+0x8c/0xad
 [<c043917f>] __remove_hrtimer+0x64/0x6b
 [<c043986c>] hrtimer_try_to_cancel+0x65/0x6d
 [<c042a0ce>] do_setitimer+0xb7/0x2d3
 [<c0451069>] audit_syscall_exit+0x294/0x2b0
 [<c0409298>] sys_ipc+0x5e/0x1bb
 [<c0407d2e>] do_syscall_trace+0xbb/0xc2
 [<c0404f70>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup detected on CPU#3!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c05a8449>] neigh_timer_handler+0x0/0x26f
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c05a8449>] neigh_timer_handler+0x0/0x26f
 [<c042dcee>] run_timer_softirq+0x10a/0x17b
 [<c05a8449>] neigh_timer_handler+0x0/0x26f
 [<c042a588>] it_real_fn+0x12/0x16
 [<c042b2e5>] __do_softirq+0x5d/0xba
 [<c04071b7>] do_softirq+0x59/0xb1
 [<c042b1c7>] ksoftirqd+0x0/0xc1
 [<c042b226>] ksoftirqd+0x5f/0xc1
 [<c0436da8>] kthread+0xb0/0xd8
 [<c0436cf8>] kthread+0x0/0xd8
 [<c0405b3f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup detected on CPU#3!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 =======================
BUG: soft lockup detected on CPU#3!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c042a2e0>] do_setitimer+0x2c9/0x2d3
 [<c042a35e>] sys_setitimer+0x74/0x7f
 [<c0404f70>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c045e707>] wb_timer_fn+0x0/0x27
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c045e707>] wb_timer_fn+0x0/0x27
 [<c042dd5a>] run_timer_softirq+0x176/0x17b
 [<c042b2e5>] __do_softirq+0x5d/0xba
 [<c04071b7>] do_softirq+0x59/0xb1
 [<c042b1c7>] ksoftirqd+0x0/0xc1
 [<c042b226>] ksoftirqd+0x5f/0xc1
 [<c0436da8>] kthread+0xb0/0xd8
 [<c0436cf8>] kthread+0x0/0xd8
 [<c0405b3f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c04b4c94>] try_atomic_semop+0x20/0x10e
 [<c04b4dda>] update_queue+0x28/0x7d
 [<c04b544f>] sys_semtimedop+0x46f/0x635
 [<c043ad9a>] clocksource_get_next+0x39/0x3f
 [<c042e38b>] do_timer+0x4f2/0x6f3
 [<c043dc75>] timer_stats_update_stats+0x142/0x14d
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0420bea>] enqueue_task+0x29/0x39
 [<c0420e47>] __activate_task+0x1c/0x29
 [<c043ad9a>] clocksource_get_next+0x39/0x3f
 [<c043ad9a>] clocksource_get_next+0x39/0x3f
 [<c042e38b>] do_timer+0x4f2/0x6f3
 [<c043dc75>] timer_stats_update_stats+0x142/0x14d
 [<c042e38b>] do_timer+0x4f2/0x6f3
 [<c043dc75>] timer_stats_update_stats+0x142/0x14d
 [<c0420bea>] enqueue_task+0x29/0x39
 [<c0420e47>] __activate_task+0x1c/0x29
 [<c0422295>] try_to_wake_up+0x3aa/0x3b4
 [<c042d6e7>] getnstimeofday+0x30/0xb6
 [<c042d6e7>] getnstimeofday+0x30/0xb6
 [<c043c220>] clockevents_program_event+0xb2/0xb9
 [<c043cfe9>] tick_program_event+0x3a/0x59
 [<c043dc75>] timer_stats_update_stats+0x142/0x14d
 [<c0439e57>] hrtimer_interrupt+0x18d/0x1b6
 [<c042d6e7>] getnstimeofday+0x30/0xb6
 [<c043c220>] clockevents_program_event+0xb2/0xb9
 [<c04e4ec8>] rb_insert_color+0x4c/0xad
 [<c043917f>] __remove_hrtimer+0x64/0x6b
 [<c043986c>] hrtimer_try_to_cancel+0x65/0x6d
 [<c042a0ce>] do_setitimer+0xb7/0x2d3
 [<c0451069>] audit_syscall_exit+0x294/0x2b0
 [<c0409298>] sys_ipc+0x5e/0x1bb
 [<c0407d2e>] do_syscall_trace+0xbb/0xc2
 [<c0404f70>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup detected on CPU#2!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c042de8b>] process_timeout+0x0/0x5
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c042de8b>] process_timeout+0x0/0x5
 [<c042dcee>] run_timer_softirq+0x10a/0x17b
 [<c042de8b>] process_timeout+0x0/0x5
 [<c042b2e5>] __do_softirq+0x5d/0xba
 [<c04071b7>] do_softirq+0x59/0xb1
 [<c042b1c7>] ksoftirqd+0x0/0xc1
 [<c042b226>] ksoftirqd+0x5f/0xc1
 [<c0436da8>] kthread+0xb0/0xd8
 [<c0436cf8>] kthread+0x0/0xd8
 [<c0405b3f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup detected on CPU#3!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04394c4>] ktime_get_ts+0x16/0x44
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 [<c071bb5f>] start_kernel+0x435/0x43d
 [<c071b25a>] unknown_bootoption+0x0/0x202
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 [<c071bb5f>] start_kernel+0x435/0x43d
 [<c071b25a>] unknown_bootoption+0x0/0x202
 =======================
BUG: soft lockup detected on CPU#2!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04394c4>] ktime_get_ts+0x16/0x44
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 =======================
BUG: soft lockup detected on CPU#1!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c060171d>] _spin_unlock_irqrestore+0x8/0x9
 [<f89de6fe>] mdio_ctrl+0xc4/0x12b [e100]
 [<c05bc5bd>] ip_rcv+0x40c/0x445
 [<f89e0c59>] e100_watchdog+0x0/0x325 [e100]
 [<f89de801>] mdio_read+0x1d/0x23 [e100]
 [<f89b9221>] mii_link_ok+0x1d/0x25 [mii]
 [<f89e0ca1>] e100_watchdog+0x48/0x325 [e100]
 [<c042dbd4>] cascade+0x3f/0x4f
 [<c042dcfa>] run_timer_softirq+0x116/0x17b
 [<f89e0c59>] e100_watchdog+0x0/0x325 [e100]
 [<c05a39b8>] net_rx_action+0x94/0x17f
 [<c042b2e5>] __do_softirq+0x5d/0xba
 [<c04071b7>] do_softirq+0x59/0xb1
 [<c042b1c7>] ksoftirqd+0x0/0xc1
 [<c042b226>] ksoftirqd+0x5f/0xc1
 [<c0436da8>] kthread+0xb0/0xd8
 [<c0436cf8>] kthread+0x0/0xd8
 [<c0405b3f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup detected on CPU#1!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 =======================
BUG: soft lockup detected on CPU#2!
 [<c0451f3e>] softlockup_tick+0xa5/0xb4
 [<c042e930>] update_process_times+0x3b/0x5e
 [<c043d2bd>] tick_sched_timer+0x78/0xbb
 [<c0439df5>] hrtimer_interrupt+0x12b/0x1b6
 [<c043d245>] tick_sched_timer+0x0/0xbb
 [<c0419c40>] smp_apic_timer_interrupt+0x6f/0x80
 [<c04059bc>] apic_timer_interrupt+0x28/0x30
 [<c0403d60>] default_idle+0x0/0x3e
 [<c0403d8c>] default_idle+0x2c/0x3e
 [<c04033d6>] cpu_idle+0xa3/0xc4
 =======================


-- 
  Gregory Stark
  EnterpriseDB          http://www.enterprisedb.com
