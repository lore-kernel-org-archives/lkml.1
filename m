Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZA1ILg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZA1ILg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZA1ILM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:11:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:50430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZA1ILK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:11:10 -0500
Message-ID: <498012FD.10301@kernel.org>
Date: Wed, 28 Jan 2009 17:10:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: cpw@sgi.com
Subject: [PATCH x86#cpus4096] x86: clean up after uv_flush_tlb_others() cpumask
 conversion
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 08:10:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

cpus4096 of uv_flush_tlb_others() conversion left percpu variable
definition and copying for uv in generic native_flush_tlb_others(),
which makes later conditionalization of uv difficult.  This patch
converts uv_flush_tlb_others() interface such that it returns pointer
to the modified cpumask instead of modifying the argument in place.

As the returned pointer points to a percpu variable
uv_flush_tlb_others() now should be called with preemption disabled
and the returned value is valid only till preemption is re-enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/uv/uv_bau.h |    5 +-
 arch/x86/kernel/tlb_64.c         |   15 +++-----
 arch/x86/kernel/tlb_uv.c         |   67 ++++++++++++++++++++++-----------------
 3 files changed, 48 insertions(+), 39 deletions(-)
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 74e6393..201ab61 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -325,8 +325,9 @@ static inline void bau_cpubits_clear(struct bau_local_cpumask *dstp, int nbits)
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-extern int uv_flush_tlb_others(struct cpumask *,
-			       struct mm_struct *, unsigned long);
+extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
+					struct mm_struct *mm, unsigned long va,
+					unsigned int cpu);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 7f4141d..9919576 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -203,16 +203,13 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
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
index 690dcf1..f65ffd4 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -209,14 +209,15 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
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
@@ -263,59 +264,69 @@ int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
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
@@ -330,17 +341,17 @@ int uv_flush_tlb_others(struct cpumask *cpumaskp, struct mm_struct *mm,
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

