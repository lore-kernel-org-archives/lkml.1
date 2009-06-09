Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZFITiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZFITiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZFITiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:38:16 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:57876 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561AbZFITiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:38:15 -0400
X-Trace: 208700093/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.83.169/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.83.169
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEALtWLkpPRVOp/2dsb2JhbACBT89nhAoF
X-IronPort-AV: E=Sophos;i="4.41,335,1241391600"; 
   d="scan'208";a="208700093"
Date: Tue, 9 Jun 2009 20:27:29 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: aarcange@redhat.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       chrisw@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/4] RFC - ksm api change into madvise
In-Reply-To: <Pine.LNX.4.64.0906091807300.20120@sister.anvils>
Message-ID: <Pine.LNX.4.64.0906092013580.31606@sister.anvils>
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0906081555360.22943@sister.anvils> <4A2D47C1.5020302@redhat.com>
 <Pine.LNX.4.64.0906081902520.9518@sister.anvils> <4A2D7036.1010800@redhat.com>
 <20090609074848.5357839a@woof.tlv.redhat.com> <Pine.LNX.4.64.0906091807300.20120@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Hugh Dickins wrote:
> On Tue, 9 Jun 2009, Izik Eidus wrote:
> > How does this look like?
> 
> One improvment to make now, though: you've elsewhere avoided
> the pgd,pud,pmd,pte descent in ksm.c (using get_pte instead), and
> page_check_address() is not static to rmap.c (filemap_xip wanted it),
> so please continue to use that.  It's not exported, right, but I think
> Chris was already decisive that we should abandon modular KSM, yes?

I think you can simplify it further, can't you?  Isn't the get_pte()
preamble in try_to_merge_one_page() just unnecessary overhead now?  See
untested code below.  Or even move the trylock/unlock of the page into
write_protect_page if you prefer.  Later on we'll uninline rmap.c's
vma_address() so you can use it instead of your addr_in_vma() copy.

Hugh

static inline int write_protect_page(struct page *page,
				     struct vm_area_struct *vma,
				     pte_t *orig_pte)
{
	struct mm_struct *mm = vma->vm_mm;
	unsigned long addr;
	pte_t *ptep;
	spinlock_t *ptl;
	int swapped;
	int ret = 1;

	addr = addr_in_vma(vma, page);
	if (addr == -EFAULT)
		goto out;

	ptep = page_check_address(page, mm, addr, &ptl, 0);
	if (!ptep)
		goto out;

	if (pte_write(*ptep)) {
		pte_t entry;

		swapped = PageSwapCache(page);
		flush_cache_page(vma, addr, page_to_pfn(page));
		/*
		 * Ok this is tricky, when get_user_pages_fast() run it doesnt
		 * take any lock, therefore the check that we are going to make
		 * with the pagecount against the mapcount is racey and
		 * O_DIRECT can happen right after the check.
		 * So we clear the pte and flush the tlb before the check
		 * this assure us that no O_DIRECT can happen after the check
		 * or in the middle of the check.
		 */
		entry = ptep_clear_flush(vma, addr, ptep);
		/*
		 * Check that no O_DIRECT or similar I/O is in progress on the
		 * page
		 */
		if ((page_mapcount(page) + 2 + swapped) != page_count(page)) {
			set_pte_at_notify(mm, addr, ptep, entry);
			goto out_unlock;
		}
		entry = pte_wrprotect(entry);
		set_pte_at_notify(mm, addr, ptep, entry);
		*orig_pte = *ptep;
	}
	ret = 0;

out_unlock:
	pte_unmap_unlock(ptep, ptl);
out:
	return ret;
}

/*
 * try_to_merge_one_page - take two pages and merge them into one
 * @mm: mm_struct that hold vma pointing into oldpage
 * @vma: the vma that hold the pte pointing into oldpage
 * @oldpage: the page that we want to replace with newpage
 * @newpage: the page that we want to map instead of oldpage
 * @newprot: the new permission of the pte inside vma
 * note:
 * oldpage should be anon page while newpage should be file mapped page
 *
 * this function return 0 if the pages were merged, 1 otherwise.
 */
static int try_to_merge_one_page(struct mm_struct *mm,
				 struct vm_area_struct *vma,
				 struct page *oldpage,
				 struct page *newpage,
				 pgprot_t newprot)
{
	int ret = 1;
	pte_t orig_pte;

	if (!PageAnon(oldpage))
		goto out;

	get_page(newpage);
	get_page(oldpage);

	/*
	 * we need the page lock to read a stable PageSwapCache in
	 * write_protect_page().
	 * we use trylock_page() instead of lock_page(), beacuse we dont want to
	 * wait here, we prefer to continue scanning and merging diffrent pages
	 * and to come back to this page when it is unlocked.
	 */
	if (!trylock_page(oldpage))
		goto out_putpage;

	if (write_protect_page(oldpage, vma, &orig_pte)) {
		unlock_page(oldpage);
		goto out_putpage;
	}
	unlock_page(oldpage);

	if (pages_identical(oldpage, newpage))
		ret = replace_page(vma, oldpage, newpage, orig_pte, newprot);

out_putpage:
	put_page(oldpage);
	put_page(newpage);
out:
	return ret;
}
