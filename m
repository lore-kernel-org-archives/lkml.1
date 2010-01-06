Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416Ab0AFWHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0AFWHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403Ab0AFWHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:07:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42515 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab0AFWHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:07:36 -0500
Date: Wed, 6 Jan 2010 22:07:25 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] Memory compaction core
Message-ID: <20100106220725.GD5426@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-5-git-send-email-mel@csn.ul.ie> <87iqbeykx9.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87iqbeykx9.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 10:37:22PM +0100, Andi Kleen wrote:
> Mel Gorman <mel@csn.ul.ie> writes:
> 
> 
> Haven't reviewed the full thing, but one thing I noticed below:
> 
> > +
> > +	/*
> > +	 * Isolate free pages until enough are available to migrate the
> > +	 * pages on cc->migratepages. We stop searching if the migrate
> > +	 * and free page scanners meet or enough free pages are isolated.
> > +	 */
> > +	spin_lock_irq(&zone->lock);
> 
> Won't that cause very long lock hold times on large zones?

Good question.  The amount of memory unavailable and the duration should
be bounded.

isolate_migratepages only considers a pageblock of pages, the maximum of
which will be MAX_ORDER_NR_PAGES so ordinarily you would expect the hold
time to be fairly short - even on large zones.

The one exception is if migration of too many of these pages are failing. The
pages are not immediately put back on the LRU list. In a really bad scenario,
too many free pages could indeed get isolated. I comment on this problem
although from another perspective here

         * XXX: Page migration at this point tries fairly hard to move
         *      pages as it is but if migration fails, pages are left
         *      on cc->migratepages for more passes. This might cause
         *      multiple useless failures. Watch
         *      compact_pagemigrate_failed
         *      in /proc/vmstat. If it grows a lot, then putback should
         *      happen after each failed migration

So, in theory in a worst case scenario, it could grow too much. The
solution would be to put pages that fail to migrate back on the LRU
list. That would keep the length of time zone->lock is held low.

Even in that worst case scenario, there is a limit to how many pages will
be removed from the free lists. When isolating free pages, split_free_page
is called and one of the checks it makes is

       /* Obey watermarks or the system could deadlock */
        watermark = low_wmark_pages(zone) + (1 << order);
        if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
                return 0;

i.e. it shouldn't be isolating pages if watermarks get messed up. If
enough free pages are not available, migration should fail, compaction
therefore fails and all the pages get put back.

Bottom line, I do not expect it to be bad. I'm much more concerned about
zone->lock getting hammered by isolating free pages, then giving them
back because page migration keeps failing and freeing the isolated pages
back to the lists.

> Presumably you need some kind of lock break heuristic.
> 

The heuristic I'm going for is "never be taking too many pages".

Just in case though, I'll put in a

	WARN_ON_ONCE(nr_migratepages > MAX_ORDER_NR_PAGES * 3);

in isolate_free_pages. If that warning triggers, it likely means the
lock is being held too long.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
