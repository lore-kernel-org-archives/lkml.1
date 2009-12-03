Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZLCWgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZLCWgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZLCWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:36:04 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34722 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753474AbZLCWfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:35:44 -0500
Message-Id: <20091203223549.730449000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 03 Dec 2009 16:34:15 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 1/2] GRU - function to generate  chipset IPI values
References: <20091203223414.393107000@sgi.com>
Content-Disposition: inline; filename=uv_ipi_macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Create a function to generate the value that is written to the UV hub
MMR to cause an IPI interrupt to be sent. The function will be
used in the GRU message queue error recovery code that sends IPIs to
nodes in remote partitions.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv_hub.h |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-12-03 07:36:31.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-12-03 07:52:04.000000000 -0600
@@ -172,6 +172,8 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define UV_LOCAL_MMR_SIZE		(64UL * 1024 * 1024)
 #define UV_GLOBAL_MMR32_SIZE		(64UL * 1024 * 1024)
 
+#define UV_GLOBAL_GRU_MMR_BASE		0x4000000
+
 #define UV_GLOBAL_MMR32_PNODE_SHIFT	15
 #define UV_GLOBAL_MMR64_PNODE_SHIFT	26
 
@@ -308,6 +310,15 @@ static inline unsigned long uv_read_glob
 }
 
 /*
+ * Global MMR space addresses when referenced by the GRU. (GRU does
+ * NOT use socket addressing).
+ */
+static inline unsigned long uv_global_gru_mmr_address(int pnode, unsigned long offset)
+{
+	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
+}
+
+/*
  * Access hub local MMRs. Faster than using global space but only local MMRs
  * are accessible.
  */
@@ -434,6 +445,14 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
+{
+	return (1UL << UVH_IPI_INT_SEND_SHFT) |
+			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
+			(vector << UVH_IPI_INT_VECTOR_SHFT);
+}
+
 static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 {
 	unsigned long val;
@@ -442,10 +461,7 @@ static inline void uv_hub_send_ipi(int p
 	if (vector == NMI_VECTOR)
 		dmode = dest_NMI;
 
-	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
-			(dmode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
-			(vector << UVH_IPI_INT_VECTOR_SHFT);
+	val = uv_hub_ipi_value(apicid, vector, dmode);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 

