Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZBRMHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZBRMHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZBRMFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:50746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbZBRMFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:39 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Cc: mingo@redhat.com, lenb@kernel.org, cpufreq@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] alloc_percpu: change percpu_ptr to per_cpu_ptr
Date: Wed, 18 Feb 2009 21:04:30 +0900
Message-Id: <1234958676-27618-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:04:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: cleanup

There are two allocated per-cpu accessor macros with almost identical
spelling.  The original and far more popular is per_cpu_ptr (44
files), so change over the other 4 files.

tj: kill percpu_ptr() and update UP too

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: mingo@redhat.com
Cc: lenb@kernel.org
Cc: cpufreq@vger.kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 drivers/acpi/processor_perflib.c           |    4 ++--
 include/linux/percpu.h                     |   23 +++++++++++------------
 kernel/sched.c                             |    6 +++---
 kernel/stop_machine.c                      |    2 +-
 5 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4b1c319..22590cf 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -601,7 +601,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (!data)
 		return -ENOMEM;
 
-	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
+	data->acpi_data = per_cpu_ptr(acpi_perf_data, cpu);
 	per_cpu(drv_data, cpu) = data;
 
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 9cc769b..68fd3d2 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -516,12 +516,12 @@ int acpi_processor_preregister_performance(
 			continue;
 		}
 
-		if (!performance || !percpu_ptr(performance, i)) {
+		if (!performance || !per_cpu_ptr(performance, i)) {
 			retval = -EINVAL;
 			continue;
 		}
 
-		pr->performance = percpu_ptr(performance, i);
+		pr->performance = per_cpu_ptr(performance, i);
 		cpumask_set_cpu(i, pr->performance->shared_cpu_map);
 		if (acpi_processor_get_psd(pr)) {
 			retval = -EINVAL;
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 3577ffd..c80cfe1 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -81,23 +81,13 @@ struct percpu_data {
 };
 
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
-/* 
- * Use this to get to a cpu's version of the per-cpu object dynamically
- * allocated. Non-atomic access to the current CPU's version should
- * probably be combined with get_cpu()/put_cpu().
- */ 
-#define percpu_ptr(ptr, cpu)                              \
-({                                                        \
-        struct percpu_data *__p = __percpu_disguise(ptr); \
-        (__typeof__(ptr))__p->ptrs[(cpu)];	          \
-})
 
 extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
 extern void percpu_free(void *__pdata);
 
 #else /* CONFIG_SMP */
 
-#define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
+#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
 static __always_inline void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
@@ -122,6 +112,15 @@ static inline void percpu_free(void *__pdata)
 						  cpu_possible_map)
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type))
 #define free_percpu(ptr)	percpu_free((ptr))
-#define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
+/*
+ * Use this to get to a cpu's version of the per-cpu object dynamically
+ * allocated. Non-atomic access to the current CPU's version should
+ * probably be combined with get_cpu()/put_cpu().
+ */
+#define per_cpu_ptr(ptr, cpu)						\
+({									\
+        struct percpu_data *__p = __percpu_disguise(ptr);		\
+        (__typeof__(ptr))__p->ptrs[(cpu)];				\
+})
 
 #endif /* __LINUX_PERCPU_H */
diff --git a/kernel/sched.c b/kernel/sched.c
index fc17fd9..9d30ac9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9472,7 +9472,7 @@ cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 
 static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
 {
-	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 	u64 data;
 
 #ifndef CONFIG_64BIT
@@ -9491,7 +9491,7 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
 
 static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
 {
-	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 
 #ifndef CONFIG_64BIT
 	/*
@@ -9587,7 +9587,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	ca = task_ca(tsk);
 
 	for (; ca; ca = ca->parent) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
 }
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 0cd415e..74541ca 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -170,7 +170,7 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
 	for_each_online_cpu(i) {
-		sm_work = percpu_ptr(stop_machine_work, i);
+		sm_work = per_cpu_ptr(stop_machine_work, i);
 		INIT_WORK(sm_work, stop_cpu);
 		queue_work_on(i, stop_machine_wq, sm_work);
 	}
-- 
1.6.0.2

