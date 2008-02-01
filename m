Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYBATO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYBATO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYBATOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:14:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47057 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754531AbYBATOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:14:17 -0500
Message-Id: <20080201191415.284635000@sgi.com>
References: <20080201191414.961558000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 01 Feb 2008 11:14:16 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] init: move setup of nr_cpu_ids to as early as possible
Content-Disposition: inline; filename=mv-set-nr_cpu_ids
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the setting of nr_cpu_ids from sched_init() to init/main.c,
so that it's available as early as possible.

Based on the linux-2.6.git + x86.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 init/main.c    |   21 +++++++++++++++++++++
 kernel/sched.c |    7 -------
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -363,10 +363,30 @@ static void __init smp_init(void)
 #endif
 
 static inline void setup_per_cpu_areas(void) { }
+static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
 #else
 
+/*
+ * Setup number of possible processor ids.
+ * This is different than setup_max_cpus as it accounts
+ * for zero bits embedded between one bits in the cpu
+ * possible map due to disabled cpu cores.
+ */
+int nr_cpu_ids __read_mostly = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
+static void __init setup_nr_cpu_ids(void)
+{
+	int cpu, highest_cpu = 0;
+
+	for_each_possible_cpu(cpu)
+		highest_cpu = cpu;
+
+	nr_cpu_ids = highest_cpu + 1;
+}
+
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 
@@ -542,6 +562,7 @@ asmlinkage void __init start_kernel(void
 	setup_arch(&command_line);
 	setup_command_line(command_line);
 	unwind_setup();
+	setup_nr_cpu_ids();
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5925,10 +5925,6 @@ void __init migration_init(void)
 
 #ifdef CONFIG_SMP
 
-/* Number of possible processor ids */
-int nr_cpu_ids __read_mostly = NR_CPUS;
-EXPORT_SYMBOL(nr_cpu_ids);
-
 #ifdef CONFIG_SCHED_DEBUG
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level)
@@ -7161,7 +7157,6 @@ static void init_tg_rt_entry(struct rq *
 
 void __init sched_init(void)
 {
-	int highest_cpu = 0;
 	int i, j;
 
 #ifdef CONFIG_SMP
@@ -7213,7 +7208,6 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
-		highest_cpu = i;
 	}
 
 	set_load_weight(&init_task);
@@ -7223,7 +7217,6 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_SMP
-	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
 #endif
 

-- 
