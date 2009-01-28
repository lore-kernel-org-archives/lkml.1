Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZA2ACH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZA2ACH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbZA1XpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:52951 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202AbZA1Xo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:59 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 047/114] x86: refactor ->check_phys_apicid_present() subarch methods
Date: Wed, 28 Jan 2009 23:41:53 +0000
Message-Id: <1233186180-29883-48-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- spread out the namespace to per driver methods

 - extend it to 64-bit as well so that we can use
   apic->check_phys_apicid_present() unconditionally

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    6 +++---
 arch/x86/include/asm/es7000/apic.h            |    4 ++--
 arch/x86/include/asm/genapic.h                |    1 +
 arch/x86/include/asm/mach-default/mach_apic.h |   18 +++++++++++++-----
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    4 ++--
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/genapic_flat_64.c             |    4 ++--
 arch/x86/kernel/genx2apic_cluster.c           |    2 +-
 arch/x86/kernel/genx2apic_phys.c              |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c              |    2 +-
 arch/x86/kernel/smpboot.c                     |    7 ++++++-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 17 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 2fa7003..5ba4118 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -99,13 +99,13 @@ static inline void bigsmp_setup_portio_remap(void)
 {
 }
 
-static inline void enable_apic_mode(void)
+static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
+	return 1;
 }
 
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
+static inline void enable_apic_mode(void)
 {
-	return (1);
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index c5b0eb5..717c27f 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -126,9 +126,9 @@ static inline physid_mask_t es7000_ioapic_phys_id_map(physid_mask_t phys_map)
 	return physids_promote(0xff);
 }
 
-
 extern unsigned int boot_cpu_physical_apicid;
-static inline int check_phys_apicid_present(int cpu_physical_apicid)
+
+static inline int es7000_check_phys_apicid_present(int cpu_physical_apicid)
 {
 	boot_cpu_physical_apicid = read_apic_id();
 	return (1);
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 2cb14d5..f292fd0 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -110,6 +110,7 @@ DECLARE_PER_CPU(int, x2apic_extra_bits);
 extern void default_setup_apic_routing(void);
 
 extern int default_cpu_present_to_apicid(int mps_cpu);
+extern int default_check_phys_apicid_present(int boot_cpu_physical_apicid);
 #endif
 
 #endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 54c20e1..0a824d3 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -118,13 +118,26 @@ static inline int __default_cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
+static inline int
+__default_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map);
+}
+
 #ifdef CONFIG_X86_32
 static inline int default_cpu_present_to_apicid(int mps_cpu)
 {
 	return __default_cpu_present_to_apicid(mps_cpu);
 }
+
+static inline int
+default_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return __default_check_phys_apicid_present(boot_cpu_physical_apicid);
+}
 #else
 extern int default_cpu_present_to_apicid(int mps_cpu);
+extern int default_check_phys_apicid_present(int boot_cpu_physical_apicid);
 #endif
 
 static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
@@ -132,11 +145,6 @@ static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
 	return physid_mask_of_physid(phys_apicid);
 }
 
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map);
-}
-
 static inline void enable_apic_mode(void)
 {
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 393a97c..efd762d 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define check_phys_apicid_present (apic->check_phys_apicid_present)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
 #define enable_apic_mode (apic->enable_apic_mode)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 6b62651..3be735e 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -92,9 +92,9 @@ static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
 
 extern void *xquad_portio;
 
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
+static inline int numaq_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
-	return (1);
+	return 1;
 }
 
 static inline void enable_apic_mode(void)
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 131343b..fe578f6 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -120,7 +120,7 @@ static inline void summit_setup_portio_remap(void)
 {
 }
 
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
+static inline int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return 1;
 }
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index f4a2c1c..78adf71 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -200,7 +200,7 @@ struct genapic apic_flat =  {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= NULL,
@@ -344,7 +344,7 @@ struct genapic apic_physflat =  {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= NULL,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 710d612..7062e24 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -202,7 +202,7 @@ struct genapic apic_x2apic_cluster = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= NULL,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 49a4491..7177a11 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -198,7 +198,7 @@ struct genapic apic_x2apic_phys = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= NULL,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index a08a635..debd721 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -263,7 +263,7 @@ struct genapic apic_x2apic_uv_x = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= NULL,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0e7d26c..ab83be2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -908,6 +908,11 @@ int default_cpu_present_to_apicid(int mps_cpu)
 {
 	return __default_cpu_present_to_apicid(mps_cpu);
 }
+
+int default_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return __default_check_phys_apicid_present(boot_cpu_physical_apicid);
+}
 #endif
 
 int __cpuinit native_cpu_up(unsigned int cpu)
@@ -1058,7 +1063,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 * Should not be necessary because the MP table should list the boot
 	 * CPU too, but we do it for the sake of robustness anyway.
 	 */
-	if (!check_phys_apicid_present(boot_cpu_physical_apicid)) {
+	if (!apic->check_phys_apicid_present(boot_cpu_physical_apicid)) {
 		printk(KERN_NOTICE
 			"weird, boot CPU (#%d) not listed by the BIOS.\n",
 			boot_cpu_physical_apicid);
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 4247405..82743d1 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -85,7 +85,7 @@ struct genapic apic_bigsmp = {
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= check_phys_apicid_present,
+	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index b48a58d..d0374c6 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -66,7 +66,7 @@ struct genapic apic_default = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= check_phys_apicid_present,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 449eca5..52b3eb5 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -127,7 +127,7 @@ struct genapic apic_es7000 = {
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= check_phys_apicid_present,
+	.check_phys_apicid_present	= es7000_check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index e60361b..7ec2ca4 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -85,7 +85,7 @@ struct genapic apic_numaq = {
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= numaq_setup_portio_remap,
-	.check_phys_apicid_present	= check_phys_apicid_present,
+	.check_phys_apicid_present	= numaq_check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index ffcf7ca..acf12de 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -65,7 +65,7 @@ struct genapic apic_summit = {
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= check_phys_apicid_present,
+	.check_phys_apicid_present	= summit_check_phys_apicid_present,
 	.enable_apic_mode		= enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
-- 
1.6.0.2

