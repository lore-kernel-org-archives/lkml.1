Return-Path: <linux-kernel-owner+w=401wt.eu-S934433AbZARQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbZARQmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762531AbZARQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:55228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761618AbZARQjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:40 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/12] x86-64: Move nodenumber from PDA to per-cpu.
Date: Mon, 19 Jan 2009 01:39:17 +0900
Message-Id: <1232296759-2253-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

tj: * s/nodenumber/node_number/
    * removed now unused pda variable from pda_init()

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h      |    1 -
 arch/x86/include/asm/topology.h |    3 ++-
 arch/x86/kernel/cpu/common.c    |   13 ++++++-------
 arch/x86/kernel/setup_percpu.c  |    4 +++-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 4527d70..b30ef6b 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -22,7 +22,6 @@ struct x8664_pda {
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 #endif
-	short nodenumber;		/* number of current node (32k max) */
 	short in_bootmem;		/* pda lives in bootmem */
 	short isidle;
 } ____cacheline_aligned_in_smp;
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 87ca3fd..ffea1fe 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -83,7 +83,8 @@ extern cpumask_t *node_to_cpumask_map;
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
 /* Returns the number of the current Node. */
-#define numa_node_id()		read_pda(nodenumber)
+DECLARE_PER_CPU(int, node_number);
+#define numa_node_id()		percpu_read(node_number)
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2323ec..7976a6a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -897,18 +897,11 @@ DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
 void __cpuinit pda_init(int cpu)
 {
-	struct x8664_pda *pda = cpu_pda(cpu);
-
 	/* Setup up data that may be needed in __get_free_pages early */
 	loadsegment(fs, 0);
 	loadsegment(gs, 0);
 
 	load_pda_offset(cpu);
-
-	if (cpu != 0) {
-		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
-			pda->nodenumber = cpu_to_node(cpu);
-	}
 }
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
@@ -978,6 +971,12 @@ void __cpuinit cpu_init(void)
 	if (cpu != 0)
 		pda_init(cpu);
 
+#ifdef CONFIG_NUMA
+	if (cpu != 0 && percpu_read(node_number) == 0 &&
+	    cpu_to_node(cpu) != NUMA_NO_NODE)
+		percpu_write(node_number, cpu_to_node(cpu));
+#endif
+
 	me = current;
 
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 258497f..efbafbb 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -53,6 +53,8 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 #define	X86_64_NUMA	1	/* (used later) */
+DEFINE_PER_CPU(int, node_number) = 0;
+EXPORT_PER_CPU_SYMBOL(node_number);
 
 /*
  * Map cpu index to node index
@@ -283,7 +285,7 @@ void __cpuinit numa_set_node(int cpu, int node)
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
 	if (node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
+		per_cpu(node_number, cpu) = node;
 }
 
 void __cpuinit numa_clear_node(int cpu)
-- 
1.6.0.2

