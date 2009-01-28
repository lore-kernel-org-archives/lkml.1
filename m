Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbZA2APA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbZA2APA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbZA1XqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:53201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbZA1XqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:14 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 079/114] x86, bigsmp: consolidate header code
Date: Wed, 28 Jan 2009 23:42:25 +0000
Message-Id: <1233186180-29883-80-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the asm/bigsmp/*.h definitions into bigsmp_32.c.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/bigsmp_32.c |  163 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 159 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index 626f45c..b1f9193 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -12,10 +12,165 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
-#include <asm/bigsmp/apicdef.h>
 #include <linux/smp.h>
-#include <asm/bigsmp/apic.h>
-#include <asm/bigsmp/ipi.h>
+
+
+static inline unsigned bigsmp_get_apic_id(unsigned long x)
+{
+	return (x >> 24) & 0xFF;
+}
+
+#define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
+
+static inline int bigsmp_apic_id_registered(void)
+{
+	return 1;
+}
+
+static inline const cpumask_t *bigsmp_target_cpus(void)
+{
+#ifdef CONFIG_SMP
+	return &cpu_online_map;
+#else
+	return &cpumask_of_cpu(0);
+#endif
+}
+
+#define APIC_DFR_VALUE		(APIC_DFR_FLAT)
+
+static inline unsigned long
+bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return 0;
+}
+
+static inline unsigned long bigsmp_check_apicid_present(int bit)
+{
+	return 1;
+}
+
+static inline unsigned long calculate_ldr(int cpu)
+{
+	unsigned long val, id;
+	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
+	id = xapic_phys_to_log_apicid(cpu);
+	val |= SET_APIC_LOGICAL_ID(id);
+	return val;
+}
+
+/*
+ * Set up the logical destination ID.
+ *
+ * Intel recommends to set DFR, LDR and TPR before enabling
+ * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
+ * document number 292116).  So here it goes...
+ */
+static inline void bigsmp_init_apic_ldr(void)
+{
+	unsigned long val;
+	int cpu = smp_processor_id();
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
+	val = calculate_ldr(cpu);
+	apic_write(APIC_LDR, val);
+}
+
+static inline void bigsmp_setup_apic_routing(void)
+{
+	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
+		"Physflat", nr_ioapics);
+}
+
+static inline int bigsmp_apicid_to_node(int logical_apicid)
+{
+	return apicid_2_node[hard_smp_processor_id()];
+}
+
+static inline int bigsmp_cpu_present_to_apicid(int mps_cpu)
+{
+	if (mps_cpu < nr_cpu_ids)
+		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
+
+	return BAD_APICID;
+}
+
+static inline physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
+{
+	return physid_mask_of_physid(phys_apicid);
+}
+
+extern u8 cpu_2_logical_apicid[];
+/* Mapping from cpu number to logical apicid */
+static inline int bigsmp_cpu_to_logical_apicid(int cpu)
+{
+	if (cpu >= nr_cpu_ids)
+		return BAD_APICID;
+	return cpu_physical_id(cpu);
+}
+
+static inline physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	/* For clustered we don't have a good way to do this yet - hack */
+	return physids_promote(0xFFL);
+}
+
+static inline void bigsmp_setup_portio_remap(void)
+{
+}
+
+static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return 1;
+}
+
+/* As we are using single CPU as destination, pick only one CPU here */
+static inline unsigned int bigsmp_cpu_mask_to_apicid(const cpumask_t *cpumask)
+{
+	return bigsmp_cpu_to_logical_apicid(first_cpu(*cpumask));
+}
+
+static inline unsigned int
+bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			      const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask) {
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	}
+	if (cpu < nr_cpu_ids)
+		return bigsmp_cpu_to_logical_apicid(cpu);
+
+	return BAD_APICID;
+}
+
+static inline int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
+
+void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+
+static inline void bigsmp_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void bigsmp_send_IPI_allbutself(int vector)
+{
+	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+static inline void bigsmp_send_IPI_all(int vector)
+{
+	bigsmp_send_IPI_mask(cpu_online_mask, vector);
+}
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
@@ -95,7 +250,7 @@ struct genapic apic_bigsmp = {
 	.cpu_mask_to_apicid		= bigsmp_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= bigsmp_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= default_send_IPI_mask,
+	.send_IPI_mask			= bigsmp_send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
 	.send_IPI_allbutself		= bigsmp_send_IPI_allbutself,
 	.send_IPI_all			= bigsmp_send_IPI_all,
-- 
1.6.0.2

