Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZCZAuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZCZAuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZCZAt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:49:59 -0400
Received: from cmpxchg.org ([85.214.51.133]:54485 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbZCZAt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:49:58 -0400
Date: Thu, 26 Mar 2009 01:48:38 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 3/3] mm: keep pages from unevictable mappings off the LRU  lists
Message-ID: <20090326004838.GB5404@cmpxchg.org>
References: <20090323084254.GA1685@cmpxchg.org> <20090323175507.6A18.A69D9226@jp.fujitsu.com> <20090323182039.6A1B.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323182039.6A1B.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 06:23:36PM +0900, KOSAKI Motohiro wrote:
> > > > this is the just reason why current code don't call add_page_to_unevictable_list().
> > > > add_page_to_unevictable_list() don't use pagevec. it is needed for avoiding race.
> > > > 
> > > > then, if readahead path (i.e. add_to_page_cache_lru()) use add_page_to_unevictable_list(),
> > > > it can cause zone->lru_lock contention storm.
> > > 
> > > How is it different then shrink_page_list()?  If readahead put a
> > > contiguous chunk of unevictable pages to the file lru, then
> > > shrink_page_list() will as well call add_page_to_unevictable_list() in
> > > a loop.
> > 
> > it's probability issue.
> > 
> > readahead: we need to concern
> > 	(1) readahead vs readahead
> > 	(2) readahead vs reclaim
> > 
> > vmscan: we need to concern
> > 	(3) background reclaim vs foreground reclaim
> > 
> > So, (3) is rarely event than (1) and (2).
> > Am I missing anything?
> 
> my last mail explanation is too poor. sorry.
> I don't dislike this patch concept. but it seems a bit naive against contention.
> if we can decrease contention risk, I can ack with presure.

My understanding is that when the mapping is truncated before the
pages are scanned for reclaim, then we have a net increase of risk for
the contention storm you describe.

Otherwise, we moved the contention from the reclaim path to the fault
path.

I don't know how likely readahead is.  It only happens when the
mapping was blown up with truncate, otherwise only writes add to the
cache in the ramfs case.

I will further look into this.

	Hannes
