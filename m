Return-Path: <linux-kernel-owner+w=401wt.eu-S965088AbXCGLU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbXCGLU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965094AbXCGLU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:20:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33636 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965088AbXCGLU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:20:57 -0500
Date: Wed, 7 Mar 2007 03:20:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: miklos@szeredi.hu, Linux Memory Management List <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 8/6] mm: fix cpdfio vs fault race
Message-Id: <20070307032038.f08333a8.akpm@linux-foundation.org>
In-Reply-To: <20070307110429.GF5555@wotan.suse.de>
References: <20070307110429.GF5555@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc's reestablished yet again)

On Wed, 7 Mar 2007 12:04:29 +0100 Nick Piggin <npiggin@suse.de> wrote:

> OK, this is how we can plug that hole, leveraging my
> previous patches to lock page over do_no_page.
> 
> I'm pretty sure the PageLocked invariant is correct.
> 
> 
> --
> Fix msync data loss and (less importantly) dirty page accounting inaccuracies
> due to the race remaining in clear_page_dirty_for_io().
> 
> The deleted comment explains what the race was, and the added comments
> explain how it is fixed.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c
> +++ linux-2.6/mm/memory.c
> @@ -1676,6 +1676,17 @@ gotten:
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  	if (dirty_page) {
> +		/*
> +		 * Yes, Virginia, this is actually required to prevent a race
> +		 * with clear_page_dirty_for_io() from clearing the page dirty
> +		 * bit after it clear all dirty ptes, but before a racing
> +		 * do_wp_page installs a dirty pte.
> +		 *
> +		 * do_fault is protected similarly by holding the page lock
> +		 * after the dirty pte is installed.
> +		 */
> +		lock_page(dirty_page);
> +		unlock_page(dirty_page);
>  		set_page_dirty_balance(dirty_page);
>  		put_page(dirty_page);

Yes, I think that'll plug it.  A wait_on_page_locked() should suffice.

But does this have any dependency on the lock-page-over-do_no_page patches?


>  	}
> Index: linux-2.6/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.orig/mm/page-writeback.c
> +++ linux-2.6/mm/page-writeback.c
> @@ -903,6 +903,8 @@ int clear_page_dirty_for_io(struct page 
>  {
>  	struct address_space *mapping = page_mapping(page);
>  
> +	BUG_ON(!PageLocked(page));
> +
>  	if (mapping && mapping_cap_account_dirty(mapping)) {
>  		/*
>  		 * Yes, Virginia, this is indeed insane.
> @@ -928,14 +930,19 @@ int clear_page_dirty_for_io(struct page 
>  		 * We basically use the page "master dirty bit"
>  		 * as a serialization point for all the different
>  		 * threads doing their things.
> -		 *
> -		 * FIXME! We still have a race here: if somebody
> -		 * adds the page back to the page tables in
> -		 * between the "page_mkclean()" and the "TestClearPageDirty()",
> -		 * we might have it mapped without the dirty bit set.
>  		 */
>  		if (page_mkclean(page))
>  			set_page_dirty(page);
> +		/*
> +		 * We carefully synchronise fault handlers against
> +		 * installing a dirty pte and marking the page dirty
> +		 * at this point. We do this by having them hold the
> +		 * page lock at some point after installing their
> +		 * pte, but before marking the page dirty.
> +		 * Pages are always locked coming in here, so we get
> +		 * the desired exclusion. See mm/memory.c:do_wp_page()
> +		 * for more comments.
> +		 */
>  		if (TestClearPageDirty(page)) {
>  			dec_zone_page_state(page, NR_FILE_DIRTY);
>  			return 1;
