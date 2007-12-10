Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXLJLXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXLJLXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXLJLX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:23:29 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:34089 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbXLJLX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:23:28 -0500
Date: Mon, 10 Dec 2007 16:38:18 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071210110818.GC12880@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com> <20071209074647.GE22981@elte.hu> <20071210081952.GA7215@in.ibm.com> <475CFF01.2090502@gmail.com> <20071210091052.GA14487@elte.hu> <20071210101500.GB12880@in.ibm.com> <20071210102157.GB31103@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210102157.GB31103@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 11:21:57AM +0100, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > > i'm wondering, what's the proper CPU-hotplug safe sequence here 
> > > then? I'm picking a CPU number from cpu_online_map, and that CPU 
> > > could go away while i'm still using it, right? What's saving us 
> > > here?
> > 
> > In this particular case, we are trying to see if any task on a 
> > particular cpu has not been scheduled for a really long time. If we do 
> > this check on a cpu which has gone offline, then a) If the tasks have 
> > not been migrated on to another cpu yet, we will still perform that 
> > check and yell if something has been holding any task for a 
> > sufficiently long time. b) If the tasks have been migrated off, then 
> > we have nothing to check.
> 
> say we've got 100 CPUs, so we've got 100 watchdog tasks running - one 
> for each CPU. Checking for hung tasks is a global operation not a 
> per-CPU operation (we iterate over the global tasklist), hence only one 
> CPU should really be calling this function. That online-cpus logic 
> achieves this by picking a single CPU. Perhaps it would be better to 
> keep a hung_task_checker_cpu variable that is driven from a 
> CPU-hotplug-down notifier? That way if a CPU is brought down we can 
> update hung_task_checker_cpu to another, still-online CPU. (this would 
> also be faster, because event-driven)

Do you mean something like this?

From: Gautham R Shenoy <ego@in.ibm.com>

softlockup: update check_cpu during cpu-hotplug

Update the check_cpu value during a cpu-hotplug operation
so that we don't check for hung tasks on a cpu which is about 
to go offline.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linuxtronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
---

 kernel/softlockup.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 576eb9c..b1a8c7c 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -194,6 +194,9 @@ static void check_hung_uninterruptible_tasks(int this_cpu)
 	read_unlock(&tasklist_lock);
 }
 
+
+static int check_cpu = -1;
+
 /*
  * The watchdog thread - runs every second and touches the timestamp.
  */
@@ -219,8 +222,6 @@ static int watchdog(void *__bind_cpu)
 		/*
 		 * Only do the hung-tasks check on one CPU:
 		 */
-		check_cpu = any_online_cpu(cpu_online_map);
-
 		if (this_cpu != check_cpu)
 			continue;
 
@@ -255,6 +256,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		check_cpu = any_online_cpu(cpu_online_map);
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -265,6 +267,14 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(watchdog_task, hotcpu),
 			     any_online_cpu(cpu_online_map));
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		if (hotcpu == check_cpu) {
+			cpumask_t temp_cpu_online_map = cpu_online_map; 
+			cpu_clear(hotcpu, temp_cpu_online_map);
+			check_cpu = any_online_cpu(temp_cpu_online_map);
+		}
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);



> 
> 	Ingo

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
