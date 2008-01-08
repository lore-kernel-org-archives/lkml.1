Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYAHRi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYAHRi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYAHRiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:38:46 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52825 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbYAHRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:38:45 -0500
Date: Tue, 8 Jan 2008 23:08:15 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Analysis of sched_mc_power_savings
Message-ID: <20080108173815.GA7793@dirshya.in.ibm.com>
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
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following experiments were conducted on a two socket dual core
intel processor based machine in order to understand the impact of
sched_mc_power_savings scheduler heuristics.

Kernel linux-2.6.24-rc6:

CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y

tick-sched.c has been instrumented to collect idle entry and exit time
stamps.

Instrumentation patch:

Instrument tick-sched nohz code and generate time stamp trace data.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc6.orig/kernel/time/tick-sched.c
+++ linux-2.6.24-rc6/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/tick.h>
+#include <linux/ktrace.h>
 
 #include <asm/irq_regs.h>
 
@@ -200,7 +201,10 @@ void tick_nohz_stop_sched_tick(void)
 	if (ts->tick_stopped) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-	}
+		ktrace_log2(KT_FUNC_tick_nohz_stop_sched_tick, KT_EVENT_INFO1,
+					ktime_to_ns(now), ts->idle_calls);
>>>>>>>>>>>>>>>>Tracepoint A

+	} else
+		ktrace_log2(KT_FUNC_tick_nohz_stop_sched_tick,
				KT_EVENT_FUNC_ENTER, ktime_to_ns(now), 0);
 
>>>>>>>>>>>>>>>>Tracepoint B

 	ts->idle_entrytime = now;
 	ts->idle_calls++;
@@ -391,6 +395,8 @@ void tick_nohz_restart_sched_tick(void)
 		tick_do_update_jiffies64(now);
 		now = ktime_get();
 	}
+	ktrace_log2(KT_FUNC_tick_nohz_restart_sched_tick, KT_EVENT_FUNC_EXIT,
+				ktime_to_ns(now), ts->idle_calls);
>>>>>>>>>>>>>>>>Tracepoint C
 	local_irq_enable();
 }

The idle time collected are time stamp at (C) minus (B). This is the
time interval between stopping ticks and restarting ticks in an idle
system.

Complete patch series:
http://svaidy.googlepages.com/1-klog.patch
http://svaidy.googlepages.com/1-trace-sched.patch

Userspace program to extract trace data:
http://svaidy.googlepages.com/1-klog.c

Python script to post process binary trace data:
http://svaidy.googlepages.com/1-sched-stats.py

Gnuplot scripts that was used to generate the graphs:
http://svaidy.googlepages.com/1-multiplot.gp

The scheduler heuristics for multi core system
/sys/devices/system/cpu/sched_mc_power_savings should ideally extend
the cpu tickless idle time atleast on few CPU in an SMP machine.

However in the experiment it was found that turning on
sched_mc_power_savings marginally increased the idle time in only some
of the CPUs.

Experiment 1:
-------------

Setup:

* yum-updated and irqbalance daemon was stopped to reduce the idle
  wakeup rate
* All irqs manually routed to CPU0 only (hoping this will keep other
  CPUs idle) (http://svaidy.googlepages.com/1-irq-config.txt)
* Powertop shows around 35 wakeups per second during idle
  (http://svaidy.googlepages.com/1-powertop-screen.txt)
* The trace of idle time stamps was collected for 120 seconds with the
  system in idle state

Results:

There are 4 png files that plots the idle time for each CPU in the
system.  

Please get the graphs from the following URLs

http://svaidy.googlepages.com/1-idle-cpu0.png
http://svaidy.googlepages.com/1-idle-cpu1.png
http://svaidy.googlepages.com/1-idle-cpu2.png
http://svaidy.googlepages.com/1-idle-cpu3.png

Each png file has 4 graphs plotted that is relevant to one CPU

* Right-top plot is the idle time sample obtained during the
  experiment
* Left-top graph is histogram of right top plot
* The bottom graphs corresponding to idle times when
  sched_mc_power_savings=1

Observations with sched_mc_power_savings=1:

* No major impact of sched_mc_power_savings on CPU0 and CPU1
* Significant idle time improvement on CPU2
* However, significant idle time reduction on CPU3

Experiment 2:
-------------

Setup:

* USB stopped
* Most daemons like yum-updatesd, hal, autofs, syslog, crond, irqbalance,
  sendmail, pcscd were stopped  
* Interrupt routing left to default but irqbalance daemon stopped  
* Powertop shows around 4 wakeups per second during idle
  (http://svaidy.googlepages.com/2-powertop-screen.txt) 
* The trace of idle time stamps was collected for 120 seconds with the
  system in idle state

Results:

There are 4 png files that plots the idle time for each CPU in the
system.  

http://svaidy.googlepages.com/2-idle-cpu0.png
http://svaidy.googlepages.com/2-idle-cpu1.png
http://svaidy.googlepages.com/2-idle-cpu2.png
http://svaidy.googlepages.com/2-idle-cpu3.png

The details of the plot are same as the previous experiment.

Observations with sched_mc_power_savings=1:

* No major impact of sched_mc_power_savings on CPU0 and CPU1
* Good idle time improvement on CPU2 and CPU3

Please review the experiment and comment on how the effectiveness of
sched_mc_power_savings can be analysed.  

At very very low wakeup count of ~4 per second on 4 CPU system gave
good idle time result when sched_mc_power_savings is enabled.

However the results are not as expected even at a marginal wakeup
count of ~35 per second.  

Please let us know your comments and suggestions on the experiment or
results.  

Do we have similar analysis and data on scheduler heuristics for power
savings.

Thanks,
Vaidy

