Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZGURwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZGURwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZGURwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:52:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60403 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZGURwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:52:20 -0400
Date: Tue, 21 Jul 2009 19:51:39 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, chrisw@redhat.com,
       avi@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 06/10] ksm: identify PageKsm pages
Message-ID: <20090721175139.GE2239@random.random>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <1247851850-4298-2-git-send-email-ieidus@redhat.com>
 <1247851850-4298-3-git-send-email-ieidus@redhat.com>
 <1247851850-4298-4-git-send-email-ieidus@redhat.com>
 <1247851850-4298-5-git-send-email-ieidus@redhat.com>
 <1247851850-4298-6-git-send-email-ieidus@redhat.com>
 <1247851850-4298-7-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247851850-4298-7-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 08:30:46PM +0300, Izik Eidus wrote:
> +static inline int PageKsm(struct page *page)
> +{
> +	return ((unsigned long)page->mapping == PAGE_MAPPING_ANON);
> +}

I'm unconvinced it's sane to have PageAnon return 1 on Ksm pages.

The above will also have short lifetime so not sure it's worth it,
if we want to swap we'll have to move to something that to:

PageExternal()
{
	return (unsigned long)page->mapping & PAGE_MAPPING_EXTERNAL != 0;
}

> +static inline void page_add_ksm_rmap(struct page *page)
> +{
> +	if (atomic_inc_and_test(&page->_mapcount)) {
> +		page->mapping = (void *) PAGE_MAPPING_ANON;
> +		__inc_zone_page_state(page, NR_ANON_PAGES);
> +	}
> +}

Is it correct to account them as anon pages?

> -	if (PageAnon(old_page)) {
> +	if (PageAnon(old_page) && !PageKsm(old_page)) {
>  		if (!trylock_page(old_page)) {
>  			page_cache_get(old_page);
>  			pte_unmap_unlock(page_table, ptl);

What exactly does it buy to have PageAnon return 1 on ksm pages,
besides requiring the above additional check (that if we stick to the
above code, I would find safer to move inside reuse_swap_page).
