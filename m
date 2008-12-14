Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYLNIS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYLNIS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbYLNIIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59944 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYLNIHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:20 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 21/36] KVM: ppc: directly insert shadow mappings into the hardware TLB
Date: Sun, 14 Dec 2008 10:06:54 +0200
Message-Id: <1229242029-13410-22-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Formerly, we used to maintain a per-vcpu shadow TLB and on every entry to the
guest would load this array into the hardware TLB. This consumed 1280 bytes of
memory (64 entries of 16 bytes plus a struct page pointer each), and also
required some assembly to loop over the array on every entry.

Instead of saving a copy in memory, we can just store shadow mappings directly
into the hardware TLB, accepting that the host kernel will clobber these as
part of the normal 440 TLB round robin. When we do that we need less than half
the memory, and we have decreased the exit handling time for all guest exits,
at the cost of increased number of TLB misses because the host overwrites some
guest entries.

These savings will be increased on processors with larger TLBs or which
implement intelligent flush instructions like tlbivax (which will avoid the
need to walk arrays in software).

In addition to that and to the code simplification, we have a greater chance of
leaving other host userspace mappings in the TLB, instead of forcing all
subsequent tasks to re-fault all their mappings.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_44x.h  |   24 ++--
 arch/powerpc/include/asm/kvm_ppc.h  |    3 +-
 arch/powerpc/kernel/asm-offsets.c   |    6 -
 arch/powerpc/kvm/44x.c              |   19 +--
 arch/powerpc/kvm/44x_tlb.c          |  256 +++++++++++++++++------------------
 arch/powerpc/kvm/44x_tlb.h          |    7 +-
 arch/powerpc/kvm/booke.c            |   26 +++--
 arch/powerpc/kvm/booke_interrupts.S |   48 -------
 8 files changed, 168 insertions(+), 221 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_44x.h b/arch/powerpc/include/asm/kvm_44x.h
index 72e5939..e770ea2 100644
--- a/arch/powerpc/include/asm/kvm_44x.h
+++ b/arch/powerpc/include/asm/kvm_44x.h
@@ -22,19 +22,25 @@
 
 #include <linux/kvm_host.h>
 
-/* XXX Can't include mmu-44x.h because it redefines struct mm_context. */
 #define PPC44x_TLB_SIZE 64
 
+/* If the guest is expecting it, this can be as large as we like; we'd just
+ * need to find some way of advertising it. */
+#define KVM44x_GUEST_TLB_SIZE 64
+
+struct kvmppc_44x_shadow_ref {
+	struct page *page;
+	u16 gtlb_index;
+	u8 writeable;
+	u8 tid;
+};
+
 struct kvmppc_vcpu_44x {
 	/* Unmodified copy of the guest's TLB. */
-	struct kvmppc_44x_tlbe guest_tlb[PPC44x_TLB_SIZE];
-	/* TLB that's actually used when the guest is running. */
-	struct kvmppc_44x_tlbe shadow_tlb[PPC44x_TLB_SIZE];
-	/* Pages which are referenced in the shadow TLB. */
-	struct page *shadow_pages[PPC44x_TLB_SIZE];
-
-	/* Track which TLB entries we've modified in the current exit. */
-	u8 shadow_tlb_mod[PPC44x_TLB_SIZE];
+	struct kvmppc_44x_tlbe guest_tlb[KVM44x_GUEST_TLB_SIZE];
+
+	/* References to guest pages in the hardware TLB. */
+	struct kvmppc_44x_shadow_ref shadow_refs[PPC44x_TLB_SIZE];
 
 	struct kvm_vcpu vcpu;
 };
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 5bb2926..36d2a50 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -53,7 +53,8 @@ extern int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu);
 extern void kvmppc_emulate_dec(struct kvm_vcpu *vcpu);
 
 extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
-                           u64 asid, u32 flags, u32 max_bytes);
+                           u64 asid, u32 flags, u32 max_bytes,
+                           unsigned int gtlb_idx);
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index b6367e8..80fa29b 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -357,12 +357,6 @@ int main(void)
 #ifdef CONFIG_KVM
 	DEFINE(TLBE_BYTES, sizeof(struct kvmppc_44x_tlbe));
 
