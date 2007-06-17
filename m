Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbXFQJzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbXFQJzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759683AbXFQJpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:55190 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 38/58] KVM: Move shadow pte modifications from set_pte/set_pde to set_pde_common()
Date: Sun, 17 Jun 2007 12:44:19 +0300
Message-Id: <11820734812831-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We want all shadow pte modifications in one place.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index c067203..35f264f 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -218,6 +218,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 	}
 
+	*shadow_pte |= *gpte & PT_PTE_COPY_MASK;
 	*shadow_pte |= access_bits << PT_SHADOW_BITS_OFFSET;
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
@@ -288,7 +289,6 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t *gpte,
 			   struct guest_walker *walker, gfn_t gfn)
 {
 	access_bits &= *gpte;
-	*shadow_pte |= (*gpte & PT_PTE_COPY_MASK);
 	FNAME(set_pte_common)(vcpu, shadow_pte, *gpte & PT_BASE_ADDR_MASK,
 			      gpte, access_bits, user_fault, write_fault,
 			      ptwrite, walker, gfn);
@@ -322,7 +322,6 @@ static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t *gpde,
 	if (PTTYPE == 32 && is_cpuid_PSE36())
 		gaddr |= (*gpde & PT32_DIR_PSE36_MASK) <<
 			(32 - PT32_DIR_PSE36_SHIFT);
-	*shadow_pte |= *gpde & PT_PTE_COPY_MASK;
 	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
 			      gpde, access_bits, user_fault, write_fault,
 			      ptwrite, walker, gfn);
-- 
1.5.0.6

