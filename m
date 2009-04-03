Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbZDCRw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbZDCRw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbZDCRwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:52:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:49307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZDCRwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:52:16 -0400
Date: Fri, 3 Apr 2009 17:51:46 GMT
From: Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330140111.GA18461@sgi.com>
References: <20090330140111.GA18461@sgi.com>
Subject: [tip:x86/uv] x86, UV: Fix for nodes with memory and no cpus
Message-ID: <tip-6a891a24e4d0056c365a90ff2d71c38fd366b0d0@git.kernel.org>
Git-Commit-ID: 6a891a24e4d0056c365a90ff2d71c38fd366b0d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 17:51:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a891a24e4d0056c365a90ff2d71c38fd366b0d0
Gitweb:     http://git.kernel.org/tip/6a891a24e4d0056c365a90ff2d71c38fd366b0d0
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 30 Mar 2009 09:01:11 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 19:49:58 +0200

x86, UV: Fix for nodes with memory and no cpus

Fix initialization of UV blade information for systems that have
nodes with memory but no cpus.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090330140111.GA18461@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 1248318..de1a50a 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -549,7 +549,8 @@ void __init uv_system_init(void)
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
 	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
 	int max_pnode = 0;
-	unsigned long mmr_base, present;
+	unsigned long mmr_base, present, paddr;
+	unsigned short pnode_mask;
 
 	map_low_mmrs();
 
@@ -592,6 +593,7 @@ void __init uv_system_init(void)
 		}
 	}
 
+	pnode_mask = (1 << n_val) - 1;
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
@@ -615,7 +617,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
 		uv_cpu_hub_info(cpu)->pnode = pnode;
-		uv_cpu_hub_info(cpu)->pnode_mask = (1 << n_val) - 1;
+		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
@@ -631,6 +633,16 @@ void __init uv_system_init(void)
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
