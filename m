Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274Ab0ALVJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0ALVJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 16:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989Ab0ALVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 16:09:10 -0500
Received: from relay1.sgi.com ([192.48.179.29]:41254 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753766Ab0ALVJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 16:09:08 -0500
Date: Tue, 12 Jan 2010 15:09:04 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Add function retrieving node controller revision
	number
Message-ID: <20100112210904.GA24546@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function for determining the revision id of the SGI UV
node controller chip (HUB). This function is needed in a
subsequent patch.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv_hub.h   |   12 ++++++++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 ++++++
 2 files changed, 18 insertions(+)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2010-01-09 19:49:39.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2010-01-12 14:42:29.000000000 -0600
@@ -496,5 +496,17 @@ static inline void uv_hub_send_ipi(int p
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
+/*
+ * Get the minimum revision number of the hub chips within the partition.
+ *     1 - initial rev 1.0 silicon
+ *     2 - rev 2.0 production silicon
+ */
+static inline int uv_get_min_hub_revision_id(void)
+{
+	extern int uv_min_hub_revision_id;
+
+	return uv_min_hub_revision_id;
+}
+
 #endif /* CONFIG_X86_64 */
 #endif /* _ASM_X86_UV_UV_HUB_H */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-01-09 19:49:39.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-01-12 14:43:36.000000000 -0600
@@ -36,6 +36,8 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
+int uv_min_hub_revision_id;
+EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 
 static inline bool is_GRU_range(u64 start, u64 end)
 {
@@ -55,6 +57,10 @@ static int early_get_nodeid(void)
 	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
 	node_id.v = *mmr;
 	early_iounmap(mmr, sizeof(*mmr));
+
+	/* Currently, all blades have same revision number */
+	uv_min_hub_revision_id = node_id.s.revision;
+
 	return node_id.s.node_id;
 }
 
