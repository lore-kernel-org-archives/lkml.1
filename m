Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbZDQOWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbZDQOWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761073AbZDQOWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:22:45 -0400
Received: from relay3.sgi.com ([192.48.156.57]:41682 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761094AbZDQOWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:22:45 -0400
Date: Fri, 17 Apr 2009 09:22:42 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Memoryless nodes
Message-ID: <20090417142242.GA23743@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for nodes that have cpus but no memory.
The current code was failing to add these nodes
to the nodes_present_map.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/tlb_uv.c |   12 +++++++++++-
 arch/x86/mm/srat_64.c    |    5 ++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/srat_64.c
===================================================================
--- linux.orig/arch/x86/mm/srat_64.c	2009-04-12 10:38:26.000000000 -0500
+++ linux/arch/x86/mm/srat_64.c	2009-04-12 10:38:47.000000000 -0500
@@ -28,6 +28,7 @@ int acpi_numa __initdata;
 static struct acpi_table_slit *acpi_slit;
 
 static nodemask_t nodes_parsed __initdata;
+static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
@@ -174,6 +175,7 @@ acpi_numa_processor_affinity_init(struct
 	else
 		apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
+	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
 	       pxm, apic_id, node);
@@ -402,7 +404,8 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
-	node_possible_map = nodes_parsed;
+	/* Account for nodes with cpus and no memory */
+	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
 	/* Finally register nodes */
 	for_each_node_mask(i, node_possible_map)
