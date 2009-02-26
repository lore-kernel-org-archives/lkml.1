Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbZBZOUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbZBZOUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbZBZOQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43058 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 11/40] KVM: SVM: Only allow setting of EFER_SVME when CPUID SVM is set
Date: Thu, 26 Feb 2009 16:15:01 +0200
Message-Id: <1235657730-27683-12-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Userspace has to tell the kernel module somehow that nested SVM should be used.
The easiest way that doesn't break anything I could think of is to implement

if (cpuid & svm)
    allow write to efer
else
    deny write to efer

Old userspaces mask the SVM capability bit, so they don't break.
In order to find out that the SVM capability is set, I had to split the
kvm_emulate_cpuid into a finding and an emulating part.

(introduced in v6)

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   58 +++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99165a9..b5e9932 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -69,6 +69,8 @@ static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffffeULL;
 
 static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 				    struct kvm_cpuid_entry2 __user *entries);
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
+					      u32 function, u32 index);
 
 struct kvm_x86_ops *kvm_x86_ops;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
@@ -173,6 +175,7 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 			   u32 error_code)
 {
 	++vcpu->stat.pf_guest;
+
 	if (vcpu->arch.exception.pending) {
 		if (vcpu->arch.exception.nr == PF_VECTOR) {
 			printk(KERN_DEBUG "kvm: inject_page_fault:"
@@ -442,6 +445,11 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_get_cr8);
 
+static inline u32 bit(int bitno)
+{
+	return 1 << (bitno & 31);
+}
+
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
@@ -481,6 +489,17 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		return;
 	}
 
+	if (efer & EFER_SVME) {
+		struct kvm_cpuid_entry2 *feat;
+
+		feat = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
+		if (!feat || !(feat->ecx & bit(X86_FEATURE_SVM))) {
+			printk(KERN_DEBUG "set_efer: #GP, enable SVM w/o SVM\n");
+			kvm_inject_gp(vcpu, 0);
+			return;
+		}
+	}
+
 	kvm_x86_ops->set_efer(vcpu, efer);
 
 	efer &= ~EFER_LMA;
@@ -1181,11 +1200,6 @@ out:
 	return r;
 }
 
-static inline u32 bit(int bitno)
-{
-	return 1 << (bitno & 31);
-}
-
 static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			  u32 index)
 {
@@ -1228,7 +1242,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_supported_word3_x86_features =
 		bit(X86_FEATURE_XMM3) | bit(X86_FEATURE_CX16);
 	const u32 kvm_supported_word6_x86_features =
-		bit(X86_FEATURE_LAHF_LM) | bit(X86_FEATURE_CMP_LEGACY);
+		bit(X86_FEATURE_LAHF_LM) | bit(X86_FEATURE_CMP_LEGACY) |
+		bit(X86_FEATURE_SVM);
 
 	/* all func 2 cpuid_count() should be called on the same cpu */
 	get_cpu();
@@ -2832,20 +2847,15 @@ static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
 	return 1;
 }
 
-void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
+					      u32 function, u32 index)
 {
 	int i;
-	u32 function, index;
-	struct kvm_cpuid_entry2 *e, *best;
+	struct kvm_cpuid_entry2 *best = NULL;
 
-	function = kvm_register_read(vcpu, VCPU_REGS_RAX);
-	index = kvm_register_read(vcpu, VCPU_REGS_RCX);
-	kvm_register_write(vcpu, VCPU_REGS_RAX, 0);
-	kvm_register_write(vcpu, VCPU_REGS_RBX, 0);
-	kvm_register_write(vcpu, VCPU_REGS_RCX, 0);
-	kvm_register_write(vcpu, VCPU_REGS_RDX, 0);
-	best = NULL;
 	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
+		struct kvm_cpuid_entry2 *e;
+
 		e = &vcpu->arch.cpuid_entries[i];
 		if (is_matching_cpuid_entry(e, function, index)) {
 			if (e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC)
@@ -2860,6 +2870,22 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 			if (!best || e->function > best->function)
 				best = e;
 	}
+
+	return best;
+}
+
+void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 function, index;
+	struct kvm_cpuid_entry2 *best;
+
+	function = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	index = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	kvm_register_write(vcpu, VCPU_REGS_RAX, 0);
+	kvm_register_write(vcpu, VCPU_REGS_RBX, 0);
+	kvm_register_write(vcpu, VCPU_REGS_RCX, 0);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, 0);
+	best = kvm_find_cpuid_entry(vcpu, function, index);
 	if (best) {
 		kvm_register_write(vcpu, VCPU_REGS_RAX, best->eax);
 		kvm_register_write(vcpu, VCPU_REGS_RBX, best->ebx);
-- 
1.6.0.6

