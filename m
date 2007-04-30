Return-Path: <linux-kernel-owner+w=401wt.eu-S1423490AbXD3PvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423490AbXD3PvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423480AbXD3PuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:50:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:34391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423475AbXD3PuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:04 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [27/34] i386: pte clear optimization
Message-Id: <20070430155000.7459E151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:50:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

When exiting from an address space, no special hypervisor notification of page
table updates needs to occur; direct page table hypervisors, such as Xen,
switch to another address space first (init_mm) and unprotects the page tables
to avoid the cost of trapping to the hypervisor for each pte_clear.  Shadow
mode hypervisors, such as VMI and lhype don't need to do the extra work of
calling through paravirt-ops, and can just directly clear the page table
entries without notifiying the hypervisor, since all the page tables are about
to be freed.

So introduce native_pte_clear functions which bypass any paravirt-ops
notification.  This results in a significant performance win for VMI and
removes some indirect calls from zap_pte_range.

Note the 3-level paging already had a native_pte_clear function, thus
demanding argument conformance and extra args for the 2-level definition.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/pgtable-2level.h |    5 +++++
 include/asm-i386/pgtable.h        |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux/include/asm-i386/pgtable-2level.h
===================================================================
--- linux.orig/include/asm-i386/pgtable-2level.h
+++ linux/include/asm-i386/pgtable-2level.h
@@ -36,6 +36,11 @@ static inline void native_set_pmd(pmd_t 
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
+{
+	*xp = __pte(0);
+}
+
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
 	return __pte(xchg(&xp->pte_low, 0));
Index: linux/include/asm-i386/pgtable.h
===================================================================
--- linux.orig/include/asm-i386/pgtable.h
+++ linux/include/asm-i386/pgtable.h
@@ -344,7 +344,7 @@ static inline pte_t ptep_get_and_clear_f
 	pte_t pte;
 	if (full) {
 		pte = *ptep;
-		pte_clear(mm, addr, ptep);
+		native_pte_clear(mm, addr, ptep);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
