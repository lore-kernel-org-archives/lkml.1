Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZHSNNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZHSNNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHSNMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:12:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50554 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751915AbZHSNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/47] KVM: MMU: add kvm_mmu_get_spte_hierarchy helper
Date: Wed, 19 Aug 2009 16:02:07 +0300
Message-Id: <1250686963-8357-12-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Required by EPT misconfiguration handler.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   18 ++++++++++++++++++
 arch/x86/kvm/mmu.h |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e18f65b..12974de 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3038,6 +3038,24 @@ out:
 	return r;
 }
 
+int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
+{
+	struct kvm_shadow_walk_iterator iterator;
+	int nr_sptes = 0;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	for_each_shadow_entry(vcpu, addr, iterator) {
+		sptes[iterator.level-1] = *iterator.sptep;
+		nr_sptes++;
+		if (!is_shadow_present_pte(*iterator.sptep))
+			break;
+	}
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	return nr_sptes;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
+
 #ifdef AUDIT
 
 static const char *audit_msg;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 016bf71..61a1b38 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -37,6 +37,8 @@
 #define PT32_ROOT_LEVEL 2
 #define PT32E_ROOT_LEVEL 3
 
+int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
+
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
 	if (unlikely(vcpu->kvm->arch.n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-- 
1.6.3.3