-	DEFINE(VCPU_TO_44X, offsetof(struct kvmppc_vcpu_44x, vcpu));
-	DEFINE(VCPU44x_SHADOW_TLB,
-	       offsetof(struct kvmppc_vcpu_44x, shadow_tlb));
-	DEFINE(VCPU44x_SHADOW_MOD,
-	       offsetof(struct kvmppc_vcpu_44x, shadow_tlb_mod));
-
 	DEFINE(VCPU_HOST_STACK, offsetof(struct kvm_vcpu, arch.host_stack));
 	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
 	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index 22054b1..05d72fc 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -96,21 +96,14 @@ void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
 
 void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	int i;
-
-	/* Mark every guest entry in the shadow TLB entry modified, so that they
-	 * will all be reloaded on the next vcpu run (instead of being
-	 * demand-faulted). */
-	for (i = 0; i <= tlb_44x_hwater; i++)
-		kvmppc_tlbe_set_modified(vcpu, i);
 }
 
 void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	/* Don't leave guest TLB entries resident when being de-scheduled. */
-	/* XXX It would be nice to differentiate between heavyweight exit and
-	 * sched_out here, since we could avoid the TLB flush for heavyweight
-	 * exits. */
+	/* XXX Since every guest uses TS=1 TID=0/1 mappings, we can't leave any TLB
+	 * entries around when we're descheduled, so we must completely flush the
+	 * TLB of all guest mappings. On the other hand, if there is only one
+	 * guest, this flush is completely unnecessary. */
 	_tlbia();
 }
 
@@ -130,6 +123,7 @@ int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	struct kvmppc_44x_tlbe *tlbe = &vcpu_44x->guest_tlb[0];
+	int i;
 
 	tlbe->tid = 0;
 	tlbe->word0 = PPC44x_TLB_16M | PPC44x_TLB_VALID;
@@ -148,6 +142,9 @@ int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
 	 * CCR1[TCS]. */
 	vcpu->arch.ccr1 = mfspr(SPRN_CCR1);
 
+	for (i = 0; i < ARRAY_SIZE(vcpu_44x->shadow_refs); i++)
+		vcpu_44x->shadow_refs[i].gtlb_index = -1;
+
 	return 0;
 }
 
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index d49dc66..2981ebe 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -22,6 +22,8 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/highmem.h>
+
+#include <asm/tlbflush.h>
 #include <asm/mmu-44x.h>
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_44x.h>
@@ -40,8 +42,6 @@
 #define PPC44x_TLB_USER_PERM_MASK (PPC44x_TLB_UX|PPC44x_TLB_UR|PPC44x_TLB_UW)
 #define PPC44x_TLB_SUPER_PERM_MASK (PPC44x_TLB_SX|PPC44x_TLB_SR|PPC44x_TLB_SW)
 
-static unsigned int kvmppc_tlb_44x_pos;
-
 #ifdef DEBUG
 void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
 {
@@ -52,24 +52,49 @@ void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
 	printk("| %2s | %3s | %8s | %8s | %8s |\n",
 			"nr", "tid", "word0", "word1", "word2");
 
-	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
+	for (i = 0; i < ARRAY_SIZE(vcpu_44x->guest_tlb); i++) {
 		tlbe = &vcpu_44x->guest_tlb[i];
 		if (tlbe->word0 & PPC44x_TLB_VALID)
 			printk(" G%2d |  %02X | %08X | %08X | %08X |\n",
 			       i, tlbe->tid, tlbe->word0, tlbe->word1,
 			       tlbe->word2);
 	}
-
-	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
-		tlbe = &vcpu_44x->shadow_tlb[i];
-		if (tlbe->word0 & PPC44x_TLB_VALID)
-			printk(" S%2d | %02X | %08X | %08X | %08X |\n",
-			       i, tlbe->tid, tlbe->word0, tlbe->word1,
-			       tlbe->word2);
-	}
 }
 #endif
 
