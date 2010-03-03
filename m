Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0CCTM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:12:57 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26342 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0CCTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:12:52 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h6bh87h67h)
X-Spam-TCS-SCL: 6:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ015-02-H4Z-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/18] KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
Date: Wed, 3 Mar 2010 20:12:06 +0100
Message-ID: <1267643541-451-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0501 (UTC) FILETIME=[7FB0E350:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary to implement Nested Nested Paging. As a
side effect this allows some cleanups in the SVM nested
paging code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e7bef19..887a1f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -241,6 +241,7 @@ struct kvm_pio_request {
  */
 struct kvm_mmu {
 	void (*new_cr3)(struct kvm_vcpu *vcpu);
+	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5c66c99..ec3da11 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2398,6 +2398,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.tdp_enabled = true;
+	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2437,6 +2438,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu.base_role.glevels = vcpu->arch.mmu.root_level;
 	vcpu->arch.mmu.tdp_enabled       = false;
+	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 
 	return r;
 }
@@ -2482,7 +2484,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	/* set_cr3() should ensure TLB has been flushed */
-	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
+	vcpu->arch.mmu.set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
 out:
 	return r;
 }
-- 
1.7.0


