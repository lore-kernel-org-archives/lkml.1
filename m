Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYHSRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYHSRv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYHSRvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:51:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbYHSRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:51:18 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] SGI UV: hardcode the TLB flush interrupt system vector
Message-Id: <E1KVVN9-0006fS-4Z@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 19 Aug 2008 12:51:59 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

The UV TLB shootdown mechanism needs a system interrupt vector.

Its vector had been hardcoded as 200, but needs to moved to the reserved
system vector range so that it does not collide with some device vector.

This is still temporary until dynamic system IRQ allocation is provided.
But it will be needed when real UV hardware becomes available and runs 2.6.27.

Diffed against 2.6.27-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c      |    3 ++-
 include/asm-x86/irq_vectors.h |    1 +
 include/asm-x86/uv/uv_bau.h   |    5 -----
 3 files changed, 3 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -18,6 +18,7 @@
 #include <asm/genapic.h>
 #include <asm/idle.h>
 #include <asm/tsc.h>
+#include <asm/irq_vectors.h>
 
 #include <mach_apic.h>
 
@@ -786,7 +787,7 @@ static int __init uv_bau_init(void)
 		uv_init_blade(blade, node, cur_cpu);
 		cur_cpu += uv_blade_nr_possible_cpus(blade);
 	}
-	set_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
+	alloc_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
 	uv_enable_timeouts();
 
 	return 0;
Index: linux/include/asm-x86/irq_vectors.h
===================================================================
--- linux.orig/include/asm-x86/irq_vectors.h
+++ linux/include/asm-x86/irq_vectors.h
@@ -76,6 +76,7 @@
 #define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR		0xfa
 #define THRESHOLD_APIC_VECTOR		0xf9
+#define UV_BAU_MESSAGE			0xf8
 #define INVALIDATE_TLB_VECTOR_END	0xf7
 #define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
 
Index: linux/include/asm-x86/uv/uv_bau.h
===================================================================
--- linux.orig/include/asm-x86/uv/uv_bau.h
+++ linux/include/asm-x86/uv/uv_bau.h
@@ -40,11 +40,6 @@
 #define UV_ACTIVATION_DESCRIPTOR_SIZE	32
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
-#define UV_BAU_MESSAGE			200
-/*
- * Messaging irq; see irq_64.h and include/asm-x86/hw_irq_64.h
- * To be dynamically allocated in the future
- */
 #define UV_NET_ENDPOINT_INTD		0x38
 #define UV_DESC_BASE_PNODE_SHIFT	49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
