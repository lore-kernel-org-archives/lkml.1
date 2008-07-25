Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYGYJTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYGYJTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYGYJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:18:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:13081 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYGYJSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=eFZcxqZifz1C2Sf1yt8qL0pS1v2v7yTKMK66EULKVF4TNFkHAhKxSfzbAEbjhp87c6
         iw8gQKpph0MVSWscHxKsCwO24rRGVBHjFrEYdVqD0oIWkgrlI+ftCbRqNPvCpNOozRfj
         JafVbDyKgXU+pN9G0RsFzxvDmRUvq9Lv0riVw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: mach-bigsmp to bigsmp
Date: Fri, 25 Jul 2008 02:17:21 -0700
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
References: <200807250214.28786.yhlu.kernel@gmail.com> <200807250215.54393.yhlu.kernel@gmail.com> <200807250216.37616.yhlu.kernel@gmail.com>
In-Reply-To: <200807250216.37616.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807250217.21831.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mach-generic/bigsmp.c             |    6 -
 include/asm-x86/bigsmp/apic.h              |  144 +++++++++++++++++++++++++++++
 include/asm-x86/bigsmp/apicdef.h           |   13 ++
 include/asm-x86/bigsmp/ipi.h               |   25 +++++
 include/asm-x86/mach-bigsmp/mach_apic.h    |  144 -----------------------------
 include/asm-x86/mach-bigsmp/mach_apicdef.h |   13 --
 include/asm-x86/mach-bigsmp/mach_ipi.h     |   25 -----
 7 files changed, 185 insertions(+), 185 deletions(-)

Index: linux-2.6/arch/x86/mach-generic/bigsmp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/bigsmp.c
+++ linux-2.6/arch/x86/mach-generic/bigsmp.c
@@ -12,10 +12,10 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
-#include <asm/mach-bigsmp/mach_apicdef.h>
+#include <asm/bigsmp/apicdef.h>
 #include <linux/smp.h>
