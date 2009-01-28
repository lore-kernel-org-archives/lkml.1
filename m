Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbZA2ACa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbZA2ACa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbZA1XpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:52961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758609AbZA1XpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:01 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 045/114] x86, apic: clean up ->apicid_to_cpu_present()
Date: Wed, 28 Jan 2009 23:41:51 +0000
Message-Id: <1233186180-29883-46-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:42 +0000 (UTC)
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
 arch/x86/include/asm/summit/apic.h            |    4 ++--
 arch/x86/kernel/io_apic.c                     |    4 ++--
 arch/x86/kernel/visws_quirks.c                |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 13 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index eea5e97..0804574 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -75,7 +75,7 @@ static inline int bigsmp_cpu_present_to_apicid(int mps_cpu)
 	return BAD_APICID;
 }
 
-static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
+static inline physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
 {
 	return physid_mask_of_physid(phys_apicid);
 }
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 7cdde3d..a09e113 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -98,7 +98,7 @@ static inline int es7000_cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
-static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
+static inline physid_mask_t es7000_apicid_to_cpu_present(int phys_apicid)
 {
 	static int id = 0;
 	physid_mask_t mask;
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 15d5627..22683e5 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -127,7 +127,7 @@ static inline int default_cpu_present_to_apicid(int mps_cpu)
 extern int default_cpu_present_to_apicid(int mps_cpu);
 #endif
 
-static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
+static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
 {
 	return physid_mask_of_physid(phys_apicid);
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 332fe93..997618f 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define apicid_to_cpu_present (apic->apicid_to_cpu_present)
 #define setup_portio_remap (apic->setup_portio_remap)
 #define check_phys_apicid_present (apic->check_phys_apicid_present)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index f482b06..8ac000f 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -82,7 +82,7 @@ static inline int numaq_apicid_to_node(int logical_apicid)
 	return logical_apicid >> 4;
 }
 
-static inline physid_mask_t apicid_to_cpu_present(int logical_apicid)
+static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
 {
 	int node = numaq_apicid_to_node(logical_apicid);
 	int cpu = __ffs(logical_apicid & 0xf);
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index fc12736..79c1a45 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -105,13 +105,13 @@ static inline int summit_cpu_present_to_apicid(int mps_cpu)
 }
 
 static inline physid_mask_t
- summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
+summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
 	return physids_promote(0x0F);
 }
 
-static inline physid_mask_t apicid_to_cpu_present(int apicid)
+static inline physid_mask_t summit_apicid_to_cpu_present(int apicid)
 {
 	return physid_mask_of_physid(0);
 }
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 282ea11..3d85d3d 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2155,7 +2155,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 			mp_ioapics[apic_id].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apicid_to_cpu_present(mp_ioapics[apic_id].apicid);
+			tmp = apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
 					mp_ioapics[apic_id].apicid);
@@ -3899,7 +3899,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 		apic_id = i;
 	}
 
-	tmp = apicid_to_cpu_present(apic_id);
+	tmp = apic->apicid_to_cpu_present(apic_id);
 	physids_or(apic_id_map, apic_id_map, tmp);
 
 	if (reg_00.bits.ID != apic_id) {
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index d801d06..2ed5bdf 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -200,7 +200,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 		return;
 	}
 
-	apic_cpus = apicid_to_cpu_present(m->apicid);
+	apic_cpus = apic->apicid_to_cpu_present(m->apicid);
 	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
 	/*
 	 * Validate version
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 1eaf18c..6139652 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -83,7 +83,7 @@ struct genapic apic_bigsmp = {
 	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= apicid_to_cpu_present,
+	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 2903657..8fc704a 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -64,7 +64,7 @@ struct genapic apic_default = {
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= apicid_to_cpu_present,
+	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 5a3a8ab..1e0e162 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -125,7 +125,7 @@ struct genapic apic_es7000 = {
 	.apicid_to_node			= es7000_apicid_to_node,
 	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= apicid_to_cpu_present,
+	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index d928cae..839b86b 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -70,7 +70,7 @@ struct genapic apic_numaq = {
 	.apicid_to_node			= numaq_apicid_to_node,
 	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= apicid_to_cpu_present,
+	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index e6bb34e..b6e3760 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -63,7 +63,7 @@ struct genapic apic_summit = {
 	.apicid_to_node			= summit_apicid_to_node,
 	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= apicid_to_cpu_present,
+	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
-- 
1.6.0.2

