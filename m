Return-Path: <linux-kernel-owner+w=401wt.eu-S1422696AbXDLFdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696AbXDLFdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422694AbXDLFde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:33:34 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56062 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422696AbXDLFda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:33:30 -0400
Date: Wed, 11 Apr 2007 22:30:47 -0700
Message-Id: <200704120530.l3C5Ulhr022828@zach-dev.vmware.com>
Subject: [PATCH 2/4] Pte clear optimization.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When exiting from an address space, no special hypervisor notification of page
table updates needs to occur; direct page table hypervisors, such as Xen,
switch to another address space first (init_mm) and unprotects the page tables
to avoid the cost of trapping to the hypervisor for each pte_clear.  Shadow
mode hypervisors, such as VMI and lhype don't need to do the extra work of
calling through paravirt-ops, and can just directly clear the page table
entries without notifiying the hypervisor, since all the page tables are
about to be freed.

So introduce native_pte_clear functions which bypass any paravirt-ops
notification.  This results in a significant performance win for VMI
and removes some indirect calls from zap_pte_range.

Note the 3-level paging already had a native_pte_clear function, thus
demanding argument conformance and extra args for the 2-level definition.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 1478ce4ec9e3 include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h	Wed Apr 11 17:13:10 2007 -0700
+++ b/include/asm-i386/pgtable-2level.h	Wed Apr 11 18:22:51 2007 -0700
@@ -35,6 +35,11 @@ static inline void native_set_pmd(pmd_t 
 
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
+
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
+{
+	*xp = __pte(0);
+}
 
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
diff -r 1478ce4ec9e3 include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h	Wed Apr 11 17:13:10 2007 -0700
+++ b/include/asm-i386/pgtable.h	Wed Apr 11 18:21:43 2007 -0700
@@ -349,7 +349,7 @@ static inline pte_t ptep_get_and_clear_f
 	pte_t pte;
 	if (full) {
 		pte = *ptep;
-		pte_clear(mm, addr, ptep);
+		native_pte_clear(mm, addr, ptep);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
