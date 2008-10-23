Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbYJWCSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbYJWCSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYJWCI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46593 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754743AbYJWCIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:32 -0400
Message-Id: <20081023020832.084887000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:55 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 29/35] cpumask: switch over to cpu_online/possible/active/present_mask From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cpu_online_mask-et-al.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to hide the definition of struct cpumask, we need to expose
only pointers.  Plus, it fits the new API far better to have pointers.

This deprecates the old _map versions, and defines them in terms of the
_mask versions.  It also centralizes the definitions (finally!).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/alpha/kernel/smp.c             |    5 --
 arch/arm/kernel/smp.c               |   10 ----
 arch/cris/arch-v32/kernel/smp.c     |    4 -
 arch/ia64/kernel/smpboot.c          |    6 --
 arch/m32r/kernel/smpboot.c          |    6 --
 arch/mips/kernel/smp.c              |    2
 arch/parisc/kernel/smp.c            |   15 ------
 arch/powerpc/kernel/smp.c           |    4 -
 arch/s390/kernel/smp.c              |    6 --
 arch/sh/kernel/smp.c                |    6 --
 arch/sparc/kernel/sparc_ksyms.c     |    2
 include/linux/cpumask.h |   84 ++++++++++++++++++++----------------------------
 kernel/cpu.c            |   71 +++++++++++++++++++---------------------
 2 files changed, 70 insertions(+), 85 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -87,9 +87,9 @@
  * int cpumask_any_and(mask1,mask2)	Any cpu in both masks
  * int cpumask_any_but(mask,cpu)	Any cpu in mask except cpu
  *
- * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_map
- * for_each_online_cpu(cpu)		for-loop cpu over cpu_online_map
- * for_each_present_cpu(cpu)		for-loop cpu over cpu_present_map
+ * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_mask
+ * for_each_online_cpu(cpu)		for-loop cpu over cpu_online_mask
+ * for_each_present_cpu(cpu)		for-loop cpu over cpu_present_mask
  *
  * Subtlety:
  * 1) The 'type-checked' form of cpu_isset() causes gcc (3.3.2, anyway)
@@ -160,7 +160,7 @@ extern cpumask_t _unused_cpumask_arg_;
 		for_each_cpu_and(cpu, &(mask), &(and))
 #define first_cpu(src)		cpumask_first(&(src))
 #define next_cpu(n, src)	cpumask_next((n), &(src))
-#define any_online_cpu(mask)	cpumask_any_and(&(mask), &cpu_online_map)
+#define any_online_cpu(mask)	cpumask_any_and(&(mask), cpu_online_mask)
 #if NR_CPUS > BITS_PER_LONG
 #define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
 #define	CPUMASK_FREE(m)		kfree(m)
@@ -169,6 +169,11 @@ extern cpumask_t _unused_cpumask_arg_;
 #define	CPUMASK_FREE(m)
 #endif
 #define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
+/* These strip const, as traditionally they weren't const. */
+#define cpu_possible_map	(*(cpumask_t *)cpu_possible_mask)
+#define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
+#define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
+#define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
 /* End deprecated region. */
 
 #if NR_CPUS > 1
