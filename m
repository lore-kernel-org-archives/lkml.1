Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYAUXH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYAUXH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYAUXHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:07:37 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46025 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755455AbYAUXHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:07:36 -0500
Message-Id: <20080121230647.038245000@sgi.com>
References: <20080121230644.752379000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 15:06:45 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86: fix early cpu_to_node panic from nr_free_zone_pages
Content-Disposition: inline; filename=fix-cpu_to_node-panic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An early call to nr_free_zone_pages() calls numa_node_id() which
needs to call early_cpu_to_node() since per_cpu(cpu_to_node_map)
might not be setup yet.

I also had to export x86_cpu_to_node_map_early_ptr because of some
calls from the network code to numa_node_id():

	net/ipv4/netfilter/arp_tables.c:
	net/ipv4/netfilter/ip_tables.c:
	net/ipv4/netfilter/ip_tables.c:

Applies to both:
	
	2.6.24-rc8-mm1
	2.6.24-rc8-mm1 + latest (08/01/21) git-x86 patch

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/numa_64.c      |    2 --
 include/asm-x86/topology.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -37,9 +37,7 @@ int x86_cpu_to_node_map_init[NR_CPUS] = 
 void *x86_cpu_to_node_map_early_ptr;
 DEFINE_PER_CPU(int, x86_cpu_to_node_map) = NUMA_NO_NODE;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-#ifdef	CONFIG_DEBUG_PER_CPU_MAPS
 EXPORT_SYMBOL(x86_cpu_to_node_map_early_ptr);
-#endif
 
 s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -37,6 +37,8 @@ extern int cpu_to_node_map[];
 DECLARE_PER_CPU(int, x86_cpu_to_node_map);
 extern int x86_cpu_to_node_map_init[];
 extern void *x86_cpu_to_node_map_early_ptr;
+/* Returns the number of the current Node. */
+#define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
 #endif
 
 extern cpumask_t node_to_cpumask_map[];

-- 

