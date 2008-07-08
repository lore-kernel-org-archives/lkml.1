Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYGHUBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYGHUBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYGHUBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:01:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:32946 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754035AbYGHUBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:01:35 -0400
To: mingo@elte.hu
Subject: [PATCH] SGI UV: TLB shootdown extended apic mode
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KGJNb-0003qF-5E@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 08 Jul 2008 15:01:39 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

Set or clear the UV hub's extended apic mode based on the kernel's setting.
This cannot be done safely in the prom, as the kernel may set the mode.

The kernel's setting of extended apic mode is indicated by global "x2apic".

Diffed against 2.6.26-rc9 (Ingo's tip-latest)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c     |   12 ++++++++++++
 include/asm-x86/uv/uv_bau.h  |    1 +
 include/asm-x86/uv/uv_mmrs.h |    5 +++++
 3 files changed, 18 insertions(+)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -741,6 +741,18 @@ static int __init uv_init_blade(int blad
 		uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
 				      ((apicid << 32) | UV_BAU_MESSAGE));
 	}
+
+	/*
+	 * The hub's extended apic mode must agree with the kernel's setting,
+	 * which is indicated by global "x2apic".
+	 */
+	pa = uv_read_global_mmr64(pnode, UVH_LB_BAU_MISC_CONTROL);
+	if (!x2apic && (pa & UVH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK))
+		pa &= ~UVH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK;
+	else if (x2apic && (!(pa & UVH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK)))
+		pa |= UVH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK;
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_MISC_CONTROL, pa);
+
 	return 0;
 }
 
Index: linux/include/asm-x86/uv/uv_bau.h
===================================================================
--- linux.orig/include/asm-x86/uv/uv_bau.h
+++ linux/include/asm-x86/uv/uv_bau.h
@@ -333,5 +333,6 @@ static inline void bau_cpubits_clear(str
 extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
+extern int x2apic;
 
 #endif /* __ASM_X86_UV_BAU__ */
Index: linux/include/asm-x86/uv/uv_mmrs.h
===================================================================
--- linux.orig/include/asm-x86/uv/uv_mmrs.h
+++ linux/include/asm-x86/uv/uv_mmrs.h
@@ -1291,5 +1291,10 @@ union uvh_si_alias2_overlay_config_u {
     } s;
 };
 
+/* ========================================================================= */
+/*                         UVH_LB_BAU_MISC_CONTROL                           */
+/* ========================================================================= */
+#define UVH_LB_BAU_MISC_CONTROL 0x320170UL
+#define UVH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK 0x0000000000000100UL
 
 #endif /* __ASM_X86_UV_MMRS__ */
