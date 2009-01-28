Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbZA2AG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbZA2AG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbZA1Xpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:53060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660AbZA1Xpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:32 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 055/114] x86, apic: refactor ->get_apic_id() & GET_APIC_ID()
Date: Wed, 28 Jan 2009 23:42:01 +0000
Message-Id: <1233186180-29883-56-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- spread out the namespace on a per driver basis

 - get rid of macro wrappers

 - small cleanups

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apicdef.h            |    6 ++----
 arch/x86/include/asm/es7000/apicdef.h            |    6 ++----
 arch/x86/include/asm/mach-default/mach_apic.h    |    2 +-
 arch/x86/include/asm/mach-default/mach_apicdef.h |   10 +++++-----
 arch/x86/include/asm/mach-generic/mach_apicdef.h |    1 -
 arch/x86/include/asm/numaq/apicdef.h             |    7 ++-----
 arch/x86/include/asm/smp.h                       |    2 +-
 arch/x86/include/asm/summit/apicdef.h            |    6 ++----
 arch/x86/kernel/genapic_flat_64.c                |    9 +++++----
 arch/x86/kernel/genx2apic_cluster.c              |    4 ++--
 arch/x86/kernel/genx2apic_phys.c                 |    4 ++--
 arch/x86/kernel/genx2apic_uv_x.c                 |    6 +++---
 arch/x86/mach-generic/bigsmp.c                   |    2 +-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mach-generic/es7000.c                   |    2 +-
 arch/x86/mach-generic/numaq.c                    |    2 +-
 arch/x86/mach-generic/summit.c                   |    2 +-
 17 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apicdef.h b/arch/x86/include/asm/bigsmp/apicdef.h
index 392c3f5..ed25dd6 100644
--- a/arch/x86/include/asm/bigsmp/apicdef.h
+++ b/arch/x86/include/asm/bigsmp/apicdef.h
@@ -3,11 +3,9 @@
 
 #define		APIC_ID_MASK		(0xFF<<24)
 
-static inline unsigned get_apic_id(unsigned long x)
+static inline unsigned bigsmp_get_apic_id(unsigned long x)
 {
-	return (((x)>>24)&0xFF);
+	return (x >> 24) & 0xFF;
 }
 
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
 #endif
diff --git a/arch/x86/include/asm/es7000/apicdef.h b/arch/x86/include/asm/es7000/apicdef.h
index 8b234a3..e237917 100644
--- a/arch/x86/include/asm/es7000/apicdef.h
+++ b/arch/x86/include/asm/es7000/apicdef.h
@@ -3,11 +3,9 @@
 
 #define		APIC_ID_MASK		(0xFF<<24)
 
-static inline unsigned get_apic_id(unsigned long x)
+static inline unsigned int es7000_get_apic_id(unsigned long x)
 {
-	return (((x)>>24)&0xFF);
+	return (x >> 24) & 0xFF;
 }
 
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
 #endif
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index d060528..8719208 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -21,7 +21,7 @@ static inline const struct cpumask *default_target_cpus(void)
 #include <asm/genapic.h>
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
-#define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
+#define read_apic_id()  (apic->get_apic_id(apic_read(APIC_ID)))
 #define send_IPI_self (apic->send_IPI_self)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void default_setup_apic_routing(void);
diff --git a/arch/x86/include/asm/mach-default/mach_apicdef.h b/arch/x86/include/asm/mach-default/mach_apicdef.h
index b4dcc09..e84d437 100644
--- a/arch/x86/include/asm/mach-default/mach_apicdef.h
+++ b/arch/x86/include/asm/mach-default/mach_apicdef.h
@@ -5,20 +5,20 @@
 
 #ifdef CONFIG_X86_64
 #define	APIC_ID_MASK		(apic->apic_id_mask)
-#define GET_APIC_ID(x)		(apic->get_apic_id(x))
 #define	SET_APIC_ID(x)		(apic->set_apic_id(x))
 #else
 #define		APIC_ID_MASK		(0xF<<24)
-static inline unsigned get_apic_id(unsigned long x) 
+
+static inline unsigned default_get_apic_id(unsigned long x) 
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
+
 	if (APIC_XAPIC(ver))
-		return (((x)>>24)&0xFF);
+		return (x >> 24) & 0xFF;
 	else
-		return (((x)>>24)&0xF);
+		return (x >> 24) & 0x0F;
 } 
 
-#define		GET_APIC_ID(x)	get_apic_id(x)
 #endif
 
 #endif /* _ASM_X86_MACH_DEFAULT_MACH_APICDEF_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_apicdef.h b/arch/x86/include/asm/mach-generic/mach_apicdef.h
index acc9add..645520b 100644
--- a/arch/x86/include/asm/mach-generic/mach_apicdef.h
+++ b/arch/x86/include/asm/mach-generic/mach_apicdef.h
@@ -4,7 +4,6 @@
 #ifndef APIC_DEFINITION
 #include <asm/genapic.h>
 
-#define GET_APIC_ID (apic->get_apic_id)
 #define APIC_ID_MASK (apic->apic_id_mask)
 #endif
 
diff --git a/arch/x86/include/asm/numaq/apicdef.h b/arch/x86/include/asm/numaq/apicdef.h
index e012a46..29f5e3d 100644
--- a/arch/x86/include/asm/numaq/apicdef.h
+++ b/arch/x86/include/asm/numaq/apicdef.h
@@ -1,14 +1,11 @@
 #ifndef __ASM_NUMAQ_APICDEF_H
 #define __ASM_NUMAQ_APICDEF_H
 
-
 #define APIC_ID_MASK (0xF<<24)
 
