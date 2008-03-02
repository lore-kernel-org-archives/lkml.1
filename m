Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYCBTsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYCBTsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCBTsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:48:22 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:32910 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751951AbYCBTsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:48:21 -0500
Date: Mon, 3 Mar 2008 01:18:13 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Too many timer interrupts in NO_HZ
Message-ID: <20080302194812.GD10028@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: discuss@LessWatts.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	venkatesh.pallipadi@intel.com, tglx@linutronix.de,
	Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
	Gautham R Shenoy <ego@in.ibm.com>,
	Chanda Sethia <chanda.sethia@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to play around with the tickless kernel and
sched_mc_power_savings tunables to increase the idle duration of the
CPU in an SMP server.  sched_mc_power_savings provides good
consolidation of long running jobs when the system is lightly loaded.
However I am interested to see CPU idle times for couple minutes on
atleast few CPUs in an completely idle SMP system.

I have posted related instrumentation results at
http://lkml.org/lkml/2008/1/8/243

The experimental setup is identical.  Just that I have tried to
collect more data and also bias the wakeup logic.

The kernel is 2.6.25-rc3 with NO_HZ, SCHED_MC, HIGH_RES_TIMERS, and
HPET turned on.

I have tried to collect interesting data from tick-sched.c, sched.c
and softirq.c.

As suggested by Ingo in the previous thread, I have hacked the sched.c
try_to_wake_up logic so that I can force all wake-ups to happen on
CPU0.  This is just and experiment, in reality we will have to
carefully choose a domain and CPU to bias all wakeups on an idle
system.

--- linux-2.6.25-rc3.orig/kernel/sched_fair.c
+++ linux-2.6.25-rc3/kernel/sched_fair.c
@@ -991,6 +991,10 @@ static int select_task_rq_fair(struct ta
        this_cpu = smp_processor_id();
        new_cpu  = cpu;

+       /* Force move all tasks to CPU 0 */
+       if (unlikely(cpu_isset(0, p->cpus_allowed)))
+               return 0;
+
        if (cpu == this_cpu)
                goto out_set_cpu;

Experiment:
-----------

Hardware:
* Two socket dual core intel xeon (4 Logical CPU)

Setup:

* Killed most daemons include irqbalance
* Routed all interrupts to CPU0
* sched_mc_power_savings = 1  
* powertop gives an average ~3 wakeups/sec
* Trace data collected for 120 secs on this completely idle machine
* Log /proc/interrupts before and after the observation period
      
Results:

Interrupt count for 120 seconds:
	   
           CPU0       CPU1       CPU2       CPU3       
 17:         55          0          0          0   IO-APIC-fasteoi-aacraid
214:        277          0          0          0   PCI-MSI-edge-eth0
LOC:        676        306        324        296   Local timer interrupts
CAL:          0         12         12         12   function call interrupts
TLB:          5          3          0          0   TLB shootdowns


		CPU0	CPU1	CPU2	CPU3
Maximum Idle 
Time (ms): 	1000	5250	5320	5250

Some of the process that was woken-up on CPUs 1,2 & 3 because of
affinity and that could not be moved to CPU0:

Wakeup    PID     PROCESS
Count     
60     :    7   [ksoftirqd/1]
58     :   10   [ksoftirqd/2]
58     :   13   [ksoftirqd/3]
 8     :   17   [events/2]
 8     : 1098   [kondemand/2]

The problem:

There are way too many timer interrupts even though the CPUs have
entered tickless idle loop.  Timer interrupts basically bring the CPU
out of idle, and then return to tickless idle.  There are very few
try_to_wake_up()s or need_resched() in between the timer interrupts.

What can happen in an idle system in the timer interrupt context that
does not invoke a need_resched() or try_to_wake_up()?

Trace pattern:

CPU2 Trace sequence:

ns								ns
2135960054680	tick_nohz_stop_sched_tick(), expires = 7290612000000 
*** tick_stopped = 1 ***
2136363725957	tick_nohz_stop_sched_tick(), expires = 7290612000000
*** Timer Interrupt ***
2136767397163	tick_nohz_stop_sched_tick(), expires = 7290612000000
*** Timer Interrupt ***
2137171068369	tick_nohz_stop_sched_tick(), expires = 7290612000000
*** Timer Interrupt ***
2137574739785	tick_nohz_stop_sched_tick(), expires = 7290612000000
.........
.........
*** Timer Interrupt ***
2140804114397	tick_nohz_stop_sched_tick(), expires = 2140808000000
*** try_to_wake_up() ***
2140804121591	tick_nohz_restart_sched_tick()
*** tick_stopped = 0 ***

There is a similar pattern on CPU1 and CPU3, while CPU0 has
significantly more wake-ups and timer interrupts.  

Basically there are more than 10 timer interrupts at 4ms interval even
though the next expected timer is very much into the future.  My HZ is
250, so I assume the tick could not be stopped for some reason.

There are instances in the trace were the tick was stopped
successfully and we get a much larger interval between successive
timer interrupts and tick_nohz_stop_sched_tick() calls.

Please help me to understand the following scenario:

* What can happen in timer interrupt context that need not wakeup any
  process?
* What can prevent tick_nohz_stop_sched_tick() from actually stopping
  the tick?  
* Whats wrong in expecting to see some of the CPUs having tickless
  idle time of few minutes

Thank you for review my experiment.  Comments and suggestions are
welcome.  I will send instrumentation patch and trace data on request.

--Vaidy

