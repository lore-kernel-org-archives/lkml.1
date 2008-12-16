Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYLPC2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYLPC2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYLPCYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:24 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50756 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022411.340518000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:20 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 11/16] x86: prepare for cpumask iterators to only go to nr_cpu_ids
Content-Disposition: inline; filename=0015-x86-prepare-for-cpumask-iterators-to-only-go-to-nr_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, futureproof

In fact, all cpumask ops will only be valid (in general) for bit
numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
places.

This is always safe: no cpu number can be >= nr_cpu_ids, and
nr_cpu_ids is initialized to NR_CPUS at boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic.c              |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 arch/x86/mm/numa_64.c               |    4 ++--
 arch/x86/mm/srat_64.c               |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index a375791..3b630ec 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -2106,7 +2106,7 @@ __cpuinit int apic_is_clustered_box(void)
 	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		/* are we being called early in kernel startup? */
 		if (bios_cpu_apicid) {
 			id = bios_cpu_apicid[i];
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 9c99018..a5bc054 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -672,7 +672,7 @@ void __init smp_boot_cpus(void)
 
 	/* loop over all the extended VIC CPUs and boot them.  The
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		if (i == boot_cpu_id || !cpu_isset(i, phys_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index cebcbf1..71a14f8 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -278,7 +278,7 @@ void __init numa_init_array(void)
 	int rr, i;
 
 	rr = first_node(node_online_map);
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		if (early_cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
 		numa_set_node(i, rr);
@@ -549,7 +549,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn)
 	memnodemap[0] = 0;
 	node_set_online(0);
 	node_set(0, node_possible_map);
-	for (i = 0; i < NR_CPUS; i++)
+	for (i = 0; i < nr_cpu_ids; i++)
 		numa_set_node(i, 0);
 	e820_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 51c0a2f..09737c8 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -382,7 +382,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		if (!node_online(i))
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		int node = early_cpu_to_node(i);
 
 		if (node == NUMA_NO_NODE)
-- 
1.6.0

-- 
