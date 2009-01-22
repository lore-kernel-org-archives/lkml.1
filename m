Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbZAVRw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbZAVRw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760099AbZAVRua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:30 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39031 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758579AbZAVRu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:27 -0500
Message-Id: <20090122175026.265884000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:20 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 03/14] Add macros for using the UV hub to send interrupts
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_send_ipi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add macros for using the UV hub to send interrupts. Change the IPI
code to use these macros. These macros will also be used in additional
patches that will follow.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/ia64/include/asm/uv/uv_hub.h |    6 ++++++
 arch/x86/include/asm/uv/uv_hub.h  |   12 ++++++++++++
 arch/x86/kernel/genx2apic_uv_x.c  |    9 ++-------
 3 files changed, 20 insertions(+), 7 deletions(-)

Index: linux/arch/ia64/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/ia64/include/asm/uv/uv_hub.h	2009-01-11 07:28:11.000000000 -0600
+++ linux/arch/ia64/include/asm/uv/uv_hub.h	2009-01-11 07:28:36.000000000 -0600
@@ -305,5 +305,11 @@ static inline int uv_num_possible_blades
 	return 1;
 }
 
+static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
+{
+	/* not currently needed on ia64 */
+}
+
+
 #endif /* __ASM_IA64_UV_HUB__ */
 
Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-01-11 07:28:11.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-01-11 07:28:36.000000000 -0600
@@ -16,6 +16,7 @@
 #include <linux/timer.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
+#include <asm/uv/uv_mmrs.h>
 
 
 /*
@@ -401,4 +402,15 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
+{
+	unsigned long val;
+
+	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
+			((apicid & 0x3f) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(vector << UVH_IPI_INT_VECTOR_SHFT);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
+}
+
+
 #endif /* _ASM_X86_UV_UV_HUB_H */
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2009-01-11 07:28:11.000000000 -0600
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2009-01-11 07:28:36.000000000 -0600
@@ -113,17 +113,12 @@ int uv_wakeup_secondary(int phys_apicid,
 
 static void uv_send_IPI_one(int cpu, int vector)
 {
-	unsigned long val, apicid, lapicid;
+	unsigned long apicid;
 	int pnode;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
-	lapicid = apicid & 0x3f;		/* ZZZ macro needed */
 	pnode = uv_apicid_to_pnode(apicid);
-	val =
-	    (1UL << UVH_IPI_INT_SEND_SHFT) | (lapicid <<
-					      UVH_IPI_INT_APIC_ID_SHFT) |
-	    (vector << UVH_IPI_INT_VECTOR_SHFT);
-	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
+	uv_hub_send_ipi(pnode, apicid, vector);
 }
 
 static void uv_send_IPI_mask(const struct cpumask *mask, int vector)

