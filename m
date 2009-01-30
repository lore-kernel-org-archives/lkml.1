Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZA3KVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZA3KVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZA3KR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54389 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZA3KRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:52 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove wakeup_cpu genapic vector
Date: Fri, 30 Jan 2009 11:17:15 +0100
Message-Id: <1233310639-27916-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-9-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
 <1233310639-27916-7-git-send-email-andi@firstfloor.org>
 <1233310639-27916-8-git-send-email-andi@firstfloor.org>
 <1233310639-27916-9-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

... and instead call wakeup_secondary_cpu_via_init directly in smpboot.c

Was only used by es7000 and numaq

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/genapic.h      |    3 --
 arch/x86/include/asm/setup.h        |    1 -
 arch/x86/kernel/bigsmp_32.c         |    1 -
 arch/x86/kernel/es7000_32.c         |    4 ---
 arch/x86/kernel/genapic_flat_64.c   |    2 -
 arch/x86/kernel/genx2apic_cluster.c |    1 -
 arch/x86/kernel/genx2apic_phys.c    |    1 -
 arch/x86/kernel/genx2apic_uv_x.c    |    1 -
 arch/x86/kernel/numaq_32.c          |   42 -----------------------------------
 arch/x86/kernel/probe_32.c          |    1 -
 arch/x86/kernel/setup.c             |    5 ----
 arch/x86/kernel/smpboot.c           |    6 ++--
 arch/x86/kernel/summit_32.c         |    1 -
 13 files changed, 3 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 988e1bc..2047b14 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -71,9 +71,6 @@ struct genapic {
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
 
-	/* wakeup_secondary_cpu */
-	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
-
 	int trampoline_phys_low;
 	int trampoline_phys_high;
 
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 8c8289c..e0b651e 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -20,7 +20,6 @@ static inline void visws_early_detect(void) { }
 static inline int is_visws_box(void) { return 0; }
 #endif
 
-extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
  */
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index e3d31ae..e35e1ff 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -250,7 +250,6 @@ struct genapic apic_bigsmp = {
 	.send_IPI_all			= bigsmp_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index b50f0f5..c94fc21 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -183,14 +183,11 @@ static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 
 static int __init es7000_update_genapic(void)
 {
-	apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
-
 	/* MPENTIUMIII */
 	if (boot_cpu_data.x86 == 6 &&
 	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11)) {
 		es7000_update_genapic_to_cluster();
 		apic->wait_for_init_deassert = NULL;
-		apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
 	}
 
 	return 0;
@@ -786,7 +783,6 @@ struct genapic apic_es7000 = {
 	.send_IPI_all			= es7000_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.wakeup_cpu			= NULL,
 
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index d85b7fc..e87c3bc 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -220,7 +220,6 @@ struct genapic apic_flat =  {
 	.send_IPI_all			= flat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
@@ -361,7 +360,6 @@ struct genapic apic_physflat =  {
 	.send_IPI_all			= physflat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 9fc9582..2e7497b 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -225,7 +225,6 @@ struct genapic apic_x2apic_cluster = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 04fb617..f47c2ff 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -211,7 +211,6 @@ struct genapic apic_x2apic_phys = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index ac0e23b..ba1e3b1 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -284,7 +284,6 @@ struct genapic apic_x2apic_uv_x = {
 	.send_IPI_all			= uv_send_IPI_all,
 	.send_IPI_self			= uv_send_IPI_self,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 9c9b3c7..d412d0e 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -234,49 +234,8 @@ static int __init numaq_setup_ioapic_ids(void)
 	return 1;
 }
 
-/*
- * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
- * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
- * won't ... remember to clear down the APIC, etc later.
- */
-static int __devinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
-{
-	unsigned long send_status, accept_status = 0;
-	int maxlvt;
-
-	/* Target chip */
-	/* Boot on the stack */
-	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
-
-	pr_debug("Waiting for send to finish...\n");
-	send_status = safe_apic_wait_icr_idle();
-
-	/*
-	 * Give the other CPU some time to accept the IPI.
-	 */
-	udelay(200);
-	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
-		maxlvt = lapic_get_maxlvt();
-		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
-			apic_write(APIC_ESR, 0);
-		accept_status = (apic_read(APIC_ESR) & 0xEF);
-	}
-	pr_debug("NMI sent.\n");
-
-	if (send_status)
-		printk(KERN_ERR "APIC never delivered???\n");
-	if (accept_status)
-		printk(KERN_ERR "APIC delivery error (%lx).\n", accept_status);
-
-	return (send_status | accept_status);
-}
-
 static int __init numaq_update_genapic(void)
 {
-	apic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
-
 	return 0;
 }
 
@@ -554,7 +513,6 @@ struct genapic apic_numaq = {
 	.send_IPI_all			= numaq_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= NUMAQ_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= NUMAQ_TRAMPOLINE_PHYS_HIGH,
 
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index 905295e..b01936f 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -116,7 +116,6 @@ struct genapic apic_default = {
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f64e1a4..d6627cf 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -602,11 +602,6 @@ early_param("elfcorehdr", setup_elfcorehdr);
 
 static int __init default_update_genapic(void)
 {
-#ifdef CONFIG_SMP
-	if (!apic->wakeup_cpu)
-		apic->wakeup_cpu = wakeup_secondary_cpu_via_init;
-#endif
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f479bba..2e32144 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -115,7 +115,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 static atomic_t init_deasserted;
 
-
 /* Set if we find a B stepping CPU */
 static int __cpuinitdata smp_b_stepping;
 
@@ -709,7 +708,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
- * Returns zero if CPU booted OK, else error code from ->wakeup_cpu.
+ * Returns zero if CPU booted OK, else error code from 
+ * wakeup_secondary_via_init.
  */
 {
 	unsigned long boot_error = 0;
@@ -796,7 +796,7 @@ do_rest:
 	/*
 	 * Starting actual IPI sequence...
 	 */
-	boot_error = apic->wakeup_cpu(apicid, start_ip);
+	boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
 
 	if (!boot_error) {
 		/*
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index f0dde1c..ec815fe 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -586,7 +586,6 @@ struct genapic apic_summit = {
 	.send_IPI_all			= summit_send_IPI_all,
 	.send_IPI_self			= NULL,
 
-	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
-- 
1.5.6.5

