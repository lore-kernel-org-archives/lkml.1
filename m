Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbZA1X7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbZA1X7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbZA1Xow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:52925 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543AbZA1Xov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:51 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 042/114] x86, apic: clean up ->apicid_to_node()
Date: Wed, 28 Jan 2009 23:41:48 +0000
Message-Id: <1233186180-29883-43-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:35 +0000 (UTC)
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
 arch/x86/include/asm/numaq/apic.h             |    4 ++--
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/smpboot.c                     |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index df59298..77f0b73 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -62,7 +62,7 @@ static inline void bigsmp_setup_apic_routing(void)
 		"Physflat", nr_ioapics);
 }
 
-static inline int apicid_to_node(int logical_apicid)
+static inline int bigsmp_apicid_to_node(int logical_apicid)
 {
 	return apicid_2_node[hard_smp_processor_id()];
 }
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 632e4cd..bcdf314 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -82,7 +82,7 @@ static inline void es7000_setup_apic_routing(void)
 			nr_ioapics, cpus_addr(*es7000_target_cpus())[0]);
 }
 
-static inline int apicid_to_node(int logical_apicid)
+static inline int es7000_apicid_to_node(int logical_apicid)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index f418d47..2f78209 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -78,7 +78,7 @@ static inline void default_setup_apic_routing(void)
 #endif
 }
 
-static inline int apicid_to_node(int logical_apicid)
+static inline int default_apicid_to_node(int logical_apicid)
 {
 #ifdef CONFIG_SMP
 	return apicid_2_node[hard_smp_processor_id()];
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index bdea0a7..b585a8e 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define apicid_to_node (apic->apicid_to_node)
 #define cpu_to_logical_apicid (apic->cpu_to_logical_apicid) 
 #define cpu_present_to_apicid (apic->cpu_present_to_apicid)
 #define apicid_to_cpu_present (apic->apicid_to_cpu_present)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 22bdf3d..a0e3b43 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -76,14 +76,14 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
-static inline int apicid_to_node(int logical_apicid) 
+static inline int numaq_apicid_to_node(int logical_apicid) 
 {
 	return logical_apicid >> 4;
 }
 
 static inline physid_mask_t apicid_to_cpu_present(int logical_apicid)
 {
-	int node = apicid_to_node(logical_apicid);
+	int node = numaq_apicid_to_node(logical_apicid);
 	int cpu = __ffs(logical_apicid & 0xf);
 
 	return physid_mask_of_physid(cpu + 4*node);
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index acb7bd1..cfff276 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -75,7 +75,7 @@ static inline void summit_setup_apic_routing(void)
 						nr_ioapics);
 }
 
-static inline int apicid_to_node(int logical_apicid)
+static inline int summit_apicid_to_node(int logical_apicid)
 {
 #ifdef CONFIG_SMP
 	return apicid_2_node[hard_smp_processor_id()];
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3791b4a..1dd4cec 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -163,7 +163,7 @@ static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
 	int apicid = logical_smp_processor_id();
-	int node = apicid_to_node(apicid);
+	int node = apic->apicid_to_node(apicid);
 
 	if (!node_online(node))
 		node = first_online_node;
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index d074956..2f41214 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -80,7 +80,7 @@ struct genapic apic_bigsmp = {
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= apicid_to_node,
+	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 6a21aa7..d391c2d 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -61,7 +61,7 @@ struct genapic apic_default = {
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= default_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= apicid_to_node,
+	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 0be59a5..933f2a3 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -122,7 +122,7 @@ struct genapic apic_es7000 = {
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= apicid_to_node,
+	.apicid_to_node			= es7000_apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index da4ed65..38344fb 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -67,7 +67,7 @@ struct genapic apic_numaq = {
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= numaq_multi_timer_check,
-	.apicid_to_node			= apicid_to_node,
+	.apicid_to_node			= numaq_apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index b618a18..6150604 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -60,7 +60,7 @@ struct genapic apic_summit = {
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= apicid_to_node,
+	.apicid_to_node			= summit_apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
-- 
1.6.0.2

