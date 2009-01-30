Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZA3Dak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZA3Dak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZA3Dac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:30:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:46672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZA3Dab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:30:31 -0500
Message-ID: <49827414.2020908@kernel.org>
Date: Thu, 29 Jan 2009 19:29:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove left over files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

remove deaf files

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/bigsmp/apic.h    |  138 ----------------------------------
 arch/x86/include/asm/bigsmp/apicdef.h |    9 --
 arch/x86/include/asm/bigsmp/ipi.h     |   22 -----
 arch/x86/mach-default/Makefile        |    5 -
 4 files changed, 174 deletions(-)

Index: linux-2.6/arch/x86/include/asm/bigsmp/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/bigsmp/apic.h
+++ /dev/null
@@ -1,138 +0,0 @@
-#ifndef __ASM_MACH_APIC_H
-#define __ASM_MACH_APIC_H
-
-#define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
-
-static inline int bigsmp_apic_id_registered(void)
-{
-	return 1;
-}
-
-static inline const cpumask_t *bigsmp_target_cpus(void)
-{
-#ifdef CONFIG_SMP
-	return &cpu_online_map;
-#else
-	return &cpumask_of_cpu(0);
-#endif
-}
-
-#define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-
-static inline unsigned long
-bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return 0;
-}
-
-static inline unsigned long bigsmp_check_apicid_present(int bit)
-{
-	return 1;
-}
-
-static inline unsigned long calculate_ldr(int cpu)
-{
-	unsigned long val, id;
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	id = xapic_phys_to_log_apicid(cpu);
-	val |= SET_APIC_LOGICAL_ID(id);
-	return val;
-}
-
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-static inline void bigsmp_init_apic_ldr(void)
-{
-	unsigned long val;
-	int cpu = smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
-}
-
-static inline void bigsmp_setup_apic_routing(void)
-{
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
-		"Physflat", nr_ioapics);
-}
-
-static inline int bigsmp_apicid_to_node(int logical_apicid)
-{
-	return apicid_2_node[hard_smp_processor_id()];
-}
-
-static inline int bigsmp_cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < nr_cpu_ids)
-		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
-
-	return BAD_APICID;
-}
-
-static inline physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
-extern u8 cpu_2_logical_apicid[];
-/* Mapping from cpu number to logical apicid */
-static inline int bigsmp_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_physical_id(cpu);
-}
-
-static inline physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xFFL);
-}
-
-static inline void bigsmp_setup_portio_remap(void)
-{
-}
-
-static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return 1;
-}
-
-/* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int bigsmp_cpu_mask_to_apicid(const cpumask_t *cpumask)
-{
-	return bigsmp_cpu_to_logical_apicid(first_cpu(*cpumask));
-}
-
-static inline unsigned int
-bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			      const struct cpumask *andmask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
-	}
-	if (cpu < nr_cpu_ids)
-		return bigsmp_cpu_to_logical_apicid(cpu);
-
-	return BAD_APICID;
-}
-
-static inline int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-#endif /* __ASM_MACH_APIC_H */
Index: linux-2.6/arch/x86/include/asm/bigsmp/apicdef.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/bigsmp/apicdef.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_MACH_APICDEF_H
-#define __ASM_MACH_APICDEF_H
-
-static inline unsigned bigsmp_get_apic_id(unsigned long x)
-{
-	return (x >> 24) & 0xFF;
-}
-
-#endif
Index: linux-2.6/arch/x86/include/asm/bigsmp/ipi.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/bigsmp/ipi.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef __ASM_MACH_IPI_H
-#define __ASM_MACH_IPI_H
-
-void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
-static inline void default_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void bigsmp_send_IPI_allbutself(int vector)
-{
-	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
-}
-
-static inline void bigsmp_send_IPI_all(int vector)
-{
-	default_send_IPI_mask(cpu_online_mask, vector);
-}
-
-#endif /* __ASM_MACH_IPI_H */
Index: linux-2.6/arch/x86/mach-default/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/mach-default/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-obj-y				:= setup.o
