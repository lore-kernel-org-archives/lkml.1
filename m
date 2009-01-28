Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZA2AB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZA2AB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZA1Xo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:52943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202AbZA1Xo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:57 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 044/114] x86, apic: clean up ->cpu_present_to_apicid()
Date: Wed, 28 Jan 2009 23:41:50 +0000
Message-Id: <1233186180-29883-45-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- separate the namespace

 - remove macros

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    2 +-
 arch/x86/include/asm/genapic.h                |    2 ++
 arch/x86/include/asm/mach-default/mach_apic.h |   11 ++++++++++-
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/genapic_flat_64.c             |    4 ++--
 arch/x86/kernel/genx2apic_cluster.c           |    2 +-
 arch/x86/kernel/genx2apic_phys.c              |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c              |    2 +-
 arch/x86/kernel/smpboot.c                     |    9 ++++++++-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 17 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index d0d894f..eea5e97 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -67,7 +67,7 @@ static inline int bigsmp_apicid_to_node(int logical_apicid)
 	return apicid_2_node[hard_smp_processor_id()];
 }
 
-static inline int cpu_present_to_apicid(int mps_cpu)
+static inline int bigsmp_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
 		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index e0cd07e..7cdde3d 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -88,7 +88,7 @@ static inline int es7000_apicid_to_node(int logical_apicid)
 }
 
 
-static inline int cpu_present_to_apicid(int mps_cpu)
+static inline int es7000_cpu_present_to_apicid(int mps_cpu)
 {
 	if (!mps_cpu)
 		return boot_cpu_physical_apicid;
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 38b1202..2cb14d5 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -108,6 +108,8 @@ extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 
 extern void default_setup_apic_routing(void);
+
+extern int default_cpu_present_to_apicid(int mps_cpu);
 #endif
 
 #endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index eae3e4b..15d5627 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -110,7 +110,7 @@ static inline int default_cpu_to_logical_apicid(int cpu)
 	return 1 << cpu;
 }
 
-static inline int cpu_present_to_apicid(int mps_cpu)
+static inline int __default_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
 		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
@@ -118,6 +118,15 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
+#ifdef CONFIG_X86_32
+static inline int default_cpu_present_to_apicid(int mps_cpu)
+{
+	return __default_cpu_present_to_apicid(mps_cpu);
+}
+#else
+extern int default_cpu_present_to_apicid(int mps_cpu);
+#endif
+
 static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
 {
 	return physid_mask_of_physid(phys_apicid);
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 2ea913e..332fe93 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define cpu_present_to_apicid (apic->cpu_present_to_apicid)
 #define apicid_to_cpu_present (apic->apicid_to_cpu_present)
 #define setup_portio_remap (apic->setup_portio_remap)
 #define check_phys_apicid_present (apic->check_phys_apicid_present)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 6989abd..f482b06 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -69,7 +69,7 @@ static inline int numaq_cpu_to_logical_apicid(int cpu)
  * cpu to APIC ID relation to properly interact with the intelligent
  * mode of the cluster controller.
  */
-static inline int cpu_present_to_apicid(int mps_cpu)
+static inline int numaq_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < 60)
 		return ((mps_cpu >> 2) << 4) | (1 << (mps_cpu & 0x3));
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index d564d7e..fc12736 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -96,7 +96,7 @@ static inline int summit_cpu_to_logical_apicid(int cpu)
 #endif
 }
 
-static inline int cpu_present_to_apicid(int mps_cpu)
+static inline int summit_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
 		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 9446f37..f4a2c1c 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -197,7 +197,7 @@ struct genapic apic_flat =  {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
-	.cpu_present_to_apicid		= NULL,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= NULL,
@@ -341,7 +341,7 @@ struct genapic apic_physflat =  {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
-	.cpu_present_to_apicid		= NULL,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= NULL,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 2eeca6e..710d612 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -199,7 +199,7 @@ struct genapic apic_x2apic_cluster = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
-	.cpu_present_to_apicid		= NULL,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= NULL,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index be0ee3e..49a4491 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -195,7 +195,7 @@ struct genapic apic_x2apic_phys = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
-	.cpu_present_to_apicid		= NULL,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= NULL,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 68b423f..a08a635 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -260,7 +260,7 @@ struct genapic apic_x2apic_uv_x = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
-	.cpu_present_to_apicid		= NULL,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= NULL,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 1dd4cec..812bf39 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -903,9 +903,16 @@ do_rest:
 	return boot_error;
 }
 
+#ifdef CONFIG_X86_64
+int default_cpu_present_to_apicid(int mps_cpu)
+{
+	return __default_cpu_present_to_apicid(mps_cpu);
+}
+#endif
+
 int __cpuinit native_cpu_up(unsigned int cpu)
 {
-	int apicid = cpu_present_to_apicid(cpu);
+	int apicid = apic->cpu_present_to_apicid(cpu);
 	unsigned long flags;
 	int err;
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index cd6f02b..1eaf18c 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -82,7 +82,7 @@ struct genapic apic_bigsmp = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
-	.cpu_present_to_apicid		= cpu_present_to_apicid,
+	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index ef9b936..2903657 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -63,7 +63,7 @@ struct genapic apic_default = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
-	.cpu_present_to_apicid		= cpu_present_to_apicid,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 74bf2b6..5a3a8ab 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -124,7 +124,7 @@ struct genapic apic_es7000 = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= es7000_apicid_to_node,
 	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
-	.cpu_present_to_apicid		= cpu_present_to_apicid,
+	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 461f5be..d928cae 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -69,7 +69,7 @@ struct genapic apic_numaq = {
 	.multi_timer_check		= numaq_multi_timer_check,
 	.apicid_to_node			= numaq_apicid_to_node,
 	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
-	.cpu_present_to_apicid		= cpu_present_to_apicid,
+	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index d99be2d..e6bb34e 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -62,7 +62,7 @@ struct genapic apic_summit = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= summit_apicid_to_node,
 	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
-	.cpu_present_to_apicid		= cpu_present_to_apicid,
+	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
 	.check_phys_apicid_present	= check_phys_apicid_present,
-- 
1.6.0.2

