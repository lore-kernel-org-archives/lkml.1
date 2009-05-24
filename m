Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbZEXQCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbZEXQCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbZEXPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:55:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 10/45] KVM: Replace get_mt_mask_shift with get_mt_mask
Date: Sun, 24 May 2009 18:49:55 +0300
Message-Id: <1243180230-2480-11-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Shadow_mt_mask is out of date, now it have only been used as a flag to indicate
if TDP enabled. Get rid of it and use tdp_enabled instead.

Also put memory type logical in kvm_x86_ops->get_mt_mask().

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    5 +++--
 arch/x86/kvm/mmu.c              |   21 ++++++---------------
 arch/x86/kvm/svm.c              |    4 ++--
 arch/x86/kvm/vmx.c              |   17 ++++++++++++-----
 arch/x86/kvm/x86.c              |    2 +-
 5 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e94d05..8a6f6b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -522,7 +522,7 @@ struct kvm_x86_ops {
 	void (*drop_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
-	int (*get_mt_mask_shift)(void);
+	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
@@ -536,7 +536,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu);
 void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
 void kvm_mmu_set_base_ptes(u64 base_pte);
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
-		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 mt_mask);
+		u64 dirty_mask, u64 nx_mask, u64 x_mask);
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
@@ -550,6 +550,7 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
 int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 		  gpa_t addr, unsigned long *ret);
+u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 extern bool tdp_enabled;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a55373c..8fcdae9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -178,7 +178,6 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
-static u64 __read_mostly shadow_mt_mask;
 
 static inline u64 rsvd_bits(int s, int e)
 {
@@ -199,14 +198,13 @@ void kvm_mmu_set_base_ptes(u64 base_pte)
 EXPORT_SYMBOL_GPL(kvm_mmu_set_base_ptes);
 
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
-		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 mt_mask)
+		u64 dirty_mask, u64 nx_mask, u64 x_mask)
 {
 	shadow_user_mask = user_mask;
 	shadow_accessed_mask = accessed_mask;
 	shadow_dirty_mask = dirty_mask;
 	shadow_nx_mask = nx_mask;
 	shadow_x_mask = x_mask;
-	shadow_mt_mask = mt_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
@@ -1608,7 +1606,7 @@ static int get_mtrr_type(struct mtrr_state_type *mtrr_state,
 	return mtrr_state->def_type;
 }
 
-static u8 get_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
+u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	u8 mtrr;
 
@@ -1618,6 +1616,7 @@ static u8 get_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 		mtrr = MTRR_TYPE_WRBACK;
 	return mtrr;
 }
+EXPORT_SYMBOL_GPL(kvm_get_guest_memory_type);
 
 static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
@@ -1670,7 +1669,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 {
 	u64 spte;
 	int ret = 0;
-	u64 mt_mask = shadow_mt_mask;
 
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
@@ -1690,16 +1688,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		spte |= shadow_user_mask;
 	if (largepage)
 		spte |= PT_PAGE_SIZE_MASK;
-	if (mt_mask) {
-		if (!kvm_is_mmio_pfn(pfn)) {
-			mt_mask = get_memory_type(vcpu, gfn) <<
-				kvm_x86_ops->get_mt_mask_shift();
-			mt_mask |= VMX_EPT_IGMT_BIT;
-		} else
-			mt_mask = MTRR_TYPE_UNCACHABLE <<
-				kvm_x86_ops->get_mt_mask_shift();
-		spte |= mt_mask;
-	}
+	if (tdp_enabled)
+		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
+			kvm_is_mmio_pfn(pfn));
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d96a6d3..6350378 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2589,7 +2589,7 @@ static int get_npt_level(void)
 #endif
 }
 
-static int svm_get_mt_mask_shift(void)
+static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	return 0;
 }
@@ -2652,7 +2652,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
-	.get_mt_mask_shift = svm_get_mt_mask_shift,
+	.get_mt_mask = svm_get_mt_mask,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 25be53a..59b080c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3577,9 +3577,17 @@ static int get_ept_level(void)
 	return VMX_EPT_DEFAULT_GAW + 1;
 }
 
-static int vmx_get_mt_mask_shift(void)
+static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
-	return VMX_EPT_MT_EPTE_SHIFT;
+	u64 ret;
+
+	if (is_mmio)
+		ret = MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+	else
+		ret = (kvm_get_guest_memory_type(vcpu, gfn) <<
+			VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IGMT_BIT;
+
+	return ret;
 }
 
 static struct kvm_x86_ops vmx_x86_ops = {
@@ -3639,7 +3647,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
-	.get_mt_mask_shift = vmx_get_mt_mask_shift,
+	.get_mt_mask = vmx_get_mt_mask,
 };
 
 static int __init vmx_init(void)
@@ -3698,8 +3706,7 @@ static int __init vmx_init(void)
 		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
 			VMX_EPT_WRITABLE_MASK);
 		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
-				VMX_EPT_EXECUTABLE_MASK,
-				VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT);
+				VMX_EPT_EXECUTABLE_MASK);
 		kvm_enable_tdp();
 	} else
 		kvm_disable_tdp();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c92d42b..2d7082c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2768,7 +2768,7 @@ int kvm_arch_init(void *opaque)
 	kvm_mmu_set_nonpresent_ptes(0ull, 0ull);
 	kvm_mmu_set_base_ptes(PT_PRESENT_MASK);
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
-			PT_DIRTY_MASK, PT64_NX_MASK, 0, 0);
+			PT_DIRTY_MASK, PT64_NX_MASK, 0);
 
 	for_each_possible_cpu(cpu)
 		per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
-- 
1.6.0.6

