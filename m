Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbYLNIRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbYLNIRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYLNIIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59941 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 19/36] KVM: ppc: support large host pages
Date: Sun, 14 Dec 2008 10:06:52 +0200
Message-Id: <1229242029-13410-20-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

KVM on 440 has always been able to handle large guest mappings with 4K host
pages -- we must, since the guest kernel uses 256MB mappings.

This patch makes KVM work when the host has large pages too (tested with 64K).

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    4 +-
 arch/powerpc/kvm/44x_tlb.c         |   71 ++++++++++++++++++++++++++++--------
 arch/powerpc/kvm/booke.c           |   12 ++++---
 3 files changed, 64 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 844f683..5bb2926 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -52,8 +52,8 @@ extern int kvmppc_emulate_instruction(struct kvm_run *run,
 extern int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu);
 extern void kvmppc_emulate_dec(struct kvm_vcpu *vcpu);
 
-extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn,
-                           u64 asid, u32 flags);
+extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
+                           u64 asid, u32 flags, u32 max_bytes);
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index ee24618..d49dc66 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -28,6 +28,13 @@
 
 #include "44x_tlb.h"
 
+#ifndef PPC44x_TLBE_SIZE
+#define PPC44x_TLBE_SIZE	PPC44x_TLB_4K
+#endif
+
+#define PAGE_SIZE_4K (1<<12)
+#define PAGE_MASK_4K (~(PAGE_SIZE_4K - 1))
+
 #define PPC44x_TLB_UATTR_MASK \
 	(PPC44x_TLB_U0|PPC44x_TLB_U1|PPC44x_TLB_U2|PPC44x_TLB_U3)
 #define PPC44x_TLB_USER_PERM_MASK (PPC44x_TLB_UX|PPC44x_TLB_UR|PPC44x_TLB_UW)
@@ -179,15 +186,26 @@ void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i)
 	vcpu_44x->shadow_tlb_mod[i] = 1;
 }
 
