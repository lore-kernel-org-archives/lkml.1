Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYFZMcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYFZMcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYFZM2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:51 -0400
Received: from il.qumranet.com ([212.179.150.194]:32422 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYFZM2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/50] KVM: MMU: Avoid page prefetch on SVM
Date: Thu, 26 Jun 2008 15:28:14 +0300
Message-Id: <1214483312-9265-33-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SVM cannot benefit from page prefetching since guest page fault bypass
cannot by made to work there.  Avoid accessing the guest page table in
this case.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 62741b7..5ebb278 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -850,7 +850,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_add_head(&sp->hash_link, bucket);
 	if (!metaphysical)
 		rmap_write_protect(vcpu->kvm, gfn);
-	vcpu->arch.mmu.prefetch_page(vcpu, sp);
+	if (shadow_trap_nonpresent_pte != shadow_notrap_nonpresent_pte)
+		vcpu->arch.mmu.prefetch_page(vcpu, sp);
+	else
+		nonpaging_prefetch_page(vcpu, sp);
 	return sp;
 }
 
-- 
1.5.6

