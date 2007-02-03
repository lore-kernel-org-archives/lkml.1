Return-Path: <linux-kernel-owner+w=401wt.eu-S1946267AbXBCCl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946267AbXBCCl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946266AbXBCClS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:41:18 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53378 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946258AbXBCClI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:41:08 -0500
Message-Id: <20070203024436.187214000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:47 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, akpm@osdl.org, wli@holomorphy.com,
       agl@us.ibm.com, hugh@veritas.com, david@gibson.dropbear.id.au
Subject: [patch 43/59] Dont allow the stack to grow into hugetlb reserved regions
Content-Disposition: inline; filename=don-t-allow-the-stack-to-grow-into-hugetlb-reserved-regions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Adam Litke <agl@us.ibm.com>

When expanding the stack, we don't currently check if the VMA will cross
into an area of the address space that is reserved for hugetlb pages. 
Subsequent faults on the expanded portion of such a VMA will confuse the
low-level MMU code, resulting in an OOPS.  Check for this.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 mm/mmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.19.2.orig/mm/mmap.c
+++ linux-2.6.19.2/mm/mmap.c
@@ -1477,6 +1477,7 @@ static int acct_stack_growth(struct vm_a
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
+	unsigned long new_start;
 
 	/* address space limit tests */
 	if (!may_expand_vm(mm, grow))
@@ -1496,6 +1497,12 @@ static int acct_stack_growth(struct vm_a
 			return -ENOMEM;
 	}
 
+	/* Check to ensure the stack will not grow into a hugetlb-only region */
+	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
+			vma->vm_end - size;
+	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
+		return -EFAULT;
+
 	/*
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.

--
