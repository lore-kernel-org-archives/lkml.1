Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbZA1Xpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbZA1Xpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbZA1Xn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:37356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684AbZA1Xn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:27 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 002/114] x86, genapic: refactor genapic_32.h
Date: Wed, 28 Jan 2009 23:41:08 +0000
Message-Id: <1233186180-29883-3-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: pre unification cleanup

Make genapic_32.h similar to genapic_64.h: reorder fields, unify types
and bring in new entries.

No existing functionality is affected.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic_32.h |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 4334502..5808b7d 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -21,19 +21,28 @@ struct mpc_cpu;
 
 struct genapic {
 	char *name;
-	int (*probe)(void);
 
+	int (*probe)(void);
+	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 	int (*apic_id_registered)(void);
+
+	u32 int_delivery_mode;
+	u32 int_dest_mode;
+
 	const struct cpumask *(*target_cpus)(void);
-	int int_delivery_mode;
-	int int_dest_mode;
+
 	int ESR_DISABLE;
+
 	int apic_destination_logical;
 	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
+
 	int no_balance_irq;
 	int no_ioapic_check;
+
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
+
 	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
 
 	void (*setup_apic_routing)(void);
@@ -45,22 +54,27 @@ struct genapic {
 	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
 	void (*enable_apic_mode)(void);
+#ifdef CONFIG_X86_32
 	u32 (*phys_pkg_id)(u32 cpuid_apic, int index_msb);
+#else
+	unsigned int (*phys_pkg_id)(int index_msb);
+#endif
 
-	/* mpparse */
-	/* When one of the next two hooks returns 1 the genapic
-	   is switched to this. Essentially they are additional probe
-	   functions. */
+	/*
+	 * When one of the next two hooks returns 1 the genapic
+	 * is switched to this. Essentially they are additional
+	 * probe functions:
+	 */
 	int (*mps_oem_check)(struct mpc_table *mpc, char *oem,
 			     char *productid);
-	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
-	unsigned (*get_apic_id)(unsigned long x);
+	unsigned int (*get_apic_id)(unsigned long x);
+	unsigned long (*set_apic_id)(unsigned int id);
 	unsigned long apic_id_mask;
+
 	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
 	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
 					       const struct cpumask *andmask);
-	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 
 #ifdef CONFIG_SMP
 	/* ipi */
@@ -69,8 +83,11 @@ struct genapic {
 					 int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
+	void (*send_IPI_self)(int vector);
 #endif
+	/* wakeup_secondary_cpu */
 	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
+
 	int trampoline_phys_low;
 	int trampoline_phys_high;
 	void (*wait_for_init_deassert)(atomic_t *deassert);
-- 
1.6.0.2