-#include <asm/mach-bigsmp/mach_apic.h>
-#include <asm/mach-bigsmp/mach_ipi.h>
+#include <asm/bigsmp/apic.h>
+#include <asm/bigsmp/ipi.h>
 #include <asm/mach-default/mach_mpparse.h>
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
Index: linux-2.6/include/asm-x86/bigsmp/apic.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/bigsmp/apic.h
@@ -0,0 +1,144 @@
+#ifndef __ASM_MACH_APIC_H
+#define __ASM_MACH_APIC_H
+
+#define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
+#define esr_disable (1)
+
+static inline int apic_id_registered(void)
+{
+	return (1);
+}
+
+/* Round robin the irqs amoung the online cpus */
+static inline cpumask_t target_cpus(void)
+{
+	static unsigned long cpu = NR_CPUS;
+	do {
+		if (cpu >= NR_CPUS)
+			cpu = first_cpu(cpu_online_map);
+		else
+			cpu = next_cpu(cpu, cpu_online_map);
+	} while (cpu >= NR_CPUS);
+	return cpumask_of_cpu(cpu);
+}
+
+#undef APIC_DEST_LOGICAL
+#define APIC_DEST_LOGICAL	0
+#define TARGET_CPUS		(target_cpus())
+#define APIC_DFR_VALUE		(APIC_DFR_FLAT)
+#define INT_DELIVERY_MODE	(dest_Fixed)
+#define INT_DEST_MODE		(0)    /* phys delivery to target proc */
+#define NO_BALANCE_IRQ		(0)
+#define WAKE_SECONDARY_VIA_INIT
+
+
+static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return (0);
+}
+
+static inline unsigned long check_apicid_present(int bit)
+{
+	return (1);
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
+static inline void init_apic_ldr(void)
+{
+	unsigned long val;
+	int cpu = smp_processor_id();
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
+	val = calculate_ldr(cpu);
+	apic_write(APIC_LDR, val);
+}
+
+static inline void setup_apic_routing(void)
+{
+	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
+		"Physflat", nr_ioapics);
+}
+
+static inline int multi_timer_check(int apic, int irq)
+{
+	return (0);
+}
+
+static inline int apicid_to_node(int logical_apicid)
+{
+	return apicid_2_node[hard_smp_processor_id()];
+}
+
+static inline int cpu_present_to_apicid(int mps_cpu)
+{
+	if (mps_cpu < NR_CPUS)
+		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
+
+	return BAD_APICID;
+}
+
+static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
+{
+	return physid_mask_of_physid(phys_apicid);
+}
+
+extern u8 cpu_2_logical_apicid[];
+/* Mapping from cpu number to logical apicid */
+static inline int cpu_to_logical_apicid(int cpu)
+{
+	if (cpu >= NR_CPUS)
+		return BAD_APICID;
+	return cpu_physical_id(cpu);
+}
+
+static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	/* For clustered we don't have a good way to do this yet - hack */
+	return physids_promote(0xFFL);
+}
+
+static inline void setup_portio_remap(void)
+{
+}
+
+static inline void enable_apic_mode(void)
+{
+}
+
+static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return (1);
+}
+
+/* As we are using single CPU as destination, pick only one CPU here */
+static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	int cpu;
+	int apicid;	
+
+	cpu = first_cpu(cpumask);
+	apicid = cpu_to_logical_apicid(cpu);
+	return apicid;
+}
+
+static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
+
+#endif /* __ASM_MACH_APIC_H */
Index: linux-2.6/include/asm-x86/bigsmp/apicdef.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/bigsmp/apicdef.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_MACH_APICDEF_H
+#define __ASM_MACH_APICDEF_H
+
+#define		APIC_ID_MASK		(0xFF<<24)
+
+static inline unsigned get_apic_id(unsigned long x)
+{
+	return (((x)>>24)&0xFF);
+}
+
+#define		GET_APIC_ID(x)	get_apic_id(x)
+
+#endif
Index: linux-2.6/include/asm-x86/bigsmp/ipi.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/bigsmp/ipi.h
@@ -0,0 +1,25 @@
+#ifndef __ASM_MACH_IPI_H
+#define __ASM_MACH_IPI_H
+
+void send_IPI_mask_sequence(cpumask_t mask, int vector);
+
+static inline void send_IPI_mask(cpumask_t mask, int vector)
+{
+	send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), mask);
+
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, vector);
+}
+
+static inline void send_IPI_all(int vector)
+{
+	send_IPI_mask(cpu_online_map, vector);
+}
+
+#endif /* __ASM_MACH_IPI_H */
Index: linux-2.6/include/asm-x86/mach-bigsmp/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-bigsmp/mach_apic.h
+++ /dev/null
@@ -1,144 +0,0 @@
-#ifndef __ASM_MACH_APIC_H
-#define __ASM_MACH_APIC_H
-
-#define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
-#define esr_disable (1)
-
-static inline int apic_id_registered(void)
-{
-	return (1);
-}
-
-/* Round robin the irqs amoung the online cpus */
-static inline cpumask_t target_cpus(void)
-{ 
-	static unsigned long cpu = NR_CPUS;
-	do {
-		if (cpu >= NR_CPUS)
-			cpu = first_cpu(cpu_online_map);
-		else
-			cpu = next_cpu(cpu, cpu_online_map);
-	} while (cpu >= NR_CPUS);
-	return cpumask_of_cpu(cpu);
-}
-
-#undef APIC_DEST_LOGICAL
-#define APIC_DEST_LOGICAL 	0
-#define TARGET_CPUS		(target_cpus())
-#define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define INT_DELIVERY_MODE	(dest_Fixed)
-#define INT_DEST_MODE		(0)    /* phys delivery to target proc */
-#define NO_BALANCE_IRQ		(0)
-#define WAKE_SECONDARY_VIA_INIT
-
-
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return (0);
-}
-
-static inline unsigned long check_apicid_present(int bit)
-{
-	return (1);
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
-static inline void init_apic_ldr(void)
-{
-	unsigned long val;
-	int cpu = smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
-}
-
-static inline void setup_apic_routing(void)
-{
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
-		"Physflat", nr_ioapics);
-}
-
-static inline int multi_timer_check(int apic, int irq)
-{
-	return (0);
-}
-
-static inline int apicid_to_node(int logical_apicid)
-{
-	return apicid_2_node[hard_smp_processor_id()];
-}
-
-static inline int cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < NR_CPUS)
-		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
-
-	return BAD_APICID;
-}
-
-static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
-extern u8 cpu_2_logical_apicid[];
-/* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= NR_CPUS)
-		return BAD_APICID;
-	return cpu_physical_id(cpu);
-}
-
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xFFL);
-}
-
-static inline void setup_portio_remap(void)
-{
-}
-
-static inline void enable_apic_mode(void)
-{
-}
-
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return (1);
-}
-
-/* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	int cpu;
-	int apicid;	
-
-	cpu = first_cpu(cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
-	return apicid;
-}
-
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-#endif /* __ASM_MACH_APIC_H */
Index: linux-2.6/include/asm-x86/mach-bigsmp/mach_apicdef.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-bigsmp/mach_apicdef.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __ASM_MACH_APICDEF_H
-#define __ASM_MACH_APICDEF_H
-
-#define		APIC_ID_MASK		(0xFF<<24)
-
-static inline unsigned get_apic_id(unsigned long x) 
-{ 
-	return (((x)>>24)&0xFF);
-} 
-
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
-#endif
Index: linux-2.6/include/asm-x86/mach-bigsmp/mach_ipi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-bigsmp/mach_ipi.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __ASM_MACH_IPI_H
-#define __ASM_MACH_IPI_H
-
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
-
-static inline void send_IPI_mask(cpumask_t mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void send_IPI_allbutself(int vector)
-{
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
-}
-
-static inline void send_IPI_all(int vector)
-{
-	send_IPI_mask(cpu_online_map, vector);
-}
-
-#endif /* __ASM_MACH_IPI_H */
