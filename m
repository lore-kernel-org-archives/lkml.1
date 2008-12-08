Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYLHLm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYLHLm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYLHLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48251 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 21/45] KVM: Enable MTRR for EPT
Date: Mon,  8 Dec 2008 13:36:32 +0200
Message-Id: <1228736216-15787-22-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

The effective memory type of EPT is the mixture of MSR_IA32_CR_PAT and memory
type field of EPT entry.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/include/asm/kvm_host.h |    3 ++-
 arch/x86/kvm/mmu.c              |   11 ++++++++++-
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |   10 ++++++++--
 arch/x86/kvm/x86.c              |    2 +-
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8082e87..93040b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -483,6 +483,7 @@ struct kvm_x86_ops {
 
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
+	int (*get_mt_mask_shift)(void);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
@@ -496,7 +497,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu);
 void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
 void kvm_mmu_set_base_ptes(u64 base_pte);
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
-		u64 dirty_mask, u64 nx_mask, u64 x_mask);
+		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 mt_mask);
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ac2304f..09d05f5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -168,6 +168,7 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
+static u64 __read_mostly shadow_mt_mask;
 
 void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte)
 {
@@ -183,13 +184,14 @@ void kvm_mmu_set_base_ptes(u64 base_pte)
 EXPORT_SYMBOL_GPL(kvm_mmu_set_base_ptes);
 
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
-		u64 dirty_mask, u64 nx_mask, u64 x_mask)
+		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 mt_mask)
 {
 	shadow_user_mask = user_mask;
 	shadow_accessed_mask = accessed_mask;
 	shadow_dirty_mask = dirty_mask;
 	shadow_nx_mask = nx_mask;
 	shadow_x_mask = x_mask;
+	shadow_mt_mask = mt_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
@@ -1546,6 +1548,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 {
 	u64 spte;
 	int ret = 0;
+	u64 mt_mask = shadow_mt_mask;
+
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
@@ -1564,6 +1568,11 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		spte |= shadow_user_mask;
 	if (largepage)
 		spte |= PT_PAGE_SIZE_MASK;
+	if (mt_mask) {
+		mt_mask = get_memory_type(vcpu, gfn) <<
+			  kvm_x86_ops->get_mt_mask_shift();
+		spte |= mt_mask;
+	}
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9c4ce65..05efc4e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1912,6 +1912,11 @@ static int get_npt_level(void)
 #endif
 }
 
+static int svm_get_mt_mask_shift(void)
+{
+	return 0;
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -1967,6 +1972,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
+	.get_mt_mask_shift = svm_get_mt_mask_shift,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b4c95a5..dae134f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3574,6 +3574,11 @@ static int get_ept_level(void)
 	return VMX_EPT_DEFAULT_GAW + 1;
 }
 
+static int vmx_get_mt_mask_shift(void)
+{
+	return VMX_EPT_MT_EPTE_SHIFT;
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -3629,6 +3634,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
+	.get_mt_mask_shift = vmx_get_mt_mask_shift,
 };
 
 static int __init vmx_init(void)
@@ -3685,10 +3691,10 @@ static int __init vmx_init(void)
 		bypass_guest_pf = 0;
 		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
 			VMX_EPT_WRITABLE_MASK |
-			VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT |
 			VMX_EPT_IGMT_BIT);
 		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
-				VMX_EPT_EXECUTABLE_MASK);
+				VMX_EPT_EXECUTABLE_MASK,
+				VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT);
 		kvm_enable_tdp();
 	} else
 		kvm_disable_tdp();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0edf753..f175b79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2615,7 +2615,7 @@ int kvm_arch_init(void *opaque)
 	kvm_mmu_set_nonpresent_ptes(0ull, 0ull);
 	kvm_mmu_set_base_ptes(PT_PRESENT_MASK);
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
-			PT_DIRTY_MASK, PT64_NX_MASK, 0);
+			PT_DIRTY_MASK, PT64_NX_MASK, 0, 0);
 	return 0;
 
 out:
-- 
1.6.0.3

