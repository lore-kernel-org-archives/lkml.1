Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbZDQUrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbZDQUrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbZDQUqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:46:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbZDQUqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:46:36 -0400
Date: Fri, 17 Apr 2009 20:45:42 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <20090417142242.GA23743@sgi.com>
References: <20090417142242.GA23743@sgi.com>
Subject: [tip:x86/urgent] x86/uv: fix init of memory-less nodes
Message-ID: <tip-dc098551918093901d8ac8936e9d1a1b891b56ed@git.kernel.org>
Git-Commit-ID: dc098551918093901d8ac8936e9d1a1b891b56ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 20:45:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc098551918093901d8ac8936e9d1a1b891b56ed
Gitweb:     http://git.kernel.org/tip/dc098551918093901d8ac8936e9d1a1b891b56ed
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Fri, 17 Apr 2009 09:22:42 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 22:42:12 +0200

x86/uv: fix init of memory-less nodes

Add support for nodes that have cpus but no memory.
The current code was failing to add these nodes
to the nodes_present_map.

v2: Fixes case caught by David Rientjes - missed support
    for the x2apic SRAT table.

[ Impact: fix potential boot crash on memory-less UV nodes. ]

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090417142242.GA23743@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/srat_64.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index c7d272b..33c5fa5 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -28,6 +28,7 @@ int acpi_numa __initdata;
 static struct acpi_table_slit *acpi_slit;
 
 static nodemask_t nodes_parsed __initdata;
+static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
@@ -141,6 +142,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 
 	apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
+	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
 	       pxm, apic_id, node);
@@ -174,6 +176,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	else
 		apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
+	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
 	       pxm, apic_id, node);
@@ -402,7 +405,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
-	node_possible_map = nodes_parsed;
+	/* Account for nodes with cpus and no memory */
+	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
 	/* Finally register nodes */
 	for_each_node_mask(i, node_possible_map)
