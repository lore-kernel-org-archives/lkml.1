Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYGLKDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYGLKDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 06:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYGLKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 06:02:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbYGLKCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 06:02:55 -0400
Message-ID: <487880D7.1040608@cn.fujitsu.com>
Date: Sat, 12 Jul 2008 18:00:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <20080712031736.GA3040@damson.getinternet.no> <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2008-7-12 11:28 Linus Torvalds wrote:
> 
> On Sat, 12 Jul 2008, Vegard Nossum wrote:
>> Can somebody else please test/ack/review it too? This should eventually
>> go into 2.6.26 if it doesn't break anything else.
> 
> And Dmitry, _please_ also explain what was going on. Why did things break 
> from calling common_cpu_mem_hotplug_unplug() too much? That function is 
> called pretty randomly anyway (for just about any random CPU event), so 
> why did it fail in some circumstances?
> 
> 		Linus
> 

My explanation:
	http://lkml.org/lkml/2008/7/7/75
this bug occurred on the kernel compiled with CONFIG_CPUSETS=y.

As Dmitry said in the following mail, modifying try_to_wake_up() to fix this bug
is not perfect. Maybe we need update the sched domain before migrating tasks.
	http://lkml.org/lkml/2008/7/7/94

So I remake a patch to fix this bug by updating the sched domain when a cpu is in
CPU_DOWN_PREPARE state.

I think Vegard Nossum's patch is not so good because it is not necessary to detach
all the sched domains when making a cpu offline.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 include/linux/sched.h |    1 +
 kernel/cpuset.c       |   30 +++++++++++++++++++++++++-----
 kernel/sched.c        |   28 +++++++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..cf40eae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -817,6 +817,7 @@ struct sched_domain {
 #endif
 };
 
+extern void detach_sched_domains(int cpu);
 extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9fceb97..64fa742 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1910,13 +1910,33 @@ static void common_cpu_mem_hotplug_unplug(void)
  */
 
 static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
-				unsigned long phase, void *unused_cpu)
+				unsigned long phase, void *hcpu)
 {
-	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
-		return NOTIFY_DONE;
+	int cpu = (long)hcpu;
 
-	common_cpu_mem_hotplug_unplug();
-	return 0;
+	switch (phase) {
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		cgroup_lock();
+		get_online_cpus();
+		detach_sched_domains(cpu);
+		put_online_cpus();
+		cgroup_unlock();
+		break;
+
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		common_cpu_mem_hotplug_unplug();
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/kernel/sched.c b/kernel/sched.c
index 4e2f603..73e0026 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7315,6 +7315,32 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
 			sizeof(struct sched_domain_attr));
 }
 
+
+/*
+ * Detach sched domains from a group of cpus which are in the same domain with
+ * the specified cpu. These cpus will now be attach to the NULL domain.
+ *
+ * Call with hotplug lock and cgroup lock held
+ */
+void detach_sched_domains(int cpu)
+{
+	int i;
+
+	unregister_sched_domain_sysctl();
+
+	mutex_lock(&sched_domains_mutex);
+
+	for (i = 0; i < ndoms_cur; i++) {
+		if (cpu_isset(cpu, doms_cur[i])) {
+			detach_destroy_domains(doms_cur + i);
+			cpus_clear(doms_cur[i]);
+			break;
+		}
+	}
+
+	mutex_unlock(&sched_domains_mutex);
+}
+
 /*
  * Partition sched domains as specified by the 'ndoms_new'
  * cpumasks in the array doms_new[] of cpumasks. This compares
@@ -7481,6 +7507,7 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 static int update_sched_domains(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
+#ifndef CONFIG_CPUSETS
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
@@ -7506,7 +7533,6 @@ static int update_sched_domains(struct notifier_block *nfb,
 		return NOTIFY_DONE;
 	}
 
-#ifndef CONFIG_CPUSETS
 	/*
 	 * Create default domain partitioning if cpusets are disabled.
 	 * Otherwise we let cpusets rebuild the domains based on the
-- 
1.5.4.rc3


