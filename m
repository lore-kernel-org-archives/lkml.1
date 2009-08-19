Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZHSNJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZHSNJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZHSNCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:02:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50542 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751611AbZHSNCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:44 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/47] KVM: MMU audit: update audit_write_protection
Date: Wed, 19 Aug 2009 16:02:00 +0300
Message-Id: <1250686963-8357-5-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

- Unsync pages contain writable sptes in the rmap.
- rmaps do not exclusively contain writable sptes anymore.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fd5579c..4c2585c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3260,20 +3260,28 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_page *sp;
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
+	u64 *spte;
 	gfn_t gfn;
 
 	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
 		if (sp->role.direct)
 			continue;
+		if (sp->unsync)
+			continue;
 
 		gfn = unalias_gfn(vcpu->kvm, sp->gfn);
 		slot = gfn_to_memslot_unaliased(vcpu->kvm, sp->gfn);
 		rmapp = &slot->rmap[gfn - slot->base_gfn];
-		if (*rmapp)
-			printk(KERN_ERR "%s: (%s) shadow page has writable"
-			       " mappings: gfn %lx role %x\n",
+
+		spte = rmap_next(vcpu->kvm, rmapp, NULL);
+		while (spte) {
+			if (*spte & PT_WRITABLE_MASK)
+				printk(KERN_ERR "%s: (%s) shadow page has "
+				"writable mappings: gfn %lx role %x\n",
 			       __func__, audit_msg, sp->gfn,
 			       sp->role.word);
+			spte = rmap_next(vcpu->kvm, rmapp, spte);
+		}
 	}
 }
 
-- 
1.6.3.3