-/* Caller must ensure that the specified guest TLB entry is safe to insert into
- * the shadow TLB. */
-void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
-                    u32 flags)
+/**
+ * kvmppc_mmu_map -- create a host mapping for guest memory
+ *
+ * If the guest wanted a larger page than the host supports, only the first
+ * host page is mapped here and the rest are demand faulted.
+ *
+ * If the guest wanted a smaller page than the host page size, we map only the
+ * guest-size page (i.e. not a full host page mapping).
+ *
+ * Caller must ensure that the specified guest TLB entry is safe to insert into
+ * the shadow TLB.
+ */
+void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr, u64 asid,
+                    u32 flags, u32 max_bytes)
 {
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	struct page *new_page;
 	struct kvmppc_44x_tlbe *stlbe;
 	hpa_t hpaddr;
+	gfn_t gfn;
 	unsigned int victim;
 
 	/* Future optimization: don't overwrite the TLB entry containing the
@@ -198,6 +216,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	stlbe = &vcpu_44x->shadow_tlb[victim];
 
 	/* Get reference to new page. */
+	gfn = gpaddr >> PAGE_SHIFT;
 	new_page = gfn_to_page(vcpu->kvm, gfn);
 	if (is_error_page(new_page)) {
 		printk(KERN_ERR "Couldn't get guest page for gfn %lx!\n", gfn);
@@ -220,10 +239,25 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	stlbe->tid = !(asid & 0xff);
 
 	/* Force TS=1 for all guest mappings. */
-	/* For now we hardcode 4KB mappings, but it will be important to
-	 * use host large pages in the future. */
-	stlbe->word0 = (gvaddr & PAGE_MASK) | PPC44x_TLB_VALID | PPC44x_TLB_TS
-	               | PPC44x_TLB_4K;
+	stlbe->word0 = PPC44x_TLB_VALID | PPC44x_TLB_TS;
+
+	if (max_bytes >= PAGE_SIZE) {
+		/* Guest mapping is larger than or equal to host page size. We can use
+		 * a "native" host mapping. */
+		stlbe->word0 |= (gvaddr & PAGE_MASK) | PPC44x_TLBE_SIZE;
+	} else {
+		/* Guest mapping is smaller than host page size. We must restrict the
+		 * size of the mapping to be at most the smaller of the two, but for
+		 * simplicity we fall back to a 4K mapping (this is probably what the
+		 * guest is using anyways). */
+		stlbe->word0 |= (gvaddr & PAGE_MASK_4K) | PPC44x_TLB_4K;
+
+		/* 'hpaddr' is a host page, which is larger than the mapping we're
+		 * inserting here. To compensate, we must add the in-page offset to the
+		 * sub-page. */
+		hpaddr |= gpaddr & (PAGE_MASK ^ PAGE_MASK_4K);
+	}
+
 	stlbe->word1 = (hpaddr & 0xfffffc00) | ((hpaddr >> 32) & 0xf);
 	stlbe->word2 = kvmppc_44x_tlb_shadow_attrib(flags,
 	                                            vcpu->arch.msr & MSR_PR);
@@ -322,10 +356,8 @@ static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
 int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 {
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
-	u64 eaddr;
-	u64 raddr;
+	gva_t eaddr;
 	u64 asid;
-	u32 flags;
 	struct kvmppc_44x_tlbe *tlbe;
 	unsigned int index;
 
@@ -364,15 +396,22 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	}
 
 	if (tlbe_is_host_safe(vcpu, tlbe)) {
+		gpa_t gpaddr;
+		u32 flags;
+		u32 bytes;
+
 		eaddr = get_tlb_eaddr(tlbe);
-		raddr = get_tlb_raddr(tlbe);
+		gpaddr = get_tlb_raddr(tlbe);
+
+		/* Use the advertised page size to mask effective and real addrs. */
+		bytes = get_tlb_bytes(tlbe);
+		eaddr &= ~(bytes - 1);
+		gpaddr &= ~(bytes - 1);
+
 		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
 		flags = tlbe->word2 & 0xffff;
 
-		/* Create a 4KB mapping on the host. If the guest wanted a
-		 * large page, only the first 4KB is mapped here and the rest
-		 * are mapped on the fly. */
-		kvmppc_mmu_map(vcpu, eaddr, raddr >> PAGE_SHIFT, asid, flags);
+		kvmppc_mmu_map(vcpu, eaddr, gpaddr, asid, flags, bytes);
 	}
 
 	KVMTRACE_5D(GTLB_WRITE, vcpu, index,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index ec59a67..924c7b4 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -308,8 +308,8 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * b) the guest used a large mapping which we're faking
 			 * Either way, we need to satisfy the fault without
 			 * invoking the guest. */
-			kvmppc_mmu_map(vcpu, eaddr, gfn, gtlbe->tid,
-			               gtlbe->word2);
+			kvmppc_mmu_map(vcpu, eaddr, vcpu->arch.paddr_accessed, gtlbe->tid,
+			               gtlbe->word2, get_tlb_bytes(gtlbe));
 			vcpu->stat.dtlb_virt_miss_exits++;
 			r = RESUME_GUEST;
 		} else {
@@ -325,6 +325,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	case BOOKE_INTERRUPT_ITLB_MISS: {
 		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.pc;
+		gpa_t gpaddr;
 		gfn_t gfn;
 
 		r = RESUME_GUEST;
@@ -340,7 +341,8 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 		vcpu->stat.itlb_virt_miss_exits++;
 
-		gfn = tlb_xlate(gtlbe, eaddr) >> PAGE_SHIFT;
+		gpaddr = tlb_xlate(gtlbe, eaddr);
+		gfn = gpaddr >> PAGE_SHIFT;
 
 		if (kvm_is_visible_gfn(vcpu->kvm, gfn)) {
 			/* The guest TLB had a mapping, but the shadow TLB
@@ -349,8 +351,8 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * b) the guest used a large mapping which we're faking
 			 * Either way, we need to satisfy the fault without
 			 * invoking the guest. */
-			kvmppc_mmu_map(vcpu, eaddr, gfn, gtlbe->tid,
-			               gtlbe->word2);
+			kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlbe->tid,
+			               gtlbe->word2, get_tlb_bytes(gtlbe));
 		} else {
 			/* Guest mapped and leaped at non-RAM! */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_MACHINE_CHECK);
-- 
1.6.0.3

