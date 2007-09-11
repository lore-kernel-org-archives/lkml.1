Return-Path: <linux-kernel-owner+w=401wt.eu-S967063AbXIKG1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967063AbXIKG1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966378AbXIKGSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:18:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:52531 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966440AbXIKGSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:18:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+XwzpVx0mX33MFhXaHeyQRC8bzDipngfkBtLVUZ9
	p4T+aHJJ+Z9OCC
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org
In-Reply-To: <Pine.LNX.4.64.0709102338170.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
	 <1188694367.11196.42.camel@dhcp193.mvista.com>
	 <20070902072029.GA24427@elte.hu>
	 <Pine.LNX.4.64.0709071634450.1817@scrub.home>
	 <1189238208.6575.54.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709102338170.1817@scrub.home>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 08:18:45 +0200
Message-Id: <1189491525.6536.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 01:23 +0200, Roman Zippel wrote:
> Hi,
> 
> On Sat, 8 Sep 2007, Mike Galbraith wrote:
> 
> > > On Sun, 2 Sep 2007, Ingo Molnar wrote:
> > > 
> > > Below is a patch updated against the latest git tree, no major changes.
> > 
> > Interesting, I see major behavioral changes.
> > 
> > I still see an aberration with fairtest2.  On startup, the hog component
> > will consume 100% cpu for a bit, then the sleeper shows up.  This
> > doesn't always happen, but happens quite often.
> 
> I found the problem for this. What basically happened is that a task that 
> hasn't been running for a second is enqueued first on an idle queue and it 
> keeps that advantage compared to tasks that had been running more recently 
> until it catched up. The new version will now remember where the last task 
> left off and use that for that first task which restarts the queue. As a 
> side effect it also limits the bonus a task gets if multiple tasks are 
> woken at the same time.

I still see the fairtest2 sleeper startup anomaly.  Sometimes it starts
up normally, others the sleeper is a delayed.  Seems to require idle
time to trigger worst case startup delay.

14854 root      20   0  1568  468  384 R   52  0.0   0:07.50 1 fairtest2
14855 root      20   0  1568  112   28 R   45  0.0   0:00.46 1 fairtest2

Everything else still seems fine.  Boot-time warnings:

