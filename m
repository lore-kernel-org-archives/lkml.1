Return-Path: <linux-kernel-owner+w=401wt.eu-S1762591AbYDVUnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591AbYDVUnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbYDVUmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:42:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37998 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754995AbYDVUmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:42:21 -0400
Message-Id: <20080422204220.455831000@polaris-admin.engr.sgi.com>
References: <20080422204219.994283000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:42:22 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: restore pda nodenumber field
Content-Disposition: inline; filename=restore-nodenumber
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Restore the nodenumber field in the x86_64 pda.  This field is slightly
    different than the x86_cpu_to_node_map mainly because it's a static
    indication of which node the cpu is on while the cpu to node map is a
    dyanamic mapping that may get reset if the cpu goes offline.  This also
    simplifies the numa_node_id() macro.

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup.c    |    3 +++
 include/asm-x86/pda.h      |    1 +
 include/asm-x86/topology.h |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.sched.orig/arch/x86/kernel/setup.c
+++ linux-2.6.sched/arch/x86/kernel/setup.c
@@ -155,6 +155,9 @@ void __cpuinit numa_set_node(int cpu, in
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
+	if (node != NUMA_NO_NODE)
+		cpu_pda(cpu)->nodenumber = node;
+
 	if (cpu_to_node_map)
 		cpu_to_node_map[cpu] = node;
 
--- linux-2.6.sched.orig/include/asm-x86/pda.h
+++ linux-2.6.sched/include/asm-x86/pda.h
@@ -20,6 +20,7 @@ struct x8664_pda {
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 	char *irqstackptr;
+	int nodenumber;			/* number of current node */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
--- linux-2.6.sched.orig/include/asm-x86/topology.h
+++ linux-2.6.sched/include/asm-x86/topology.h
@@ -56,7 +56,7 @@ extern cpumask_t node_to_cpumask_map[];
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
 /* Returns the number of the current Node. */
-#define numa_node_id()	(per_cpu(x86_cpu_to_node_map, raw_smp_processor_id()))
+#define numa_node_id()		read_pda(nodenumber)
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);

-- 
