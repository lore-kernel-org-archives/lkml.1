Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZIEPHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZIEPHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 11:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZIEPHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 11:07:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbZIEPHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 11:07:17 -0400
Date: Sat, 5 Sep 2009 12:06:58 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>, linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/18] tracing/ring-buffer: fixes for latency tracer
	[2.6.32]
Message-ID: <20090905150658.GA13387@ghostprotocols.net>
References: <20090904235527.520961911@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904235527.520961911@goodmis.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 04, 2009 at 07:55:27PM -0400, Steven Rostedt escreveu:
> Thomas,
> 
> I can port these over to -rt if you want, or you could just
> add them yourself. I know the spinlocks need to be converted to atomic.
> Just let me know if you want me to do it.

I did a quick port to tip/rt/head and couldn't reproduce the problems I
was experiencing, thanks!

I've put the ported patch series at:

http://userweb.kernel.org/~acme/rostedt-rb-rt

Tested using:

echo 1 > /sys/kernel/debug/tracing/events/irq/enable
echo 1 > /sys/kernel/debug/tracing/events/sched/enable
echo wakeup > /sys/kernel/debug/tracing/current_tracer

Then a make -j64 allyesconfig + cyclictest -p95 ...
[root@hs21xm-1 ~]# uname -a
Linux hs21xm-1 2.6.31-rc8-rt9 #2 SMP PREEMPT RT Sat Sep 5 09:42:03 CDT
2009 x86_64 x86_64 x86_64 GNU/Linux
[root@hs21xm-1 ~]# cat /sys/kernel/debug/tracing/trace
# tracer: wakeup
#
# wakeup latency trace v1.1.5 on 2.6.31-rc8-rt9
# --------------------------------------------------------------------
# latency: 220 us, #43/43, CPU#4 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:8)
#    -----------------
#    | task: -2924 (uid:0 nice:-5 policy:1 rt_prio:85)
#    -----------------
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /                      
#                |||||     delay             
#  cmd     pid   ||||| time  |   caller      
#     \   /      |||||   \   |   /           
sirq-rcu-52      3d..3    0us : sched_switch: task sirq-rcu/3:52 [29] (D) ==> cc1:13267 [120]
  <idle>-0       5d.h3    0us :      0:140:R   + [004]  2924: 14:R irq/60-eth2
  <idle>-0       5d.h3    1us+: wake_up_process <-handle_IRQ_event
irq/60-e-2924    4d..2    4us+: sched_wakeup: task sirq-net-rx/4:60 [24] success=1
   <...>-13267   3d..3    8us : sched_switch: task cc1:13267 [120] (T|0x100) ==> cc1:13085 [120]
irq/60-e-2924    4d.h2    8us+: sched_wakeup: task sirq-timer/4:58 [29] success=1
irq/60-e-2924    4d.h2   10us+: sched_wakeup: task sirq-rcu/4:65 [29] success=1
irq/60-e-2924    4d..3   15us+: sched_switch: task irq/60-eth2:2924 [14] (D) ==> sirq-net-rx/4:60 [24]
   <...>-12172   0d..4   26us+: sched_wakeup: task cc1:13566 [120] success=0
   <...>-13566   7d..4   36us+: sched_wakeup: task cc1:12172 [120] success=0
   <...>-60      4d..2   39us+: sched_wakeup: task cc1:12985 [120] success=1
   <...>-13300   2d..4   44us+: sched_wakeup: task cc1:12172 [120] success=0
   <...>-13566   7d..3   46us+: sched_switch: task cc1:13566 [120] (R) ==> cc1:12985 [120]
   <...>-60      4d..2   55us+: sched_wakeup: task cc1:13149 [120] success=1
   <...>-60      4d..4   59us+: sched_wakeup: task cc1:12985 [120] success=0
   <...>-12985   7d..2   65us : sched_migrate_task: task cc1:13274 [120] from: 4  to: 7
  <idle>-0       5d.h3   67us+: sched_wakeup: task sirq-timer/5:71 [29] success=1
   <...>-12985   7d..2   68us+: sched_wakeup: task cc1:13274 [120] success=1
  <idle>-0       5d..3   70us+: sched_switch: task swapper:0 [140] (R) ==> sirq-timer/5:71 [29]
sirq-tim-71      5d..3   74us+: sched_switch: task sirq-timer/5:71 [29] (D) ==> swapper:0 [140]
   <...>-60      4d..2   82us+: sched_wakeup: task cc1:12683 [120] success=1
   <...>-60      4d..3   89us+: sched_switch: task sirq-net-rx/4:60 [24] (D) ==> sirq-timer/4:58 [29]
sirq-tim-58      4d..3   93us+: sched_switch: task sirq-timer/4:58 [29] (D) ==> sirq-rcu/4:65 [29]
sirq-rcu-65      4d..3   97us+: sched_switch: task sirq-rcu/4:65 [29] (D) ==> cc1:13355 [120]
   <...>-13210   6d..3  103us+: sched_switch: task cc1:13210 [120] (T|0x100) ==> fixdep:13407 [120]
   <...>-13407   6d..2  127us+: sched_wakeup: task cc1:13127 [120] success=1
   <...>-13407   6d.h3  134us+: sched_wakeup: task sirq-timer/6:84 [29] success=1
   <...>-13407   6dNh3  137us+: sched_wakeup: task sirq-rcu/6:91 [29] success=1
   <...>-13407   6d..3  141us+: sched_switch: task fixdep:13407 [120] (R) ==> sirq-timer/6:84 [29]
   <...>-13300   2d..4  145us : sched_wakeup: task cc1:12172 [120] success=0
sirq-tim-84      6d..3  146us+: sched_switch: task sirq-timer/6:84 [29] (D) ==> sirq-rcu/6:91 [29]
sirq-rcu-91      6d..3  153us+: sched_switch: task sirq-rcu/6:91 [29] (D) ==> genksyms:13194 [120]
   <...>-12985   7d.h2  194us+: sched_wakeup: task sirq-timer/7:97 [29] success=1
   <...>-13358   1d..3  199us : sched_switch: task genksyms:13358 [120] (D) ==> as:12659 [120]
   <...>-12985   7dNh2  199us+: sched_wakeup: task sirq-rcu/7:104 [29] success=1
   <...>-12985   7d..3  204us+: sched_switch: task cc1:12985 [120] (R) ==> sirq-timer/7:97 [29]
sirq-tim-97      7d.h1  207us : irq_handler_entry: irq=60 handler=eth2
sirq-tim-97      7d.h1  208us+: irq_handler_exit: irq=60 return=handled
sirq-tim-97      7d.h2  211us+: sched_wakeup: task irq/60-eth2:2924 [14] success=1
sirq-tim-97      7d..3  216us+: sched_switch: task sirq-timer/7:97 [29] (D) ==> sirq-rcu/7:104 [29]
   <...>-13355   4d..3  219us : sched_switch: task cc1:13355 [120] (R) ==> irq/60-eth2:2924 [14]
   <...>-13355   4d..3  219us : __schedule <-schedule
   <...>-13355   4d..3  220us :  13355:120:R ==> [004]  2924: 14:R irq/60-eth2

- Arnaldo
