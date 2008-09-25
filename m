Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYIYMCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYIYMCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYIYL4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48592 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbYIYL4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:03 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 25/39] KVM: MMU: Infer shadow root level in direct_map()
Date: Thu, 25 Sep 2008 14:54:57 +0300
Message-Id: <1222343711-12508-26-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

In all cases the shadow root level is available in mmu.shadow_root_level,
so there is no need to pass it as a parameter.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3ee856f..72f739a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1227,11 +1227,11 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			   int largepage, gfn_t gfn, pfn_t pfn,
-			   int level)
+			int largepage, gfn_t gfn, pfn_t pfn)
 {
 	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
 	int pt_write = 0;
+	int level = vcpu->arch.mmu.shadow_root_level;
 
 	for (; ; level--) {
 		u32 index = PT64_INDEX(v, level);
@@ -1299,8 +1299,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, largepage, gfn, pfn,
-			 PT32E_ROOT_LEVEL);
+	r = __direct_map(vcpu, v, write, largepage, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 
@@ -1455,7 +1454,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
-			 largepage, gfn, pfn, kvm_x86_ops->get_tdp_level());
+			 largepage, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
-- 
1.6.0.1

