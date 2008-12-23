Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbYLWPGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbYLWPGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 10:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYLWPGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 10:06:23 -0500
Received: from cmpxchg.org ([85.214.51.133]:41527 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYLWPGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 10:06:22 -0500
Date: Tue, 23 Dec 2008 16:06:18 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] fix unmap_vmas() with NULL vma
Message-ID: <20081223150618.GB3215@cmpxchg.org>
References: <20081223103820.GB7217@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223103820.GB7217@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 07:38:21PM +0900, Akinobu Mita wrote:
> unmap_vmas() with NULL vma causes kernel NULL pointer dereference by
> vma->mm.
> 
> It is happend the following scenario:
> 
> 1. dup_mm() duplicates mm_struct and ->mmap is NULL
> 2. dup_mm() calls dup_mmap() to duplicate vmas
> 
> 3. If dup_mmap() cannot duplicate any vmas due to no enough memory,
> it returns error and ->mmap is still NULL
> 
> 4. dup_mm() calls mmput() with the incompletely duplicated mm_struct to
> deallocate it
> 
> 5. mmput calls exit_mmap with the mm_struct
> 6. exit_mmap calls unmap_vmas with NULL vma
> 
> Cc: linux-mm@kvack.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  mm/memory.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: 2.6-rc/mm/memory.c
> ===================================================================
> --- 2.6-rc.orig/mm/memory.c
> +++ 2.6-rc/mm/memory.c
> @@ -899,8 +899,12 @@ unsigned long unmap_vmas(struct mmu_gath
>  	unsigned long start = start_addr;
>  	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
>  	int fullmm = (*tlbp)->fullmm;
> -	struct mm_struct *mm = vma->vm_mm;
> +	struct mm_struct *mm;
> +
> +	if (!vma)
> +		return start;
>  
> +	mm = vma->vm_mm;
>  	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
>  	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
>  		unsigned long end;

Why bail out this late?  We can save the other stuff in exit_mmap() as
well if we have no mmaps.

Granted, the path is dead cold so the extra call overhead doesn't
matter but I think the check is logically better placed in
exit_mmap().

	Hannes

---
Subject: mm: check for no mmaps in exit_mmap()

When dup_mmap() ooms we can end up with mm->mmap == NULL.  The error
path does mmput() and unmap_vmas() gets a NULL vma which it
dereferences.

In exit_mmap() there is nothing to do at all for this case, we can
cancel the callpath right there.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/mm/mmap.c b/mm/mmap.c
index d4855a6..b9d1636 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2091,6 +2091,9 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
+	if (!mm->mmap)
+		return;
+
 	if (mm->locked_vm) {
 		vma = mm->mmap;
 		while (vma) {