+static inline void kvmppc_44x_tlbie(unsigned int index)
+{
+	/* 0 <= index < 64, so the V bit is clear and we can use the index as
+	 * word0. */
+	asm volatile(
+		"tlbwe %[index], %[index], 0\n"
+	:
+	: [index] "r"(index)
+	);
+}
+
+static inline void kvmppc_44x_tlbwe(unsigned int index,
+                                    struct kvmppc_44x_tlbe *stlbe)
+{
+	unsigned long tmp;
+
+	asm volatile(
+		"mfspr %[tmp], %[sprn_mmucr]\n"
+		"rlwimi %[tmp], %[tid], 0, 0xff\n"
+		"mtspr %[sprn_mmucr], %[tmp]\n"
+		"tlbwe %[word0], %[index], 0\n"
+		"tlbwe %[word1], %[index], 1\n"
+		"tlbwe %[word2], %[index], 2\n"
+		: [tmp]   "=&r"(tmp)
+		: [word0] "r"(stlbe->word0),
+		  [word1] "r"(stlbe->word1),
+		  [word2] "r"(stlbe->word2),
+		  [tid]   "r"(stlbe->tid),
+		  [index] "r"(index),
+		  [sprn_mmucr] "i"(SPRN_MMUCR)
+	);
+}
+
 static u32 kvmppc_44x_tlb_shadow_attrib(u32 attrib, int usermode)
 {
 	/* We only care about the guest's permission and user bits. */
@@ -99,7 +124,7 @@ int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
 	int i;
 
 	/* XXX Replace loop with fancy data structures. */
-	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
+	for (i = 0; i < ARRAY_SIZE(vcpu_44x->guest_tlb); i++) {
 		struct kvmppc_44x_tlbe *tlbe = &vcpu_44x->guest_tlb[i];
 		unsigned int tid;
 
@@ -125,65 +150,53 @@ int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
 	return -1;
 }
 
-struct kvmppc_44x_tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu,
-                                               gva_t eaddr)
+int kvmppc_44x_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
 {
-	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
-	unsigned int index;
 
-	index = kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
-	if (index == -1)
-		return NULL;
-	return &vcpu_44x->guest_tlb[index];
+	return kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
 }
 
-struct kvmppc_44x_tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu,
-                                               gva_t eaddr)
+int kvmppc_44x_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
 {
-	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	unsigned int as = !!(vcpu->arch.msr & MSR_DS);
-	unsigned int index;
 
-	index = kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
-	if (index == -1)
-		return NULL;
-	return &vcpu_44x->guest_tlb[index];
+	return kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
 }
 
-static int kvmppc_44x_tlbe_is_writable(struct kvmppc_44x_tlbe *tlbe)
+static void kvmppc_44x_shadow_release(struct kvmppc_vcpu_44x *vcpu_44x,
+                                      unsigned int stlb_index)
 {
-	return tlbe->word2 & (PPC44x_TLB_SW|PPC44x_TLB_UW);
-}
+	struct kvmppc_44x_shadow_ref *ref = &vcpu_44x->shadow_refs[stlb_index];
 
-static void kvmppc_44x_shadow_release(struct kvm_vcpu *vcpu,
-                                      unsigned int index)
-{
-	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
-	struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[index];
-	struct page *page = vcpu_44x->shadow_pages[index];
+	if (!ref->page)
+		return;
 
-	if (get_tlb_v(stlbe)) {
-		if (kvmppc_44x_tlbe_is_writable(stlbe))
-			kvm_release_page_dirty(page);
-		else
-			kvm_release_page_clean(page);
-	}
-}
+	/* Discard from the TLB. */
+	/* Note: we could actually invalidate a host mapping, if the host overwrote
+	 * this TLB entry since we inserted a guest mapping. */
+	kvmppc_44x_tlbie(stlb_index);
 
-void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu)
-{
-	int i;
+	/* Now release the page. */
+	if (ref->writeable)
+		kvm_release_page_dirty(ref->page);
+	else
+		kvm_release_page_clean(ref->page);
 
-	for (i = 0; i <= tlb_44x_hwater; i++)
-		kvmppc_44x_shadow_release(vcpu, i);
+	ref->page = NULL;
+
+	/* XXX set tlb_44x_index to stlb_index? */
+
+	KVMTRACE_1D(STLB_INVAL, &vcpu_44x->vcpu, stlb_index, handler);
 }
 
-void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i)
+void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	int i;
 
-	vcpu_44x->shadow_tlb_mod[i] = 1;
+	for (i = 0; i <= tlb_44x_hwater; i++)
+		kvmppc_44x_shadow_release(vcpu_44x, i);
 }
 
 /**
@@ -199,21 +212,24 @@ void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i)
  * the shadow TLB.
  */
 void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr, u64 asid,
