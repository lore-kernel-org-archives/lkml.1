Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbYJWCR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbYJWCR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbYJWCIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43357 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754767AbYJWCIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:32 -0400
Message-Id: <20081023020832.289991000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:56 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 30/35] cpumask: cpu_all_mask and cpu_none_mask. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cpu_all_mask-and-cpu_none_mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of CPU_MASK_ALL_PTR and the SMP-only cpu_mask_all, this makes
cpu_all_mask and cpu_none_mask which are const cpumask pointers which
always exist.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   16 ++++++++++------
 init/main.c             |    7 +------
 kernel/cpu.c            |    3 +++
 kernel/kmod.c           |    2 +-
 kernel/kthread.c        |    4 ++--
 kernel/sched.c          |    2 +-
 6 files changed, 18 insertions(+), 16 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -116,6 +116,7 @@ struct cpumask {
 typedef struct cpumask cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;
 
+#define CPU_MASK_ALL_PTR	(cpu_all_mask)
 #define CPU_MASK_ALL		((cpumask_t){ CPU_BITS_ALL })
 #define CPU_MASK_NONE		((cpumask_t){ CPU_BITS_NONE })
 #define CPU_MASK_CPU0		((cpumask_t){ CPU_BITS_CPU0 })
@@ -174,6 +175,7 @@ extern cpumask_t _unused_cpumask_arg_;
 #define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
 #define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
 #define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
+#define cpu_mask_all		(*(cpumask_t *)cpu_all_mask)
 /* End deprecated region. */
 
 #if NR_CPUS > 1
@@ -414,8 +416,6 @@ static inline const struct cpumask *cpum
 	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
 }
 
-#define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
-
 #else
 
 #define CPU_BITS_ALL						\
@@ -424,10 +424,6 @@ static inline const struct cpumask *cpum
 	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
 }
 
-/* cpu_mask_all is in init/main.c */
-extern cpumask_t cpu_mask_all;
-#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
-
 #endif
 
 #define CPU_BITS_NONE						\
@@ -560,6 +556,14 @@ extern const struct cpumask *const cpu_o
 extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
 
+/* It's common to want to use cpu_all_mask in struct member initializers,
+ * so it has to refer to an address rather than a pointer. */
+extern const DECLARE_BITMAP(cpu_all_bits, CONFIG_NR_CPUS);
+#define cpu_all_mask to_cpumask(cpu_all_bits)
+
+/* First bits of cpu_bit_bitmap are in fact unset. */
+#define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
+
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
 #define num_possible_cpus()	cpus_weight(cpu_possible_map)
--- linux-2.6.28.orig/init/main.c
+++ linux-2.6.28/init/main.c
@@ -368,11 +368,6 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
-#if NR_CPUS > BITS_PER_LONG
-cpumask_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_mask_all);
-#endif
-
 /* Setup number of possible processor ids */
 /* nr_cpu_ids is a real variable for SMP. */
 #ifndef nr_cpu_ids
@@ -863,7 +858,7 @@ static int __init kernel_init(void * unu
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.
--- linux-2.6.28.orig/kernel/cpu.c
+++ linux-2.6.28/kernel/cpu.c
@@ -498,6 +498,9 @@ static DECLARE_BITMAP(cpu_active_bits, C
 const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
 EXPORT_SYMBOL(cpu_active_mask);
 
+const DECLARE_BITMAP(cpu_all_bits, CONFIG_NR_CPUS) = CPU_BITS_ALL;
+EXPORT_SYMBOL(cpu_all_bits);
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
--- linux-2.6.28.orig/kernel/kmod.c
+++ linux-2.6.28/kernel/kmod.c
@@ -166,7 +166,7 @@ static int ____call_usermodehelper(void 
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
--- linux-2.6.28.orig/kernel/kthread.c
+++ linux-2.6.28/kernel/kthread.c
@@ -107,7 +107,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
+		set_cpus_allowed_ptr(create->result, cpu_all_mask);
 	}
 	complete(&create->done);
 }
@@ -237,7 +237,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
--- linux-2.6.28.orig/kernel/sched.c
+++ linux-2.6.28/kernel/sched.c
@@ -6167,7 +6167,7 @@ static void move_task_off_dead_cpu(int d
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(any_online_cpu(*CPU_MASK_ALL_PTR));
+	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_online_mask));
 	unsigned long flags;
 
 	local_irq_save(flags);

-- 
