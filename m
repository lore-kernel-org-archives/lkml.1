Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbYF0MVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbYF0MVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbYF0MNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:13:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48664 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761026AbYF0MNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:13:47 -0400
Date: Fri, 27 Jun 2008 13:13:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Johannes Weiner <hannes@saeurebad.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] remove unused vma_page_offset()
In-Reply-To: <874p7fyvvl.fsf@skyscraper.fehenstaub.lan>
Message-ID: <Pine.LNX.4.64.0806271300350.16003@blonde.site>
References: <874p7fyvvl.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Johannes Weiner wrote:
> Function has no callees, drop it.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---

Yes, I noticed that too; but I also thought vma_pagecache_offset()
below it needs a name change, and was planning on sending Andrew
the patch at the end, okay to replace yours with that?

Hugh

> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 690abf0..a7c7c18 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -48,17 +48,6 @@ static DEFINE_SPINLOCK(hugetlb_lock);
>  
>  /*
>   * Convert the address within this vma to the page offset within
> - * the mapping, in base page units.
> - */
> -static pgoff_t vma_page_offset(struct vm_area_struct *vma,
> -				unsigned long address)
> -{
> -	return ((address - vma->vm_start) >> PAGE_SHIFT) +
> -					(vma->vm_pgoff >> PAGE_SHIFT);
> -}
> -
> -/*
> - * Convert the address within this vma to the page offset within
>   * the mapping, in pagecache page units; huge pages here.
>   */
>  static pgoff_t vma_pagecache_offset(struct hstate *h,

From: Johannes Weiner <hannes@saeurebad.de>

vma_page_offset() has no callees: drop it.

Hugh adds: vma_pagecache_offset() has a dangerously misleading name,
since it's using hugepage units: rename it to vma_hugecache_offset().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/hugetlb.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c	2008-06-25 12:45:11.000000000 +0100
+++ b/mm/hugetlb.c	2008-06-25 19:02:42.000000000 +0100
@@ -48,20 +48,9 @@ static DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
  * Convert the address within this vma to the page offset within
- * the mapping, in base page units.
- */
-static pgoff_t vma_page_offset(struct vm_area_struct *vma,
-				unsigned long address)
-{
-	return ((address - vma->vm_start) >> PAGE_SHIFT) +
-					(vma->vm_pgoff >> PAGE_SHIFT);
-}
-
-/*
- * Convert the address within this vma to the page offset within
  * the mapping, in pagecache page units; huge pages here.
  */
-static pgoff_t vma_pagecache_offset(struct hstate *h,
+static pgoff_t vma_hugecache_offset(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
 {
 	return ((address - vma->vm_start) >> huge_page_shift(h)) +
@@ -786,7 +775,7 @@ static int vma_needs_reservation(struct 
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(h, vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -804,7 +793,7 @@ static void vma_commit_reservation(struc
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(h, vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 	}
 }
@@ -1761,7 +1750,7 @@ static struct page *hugetlbfs_pagecache_
 	pgoff_t idx;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(h, vma, address);
+	idx = vma_hugecache_offset(h, vma, address);
 
 	return find_lock_page(mapping, idx);
 }
@@ -1790,7 +1779,7 @@ static int hugetlb_no_page(struct mm_str
 	}
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(h, vma, address);
+	idx = vma_hugecache_offset(h, vma, address);
 
 	/*
 	 * Use page lock to guard against racing truncation
