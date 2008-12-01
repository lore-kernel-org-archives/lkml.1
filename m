Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbYLAIRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbYLAIRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYLAIRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:17:42 -0500
Received: from ozlabs.org ([203.10.76.45]:58566 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYLAIRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:17:41 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:47:38 +1030
Subject: [PATCH 4/6] cpumask: switch over to cpu_online/possible/active/present_mask: core
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011847.38877.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

This implements the obsolescent cpu_online_map in terms of
cpu_online_mask, rather than the other way around.  Same for the other
maps.

The documentation comments are also updated to refer to _mask rather
than _map.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   75 ++++++++++++++++++------------------------------
 kernel/cpu.c            |   49 ++++++++++++++-----------------
 2 files changed, 52 insertions(+), 72 deletions(-)

diff -r a8a764f1893f include/linux/cpumask.h
--- a/include/linux/cpumask.h	Tue Nov 18 21:11:37 2008 +1030
+++ b/include/linux/cpumask.h	Tue Nov 18 21:15:28 2008 +1030
@@ -416,65 +416,54 @@
 
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
+ *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
+ *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
+ *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
+ *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
  *
- *  In either case, NR_CPUS is fixed at compile time, as the static
- *  size of these bitmaps.  The cpu_possible_map is fixed at boot
- *  time, as the set of CPU id's that it is possible might ever
- *  be plugged in at anytime during the life of that system boot.
- *  The cpu_present_map is dynamic(*), representing which CPUs
- *  are currently plugged in.  And cpu_online_map is the dynamic
- *  subset of cpu_present_map, indicating those CPUs available
- *  for scheduling.
+ *  If !CONFIG_HOTPLUG_CPU, present == possible, and active == online.
  *
- *  If HOTPLUG is enabled, then cpu_possible_map is forced to have
+ *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
+ *  that it is possible might ever be plugged in at anytime during the
+ *  life of that system boot.  The cpu_present_mask is dynamic(*),
+ *  representing which CPUs are currently plugged in.  And
+ *  cpu_online_mask is the dynamic subset of cpu_present_mask,
+ *  indicating those CPUs available for scheduling.
+ *
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
+
+/* These strip const, as traditionally they weren't const. */
+#define cpu_possible_map	(*(cpumask_t *)cpu_possible_mask)
+#define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
+#define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
+#define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight_nr(cpu_online_map)
@@ -1044,12 +1033,6 @@
 }
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 
-/* The pointer versions of the maps, these will become the primary versions. */
-#define cpu_possible_mask ((const struct cpumask *)&cpu_possible_map)
-#define cpu_online_mask ((const struct cpumask *)&cpu_online_map)
-#define cpu_present_mask ((const struct cpumask *)&cpu_present_map)
-#define cpu_active_mask ((const struct cpumask *)&cpu_active_map)
-
 /* It's common to want to use cpu_all_mask in struct member initializers,
  * so it has to refer to an address rather than a pointer. */
 extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
diff -r a8a764f1893f kernel/cpu.c
--- a/kernel/cpu.c	Tue Nov 18 21:11:37 2008 +1030
+++ b/kernel/cpu.c	Tue Nov 18 21:15:28 2008 +1030
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
@@ -64,8 +42,6 @@
 	mutex_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
 }
-
-cpumask_t cpu_active_map;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
@@ -97,7 +73,7 @@
 
 /*
  * The following two API's must be used when attempting
- * to serialize the updates to cpu_online_map, cpu_present_map.
+ * to serialize the updates to cpu_online_mask, cpu_present_mask.
  */
 void cpu_maps_update_begin(void)
 {
@@ -503,3 +479,24 @@
 
 const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
 EXPORT_SYMBOL(cpu_all_bits);
+
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


