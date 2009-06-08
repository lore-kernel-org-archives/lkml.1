Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZFHRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZFHRBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZFHRBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:01:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbZFHRBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:01:34 -0400
Date: Mon, 8 Jun 2009 17:00:36 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090608154405.GA16395@sgi.com>
References: <20090608154405.GA16395@sgi.com>
Subject: [tip:x86/urgent] x86, UV: Fix macros for multiple coherency domains
Message-ID: <tip-c4ed3f04ba9defe22aa729d1646f970f791c03d7@git.kernel.org>
Git-Commit-ID: c4ed3f04ba9defe22aa729d1646f970f791c03d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Jun 2009 17:00:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4ed3f04ba9defe22aa729d1646f970f791c03d7
Gitweb:     http://git.kernel.org/tip/c4ed3f04ba9defe22aa729d1646f970f791c03d7
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 8 Jun 2009 10:44:05 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Jun 2009 18:57:47 +0200

x86, UV: Fix macros for multiple coherency domains

Fix bug in the SGI UV macros that support systems with multiple
coherency domains.  The macros used for referencing global MMR
(chipset registers) are failing to correctly "or" the NASID
(node identifier) bits that reside above M+N. These high bits
are supplied automatically by the chipset for memory accesses
coming from the processor socket.

However, the bits must be present for references to the special
global MMR space used to map chipset registers. (See uv_hub.h
for more details ...)

The bug results in references to invalid/incorrect nodes.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: <stable@kernel.org>
LKML-Reference: <20090608154405.GA16395@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_hub.h   |    6 ++++--
 arch/x86/kernel/apic/x2apic_uv_x.c |   15 +++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index d3a98ea..341070f 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -133,6 +133,7 @@ struct uv_scir_s {
 struct uv_hub_info_s {
 	unsigned long		global_mmr_base;
 	unsigned long		gpa_mask;
+	unsigned int		gnode_extra;
 	unsigned long		gnode_upper;
 	unsigned long		lowmem_remap_top;
 	unsigned long		lowmem_remap_base;
@@ -159,7 +160,8 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
  * 		p -  PNODE (local part of nsids, right shifted 1)
  */
 #define UV_NASID_TO_PNODE(n)		(((n) >> 1) & uv_hub_info->pnode_mask)
-#define UV_PNODE_TO_NASID(p)		(((p) << 1) | uv_hub_info->gnode_upper)
+#define UV_PNODE_TO_GNODE(p)		((p) |uv_hub_info->gnode_extra)
+#define UV_PNODE_TO_NASID(p)		(UV_PNODE_TO_GNODE(p) << 1)
 
 #define UV_LOCAL_MMR_BASE		0xf4000000UL
 #define UV_GLOBAL_MMR32_BASE		0xf8000000UL
@@ -173,7 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define UV_GLOBAL_MMR32_PNODE_BITS(p)	((p) << (UV_GLOBAL_MMR32_PNODE_SHIFT))
 
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
-	((unsigned long)(p) << UV_GLOBAL_MMR64_PNODE_SHIFT)
+	((unsigned long)(UV_PNODE_TO_GNODE(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
 #define UV_APIC_PNODE_SHIFT	6
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2bda693..39f2af4 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -562,7 +562,7 @@ void __init uv_system_init(void)
 	union uvh_node_id_u node_id;
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
 	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
-	int max_pnode = 0;
+	int gnode_extra, max_pnode = 0;
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
 
@@ -574,6 +574,13 @@ void __init uv_system_init(void)
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
+	pnode_mask = (1 << n_val) - 1;
+	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
+	gnode_extra = (node_id.s.node_id & ~((1 << n_val) - 1)) >> 1;
+	gnode_upper = ((unsigned long)gnode_extra  << m_val);
+	printk(KERN_DEBUG "UV: N %d, M %d, gnode_upper 0x%lx, gnode_extra 0x%x\n",
+			n_val, m_val, gnode_upper, gnode_extra);
+
 	printk(KERN_DEBUG "UV: global MMR base 0x%lx\n", mmr_base);
 
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
@@ -607,11 +614,6 @@ void __init uv_system_init(void)
 		}
 	}
 
-	pnode_mask = (1 << n_val) - 1;
-	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
-	gnode_upper = (((unsigned long)node_id.s.node_id) &
-		       ~((1 << n_val) - 1)) << m_val;
-
 	uv_bios_init();
 	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
 			    &sn_coherency_id, &sn_region_size);
@@ -634,6 +636,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
+		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = sn_coherency_id;
 		uv_cpu_hub_info(cpu)->scir.offset = SCIR_LOCAL_MMR_BASE + lcpu;