-                    u32 flags, u32 max_bytes)
+                    u32 flags, u32 max_bytes, unsigned int gtlb_index)
 {
+	struct kvmppc_44x_tlbe stlbe;
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	struct kvmppc_44x_shadow_ref *ref;
 	struct page *new_page;
-	struct kvmppc_44x_tlbe *stlbe;
 	hpa_t hpaddr;
 	gfn_t gfn;
 	unsigned int victim;
 
-	/* Future optimization: don't overwrite the TLB entry containing the
-	 * current PC (or stack?). */
-	victim = kvmppc_tlb_44x_pos++;
-	if (kvmppc_tlb_44x_pos > tlb_44x_hwater)
-		kvmppc_tlb_44x_pos = 0;
-	stlbe = &vcpu_44x->shadow_tlb[victim];
+	/* Select TLB entry to clobber. Indirectly guard against races with the TLB
+	 * miss handler by disabling interrupts. */
+	local_irq_disable();
+	victim = ++tlb_44x_index;
+	if (victim > tlb_44x_hwater)
+		victim = 0;
+	tlb_44x_index = victim;
+	local_irq_enable();
 
 	/* Get reference to new page. */
 	gfn = gpaddr >> PAGE_SHIFT;
@@ -225,10 +241,8 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr, u64 asid,
 	}
 	hpaddr = page_to_phys(new_page);
 
-	/* Drop reference to old page. */
-	kvmppc_44x_shadow_release(vcpu, victim);
-
-	vcpu_44x->shadow_pages[victim] = new_page;
+	/* Invalidate any previous shadow mappings. */
+	kvmppc_44x_shadow_release(vcpu_44x, victim);
 
 	/* XXX Make sure (va, size) doesn't overlap any other
 	 * entries. 440x6 user manual says the result would be
@@ -236,21 +250,19 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr, u64 asid,
 
 	/* XXX what about AS? */
 
-	stlbe->tid = !(asid & 0xff);
-
 	/* Force TS=1 for all guest mappings. */
-	stlbe->word0 = PPC44x_TLB_VALID | PPC44x_TLB_TS;
+	stlbe.word0 = PPC44x_TLB_VALID | PPC44x_TLB_TS;
 
 	if (max_bytes >= PAGE_SIZE) {
 		/* Guest mapping is larger than or equal to host page size. We can use
 		 * a "native" host mapping. */
-		stlbe->word0 |= (gvaddr & PAGE_MASK) | PPC44x_TLBE_SIZE;
+		stlbe.word0 |= (gvaddr & PAGE_MASK) | PPC44x_TLBE_SIZE;
 	} else {
 		/* Guest mapping is smaller than host page size. We must restrict the
 		 * size of the mapping to be at most the smaller of the two, but for
 		 * simplicity we fall back to a 4K mapping (this is probably what the
 		 * guest is using anyways). */
-		stlbe->word0 |= (gvaddr & PAGE_MASK_4K) | PPC44x_TLB_4K;
+		stlbe.word0 |= (gvaddr & PAGE_MASK_4K) | PPC44x_TLB_4K;
 
 		/* 'hpaddr' is a host page, which is larger than the mapping we're
 		 * inserting here. To compensate, we must add the in-page offset to the
@@ -258,47 +270,36 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr, u64 asid,
 		hpaddr |= gpaddr & (PAGE_MASK ^ PAGE_MASK_4K);
 	}
 
-	stlbe->word1 = (hpaddr & 0xfffffc00) | ((hpaddr >> 32) & 0xf);
-	stlbe->word2 = kvmppc_44x_tlb_shadow_attrib(flags,
+	stlbe.word1 = (hpaddr & 0xfffffc00) | ((hpaddr >> 32) & 0xf);
+	stlbe.word2 = kvmppc_44x_tlb_shadow_attrib(flags,
 	                                            vcpu->arch.msr & MSR_PR);
-	kvmppc_tlbe_set_modified(vcpu, victim);
-
-	KVMTRACE_5D(STLB_WRITE, vcpu, victim,
-			stlbe->tid, stlbe->word0, stlbe->word1, stlbe->word2,
-			handler);
+	stlbe.tid = !(asid & 0xff);
+
+	/* Keep track of the reference so we can properly release it later. */
+	ref = &vcpu_44x->shadow_refs[victim];
+	ref->page = new_page;
+	ref->gtlb_index = gtlb_index;
+	ref->writeable = !!(stlbe.word2 & PPC44x_TLB_UW);
+	ref->tid = stlbe.tid;
+
+	/* Insert shadow mapping into hardware TLB. */
+	kvmppc_44x_tlbwe(victim, &stlbe);
+	KVMTRACE_5D(STLB_WRITE, vcpu, victim, stlbe.tid, stlbe.word0, stlbe.word1,
+	            stlbe.word2, handler);
 }
 
