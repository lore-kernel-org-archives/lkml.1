Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYFZMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYFZMnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYFZM3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:47 -0400
Received: from il.qumranet.com ([212.179.150.194]:32343 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYFZM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/50] KVM: MTRR support
Date: Thu, 26 Jun 2008 15:28:03 +0300
Message-Id: <1214483312-9265-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add emulation for the memory type range registers, needed by VMware esx 3.5,
and by pci device assignment.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |   52 ++++++++++++++++++++++++++++++++++++++++---
 include/asm-x86/kvm_host.h |    3 ++
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cab5f92..2095e79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -611,6 +611,38 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
 }
 
+static bool msr_mtrr_valid(unsigned msr)
+{
+	switch (msr) {
+	case 0x200 ... 0x200 + 2 * KVM_NR_VAR_MTRR - 1:
+	case MSR_MTRRfix64K_00000:
+	case MSR_MTRRfix16K_80000:
+	case MSR_MTRRfix16K_A0000:
+	case MSR_MTRRfix4K_C0000:
+	case MSR_MTRRfix4K_C8000:
+	case MSR_MTRRfix4K_D0000:
+	case MSR_MTRRfix4K_D8000:
+	case MSR_MTRRfix4K_E0000:
+	case MSR_MTRRfix4K_E8000:
+	case MSR_MTRRfix4K_F0000:
+	case MSR_MTRRfix4K_F8000:
+	case MSR_MTRRdefType:
+	case MSR_IA32_CR_PAT:
+		return true;
+	case 0x2f8:
+		return true;
+	}
+	return false;
+}
+
+static int set_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	if (!msr_mtrr_valid(msr))
+		return 1;
+
+	vcpu->arch.mtrr[msr - 0x200] = data;
+	return 0;
+}
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
@@ -632,8 +664,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_UCODE_WRITE:
-	case 0x200 ... 0x2ff: /* MTRRs */
 		break;
+	case 0x200 ... 0x2ff:
+		return set_msr_mtrr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		kvm_set_apic_base(vcpu, data);
 		break;
@@ -691,6 +724,15 @@ int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 	return kvm_x86_ops->get_msr(vcpu, msr_index, pdata);
 }
 
+static int get_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+{
+	if (!msr_mtrr_valid(msr))
+		return 1;
+
+	*pdata = vcpu->arch.mtrr[msr - 0x200];
+	return 0;
+}
+
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
 	u64 data;
@@ -712,11 +754,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MC0_MISC+16:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_EBL_CR_POWERON:
-		/* MTRR registers */
-	case 0xfe:
-	case 0x200 ... 0x2ff:
 		data = 0;
 		break;
+	case MSR_MTRRcap:
+		data = 0x500 | KVM_NR_VAR_MTRR;
+		break;
+	case 0x200 ... 0x2ff:
+		return get_msr_mtrr(vcpu, msr, pdata);
 	case 0xcd: /* fsb frequency */
 		data = 3;
 		break;
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 075598b..fc72bad 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -79,6 +79,7 @@
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 40
+#define KVM_NR_VAR_MTRR 8
 
 extern spinlock_t kvm_lock;
 extern struct list_head vm_list;
@@ -290,6 +291,8 @@ struct kvm_vcpu_arch {
 	struct page *time_page;
 
 	bool nmi_pending;
+
+	u64 mtrr[0x100];
 };
 
 struct kvm_mem_alias {
-- 
1.5.6

