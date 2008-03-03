Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYCCRXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYCCRXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758963AbYCCRPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786AbYCCRP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:29 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 25/52] create ipi.c
Date: Mon,  3 Mar 2008 14:12:53 -0300
Message-Id: <1204564400-17636-26-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-25-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all ipi and apic related functions
from smp_32.c to ipi.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile |    2 +-
 arch/x86/kernel/ipi.c    |  178 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smp_32.c |  153 ---------------------------------------
 3 files changed, 179 insertions(+), 154 deletions(-)
 create mode 100644 arch/x86/kernel/ipi.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0a4b088..e3b01f9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o smp.o
-obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o
+obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
new file mode 100644
index 0000000..c0df7b8
--- /dev/null
+++ b/arch/x86/kernel/ipi.c
@@ -0,0 +1,178 @@
+#include <linux/cpumask.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/kernel_stat.h>
+#include <linux/mc146818rtc.h>
+#include <linux/cache.h>
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
+#include <linux/module.h>
+
+#include <asm/smp.h>
+#include <asm/mtrr.h>
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+#include <asm/apic.h>
+#include <asm/proto.h>
+
+#ifdef CONFIG_X86_32
+#include <mach_apic.h>
+/*
+ * the following functions deal with sending IPIs between CPUs.
+ *
+ * We use 'broadcast', CPU->CPU IPIs and self-IPIs too.
+ */
+
+static inline int __prepare_ICR(unsigned int shortcut, int vector)
+{
+	unsigned int icr = shortcut | APIC_DEST_LOGICAL;
+
+	switch (vector) {
+	default:
+		icr |= APIC_DM_FIXED | vector;
+		break;
+	case NMI_VECTOR:
+		icr |= APIC_DM_NMI;
+		break;
+	}
+	return icr;
+}
+
+static inline int __prepare_ICR2(unsigned int mask)
+{
+	return SET_APIC_DEST_FIELD(mask);
+}
+
+void __send_IPI_shortcut(unsigned int shortcut, int vector)
+{
+	/*
+	 * Subtle. In the case of the 'never do double writes' workaround
+	 * we have to lock out interrupts to be safe.  As we don't care
+	 * of the value read we use an atomic rmw access to avoid costly
+	 * cli/sti.  Otherwise we use an even cheaper single atomic write
+	 * to the APIC.
+	 */
+	unsigned int cfg;
+
+	/*
+	 * Wait for idle.
+	 */
+	apic_wait_icr_idle();
+
+	/*
+	 * No need to touch the target chip field
+	 */
+	cfg = __prepare_ICR(shortcut, vector);
+
+	/*
+	 * Send the IPI. The write to APIC_ICR fires this off.
+	 */
+	apic_write_around(APIC_ICR, cfg);
+}
+
+void send_IPI_self(int vector)
+{
+	__send_IPI_shortcut(APIC_DEST_SELF, vector);
+}
+
+/*
+ * This is used to send an IPI with no shorthand notation (the destination is
+ * specified in bits 56 to 63 of the ICR).
+ */
+static inline void __send_IPI_dest_field(unsigned long mask, int vector)
+{
+	unsigned long cfg;
+
+	/*
+	 * Wait for idle.
+	 */
+	if (unlikely(vector == NMI_VECTOR))
+		safe_apic_wait_icr_idle();
+	else
+		apic_wait_icr_idle();
+
+	/*
+	 * prepare target chip field
+	 */
+	cfg = __prepare_ICR2(mask);
+	apic_write_around(APIC_ICR2, cfg);
+
+	/*
+	 * program the ICR
+	 */
+	cfg = __prepare_ICR(0, vector);
+
+	/*
+	 * Send the IPI. The write to APIC_ICR fires this off.
+	 */
+	apic_write_around(APIC_ICR, cfg);
+}
+
+/*
+ * This is only used on smaller machines.
+ */
+void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
+{
+	unsigned long mask = cpus_addr(cpumask)[0];
+	unsigned long flags;
+
+	local_irq_save(flags);
+	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
+	__send_IPI_dest_field(mask, vector);
+	local_irq_restore(flags);
+}
+
+void send_IPI_mask_sequence(cpumask_t mask, int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+
+	/*
+	 * Hack. The clustered APIC addressing mode doesn't allow us to send
+	 * to an arbitrary mask, so I do a unicasts to each CPU instead. This
+	 * should be modified to do 1 message per cluster ID - mbligh
+	 */
+
+	local_irq_save(flags);
+	for_each_possible_cpu(query_cpu) {
+		if (cpu_isset(query_cpu, mask)) {
+			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
+					      vector);
+		}
+	}
+	local_irq_restore(flags);
+}
+
+/* must come after the send_IPI functions above for inlining */
+#include <mach_ipi.h>
+static int convert_apicid_to_cpu(int apic_id)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		if (per_cpu(x86_cpu_to_apicid, i) == apic_id)
+			return i;
+	}
+	return -1;
+}
+
+int safe_smp_processor_id(void)
+{
+	int apicid, cpuid;
+
+	if (!boot_cpu_has(X86_FEATURE_APIC))
+		return 0;
+
+	apicid = hard_smp_processor_id();
+	if (apicid == BAD_APICID)
+		return 0;
+
+	cpuid = convert_apicid_to_cpu(apicid);
+
+	return cpuid >= 0 ? cpuid : 0;
+}
+#endif
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index 61e546e..d80623a 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -107,132 +107,6 @@
 
 DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate) ____cacheline_aligned = { &init_mm, 0, };
 