-static void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
-                                  gva_t eend, u32 asid)
+/* For a particular guest TLB entry, invalidate the corresponding host TLB
+ * mappings and release the host pages. */
+static void kvmppc_44x_invalidate(struct kvm_vcpu *vcpu,
+                                  unsigned int gtlb_index)
 {
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
-	unsigned int pid = !(asid & 0xff);
 	int i;
 
-	/* XXX Replace loop with fancy data structures. */
-	for (i = 0; i <= tlb_44x_hwater; i++) {
-		struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
-		unsigned int tid;
-
-		if (!get_tlb_v(stlbe))
-			continue;
-
-		if (eend < get_tlb_eaddr(stlbe))
-			continue;
-
-		if (eaddr > get_tlb_end(stlbe))
-			continue;
-
-		tid = get_tlb_tid(stlbe);
-		if (tid && (tid != pid))
-			continue;
-
-		kvmppc_44x_shadow_release(vcpu, i);
-		stlbe->word0 = 0;
-		kvmppc_tlbe_set_modified(vcpu, i);
-		KVMTRACE_5D(STLB_INVAL, vcpu, i,
-				stlbe->tid, stlbe->word0, stlbe->word1,
-				stlbe->word2, handler);
+	for (i = 0; i < ARRAY_SIZE(vcpu_44x->shadow_refs); i++) {
+		struct kvmppc_44x_shadow_ref *ref = &vcpu_44x->shadow_refs[i];
+		if (ref->gtlb_index == gtlb_index)
+			kvmppc_44x_shadow_release(vcpu_44x, i);
 	}
 }
 
@@ -321,14 +322,11 @@ void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 new_pid)
 	 * can't access guest kernel mappings (TID=1). When we switch to a new
 	 * guest PID, which will also use host PID=0, we must discard the old guest
 	 * userspace mappings. */
-	for (i = 0; i < ARRAY_SIZE(vcpu_44x->shadow_tlb); i++) {
-		struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
-
-		if (get_tlb_tid(stlbe) == 0) {
-			kvmppc_44x_shadow_release(vcpu, i);
-			stlbe->word0 = 0;
-			kvmppc_tlbe_set_modified(vcpu, i);
-		}
+	for (i = 0; i < ARRAY_SIZE(vcpu_44x->shadow_refs); i++) {
+		struct kvmppc_44x_shadow_ref *ref = &vcpu_44x->shadow_refs[i];
+
+		if (ref->tid == 0)
+			kvmppc_44x_shadow_release(vcpu_44x, i);
 	}
 }
 
@@ -356,26 +354,21 @@ static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
 int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 {
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
-	gva_t eaddr;
-	u64 asid;
 	struct kvmppc_44x_tlbe *tlbe;
-	unsigned int index;
+	unsigned int gtlb_index;
 
-	index = vcpu->arch.gpr[ra];
-	if (index > PPC44x_TLB_SIZE) {
-		printk("%s: index %d\n", __func__, index);
+	gtlb_index = vcpu->arch.gpr[ra];
+	if (gtlb_index > KVM44x_GUEST_TLB_SIZE) {
+		printk("%s: index %d\n", __func__, gtlb_index);
 		kvmppc_dump_vcpu(vcpu);
 		return EMULATE_FAIL;
 	}
 
-	tlbe = &vcpu_44x->guest_tlb[index];
+	tlbe = &vcpu_44x->guest_tlb[gtlb_index];
 
-	/* Invalidate shadow mappings for the about-to-be-clobbered TLBE. */
-	if (tlbe->word0 & PPC44x_TLB_VALID) {
-		eaddr = get_tlb_eaddr(tlbe);
-		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
-		kvmppc_mmu_invalidate(vcpu, eaddr, get_tlb_end(tlbe), asid);
-	}
+	/* Invalidate shadow mappings for the about-to-be-clobbered TLB entry. */
+	if (tlbe->word0 & PPC44x_TLB_VALID)
+		kvmppc_44x_invalidate(vcpu, gtlb_index);
 
 	switch (ws) {
 	case PPC44x_TLB_PAGEID:
@@ -396,6 +389,8 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	}
 
 	if (tlbe_is_host_safe(vcpu, tlbe)) {
+		u64 asid;
+		gva_t eaddr;
 		gpa_t gpaddr;
 		u32 flags;
 		u32 bytes;
@@ -411,12 +406,11 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
 		flags = tlbe->word2 & 0xffff;
 
-		kvmppc_mmu_map(vcpu, eaddr, gpaddr, asid, flags, bytes);
+		kvmppc_mmu_map(vcpu, eaddr, gpaddr, asid, flags, bytes, gtlb_index);
 	}
 
-	KVMTRACE_5D(GTLB_WRITE, vcpu, index,
-	            tlbe->tid, tlbe->word0, tlbe->word1, tlbe->word2,
-	            handler);
+	KVMTRACE_5D(GTLB_WRITE, vcpu, gtlb_index, tlbe->tid, tlbe->word0,
+	            tlbe->word1, tlbe->word2, handler);
 
 	return EMULATE_DONE;
 }
@@ -424,7 +418,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc)
 {
 	u32 ea;
-	int index;
+	int gtlb_index;
 	unsigned int as = get_mmucr_sts(vcpu);
 	unsigned int pid = get_mmucr_stid(vcpu);
 
@@ -432,14 +426,14 @@ int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc)
 	if (ra)
 		ea += vcpu->arch.gpr[ra];
 
