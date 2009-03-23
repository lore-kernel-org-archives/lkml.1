Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZCWCVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZCWCVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 22:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZCWCVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 22:21:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59939 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZCWCVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 22:21:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [patch 3/3] mm: keep pages from unevictable mappings off the LRU  lists
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <28c262360903221744r6d275294gdc8ad3a12b8c5361@mail.gmail.com>
References: <1237752784-1989-3-git-send-email-hannes@cmpxchg.org> <28c262360903221744r6d275294gdc8ad3a12b8c5361@mail.gmail.com>
Message-Id: <20090323111615.69F3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 11:21:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm,,
> 
> This patch is another thing unlike previous series patches.
> Firstly, It looked good to me.
> 
> I think add_to_page_cache_lru have to become a fast path.
> But, how often would ramfs and shmem function be called ?
> 
> I have a concern for this patch to add another burden.
> so, we need any numbers for getting pros and cons.
> 
> Any thoughts ?

this is the just reason why current code don't call add_page_to_unevictable_list().
add_page_to_unevictable_list() don't use pagevec. it is needed for avoiding race.

then, if readahead path (i.e. add_to_page_cache_lru()) use add_page_to_unevictable_list(),
it can cause zone->lru_lock contention storm.

then, if nobody have good performance result, I don't ack this patch.


> On Mon, Mar 23, 2009 at 5:13 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > Check if the mapping is evictable when initially adding page cache
> > pages to the LRU lists. ?If that is not the case, add them to the
> > unevictable list immediately instead of leaving it up to the reclaim
> > code to move them there.
> >
> > This is useful for ramfs and locked shmem which mark whole mappings as
> > unevictable and we know at fault time already that it is useless to
> > try reclaiming these pages.


