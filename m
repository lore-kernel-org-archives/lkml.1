Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZJSJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZJSJTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZJSJTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:19:18 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46485 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755930AbZJSJTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:19:18 -0400
From: Robin Holt <holt@sgi.com>
Message-Id: <20091019091919.050247000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Oct 2009 04:18:55 -0500
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Martin Hicks <mort@sgi.com>
Subject: [patch 1/1] x86, UV: uv_hub_send_ipi Needs to set DELIVERY_MODE=4 for vector=NMI_VECTOR.
References: <20091019091854.696198000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=uv_fix_nmi_delivery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending a NMI_VECTOR IPI using the UV_HUB_IPI_INT register,
we need to ensure the delivery mode field of that register has NMI
delivery selected.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Cc: Martin Hicks <mort@sgi.com>

---
 arch/x86/include/asm/uv/uv_hub.h |    6 ++++++
 1 file changed, 6 insertions(+)
Index: linux-x86/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux-x86.orig/arch/x86/include/asm/uv/uv_hub.h	2009-10-19 04:07:07.000000000 -0500
+++ linux-x86/arch/x86/include/asm/uv/uv_hub.h	2009-10-19 04:07:09.000000000 -0500
@@ -19,6 +19,7 @@
 #include <asm/types.h>
 #include <asm/percpu.h>
 #include <asm/uv/uv_mmrs.h>
+#include <asm/irq_vectors.h>
 
 
 /*
@@ -435,9 +436,14 @@ static inline void uv_set_cpu_scir_bits(
 static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 {
 	unsigned long val;
+	unsigned long dmode = 0; /* Directed Delivery */
+
+	if (vector == NMI_VECTOR)
+		dmode = 4; /* NMI Delivery */
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(dmode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }

