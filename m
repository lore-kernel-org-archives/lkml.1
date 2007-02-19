Return-Path: <linux-kernel-owner+w=401wt.eu-S1750835AbXBSKVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750835AbXBSKVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbXBSKVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:21:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:58874 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbXBSKVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:21:52 -0500
Subject: [PATCH 1/13] KVM: mmu: add missing dirty page tracking cases
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:21:51 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102151.9082E25016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We fail to mark a page dirty in three cases:

- setting the accessed bit in a pte
- setting the dirty bit in a pte
- emulating a write into a pagetable

This fix adds the missing cases.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/paging_tmpl.h
===================================================================
--- linux-2.6.orig/drivers/kvm/paging_tmpl.h
+++ linux-2.6/drivers/kvm/paging_tmpl.h
@@ -128,8 +128,10 @@ static int FNAME(walk_addr)(struct guest
 			goto access_error;
 #endif
 
-		if (!(*ptep & PT_ACCESSED_MASK))
-			*ptep |= PT_ACCESSED_MASK; 	/* avoid rmw */
+		if (!(*ptep & PT_ACCESSED_MASK)) {
+			mark_page_dirty(vcpu->kvm, table_gfn);
+			*ptep |= PT_ACCESSED_MASK;
+		}
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = (*ptep & PT_BASE_ADDR_MASK)
@@ -185,6 +187,12 @@ static void FNAME(release_walker)(struct
 		kunmap_atomic(walker->table, KM_USER0);
 }
 
+static void FNAME(mark_pagetable_dirty)(struct kvm *kvm,
+					struct guest_walker *walker)
+{
+	mark_page_dirty(kvm, walker->table_gfn[walker->level - 1]);
+}
+
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
 			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
@@ -348,12 +356,15 @@ static int FNAME(fix_write_pf)(struct kv
 	} else if (kvm_mmu_lookup_page(vcpu, gfn)) {
 		pgprintk("%s: found shadow page for %lx, marking ro\n",
 			 __FUNCTION__, gfn);
+		mark_page_dirty(vcpu->kvm, gfn);
+		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 		*guest_ent |= PT_DIRTY_MASK;
 		*write_pt = 1;
 		return 0;
 	}
 	mark_page_dirty(vcpu->kvm, gfn);
 	*shadow_ent |= PT_WRITABLE_MASK;
+	FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 	*guest_ent |= PT_DIRTY_MASK;
 	rmap_add(vcpu, shadow_ent);
 