[  113.504259] audit(1189488395.753:2): audit_pid=5403 old=0 by auid=4294967295
[  114.077979] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[  116.281216] 4,f70355a0(5633,b,d1cef00): 32af5bc18d4,31b49210000,f70355a0(5633,b,d1cef00),2
[  116.298004] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  116.312380]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  116.326193]  [<c0105d83>] show_trace+0x12/0x14
[  116.339270]  [<c0105d9b>] dump_stack+0x16/0x18
[  116.352199]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  116.365406]  [<c011e8a3>] enqueue_entity+0x186/0x21b
[  116.378571]  [<c0123344>] enqueue_task_fair+0x2f/0x31
[  116.391545]  [<c011d043>] enqueue_task+0xd/0x18
[  116.403833]  [<c011dffe>] activate_task+0x20/0x2d
[  116.416174]  [<c0120336>] __migrate_task+0x9a/0xc4
[  116.428490]  [<c0122d0b>] migration_thread+0x175/0x220
[  116.441159]  [<c01393f7>] kthread+0x37/0x59
[  116.452824]  [<c0104dd3>] kernel_thread_helper+0x7/0x14
[  116.465582]  =======================
[  116.476497] 4,f70355a0(5633,b,d1cef00): 32af5bc18d4,31b496c0000,f7e1a5a0(4179,3b0,232aaf800),4
[  116.492899] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  116.506459]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  116.519302]  [<c0105d83>] show_trace+0x12/0x14
[  116.531313]  [<c0105d9b>] dump_stack+0x16/0x18
[  116.543334]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  116.555710]  [<c011ea1e>] update_curr+0xe6/0x102
[  116.567654]  [<c011ebb9>] task_tick_fair+0x3f/0x1f2
[  116.579657]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  116.591808]  [<c012fa9d>] update_process_times+0x44/0x63
[  116.604400]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  116.616741]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  116.629230]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  116.642047]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  116.654692]  [<c011f119>] __wake_up+0x3a/0x42
[  116.666158]  [<c03f02d3>] sock_def_readable+0x6e/0x70
[  116.678143]  [<c046195c>] unix_stream_sendmsg+0x19d/0x32c
[  116.690520]  [<c03ebf11>] sock_aio_write+0x104/0x123
[  116.702479]  [<c0178c60>] do_sync_readv_writev+0xb4/0xea
[  116.714907]  [<c0179318>] do_readv_writev+0xbb/0x1d4
[  116.727074]  [<c0179470>] vfs_writev+0x3f/0x51
[  116.738800]  [<c01798b4>] sys_writev+0x3d/0x64
[  116.750154]  [<c0104182>] sysenter_past_esp+0x5f/0x85
[  116.761932]  =======================
[  116.772092] 4,f70355a0(5633,b,d1cef00): 32af5bc18d4,31b496c0000,f793bae0(4010,3b0,232aaf800),3
[  116.787811] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  116.800930]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  116.813437]  [<c0105d83>] show_trace+0x12/0x14
[  116.825164]  [<c0105d9b>] dump_stack+0x16/0x18
[  116.836828]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  116.848910]  [<c0123391>] dequeue_task_fair+0x4b/0x2d3
[  116.861390]  [<c011d05b>] dequeue_task+0xd/0x18
[  116.873193]  [<c011dfa1>] deactivate_task+0x20/0x3a
[  116.885335]  [<c011e0aa>] balance_tasks+0x9f/0x140
[  116.897357]  [<c011e1ab>] load_balance_fair+0x60/0x7d
[  116.909627]  [<c011d141>] move_tasks+0x5b/0x77
[  116.921200]  [<c0120c0b>] load_balance+0xd3/0x2ab
[  116.932786]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  116.944998]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  116.956238]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  116.967316]  =======================
[  116.977554] 3,f70355a0(5633,b,d1cef00): 32af5bc18d4,31b2ded0000,f793bae0(4010,3b0,232aaf800),1
[  116.993315] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  117.006408]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  117.018914]  [<c0105d83>] show_trace+0x12/0x14
[  117.030667]  [<c0105d9b>] dump_stack+0x16/0x18
[  117.042332]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  117.054335]  [<c01234ec>] dequeue_task_fair+0x1a6/0x2d3
[  117.066781]  [<c011d05b>] dequeue_task+0xd/0x18
[  117.078429]  [<c011dfa1>] deactivate_task+0x20/0x3a
[  117.090380]  [<c011e0aa>] balance_tasks+0x9f/0x140
[  117.102203]  [<c011e1ab>] load_balance_fair+0x60/0x7d
[  117.114283]  [<c011d141>] move_tasks+0x5b/0x77
[  117.125689]  [<c0120c0b>] load_balance+0xd3/0x2ab
[  117.137320]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  117.149773]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  117.161343]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  117.172724]  =======================
[  117.183276] 3,f70355a0(5633,b,d1cef00): 32af5bc18d4,31b2ded0000,f7035ae0(5612,3b0,232aaf800),3
[  117.199354] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  117.212692]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  117.225188]  [<c0105d83>] show_trace+0x12/0x14
[  117.236680]  [<c0105d9b>] dump_stack+0x16/0x18
[  117.247991]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  117.259717]  [<c0123391>] dequeue_task_fair+0x4b/0x2d3
[  117.271903]  [<c011d05b>] dequeue_task+0xd/0x18
[  117.283414]  [<c011dfa1>] deactivate_task+0x20/0x3a
[  117.295253]  [<c011e0aa>] balance_tasks+0x9f/0x140
[  117.307030]  [<c011e1ab>] load_balance_fair+0x60/0x7d
[  117.319101]  [<c011d141>] move_tasks+0x5b/0x77
[  117.330543]  [<c0120c0b>] load_balance+0xd3/0x2ab
[  117.342243]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  117.354801]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  117.366493]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  117.377949]  =======================
[  117.388461] 8,f70355a0(5633,b,d1cef00): 32af5bc18d4,31c54050000,f70355a0(5633,b,d1cef00),2
[  117.404131] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  117.417451]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  117.429922]  [<c0105d83>] show_trace+0x12/0x14
[  117.441387]  [<c0105d9b>] dump_stack+0x16/0x18
[  117.452681]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  117.464372]  [<c011e8a3>] enqueue_entity+0x186/0x21b
[  117.476324]  [<c0123344>] enqueue_task_fair+0x2f/0x31
[  117.488346]  [<c011d043>] enqueue_task+0xd/0x18
[  117.499760]  [<c011dffe>] activate_task+0x20/0x2d
[  117.511365]  [<c011e0bf>] balance_tasks+0xb4/0x140
[  117.523046]  [<c011e1ab>] load_balance_fair+0x60/0x7d
[  117.535015]  [<c011d141>] move_tasks+0x5b/0x77
[  117.546335]  [<c0120c0b>] load_balance+0xd3/0x2ab
[  117.557923]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  117.570385]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  117.581929]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  117.593248]  =======================
[  117.603676] 8,f70355a0(5633,b,d1cef00): 32af5bc18d4,31c54050000,dfcd4060(939,135,b82da880),4
[  117.619422] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  117.632410]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  117.644554]  [<c0105d83>] show_trace+0x12/0x14
[  117.655838]  [<c0105d9b>] dump_stack+0x16/0x18
[  117.667078]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  117.678770]  [<c011ea1e>] update_curr+0xe6/0x102
[  117.690245]  [<c011ebb9>] task_tick_fair+0x3f/0x1f2
[  117.701972]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  117.713818]  [<c012fa9d>] update_process_times+0x44/0x63
[  117.726056]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  117.737964]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  117.750175]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  117.762890]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  117.775290]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  117.787875]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  117.799549]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  117.811040]  =======================
[  117.821594] 8,f70355a0(5633,b,d1cef00): 32af5bc18d4,32397330000,dfc46060(3936,3b0,232aaf800),3
[  117.837448] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  117.850404]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  117.862659]  [<c0105d83>] show_trace+0x12/0x14
[  117.874184]  [<c0105d9b>] dump_stack+0x16/0x18
[  117.885711]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  117.897601]  [<c0123391>] dequeue_task_fair+0x4b/0x2d3
[  117.909865]  [<c011d05b>] dequeue_task+0xd/0x18
[  117.921487]  [<c011dfa1>] deactivate_task+0x20/0x3a
[  117.933509]  [<c011e0aa>] balance_tasks+0x9f/0x140
[  117.945443]  [<c011e1ab>] load_balance_fair+0x60/0x7d
[  117.957671]  [<c011d141>] move_tasks+0x5b/0x77
[  117.969259]  [<c0120c0b>] load_balance+0xd3/0x2ab
[  117.981115]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  117.993846]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  118.005658]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  118.017255]  =======================
[  118.027946] 7,f70355a0(5633,b,d1cef00): 32af5bc18d4,3238da60000,dfc46060(3936,3b0,232aaf800),1
[  118.044138] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  118.057413]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  118.069850]  [<c0105d83>] show_trace+0x12/0x14
[  118.081438]  [<c0105d9b>] dump_stack+0x16/0x18
[  118.092983]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  118.104976]  [<c01234ec>] dequeue_task_fair+0x1a6/0x2d3
[  118.117448]  [<c011d05b>] dequeue_task+0xd/0x18
[  118.129182]  [<c011dfa1>] deactivate_task+0x20/0x3a
[  118.141272]  [<c011e0aa>] balance_tasks+0x9f/0x140
[  118.153258]  [<c011e1ab>] load_balance_fair+0x60/0x7d
[  118.165505]  [<c011d141>] move_tasks+0x5b/0x77
[  118.177084]  [<c0120c0b>] load_balance+0xd3/0x2ab
[  118.188888]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  118.201507]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  118.213207]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  118.224673]  =======================
[  118.235200] 7,f70355a0(5633,b,d1cef00): 32af5bc18d4,3238da60000,f791f060(5607,3b0,232aaf800),3
[  118.251260] WARNING: at kernel/sched_norm.c:271 verify_queue()
[  118.264614]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  118.277128]  [<c0105d83>] show_trace+0x12/0x14
[  118.288631]  [<c0105d9b>] dump_stack+0x16/0x18
[  118.299967]  [<c011e61a>] verify_queue+0x2f8/0x3fb
[  118.311709]  [<c0123391>] dequeue_task_fair+0x4b/0x2d3
[  118.323920]  [<c011d05b>] dequeue_task+0xd/0x18
[  118.335457]  [<c011dfa1>] deactivate_task+0x20/0x3a
[  118.347331]  [<c011e0aa>] balance_tasks+0x9f/0x140
[  118.359125]  [<c011e1ab>] load_balance_fair+0x60/0x7d
[  118.371206]  [<c011d141>] move_tasks+0x5b/0x77
[  118.382656]  [<c0120c0b>] load_balance+0xd3/0x2ab
[  118.394366]  [<c0123fca>] run_rebalance_domains+0x89/0x319
[  118.406932]  [<c012bbc2>] __do_softirq+0x73/0xe0
[  118.418632]  [<c0106bc3>] do_softirq+0x6e/0xc1
[  118.430088]  =======================
[  118.661317] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  118.841985] 3,f7913ae0(5648,b,d1cef00): 30aea0eef39,2dc5dc40000,f7913ae0(5648,b,d1cef00),5
[  118.876767] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  118.908572]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  118.939760]  [<c0105d83>] show_trace+0x12/0x14
[  118.970122]  [<c0105d9b>] dump_stack+0x16/0x18
[  119.000496]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  119.031508]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  119.062350]  [<c012fa9d>] update_process_times+0x44/0x63
[  119.093732]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  119.124944]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  119.156611]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  119.188954]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  119.221063]  [<c0165c22>] __do_fault+0x3d/0x363
[  119.252382]  [<c0167288>] handle_mm_fault+0x11b/0x6a8
[  119.284202]  [<c011c158>] do_page_fault+0x3ed/0x615
[  119.315726]  [<c04d2bba>] error_code+0x72/0x78
[  119.346869]  =======================
[  119.408744] 3,f7dceae0(5657,b,d1cef00): 333cd7dba80,3291a150000,f7dceae0(5657,b,d1cef00),5
[  119.424943] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  119.438312]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  119.451068]  [<c0105d83>] show_trace+0x12/0x14
[  119.463097]  [<c0105d9b>] dump_stack+0x16/0x18
[  119.475119]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  119.487694]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  119.500217]  [<c012fa9d>] update_process_times+0x44/0x63
[  119.513155]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  119.525773]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  119.538696]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  119.552119]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  119.565221]  =======================
[  119.650421] NFSD: starting 90-second grace period
[  120.632062] 2,f7335060(5712,b,d1cef00): 35ac9c90eea,ffffe84b40460000,f7335060(5712,b,d1cef00),5
[  120.652839] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  120.670841]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  120.688353]  [<c0105d83>] show_trace+0x12/0x14
[  120.705102]  [<c0105d9b>] dump_stack+0x16/0x18
[  120.721703]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  120.738851]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  120.755914]  [<c012fa9d>] update_process_times+0x44/0x63
[  120.773311]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  120.790296]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  120.807555]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  120.825351]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  120.842811]  =======================
[  120.858451] 2,f7335060(5712,b,d1cef00): 35aca70e122,ffffe84b40e90000,f7335060(5712,b,d1cef00),5
[  120.879922] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  120.898237]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  120.915750]  [<c0105d83>] show_trace+0x12/0x14
[  120.932336]  [<c0105d9b>] dump_stack+0x16/0x18
[  120.948858]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  120.966070]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  120.983249]  [<c012fa9d>] update_process_times+0x44/0x63
[  121.000839]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  121.018090]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  121.035610]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  121.053627]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  121.071256]  =======================
[  121.087023] 2,f7335060(5712,b,d1cef00): 35acb18b35a,ffffe84b418c0000,f7335060(5712,b,d1cef00),5
[  121.108549] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  121.127230]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  121.145279]  [<c0105d83>] show_trace+0x12/0x14
[  121.162114]  [<c0105d9b>] dump_stack+0x16/0x18
[  121.178420]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  121.195216]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  121.211843]  [<c012fa9d>] update_process_times+0x44/0x63
[  121.228703]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  121.245445]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  121.262515]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  121.279696]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  121.296219]  =======================
[  121.310817] 2,f7335060(5712,b,d1cef00): 35acbc08592,ffffe84b422e0000,f7335060(5712,b,d1cef00),5
[  121.331338] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  121.349145]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  121.366481]  [<c0105d83>] show_trace+0x12/0x14
[  121.383035]  [<c0105d9b>] dump_stack+0x16/0x18
[  121.399470]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  121.416436]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  121.433297]  [<c012fa9d>] update_process_times+0x44/0x63
[  121.450497]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  121.467300]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  121.484335]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  121.501525]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  121.518032]  =======================
[  121.532610] 2,f7335060(5712,b,d1cef00): 35acc6857ca,ffffe84b42d10000,f7335060(5712,b,d1cef00),5
[  121.553097] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  121.570885]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  121.588190]  [<c0105d83>] show_trace+0x12/0x14
[  121.604731]  [<c0105d9b>] dump_stack+0x16/0x18
[  121.621151]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  121.638084]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  121.654955]  [<c012fa9d>] update_process_times+0x44/0x63
[  121.672143]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  121.688956]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  121.705988]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  121.723180]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  121.739686]  =======================
[  121.754270] 3,f7335060(5712,b,d1cef00): 35acd102a0d,ffffe85123590000,f7335060(5712,b,d1cef00),5
[  121.774772] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  121.792570]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  121.809871]  [<c0105d83>] show_trace+0x12/0x14
[  121.826405]  [<c0105d9b>] dump_stack+0x16/0x18
[  121.842791]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  121.859719]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  121.876564]  [<c012fa9d>] update_process_times+0x44/0x63
[  121.893738]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  121.910522]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  121.927532]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  121.944700]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  121.961179]  =======================
[  121.975739] 2,f7335060(5712,b,d1cef00): 35acdb7fc45,ffffe85306070000,f7335060(5712,b,d1cef00),5
[  121.996410] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  122.014189]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  122.031484]  [<c0105d83>] show_trace+0x12/0x14
[  122.047999]  [<c0105d9b>] dump_stack+0x16/0x18
[  122.064367]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  122.081282]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  122.098123]  [<c012fa9d>] update_process_times+0x44/0x63
[  122.115307]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  122.132098]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  122.149090]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  122.166256]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  122.182763]  =======================
[  122.197362] 2,f7335060(5712,b,d1cef00): 35ace5fce7d,ffffe85306aa0000,f7335060(5712,b,d1cef00),5
[  122.217856] WARNING: at kernel/sched_norm.c:438 entity_tick()
[  122.235637]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  122.252929]  [<c0105d83>] show_trace+0x12/0x14
[  122.269437]  [<c0105d9b>] dump_stack+0x16/0x18
[  122.285823]  [<c011ed0e>] task_tick_fair+0x194/0x1f2
[  122.302718]  [<c01223f3>] scheduler_tick+0x18d/0x2d5
[  122.319572]  [<c012fa9d>] update_process_times+0x44/0x63
[  122.336736]  [<c014179e>] tick_sched_timer+0x5c/0xbd
[  122.353530]  [<c013cbe1>] hrtimer_interrupt+0x12c/0x1a0
[  122.370532]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  122.387687]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  122.404192]  =======================
[  128.411998] [drm] Initialized drm 1.1.0 20060810



