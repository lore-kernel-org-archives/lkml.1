Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZHUJ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZHUJ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 05:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZHUJ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 05:56:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZHUJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 05:56:59 -0400
Subject: [PATCH -rt] timer: delay waking softirqs from the jiffy tick
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Aug 2009 11:56:45 +0200
Message-Id: <1250848605.7538.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

most people were complaining about broken balancing with the recent -rt
series.

A look at /proc/sched_debug yielded:

cpu#0, 2393.874 MHz
  .nr_running                    : 0
  .load                          : 0
  .cpu_load[0]                   : 177522
  .cpu_load[1]                   : 177522
  .cpu_load[2]                   : 177522
  .cpu_load[3]                   : 177522
  .cpu_load[4]                   : 177522
cpu#1, 2393.874 MHz
  .nr_running                    : 4
  .load                          : 4096
  .cpu_load[0]                   : 181618
  .cpu_load[1]                   : 180850
  .cpu_load[2]                   : 180274
  .cpu_load[3]                   : 179938
  .cpu_load[4]                   : 179758


Which indicated the cpu_load computation was hosed, the 177522 value
indicates that there is one RT task runnable. Initially I thought the
old problem of calculating the cpu_load from a softirq had re-surfaced,
however looking at the code shows its being done from scheduler_tick().

[ we really should fix this RT/cfs interaction some day... ]

A few trace_printk()s later:

    sirq-timer/1-19    [001]   174.289744:     19: 50:S ==> [001]     0:140:R <idle>                            
          <idle>-0     [001]   174.290724: enqueue_task_rt: adding task: 19/sirq-timer/1 with load: 177522      
          <idle>-0     [001]   174.290725:      0:140:R   + [001]    19: 50:S sirq-timer/1                      
          <idle>-0     [001]   174.290730: scheduler_tick: current load: 177522                                 
          <idle>-0     [001]   174.290732: scheduler_tick: current: 0/swapper                                   
          <idle>-0     [001]   174.290736:      0:140:R ==> [001]    19: 50:R sirq-timer/1                      
    sirq-timer/1-19    [001]   174.290741: dequeue_task_rt: removing task: 19/sirq-timer/1 with load: 177522    
    sirq-timer/1-19    [001]   174.290743:     19: 50:S ==> [001]     0:140:R <idle>  

We see that we always raise the timer softirq before doing the load
calculation. Avoid this by re-ordering the scheduler_tick() call in
update_process_times() to occur before we deal with timers.

This lowers the load back to sanity and restores regular load-balancing
behaviour.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 8137cce..96ac1b4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1221,10 +1221,10 @@ void update_process_times(int user_tick)
 
 	/* Note: this timer irq context must be accounted for as well. */
 	account_process_tick(p, user_tick);
+	scheduler_tick();
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
-	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
 

