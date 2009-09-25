Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZIYWUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZIYWUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZIYWUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:20:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46565 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZIYWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:19:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=Sy2Hvey1IHx6svlBkKI4sF4PpI1Q9E4m2aolN3gT9JkXprZe0vSZJNBLUzeQcsMJv
	i1h5O9uxH4kKK+KGDKfTQ==
Date: Fri, 25 Sep 2009 15:19:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
cc: Yinghai Lu <yinghai@kernel.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ankita Garg <ankita@in.ibm.com>, Len Brown <len.brown@intel.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/4] x86: cleanup and add missing log levels for k8
Message-ID: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all printk's in arch/x86/mm/k8topology_64.c to use pr_info() or
pr_err() appropriately.

Adds log levels for messages currently lacking them.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/k8topology_64.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -91,14 +91,14 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	if (nb < 0)
 		return nb;
 
-	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb);
+	pr_info("Scanning NUMA topology in Northbridge %d\n", nb);
 
 	reg = read_pci_config(0, nb, 0, 0x60);
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
 		return -1;
 
-	printk(KERN_INFO "Number of nodes %d\n", numnodes);
+	pr_info("Number of nodes %d\n", numnodes);
 
 	memset(&nodes, 0, sizeof(nodes));
 	prevbase = 0;
@@ -111,28 +111,28 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		nodeid = limit & 7;
 		if ((base & 3) == 0) {
 			if (i < numnodes)
-				printk("Skipping disabled node %d\n", i);
+				pr_info("Skipping disabled node %d\n", i);
 			continue;
 		}
 		if (nodeid >= numnodes) {
-			printk("Ignoring excess node %d (%lx:%lx)\n", nodeid,
-			       base, limit);
+			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
+				base, limit);
 			continue;
 		}
 
 		if (!limit) {
-			printk(KERN_INFO "Skipping node entry %d (base %lx)\n",
-			       i, base);
+			pr_info("Skipping node entry %d (base %lx)\n",
+				i, base);
 			continue;
 		}
 		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			printk(KERN_ERR "Node %d using interleaving mode %lx/%lx\n",
-			       nodeid, (base>>8)&3, (limit>>8) & 3);
+			pr_err("Node %d using interleaving mode %lx/%lx\n",
+			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -1;
 		}
 		if (node_isset(nodeid, node_possible_map)) {
-			printk(KERN_INFO "Node %d already present. Skipping\n",
-			       nodeid);
+			pr_info("Node %d already present, skipping\n",
+				nodeid);
 			continue;
 		}
 
@@ -154,24 +154,24 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		if (limit > end)
 			limit = end;
 		if (limit == base) {
-			printk(KERN_ERR "Empty node %d\n", nodeid);
+			pr_err("Empty node %d\n", nodeid);
 			continue;
 		}
 		if (limit < base) {
-			printk(KERN_ERR "Node %d bogus settings %lx-%lx.\n",
+			pr_err("Node %d bogus settings %lx-%lx.\n",
 			       nodeid, base, limit);
 			continue;
 		}
 
 		/* Could sort here, but pun for now. Should not happen anyroads. */
 		if (prevbase > base) {
-			printk(KERN_ERR "Node map not sorted %lx,%lx\n",
+			pr_err("Node map not sorted %lx,%lx\n",
 			       prevbase, base);
 			return -1;
 		}
 
-		printk(KERN_INFO "Node %d MemBase %016lx Limit %016lx\n",
-		       nodeid, base, limit);
+		pr_info("Node %d MemBase %016lx Limit %016lx\n",
+			nodeid, base, limit);
 
 		found++;
 
@@ -188,10 +188,10 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 
 	memnode_shift = compute_hash_shift(nodes, 8, NULL);
 	if (memnode_shift < 0) {
-		printk(KERN_ERR "No NUMA node hash function found. Contact maintainer\n");
+		pr_err("No NUMA node hash function found. Contact maintainer\n");
 		return -1;
 	}
-	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift);
+	pr_info("Using node hash shift of %d\n", memnode_shift);
 
 	/* use the coreid bits from early_identify_cpu */
 	bits = boot_cpu_data.x86_coreid_bits;
@@ -200,8 +200,7 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	/* need to get boot_cpu_id early for system with apicid lifting */
 	early_get_boot_cpu_id();
 	if (boot_cpu_physical_apicid > 0) {
-		printk(KERN_INFO "BSP APIC ID: %02x\n",
-				 boot_cpu_physical_apicid);
+		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
