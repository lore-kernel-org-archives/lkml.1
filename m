Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZDQU27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZDQU27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDQU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:28:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35234 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751445AbZDQU2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:28:49 -0400
Date: Fri, 17 Apr 2009 15:28:45 -0500
From: Jack Steiner <steiner@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/uv: fix init of memory-less nodes
Message-ID: <20090417202845.GA19532@sgi.com>
References: <20090417142242.GA23743@sgi.com> <tip-28468050e2f5410c04fd737c922f2bea73ddd690@git.kernel.org> <alpine.DEB.2.00.0904171129310.16240@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904171129310.16240@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/uv: fix init of memory-less nodes

Add support for nodes that have cpus but no memory.
The current code was failing to add these nodes
to the nodes_present_map.

[ Impact: fix potential boot crash on memory-less nodes. ]

Signed-off-by: Jack Steiner <steiner@sgi.com>



---

Fixes case caught by David - missed support for the x2apic SRAT table.



 arch/x86/mm/srat_64.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/srat_64.c
===================================================================
--- linux.orig/arch/x86/mm/srat_64.c	2009-04-17 15:12:13.000000000 -0500
+++ linux/arch/x86/mm/srat_64.c	2009-04-17 15:15:15.000000000 -0500
@@ -28,6 +28,7 @@ int acpi_numa __initdata;
 static struct acpi_table_slit *acpi_slit;
 
 static nodemask_t nodes_parsed __initdata;
+static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
@@ -141,6 +142,7 @@ acpi_numa_x2apic_affinity_init(struct ac
 
 	apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
+	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
 	       pxm, apic_id, node);
@@ -174,6 +176,7 @@ acpi_numa_processor_affinity_init(struct
 	else
 		apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
+	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
 	       pxm, apic_id, node);
@@ -402,7 +405,8 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
-	node_possible_map = nodes_parsed;
+	/* Account for nodes with cpus and no memory */
+	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
 	/* Finally register nodes */
 	for_each_node_mask(i, node_possible_map)
