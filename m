Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbYDZARY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbYDZARY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbYDZAPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:15:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55380 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757374AbYDZAPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:50 -0400
Message-Id: <20080426001549.458477000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:51 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] x86: restore pda nodenumber field
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
 arch/x86/kernel/setup.c    |    4 ++++
 include/asm-x86/pda.h      |    1 +
 include/asm-x86/topology.h |    2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.sched.orig/arch/x86/kernel/setup.c
+++ linux-2.6.sched/arch/x86/kernel/setup.c
@@ -31,6 +31,7 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 #define	X86_64_NUMA	1
 
+/* map cpu index to node index */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 #endif
@@ -154,6 +155,9 @@ void __cpuinit numa_set_node(int cpu, in
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
