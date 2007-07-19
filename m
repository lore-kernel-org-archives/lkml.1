Return-Path: <linux-kernel-owner+w=401wt.eu-S938278AbXGSKVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938278AbXGSKVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbXGSJ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:33125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619AbXGSJzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:39 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: rientjes@google.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [46/58] x86_64: fake apicid_to_node mapping for fake numa
Message-Id: <20070719095532.D30DB14E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>

When we are in the emulated NUMA case, we need to make sure that all existing
apicid_to_node mappings that point to real node ID's now point to the
equivalent fake node ID's.

If we simply iterate over all apicid_to_node[] members for each node, we risk
remapping an entry if it shares a node ID with a real node.  Since apicid's
may not be consecutive, we're forced to create an automatic array of
apicid_to_node mappings and then copy it over once we have finished remapping
fake to real nodes.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/mm/srat.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/mm/srat.c
===================================================================
--- linux.orig/arch/x86_64/mm/srat.c
+++ linux/arch/x86_64/mm/srat.c
@@ -470,10 +470,13 @@ static int __init find_node_by_addr(unsi
  */
 void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 {
-	int i;
+	int i, j;
 	int fake_node_to_pxm_map[MAX_NUMNODES] = {
 		[0 ... MAX_NUMNODES-1] = PXM_INVAL
 	};
+	unsigned char fake_apicid_to_node[MAX_LOCAL_APIC] = {
+		[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
+	};
 
 	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
 			 "topology.\n");
@@ -487,9 +490,17 @@ void __init acpi_fake_nodes(const struct
 		if (pxm == PXM_INVAL)
 			continue;
 		fake_node_to_pxm_map[i] = pxm;
+		/*
+		 * For each apicid_to_node mapping that exists for this real
+		 * node, it must now point to the fake node ID.
+		 */
+		for (j = 0; j < MAX_LOCAL_APIC; j++)
+			if (apicid_to_node[j] == nid)
+				fake_apicid_to_node[j] = i;
 	}
 	for (i = 0; i < num_nodes; i++)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
+	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
 
 	nodes_clear(nodes_parsed);
 	for (i = 0; i < num_nodes; i++)
