Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZA3KXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZA3KXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZA3KSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:18:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54402 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbZA3KRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:55 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove trampoline_phys_low/high genapic fields
Date: Fri, 30 Jan 2009 11:17:17 +0100
Message-Id: <1233310639-27916-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-11-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
 <1233310639-27916-7-git-send-email-andi@firstfloor.org>
 <1233310639-27916-8-git-send-email-andi@firstfloor.org>
 <1233310639-27916-9-git-send-email-andi@firstfloor.org>
 <1233310639-27916-10-git-send-email-andi@firstfloor.org>
 <1233310639-27916-11-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

were only used by NUMAQ and es7000

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/genapic.h       |    9 +++------
 arch/x86/include/asm/smpboot_hooks.h |   10 +++++-----
 arch/x86/kernel/bigsmp_32.c          |    2 --
 arch/x86/kernel/es7000_32.c          |    3 ---
 arch/x86/kernel/genapic_flat_64.c    |    4 ----
 arch/x86/kernel/genx2apic_cluster.c  |    2 --
 arch/x86/kernel/genx2apic_phys.c     |    2 --
 arch/x86/kernel/genx2apic_uv_x.c     |    2 --
 arch/x86/kernel/numaq_32.c           |    6 ------
 arch/x86/kernel/probe_32.c           |    2 --
 arch/x86/kernel/summit_32.c          |    2 --
 11 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 2047b14..658d66a 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -71,9 +71,6 @@ struct genapic {
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
 
-	int trampoline_phys_low;
-	int trampoline_phys_high;
-
 	void (*wait_for_init_deassert)(atomic_t *deassert);
 	void (*inquire_remote_apic)(int apicid);
 };
@@ -81,10 +78,10 @@ struct genapic {
 extern struct genapic *apic;
 
 /*
- * Warm reset vector default position:
+ * Warm reset vector position:
  */
-#define DEFAULT_TRAMPOLINE_PHYS_LOW		0x467
-#define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
+#define TRAMPOLINE_PHYS_LOW		0x467
+#define TRAMPOLINE_PHYS_HIGH		0x469
 
 #ifdef CONFIG_X86_32
 extern void es7000_update_genapic_to_cluster(void);
diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 1def601..a104f84 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -13,11 +13,11 @@ static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 	CMOS_WRITE(0xa, 0xf);
 	local_flush_tlb();
 	pr_debug("1.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
-								 start_eip >> 4;
+	*((volatile unsigned short *)
+		phys_to_virt(TRAMPOLINE_PHYS_HIGH)) = start_eip >> 4;
 	pr_debug("2.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
-							 start_eip & 0xf;
+	*((volatile unsigned short *)
+		phys_to_virt(TRAMPOLINE_PHYS_LOW)) = start_eip & 0xf;
 	pr_debug("3.\n");
 }
 
@@ -34,7 +34,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile long *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index e35e1ff..17c6c06 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -250,8 +250,6 @@ struct genapic apic_bigsmp = {
 	.send_IPI_all			= bigsmp_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index c94fc21..bb4f525 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -784,9 +784,6 @@ struct genapic apic_es7000 = {
 	.send_IPI_self			= NULL,
 
 
-	.trampoline_phys_low		= 0x467,
-	.trampoline_phys_high		= 0x469,
-
 	.wait_for_init_deassert		= es7000_wait_for_init_deassert,
 
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index e87c3bc..a7c42d4 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -220,8 +220,6 @@ struct genapic apic_flat =  {
 	.send_IPI_all			= flat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.inquire_remote_apic		= NULL,
 };
@@ -360,8 +358,6 @@ struct genapic apic_physflat =  {
 	.send_IPI_all			= physflat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 2e7497b..71534eb 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -225,8 +225,6 @@ struct genapic apic_x2apic_cluster = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index f47c2ff..02b3e37 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -211,8 +211,6 @@ struct genapic apic_x2apic_phys = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index ba1e3b1..def1b26 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -284,8 +284,6 @@ struct genapic apic_x2apic_uv_x = {
 	.send_IPI_all			= uv_send_IPI_all,
 	.send_IPI_self			= uv_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index d412d0e..e719520 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -337,9 +337,6 @@ static inline void numaq_send_IPI_all(int vector)
 
 extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
 
-#define NUMAQ_TRAMPOLINE_PHYS_LOW (0x8)
-#define NUMAQ_TRAMPOLINE_PHYS_HIGH (0xa)
-
 static inline const cpumask_t *numaq_target_cpus(void)
 {
 	return &CPU_MASK_ALL;
@@ -513,9 +510,6 @@ struct genapic apic_numaq = {
 	.send_IPI_all			= numaq_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.trampoline_phys_low		= NUMAQ_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= NUMAQ_TRAMPOLINE_PHYS_HIGH,
-
 	/* We don't do anything here because we use NMI's to boot instead */
 	.wait_for_init_deassert		= NULL,
 
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index b01936f..826bc86 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -116,8 +116,6 @@ struct genapic apic_default = {
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index ec815fe..f528723 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -586,8 +586,6 @@ struct genapic apic_summit = {
 	.send_IPI_all			= summit_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-- 
1.5.6.5

