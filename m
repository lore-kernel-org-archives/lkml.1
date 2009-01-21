Return-Path: <linux-kernel-owner+w=401wt.eu-S1763932AbZAUIuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763932AbZAUIuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZAUIqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:38089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbZAUIqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:46 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] x86: uv cleanup
Date: Wed, 21 Jan 2009 17:46:15 +0900
Message-Id: <1232527578-1960-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Make the following uv related cleanups.

* collect visible uv related definitions and interfaces into uv/uv.h
  and use it.  this cleans up the messy situation where on 64bit, uv
  is defined properly, on 32bit generic it's dummy and on the rest
  undefined.  after this clean up, uv is defined on 64 and dummy on
  32.

* update uv_flush_tlb_others() such that it takes cpumask of
  to-be-flushed cpus as argument, instead of that minus self, and
  returns yet-to-be-flushed cpumask, instead of modifying the passed
  in parameter.  this interface change will ease dummy implementation
  of uv_flush_tlb_others() and makes uv tlb flush related stuff
  defined in tlb_uv proper.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/genapic_32.h |    7 ----
 arch/x86/include/asm/genapic_64.h |    6 ---
 arch/x86/include/asm/uv/uv.h      |   33 ++++++++++++++++++
 arch/x86/include/asm/uv/uv_bau.h  |    2 -
 arch/x86/kernel/cpu/common.c      |    1 +
 arch/x86/kernel/genx2apic_uv_x.c  |    1 +
 arch/x86/kernel/smpboot.c         |    1 +
 arch/x86/kernel/tlb_64.c          |   18 ++++------
 arch/x86/kernel/tlb_uv.c          |   68 +++++++++++++++++++++---------------
 9 files changed, 83 insertions(+), 54 deletions(-)
 create mode 100644 arch/x86/include/asm/uv/uv.h

diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 2c05b73..4334502 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -138,11 +138,4 @@ struct genapic {
 extern struct genapic *genapic;
 extern void es7000_update_genapic_to_cluster(void);
 
-enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
-#define get_uv_system_type()		UV_NONE
-#define is_uv_system()			0
-#define uv_wakeup_secondary(a, b)	1
-#define uv_system_init()		do {} while (0)
-
-
 #endif /* _ASM_X86_GENAPIC_32_H */
diff --git a/arch/x86/include/asm/genapic_64.h b/arch/x86/include/asm/genapic_64.h
index adf32fb..7bb092c 100644
--- a/arch/x86/include/asm/genapic_64.h
+++ b/arch/x86/include/asm/genapic_64.h
@@ -51,15 +51,9 @@ extern struct genapic apic_x2apic_phys;
 extern int acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);
-enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
-extern enum uv_system_type get_uv_system_type(void);
-extern int is_uv_system(void);
 
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
-extern void uv_cpu_init(void);
-extern void uv_system_init(void);
-extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
 
 extern void setup_apic_routing(void);
 
diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
new file mode 100644
index 0000000..dce5fe3
--- /dev/null
+++ b/arch/x86/include/asm/uv/uv.h
@@ -0,0 +1,33 @@
+#ifndef _ASM_X86_UV_UV_H
+#define _ASM_X86_UV_UV_H
+
+enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
+
+#ifdef CONFIG_X86_64
+
+extern enum uv_system_type get_uv_system_type(void);
+extern int is_uv_system(void);
+extern void uv_cpu_init(void);
+extern void uv_system_init(void);
+extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
+extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
+						 struct mm_struct *mm,
+						 unsigned long va,
+						 unsigned int cpu);
+
+#else	/* X86_64 */
+
+static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
+static inline int is_uv_system(void)	{ return 0; }
+static inline void uv_cpu_init(void)	{ }
+static inline void uv_system_init(void)	{ }
+static inline int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
+{ return 1; }
+static inline const struct cpumask *
+uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
+		    unsigned long va, unsigned int cpu)
+{ return cpumask; }
+
+#endif	/* X86_64 */
+
+#endif	/* _ASM_X86_UV_UV_H */
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 74e6393..9b0e61b 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -325,8 +325,6 @@ static inline void bau_cpubits_clear(struct bau_local_cpumask *dstp, int nbits)
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-extern int uv_flush_tlb_others(struct cpumask *,
-			       struct mm_struct *, unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index fbebbce..99904f2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -28,6 +28,7 @@
 #include <asm/apic.h>
 #include <mach_apic.h>
 #include <asm/genapic.h>
+#include <asm/uv/uv.h>
 #endif
 
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index b193e08..bfe3624 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -25,6 +25,7 @@
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 #include <asm/pgtable.h>
+#include <asm/uv/uv.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 869b988..def770b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -62,6 +62,7 @@
 #include <asm/vmi.h>
 #include <asm/genapic.h>
 #include <asm/setup.h>
+#include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index e64a32c..b8bed84 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -15,8 +15,7 @@
 #include <asm/proto.h>
 #include <asm/apicdef.h>
 #include <asm/idle.h>
-#include <asm/uv/uv_hub.h>
-#include <asm/uv/uv_bau.h>
+#include <asm/uv/uv.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
 			= { &init_mm, 0, };
@@ -206,16 +205,13 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 			     struct mm_struct *mm, unsigned long va)
 {
 	if (is_uv_system()) {
-		/* FIXME: could be an percpu_alloc'd thing */
-		static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
-		struct cpumask *after_uv_flush = &get_cpu_var(flush_tlb_mask);
+		unsigned int cpu;
 
-		cpumask_andnot(after_uv_flush, cpumask,
-			       cpumask_of(smp_processor_id()));
-		if (!uv_flush_tlb_others(after_uv_flush, mm, va))
-			flush_tlb_others_ipi(after_uv_flush, mm, va);
-
-		put_cpu_var(flush_tlb_uv_cpumask);
+		cpu = get_cpu();
+		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
+		if (cpumask)
+			flush_tlb_others_ipi(cpumask, mm, va);
+		put_cpu();
 		return;
 	}
 	flush_tlb_others_ipi(cpumask, mm, va);
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 690dcf1..aae15dd 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 
 #include <asm/mmu_context.h>
+#include <asm/uv/uv.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_bau.h>
@@ -209,14 +210,15 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
  *
  * Send a broadcast and wait for a broadcast message to complete.
  *
- * The cpumaskp mask contains the cpus the broadcast was sent to.
+ * The flush_mask contains the cpus the broadcast was sent to.
  *
- * Returns 1 if all remote flushing was done. The mask is zeroed.
- * Returns 0 if some remote flushing remains to be done. The mask will have
- * some bits still set.
+ * Returns NULL if all remote flushing was done. The mask is zeroed.
+ * Returns @flush_mask if some remote flushing remains to be done. The
+ * mask will have some bits still set.
  */
-int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
-			   struct cpumask *cpumaskp)
+const struct cpumask *uv_flush_send_and_wait(int cpu, int this_blade,
+					     struct bau_desc *bau_desc,
+					     struct cpumask *flush_mask)
 {
 	int completion_status = 0;
 	int right_shift;
@@ -263,59 +265,69 @@ int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
 	 * Success, so clear the remote cpu's from the mask so we don't
 	 * use the IPI method of shootdown on them.
 	 */
-	for_each_cpu(bit, cpumaskp) {
+	for_each_cpu(bit, flush_mask) {
 		blade = uv_cpu_to_blade_id(bit);
 		if (blade == this_blade)
 			continue;
-		cpumask_clear_cpu(bit, cpumaskp);
+		cpumask_clear_cpu(bit, flush_mask);
 	}
-	if (!cpumask_empty(cpumaskp))
-		return 0;
-	return 1;
+	if (!cpumask_empty(flush_mask))
+		return flush_mask;
+	return NULL;
 }
 
 /**
  * uv_flush_tlb_others - globally purge translation cache of a virtual
  * address or all TLB's
- * @cpumaskp: mask of all cpu's in which the address is to be removed
+ * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
  * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
+ * @cpu: the current cpu
  *
  * This is the entry point for initiating any UV global TLB shootdown.
  *
  * Purges the translation caches of all specified processors of the given
  * virtual address, or purges all TLB's on specified processors.
  *
- * The caller has derived the cpumaskp from the mm_struct and has subtracted
- * the local cpu from the mask.  This function is called only if there
- * are bits set in the mask. (e.g. flush_tlb_page())
+ * The caller has derived the cpumask from the mm_struct.  This function
+ * is called only if there are bits set in the mask. (e.g. flush_tlb_page())
  *
- * The cpumaskp is converted into a nodemask of the nodes containing
+ * The cpumask is converted into a nodemask of the nodes containing
  * the cpus.
  *
- * Returns 1 if all remote flushing was done.
- * Returns 0 if some remote flushing remains to be done.
+ * Note that this function should be called with preemption disabled.
+ *
+ * Returns NULL if all remote flushing was done.
+ * Returns pointer to cpumask if some remote flushing remains to be
+ * done.  The returned pointer is valid till preemption is re-enabled.
  */
-int uv_flush_tlb_others(struct cpumask *cpumaskp, struct mm_struct *mm,
-			unsigned long va)
+const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
+					  struct mm_struct *mm,
+					  unsigned long va, unsigned int cpu)
 {
+	static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
+	struct cpumask *flush_mask = &__get_cpu_var(flush_tlb_mask);
 	int i;
 	int bit;
 	int blade;
-	int cpu;
+	int uv_cpu;
 	int this_blade;
 	int locals = 0;
 	struct bau_desc *bau_desc;
 
-	cpu = uv_blade_processor_id();
+	WARN_ON(!in_atomic());
+
+	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
+
+	uv_cpu = uv_blade_processor_id();
 	this_blade = uv_numa_blade_id();
 	bau_desc = __get_cpu_var(bau_control).descriptor_base;
-	bau_desc += UV_ITEMS_PER_DESCRIPTOR * cpu;
+	bau_desc += UV_ITEMS_PER_DESCRIPTOR * uv_cpu;
 
 	bau_nodes_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
 	i = 0;
-	for_each_cpu(bit, cpumaskp) {
+	for_each_cpu(bit, flush_mask) {
 		blade = uv_cpu_to_blade_id(bit);
 		BUG_ON(blade > (UV_DISTRIBUTION_SIZE - 1));
 		if (blade == this_blade) {
@@ -330,17 +342,17 @@ int uv_flush_tlb_others(struct cpumask *cpumaskp, struct mm_struct *mm,
 		 * no off_node flushing; return status for local node
 		 */
 		if (locals)
-			return 0;
+			return flush_mask;
 		else
-			return 1;
+			return NULL;
 	}
 	__get_cpu_var(ptcstats).requestor++;
 	__get_cpu_var(ptcstats).ntargeted += i;
 
 	bau_desc->payload.address = va;
-	bau_desc->payload.sending_cpu = smp_processor_id();
+	bau_desc->payload.sending_cpu = cpu;
 
-	return uv_flush_send_and_wait(cpu, this_blade, bau_desc, cpumaskp);
+	return uv_flush_send_and_wait(uv_cpu, this_blade, bau_desc, flush_mask);
 }
 
 /*
-- 
1.6.0.2

