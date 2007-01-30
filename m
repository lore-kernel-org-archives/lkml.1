Return-Path: <linux-kernel-owner+w=401wt.eu-S965518AbXA3OjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbXA3OjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXA3OjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:39:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:53216 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965518AbXA3OjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:39:01 -0500
Subject: [PATCH 3/11] KVM: Fix gva_to_gpa()
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:39:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130143900.1597AA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gva_to_gpa() needs to be updated to the new walk_addr() calling convention,
otherwise it may oops under some circumstances.

Use the opportunity to remove all the code duplication in gva_to_gpa(), which
essentially repeats the calculations in walk_addr().

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/paging_tmpl.h
===================================================================
--- linux-2.6.orig/drivers/kvm/paging_tmpl.h
+++ linux-2.6/drivers/kvm/paging_tmpl.h
@@ -443,31 +443,17 @@ static int FNAME(page_fault)(struct kvm_
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
 {
 	struct guest_walker walker;
-	pt_element_t guest_pte;
-	gpa_t gpa;
+	gpa_t gpa = UNMAPPED_GVA;
+	int r;
 
-	FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0, 0);
-	guest_pte = *walker.ptep;
-	FNAME(release_walker)(&walker);
-
-	if (!is_present_pte(guest_pte))
-		return UNMAPPED_GVA;
-
-	if (walker.level == PT_DIRECTORY_LEVEL) {
-		ASSERT((guest_pte & PT_PAGE_SIZE_MASK));
-		ASSERT(PTTYPE == 64 || is_pse(vcpu));
+	r = FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0, 0);
 
-		gpa = (guest_pte & PT_DIR_BASE_ADDR_MASK) | (vaddr &
-			(PT_LEVEL_MASK(PT_PAGE_TABLE_LEVEL) | ~PAGE_MASK));
-
-		if (PTTYPE == 32 && is_cpuid_PSE36())
-			gpa |= (guest_pte & PT32_DIR_PSE36_MASK) <<
-					(32 - PT32_DIR_PSE36_SHIFT);
-	} else {
-		gpa = (guest_pte & PT_BASE_ADDR_MASK);
-		gpa |= (vaddr & ~PAGE_MASK);
+	if (r) {
+		gpa = (gpa_t)walker.gfn << PAGE_SHIFT;
+		gpa |= vaddr & ~PAGE_MASK;
 	}
 
+	FNAME(release_walker)(&walker);
 	return gpa;
 }
 
