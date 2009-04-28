Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZD1B7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZD1B7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZD1B6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:58:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:28519 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247AbZD1B6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:58:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,257,1239001200"; 
   d="scan'208";a="407441450"
Subject: Re: [PATCH 00/22] Cleanup and optimise the page allocator V7
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090427143845.GC912@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240819119.2567.884.camel@ymzhang>  <20090427143845.GC912@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 09:59:17 +0800
Message-Id: <1240883957.2567.886.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 15:38 +0100, Mel Gorman wrote:
> On Mon, Apr 27, 2009 at 03:58:39PM +0800, Zhang, Yanmin wrote:
> > On Wed, 2009-04-22 at 14:53 +0100, Mel Gorman wrote:
> > > Here is V7 of the cleanup and optimisation of the page allocator and
> > > it should be ready for wider testing. Please consider a possibility for
> > > merging as a Pass 1 at making the page allocator faster. Other passes will
> > > occur later when this one has had a bit of exercise. This patchset is based
> > > on mmotm-2009-04-17 and I've tested it successfully on a small number of
> > > machines.
> > We ran some performance benchmarks against V7 patch on top of 2.6.30-rc3.
> > It seems some counters in kernel are incorrect after we run some ffsb (disk I/O benchmark)
> > and swap-cp (a simple swap memory testing by cp on tmpfs). Free memory is bigger than
> > total memory.
> > 
> 
> oops. Can you try this patch please?
> 
> ==== CUT HERE ====
> 
> Properly account for freed pages in free_pages_bulk() and when allocating high-order pages in buffered_rmqueue()
> 
> free_pages_bulk() updates the number of free pages in the zone but it is
> assuming that the pages being freed are order-0. While this is currently
> always true, it's wrong to assume the order is 0. This patch fixes the
> problem.
> 
> buffered_rmqueue() is not updating NR_FREE_PAGES when allocating pages with
> __rmqueue(). This means that any high-order allocation will appear to increase
> the number of free pages leading to the situation where free pages appears to
> exceed available RAM. This patch accounts for those allocated pages properly.
> 
> This is a candidate fix to the patch
> page-allocator-update-nr_free_pages-only-as-necessary.patch. It has yet to be
> verified as fixing a problem where the free pages count is getting corrupted.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3db5f57..dd69593 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -545,7 +545,7 @@ static void free_pages_bulk(struct zone *zone, int count,
>  	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
>  	zone->pages_scanned = 0;
>  
> -	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
> +	__mod_zone_page_state(zone, NR_FREE_PAGES, count << order);
>  	while (count--) {
>  		struct page *page;
>  
> @@ -1151,6 +1151,7 @@ again:
>  	} else {
>  		spin_lock_irqsave(&zone->lock, flags);
>  		page = __rmqueue(zone, order, migratetype);
> +		__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
Here 'i' should be 1?

>  		spin_unlock(&zone->lock);
>  		if (!page)
>  			goto failed;
I ran a cp kernel source files and swap-cp workload and didn't find
bad counter now.


