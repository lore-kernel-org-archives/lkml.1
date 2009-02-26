Return-Path: <linux-kernel-owner+w=401wt.eu-S1762348AbZBZO35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762348AbZBZO35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbZBZORh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43070 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/40] KVM: MMU: Inherit a shadow page's guest level count from vcpu setup
Date: Thu, 26 Feb 2009 16:15:10 +0200
Message-Id: <1235657730-27683-21-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of "calculating" it on every shadow page allocation, set it once
when switching modes, and copy it when allocating pages.

This doesn't buy us much, but sets up the stage for inheriting more
information related to the mmu setup.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0a4dab2..28f875f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -244,6 +244,7 @@ struct kvm_mmu {
 	hpa_t root_hpa;
 	int root_level;
 	int shadow_root_level;
+	union kvm_mmu_page_role base_role;
 
 	u64 *pae_root;
 };
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2d4477c..f15023c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1204,8 +1204,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *tmp;
 
-	role.word = 0;
-	role.glevels = vcpu->arch.mmu.root_level;
+	role = vcpu->arch.mmu.base_role;
 	role.level = level;
 	role.metaphysical = metaphysical;
 	role.access = access;
@@ -2251,17 +2250,23 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 
 static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
+	int r;
+
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (!is_paging(vcpu))
-		return nonpaging_init_context(vcpu);
+		r = nonpaging_init_context(vcpu);
 	else if (is_long_mode(vcpu))
-		return paging64_init_context(vcpu);
+		r = paging64_init_context(vcpu);
 	else if (is_pae(vcpu))
-		return paging32E_init_context(vcpu);
+		r = paging32E_init_context(vcpu);
 	else
-		return paging32_init_context(vcpu);
+		r = paging32_init_context(vcpu);
+
+	vcpu->arch.mmu.base_role.glevels = vcpu->arch.mmu.root_level;
+
+	return r;
 }
 
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
-- 
1.6.0.6

