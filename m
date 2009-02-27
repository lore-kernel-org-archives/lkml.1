Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZB0KcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZB0KcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbZB0K1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53579 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/37] KVM: MMU: Optimize page unshadowing
Date: Fri, 27 Feb 2009 12:26:46 +0200
Message-Id: <1235730420-7929-24-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kvm_mmu_lookup_page() will result in multiple scans of the hash chains;
use hlist_for_each_entry_safe() to achieve a single scan instead.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1585080..aac0499 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1471,11 +1471,20 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 
 static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
+	unsigned index;
+	struct hlist_head *bucket;
 	struct kvm_mmu_page *sp;
+	struct hlist_node *node, *nn;
 
-	while ((sp = kvm_mmu_lookup_page(kvm, gfn)) != NULL) {
-		pgprintk("%s: zap %lx %x\n", __func__, gfn, sp->role.word);
-		kvm_mmu_zap_page(kvm, sp);
+	index = kvm_page_table_hashfn(gfn);
+	bucket = &kvm->arch.mmu_page_hash[index];
+	hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
+		if (sp->gfn == gfn && !sp->role.metaphysical
+		    && !sp->role.invalid) {
+			pgprintk("%s: zap %lx %x\n",
+				 __func__, gfn, sp->role.word);
+			kvm_mmu_zap_page(kvm, sp);
+		}
 	}
 }
 
-- 
1.6.0.6

