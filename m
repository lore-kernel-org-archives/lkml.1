Return-Path: <linux-kernel-owner+w=401wt.eu-S1761955AbYGOCjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761955AbYGOCjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761651AbYGOCe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:56 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19424 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbYGOCex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:53 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 01/14] Introduce cpu_enabled_map and friends
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>
Date: Mon, 14 Jul 2008 20:33:49 -0600
Message-ID: <20080715023349.2528.9423.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
References: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the following cpu maps exist:

	cpu_possible_map - map of populatable CPUs
	cpu_present_map  - map of populated CPUs
	cpu_online_map   - map of schedulable CPUs

These maps do not provide the concept of populated, but disabled CPUs.

That is, a system may contain CPU modules that are physically plugged
in, but disabled by system firmware. The existence of this class of
CPUs breaks the following assumption in smp_init():

        for_each_present_cpu(cpu) {

		.../...

                if (!cpu_online(cpu))
                        cpu_up(cpu);
        }

The assumption is that the kernel should attempt cpu_up() on every
physically populated CPU, which may not be desirable for present but
disabled CPUs.

By providing cpu_enabled_map, we can keep the above [simplifying]
assumption in smp_init(), and push the knowledge of disabled CPUs
and the decision to bring them up, down into arch specific code.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/base/cpu.c      |    9 +++++++--
 include/linux/cpumask.h |   31 ++++++++++++++++++++++++-------
 init/main.c             |    1 +
 kernel/sched.c          |   16 ++++++++++++----
 4 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e38dfed..bc300df 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -57,7 +57,10 @@ static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
 static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
-	sysdev_create_file(&cpu->sysdev, &attr_online);
+	int logical_cpu = cpu->sysdev.id;
+
+	if (cpu_isset(logical_cpu, cpu_enabled_map))
+		sysdev_create_file(&cpu->sysdev, &attr_online);
 }
 void unregister_cpu(struct cpu *cpu)
 {
@@ -125,11 +128,13 @@ struct sysdev_class_attribute attr_##type##_map = 			\
 print_cpus_func(online);
 print_cpus_func(possible);
 print_cpus_func(present);
+print_cpus_func(enabled);
 
 struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_online_map,
 	&attr_possible_map,
 	&attr_present_map,
+ 	&attr_enabled_map,
 };
 
 static int cpu_states_init(void)
@@ -172,7 +177,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 		register_cpu_under_node(num, cpu_to_node(num));
 
 #ifdef CONFIG_KEXEC
-	if (!error)
+	if ((!error) && cpu_isset(num, cpu_enabled_map))
 		error = sysdev_create_file(&cpu->sysdev, &attr_crash_notes);
 #endif
 	return error;
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c24875b..bba31aa 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -64,16 +64,19 @@
  * int num_online_cpus()		Number of online CPUs
  * int num_possible_cpus()		Number of all possible CPUs
  * int num_present_cpus()		Number of present CPUs
+ * int num_enabled_cpus()		Number of enabled CPUs
  *
  * int cpu_online(cpu)			Is some cpu online?
  * int cpu_possible(cpu)		Is some cpu possible?
  * int cpu_present(cpu)			Is some cpu present (can schedule)?
+ * int cpu_enabled(cpu)			Is some cpu enabled (by firmware)?
  *
  * int any_online_cpu(mask)		First online cpu in mask
  *
  * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_map
  * for_each_online_cpu(cpu)		for-loop cpu over cpu_online_map
  * for_each_present_cpu(cpu)		for-loop cpu over cpu_present_map
+ * for_each_enabled_cpu(cpu)		for-loop cpu over cpu_enabled_map
  *
  * Subtlety:
  * 1) The 'type-checked' form of cpu_isset() causes gcc (3.3.2, anyway)