-static inline unsigned get_apic_id(unsigned long x)
+static inline unsigned int numaq_get_apic_id(unsigned long x)
 {
-	        return (((x)>>24)&0x0F);
+	return (x >> 24) & 0x0F;
 }
 
-#define         GET_APIC_ID(x)  get_apic_id(x)
-
 #endif
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 45ef8a1..c63d480 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -189,7 +189,7 @@ static inline unsigned int read_apic_id(void)
 
 	reg = *(u32 *)(APIC_BASE + APIC_ID);
 
-	return GET_APIC_ID(reg);
+	return apic->get_apic_id(reg);
 }
 #endif
 
diff --git a/arch/x86/include/asm/summit/apicdef.h b/arch/x86/include/asm/summit/apicdef.h
index f3fbca1..4286528 100644
--- a/arch/x86/include/asm/summit/apicdef.h
+++ b/arch/x86/include/asm/summit/apicdef.h
@@ -3,11 +3,9 @@
 
 #define		APIC_ID_MASK		(0xFF<<24)
 
-static inline unsigned get_apic_id(unsigned long x)
+static inline unsigned summit_get_apic_id(unsigned long x)
 {
-	return (x>>24)&0xFF;
+	return (x >> 24) & 0xFF;
 }
 
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
 #endif
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index cc9e07b..ab47091 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -126,11 +126,12 @@ static void flat_send_IPI_all(int vector)
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->dest_logical);
 }
 
-static unsigned int get_apic_id(unsigned long x)
+static unsigned int flat_get_apic_id(unsigned long x)
 {
 	unsigned int id;
 
 	id = (((x)>>24) & 0xFFu);
+
 	return id;
 }
 
@@ -146,7 +147,7 @@ static unsigned int read_xapic_id(void)
 {
 	unsigned int id;
 
-	id = get_apic_id(apic_read(APIC_ID));
+	id = flat_get_apic_id(apic_read(APIC_ID));
 	return id;
 }
 
@@ -205,7 +206,7 @@ struct genapic apic_flat =  {
 	.phys_pkg_id			= flat_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= flat_get_apic_id,
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFu << 24,
 
@@ -349,7 +350,7 @@ struct genapic apic_physflat =  {
 	.phys_pkg_id			= flat_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= flat_get_apic_id,
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFu<<24,
 
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 18b6f14..c7557e0 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -141,7 +141,7 @@ static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return BAD_APICID;
 }
 
-static unsigned int get_apic_id(unsigned long x)
+static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
 {
 	unsigned int id;
 
@@ -207,7 +207,7 @@ struct genapic apic_x2apic_cluster = {
 	.phys_pkg_id			= x2apic_cluster_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= x2apic_cluster_phys_get_apic_id,
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 2cb6f49..80cba49 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -140,7 +140,7 @@ static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return BAD_APICID;
 }
 
-static unsigned int get_apic_id(unsigned long x)
+static unsigned int x2apic_phys_get_apic_id(unsigned long x)
 {
 	unsigned int id;
 
@@ -203,7 +203,7 @@ struct genapic apic_x2apic_phys = {
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= x2apic_phys_get_apic_id,
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 67e7658..50310b9 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -201,7 +201,7 @@ static unsigned int uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return BAD_APICID;
 }
 
-static unsigned int get_apic_id(unsigned long x)
+static unsigned int x2apic_get_apic_id(unsigned long x)
 {
 	unsigned int id;
 
@@ -223,7 +223,7 @@ static unsigned long set_apic_id(unsigned int id)
 static unsigned int uv_read_apic_id(void)
 {
 
-	return get_apic_id(apic_read(APIC_ID));
+	return x2apic_get_apic_id(apic_read(APIC_ID));
 }
 
 static int uv_phys_pkg_id(int initial_apicid, int index_msb)
@@ -268,7 +268,7 @@ struct genapic apic_x2apic_uv_x = {
 	.phys_pkg_id			= uv_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 6bf6aaf..9eca977 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -90,7 +90,7 @@ struct genapic apic_bigsmp = {
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= bigsmp_get_apic_id,
 	.set_apic_id			= NULL,
 	.apic_id_mask			= APIC_ID_MASK,
 
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index e5f85cd..d51a3f0 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -71,7 +71,7 @@ struct genapic apic_default = {
 	.phys_pkg_id			= default_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= default_get_apic_id,
 	.set_apic_id			= NULL,
 	.apic_id_mask			= APIC_ID_MASK,
 
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index f861163..1944675 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -126,7 +126,7 @@ struct genapic apic_es7000 = {
 	.phys_pkg_id			= es7000_phys_pkg_id,
 	.mps_oem_check			= es7000_mps_oem_check,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= es7000_get_apic_id,
 	.set_apic_id			= NULL,
 	.apic_id_mask			= APIC_ID_MASK,
 
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 517882c..fcbba84 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -90,7 +90,7 @@ struct genapic apic_numaq = {
 	.phys_pkg_id			= numaq_phys_pkg_id,
 	.mps_oem_check			= __numaq_mps_oem_check,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= numaq_get_apic_id,
 	.set_apic_id			= NULL,
 	.apic_id_mask			= APIC_ID_MASK,
 
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 719e944..5650eaf 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -70,7 +70,7 @@ struct genapic apic_summit = {
 	.phys_pkg_id			= summit_phys_pkg_id,
 	.mps_oem_check			= summit_mps_oem_check,
 
-	.get_apic_id			= get_apic_id,
+	.get_apic_id			= summit_get_apic_id,
 	.set_apic_id			= NULL,
 	.apic_id_mask			= APIC_ID_MASK,
 
-- 
1.6.0.2

