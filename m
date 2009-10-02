Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZJBCkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZJBCkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZJBCke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:40:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55638 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZJBCke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 22:40:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [rfc patch 3/3] mm: munlock COW pages on truncation unmap
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1254344964-8124-3-git-send-email-hannes@cmpxchg.org>
References: <1254344964-8124-1-git-send-email-hannes@cmpxchg.org> <1254344964-8124-3-git-send-email-hannes@cmpxchg.org>
Message-Id: <20091002100838.5F5A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Oct 2009 11:40:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

thanks for very interesting patches.
I have a question.


> @@ -835,6 +835,43 @@ static unsigned long zap_pte_range(struc
>  				    (page->index < details->first_index ||
>  				     page->index > details->last_index))
>  					continue;
> +				/*
> +				 * When truncating, private COW pages may be
> +				 * mlocked in VM_LOCKED VMAs, so they need
> +				 * munlocking here before getting freed.
> +				 *
> +				 * Skip them completely if we don't have the
> +				 * anon_vma locked.  We will get it the second
> +				 * time.  When page cache is truncated, no more
> +				 * private pages can show up against this VMA
> +				 * and the anon_vma is either present or will
> +				 * never be.
> +				 *
> +				 * Otherwise, we still have to synchronize
> +				 * against concurrent reclaimers.  We can not
> +				 * grab the page lock, but with correct
> +				 * ordering of page flag accesses we can get
> +				 * away without it.
> +				 *
> +				 * A concurrent isolator may add the page to
> +				 * the unevictable list, set PG_lru and then
> +				 * recheck PG_mlocked to verify it chose the
> +				 * right list and conditionally move it again.
> +				 *
> +				 * TestClearPageMlocked() provides one half of
> +				 * the barrier: when we do not see the page on
> +				 * the LRU and fail isolation, the isolator
> +				 * must see PG_mlocked cleared and move the
> +				 * page on its own back to the evictable list.
> +				 */
> +				if (private && !details->anon_vma)
> +					continue;
> +				if (private && TestClearPageMlocked(page)) {
> +					dec_zone_page_state(page, NR_MLOCK);
> +					count_vm_event(UNEVICTABLE_PGCLEARED);
> +					if (!isolate_lru_page(page))
> +						putback_lru_page(page);
> +				}
>  			}
>  			ptent = ptep_get_and_clear_full(mm, addr, pte,
>  							tlb->fullmm);

Umm..
I haven't understand this.

(1) unmap_mapping_range() is called twice.

	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
	truncate_inode_pages(mapping, new);
	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);

(2) PG_mlock is turned on from mlock() and vmscan.
(3) vmscan grab anon_vma, but mlock don't grab anon_vma.
(4) after truncate_inode_pages(), we don't need to think vs-COW, because
    find_get_page() never success. but first unmap_mapping_range()
    have vs-COW racing. 

So, Is anon_vma grabbing really sufficient?
Or, you intent to the following?

	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 0);
	truncate_inode_pages(mapping, new);
	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);



> @@ -544,6 +544,13 @@ redo:
>  		 */
>  		lru = LRU_UNEVICTABLE;
>  		add_page_to_unevictable_list(page);
> +		/*
> +		 * See the TestClearPageMlocked() in zap_pte_range():
> +		 * if a racing unmapper did not see the above setting
> +		 * of PG_lru, we must see its clearing of PG_locked
> +		 * and move the page back to the evictable list.
> +		 */
> +		smp_mb();
>  	}

add_page_to_unevictable() have a spin lock. Why do we need additionl
explicit memory barrier?



