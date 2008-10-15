Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYJOLEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYJOLEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYJOLEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:04:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59746 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYJOLEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:04:33 -0400
Message-ID: <48F5CE10.3060403@redhat.com>
Date: Wed, 15 Oct 2008 13:03:44 +0200
From: Chris Lalancette <clalance@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH]: Fix Xen domU boot with batched mprotect
Content-Type: multipart/mixed;
 boundary="------------070406010509010007030301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070406010509010007030301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Recent i686 2.6.27 kernels with a certain amount of memory (between 736 and
855MB) have a problem booting under a hypervisor that supports batched mprotect
(this includes the RHEL-5 Xen hypervisor as well as any 3.3 or later Xen
hypervisor).  The problem ends up being that xen_ptep_modify_prot_commit() is
using virt_to_machine to calculate which pfn to update.  However, this only
works for pages that are in the p2m list, and the pages coming from
change_pte_range() in mm/mprotect.c are kmap_atomic pages.  Because of this, we
can run into the situation where the lookup in the p2m table returns an
INVALID_MFN, which we then try to pass to the hypervisor, which then (correctly)
denies the request to a totally bogus pfn.

The right thing to do is to use arbitrary_virt_to_machine, so that we can be
sure we are modifying the right pfn.  This unfortunately introduces a
performance penalty because of a full page-table-walk, but we can avoid that
penalty for pages in the p2m list by checking if virt_addr_valid is true, and if
so, just doing the lookup in the p2m table.

The attached patch implements this, and allows my 2.6.27 i686 based guest with
768MB of memory to boot on a RHEL-5 hypervisor again.  Thanks to Jeremy for the
suggestions about how to fix this particular issue.

Signed-off-by: Chris Lalancette <clalance@redhat.com>

--------------070406010509010007030301
Content-Type: text/x-patch;
 name="lkml-768MB-virt_to_machine-3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lkml-768MB-virt_to_machine-3.patch"

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ae173f6..f579103 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -246,11 +246,21 @@ xmaddr_t arbitrary_virt_to_machine(void *vaddr)
 {
 	unsigned long address = (unsigned long)vaddr;
 	unsigned int level;
-	pte_t *pte = lookup_address(address, &level);
-	unsigned offset = address & ~PAGE_MASK;
+	pte_t *pte;
+	unsigned offset;
 
-	BUG_ON(pte == NULL);
+	/*
+	 * if the PFN is in the linear mapped vaddr range, we can just use
+	 * the (quick) virt_to_machine() p2m lookup
+	 */
+	if (virt_addr_valid(vaddr))
+		return virt_to_machine(vaddr);
 
+	/* otherwise we have to do a (slower) full page-table walk */
+
+	pte = lookup_address(address, &level);
+	BUG_ON(pte == NULL);
+	offset = address & ~PAGE_MASK;
 	return XMADDR(((phys_addr_t)pte_mfn(*pte) << PAGE_SHIFT) + offset);
 }
 
@@ -410,7 +420,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 
 	xen_mc_batch();
 
-	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
+	u.ptr = arbitrary_virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
 	u.val = pte_val_ma(pte);
 	xen_extend_mmu_update(&u);
 

--------------070406010509010007030301--
