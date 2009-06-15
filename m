Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZFOEva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZFOEva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbZFOEvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:51:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36695 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZFOEvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:51:20 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] Properly account for the number of page cache pages zone_reclaim() can reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090612101735.GA14498@csn.ul.ie>
References: <20090611203349.6D68.A69D9226@jp.fujitsu.com> <20090612101735.GA14498@csn.ul.ie>
Message-Id: <20090615134406.B422.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Jun 2009 13:51:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +/* Work out how many page cache pages we can reclaim in this reclaim_mode */
> > > +static long zone_pagecache_reclaimable(struct zone *zone)
> > > +{
> > > +	long nr_pagecache_reclaimable;
> > > +	long delta = 0;
> > > +
> > > +	/*
> > > +	 * If RECLAIM_SWAP is set, then all file pages are considered
> > > +	 * potentially reclaimable. Otherwise, we have to worry about
> > > +	 * pages like swapcache and zone_unmapped_file_pages() provides
> > > +	 * a better estimate
> > > +	 */
> > > +	if (zone_reclaim_mode & RECLAIM_SWAP)
> > > +		nr_pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
> > > +	else
> > > +		nr_pagecache_reclaimable = zone_unmapped_file_pages(zone);
> > > +
> > > +	/* If we can't clean pages, remove dirty pages from consideration */
> > > +	if (!(zone_reclaim_mode & RECLAIM_WRITE))
> > > +		delta += zone_page_state(zone, NR_FILE_DIRTY);
> > 
> > no use delta?
> > 
> 
> delta was used twice in an interim version when it was possible to overflow
> the counter. I left it as is because if another counter is added that must
> be subtracted from nr_pagecache_reclaimable, it'll be tidier to patch in if
> delta was there. I can take it out if you prefer.

Honestly, I'm confusing now.

your last version have following usage of "delta"

	/* Beware of double accounting */
	if (delta < nr_pagecache_reclaimable)
		nr_pagecache_reclaimable -= delta;

but current your patch don't have it.
IOW, nobody use delta variable. I'm not sure about you forget to
accurate to nr_pagecache_reclaimable or forget to remove 
"delta += zone_page_state(zone, NR_FILE_DIRTY);" line.

Or, Am I missing anything?
Now, I don't oppose this change. I only hope to clarify your intention.



> > > -	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
> > > -				 zone_page_state(zone, NR_ACTIVE_FILE) -
> > > -				 zone_page_state(zone, NR_FILE_MAPPED);
> > > -
> > > -	if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
> > > +	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
> > 
> > Documentation/sysctl/vm.txt says
> > =============================================================
> > 
> > min_unmapped_ratio:
> > 
> > This is available only on NUMA kernels.
> > 
> > A percentage of the total pages in each zone.  Zone reclaim will only
> > occur if more than this percentage of pages are file backed and unmapped.
> > This is to insure that a minimal amount of local pages is still available for
> > file I/O even if the node is overallocated.
> > 
> > The default is 1 percent.
> > 
> > ==============================================================
> > 
> > but your code condider more addional thing. Can you please change document too?
> > 
> 
> How does this look?
> 
> ==============================================================
> min_unmapped_ratio:
> 
> This is available only on NUMA kernels.
> 
> This is a percentage of the total pages in each zone. Zone reclaim will only
> occur if more than this percentage are in a state that zone_reclaim_mode
> allows to be reclaimed.
> 
> If zone_reclaim_mode has the value 4 OR'd, then the percentage is compared
> against all file-backed unmapped pages including swapcache pages and tmpfs
> files. Otherwise, only unmapped pages backed by normal files but not tmpfs
> files and similar are considered.
> 
> The default is 1 percent.
> ==============================================================

Great! thanks.



