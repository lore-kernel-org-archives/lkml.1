Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYHSJM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYHSJM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHSJMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:12:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240AbYHSJMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:12:16 -0400
Date: Tue, 19 Aug 2008 02:11:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: dirty page tracking race fix
Message-Id: <20080819021155.3d92b193.akpm@linux-foundation.org>
In-Reply-To: <20080818053821.GA3011@wotan.suse.de>
References: <20080818053821.GA3011@wotan.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 07:38:21 +0200 Nick Piggin <npiggin@suse.de> wrote:

> There is a race with dirty page accounting where a page may not properly
> be accounted for.
> 
> clear_page_dirty_for_io() calls page_mkclean; then TestClearPageDirty.
> 
> page_mkclean walks the rmaps for that page, and for each one it cleans and
> write protects the pte if it was dirty. It uses page_check_address to find the
> pte. That function has a shortcut to avoid the ptl if the pte is not
> present. Unfortunately, the pte can be switched to not-present then back to
> present by other code while holding the page table lock -- this should not
> be a signal for page_mkclean to ignore that pte, because it may be dirty.
> 
> For example, powerpc64's set_pte_at will clear a previously present pte before
> setting it to the desired value. There may also be other code in core mm or
> in arch which do similar things.
> 
> The consequence of the bug is loss of data integrity due to msync, and loss
> of dirty page accounting accuracy. XIP's __xip_unmap could easily also be
> unreliable (depending on the exact XIP locking scheme), which can lead to data
> corruption.
> 
> Fix this by having an option to always take ptl to check the pte in
> page_check_address.
> 
> It's possible to retain this optimization for page_referenced and
> try_to_unmap.

Is it also possible to retain it for

/**
 * page_mapped_in_vma - check whether a page is really mapped in a VMA
 * @page: the page to test
 * @vma: the VMA to test
 *
 * Returns 1 if the page is mapped into the page tables of the VMA, 0
 * if the page is not mapped into the page tables of this VMA.  Only
 * valid for normal file or anonymous VMAs.
 */
static int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
{
	unsigned long address;
	pte_t *pte;
	spinlock_t *ptl;

	address = vma_address(page, vma);
	if (address == -EFAULT)		/* out of vma range */
		return 0;
	pte = page_check_address(page, vma->vm_mm, address, &ptl);
	if (!pte)			/* the page is not in this mm */
		return 0;
	pte_unmap_unlock(pte, ptl);

	return 1;
}

?
