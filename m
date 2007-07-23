Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXGWOgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXGWOgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXGWOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:36:29 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36864 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753060AbXGWOg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:36:28 -0400
Message-ID: <385201377.00678@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 23 Jul 2007 22:24:57 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Message-ID: <20070723142457.GA10130@mail.ustc.edu.cn>
Mail-Followup-To: Nick Piggin <nickpiggin@yahoo.com.au>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>
References: <20070721210005.000228000@chello.nl> <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com> <20070722081010.GA6317@mail.ustc.edu.cn> <1185093236.6344.87.camel@localhost.localdomain> <46A46E4B.7050007@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A46E4B.7050007@yahoo.com.au>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 07:00:59PM +1000, Nick Piggin wrote:
> Rusty Russell wrote:
> >On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:
> 
> >>So I opt for it being made tunable, safe, and turned off by default.
> 
> I hate tunables :) Unless we have workload A that gets a reasonable
> benefit from something and workload B that gets a significant regression,
> and no clear way to reconcile them...

Me too ;)

But sometimes we really want to avoid flushing the cache.
Andrew's user space LD_PRELOAD+fadvise based tool fit nicely here.

> >I'd like to see it turned on by default in -mm, and try to come up with
> >some server-like workload to measure the effect.  Should be easy to
> >simulate something (eg. apache server, where clients grab some files in
> >preference, and apache server where clients grab different files).
> 
> I don't like this kind of conditional information going from something
> like readahead into page reclaim. Unless it is for readahead _specific_
> data such as "I got these all wrong, so you can reclaim them" (which
> this isn't).
> 
> Possibly it makes sense to realise that the given pages are cheaper
> to read back in as they are apparently being read-ahead very nicely.

In fact I have talked to Jens about it in last year's kernel summit.
The patch below explains itself.
---
Subject: cost based page reclaim

Cost based page reclaim - a minimalist implementation.

Suppose we cached 32 small files each with 1 page, and one 32-page chunk from a
large file.  Should we first drop the 32-pages which are read in one I/O, or
drop the 32 distinct pages, each costs one I/O? (Given that the files are of
equal hotness.)

Page replacement algorithms should be designed to minimize the number of I/Os,
instead of the number of page faults. Dividing the cost of I/O by the number of
pages it bring in, we get the cost of the page. The bigger page cost, the more
'lives/bloods' the page should have.

This patch adds life to costly pages by pretending that they are
referenced more times. Possible downsides:
- burdens the pressure of vmscan
- active pages are no longer that 'active'

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/backing-dev.h |    1 +
 mm/readahead.c              |   27 +++++++++++++++++++++++++++
 mm/swap.c                   |    5 ++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

--- linux-2.6.22.orig/mm/readahead.c
+++ linux-2.6.22/mm/readahead.c
@@ -125,6 +125,7 @@ static void ra_account(struct file_ra_st
 
 struct backing_dev_info default_backing_dev_info = {
 	.ra_pages	= MAX_RA_PAGES,
+	.avg_ra_size	= MAX_RA_PAGES * PAGE_CACHE_SIZE,
 	.ra_pages0	= INITIAL_RA_PAGES,
 	.ra_thrash_bytes = MAX_RA_PAGES * PAGE_CACHE_SIZE,
 	.state		= 0,
@@ -133,6 +134,26 @@ struct backing_dev_info default_backing_
 };
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
+#define log2(n) fls(n)
+static int readahead_cost_per_page(struct address_space *mapping,
+						unsigned long pages)
+{
+	unsigned long avg;
+	int cost;
+
+	avg = mapping->backing_dev_info->avg_ra_size;
+	avg = (pages * PAGE_CACHE_SIZE + avg * 1023) / 1024;
+	mapping->backing_dev_info->avg_ra_size = avg;
+
+	avg = avg / PAGE_CACHE_SIZE;
+	if (!avg || !pages)
+		cost = 0;
+	else
+		cost = (log2(avg) - log2(pages)) * 5 / log2(avg);
+
+	return cost;
+}
+
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.
@@ -418,6 +439,7 @@ __do_page_cache_readahead(struct address
 	struct page *page;
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
+	int cost;
 	int page_idx;
 	int ret = 0;
 	loff_t isize = i_size_read(inode);
@@ -426,6 +448,7 @@ __do_page_cache_readahead(struct address
 		goto out;
 
 	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+	cost = readahead_cost_per_page(mapping, nr_to_read);
 
 	/*
 	 * Preallocate as many pages as we will need.
@@ -448,6 +471,10 @@ __do_page_cache_readahead(struct address
 		if (!page)
 			break;
 		page->index = page_offset;
+		if (cost >= 3)
+			SetPageActive(page);
+		else if (cost == 2)
+			SetPageReferenced(page);
 		list_add(&page->lru, &page_pool);
 		if (page_idx == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
--- linux-2.6.22.orig/mm/swap.c
+++ linux-2.6.22/mm/swap.c
@@ -365,7 +365,10 @@ void __pagevec_lru_add(struct pagevec *p
 		}
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
-		add_page_to_inactive_list(zone, page);
+		if (!PageActive(page))
+			add_page_to_inactive_list(zone, page);
+		else
+			add_page_to_active_list(zone, page);
 	}
 	if (zone)
 		spin_unlock_irq(&zone->lru_lock);
--- linux-2.6.22.orig/include/linux/backing-dev.h
+++ linux-2.6.22/include/linux/backing-dev.h
@@ -26,6 +26,7 @@ typedef int (congested_fn)(void *, int);
 
 struct backing_dev_info {
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
+	unsigned long avg_ra_size;
 	unsigned long ra_pages0; /* min readahead on start of file */
 	unsigned long ra_thrash_bytes;	/* estimated thrashing threshold */
 	unsigned long state;	/* Always use atomic bitops on this */

