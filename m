Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbYGOMS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbYGOMS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbYGOMNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:13:01 -0400
Received: from il.qumranet.com ([212.179.150.194]:30362 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbYGOMMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 11/19] KVM: VMX: Add ept_sync_context in flush_tlb
Date: Tue, 15 Jul 2008 15:12:30 +0300
Message-Id: <1216123958-10717-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Fix a potention issue caused by kvm_mmu_slot_remove_write_access(). The
old behavior don't sync EPT TLB with modified EPT entry, which result
in inconsistent content of EPT TLB and EPT table.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ea6bcf5..d300aa1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -91,6 +91,7 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 }
 
 static int init_rmode(struct kvm *kvm);
+static u64 construct_eptp(unsigned long root_hpa);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
@@ -1422,6 +1423,8 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	vpid_sync_vcpu_all(to_vmx(vcpu));
+	if (vm_need_ept())
+		ept_sync_context(construct_eptp(vcpu->arch.mmu.root_hpa));
 }
 
 static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
-- 
1.5.6.1