-	index = kvmppc_44x_tlb_index(vcpu, ea, pid, as);
+	gtlb_index = kvmppc_44x_tlb_index(vcpu, ea, pid, as);
 	if (rc) {
-		if (index < 0)
+		if (gtlb_index < 0)
 			vcpu->arch.cr &= ~0x20000000;
 		else
 			vcpu->arch.cr |= 0x20000000;
 	}
-	vcpu->arch.gpr[rt] = index;
+	vcpu->arch.gpr[rt] = gtlb_index;
 
 	return EMULATE_DONE;
 }
diff --git a/arch/powerpc/kvm/44x_tlb.h b/arch/powerpc/kvm/44x_tlb.h
index b1029af..772191f 100644
--- a/arch/powerpc/kvm/44x_tlb.h
+++ b/arch/powerpc/kvm/44x_tlb.h
@@ -25,11 +25,8 @@
 
 extern int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr,
                                 unsigned int pid, unsigned int as);
-extern struct kvmppc_44x_tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu,
-                                                      gva_t eaddr);
-extern struct kvmppc_44x_tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu,
-                                                      gva_t eaddr);
-extern void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i);
+extern int kvmppc_44x_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
+extern int kvmppc_44x_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
 
 extern int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb,
                                  u8 rc);
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 924c7b4..eb24383 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -24,10 +24,12 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+
 #include <asm/cputable.h>
 #include <asm/uaccess.h>
 #include <asm/kvm_ppc.h>
 #include <asm/cacheflush.h>
+#include <asm/kvm_44x.h>
 
 #include "booke.h"
 #include "44x_tlb.h"
@@ -207,10 +209,6 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		 * handled this interrupt the moment we enabled interrupts.
 		 * Now we just offer it a chance to reschedule the guest. */
 
-		/* XXX At this point the TLB still holds our shadow TLB, so if
-		 * we do reschedule the host will fault over it. Perhaps we
-		 * should politely restore the host's entries to minimize
-		 * misses before ceding control. */
 		vcpu->stat.dec_exits++;
 		if (need_resched())
 			cond_resched();
@@ -281,14 +279,17 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		r = RESUME_GUEST;
 		break;
 
+	/* XXX move to a 440-specific file. */
 	case BOOKE_INTERRUPT_DTLB_MISS: {
+		struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.fault_dear;
+		int gtlb_index;
 		gfn_t gfn;
 
 		/* Check the guest TLB. */
-		gtlbe = kvmppc_44x_dtlb_search(vcpu, eaddr);
-		if (!gtlbe) {
+		gtlb_index = kvmppc_44x_dtlb_index(vcpu, eaddr);
+		if (gtlb_index < 0) {
 			/* The guest didn't have a mapping for it. */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DTLB_MISS);
 			vcpu->arch.dear = vcpu->arch.fault_dear;
@@ -298,6 +299,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			break;
 		}
 
+		gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
 		vcpu->arch.paddr_accessed = tlb_xlate(gtlbe, eaddr);
 		gfn = vcpu->arch.paddr_accessed >> PAGE_SHIFT;
 
@@ -309,7 +311,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * Either way, we need to satisfy the fault without
 			 * invoking the guest. */
 			kvmppc_mmu_map(vcpu, eaddr, vcpu->arch.paddr_accessed, gtlbe->tid,
-			               gtlbe->word2, get_tlb_bytes(gtlbe));
+			               gtlbe->word2, get_tlb_bytes(gtlbe), gtlb_index);
 			vcpu->stat.dtlb_virt_miss_exits++;
 			r = RESUME_GUEST;
 		} else {
@@ -322,17 +324,20 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 	}
 
