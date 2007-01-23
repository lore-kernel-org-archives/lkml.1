Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXAWOfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXAWOfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933034AbXAWOfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:35:08 -0500
Received: from il.qumranet.com ([62.219.232.206]:56726 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXAWOfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:35:06 -0500
Subject: [PATCH 4/5] KVM: MMU: Report nx faults to the guest
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 23 Jan 2007 14:35:04 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45B61C09.5020501@qumranet.com>
In-Reply-To: <45B61C09.5020501@qumranet.com>
Message-Id: <20070123143504.48BCC2507E1@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rith the recent guest page fault change, we perform access checks on our own
instead of relying on the cpu.  This means we have to perform the nx checks as
well.

Software like the google toolbar on windows appears to rely on this somehow.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/mmu.c
===================================================================
--- linux-2.6.orig/drivers/kvm/mmu.c
+++ linux-2.6/drivers/kvm/mmu.c
@@ -143,6 +143,7 @@ static int dbg = 1;
 #define PFERR_PRESENT_MASK (1U << 0)
 #define PFERR_WRITE_MASK (1U << 1)
 #define PFERR_USER_MASK (1U << 2)
+#define PFERR_FETCH_MASK (1U << 4)
 
 #define PT64_ROOT_LEVEL 4
 #define PT32_ROOT_LEVEL 2
@@ -168,6 +169,11 @@ static int is_cpuid_PSE36(void)
 	return 1;
 }
 
+static int is_nx(struct kvm_vcpu *vcpu)
+{
+	return vcpu->shadow_efer & EFER_NX;
+}
+
 static int is_present_pte(unsigned long pte)
 {
 	return pte & PT_PRESENT_MASK;
Index: linux-2.6/drivers/kvm/paging_tmpl.h
===================================================================
--- linux-2.6.orig/drivers/kvm/paging_tmpl.h
+++ linux-2.6/drivers/kvm/paging_tmpl.h
@@ -71,7 +71,7 @@ struct guest_walker {
  */
 static int FNAME(walk_addr)(struct guest_walker *walker,
 			    struct kvm_vcpu *vcpu, gva_t addr,
-			    int write_fault, int user_fault)
+			    int write_fault, int user_fault, int fetch_fault)
 {
 	hpa_t hpa;
 	struct kvm_memory_slot *slot;
@@ -123,6 +123,11 @@ static int FNAME(walk_addr)(struct guest
 		if (user_fault && !(*ptep & PT_USER_MASK))
 			goto access_error;
 
+#if PTTYPE == 64
+		if (fetch_fault && is_nx(vcpu) && (*ptep & PT64_NX_MASK))
+			goto access_error;
+#endif
+
 		if (!(*ptep & PT_ACCESSED_MASK))
 			*ptep |= PT_ACCESSED_MASK; 	/* avoid rmw */
 
@@ -169,6 +174,8 @@ err:
 		walker->error_code |= PFERR_WRITE_MASK;
 	if (user_fault)
 		walker->error_code |= PFERR_USER_MASK;
+	if (fetch_fault)
+		walker->error_code |= PFERR_FETCH_MASK;
 	return 0;
 }
 
@@ -372,6 +379,7 @@ static int FNAME(page_fault)(struct kvm_
 {
 	int write_fault = error_code & PFERR_WRITE_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
+	int fetch_fault = error_code & PFERR_FETCH_MASK;
 	struct guest_walker walker;
 	u64 *shadow_pte;
 	int fixed;
@@ -388,7 +396,8 @@ static int FNAME(page_fault)(struct kvm_
 	/*
 	 * Look up the shadow pte for the faulting address.
 	 */
-	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault);
+	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault,
+			     fetch_fault);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
@@ -437,7 +446,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kv
 	pt_element_t guest_pte;
 	gpa_t gpa;
 
-	FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0);
+	FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0, 0);
 	guest_pte = *walker.ptep;
 	FNAME(release_walker)(&walker);
 
