Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbXLJKPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbXLJKPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXLJKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:15:35 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55322 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbXLJKPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:15:34 -0500
Date: Mon, 10 Dec 2007 15:45:00 +0530
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
Message-ID: <20071210101500.GB12880@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com> <20071209074647.GE22981@elte.hu> <20071210081952.GA7215@in.ibm.com> <475CFF01.2090502@gmail.com> <20071210091052.GA14487@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210091052.GA14487@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 10:10:52AM +0100, Ingo Molnar wrote:
> 
> > > softlockup: remove get_online_cpus() which doesn't help here.
> > > 
> > > The get_online_cpus() protection seems to be bogus in 
> > > kernel/softlockup.c as cpu cached in check_cpu can go offline once 
> > > we do a put_online_cpus().
> > > 
> > > This can also cause deadlock during a cpu offline as follows:
> 
> i'm wondering, what's the proper CPU-hotplug safe sequence here then? 
> I'm picking a CPU number from cpu_online_map, and that CPU could go away 
> while i'm still using it, right? What's saving us here?

In this particular case, we are trying to see if any task on a particular
cpu has not been scheduled for a really long time. If we do this check
on a cpu which has gone offline, then
a) If the tasks have not been migrated on to another cpu yet, we will
still perform that check and yell if something has been holding any task
for a sufficiently long time.
b) If the tasks have been migrated off, then we have nothing to check.

However, if we still want that particular cpu to not go offline during
the check, then could we use the following patch

commit a49736844717e00f7a37c96368cea8fec7eb31cf
Author: Gautham R Shenoy <ego@in.ibm.com>
Date:   Mon Dec 10 15:43:32 2007 +0530

CPU-Hotplug: Add try_get_online_cpus()

Add the fastpath code, try_get_online_cpus() which will
return 1 once it has managed to hold the reference to the cpu_online_map
if there are no threads trying to perform a cpu-hotplug.

Use the primitive in the softlockup code.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linuxtronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index e0132cb..d236e21 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -107,6 +107,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 }
 
 extern void get_online_cpus(void);
+extern int  try_get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb =			\
@@ -127,6 +128,9 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+static inline int try_get_online_cpus(void) 
+{ return 1;}
+
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e0d3a4f..38537c9 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -48,11 +48,35 @@ void __init cpu_hotplug_init(void)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
+/*
+ * try_get_online_cpus(): Tries to hold a reference 
+ * to the cpu_online_map if no one is trying to perform 
+ * a cpu-hotplug operation. This is the fastpath code for
+ * get_online_cpus.
+ *
+ * Returns 1 if there is no cpu-hotplug operation
+ * currently in progress.
+ */
+int try_get_online_cpus(void)
+{
+	if(!cpu_hotplug.active_writer) {
+		cpu_hotplug.refcount++;
+		return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(try_get_online_cpus);
+
 void get_online_cpus(void)
 {
 	might_sleep();
 	if (cpu_hotplug.active_writer == current)
 		return;
+	if (try_get_online_cpus())
+		return;
+
+	/* The writer exists, hence the slowpath */
 	mutex_lock(&cpu_hotplug.lock);
 	cpu_hotplug.refcount++;
 	mutex_unlock(&cpu_hotplug.lock);
@@ -120,6 +144,11 @@ static void cpu_hotplug_begin(void)
 	mutex_lock(&cpu_hotplug.lock);
 
 	cpu_hotplug.active_writer = current;
+	synchronize_sched();
+	/* New users of get_online_cpus() will see a non-NULL value
+	 * for cpu_hotplug.active_writer here and will take the slowpath
+	 */
+
 	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
 	while (cpu_hotplug.refcount) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 576eb9c..cb0616d 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -150,8 +150,8 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 	sysctl_hung_task_warnings--;
 
 	/*
-	 * Ok, the task did not get scheduled for more than 2 minutes,
-	 * complain:
+	 * Ok, the task did not get scheduled for more than
+	 * sysctl_hung_task_timeout_secs, complain:
 	 */
 	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
 			"%ld seconds.\n", t->comm, t->pid,
@@ -216,16 +216,21 @@ static int watchdog(void *__bind_cpu)
 		touch_softlockup_watchdog();
 		msleep_interruptible(10000);
 
+		/* 
+		 * If a cpu-hotplug operation is in progress
+		 * we can come back later
+		 */
+		if (!try_get_online_cpus())
+			continue; 
 		/*
 		 * Only do the hung-tasks check on one CPU:
 		 */
 		check_cpu = any_online_cpu(cpu_online_map);
 
-		if (this_cpu != check_cpu)
-			continue;
-
-		if (sysctl_hung_task_timeout_secs)
+		if ((this_cpu == check_cpu) && sysctl_hung_task_timeout_secs)
 			check_hung_uninterruptible_tasks(this_cpu);
+
+		put_online_cpus();
 	}
 
 	return 0;






> 
> 	Ingo

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
