Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZAFCkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZAFCkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZAFCkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:40:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:45890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbZAFCkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:40:04 -0500
Message-ID: <4962C445.3090307@kernel.org>
Date: Mon, 05 Jan 2009 18:39:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: k8 numa register active regions later
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

don't register early, so we don't need to clear actived regions if it fail
to get node hash shift or wild set in nb config.

also remove nodeids array that is not needed

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/k8topology_64.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/mm/k8topology_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/k8topology_64.c
+++ linux-2.6/arch/x86/mm/k8topology_64.c
@@ -81,7 +81,6 @@ int __init k8_scan_nodes(unsigned long s
 	unsigned numnodes, cores, bits, apicid_base;
 	unsigned long prevbase;
 	struct bootnode nodes[8];
-	unsigned char nodeids[8];
 	int i, j, nb, found = 0;
 	u32 nodeid, reg;
 
@@ -110,7 +109,6 @@ int __init k8_scan_nodes(unsigned long s
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
 
 		nodeid = limit & 7;
-		nodeids[i] = nodeid;
 		if ((base & 3) == 0) {
 			if (i < numnodes)
 				printk("Skipping disabled node %d\n", i);
@@ -179,9 +177,6 @@ int __init k8_scan_nodes(unsigned long s
 
 		nodes[nodeid].start = base;
 		nodes[nodeid].end = limit;
-		e820_register_active_regions(nodeid,
-				nodes[nodeid].start >> PAGE_SHIFT,
-				nodes[nodeid].end >> PAGE_SHIFT);
 
 		prevbase = base;
 
@@ -211,12 +206,15 @@ int __init k8_scan_nodes(unsigned long s
 	}
 
 	for (i = 0; i < 8; i++) {
-		if (nodes[i].start != nodes[i].end) {
-			nodeid = nodeids[i];
-			for (j = apicid_base; j < cores + apicid_base; j++)
-				apicid_to_node[(nodeid << bits) + j] = i;
-			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-		}
+		if (nodes[i].start == nodes[i].end)
+			continue;
+
+		e820_register_active_regions(i,
+				nodes[i].start >> PAGE_SHIFT,
+				nodes[i].end >> PAGE_SHIFT);
+		for (j = apicid_base; j < cores + apicid_base; j++)
+			apicid_to_node[(i << bits) + j] = i;
+		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
 
 	numa_init_array();
