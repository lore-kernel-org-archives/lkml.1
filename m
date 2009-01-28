Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbZA2ACq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbZA2ACq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbZA1XpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:52974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615AbZA1XpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:02 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 046/114] x86: refactor ->setup_portio_remap() subarch methods
Date: Wed, 28 Jan 2009 23:41:52 +0000
Message-Id: <1233186180-29883-47-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only NUMAQ has a real ->setup_portio_remap() method, the other
subarchitectures define it but keep it empty.

So mark the vector as NULL, extend the generic code to handle
NULL -setup_portio_remap() entries and remove all the empty
handlers.

Also move the NUMAQ method from the header file into the
 apic driver .c file.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    4 ----
 arch/x86/include/asm/mach-default/mach_apic.h |    4 ----
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |   13 -------------
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/smpboot.c                     |    3 ++-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |   15 ++++++++++++++-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 0804574..2fa7003 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -95,7 +95,7 @@ static inline physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
 	return physids_promote(0xFFL);
 }
 
-static inline void setup_portio_remap(void)
+static inline void bigsmp_setup_portio_remap(void)
 {
 }
 
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index a09e113..c5b0eb5 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -127,10 +127,6 @@ static inline physid_mask_t es7000_ioapic_phys_id_map(physid_mask_t phys_map)
 }
 
 
-static inline void setup_portio_remap(void)
-{
-}
-
 extern unsigned int boot_cpu_physical_apicid;
 static inline int check_phys_apicid_present(int cpu_physical_apicid)
 {
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 22683e5..54c20e1 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -132,10 +132,6 @@ static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
 	return physid_mask_of_physid(phys_apicid);
 }
 
-static inline void setup_portio_remap(void)
-{
-}
-
 static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map);
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 997618f..393a97c 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define setup_portio_remap (apic->setup_portio_remap)
 #define check_phys_apicid_present (apic->check_phys_apicid_present)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 8ac000f..6b62651 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -92,19 +92,6 @@ static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
 
 extern void *xquad_portio;
 
-static inline void setup_portio_remap(void)
-{
-	int num_quads = num_online_nodes();
-
-	if (num_quads <= 1)
-       		return;
-
-	printk("Remapping cross-quad port I/O for %d quads\n", num_quads);
-	xquad_portio = ioremap(XQUAD_PORTIO_BASE, num_quads*XQUAD_PORTIO_QUAD);
-	printk("xquad_portio vaddr 0x%08lx, len %08lx\n",
-		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
-}
-
 static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return (1);
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 79c1a45..131343b 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -116,7 +116,7 @@ static inline physid_mask_t summit_apicid_to_cpu_present(int apicid)
 	return physid_mask_of_physid(0);
 }
 
-static inline void setup_portio_remap(void)
+static inline void summit_setup_portio_remap(void)
 {
 }
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 812bf39..0e7d26c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1170,7 +1170,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	map_cpu_to_logical_apicid();
 
-	setup_portio_remap();
+	if (apic->setup_portio_remap)
+		apic->setup_portio_remap();
 
 	smpboot_setup_io_apic();
 	/*
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 6139652..4247405 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -84,7 +84,7 @@ struct genapic apic_bigsmp = {
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
-	.setup_portio_remap		= setup_portio_remap,
+	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 8fc704a..b48a58d 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -65,7 +65,7 @@ struct genapic apic_default = {
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
-	.setup_portio_remap		= setup_portio_remap,
+	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 1e0e162..449eca5 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -126,7 +126,7 @@ struct genapic apic_es7000 = {
 	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
-	.setup_portio_remap		= setup_portio_remap,
+	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 839b86b..e60361b 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -44,6 +44,19 @@ static void numaq_vector_allocation_domain(int cpu, cpumask_t *retmask)
 	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
+static void numaq_setup_portio_remap(void)
+{
+	int num_quads = num_online_nodes();
+
+	if (num_quads <= 1)
+       		return;
+
+	printk("Remapping cross-quad port I/O for %d quads\n", num_quads);
+	xquad_portio = ioremap(XQUAD_PORTIO_BASE, num_quads*XQUAD_PORTIO_QUAD);
+	printk("xquad_portio vaddr 0x%08lx, len %08lx\n",
+		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
+}
+
 struct genapic apic_numaq = {
 
 	.name				= "NUMAQ",
@@ -71,7 +84,7 @@ struct genapic apic_numaq = {
 	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
-	.setup_portio_remap		= setup_portio_remap,
+	.setup_portio_remap		= numaq_setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index b6e3760..ffcf7ca 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -64,7 +64,7 @@ struct genapic apic_summit = {
 	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
-	.setup_portio_remap		= setup_portio_remap,
+	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
-- 
1.6.0.2

