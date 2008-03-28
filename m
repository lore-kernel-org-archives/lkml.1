Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYC1Caq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYC1Caq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbYC1CaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:30:21 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39790 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755069AbYC1CaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:30:19 -0400
Message-Id: <20080328023018.584332000@polaris-admin.engr.sgi.com>
References: <20080328023018.264203000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 19:30:19 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] init: move setup of nr_cpu_ids to as early as possible
Content-Disposition: inline; filename=setup-nr_cpu_ids
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the setting of nr_cpu_ids from sched_init() to start_kernel()
so that it's available as early as possible.

Note that an arch has the option of setting it even earlier if need be,
but it should not result in a different value than the setup_nr_cpu_ids()
function.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 init/main.c    |   17 +++++++++++++++++
 kernel/sched.c |    7 -------
 2 files changed, 17 insertions(+), 7 deletions(-)

--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -360,10 +360,26 @@ static void __init smp_init(void)
 #endif
 
 static inline void setup_per_cpu_areas(void) { }
+static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
 #else
 
+/* Setup number of possible processor ids */
+int nr_cpu_ids __read_mostly = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
+/* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
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
 
@@ -544,6 +560,7 @@ asmlinkage void __init start_kernel(void
 	setup_command_line(command_line);
 	unwind_setup();
 	setup_per_cpu_areas();
+	setup_nr_cpu_ids();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
 	/*
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6229,10 +6229,6 @@ void __init migration_init(void)
 
 #ifdef CONFIG_SMP
 
-/* Number of possible processor ids */
-int nr_cpu_ids __read_mostly = NR_CPUS;
-EXPORT_SYMBOL(nr_cpu_ids);
-
 #ifdef CONFIG_SCHED_DEBUG
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level)
@@ -7443,7 +7439,6 @@ static void init_tg_rt_entry(struct rq *
 
 void __init sched_init(void)
 {
-	int highest_cpu = 0;
 	int i, j;
 
 #ifdef CONFIG_SMP
@@ -7505,7 +7500,6 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
-		highest_cpu = i;
 	}
 
 	set_load_weight(&init_task);
@@ -7515,7 +7509,6 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_SMP
-	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
 #endif
 

-- 
