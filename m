Return-Path: <linux-kernel-owner+w=401wt.eu-S939129AbXGSOGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939129AbXGSOGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbXGSNtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760451AbXGSNtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:09 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: joachim.deguara@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [37/48] x86_64: make k8topology multi-core aware
Message-Id: <20070719134907.E40C514E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Joachim Deguara" <joachim.deguara@amd.com>

This makes k8topology multicore aware instead of limited to signle- and 
dual-core CPUs.  It uses the CPUID to be more future proof.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>

--
---
 arch/x86_64/mm/k8topology.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/arch/x86_64/mm/k8topology.c
===================================================================
--- linux.orig/arch/x86_64/mm/k8topology.c
+++ linux/arch/x86_64/mm/k8topology.c
@@ -48,12 +48,12 @@ int __init k8_scan_nodes(unsigned long s
 { 
 	unsigned long prevbase;
 	struct bootnode nodes[8];
-	int nodeid, i, nb; 
+	int nodeid, i, j, nb;
 	unsigned char nodeids[8];
 	int found = 0;
 	u32 reg;
 	unsigned numnodes;
-	unsigned dualcore = 0;
+	unsigned num_cores;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -64,6 +64,9 @@ int __init k8_scan_nodes(unsigned long s
 
 	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb); 
 
+	num_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
+	printk(KERN_INFO "CPU has %d num_cores\n", num_cores);
+
 	reg = read_pci_config(0, nb, 0, 0x60); 
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
@@ -77,8 +80,6 @@ int __init k8_scan_nodes(unsigned long s
 		unsigned long base,limit; 
 		u32 nodeid;
 		
-		/* Undefined before E stepping, but hopefully 0 */
-		dualcore |= ((read_pci_config(0, nb, 3, 0xe8) >> 12) & 3) == 1;
 		base = read_pci_config(0, nb, 1, 0x40 + i*8);
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
 
@@ -174,8 +175,8 @@ int __init k8_scan_nodes(unsigned long s
 	for (i = 0; i < 8; i++) {
 		if (nodes[i].start != nodes[i].end) { 
 			nodeid = nodeids[i];
-			apicid_to_node[nodeid << dualcore] = i;
-			apicid_to_node[(nodeid << dualcore) + dualcore] = i;
+			for (j = 0; j < num_cores; j++)
+				apicid_to_node[(nodeid * num_cores) + j] = i;
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end); 
 		} 
 	}
