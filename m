Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYCXTxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYCXTxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYCXTxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:53:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYCXTxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:53:19 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: [PATCH 2/2] move apic declarations to mach_apic.h
Date: Mon, 24 Mar 2008 16:52:41 -0300
Message-Id: <1206388361-17265-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206388361-17265-1-git-send-email-gcosta@redhat.com>
References: <1206388361-17265-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

take them out of the x86_64-specific asm/mach_apic.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_64.c                |    2 -
 arch/x86/kernel/io_apic_64.c             |    2 -
 arch/x86/kernel/setup_64.c               |    2 -
 include/asm-x86/mach-default/mach_apic.h |   80 ++++++++++++++++--------------
 include/asm-x86/mach_apic.h              |   26 ----------
 5 files changed, 46 insertions(+), 66 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 206278f..7dd6250 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -34,7 +34,6 @@ #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/hpet.h>
 #include <asm/pgalloc.h>
-#include <asm/mach_apic.h>
 #include <asm/nmi.h>
 #include <asm/idle.h>
 #include <asm/proto.h>
@@ -42,6 +41,7 @@ #include <asm/timex.h>
 #include <asm/apic.h>
 
 #include <mach_ipi.h>
+#include <mach_apic.h>
 
 int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 7d5cdf3..6dd3362 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -43,7 +43,6 @@ #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/desc.h>
 #include <asm/proto.h>
-#include <asm/mach_apic.h>
 #include <asm/acpi.h>
 #include <asm/dma.h>
 #include <asm/nmi.h>
@@ -51,6 +50,7 @@ #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 
 #include <mach_ipi.h>
+#include <mach_apic.h>
 
 struct irq_cfg {
 	cpumask_t domain;
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 3f1dc97..08f9591 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -60,7 +60,6 @@ #include <asm/mpspec.h>
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
-#include <asm/mach_apic.h>
 #include <asm/numa.h>
 #include <asm/sections.h>
 #include <asm/dmi.h>
@@ -69,6 +68,7 @@ #include <asm/mce.h>
 #include <asm/ds.h>
 #include <asm/topology.h>
 
+#include <mach_apic.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
diff --git a/include/asm-x86/mach-default/mach_apic.h b/include/asm-x86/mach-default/mach_apic.h
index 13900e8..3f49a3a 100644
--- a/include/asm-x86/mach-default/mach_apic.h
+++ b/include/asm-x86/mach-default/mach_apic.h
@@ -14,24 +14,25 @@ #else
 	return cpumask_of_cpu(0);
 #endif
 } 
-#define TARGET_CPUS (target_cpus())
 
 #define NO_BALANCE_IRQ (0)
 #define esr_disable (0)
 
+#ifdef CONFIG_X86_64
+#include <asm/genapic.h>
+#define INT_DELIVERY_MODE (genapic->int_delivery_mode)
+#define INT_DEST_MODE (genapic->int_dest_mode)
+#define TARGET_CPUS	  (genapic->target_cpus())
+#define apic_id_registered (genapic->apic_id_registered)
+#define init_apic_ldr (genapic->init_apic_ldr)
+#define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
+#define phys_pkg_id	(genapic->phys_pkg_id)
+#define vector_allocation_domain    (genapic->vector_allocation_domain)
+extern void setup_apic_routing(void);
+#else
 #define INT_DELIVERY_MODE dest_LowestPrio
 #define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
-
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return physid_isset(apicid, bitmap);
-}
-
-static inline unsigned long check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
+#define TARGET_CPUS (target_cpus())
 /*
  * Set up the logical destination ID.
  *
@@ -49,32 +50,52 @@ static inline void init_apic_ldr(void)
 	apic_write_around(APIC_LDR, val);
 }
 
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+static inline int apic_id_registered(void)
 {
-	return phys_map;
+	return physid_isset(GET_APIC_ID(apic_read(APIC_ID)), phys_cpu_present_map);
+}
+
+static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	return cpus_addr(cpumask)[0];
+}
+
+static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
 }
 
-#ifdef CONFIG_X86_64
-extern void setup_apic_routing(void);
-#else
 static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 					"Flat", nr_ioapics);
 }
-#endif
 
-static inline int multi_timer_check(int apic, int irq)
+static inline int apicid_to_node(int logical_apicid)
 {
 	return 0;
 }
+#endif
 
-#ifdef CONFIG_X86_32
-static inline int apicid_to_node(int logical_apicid)
+static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return physid_isset(apicid, bitmap);
+}
+
+static inline unsigned long check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
+
+static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	return phys_map;
+}
+
+static inline int multi_timer_check(int apic, int irq)
 {
 	return 0;
 }
-#endif
 
 /* Mapping from cpu number to logical apicid */
 static inline int cpu_to_logical_apicid(int cpu)
@@ -109,23 +130,8 @@ static inline int check_phys_apicid_pres
 	return physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map);
 }
 
-static inline int apic_id_registered(void)
-{
-	return physid_isset(GET_APIC_ID(apic_read(APIC_ID)), phys_cpu_present_map);
-}
-
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	return cpus_addr(cpumask)[0];
-}
-
 static inline void enable_apic_mode(void)
 {
 }
 
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
 #endif /* __ASM_MACH_APIC_H */
diff --git a/include/asm-x86/mach_apic.h b/include/asm-x86/mach_apic.h
deleted file mode 100644
index 1bc68c0..0000000
--- a/include/asm-x86/mach_apic.h
+++ /dev/null
@@ -1,26 +0,0 @@
-#ifndef __ASM_MACH_APIC_H
-#define __ASM_MACH_APIC_H
-
-/*
- * Copyright 2004 James Cleverdon, IBM.
- * Subject to the GNU Public License, v.2
- *
- * Generic APIC sub-arch defines.
- *
- * Hacked for x86-64 by James Cleverdon from i386 architecture code by
- * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
- * James Cleverdon.
- */
-
-#include <asm/genapic.h>
-
-#define INT_DELIVERY_MODE (genapic->int_delivery_mode)
-#define INT_DEST_MODE (genapic->int_dest_mode)
-#define TARGET_CPUS	  (genapic->target_cpus())
-#define vector_allocation_domain	(genapic->vector_allocation_domain)
-#define apic_id_registered (genapic->apic_id_registered)
-#define init_apic_ldr (genapic->init_apic_ldr)
-#define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
-#define phys_pkg_id	(genapic->phys_pkg_id)
-
-#endif /* __ASM_MACH_APIC_H */
-- 
1.4.2