-/*
- * the following functions deal with sending IPIs between CPUs.
- *
- * We use 'broadcast', CPU->CPU IPIs and self-IPIs too.
- */
-
-static inline int __prepare_ICR (unsigned int shortcut, int vector)
-{
-	unsigned int icr = shortcut | APIC_DEST_LOGICAL;
-
-	switch (vector) {
-	default:
-		icr |= APIC_DM_FIXED | vector;
-		break;
-	case NMI_VECTOR:
-		icr |= APIC_DM_NMI;
-		break;
-	}
-	return icr;
-}
-
-static inline int __prepare_ICR2 (unsigned int mask)
-{
-	return SET_APIC_DEST_FIELD(mask);
-}
-
-void __send_IPI_shortcut(unsigned int shortcut, int vector)
-{
-	/*
-	 * Subtle. In the case of the 'never do double writes' workaround
-	 * we have to lock out interrupts to be safe.  As we don't care
-	 * of the value read we use an atomic rmw access to avoid costly
-	 * cli/sti.  Otherwise we use an even cheaper single atomic write
-	 * to the APIC.
-	 */
-	unsigned int cfg;
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-
-	/*
-	 * No need to touch the target chip field
-	 */
-	cfg = __prepare_ICR(shortcut, vector);
-
-	/*
-	 * Send the IPI. The write to APIC_ICR fires this off.
-	 */
-	apic_write_around(APIC_ICR, cfg);
-}
-
-void send_IPI_self(int vector)
-{
-	__send_IPI_shortcut(APIC_DEST_SELF, vector);
-}
-
-/*
- * This is used to send an IPI with no shorthand notation (the destination is
- * specified in bits 56 to 63 of the ICR).
- */
-static inline void __send_IPI_dest_field(unsigned long mask, int vector)
-{
-	unsigned long cfg;
-
-	/*
-	 * Wait for idle.
-	 */
-	if (unlikely(vector == NMI_VECTOR))
-		safe_apic_wait_icr_idle();
-	else
-		apic_wait_icr_idle();
-		
-	/*
-	 * prepare target chip field
-	 */
-	cfg = __prepare_ICR2(mask);
-	apic_write_around(APIC_ICR2, cfg);
-		
-	/*
-	 * program the ICR 
-	 */
-	cfg = __prepare_ICR(0, vector);
-			
-	/*
-	 * Send the IPI. The write to APIC_ICR fires this off.
-	 */
-	apic_write_around(APIC_ICR, cfg);
-}
-
-/*
- * This is only used on smaller machines.
- */
-void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
-{
-	unsigned long mask = cpus_addr(cpumask)[0];
-	unsigned long flags;
-
-	local_irq_save(flags);
-	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
-	__send_IPI_dest_field(mask, vector);
-	local_irq_restore(flags);
-}
-
-void send_IPI_mask_sequence(cpumask_t mask, int vector)
-{
-	unsigned long flags;
-	unsigned int query_cpu;
-
-	/*
-	 * Hack. The clustered APIC addressing mode doesn't allow us to send 
-	 * to an arbitrary mask, so I do a unicasts to each CPU instead. This 
-	 * should be modified to do 1 message per cluster ID - mbligh
-	 */ 
-
-	local_irq_save(flags);
-	for_each_possible_cpu(query_cpu) {
-		if (cpu_isset(query_cpu, mask)) {
-			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
-					      vector);
-		}
-	}
-	local_irq_restore(flags);
-}
-
 #include <mach_ipi.h> /* must come after the send_IPI functions above for inlining */
 
 /*
@@ -465,30 +339,3 @@ void flush_tlb_all(void)
 {
 	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
 }
-
-static int convert_apicid_to_cpu(int apic_id)
-{
-	int i;
-
-	for_each_possible_cpu(i) {
-		if (per_cpu(x86_cpu_to_apicid, i) == apic_id)
-			return i;
-	}
-	return -1;
-}
-
-int safe_smp_processor_id(void)
-{
-	int apicid, cpuid;
-
-	if (!boot_cpu_has(X86_FEATURE_APIC))
-		return 0;
-
-	apicid = hard_smp_processor_id();
-	if (apicid == BAD_APICID)
-		return 0;
-
-	cpuid = convert_apicid_to_cpu(apicid);
-
-	return cpuid >= 0 ? cpuid : 0;
-}
-- 
1.5.0.6

