Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbZETLc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbZETLc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZETLVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55260 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbZETLSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 05/46] KVM: MMU: Emulate #PF error code of reserved bits violation
Date: Wed, 20 May 2009 14:18:02 +0300
Message-Id: <1242818323-10413-6-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong, Eddie <eddie.dong@intel.com>

Detect, indicate, and propagate page faults where reserved bits are set.
Take care to handle the different paging modes, each of which has different
sets of reserved bits.

[avi: fix pte reserved bits for efer.nxe=0]

Signed-off-by: Eddie Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |   69 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h      |    7 ++++
 arch/x86/kvm/x86.c              |   10 ++++++
 4 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8351c4d..548b97d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -261,6 +261,7 @@ struct kvm_mmu {
 	union kvm_mmu_page_role base_role;
 
 	u64 *pae_root;
+	u64 rsvd_bits_mask[2][4];
 };
 
 struct kvm_vcpu_arch {
@@ -791,5 +792,6 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_age_hva(struct kvm *kvm, unsigned long hva);
+int cpuid_maxphyaddr(struct kvm_vcpu *vcpu);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9256484..24f5a57 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -126,6 +126,7 @@ module_param(oos_shadow, bool, 0644);
 #define PFERR_PRESENT_MASK (1U << 0)
 #define PFERR_WRITE_MASK (1U << 1)
 #define PFERR_USER_MASK (1U << 2)
+#define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
 
 #define PT_DIRECTORY_LEVEL 2
@@ -179,6 +180,11 @@ static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
 static u64 __read_mostly shadow_mt_mask;
 
+static inline u64 rsvd_bits(int s, int e)
+{
+	return ((1ULL << (e - s + 1)) - 1) << s;
+}
+
 void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte)
 {
 	shadow_trap_nonpresent_pte = trap_pte;
@@ -2151,6 +2157,14 @@ static void paging_free(struct kvm_vcpu *vcpu)
 	nonpaging_free(vcpu);
 }
 
+static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
+{
+	int bit7;
+
+	bit7 = (gpte >> 7) & 1;
+	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
+}
+
 #define PTTYPE 64
 #include "paging_tmpl.h"
 #undef PTTYPE
@@ -2159,6 +2173,55 @@ static void paging_free(struct kvm_vcpu *vcpu)
 #include "paging_tmpl.h"
 #undef PTTYPE
 
+static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
+{
+	struct kvm_mmu *context = &vcpu->arch.mmu;
+	int maxphyaddr = cpuid_maxphyaddr(vcpu);
+	u64 exb_bit_rsvd = 0;
+
+	if (!is_nx(vcpu))
+		exb_bit_rsvd = rsvd_bits(63, 63);
+	switch (level) {
+	case PT32_ROOT_LEVEL:
+		/* no rsvd bits for 2 level 4K page table entries */
+		context->rsvd_bits_mask[0][1] = 0;
+		context->rsvd_bits_mask[0][0] = 0;
+		if (is_cpuid_PSE36())
+			/* 36bits PSE 4MB page */
+			context->rsvd_bits_mask[1][1] = rsvd_bits(17, 21);
+		else
+			/* 32 bits PSE 4MB page */
+			context->rsvd_bits_mask[1][1] = rsvd_bits(13, 21);
+		context->rsvd_bits_mask[1][0] = ~0ull;
+		break;
+	case PT32E_ROOT_LEVEL:
+		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 62);		/* PDE */
+		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 62); 	/* PTE */
+		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 62) |
+			rsvd_bits(13, 20);		/* large page */
+		context->rsvd_bits_mask[1][0] = ~0ull;
+		break;
+	case PT64_ROOT_LEVEL:
+		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
+		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
+		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
+		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 51);
+		context->rsvd_bits_mask[1][3] = context->rsvd_bits_mask[0][3];
+		context->rsvd_bits_mask[1][2] = context->rsvd_bits_mask[0][2];
+		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 51) | rsvd_bits(13, 20);
+		context->rsvd_bits_mask[1][0] = ~0ull;
+		break;
+	}
+}
+
 static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 {
 	struct kvm_mmu *context = &vcpu->arch.mmu;
@@ -2179,6 +2242,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 
 static int paging64_init_context(struct kvm_vcpu *vcpu)
 {
+	reset_rsvds_bits_mask(vcpu, PT64_ROOT_LEVEL);
 	return paging64_init_context_common(vcpu, PT64_ROOT_LEVEL);
 }
 
@@ -2186,6 +2250,7 @@ static int paging32_init_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *context = &vcpu->arch.mmu;
 
+	reset_rsvds_bits_mask(vcpu, PT32_ROOT_LEVEL);
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
@@ -2201,6 +2266,7 @@ static int paging32_init_context(struct kvm_vcpu *vcpu)
 
 static int paging32E_init_context(struct kvm_vcpu *vcpu)
 {
+	reset_rsvds_bits_mask(vcpu, PT32E_ROOT_LEVEL);
 	return paging64_init_context_common(vcpu, PT32E_ROOT_LEVEL);
 }
 
@@ -2221,12 +2287,15 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
+		reset_rsvds_bits_mask(vcpu, PT64_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT64_ROOT_LEVEL;
 	} else if (is_pae(vcpu)) {
+		reset_rsvds_bits_mask(vcpu, PT32E_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT32E_ROOT_LEVEL;
 	} else {
+		reset_rsvds_bits_mask(vcpu, PT32_ROOT_LEVEL);
 		context->gva_to_gpa = paging32_gva_to_gpa;
 		context->root_level = PT32_ROOT_LEVEL;
 	}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index eae9499..09782a9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -123,6 +123,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	gfn_t table_gfn;
 	unsigned index, pt_access, pte_access;
 	gpa_t pte_gpa;
+	int rsvd_fault = 0;
 
 	pgprintk("%s: addr %lx\n", __func__, addr);
 walk:
@@ -157,6 +158,10 @@ walk:
 		if (!is_present_pte(pte))
 			goto not_present;
 
+		rsvd_fault = is_rsvd_bits_set(vcpu, pte, walker->level);
+		if (rsvd_fault)
+			goto access_error;
+
 		if (write_fault && !is_writeble_pte(pte))
 			if (user_fault || is_write_protection(vcpu))
 				goto access_error;
@@ -232,6 +237,8 @@ err:
 		walker->error_code |= PFERR_USER_MASK;
 	if (fetch_fault)
 		walker->error_code |= PFERR_FETCH_MASK;
+	if (rsvd_fault)
+		walker->error_code |= PFERR_RSVD_MASK;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab61ea6..12ada0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3013,6 +3013,16 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 	return best;
 }
 
+int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
+	if (best)
+		return best->eax & 0xff;
+	return 36;
+}
+
 void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 {
 	u32 function, index;
-- 
1.6.0.6

