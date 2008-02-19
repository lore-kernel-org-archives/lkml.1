Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbYBSX2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbYBSX2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYBSX1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:27:54 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65343 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYBSX1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:27:53 -0500
Date: Tue, 19 Feb 2008 15:35:54 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: not set node to cpu_to_node if the node is not online
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802191535.54686.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


numa_init_array will set round-bin to all cpu to online nodes.
init_cpu_to_node will use cpu->apic (from MADT or mptable) and
apic->node(from SRAT or AMD config space with k8_bus_64.c) to have cpu->node mapping.
and later identify_cpu will overwrite them again...(with nearby_node...)

this patch will check if the node is online, otherwise will not update cpu_node map.
so keep cpu_node map to online node before identify_cpu..., to prevent possible  error.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -622,13 +622,17 @@ void __init init_cpu_to_node(void)
 	int i;
 
 	for (i = 0; i < NR_CPUS; i++) {
+		int node;
 		u16 apicid = x86_cpu_to_apicid_init[i];
 
 		if (apicid == BAD_APICID)
 			continue;
-		if (apicid_to_node[apicid] == NUMA_NO_NODE)
+		node = apicid_to_node[apicid];
+		if (node == NUMA_NO_NODE)
 			continue;
-		numa_set_node(i, apicid_to_node[apicid]);
+		if (!node_online(node))
+			continue;
+		numa_set_node(i, node);
 	}
 }
 