+	/* XXX move to a 440-specific file. */
 	case BOOKE_INTERRUPT_ITLB_MISS: {
+		struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.pc;
 		gpa_t gpaddr;
 		gfn_t gfn;
+		int gtlb_index;
 
 		r = RESUME_GUEST;
 
 		/* Check the guest TLB. */
-		gtlbe = kvmppc_44x_itlb_search(vcpu, eaddr);
-		if (!gtlbe) {
+		gtlb_index = kvmppc_44x_itlb_index(vcpu, eaddr);
+		if (gtlb_index < 0) {
 			/* The guest didn't have a mapping for it. */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_ITLB_MISS);
 			vcpu->stat.itlb_real_miss_exits++;
@@ -341,6 +346,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 		vcpu->stat.itlb_virt_miss_exits++;
 
+		gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
 		gpaddr = tlb_xlate(gtlbe, eaddr);
 		gfn = gpaddr >> PAGE_SHIFT;
 
@@ -352,7 +358,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * Either way, we need to satisfy the fault without
 			 * invoking the guest. */
 			kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlbe->tid,
-			               gtlbe->word2, get_tlb_bytes(gtlbe));
+			               gtlbe->word2, get_tlb_bytes(gtlbe), gtlb_index);
 		} else {
 			/* Guest mapped and leaped at non-RAM! */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_MACHINE_CHECK);
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 8d6929b..eb21868 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -335,54 +335,6 @@ lightweight_exit:
 	lwz	r3, VCPU_SHADOW_PID(r4)
 	mtspr	SPRN_PID, r3
 
-	/* Prevent all asynchronous TLB updates. */
-	mfmsr	r5
-	lis	r6, (MSR_EE|MSR_CE|MSR_ME|MSR_DE)@h
-	ori	r6, r6, (MSR_EE|MSR_CE|MSR_ME|MSR_DE)@l
-	andc	r6, r5, r6
-	mtmsr	r6
-
-	/* Load the guest mappings, leaving the host's "pinned" kernel mappings
-	 * in place. */
-	mfspr	r10, SPRN_MMUCR			/* Save host MMUCR. */
-	li	r5, PPC44x_TLB_SIZE
-	lis	r5, tlb_44x_hwater@ha
-	lwz	r5, tlb_44x_hwater@l(r5)
-	mtctr	r5
-	addi	r9, r4, -VCPU_TO_44X + VCPU44x_SHADOW_TLB
-	addi	r5, r4, -VCPU_TO_44X + VCPU44x_SHADOW_MOD
-	li	r3, 0
-1:
-	lbzx	r7, r3, r5
-	cmpwi	r7, 0
-	beq	3f
-
-	/* Load guest entry. */
-	mulli	r11, r3, TLBE_BYTES
-	add	r11, r11, r9
-	lwz	r7, 0(r11)
-	mtspr	SPRN_MMUCR, r7
-	lwz	r7, 4(r11)
-	tlbwe	r7, r3, PPC44x_TLB_PAGEID
-	lwz	r7, 8(r11)
-	tlbwe	r7, r3, PPC44x_TLB_XLAT
-	lwz	r7, 12(r11)
-	tlbwe	r7, r3, PPC44x_TLB_ATTRIB
-3:
-	addi	r3, r3, 1                       /* Increment index. */
-	bdnz	1b
-
-	mtspr	SPRN_MMUCR, r10			/* Restore host MMUCR. */
-
-	/* Clear bitmap of modified TLB entries */
-	li	r5, PPC44x_TLB_SIZE>>2
-	mtctr	r5
-	addi	r5, r4, -VCPU_TO_44X + VCPU44x_SHADOW_MOD - 4
-	li	r6, 0
-1:
-	stwu	r6, 4(r5)
-	bdnz	1b
-
 	iccci	0, 0 /* XXX hack */
 
 	/* Load some guest volatiles. */
-- 
1.6.0.3

