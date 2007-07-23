Return-Path: <linux-kernel-owner+w=401wt.eu-S935214AbXGWUUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214AbXGWUUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765541AbXGWUUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:20:13 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42706 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764344AbXGWUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:20:10 -0400
Date: Mon, 23 Jul 2007 13:09:22 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 7/10] x86_64: use core id bits for apicid_to_node initialization
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707231309.22829.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 7/10] x86_64: use core id bits for apicid_to_node initialization

We shoud use core id bits instead of max cores, in case later with AMD
downcores Quad core Opteron.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86_64/mm/k8topology.c b/arch/x86_64/mm/k8topology.c
index a96006f..7cbd58a 100644
--- a/arch/x86_64/mm/k8topology.c
+++ b/arch/x86_64/mm/k8topology.c
@@ -44,12 +44,14 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
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
@@ -60,9 +62,6 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 
 	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb); 
 
-	num_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
-	printk(KERN_INFO "CPU has %d num_cores\n", num_cores);
-
 	reg = read_pci_config(0, nb, 0, 0x60); 
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
@@ -168,11 +167,15 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
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
