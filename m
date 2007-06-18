Return-Path: <linux-kernel-owner+w=401wt.eu-S1764166AbXFRRS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764166AbXFRRS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbXFRRSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:18:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51969 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756816AbXFRRSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:18:49 -0400
Date: Mon, 18 Jun 2007 10:18:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 5/7] Introduce a means of compacting memory within a zone
In-Reply-To: <20070618093002.7790.68471.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0706181010030.4751@schroedinger.engr.sgi.com>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
 <20070618093002.7790.68471.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Mel Gorman wrote:

> +	/* Isolate free pages. This assumes the block is valid */
> +	for (; blockpfn < end_pfn; blockpfn++) {
> +		struct page *page;
> +		int isolated, i;
> +
> +		if (!pfn_valid_within(blockpfn))
> +			continue;
> +
> +		page = pfn_to_page(blockpfn);
> +		if (!PageBuddy(page))
> +			continue;

The name PageBuddy is getting to be misleading. Maybe rename this to
PageFree or so?

> +
> +		/* Found a free page, break it into order-0 pages */
> +		isolated = split_free_page(page);
> +		total_isolated += isolated;
> +		for (i = 0; i < isolated; i++) {
> +			list_add(&page->lru, freelist);
> +			page++;
> +		}

Why do you need to break them all up? Easier to coalesce later?

> +/* Returns 1 if the page is within a block suitable for migration to */
> +static int pageblock_migratable(struct page *page)
> +{
> +	/* If the page is a large free page, then allow migration */
> +	if (PageBuddy(page) && page_order(page) >= pageblock_order)
> +		return 1;

if (PageSlab(page) && page->slab->ops->kick) {
	migratable slab
}

if (page table page) {
	migratable page table page?
}

etc?

> +		/* Try isolate the page */
> +		if (locked_isolate_lru_page(zone, page, migratelist) == 0)
> +			isolated++;

Support for other ways of migrating a page?

> +static int compact_zone(struct zone *zone, struct compact_control *cc)
> +{
> +	int ret = COMPACT_INCOMPLETE;
> +
> +	/* Setup to move all movable pages to the end of the zone */
> +	cc->migrate_pfn = zone->zone_start_pfn;
> +	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
> +	cc->free_pfn &= ~(pageblock_nr_pages-1);
> +
> +	for (; ret == COMPACT_INCOMPLETE; ret = compact_finished(zone, cc)) {
> +		isolate_migratepages(zone, cc);
> +
> +		if (!cc->nr_migratepages)
> +			continue;
> +
> +		/* Isolate free pages if necessary */
> +		if (cc->nr_freepages < cc->nr_migratepages)
> +			isolate_freepages(zone, cc);
> +
> +		/* Stop compacting if we cannot get enough free pages */
> +		if (cc->nr_freepages < cc->nr_migratepages)
> +			break;
> +
> +		migrate_pages(&cc->migratepages, compaction_alloc,
> +							(unsigned long)cc);

You do not need to check the result of migration? Page migration is a best 
effort that may fail.

Looks good otherwise.

Acked-by: Christoph Lameter <clameter@sgi.com>

