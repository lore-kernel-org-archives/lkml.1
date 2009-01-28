Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZA2AA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZA2AA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbZA1Xox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:52918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbZA1Xot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:49 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 039/114] x86, apic: clean up ->ioapic_phys_id_map()
Date: Wed, 28 Jan 2009 23:41:45 +0000
Message-Id: <1233186180-29883-40-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- separate the namespace

 - remove macros

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    2 +-
 arch/x86/include/asm/mach-default/mach_apic.h |    2 +-
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    3 ++-
 arch/x86/kernel/io_apic.c                     |    4 ++--
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 8194130..05116d5 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -94,7 +94,7 @@ static inline int cpu_to_logical_apicid(int cpu)
 	return cpu_physical_id(cpu);
 }
 
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+static inline physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
 	return physids_promote(0xFFL);
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 06f5757..db3e652 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -125,7 +125,7 @@ static inline int cpu_to_logical_apicid(int cpu)
 #endif
 }
 
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+static inline physid_mask_t es7000_ioapic_phys_id_map(physid_mask_t phys_map)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
 	return physids_promote(0xff);
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 23e0a2d..7abdaae 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -99,7 +99,7 @@ static inline unsigned long default_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+static inline physid_mask_t default_ioapic_phys_id_map(physid_mask_t phys_map)
 {
 	return phys_map;
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 8e51f41..c1c96e6 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define ioapic_phys_id_map (apic->ioapic_phys_id_map)
 #define setup_apic_routing (apic->setup_apic_routing)
 #define multi_timer_check (apic->multi_timer_check)
 #define apicid_to_node (apic->apicid_to_node)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 8022974..dc7499b 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -48,7 +48,7 @@ static inline int multi_timer_check(int apic, int irq)
 	return apic != 0 && irq == 0;
 }
 
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+static inline physid_mask_t numaq_ioapic_phys_id_map(physid_mask_t phys_map)
 {
 	/* We don't have a good way to do this yet - hack */
 	return physids_promote(0xFUL);
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 9108c89..4dafb58 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -109,7 +109,8 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_id_map)
+static inline physid_mask_t
+ summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
 	return physids_promote(0x0F);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 49899e0..db79ad9 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2108,7 +2108,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 	 * This is broken; anything with a real cpu count has to
 	 * circumvent this idiocy regardless.
 	 */
-	phys_id_present_map = ioapic_phys_id_map(phys_cpu_present_map);
+	phys_id_present_map = apic->ioapic_phys_id_map(phys_cpu_present_map);
 
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
@@ -3862,7 +3862,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	 */
 
 	if (physids_empty(apic_id_map))
-		apic_id_map = ioapic_phys_id_map(phys_cpu_present_map);
+		apic_id_map = apic->ioapic_phys_id_map(phys_cpu_present_map);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic, 0);
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 7b7fc47..f2a3418 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -77,7 +77,7 @@ struct genapic apic_bigsmp = {
 	.vector_allocation_domain	= bigsmp_vector_allocation_domain,
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
 
-	.ioapic_phys_id_map		= ioapic_phys_id_map,
+	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 633e848..c403f3d 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -58,7 +58,7 @@ struct genapic apic_default = {
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= default_init_apic_ldr,
 
-	.ioapic_phys_id_map		= ioapic_phys_id_map,
+	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index b70833e..ce09baf 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -119,7 +119,7 @@ struct genapic apic_es7000 = {
 	.vector_allocation_domain	= es7000_vector_allocation_domain,
 	.init_apic_ldr			= es7000_init_apic_ldr,
 
-	.ioapic_phys_id_map		= ioapic_phys_id_map,
+	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index a06fda5..5d98f18 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -64,7 +64,7 @@ struct genapic apic_numaq = {
 	.vector_allocation_domain	= numaq_vector_allocation_domain,
 	.init_apic_ldr			= numaq_init_apic_ldr,
 
-	.ioapic_phys_id_map		= ioapic_phys_id_map,
+	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 36c552f..6abdd53 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -57,7 +57,7 @@ struct genapic apic_summit = {
 	.vector_allocation_domain	= summit_vector_allocation_domain,
 	.init_apic_ldr			= summit_init_apic_ldr,
 
-	.ioapic_phys_id_map		= ioapic_phys_id_map,
+	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
 	.multi_timer_check		= multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
-- 
1.6.0.2

