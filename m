Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbYKPLOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbYKPLOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 06:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYKPLNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 06:13:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:35120 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYKPLNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 06:13:50 -0500
Message-ID: <49200031.2040701@kernel.org>
Date: Sun, 16 Nov 2008 03:12:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
References: <491FDE2A.1010809@kernel.org>
In-Reply-To: <491FDE2A.1010809@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix wakeup path with numaq and es7000

while looking at wakeup_secondary_cpu for WAKE_SECONDARY_VIA_NMI

|#ifdef WAKE_SECONDARY_VIA_NMI
|/*
| * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
| * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
| * won't ... remember to clear down the APIC, etc later.
| */
|static int __devinit
|wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
|{
|        unsigned long send_status, accept_status = 0;
|        int maxlvt;
|...
|        if (APIC_INTEGRATED(apic_version[phys_apicid])) {
|                maxlvt = lapic_get_maxlvt();

there is no warning about undefined phys_apicid...
because WAKE_SECONDARY_VIA_NMI and WAKE_SECONDARY_VIA_INIT can not be defined
at the same time. so NUMAQ is using wrong wakeup_secondary_cpu.
so add wakeup_secondary_cup in x86_quirks

need to add functions in wakecpu.h to genapic for 32bit.
while looking further, about functions in wakecup.h for numaq and es7000 is
different to default to mach_wakecpu.h. but smpboot.c will only use default
mach_wakecpu.h with smphook.h
So need to add mach_wakecpu.h for mach_generic to support numaq and es7000.


Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/bigsmp/apic.h                |    2 -
 arch/x86/include/asm/es7000/apic.h                |    3 -
 arch/x86/include/asm/es7000/wakecpu.h             |   41 +++++---------------
 arch/x86/include/asm/genapic_32.h                 |   17 ++++++++
 arch/x86/include/asm/mach-default/mach_wakecpu.h  |   24 ++++--------
 arch/x86/include/asm/mach-default/smpboot_hooks.h |    8 ++--
 arch/x86/include/asm/mach-generic/mach_wakecpu.h  |   12 ++++++
 arch/x86/include/asm/numaq/wakecpu.h              |   20 ++++------
 arch/x86/include/asm/setup.h                      |    2 +
 arch/x86/kernel/es7000_32.c                       |   44 ++++++++++++----------
 arch/x86/kernel/numaq_32.c                        |    1 
 arch/x86/kernel/smpboot.c                         |   24 +++++++-----
 arch/x86/mach-generic/bigsmp.c                    |    1 
 arch/x86/mach-generic/default.c                   |    1 
 arch/x86/mach-generic/summit.c                    |    1 
 15 files changed, 106 insertions(+), 95 deletions(-)

Index: linux-2.6/arch/x86/include/asm/bigsmp/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/bigsmp/apic.h
+++ linux-2.6/arch/x86/include/asm/bigsmp/apic.h
@@ -24,8 +24,6 @@ static inline cpumask_t target_cpus(void
 #define INT_DELIVERY_MODE	(dest_Fixed)
 #define INT_DEST_MODE		(0)    /* phys delivery to target proc */
 #define NO_BALANCE_IRQ		(0)
-#define WAKE_SECONDARY_VIA_INIT
-
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
Index: linux-2.6/arch/x86/include/asm/es7000/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/es7000/apic.h
+++ linux-2.6/arch/x86/include/asm/es7000/apic.h
@@ -23,8 +23,6 @@ static inline cpumask_t target_cpus(void
 #define INT_DELIVERY_MODE	(dest_LowestPrio)
 #define INT_DEST_MODE		(1)    /* logical delivery broadcast to all procs */
 #define NO_BALANCE_IRQ		(1)
-#undef  WAKE_SECONDARY_VIA_INIT
-#define WAKE_SECONDARY_VIA_MIP
 #else
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define INT_DELIVERY_MODE	(dest_Fixed)
@@ -32,7 +30,6 @@ static inline cpumask_t target_cpus(void
 #define NO_BALANCE_IRQ		(0)
 #undef  APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0x0
-#define WAKE_SECONDARY_VIA_INIT
 #endif
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
Index: linux-2.6/arch/x86/include/asm/es7000/wakecpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/es7000/wakecpu.h
+++ linux-2.6/arch/x86/include/asm/es7000/wakecpu.h
@@ -1,36 +1,12 @@
 #ifndef __ASM_ES7000_WAKECPU_H
 #define __ASM_ES7000_WAKECPU_H
 
-/*
- * This file copes with machines that wakeup secondary CPUs by the
- * INIT, INIT, STARTUP sequence.
- */
-
-#ifdef CONFIG_ES7000_CLUSTERED_APIC
-#define WAKE_SECONDARY_VIA_MIP
-#else
-#define WAKE_SECONDARY_VIA_INIT
-#endif
-
-#ifdef WAKE_SECONDARY_VIA_MIP
-extern int es7000_start_cpu(int cpu, unsigned long eip);
-static inline int
-wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
-{
-	int boot_error = 0;
-	boot_error = es7000_start_cpu(phys_apicid, start_eip);
-	return boot_error;
-}
-#endif
-
-#define TRAMPOLINE_LOW phys_to_virt(0x467)
-#define TRAMPOLINE_HIGH phys_to_virt(0x469)
-
-#define boot_cpu_apicid boot_cpu_physical_apicid
+#define TRAMPOLINE_PHYS_LOW (0x467)
+#define TRAMPOLINE_PHYS_HIGH (0x469)
 
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
-#ifdef WAKE_SECONDARY_VIA_INIT
+#ifndef CONFIG_ES7000_CLUSTERED_APIC
 	while (!atomic_read(deassert))
 		cpu_relax();
 #endif
@@ -50,9 +26,12 @@ static inline void restore_NMI_vector(un
 {
 }
 
-#define inquire_remote_apic(apicid) do {		\
-		if (apic_verbosity >= APIC_DEBUG)	\
-			__inquire_remote_apic(apicid);	\
-	} while (0)
+extern void __inquire_remote_apic(int apicid);
+
+static inline void inquire_remote_apic(int apicid)
+{
+	if (apic_verbosity >= APIC_DEBUG)
+		__inquire_remote_apic(apicid);
+}
 
 #endif /* __ASM_MACH_WAKECPU_H */
Index: linux-2.6/arch/x86/include/asm/genapic_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic_32.h
+++ linux-2.6/arch/x86/include/asm/genapic_32.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_GENAPIC_32_H
 
 #include <asm/mpspec.h>
+#include <asm/atomic.h>
 
 /*
  * Generic APIC driver interface.
@@ -65,6 +66,13 @@ struct genapic {
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
+	int trampoline_phys_low;
+	int trampoline_phys_high;
+	void (*wait_for_init_deassert)(atomic_t *deassert);
+	void (*smp_callin_clear_local_apic)(void);
+	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
+	void (*restore_NMI_vector)(unsigned short *high, unsigned short *low);
+	void (*inquire_remote_apic)(int apicid);
 };
 
 #define APICFUNC(x) .x = x,
@@ -105,13 +113,20 @@ struct genapic {
 	APICFUNC(get_apic_id)				\
 	.apic_id_mask = APIC_ID_MASK,			\
 	APICFUNC(cpu_mask_to_apicid)			\
-	APICFUNC(vector_allocation_domain)			\
+	APICFUNC(vector_allocation_domain)		\
 	APICFUNC(acpi_madt_oem_check)			\
 	IPIFUNC(send_IPI_mask)				\
 	IPIFUNC(send_IPI_allbutself)			\
 	IPIFUNC(send_IPI_all)				\
 	APICFUNC(enable_apic_mode)			\
 	APICFUNC(phys_pkg_id)				\
+	.trampoline_phys_low = TRAMPOLINE_PHYS_LOW,		\
+	.trampoline_phys_high = TRAMPOLINE_PHYS_HIGH,		\
+	APICFUNC(wait_for_init_deassert)		\
+	APICFUNC(smp_callin_clear_local_apic)		\
+	APICFUNC(store_NMI_vector)			\
+	APICFUNC(restore_NMI_vector)			\
+	APICFUNC(inquire_remote_apic)			\
 }
 
 extern struct genapic *genapic;
Index: linux-2.6/arch/x86/include/asm/mach-default/mach_wakecpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ linux-2.6/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -1,17 +1,8 @@
 #ifndef _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 #define _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 
-/* 
- * This file copes with machines that wakeup secondary CPUs by the
- * INIT, INIT, STARTUP sequence.
- */
-
-#define WAKE_SECONDARY_VIA_INIT
-
-#define TRAMPOLINE_LOW phys_to_virt(0x467)
-#define TRAMPOLINE_HIGH phys_to_virt(0x469)
-
-#define boot_cpu_apicid boot_cpu_physical_apicid
+#define TRAMPOLINE_PHYS_LOW (0x467)
+#define TRAMPOLINE_PHYS_HIGH (0x469)
 
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
@@ -33,9 +24,12 @@ static inline void restore_NMI_vector(un
 {
 }
 
-#define inquire_remote_apic(apicid) do {		\
-		if (apic_verbosity >= APIC_DEBUG)	\
-			__inquire_remote_apic(apicid);	\
-	} while (0)
+extern void __inquire_remote_apic(int apicid);
+
+static inline void inquire_remote_apic(int apicid)
+{
+	if (apic_verbosity >= APIC_DEBUG)
+		__inquire_remote_apic(apicid);
+}
 
 #endif /* _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H */
Index: linux-2.6/arch/x86/include/asm/numaq/wakecpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/numaq/wakecpu.h
+++ linux-2.6/arch/x86/include/asm/numaq/wakecpu.h
@@ -3,12 +3,8 @@
 
 /* This file copes with machines that wakeup secondary CPUs by NMIs */
 
-#define WAKE_SECONDARY_VIA_NMI
-
-#define TRAMPOLINE_LOW phys_to_virt(0x8)
-#define TRAMPOLINE_HIGH phys_to_virt(0xa)
-
-#define boot_cpu_apicid boot_cpu_logical_apicid
+#define TRAMPOLINE_PHYS_LOW (0x8)
+#define TRAMPOLINE_PHYS_HIGH (0xa)
 
 /* We don't do anything here because we use NMI's to boot instead */
 static inline void wait_for_init_deassert(atomic_t *deassert)
@@ -27,17 +23,23 @@ static inline void smp_callin_clear_loca
 static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
 {
 	printk("Storing NMI vector\n");
-	*high = *((volatile unsigned short *) TRAMPOLINE_HIGH);
-	*low = *((volatile unsigned short *) TRAMPOLINE_LOW);
+	*high =
+	  *((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH));
+	*low =
+	  *((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW));
 }
 
 static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
 {
 	printk("Restoring NMI vector\n");
-	*((volatile unsigned short *) TRAMPOLINE_HIGH) = *high;
-	*((volatile unsigned short *) TRAMPOLINE_LOW) = *low;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+								 *high;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+								 *low;
 }
 
-#define inquire_remote_apic(apicid) {}
+static inline void inquire_remote_apic(int apicid)
+{
+}
 
 #endif /* __ASM_NUMAQ_WAKECPU_H */
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -20,6 +20,7 @@ static inline void visws_early_detect(vo
 static inline int is_visws_box(void) { return 0; }
 #endif
 
+extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
  */
@@ -43,6 +44,7 @@ struct x86_quirks {
 	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
                                     unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
+	int (*wakeup_secondary_cpu)(int apicid, unsigned long start_eip);
 };
 
 extern struct x86_quirks *x86_quirks;
Index: linux-2.6/arch/x86/kernel/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/es7000_32.c
+++ linux-2.6/arch/x86/kernel/es7000_32.c
@@ -40,6 +40,7 @@
 #include <asm/smp.h>
 #include <asm/apicdef.h>
 #include <mach_mpparse.h>
+#include <asm/setup.h>
 
 /*
  * ES7000 chipsets
@@ -161,6 +162,26 @@ es7000_rename_gsi(int ioapic, int gsi)
 	return gsi;
 }
 
+#ifdef CONFIG_ES7000_CLUSTERED_APIC
+static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
+{
+	unsigned long vect = 0, psaival = 0;
+
+	if (psai == NULL)
+		return -1;
+
+	vect = ((unsigned long)__pa(eip)/0x1000) << 16;
+	psaival = (0x1000000 | vect | cpu);
+
+	while (*psai & 0x1000000)
+		;
+
+	*psai = psaival;
+
+	return 0;
+}
+#endif
+
 void __init
 setup_unisys(void)
 {
@@ -176,6 +197,9 @@ setup_unisys(void)
 	else
 		es7000_plat = ES7000_CLASSIC;
 	ioapic_renumber_irq = es7000_rename_gsi;
+#ifdef CONFIG_ES7000_CLUSTERED_APIC
+	x86_quirks->wakeup_secondary_cpu = wakeup_secondary_cpu_via_mip;
+#endif
 }
 
 /*
@@ -317,26 +341,6 @@ es7000_mip_write(struct mip_reg *mip_reg
 	return status;
 }
 
-int
-es7000_start_cpu(int cpu, unsigned long eip)
-{
-	unsigned long vect = 0, psaival = 0;
-
-	if (psai == NULL)
-		return -1;
-
-	vect = ((unsigned long)__pa(eip)/0x1000) << 16;
-	psaival = (0x1000000 | vect | cpu);
-
-	while (*psai & 0x1000000)
-                ;
-
-	*psai = psaival;
-
-	return 0;
-
-}
-
 void __init
 es7000_sw_apic(void)
 {
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -250,6 +250,7 @@ static struct x86_quirks numaq_x86_quirk
 	.mpc_oem_pci_bus	= mpc_oem_pci_bus,
 	.smp_read_mpc_oem	= smp_read_mpc_oem,
 	.setup_ioapic_ids	= numaq_setup_ioapic_ids,
+	.wakeup_secondary_cpu	= wakeup_secondary_cpu_via_nmi,
 };
 
 void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -62,6 +62,7 @@
 #include <asm/mtrr.h>
 #include <asm/vmi.h>
 #include <asm/genapic.h>
+#include <asm/setup.h>
 #include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
@@ -536,7 +537,7 @@ static void impress_friends(void)
 	pr_debug("Before bogocount - setting activated=1.\n");
 }
 
-static inline void __inquire_remote_apic(int apicid)
+void __inquire_remote_apic(int apicid)
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
 	char *names[] = { "ID", "VERSION", "SPIV" };
@@ -575,14 +576,13 @@ static inline void __inquire_remote_apic
 	}
 }
 
-#ifdef WAKE_SECONDARY_VIA_NMI
 /*
  * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-static int __devinit
-wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
+int __devinit
+wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
@@ -599,7 +599,7 @@ wakeup_secondary_cpu(int logical_apicid,
 	 * Give the other CPU some time to accept the IPI.
 	 */
 	udelay(200);
-	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		maxlvt = lapic_get_maxlvt();
 		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
@@ -614,11 +614,9 @@ wakeup_secondary_cpu(int logical_apicid,
 
 	return (send_status | accept_status);
 }
-#endif	/* WAKE_SECONDARY_VIA_NMI */
 
-#ifdef WAKE_SECONDARY_VIA_INIT
 static int __devinit
-wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
+wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt, num_starts, j;
@@ -737,7 +735,15 @@ wakeup_secondary_cpu(int phys_apicid, un
 
 	return (send_status | accept_status);
 }
-#endif	/* WAKE_SECONDARY_VIA_INIT */
+
+static int __devinit
+wakeup_secondary_cpu(int apicid, unsigned long start_eip)
+{
+	if (x86_quirks->wakeup_secondary_cpu)
+		return x86_quirks->wakeup_secondary_cpu(apicid, start_eip);
+
+	return wakeup_secondary_cpu_via_init(apicid, start_eip);
+}
 
 struct create_idle {
 	struct work_struct work;
Index: linux-2.6/arch/x86/mach-generic/bigsmp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/bigsmp.c
+++ linux-2.6/arch/x86/mach-generic/bigsmp.c
@@ -17,6 +17,7 @@
 #include <asm/bigsmp/apic.h>
 #include <asm/bigsmp/ipi.h>
 #include <asm/mach-default/mach_mpparse.h>
+#include <asm/mach-default/mach_wakecpu.h>
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
Index: linux-2.6/arch/x86/mach-generic/default.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/default.c
+++ linux-2.6/arch/x86/mach-generic/default.c
@@ -16,6 +16,7 @@
 #include <asm/mach-default/mach_apic.h>
 #include <asm/mach-default/mach_ipi.h>
 #include <asm/mach-default/mach_mpparse.h>
+#include <asm/mach-default/mach_wakecpu.h>
 
 /* should be called last. */
 static int probe_default(void)
Index: linux-2.6/arch/x86/mach-generic/summit.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/summit.c
+++ linux-2.6/arch/x86/mach-generic/summit.c
@@ -16,6 +16,7 @@
 #include <asm/summit/apic.h>
 #include <asm/summit/ipi.h>
 #include <asm/summit/mpparse.h>
+#include <asm/mach-default/mach_wakecpu.h>
 
 static int probe_summit(void)
 {
Index: linux-2.6/arch/x86/include/asm/mach-generic/mach_wakecpu.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/include/asm/mach-generic/mach_wakecpu.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
+#define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
+
+#define TRAMPOLINE_PHYS_LOW (genapic->trampoline_phys_low)
+#define TRAMPOLINE_PHYS_HIGH (genapic->trampoline_phys_high)
+#define wait_for_init_deassert (genapic->wait_for_init_deassert)
+#define smp_callin_clear_local_apic (genapic->smp_callin_clear_local_apic)
+#define store_NMI_vector (genapic->store_NMI_vector)
+#define restore_NMI_vector (genapic->restore_NMI_vector)
+#define inquire_remote_apic (genapic->inquire_remote_apic)
+
+#endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
Index: linux-2.6/arch/x86/include/asm/mach-default/smpboot_hooks.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mach-default/smpboot_hooks.h
+++ linux-2.6/arch/x86/include/asm/mach-default/smpboot_hooks.h
@@ -13,9 +13,11 @@ static inline void smpboot_setup_warm_re
 	CMOS_WRITE(0xa, 0xf);
 	local_flush_tlb();
 	pr_debug("1.\n");
-	*((volatile unsigned short *) TRAMPOLINE_HIGH) = start_eip >> 4;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+								 start_eip >> 4;
 	pr_debug("2.\n");
-	*((volatile unsigned short *) TRAMPOLINE_LOW) = start_eip & 0xf;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+							 start_eip & 0xf;
 	pr_debug("3.\n");
 }
 
@@ -32,7 +34,7 @@ static inline void smpboot_restore_warm_
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *) phys_to_virt(0x467)) = 0;
+	*((volatile long *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)

