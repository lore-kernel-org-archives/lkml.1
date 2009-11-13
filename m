Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZKMGaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZKMGaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 01:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZKMGaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:30:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55997 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZKMGaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:30:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911102151500.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils> <Pine.LNX.4.64.0911102151500.2816@sister.anvils>
Message-Id: <20091113151554.33C2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 13 Nov 2009 15:30:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -787,6 +787,8 @@ static int try_to_unmap_one(struct page
>  			ret = SWAP_MLOCK;
>  			goto out_unmap;
>  		}
> +		if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
> +			goto out_unmap;
>  	}
>  	if (!(flags & TTU_IGNORE_ACCESS)) {
>  		if (ptep_clear_flush_young_notify(vma, address, pte)) {
> @@ -852,12 +854,22 @@ static int try_to_unmap_one(struct page
>  	} else
>  		dec_mm_counter(mm, file_rss);
>  
> -
>  	page_remove_rmap(page);
>  	page_cache_release(page);
>  
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
> +
> +	if (MLOCK_PAGES && ret == SWAP_MLOCK) {
> +		ret = SWAP_AGAIN;
> +		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
> +			if (vma->vm_flags & VM_LOCKED) {
> +				mlock_vma_page(page);
> +				ret = SWAP_MLOCK;
> +			}
> +			up_read(&vma->vm_mm->mmap_sem);
> +		}
> +	}
>  out:

Very small nit. How about this?


------------------------------------------------------------
>From 9d4b507572eccf88dcaa02e650df59874216528c Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 13 Nov 2009 15:00:04 +0900
Subject: [PATCH] Simplify try_to_unmap_one()

SWAP_MLOCK mean "We marked the page as PG_MLOCK, please move it to
unevictable-lru". So, following code is easy confusable.

	if (vma->vm_flags & VM_LOCKED) {
		ret = SWAP_MLOCK;
		goto out_unmap;
	}

Plus, if the VMA doesn't have VM_LOCKED, We don't need to check
the needed of calling mlock_vma_page().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/rmap.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 4440a86..81a168c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -784,10 +784,8 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!(flags & TTU_IGNORE_MLOCK)) {
-		if (vma->vm_flags & VM_LOCKED) {
-			ret = SWAP_MLOCK;
-			goto out_unmap;
-		}
+		if (vma->vm_flags & VM_LOCKED)
+			goto out_unlock;
 		if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
 			goto out_unmap;
 	}
@@ -856,18 +854,19 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
+out:
+	return ret;
 
-	if (MLOCK_PAGES && ret == SWAP_MLOCK) {
-		ret = SWAP_AGAIN;
-		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
-			if (vma->vm_flags & VM_LOCKED) {
-				mlock_vma_page(page);
-				ret = SWAP_MLOCK;
-			}
-			up_read(&vma->vm_mm->mmap_sem);
+out_unlock:
+	pte_unmap_unlock(pte, ptl);
+
+	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
+		if (vma->vm_flags & VM_LOCKED) {
+			mlock_vma_page(page);
+			ret = SWAP_MLOCK;
 		}
+		up_read(&vma->vm_mm->mmap_sem);
 	}
-out:
 	return ret;
 }
 
-- 
1.6.2.5





