Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYLHLln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYLHLln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYLHLhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48257 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 18/45] KVM: Improve MTRR structure
Date: Mon,  8 Dec 2008 13:36:29 +0200
Message-Id: <1228736216-15787-19-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

As well as reset mmu context when set MTRR.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/include/asm/kvm_host.h |    5 ++-
 arch/x86/kvm/x86.c              |   61 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a40fa84..8082e87 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -21,6 +21,7 @@
 
 #include <asm/pvclock-abi.h>
 #include <asm/desc.h>
+#include <asm/mtrr.h>
 
 #define KVM_MAX_VCPUS 16
 #define KVM_MEMORY_SLOTS 32
@@ -86,6 +87,7 @@
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 40
+#define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 
 extern spinlock_t kvm_lock;
@@ -329,7 +331,8 @@ struct kvm_vcpu_arch {
 	bool nmi_injected;
 	bool nmi_window_open;
 
-	u64 mtrr[0x100];
+	struct mtrr_state_type mtrr_state;
+	u32 pat;
 };
 
 struct kvm_mem_alias {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2c4b55..f5b2334 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -39,6 +39,7 @@
 #include <asm/uaccess.h>
 #include <asm/msr.h>
 #include <asm/desc.h>
+#include <asm/mtrr.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -650,10 +651,38 @@ static bool msr_mtrr_valid(unsigned msr)
 
 static int set_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
+	u64 *p = (u64 *)&vcpu->arch.mtrr_state.fixed_ranges;
+
 	if (!msr_mtrr_valid(msr))
 		return 1;
 
-	vcpu->arch.mtrr[msr - 0x200] = data;
+	if (msr == MSR_MTRRdefType) {
+		vcpu->arch.mtrr_state.def_type = data;
+		vcpu->arch.mtrr_state.enabled = (data & 0xc00) >> 10;
+	} else if (msr == MSR_MTRRfix64K_00000)
+		p[0] = data;
+	else if (msr == MSR_MTRRfix16K_80000 || msr == MSR_MTRRfix16K_A0000)
+		p[1 + msr - MSR_MTRRfix16K_80000] = data;
+	else if (msr >= MSR_MTRRfix4K_C0000 && msr <= MSR_MTRRfix4K_F8000)
+		p[3 + msr - MSR_MTRRfix4K_C0000] = data;
+	else if (msr == MSR_IA32_CR_PAT)
+		vcpu->arch.pat = data;
+	else {	/* Variable MTRRs */
+		int idx, is_mtrr_mask;
+		u64 *pt;
+
+		idx = (msr - 0x200) / 2;
+		is_mtrr_mask = msr - 0x200 - 2 * idx;
+		if (!is_mtrr_mask)
+			pt =
+			  (u64 *)&vcpu->arch.mtrr_state.var_ranges[idx].base_lo;
+		else
+			pt =
+			  (u64 *)&vcpu->arch.mtrr_state.var_ranges[idx].mask_lo;
+		*pt = data;
+	}
+
+	kvm_mmu_reset_context(vcpu);
 	return 0;
 }
 
@@ -749,10 +778,37 @@ int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 
 static int get_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
+	u64 *p = (u64 *)&vcpu->arch.mtrr_state.fixed_ranges;
+
 	if (!msr_mtrr_valid(msr))
 		return 1;
 
-	*pdata = vcpu->arch.mtrr[msr - 0x200];
+	if (msr == MSR_MTRRdefType)
+		*pdata = vcpu->arch.mtrr_state.def_type +
+			 (vcpu->arch.mtrr_state.enabled << 10);
+	else if (msr == MSR_MTRRfix64K_00000)
+		*pdata = p[0];
+	else if (msr == MSR_MTRRfix16K_80000 || msr == MSR_MTRRfix16K_A0000)
+		*pdata = p[1 + msr - MSR_MTRRfix16K_80000];
+	else if (msr >= MSR_MTRRfix4K_C0000 && msr <= MSR_MTRRfix4K_F8000)
+		*pdata = p[3 + msr - MSR_MTRRfix4K_C0000];
+	else if (msr == MSR_IA32_CR_PAT)
+		*pdata = vcpu->arch.pat;
+	else {	/* Variable MTRRs */
+		int idx, is_mtrr_mask;
+		u64 *pt;
+
+		idx = (msr - 0x200) / 2;
+		is_mtrr_mask = msr - 0x200 - 2 * idx;
+		if (!is_mtrr_mask)
+			pt =
+			  (u64 *)&vcpu->arch.mtrr_state.var_ranges[idx].base_lo;
+		else
+			pt =
+			  (u64 *)&vcpu->arch.mtrr_state.var_ranges[idx].mask_lo;
+		*pdata = *pt;
+	}
+
 	return 0;
 }
 
@@ -3942,6 +3998,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	/* We do fxsave: this must be aligned. */
 	BUG_ON((unsigned long)&vcpu->arch.host_fx_image & 0xF);
 
+	vcpu->arch.mtrr_state.have_fixed = 1;
 	vcpu_load(vcpu);
 	r = kvm_arch_vcpu_reset(vcpu);
 	if (r == 0)
-- 
1.6.0.3

