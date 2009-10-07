Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZJGONY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZJGONY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZJGONY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:13:24 -0400
Received: from mci007.btnet.de ([194.172.160.7]:34179 "EHLO relay.btnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbZJGONX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:13:23 -0400
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: clock_nanosleep: cyclic POSIX thread freezes during time setting
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Date: Wed, 7 Oct 2009 16:13:26 +0200
Message-ID: <40F775BBD072A346957E787B3D0DBE5F1C97BB@w2k3-46ex01.RITTER.LOCAL>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: clock_nanosleep: cyclic POSIX thread freezes during time setting
thread-index: AcpGbHRVVjXKNE5aQ26gPUhEDh0PVAAG01EQ
References: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910052044410.2646@localhost.localdomain> <40F775BBD072A346957E787B3D0DBE5F1C97B4@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910061112400.2646@localhost.localdomain> <40F775BBD072A346957E787B3D0DBE5F1C97B5@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910061201210.2646@localhost.localdomain>
From: "Mehlan, Markus" <Markus.Mehlan@ritter.info>
To: "Thomas Gleixner" <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> I don't remember whether the older -rt kernels had ftrace support for
> powerpc. 
> 
> Can you verify whether later -rt versions (29-rt or 31-rt) have the
> same problem ? 
> 
> Thanks,
> 
> 	tglx
> 
I tried the ftrace (linux-2.6.26.8-rt16).

line 11347 in attached file: trace6.txt
Is this a problem?
          <idle>     0   0 1 00000001 00002c49 [06b367e8] 42514.699ms
(+2053.955ms): rcu_needs_cpu (tick_nohz_stop_sched_tick) 

I created the file with:
# echo verbose > /debug/tracing/iter_ctrl

When the "freeze" happened, I stopped the trace immediately and wrote
the trace to the log file.
# echo 0 > /debug/tracing/tracing_enabled
# cat /debug/tracing/latency_trace > /home/trace6.txt

Regards,
Markus



Hello Thomas,

please disgard the last mails, the trace was to large.
(Message size exceeding 100 000 characters causes blocking.)

Extract of the trace:
# tracer: ftrace
#
ftrace latency trace v1.1.5 on 2.6.26.8-rt16-el392
--------------------------------------------------------------------
 latency: 0 us, #16425/12444805, CPU#0 | (M:preempt VP:0, KP:0, SP:0
HP:0)
    -----------------
    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------

            date   605   0 5 00000000 00000000 [06b2230d] 42431.537ms
(+0.002ms): try_to_wake_up (wake_up_process)
            date   605   0 5 00000000 00000001 [06b2230f] 42431.539ms
(+0.002ms): task_rq_lock (try_to_wake_up)
            date   605   0 5 00000000 00000002 [06b22311] 42431.541ms
(+0.003ms): add_preempt_count (task_rq_lock)

...

          <idle>     0   0 1 00000001 00002c40 [06b367c7] 42514.667ms
(+0.006ms): getnstimeofday (ktime_get_ts)
          <idle>     0   0 1 00000001 00002c41 [06b367cd] 42514.673ms
(+0.005ms): set_normalized_timespec (ktime_get_ts)
          <idle>     0   0 1 00000001 00002c42 [06b367d3] 42514.678ms
(+0.002ms): get_next_timer_interrupt (tick_nohz_stop_sched_tick)
          <idle>     0   0 1 00000001 00002c43 [06b367d5] 42514.680ms
(+0.002ms): rt_spin_trylock (get_next_timer_interrupt)
          <idle>     0   0 1 00000001 00002c44 [06b367d7] 42514.682ms
(+0.007ms): rt_mutex_trylock (rt_spin_trylock)
          <idle>     0   0 1 00000001 00002c45 [06b367dd] 42514.689ms
(+0.003ms): rt_spin_unlock (get_next_timer_interrupt)
          <idle>     0   0 1 00000001 00002c46 [06b367e0] 42514.692ms
(+0.002ms): hrtimer_get_next_event (get_next_timer_interrupt)
          <idle>     0   0 1 00000001 00002c47 [06b367e2] 42514.694ms
(+0.002ms): add_preempt_count (hrtimer_get_next_event)
          <idle>     0   0 1 00000002 00002c48 [06b367e5] 42514.696ms
(+0.003ms): sub_preempt_count (hrtimer_get_next_event)


          <idle>     0   0 1 00000001 00002c49 [06b367e8] 42514.699ms
(+2053.955ms): rcu_needs_cpu (tick_nohz_stop_sched_tick)


          <idle>     0   0 1 00000001 00002c4a [06d2bf2a] 44568.654ms
(+0.002ms): do_IRQ (ret_from_except)
          <idle>     0   0 1 00000001 00002c4b [06d2bf2d] 44568.656ms
(+0.002ms): irq_enter (do_IRQ)
          <idle>     0   0 1 00000001 00002c4c [06d2bf2f] 44568.658ms
(+0.002ms): debug_smp_processor_id (irq_enter)
          <idle>     0   0 1 00000001 00002c4d [06d2bf31] 44568.660ms
(+0.003ms): idle_cpu (irq_enter)
          <idle>     0   0 1 00000001 00002c4e [06d2bf34] 44568.663ms
(+0.002ms): tick_nohz_stop_idle (irq_enter)
          <idle>     0   0 1 00000001 00002c4f [06d2bf36] 44568.666ms
(+0.002ms): ktime_get (tick_nohz_stop_idle)
          <idle>     0   0 1 00000001 00002c50 [06d2bf38] 44568.668ms
(+0.003ms): ktime_get_ts (ktime_get)
          <idle>     0   0 1 00000001 00002c51 [06d2bf3b] 44568.670ms
(+0.002ms): getnstimeofday (ktime_get_ts)
          <idle>     0   0 1 00000001 00002c52 [06d2bf3d] 44568.673ms
(+0.003ms): set_normalized_timespec (ktime_get_ts)
          <idle>     0   0 1 00000001 00002c53 [06d2bf40] 44568.675ms
(+0.002ms): rcu_irq_enter (irq_enter)
          <idle>     0   0 1 00000001 00002c54 [06d2bf42] 44568.677ms
(+0.003ms): debug_smp_processor_id (rcu_irq_enter)
          <idle>     0   0 1 00000001 00002c55 [06d2bf45] 44568.680ms
(+0.002ms): add_preempt_count (irq_enter)
          <idle>     0   0 5 00000001 00002c56 [06d2bf47] 44568.682ms
(+0.002ms): idle_cpu (irq_enter)
          <idle>     0   0 5 00000001 00002c57 [06d2bf48] 44568.684ms
(+0.002ms): tick_nohz_update_jiffies (irq_enter)
          <idle>     0   0 5 00000001 00002c58 [06d2bf4a] 44568.686ms
(+0.003ms): debug_smp_processor_id (tick_nohz_update_jiffies)
          <idle>     0   0 5 00000001 00002c59 [06d2bf4d] 44568.689ms
(+0.003ms): mpc52xx_get_irq (do_IRQ)

Sitz der Gesellschaft: Oberhausen
Handelsregister Amtsgericht Duisburg HRB-Nr. 17168 UST ID-Nr. DE 814009849
Geschaftsfuehrer: Manfred A. Wagner und Dr. Uwe Baader

