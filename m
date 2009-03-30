Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZC3OB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZC3OB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZC3OBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:01:18 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49056 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752386AbZC3OBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:01:17 -0400
Date: Mon, 30 Mar 2009 09:01:11 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Fix for nodes with memory and no cpus
Message-ID: <20090330140111.GA18461@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix initialization of UV blade information for systems that have
nodes with memory but no cpus.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-03-30 01:54:51.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-03-30 08:46:49.000000000 -0500
@@ -555,7 +555,8 @@ void __init uv_system_init(void)
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
 	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
 	int max_pnode = 0;
-	unsigned long mmr_base, present;
+	unsigned long mmr_base, present, paddr;
+	unsigned short pnode_mask;
 
 	map_low_mmrs();
 
@@ -598,6 +599,7 @@ void __init uv_system_init(void)
 		}
 	}
 
+	pnode_mask = (1 << n_val) - 1;
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
@@ -621,7 +623,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
 		uv_cpu_hub_info(cpu)->pnode = pnode;
-		uv_cpu_hub_info(cpu)->pnode_mask = (1 << n_val) - 1;
+		uv_cpu_hub_info(cpu)->pnode_mask =pnode_mask;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
@@ -637,6 +639,16 @@ void __init uv_system_init(void)
 			lcpu, blade);
 	}
 
+	/* Add blade/pnode info for nodes without cpus */
+	for_each_online_node(nid) {
+		if (uv_node_to_blade[nid] >= 0)
+			continue;
+		paddr = node_start_pfn(nid) << PAGE_SHIFT;
+		pnode = (paddr >> m_val) & pnode_mask;
+		blade = boot_pnode_to_blade(pnode);
+		uv_node_to_blade[nid] = blade;
+	}
+
 	map_gru_high(max_pnode);
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
