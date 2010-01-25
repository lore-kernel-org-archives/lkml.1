Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140Ab0AYApx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0AYApx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 19:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914Ab0AYApw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 19:45:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60619 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0AYApw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 19:45:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 25 Jan 2010 09:42:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Frost <frost@CS.UCLA.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       Steve Dickson <steved@redhat.com>, David Howells <dhowells@redhat.com>,
       Xu Chenfeng <xcf@ustc.edu.cn>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>
Subject: Re: [PATCH] mm/readahead.c: update the LRU positions of in-core
 pages, too
Message-Id: <20100125094228.f7ca1430.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100123102222.GA6943@localhost>
References: <20100120215536.GN27212@frostnet.net>
	<20100121054734.GC24236@localhost>
	<20100123040348.GC30844@frostnet.net>
	<20100123102222.GA6943@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010 18:22:22 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Hi Chris,
> 
> > > +/*
> > > + * Move pages in danger (of thrashing) to the head of inactive_list.
> > > + * Not expected to happen frequently.
> > > + */
> > > +static unsigned long rescue_pages(struct address_space *mapping,
> > > +				  struct file_ra_state *ra,
> > > +				  pgoff_t index, unsigned long nr_pages)
> > > +{
> > > +	struct page *grabbed_page;
> > > +	struct page *page;
> > > +	struct zone *zone;
> > > +	int pgrescue = 0;
> > > +
> > > +	dprintk("rescue_pages(ino=%lu, index=%lu, nr=%lu)\n",
> > > +			mapping->host->i_ino, index, nr_pages);
> > > +
> > > +	for(; nr_pages;) {
> > > +		grabbed_page = page = find_get_page(mapping, index);
> > > +		if (!page) {
> > > +			index++;
> > > +			nr_pages--;
> > > +			continue;
> > > +		}
> > > +
> > > +		zone = page_zone(page);
> > > +		spin_lock_irq(&zone->lru_lock);
> > > +
> > > +		if (!PageLRU(page)) {
> > > +			index++;
> > > +			nr_pages--;
> > > +			goto next_unlock;
> > > +		}
> > > +
> > > +		do {
> > > +			struct page *the_page = page;
> > > +			page = list_entry((page)->lru.prev, struct page, lru);
> > > +			index++;
> > > +			nr_pages--;
> > > +			ClearPageReadahead(the_page);
> > > +			if (!PageActive(the_page) &&
> > > +					!PageLocked(the_page) &&
> > > +					page_count(the_page) == 1) {
> > 
> > Why require the page count to be 1?
> 
> Hmm, I think the PageLocked() and page_count() tests meant to
> skip pages being manipulated by someone else.
> 
> You can just remove them.  In fact the page_count()==1 will exclude
> the grabbed_page, so must be removed. Thanks for the reminder!
> 
> > 
> > > +				list_move(&the_page->lru, &zone->inactive_list);
> > 
> > The LRU list manipulation interface has changed since this patch.
> 
> Yeah.
> 
> > I believe we should replace the list_move() call with:
> > 	del_page_from_lru_list(zone, the_page, LRU_INACTIVE_FILE);
> > 	add_page_to_lru_list(zone, the_page, LRU_INACTIVE_FILE);
> > This moves the page to the top of the list, but also notifies mem_cgroup.
> > It also, I believe needlessly, decrements and then increments the zone
> > state for each move.
> 
> Why do you think mem_cgroup shall be notified here? As me understand
> it, mem_cgroup should only care about page addition/removal.
> 
No. memcg maintains its LRU list in synchronous way with global LRU.
So, I think it's better to call usual LRU handler calls as Chris does.

And...for maintainance, I like following code rather than your direct code.
Because you mention " Not expected to happen frequently."

void find_isolate_inactive_page(struct address_space *mapping,  pgoff_t index, int len)
{
	int i = 0;
	struct list_head *list;

	for (i = 0; i < len; i++)
		page = find_get_page(mapping, index + i);
		if (!page)
			continue;
		zone = page_zone(page);
		spin_lock_irq(&zone->lru_lock); /* you can optimize this if you want */
		/* isolate_lru_page() doesn't handle the type of list, so call __isolate_lru_page */
		if (__isolate_lru_page(page, ISOLATE_INACTIVE, 1)
			continue;
		spin_unlock_irq(&zone->lru_lock);
		ClearPageReadahead(page);
		putback_lru_page(page);
	}
}

Please feel free to do as you want but please takeing care of memcg' lru management.

Thanks,
-Kame

