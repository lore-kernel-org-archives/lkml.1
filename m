Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZBBRQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZBBRQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZBBRQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:16:24 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3168 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZBBRQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:16:23 -0500
Subject: Re: [PATCH] fix mlocked page counter mismatch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: linux mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20090202061622.GA13286@barrios-desktop>
References: <20090202061622.GA13286@barrios-desktop>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 02 Feb 2009 12:16:35 -0500
Message-Id: <1233594995.17895.144.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 15:16 +0900, MinChan Kim wrote:
> When I tested following program, I found that mlocked counter 
> is strange. 
> It couldn't free some mlocked pages of test program.
> 
> It is caused that try_to_unmap_file don't check real 
> page mapping in vmas. 
> That's because goal of address_space for file is to find all processes 
> into which the file's specific interval is mapped. 
> What I mean is that it's not related page but file's interval.
> 
> Even if the page isn't really mapping at the vma, it returns 
> SWAP_MLOCK since the vma have VM_LOCKED, then calls 
> try_to_mlock_page. After all, mlocked counter is increased again. 
> 
> This patch is based on 2.6.28-rc2-mm1.
> 
> -- my test program --
> 
> #include <stdio.h>
> #include <sys/mman.h>
> int main()
> {
>         mlockall(MCL_CURRENT);
>         return 0;
> }
> 
> -- before --
> 
> root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
> Unevictable:           0 kB
> Mlocked:               0 kB
> 
> -- after --
> 
> root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
> Unevictable:           8 kB
> Mlocked:               8 kB
> 
> 
> --
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1099394..9ba1fdf 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1073,6 +1073,9 @@ static int try_to_unmap_file(struct page *page, int unlock, int migration)
>  	unsigned long max_nl_size = 0;
>  	unsigned int mapcount;
>  	unsigned int mlocked = 0;
> +	unsigned long address;
> +	pte_t *pte;
> +	spinlock_t *ptl;
>  
>  	if (MLOCK_PAGES && unlikely(unlock))
>  		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
> @@ -1089,6 +1092,13 @@ static int try_to_unmap_file(struct page *page, int unlock, int migration)
>  				goto out;
>  		}
>  		if (ret == SWAP_MLOCK) {
> +     address = vma_address(page, vma);
> +     if (address != -EFAULT) {
> +       pte = page_check_address(page, vma->vm_mm, address, &ptl, 0);
> +       if (!pte)
> +            continue; 
> +       pte_unmap_unlock(pte, ptl);
> +     } 
>  			mlocked = try_to_mlock_page(page, vma);
>  			if (mlocked)
>  				break;  /* stop if actually mlocked page */

Hi, MinChan:

   Interestingly, Rik had addressed this [simpler patch below] way back
when he added the page_mapped_in_vma() function.  I asked him whether
the rb tree shouldn't have filtered any vmas that didn't have the page
mapped.  He agreed and removed the check from try_to_unmap_file().
Guess I can be very convincing, even when I'm wrong [happening a lot
lately].  Of course, in this instance, the rb-tree filtering only works
for shared, page-cache pages.  The problem uncovered by your test case
is with a COWed anon page in a file-backed vma.  Yes, the vma 'maps' the
virtual address range containing the page in question, but since it's a
private COWed anon page, it isn't necessarily "mapped" in the VM_LOCKED
vma's mm's page table.  We need the check...

I've added the variant below [CURRENTLY UNTESTED] to my test tree.

Lee

[intentionally omitted sign off, until tested.]


Index: linux-2.6.29-rc3/mm/rmap.c
===================================================================
--- linux-2.6.29-rc3.orig/mm/rmap.c	2009-01-30 14:13:56.000000000 -0500
+++ linux-2.6.29-rc3/mm/rmap.c	2009-02-02 11:27:11.000000000 -0500
@@ -1072,7 +1072,8 @@ static int try_to_unmap_file(struct page
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		if (MLOCK_PAGES && unlikely(unlock)) {
-			if (!(vma->vm_flags & VM_LOCKED))
+			if (!((vma->vm_flags & VM_LOCKED) &&
+			      page_mapped_in_vma(page, vma)))
 				continue;	/* must visit all vmas */
 			ret = SWAP_MLOCK;
 		} else {


