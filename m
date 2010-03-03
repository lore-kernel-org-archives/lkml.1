Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0CCTOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:14:00 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26994 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab0CCTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:20 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01B-02-H5F-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/18] KVM: MMU: Propagate the right fault back to the guest after gva_to_gpa
Date: Wed, 3 Mar 2010 20:12:18 +0100
Message-ID: <1267643541-451-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0813 (UTC) FILETIME=[7FE07ED0:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements logic to make sure that either a
page-fault/page-fault-vmexit or a nested-page-fault-vmexit
is propagated back to the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.h         |    1 +
 arch/x86/kvm/paging_tmpl.h |    2 ++
 arch/x86/kvm/x86.c         |   15 ++++++++++++++-
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 64f619b..b42b27e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -47,6 +47,7 @@
 #define PFERR_USER_MASK (1U << 2)
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
+#define PFERR_NESTED_MASK (1U << 31)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index c0158d8..9fc5fb1 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -154,6 +154,7 @@ walk:
 
 		pte_gpa = mmu->translate_gpa(vcpu, pte_gpa, &error);
 		if (pte_gpa == UNMAPPED_GVA) {
+			error |= PFERR_NESTED_MASK;
 			walker->error_code = error;
 			return 0;
 		}
@@ -223,6 +224,7 @@ walk:
 			pte_gpa = gfn_to_gpa(walker->gfn);
 			pte_gpa = mmu->translate_gpa(vcpu, pte_gpa, &error);
 			if (pte_gpa == UNMAPPED_GVA) {
+				error |= PFERR_NESTED_MASK;
 				walker->error_code = error;
 				return 0;
 			}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2883ce8..9f8b02d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -314,6 +314,19 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
 
+void kvm_propagate_fault(struct kvm_vcpu *vcpu, unsigned long addr, u32 error_code)
+{
+	u32 nested, error;
+
+	nested = error_code &  PFERR_NESTED_MASK;
+	error  = error_code & ~PFERR_NESTED_MASK;
+
+	if (vcpu->arch.mmu.nested && !(error_code && PFERR_NESTED_MASK))
+		vcpu->arch.nested_mmu.inject_page_fault(vcpu, addr, error);
+	else
+		vcpu->arch.mmu.inject_page_fault(vcpu, addr, error);
+}
+
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.nmi_pending = 1;
@@ -3546,7 +3559,7 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
 		ret = kvm_read_guest_virt(q, p, bytes, vcpu, &error_code);
 
 	if (ret == X86EMUL_PROPAGATE_FAULT)
-		kvm_inject_page_fault(vcpu, q, error_code);
+		kvm_propagate_fault(vcpu, q, error_code);
 
 	return ret;
 }
-- 
1.7.0


