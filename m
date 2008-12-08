Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbYLHLnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbYLHLnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYLHLhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbYLHLhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 39/45] KVM: ppc: Rename "struct tlbe" to "struct kvmppc_44x_tlbe"
Date: Mon,  8 Dec 2008 13:36:50 +0200
Message-Id: <1228736216-15787-40-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This will ease ports to other cores.

Also remove unused "struct kvm_tlb" while we're at it.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |    6 +++---
 arch/powerpc/include/asm/kvm_ppc.h  |    5 -----
 arch/powerpc/kernel/asm-offsets.c   |    2 +-
 arch/powerpc/kvm/44x_tlb.c          |   22 ++++++++++++----------
 arch/powerpc/kvm/44x_tlb.h          |   24 +++++++++++++-----------
 arch/powerpc/kvm/booke_guest.c      |    8 ++++----
 6 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 34b52b7..df73351 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -64,7 +64,7 @@ struct kvm_vcpu_stat {
 	u32 halt_wakeup;
 };
 
-struct tlbe {
+struct kvmppc_44x_tlbe {
 	u32 tid; /* Only the low 8 bits are used. */
 	u32 word0;
 	u32 word1;
@@ -76,9 +76,9 @@ struct kvm_arch {
 
 struct kvm_vcpu_arch {
 	/* Unmodified copy of the guest's TLB. */
-	struct tlbe guest_tlb[PPC44x_TLB_SIZE];
+	struct kvmppc_44x_tlbe guest_tlb[PPC44x_TLB_SIZE];
 	/* TLB that's actually used when the guest is running. */
-	struct tlbe shadow_tlb[PPC44x_TLB_SIZE];
+	struct kvmppc_44x_tlbe shadow_tlb[PPC44x_TLB_SIZE];
 	/* Pages which are referenced in the shadow TLB. */
 	struct page *shadow_pages[PPC44x_TLB_SIZE];
 
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 4adb4a3..39daeaa 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -29,11 +29,6 @@
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 
-struct kvm_tlb {
-	struct tlbe guest_tlb[PPC44x_TLB_SIZE];
-	struct tlbe shadow_tlb[PPC44x_TLB_SIZE];
-};
-
 enum emulation_result {
 	EMULATE_DONE,         /* no further processing */
 	EMULATE_DO_MMIO,      /* kvm_run filled with MMIO request */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 75c5dd0..1d15420 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -355,7 +355,7 @@ int main(void)
 	DEFINE(PTE_SIZE, sizeof(pte_t));
 
 #ifdef CONFIG_KVM
-	DEFINE(TLBE_BYTES, sizeof(struct tlbe));
+	DEFINE(TLBE_BYTES, sizeof(struct kvmppc_44x_tlbe));
 
 	DEFINE(VCPU_HOST_STACK, offsetof(struct kvm_vcpu, arch.host_stack));
 	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index dd75ab8..5152fe5 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -86,7 +86,7 @@ int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
 
 	/* XXX Replace loop with fancy data structures. */
 	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
-		struct tlbe *tlbe = &vcpu->arch.guest_tlb[i];
+		struct kvmppc_44x_tlbe *tlbe = &vcpu->arch.guest_tlb[i];
 		unsigned int tid;
 
 		if (eaddr < get_tlb_eaddr(tlbe))
@@ -111,7 +111,8 @@ int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
 	return -1;
 }
 
-struct tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu, gva_t eaddr)
+struct kvmppc_44x_tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu,
+                                               gva_t eaddr)
 {
 	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
 	unsigned int index;
@@ -122,7 +123,8 @@ struct tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu, gva_t eaddr)
 	return &vcpu->arch.guest_tlb[index];
 }
 
-struct tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu, gva_t eaddr)
+struct kvmppc_44x_tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu,
+                                               gva_t eaddr)
 {
 	unsigned int as = !!(vcpu->arch.msr & MSR_DS);
 	unsigned int index;
@@ -133,7 +135,7 @@ struct tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu, gva_t eaddr)
 	return &vcpu->arch.guest_tlb[index];
 }
 
-static int kvmppc_44x_tlbe_is_writable(struct tlbe *tlbe)
+static int kvmppc_44x_tlbe_is_writable(struct kvmppc_44x_tlbe *tlbe)
 {
 	return tlbe->word2 & (PPC44x_TLB_SW|PPC44x_TLB_UW);
 }
