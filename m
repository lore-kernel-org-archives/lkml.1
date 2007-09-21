Return-Path: <linux-kernel-owner+w=401wt.eu-S1764242AbXIUWc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764242AbXIUWc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762002AbXIUWcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:40434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761678AbXIUWcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:01 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: yhlu.kernel@gmail.com, clameter@sgi.com, ak@suse.de, lenb@kernel.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/50] x86_64: use core id bits for apicid_to_node initialization
Message-Id: <20070921223200.08B701479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:31:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Yinghai Lu" <yhlu.kernel@gmail.com>

We shoud use core id bits instead of max cores, in case later with AMD
downcores Quad core Opteron.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/k8topology.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/mm/k8topology.c
===================================================================
--- linux.orig/arch/x86_64/mm/k8topology.c
+++ linux/arch/x86_64/mm/k8topology.c
@@ -44,12 +44,14 @@ int __init k8_scan_nodes(unsigned long s
 { 
 	unsigned long prevbase;
 	struct bootnode nodes[8];
-	int nodeid, i, j, nb;
+	int nodeid, i, nb;
 	unsigned char nodeids[8];
 	int found = 0;
 	u32 reg;
 	unsigned numnodes;
-	unsigned num_cores;
+	unsigned cores;
+	unsigned bits;
+	int j;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -60,9 +62,6 @@ int __init k8_scan_nodes(unsigned long s
 
 	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb); 
 
-	num_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
-	printk(KERN_INFO "CPU has %d num_cores\n", num_cores);
-
 	reg = read_pci_config(0, nb, 0, 0x60); 
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
@@ -168,11 +167,15 @@ int __init k8_scan_nodes(unsigned long s
 	} 
 	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift); 
 
+	/* use the coreid bits from early_identify_cpu */
+	bits = boot_cpu_data.x86_coreid_bits;
+	cores = (1<<bits);
+
 	for (i = 0; i < 8; i++) {
 		if (nodes[i].start != nodes[i].end) { 
 			nodeid = nodeids[i];
-			for (j = 0; j < num_cores; j++)
-				apicid_to_node[(nodeid * num_cores) + j] = i;
+			for (j = 0; j < cores; j++)
+				apicid_to_node[(nodeid << bits) + j] = i;
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end); 
 		} 
 	}
