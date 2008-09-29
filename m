Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYI2SG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYI2SG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYI2SDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54318 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752007AbYI2SCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:52 -0400
Message-Id: <20080929180251.772803000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:02 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/31] cpumask: remove CPU_MASK_ALL_PTR
Content-Disposition: inline; filename=CPU_MASK_ALL_PTR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    4 ++--
 include/asm-generic/topology.h          |    2 +-
 init/main.c                             |    2 +-
 kernel/kmod.c                           |    2 +-
 kernel/kthread.c                        |    4 ++--
 kernel/sched.c                          |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ struct-cpumasks/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -512,9 +512,9 @@ static __cpuinit int threshold_create_ba
 		goto out_free;
 
 #ifndef CONFIG_SMP
-	b->cpus = CPU_MASK_ALL;
+	cpus_copy(b->cpus, CPU_MASK_ALL);
 #else
-	b->cpus = per_cpu(cpu_core_map, cpu);
+	cpus_copy(b->cpus, per_cpu(cpu_core_map, cpu));
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
--- struct-cpumasks.orig/include/asm-generic/topology.h
+++ struct-cpumasks/include/asm-generic/topology.h
@@ -49,7 +49,7 @@
 
 #ifndef pcibus_to_cpumask
 #define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
+					cpu_mask_all : \
 					node_to_cpumask(pcibus_to_node(bus)) \
 				)
 #endif
--- struct-cpumasks.orig/init/main.c
+++ struct-cpumasks/init/main.c
@@ -937,7 +937,7 @@ static int __init kernel_init(void * unu
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed(current, cpu_mask_all);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.
--- struct-cpumasks.orig/kernel/kmod.c
+++ struct-cpumasks/kernel/kmod.c
@@ -166,7 +166,7 @@ static int ____call_usermodehelper(void 
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed(current, cpu_mask_all);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
--- struct-cpumasks.orig/kernel/kthread.c
+++ struct-cpumasks/kernel/kthread.c
@@ -107,7 +107,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed(create->result, CPU_MASK_ALL_PTR);
+		set_cpus_allowed(create->result, cpu_mask_all);
 	}
 	complete(&create->done);
 }
@@ -238,7 +238,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed(tsk, CPU_MASK_ALL_PTR);
+	set_cpus_allowed(tsk, cpu_mask_all);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
--- struct-cpumasks.orig/kernel/sched.c
+++ struct-cpumasks/kernel/sched.c
@@ -6195,7 +6195,7 @@ static void move_task_off_dead_cpu(int d
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(any_online_cpu(*CPU_MASK_ALL_PTR));
+	struct rq *rq_dest = cpu_rq(any_online_cpu(cpu_mask_all));
 	unsigned long flags;
 
 	local_irq_save(flags);

-- 
