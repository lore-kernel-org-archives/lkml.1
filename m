Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZCWJBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZCWJBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbZCWJBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:01:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51657 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbZCWJBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:01:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 3/3] mm: keep pages from unevictable mappings off the LRU  lists
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090323084254.GA1685@cmpxchg.org>
References: <20090323111615.69F3.A69D9226@jp.fujitsu.com> <20090323084254.GA1685@cmpxchg.org>
Message-Id: <20090323175507.6A18.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 18:01:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 23, 2009 at 11:21:36AM +0900, KOSAKI Motohiro wrote:
> > > Hmm,,
> > > 
> > > This patch is another thing unlike previous series patches.
> > > Firstly, It looked good to me.
> > > 
> > > I think add_to_page_cache_lru have to become a fast path.
> > > But, how often would ramfs and shmem function be called ?
> > > 
> > > I have a concern for this patch to add another burden.
> > > so, we need any numbers for getting pros and cons.
> > > 
> > > Any thoughts ?
> > 
> > this is the just reason why current code don't call add_page_to_unevictable_list().
> > add_page_to_unevictable_list() don't use pagevec. it is needed for avoiding race.
> > 
> > then, if readahead path (i.e. add_to_page_cache_lru()) use add_page_to_unevictable_list(),
> > it can cause zone->lru_lock contention storm.
> 
> How is it different then shrink_page_list()?  If readahead put a
> contiguous chunk of unevictable pages to the file lru, then
> shrink_page_list() will as well call add_page_to_unevictable_list() in
> a loop.

it's probability issue.

readahead: we need to concern
	(1) readahead vs readahead
	(2) readahead vs reclaim

vmscan: we need to concern
	(3) background reclaim vs foreground reclaim

So, (3) is rarely event than (1) and (2).
Am I missing anything?