@@ -512,65 +517,48 @@ static inline void free_cpumask_var(cpum
 
 /*
  * The following particular system cpumasks and operations manage
- * possible, present, active and online cpus.  Each of them is a fixed size
- * bitmap of size NR_CPUS.
+ * possible, present, active and online cpus.
  *
- *  #ifdef CONFIG_HOTPLUG_CPU
- *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
- *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
- *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
- *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
- *  #else
- *     cpu_possible_map - has bit 'cpu' set iff cpu is populated
- *     cpu_present_map  - copy of cpu_possible_map
- *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
- *  #endif
- *
- *  In either case, NR_CPUS is fixed at compile time, as the static
- *  size of these bitmaps.  The cpu_possible_map is fixed at boot
- *  time, as the set of CPU id's that it is possible might ever
- *  be plugged in at anytime during the life of that system boot.
- *  The cpu_present_map is dynamic(*), representing which CPUs
- *  are currently plugged in.  And cpu_online_map is the dynamic
- *  subset of cpu_present_map, indicating those CPUs available
- *  for scheduling.
+ *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
+ *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
+ *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
+ *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
+ *
+ *  If !CONFIG_HOTPLUG_CPU, present == possible, and active == online.
+ *
+ *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
+ *  that it is possible might ever be plugged in at anytime during the
+ *  life of that system boot.  The cpu_present_mask is dynamic(*),
+ *  representing which CPUs are currently plugged in.  And
+ *  cpu_online_mask is the dynamic subset of cpu_present_mask,
+ *  indicating those CPUs available for scheduling.
  *
- *  If HOTPLUG is enabled, then cpu_possible_map is forced to have
+ *  If HOTPLUG is enabled, then cpu_possible_mask is forced to have
  *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
  *  ACPI reports present at boot.
  *
- *  If HOTPLUG is enabled, then cpu_present_map varies dynamically,
+ *  If HOTPLUG is enabled, then cpu_present_mask varies dynamically,
  *  depending on what ACPI reports as currently plugged in, otherwise
- *  cpu_present_map is just a copy of cpu_possible_map.
+ *  cpu_present_mask is just a copy of cpu_possible_mask.
  *
- *  (*) Well, cpu_present_map is dynamic in the hotplug case.  If not
- *      hotplug, it's a copy of cpu_possible_map, hence fixed at boot.
+ *  (*) Well, cpu_present_mask is dynamic in the hotplug case.  If not
+ *      hotplug, it's a copy of cpu_possible_mask, hence fixed at boot.
  *
  * Subtleties:
  * 1) UP arch's (NR_CPUS == 1, CONFIG_SMP not defined) hardcode
  *    assumption that their single CPU is online.  The UP
- *    cpu_{online,possible,present}_maps are placebos.  Changing them
+ *    cpu_{online,possible,present}_masks are placebos.  Changing them
  *    will have no useful affect on the following num_*_cpus()
  *    and cpu_*() macros in the UP case.  This ugliness is a UP
  *    optimization - don't waste any instructions or memory references
  *    asking if you're online or how many CPUs there are if there is
  *    only one CPU.
- * 2) Most SMP arch's #define some of these maps to be some
- *    other map specific to that arch.  Therefore, the following
- *    must be #define macros, not inlines.  To see why, examine
- *    the assembly code produced by the following.  Note that
- *    set1() writes phys_x_map, but set2() writes x_map:
- *        int x_map, phys_x_map;
- *        #define set1(a) x_map = a
- *        inline void set2(int a) { x_map = a; }
- *        #define x_map phys_x_map
- *        main(){ set1(3); set2(5); }
  */
 
-extern cpumask_t cpu_possible_map;
-extern cpumask_t cpu_online_map;
-extern cpumask_t cpu_present_map;
-extern cpumask_t cpu_active_map;
+extern const struct cpumask *const cpu_possible_mask;
+extern const struct cpumask *const cpu_online_mask;
+extern const struct cpumask *const cpu_present_mask;
+extern const struct cpumask *const cpu_active_mask;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
@@ -601,8 +589,8 @@ void init_cpu_online(const struct cpumas
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#define for_each_possible_cpu(cpu) for_each_cpu((cpu), &cpu_possible_map)
-#define for_each_online_cpu(cpu)   for_each_cpu((cpu), &cpu_online_map)
-#define for_each_present_cpu(cpu)  for_each_cpu((cpu), &cpu_present_map)
+#define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
+#define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
+#define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
 
 #endif /* __LINUX_CPUMASK_H */
--- linux-2.6.28.orig/kernel/cpu.c
+++ linux-2.6.28/kernel/cpu.c
@@ -15,30 +15,8 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 
-/*
- * Represents all cpu's present in the system
- * In systems capable of hotplug, this map could dynamically grow
- * as new cpu's are detected in the system via any platform specific
- * method, such as ACPI for e.g.
- */
-cpumask_t cpu_present_map __read_mostly;
-EXPORT_SYMBOL(cpu_present_map);
-
-/*
- * Represents all cpu's that are currently online.
- */
-cpumask_t cpu_online_map __read_mostly;
-EXPORT_SYMBOL(cpu_online_map);
-
-#ifdef CONFIG_INIT_ALL_POSSIBLE
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
-#else
-cpumask_t cpu_possible_map __read_mostly;
-#endif
-EXPORT_SYMBOL(cpu_possible_map);
-
 #ifdef CONFIG_SMP
-/* Serializes the updates to cpu_online_map, cpu_present_map */
+/* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
 static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
@@ -65,8 +43,6 @@ void __init cpu_hotplug_init(void)
 	cpu_hotplug.refcount = 0;
 }
 
-cpumask_t cpu_active_map;
-
 #ifdef CONFIG_HOTPLUG_CPU
 
 void get_online_cpus(void)
@@ -97,7 +73,7 @@ EXPORT_SYMBOL_GPL(put_online_cpus);
 
 /*
  * The following two API's must be used when attempting
- * to serialize the updates to cpu_online_map, cpu_present_map.
+ * to serialize the updates to cpu_online_mask, cpu_present_mask.
  */
 void cpu_maps_update_begin(void)
 {
@@ -501,43 +477,64 @@ const unsigned long cpu_bit_bitmap[BITS_
 };
 EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
 
+#ifdef CONFIG_INIT_ALL_POSSIBLE
+static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
+	= CPU_BITS_ALL;
+#else
+static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
+#endif
+const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
+EXPORT_SYMBOL(cpu_possible_mask);
+
+static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
+EXPORT_SYMBOL(cpu_online_mask);
+
+static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
+EXPORT_SYMBOL(cpu_present_mask);
+
+static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
+EXPORT_SYMBOL(cpu_active_mask);
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
-		cpumask_set_cpu(cpu, &cpu_possible_map);
+		cpumask_set_cpu(cpu, to_cpumask(cpu_possible_bits));
 	else
-		cpumask_clear_cpu(cpu, &cpu_possible_map);
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
 }
 void set_cpu_present(unsigned int cpu, bool present)
 {
 	if (present)
-		cpumask_set_cpu(cpu, &cpu_present_map);
+		cpumask_set_cpu(cpu, to_cpumask(cpu_present_bits));
 	else
-		cpumask_clear_cpu(cpu, &cpu_present_map);
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_present_bits));
 }
 void set_cpu_online(unsigned int cpu, bool online)
 {
 	if (online)
-		cpumask_set_cpu(cpu, &cpu_online_map);
+		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
-		cpumask_clear_cpu(cpu, &cpu_online_map);
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
 }
 void set_cpu_active(unsigned int cpu, bool active)
 {
 	if (active)
-		cpumask_set_cpu(cpu, &cpu_active_map);
+		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
 	else
-		cpumask_clear_cpu(cpu, &cpu_active_map);
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
 }
 void init_cpu_present(const struct cpumask *src)
 {
-	cpumask_copy(&cpu_present_map, src);
+	cpumask_copy(to_cpumask(cpu_present_bits), src);
 }
 void init_cpu_possible(const struct cpumask *src)
 {
-	cpumask_copy(&cpu_possible_map, src);
+	cpumask_copy(to_cpumask(cpu_possible_bits), src);
 }
 void init_cpu_online(const struct cpumask *src)
 {
-	cpumask_copy(&cpu_online_map, src);
+	cpumask_copy(to_cpumask(cpu_online_bits), src);
 }

-- 
