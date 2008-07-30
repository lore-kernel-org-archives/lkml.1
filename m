Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbYG3Xni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbYG3Xni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbYG3Xmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:42:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:34731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbYG3Xmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:42:42 -0400
Date: Wed, 30 Jul 2008 16:27:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Greg KH <greg@kroah.com>,
       Andy Whitcroft <apw@shadowen.org>,
       David Gibson <david@gibson.dropbear.id.au>
Subject: [patch 27/29] Correct hash flushing from huge_ptep_set_wrprotect()
Message-ID: <20080730232743.GB30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="correct-hash-flushing-from-huge_ptep_set_wrprotect.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: David Gibson <david@gibson.dropbear.id.au>

Correct hash flushing from huge_ptep_set_wrprotect() [stable tree version]

A fix for incorrect flushing of the hash page table at fork() for
hugepages was recently committed as
86df86424939d316b1f6cfac1b6204f0c7dee317.  Without this fix, a process
can make a MAP_PRIVATE hugepage mapping, then fork() and have writes
to the mapping after the fork() pollute the child's version.

Unfortunately this bug also exists in the stable branch.  In fact in
that case copy_hugetlb_page_range() from mm/hugetlb.c calls
ptep_set_wrprotect() directly, the hugepage variant hook
huge_ptep_set_wrprotect() doesn't even exist.

The patch below is a port of the fix to the stable25/master branch.
It introduces a huge_ptep_set_wrprotect() call, but this is #defined
to be equal to ptep_set_wrprotect() unless the arch defines its own
version and sets __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT.

This arch preprocessor flag is kind of nasty, but it seems the sanest
way to introduce this fix with minimum risk of breaking other archs
for whom prep_set_wprotect() is suitable for hugepages.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-powerpc/pgtable-ppc64.h |   11 +++++++++++
 mm/hugetlb.c                        |    6 +++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/include/asm-powerpc/pgtable-ppc64.h
+++ b/include/asm-powerpc/pgtable-ppc64.h
@@ -311,6 +311,17 @@ static inline void ptep_set_wrprotect(st
 	old = pte_update(mm, addr, ptep, _PAGE_RW, 0);
 }
 
+#define __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	unsigned long old;
+
+       	if ((pte_val(*ptep) & _PAGE_RW) == 0)
+       		return;
+	old = pte_update(mm, addr, ptep, _PAGE_RW, 1);
+}
+
 /*
  * We currently remove entries from the hashtable regardless of whether
  * the entry was young or dirty. The generic routines only flush if the
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -738,6 +738,10 @@ static void set_huge_ptep_writable(struc
 }
 
 
+#ifndef __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
+#define huge_ptep_set_wrprotect		ptep_set_wrprotect
+#endif
+
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
 {
@@ -764,7 +768,7 @@ int copy_hugetlb_page_range(struct mm_st
 		spin_lock(&src->page_table_lock);
 		if (!pte_none(*src_pte)) {
 			if (cow)
-				ptep_set_wrprotect(src, addr, src_pte);
+				huge_ptep_set_wrprotect(src, addr, src_pte);
 			entry = *src_pte;
 			ptepage = pte_page(entry);
 			get_page(ptepage);

-- 
