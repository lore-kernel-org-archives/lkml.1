Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbYKQHZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbYKQHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYKQHVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:11 -0500
Received: from kroah.org ([198.145.64.141]:38298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752683AbYKQHVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:00 -0500
Date: Sun, 16 Nov 2008 23:15:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Adam Litke <agl@us.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 13/46] hugetlb: make unmap_ref_private multi-size-aware
Message-ID: <20081117071503.GN29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hugetlb-make-unmap_ref_private-multi-size-aware.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Litke <agl@us.ibm.com>

commit 7526674de0c921e7f1e9b6f71a1f9d832557b554 upstream.

Oops.  Part of the hugetlb private reservation code was not fully
converted to use hstates.

When a huge page must be unmapped from VMAs due to a failed COW,
HPAGE_SIZE is used in the call to unmap_hugepage_range() regardless of
the page size being used.  This works if the VMA is using the default
huge page size.  Otherwise we might unmap too much, too little, or
trigger a BUG_ON.  Rare but serious -- fix it.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1797,6 +1797,7 @@ int unmap_ref_private(struct mm_struct *
 					struct page *page,
 					unsigned long address)
 {
+	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;
 	struct prio_tree_iter iter;
@@ -1806,7 +1807,7 @@ int unmap_ref_private(struct mm_struct *
 	 * vm_pgoff is in PAGE_SIZE units, hence the different calculation
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
-	address = address & huge_page_mask(hstate_vma(vma));
+	address = address & huge_page_mask(h);
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
 		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
@@ -1825,7 +1826,7 @@ int unmap_ref_private(struct mm_struct *
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma,
-				address, address + HPAGE_SIZE,
+				address, address + huge_page_size(h),
 				page);
 	}
 

-- 
