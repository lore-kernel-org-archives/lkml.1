Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYLNISV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYLNISV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYLNIIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59940 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 22/36] KVM: ppc: save and restore guest mappings on context switch
Date: Sun, 14 Dec 2008 10:06:55 +0200
Message-Id: <1229242029-13410-23-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Store shadow TLB entries in memory, but only use it on host context switch
(instead of every guest entry). This improves performance for most workloads on
440 by reducing the guest TLB miss rate.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_44x.h |    6 ++++
 arch/powerpc/kvm/44x.c             |    7 +---
 arch/powerpc/kvm/44x_tlb.c         |   58 ++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_44x.h b/arch/powerpc/include/asm/kvm_44x.h
index e770ea2..f49031b 100644
--- a/arch/powerpc/include/asm/kvm_44x.h
+++ b/arch/powerpc/include/asm/kvm_44x.h
@@ -42,6 +42,10 @@ struct kvmppc_vcpu_44x {
 	/* References to guest pages in the hardware TLB. */
 	struct kvmppc_44x_shadow_ref shadow_refs[PPC44x_TLB_SIZE];
 
+	/* State of the shadow TLB at guest context switch time. */
+	struct kvmppc_44x_tlbe shadow_tlb[PPC44x_TLB_SIZE];
+	u8 shadow_tlb_mod[PPC44x_TLB_SIZE];
+
 	struct kvm_vcpu vcpu;
 };
 
@@ -51,5 +55,7 @@ static inline struct kvmppc_vcpu_44x *to_44x(struct kvm_vcpu *vcpu)
 }
 
 void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 new_pid);
+void kvmppc_44x_tlb_put(struct kvm_vcpu *vcpu);
+void kvmppc_44x_tlb_load(struct kvm_vcpu *vcpu);
 
 #endif /* __ASM_44X_H__ */
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index 05d72fc..a66bec5 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -96,15 +96,12 @@ void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
 
 void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	kvmppc_44x_tlb_load(vcpu);
 }
 
 void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	/* XXX Since every guest uses TS=1 TID=0/1 mappings, we can't leave any TLB
-	 * entries around when we're descheduled, so we must completely flush the
-	 * TLB of all guest mappings. On the other hand, if there is only one
-	 * guest, this flush is completely unnecessary. */
-	_tlbia();
+	kvmppc_44x_tlb_put(vcpu);
 }
 
 int kvmppc_core_check_processor_compat(void)
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 2981ebe..ff16d0e 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -73,6 +73,25 @@ static inline void kvmppc_44x_tlbie(unsigned int index)
 	);
 }
 
+static inline void kvmppc_44x_tlbre(unsigned int index,
+                                    struct kvmppc_44x_tlbe *tlbe)
+{
+	asm volatile(
+		"tlbre %[word0], %[index], 0\n"
+		"mfspr %[tid], %[sprn_mmucr]\n"
+		"andi. %[tid], %[tid], 0xff\n"
+		"tlbre %[word1], %[index], 1\n"
+		"tlbre %[word2], %[index], 2\n"
+		: [word0] "=r"(tlbe->word0),
+		  [word1] "=r"(tlbe->word1),
+		  [word2] "=r"(tlbe->word2),
+		  [tid]   "=r"(tlbe->tid)
+		: [index] "r"(index),
+		  [sprn_mmucr] "i"(SPRN_MMUCR)
+		: "cc"
+	);
+}
+
 static inline void kvmppc_44x_tlbwe(unsigned int index,
                                     struct kvmppc_44x_tlbe *stlbe)
 {
@@ -116,6 +135,44 @@ static u32 kvmppc_44x_tlb_shadow_attrib(u32 attrib, int usermode)
 	return attrib;
 }
 
+/* Load shadow TLB back into hardware. */
+void kvmppc_44x_tlb_load(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	int i;
+
+	for (i = 0; i <= tlb_44x_hwater; i++) {
+		struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
+
+		if (get_tlb_v(stlbe) && get_tlb_ts(stlbe))
+			kvmppc_44x_tlbwe(i, stlbe);
+	}
+}
+
+static void kvmppc_44x_tlbe_set_modified(struct kvmppc_vcpu_44x *vcpu_44x,
+                                         unsigned int i)
+{
+	vcpu_44x->shadow_tlb_mod[i] = 1;
+}
+
+/* Save hardware TLB to the vcpu, and invalidate all guest mappings. */
+void kvmppc_44x_tlb_put(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	int i;
+
+	for (i = 0; i <= tlb_44x_hwater; i++) {
+		struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
+
+		if (vcpu_44x->shadow_tlb_mod[i])
+			kvmppc_44x_tlbre(i, stlbe);
+
+		if (get_tlb_v(stlbe) && get_tlb_ts(stlbe))
+			kvmppc_44x_tlbie(i);
+	}
+}
+
+
 /* Search the guest TLB for a matching entry. */
 int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
                          unsigned int as)
@@ -283,6 +340,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr, u64 asid,
 	ref->tid = stlbe.tid;
 
 	/* Insert shadow mapping into hardware TLB. */
+	kvmppc_44x_tlbe_set_modified(vcpu_44x, victim);
 	kvmppc_44x_tlbwe(victim, &stlbe);
 	KVMTRACE_5D(STLB_WRITE, vcpu, victim, stlbe.tid, stlbe.word0, stlbe.word1,
 	            stlbe.word2, handler);
-- 
1.6.0.3

