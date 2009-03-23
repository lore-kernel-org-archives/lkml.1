Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbZCWIoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbZCWIoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZCWIoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:44:13 -0400
Received: from cmpxchg.org ([85.214.51.133]:54634 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102AbZCWIoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:44:12 -0400
Date: Mon, 23 Mar 2009 09:42:54 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 3/3] mm: keep pages from unevictable mappings off the LRU  lists
Message-ID: <20090323084254.GA1685@cmpxchg.org>
References: <1237752784-1989-3-git-send-email-hannes@cmpxchg.org> <28c262360903221744r6d275294gdc8ad3a12b8c5361@mail.gmail.com> <20090323111615.69F3.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323111615.69F3.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 11:21:36AM +0900, KOSAKI Motohiro wrote:
> > Hmm,,
> > 
> > This patch is another thing unlike previous series patches.
> > Firstly, It looked good to me.
> > 
> > I think add_to_page_cache_lru have to become a fast path.
> > But, how often would ramfs and shmem function be called ?
> > 
> > I have a concern for this patch to add another burden.
> > so, we need any numbers for getting pros and cons.
> > 
> > Any thoughts ?
> 
> this is the just reason why current code don't call add_page_to_unevictable_list().
> add_page_to_unevictable_list() don't use pagevec. it is needed for avoiding race.
> 
> then, if readahead path (i.e. add_to_page_cache_lru()) use add_page_to_unevictable_list(),
> it can cause zone->lru_lock contention storm.

How is it different then shrink_page_list()?  If readahead put a
contiguous chunk of unevictable pages to the file lru, then
shrink_page_list() will as well call add_page_to_unevictable_list() in
a loop.
