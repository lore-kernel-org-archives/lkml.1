Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYGLVcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYGLVcC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 17:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYGLVbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 17:31:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbYGLVbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 17:31:52 -0400
Date: Sat, 12 Jul 2008 14:30:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Linus Torvalds wrote:
> 
> > Being called for CPU_UP_PREPARE (and if its callback is called after
> > update_sched_domains()), it just negates all the work done by
> > update_sched_domains() -- i.e. a soon-to-be-offline cpu is included in
> > the sched-domains and that makes it visible for the load-balancer
> > while the CPU_DOWN ops. is in progress.
> 
> This sounds like it could trigger various other problems too, but happily 
> hit the BUG_ON() first.

Btw - the way to avoid this whole problem might be to make CPU migration 
use a *different* CPU map than "online".

This patch almost certainly doesn't work, but let me explain:

 - "cpu_online_map" is the CPU's that can be currently be running

   It is enabled/disabled by low-level architecture code when the CPU 
   actually gets disabled.

 - Add a new "cpu_active_map", which is the CPU's that are currently fully 
   set up, and can not just be running tasks, but can be _migrated_ to!

 - We can always just clear the "cpu_active_map" entry when we start a CPU 
   down event - that guarantees that while tasks may be running on it, 
   there won't be any _new_ tasks migrated to it.

 - both cpu_down() and cpu_up() can just end with a simple

	if (cpu_online(cpu))
		cpu_set(cpu, cpu_active_map);

   before they release the hotplug lock, and it will always do the right 
   thing regardless of whether the up/down succeeded or not.

The _only_ thing that "active" is used for is literally to verify that a 
migration is valid before doing it.

Now, a few points:
 (a) it's *TOTALLY* untested. It may or may not compile.
 (b) I think many architectures do magic things at the initial boot, and 
     change the online maps in odd ways. I tried to avoid this by simply 
     doing the initial "cpu_set()" of cpu_active_map pretty late, just 
     before we bring up other CPUs
 (c) I think this is a pretty simple approach - and like how all the code 
     is architecture-neutral. The "active" map may not be used a lot, but 
     doesn't this simplify the whole problem a lot? It just makes the 
     whole scheduling issue go away for CPU's that are going down.

What do you guys think? Ingo?

Vegard, and just out of interest, in case this would happen to work, does 
this actually end up also fixing the bug (with the other fixes unapplied?)

		Linus

---
 include/linux/cpumask.h |   15 ++++++++++++++-
 init/main.c             |    7 +++++++
 kernel/cpu.c            |    8 +++++++-
 kernel/sched.c          |    2 +-
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c24875b..88f2dd2 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -359,13 +359,14 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 
 /*
  * The following particular system cpumasks and operations manage
- * possible, present and online cpus.  Each of them is a fixed size
+ * possible, present, active and online cpus.  Each of them is a fixed size
  * bitmap of size NR_CPUS.
  *
  *  #ifdef CONFIG_HOTPLUG_CPU
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
  *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
  *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
+ *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
  *  #else
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populated
  *     cpu_present_map  - copy of cpu_possible_map
@@ -417,6 +418,16 @@ extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
 
+/*
+ * With CONFIG_HOTPLUG_CPU, cpu_active_map is a real instance.
+ * Without hotplugging, "online" and "active" are the same.
+ */
+#ifdef CONFIG_HOTPLUG_CPU
+extern cpumask_t cpu_active_map;
+#else
+#define cpu_active_map cpu_online_map
+#endif
+
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
 #define num_possible_cpus()	cpus_weight(cpu_possible_map)
@@ -424,6 +435,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -431,6 +443,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_active(cpu)		((cpu) == 0)
 #endif
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
diff --git a/init/main.c b/init/main.c
index f7fb200..bfccff6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -414,6 +414,13 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
+	/*
+	 * Set up the current CPU as possible to migrate to.
+	 * The other ones will be done by cpu_up/cpu_down()
+	 */
+	cpu = smp_processor_id();
+	cpu_set(cpu, cpu_active_map);
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index c77bc3a..2a30026 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -44,6 +44,8 @@ void __init cpu_hotplug_init(void)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
+cpumask_t cpu_active_map;
+
 void get_online_cpus(void)
 {
 	might_sleep();
@@ -269,11 +271,13 @@ int __ref cpu_down(unsigned int cpu)
 	int err = 0;
 
 	cpu_maps_update_begin();
+	cpu_clear(cpu, cpu_active_map);
 	if (cpu_hotplug_disabled)
 		err = -EBUSY;
 	else
 		err = _cpu_down(cpu, 0);
-
+	if (cpu_online(cpu))
+		cpu_set(cpu, cpu_active_map);
 	cpu_maps_update_done();
 	return err;
 }
@@ -337,6 +341,8 @@ int __cpuinit cpu_up(unsigned int cpu)
 	else
 		err = _cpu_up(cpu, 0);
 
+	if (cpu_online(cpu))
+		cpu_set(cpu, cpu_active_map);
 	cpu_maps_update_done();
 	return err;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 4e2f603..21ee025 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2680,7 +2680,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 
 	rq = task_rq_lock(p, &flags);
 	if (!cpu_isset(dest_cpu, p->cpus_allowed)
-	    || unlikely(cpu_is_offline(dest_cpu)))
+	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
 	/* force the process onto the specified CPU */