@@ -359,16 +362,18 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 
 /*
  * The following particular system cpumasks and operations manage
- * possible, present and online cpus.  Each of them is a fixed size
- * bitmap of size NR_CPUS.
+ * possible, present, enabled and online cpus.  Each of them is a fixed
+ * size bitmap of size NR_CPUS.
  *
  *  #ifdef CONFIG_HOTPLUG_CPU
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
  *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
+ *     cpu_enabled_map  - has bit 'cpu' set iff cpu is enabled by firmware
  *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
  *  #else
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populated
  *     cpu_present_map  - copy of cpu_possible_map
+ *     cpu_enabled_map  - copy of cpu_possible_map
  *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
  *  #endif
  *
@@ -377,9 +382,10 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
  *  time, as the set of CPU id's that it is possible might ever
  *  be plugged in at anytime during the life of that system boot.
  *  The cpu_present_map is dynamic(*), representing which CPUs
- *  are currently plugged in.  And cpu_online_map is the dynamic
- *  subset of cpu_present_map, indicating those CPUs available
- *  for scheduling.
+ *  are currently plugged in.  The cpu_enabled_map is also dynamic(*),
+ *  and represents CPUs both plugged in and enabled by firmware.
+ *  And cpu_online_map is the dynamic subset of cpu_present_map,
+ *  indicating those CPUs available for scheduling.
  *
  *  If HOTPLUG is enabled, then cpu_possible_map is forced to have
  *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
@@ -389,8 +395,13 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
  *  depending on what ACPI reports as currently plugged in, otherwise
  *  cpu_present_map is just a copy of cpu_possible_map.
  *
- *  (*) Well, cpu_present_map is dynamic in the hotplug case.  If not
- *      hotplug, it's a copy of cpu_possible_map, hence fixed at boot.
+ *  If HOTPLUG is enabled, then cpu_enabled_map varies dynamically,
+ *  depending on what ACPI reports as currently enabled by firmware,
+ *  otherwise cpu_enabled_map is just a copy of cpu_possible_map.
+ *
+ *  (*) Well, cpu_present_map and cpu_enabled_map are dynamic in the
+ *      hotplug case.  If not hotplug, they're copies of cpu_possible_map,
+ *      hence fixed at boot.
  *
  * Subtleties:
  * 1) UP arch's (NR_CPUS == 1, CONFIG_SMP not defined) hardcode
@@ -416,21 +427,26 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_enabled_map;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
 #define num_possible_cpus()	cpus_weight(cpu_possible_map)
 #define num_present_cpus()	cpus_weight(cpu_present_map)
+#define num_enabled_cpus()	cpus_weight(cpu_enabled_map)
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_enabled(cpu)	cpu_isset((cpu), cpu_enabled_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
 #define num_present_cpus()	1
+#define num_enabled_cpus()	1
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_enabled(cpu)	((cpu) == 0)
 #endif
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
@@ -447,5 +463,6 @@ int __any_online_cpu(const cpumask_t *mask);
 #define for_each_possible_cpu(cpu)  for_each_cpu_mask((cpu), cpu_possible_map)
 #define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_map)
 #define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_map)
+#define for_each_enabled_cpu(cpu)  for_each_cpu_mask((cpu), cpu_enabled_map)
 
 #endif /* __LINUX_CPUMASK_H */
diff --git a/init/main.c b/init/main.c
index f7fb200..1fe50c6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -520,6 +520,7 @@ static void __init boot_cpu_init(void)
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
 	cpu_set(cpu, cpu_online_map);
 	cpu_set(cpu, cpu_present_map);
+	cpu_set(cpu, cpu_enabled_map);
 	cpu_set(cpu, cpu_possible_map);
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 4e2f603..b04eb61 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5071,15 +5071,23 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 }
 
 /*
- * Represents all cpu's present in the system
+ * Represents all CPUs present in the system
  * In systems capable of hotplug, this map could dynamically grow
- * as new cpu's are detected in the system via any platform specific
- * method, such as ACPI for e.g.
+ * as new CPUs are detected in the system via any platform specific
+ * method, such as ACPI.
  */
-
 cpumask_t cpu_present_map __read_mostly;
 EXPORT_SYMBOL(cpu_present_map);
 
+/*
+ * Represents all CPUs enabled by firmware in the system
+ * In systems capable of hotplug, this map could dynamically grow
+ * as new CPUs are detected in the system via any platform specific
+ * method, such as ACPI.
+ */
+cpumask_t cpu_enabled_map __read_mostly;
+EXPORT_SYMBOL(cpu_enabled_map);
+
 #ifndef CONFIG_SMP
 cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
 EXPORT_SYMBOL(cpu_online_map);

