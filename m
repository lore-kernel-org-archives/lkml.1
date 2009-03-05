Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZCEMNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZCEMNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZCEMM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:12:56 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:22332
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753133AbZCEMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:12:53 -0500
X-BigFish: VPS2(zba6izzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KG18L3-02-DEE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/6] kvm/x86/mmu: handle invlpg on large pages
Date: Thu, 5 Mar 2009 13:12:31 +0100
Message-ID: <1236255153-4432-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 05 Mar 2009 12:12:33.0796 (UTC) FILETIME=[AA2E8440:01C99D8B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 79668ba..aa79396 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -441,6 +441,7 @@ out_unlock:
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
 	pt_element_t gpte;
 	gpa_t pte_gpa = -1;
 	int level;
@@ -451,12 +452,17 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	for_each_shadow_entry(vcpu, gva, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
+		sp = page_header(__pa(sptep));
+
+		if (sp->role.direct) {
+			/* mapped from a guest's large_pte */
+			kvm_mmu_zap_page(vcpu->kvm, sp);
+			kvm_flush_remote_tlbs(vcpu->kvm);
+			return;
+		}
 
-		/* FIXME: properly handle invlpg on large guest pages */
 		if (level == PT_PAGE_TABLE_LEVEL ||
 		    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
-			struct kvm_mmu_page *sp = page_header(__pa(sptep));
-
 			pte_gpa = (sp->gfn << PAGE_SHIFT);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
-- 
1.5.6.4