@@ -141,7 +143,7 @@ static int kvmppc_44x_tlbe_is_writable(struct tlbe *tlbe)
 static void kvmppc_44x_shadow_release(struct kvm_vcpu *vcpu,
                                       unsigned int index)
 {
-	struct tlbe *stlbe = &vcpu->arch.shadow_tlb[index];
+	struct kvmppc_44x_tlbe *stlbe = &vcpu->arch.shadow_tlb[index];
 	struct page *page = vcpu->arch.shadow_pages[index];
 
 	if (get_tlb_v(stlbe)) {
@@ -171,7 +173,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
                     u32 flags)
 {
 	struct page *new_page;
-	struct tlbe *stlbe;
+	struct kvmppc_44x_tlbe *stlbe;
 	hpa_t hpaddr;
 	unsigned int victim;
 
@@ -227,7 +229,7 @@ static void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
 
 	/* XXX Replace loop with fancy data structures. */
 	for (i = 0; i <= tlb_44x_hwater; i++) {
-		struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
+		struct kvmppc_44x_tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
 		unsigned int tid;
 
 		if (!get_tlb_v(stlbe))
@@ -262,7 +264,7 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 	if (vcpu->arch.swap_pid) {
 		/* XXX Replace loop with fancy data structures. */
 		for (i = 0; i <= tlb_44x_hwater; i++) {
-			struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
+			struct kvmppc_44x_tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
 
 			/* Future optimization: clear only userspace mappings. */
 			kvmppc_44x_shadow_release(vcpu, i);
@@ -279,7 +281,7 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 }
 
 static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
-                             const struct tlbe *tlbe)
+                             const struct kvmppc_44x_tlbe *tlbe)
 {
 	gpa_t gpa;
 
@@ -305,7 +307,7 @@ int kvmppc_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	u64 raddr;
 	u64 asid;
 	u32 flags;
-	struct tlbe *tlbe;
+	struct kvmppc_44x_tlbe *tlbe;
 	unsigned int index;
 
 	index = vcpu->arch.gpr[ra];
diff --git a/arch/powerpc/kvm/44x_tlb.h b/arch/powerpc/kvm/44x_tlb.h
index 2ccd46b..e5b0a76 100644
--- a/arch/powerpc/kvm/44x_tlb.h
+++ b/arch/powerpc/kvm/44x_tlb.h
@@ -25,48 +25,50 @@
 
 extern int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr,
                                 unsigned int pid, unsigned int as);
-extern struct tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu, gva_t eaddr);
-extern struct tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu, gva_t eaddr);
+extern struct kvmppc_44x_tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu,
+                                                      gva_t eaddr);
+extern struct kvmppc_44x_tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu,
+                                                      gva_t eaddr);
 
 /* TLB helper functions */
-static inline unsigned int get_tlb_size(const struct tlbe *tlbe)
+static inline unsigned int get_tlb_size(const struct kvmppc_44x_tlbe *tlbe)
 {
 	return (tlbe->word0 >> 4) & 0xf;
 }
 
-static inline gva_t get_tlb_eaddr(const struct tlbe *tlbe)
+static inline gva_t get_tlb_eaddr(const struct kvmppc_44x_tlbe *tlbe)
 {
 	return tlbe->word0 & 0xfffffc00;
 }
 
-static inline gva_t get_tlb_bytes(const struct tlbe *tlbe)
+static inline gva_t get_tlb_bytes(const struct kvmppc_44x_tlbe *tlbe)
 {
 	unsigned int pgsize = get_tlb_size(tlbe);
 	return 1 << 10 << (pgsize << 1);
 }
 
-static inline gva_t get_tlb_end(const struct tlbe *tlbe)
+static inline gva_t get_tlb_end(const struct kvmppc_44x_tlbe *tlbe)
 {
 	return get_tlb_eaddr(tlbe) + get_tlb_bytes(tlbe) - 1;
 }
 
-static inline u64 get_tlb_raddr(const struct tlbe *tlbe)
+static inline u64 get_tlb_raddr(const struct kvmppc_44x_tlbe *tlbe)
 {
 	u64 word1 = tlbe->word1;
 	return ((word1 & 0xf) << 32) | (word1 & 0xfffffc00);
 }
 
-static inline unsigned int get_tlb_tid(const struct tlbe *tlbe)
+static inline unsigned int get_tlb_tid(const struct kvmppc_44x_tlbe *tlbe)
 {
 	return tlbe->tid & 0xff;
 }
 
-static inline unsigned int get_tlb_ts(const struct tlbe *tlbe)
+static inline unsigned int get_tlb_ts(const struct kvmppc_44x_tlbe *tlbe)
 {
 	return (tlbe->word0 >> 8) & 0x1;
 }
 
-static inline unsigned int get_tlb_v(const struct tlbe *tlbe)
+static inline unsigned int get_tlb_v(const struct kvmppc_44x_tlbe *tlbe)
 {
 	return (tlbe->word0 >> 9) & 0x1;
 }
@@ -81,7 +83,7 @@ static inline unsigned int get_mmucr_sts(const struct kvm_vcpu *vcpu)
 	return (vcpu->arch.mmucr >> 16) & 0x1;
 }
 
-static inline gpa_t tlb_xlate(struct tlbe *tlbe, gva_t eaddr)
+static inline gpa_t tlb_xlate(struct kvmppc_44x_tlbe *tlbe, gva_t eaddr)
 {
 	unsigned int pgmask = get_tlb_bytes(tlbe) - 1;
 
diff --git a/arch/powerpc/kvm/booke_guest.c b/arch/powerpc/kvm/booke_guest.c
index c0f8532..41bbf4c 100644
--- a/arch/powerpc/kvm/booke_guest.c
+++ b/arch/powerpc/kvm/booke_guest.c
@@ -307,7 +307,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 
 	case BOOKE_INTERRUPT_DTLB_MISS: {
-		struct tlbe *gtlbe;
+		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.fault_dear;
 		gfn_t gfn;
 
@@ -347,7 +347,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	}
 
 	case BOOKE_INTERRUPT_ITLB_MISS: {
-		struct tlbe *gtlbe;
+		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.pc;
 		gfn_t gfn;
 
@@ -442,7 +442,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 /* Initial guest state: 16MB mapping 0 -> 0, PC = 0, MSR = 0, R1 = 16MB */
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
-	struct tlbe *tlbe = &vcpu->arch.guest_tlb[0];
+	struct kvmppc_44x_tlbe *tlbe = &vcpu->arch.guest_tlb[0];
 
 	tlbe->tid = 0;
 	tlbe->word0 = PPC44x_TLB_16M | PPC44x_TLB_VALID;
@@ -553,7 +553,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
                                   struct kvm_translation *tr)
 {
-	struct tlbe *gtlbe;
+	struct kvmppc_44x_tlbe *gtlbe;
 	int index;
 	gva_t eaddr;
 	u8 pid;
-- 
1.6.0.3

