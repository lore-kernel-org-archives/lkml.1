Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbXEGO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbXEGO2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934138AbXEGO2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:28:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136AbXEGO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:28:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=od5RZU5RohgudHPN+AYyc0JiP1AfXblm/5U7NS6yhuqqOXM6qCj+twioyZjBHkY/b
	DWlXmISu6Q27ut4Y1umpQ==
Date: Mon, 7 May 2007 07:28:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [2.6.22 patch 1/4] x86_64: rename and export bad_srat to kernel code
Message-ID: <Pine.LNX.4.64.0705061703060.27058@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rename bad_srat() to disable_srat() and include it in asm-x86_64/numa.h so 
that it can be referenced from generic x86-64 boot code.  It's needed for 
NUMA emulation disabling of active SRAT regions and apicid_to_node[]
population.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/mm/srat.c     |   16 ++++++++--------
 include/asm-x86_64/numa.h |    6 ++++++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -74,7 +74,7 @@ static __init void cutoff_node(int i, unsigned long start, unsigned long end)
 	}
 }
 
-static __init void bad_srat(void)
+void __init disable_srat(void)
 {
 	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
@@ -133,7 +133,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	if (srat_disabled())
 		return;
 	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
@@ -142,7 +142,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	apicid_to_node[pa->apic_id] = node;
@@ -289,7 +289,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	if (srat_disabled())
 		return;
 	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
@@ -303,7 +303,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	i = conflicting_nodes(start, end);
@@ -316,7 +316,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		       "SRAT: PXM %d (%lx-%lx) overlaps with PXM %d (%Lx-%Lx)\n",
 		       pxm, start, end, node_to_pxm(i),
 			nodes[i].start, nodes[i].end);
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	nd = &nodes[node];
@@ -407,7 +407,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 
 	if (!nodes_cover_memory()) {
-		bad_srat();
+		disable_srat();
 		return -1;
 	}
 
@@ -415,7 +415,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	if (memnode_shift < 0) {
 		printk(KERN_ERR
 		     "SRAT: No NUMA node hash function found. Contact maintainer\n");
-		bad_srat();
+		disable_srat();
 		return -1;
 	}
 
diff --git a/include/asm-x86_64/numa.h b/include/asm-x86_64/numa.h
--- a/include/asm-x86_64/numa.h
+++ b/include/asm-x86_64/numa.h
@@ -33,6 +33,12 @@ static inline void clear_node_cpumask(int cpu)
 #define clear_node_cpumask(cpu) do {} while (0)
 #endif
 
+#ifdef CONFIG_ACPI_NUMA
+extern void __init disable_srat(void);
+#else
+#define disable_srat()	do {} while (0)
+#endif
+
 #define NUMA_NO_NODE 0xff
 
 #endif
