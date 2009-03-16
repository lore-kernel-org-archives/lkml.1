Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZCPQmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZCPQmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZCPQmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:42:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44963 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZCPQml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:42:41 -0400
Date: Mon, 16 Mar 2009 16:42:39 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 23/35] Update NR_FREE_PAGES only as necessary
Message-ID: <20090316164238.GK24293@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-24-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161214080.32577@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903161214080.32577@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:17:15PM -0400, Christoph Lameter wrote:
> On Mon, 16 Mar 2009, Mel Gorman wrote:
> 
> > When pages are being freed to the buddy allocator, the zone
> > NR_FREE_PAGES counter must be updated. In the case of bulk per-cpu page
> > freeing, it's updated once per page. This retouches cache lines more
> > than necessary. Update the counters one per per-cpu bulk free.
> 
> Not sure about the reasoning here since the individual updates are batched

Each update take places between lots of other work with different cache
lines. With enough buddy merging, I believed the line holding the counters
could at least get pushed out of L1 although probably not L2 cache.

> and you are touching the same cacheline as the pcp you are operating on
> and have to touch anyways.
> 
> But if its frequent that __rmqueue_smallest() and free_pages_bulk() are
> called with multiple pages then its always a win.
> 

It's frequent enough that it showed up in profiles

> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> 
> > +	__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order) * i);
> 
> A multiplication? Okay with contemporary cpus I guess.
> 

Replaced with

__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
