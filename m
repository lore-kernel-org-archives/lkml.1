Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab0BPQrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:47:37 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:43860 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab0BPQrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:47:35 -0500
Message-ID: <4B7ACC1E.9080205@linux.vnet.ibm.com>
Date: Tue, 16 Feb 2010 17:47:26 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie> <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie> <4B7184B5.6040400@linux.vnet.ibm.com> <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie>
In-Reply-To: <20100216112517.GE1194@csn.ul.ie>
Content-Type: multipart/mixed;
 boundary="------------010002040105070909020804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010002040105070909020804
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit

Mel Gorman wrote:
> On Mon, Feb 15, 2010 at 04:46:53PM +0100, Christian Ehrhardt wrote:
[...]
>> The differences in asm are pretty much the same, as before rmqueue_bulk was already inlined the actually intended change to its parameters was negligible.
>> I wondered if it would be important if that is a constant value (-1) or if the reason was caused by that shift. So I tried:
>>
>>  23 @@ -965,7 +965,7 @@
>>  24                 set_page_private(page, migratetype);
>>  25                 list = &page->lru;
>>  26         }
>>  27 -       __mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
>>  28 +       __mod_zone_page_state(zone, NR_FREE_PAGES, -i);
>>  29         spin_unlock(&zone->lock);
>>  30         return i;
>>  31  }
>>
[...]
> It "fixes" it only by not calling direct reclaim when it should :(

yeah as we both realized -1 was not right so it was more a crazy workaround :-)

Anyway after that being a dead end again I dug even deeper into the details of direct_reclaim - I think we can agree that out of the counters we already know the race between try_to_free making progress and get_page not getting a page causing the congestion_wait is source of the issue.

So what I tried to bring some more light into all that was extending my perf counters to track a few more details in direct_reclaim.
Two patches are attached and apply after the other three already available in that thread.
The intention is
a) to track the time
 a1) spent in try_to_free_pages
 a2) consumed after try_to_free_pages until get_page_from_freelist
 a3) spent in get_pages_from_freelist
b1) after seeing that order!=0 -> drain_all_pages I wondered if that might differ even all calls look like they have zero
b2) tracking the average amount of pages freed by try_to_free_pages for fast path and slow path (progres&!page)

Naming convention (otherwise it might get confusing here)
Good case - the scenario e.g. with e084b and 5f8dcc21 reverted resulting in high throughput and a low ratio of direct_reclaim running into progress&!page
Bad case - the scenario e.g. on a clean 2.6.32
Fast path - direct reclaim calls that did not run into progress&!page
Slow path - direct reclaim calls that ran into progress&!page ending up in a long congestion_wait and therefore called "slow" path

Mini summary of what we had before in huge tables:
            fast path   slow path
GOOD CASE      ~98%       ~1-3%
BAD CASE       ~70%        ~30%
-> leading to throughput impact of e.g. 600 mb/s with 16 iozone threads (worse with even more threads)

Out of the numbers I got the following things might help us to create a new approach to a solution.
The timings showed that that the so called slow case is actually much faster passing though direct_reclaim in bad case.

GOOD CASE                                        duration
a1 Fast-avg-duration_pre_ttf_2_post_ttf            164099
a2 Fast-avg-duration_post_ttf_2_pre_get_page          459
a3 Fast-avg-duration_pre_get_page_2_post_get_page     346
a1 Slow-avg-duration_pre_ttf_2_post_ttf            127621
a2 Slow-avg-duration_post_ttf_2_pre_get_page         1957
a3 Slow-avg-duration_pre_get_page_2_post_get_page     256
BAD CASE                                         duration   deviation to good case in %
a1 Fast-avg-duration_pre_ttf_2_post_ttf            122921   -25.09%
a2 Fast-avg-duration_post_ttf_2_pre_get_page          521   13.53%
a3 Fast-avg-duration_pre_get_page_2_post_get_page     244   -29.55%
a1 Slow-avg-duration_pre_ttf_2_post_ttf            109740   -14.01%
a2 Slow-avg-duration_post_ttf_2_pre_get_page          250   -87.18%
a3 Slow-avg-duration_pre_get_page_2_post_get_page     117   -54.16%

That means that in the bad case the execution is much faster. Especially in the case that eventually runs into the slow path try_to_free is 14% faster, more important the time between try_to_free and get_pages is 87%! faster => less than a fifth and finally get_page is 54% faster, but that is probably just failing in an almost empty list which is fast^^.

As I checked order which always was zero the time is not spent in drain_all_pages and the only other thing left might be cond_resched ?!
Everything else are a few assignments so it can't be much else.
But why would e.g. not running into schedule in cond_resched cause get_pages to not find anything - I don't know and I would expect it should be the other way around - the faster you get from free to get the more pages should be left.

I thought the progress try_to_free_pages is doing might be important as well so I took numbers for that too.
>From those I see that the good case as well as the bad case has an average of 62 pages freed in fast path.
But in slow path they start to differ - while the good case that is running only seldom in that path anyway frees an average of 1.46 pages (that might be the thing causing it not getting a page eventually) in the bad case it makes a progress of avg 37 pages even in slow path.

PAGES-FREED  fast path   slow path
GOOD CASE      ~62       ~1.46
BAD CASE       ~62       ~37

Thinking of it as asking "how few pages do I have to free until I fall from fast to slow path" the kernels behave different it looks wrong but interesting.
The good case only drops to slow path (!page) in case of ~1.46 pages freed while the bad case seems to enter that much earlier with even 37 pages freed.

As order is always 0 and get_page afaik about getting just "one" page I wonder where these 37 pages disappeared especially as in bad case it is much faster getting to get_pages after freeing those ~37 pages.

Comments and ideas welcome!

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

--------------010002040105070909020804
Content-Type: text/x-patch;
 name="perf-count-direct-reclaim-durations.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-direct-reclaim-durations.diff"

Index: linux-2.6-git/kernel/sysctl.c
===================================================================
--- linux-2.6-git.orig/kernel/sysctl.c	2010-02-16 11:06:29.000000000 +0100
+++ linux-2.6-git/kernel/sysctl.c	2010-02-16 13:38:48.000000000 +0100
@@ -264,9 +264,64 @@
 extern unsigned long perf_count_failed_pages_direct_reclaim_but_progress;
 extern unsigned long perf_count_call_congestion_wait_from_alloc_pages_high_priority;
 extern unsigned long perf_count_call_congestion_wait_from_alloc_pages_slowpath;
+
+extern unsigned long long perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf;
+extern unsigned long long perf_count_direct_reclaim_slow_dursum_post_ttf_2_pre_get_page;
+extern unsigned long long perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_ttf;
+extern unsigned long long perf_count_direct_reclaim_fast_dursum_pre_ttf_2_post_ttf;
+extern unsigned long long perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page;
+extern unsigned long long perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_ttf;
 static struct ctl_table perf_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf",
+		.data           = &perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_slow_dursum_post_ttf_2_pre_get_page",
+		.data           = &perf_count_direct_reclaim_slow_dursum_post_ttf_2_pre_get_page,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_get_page",
+		.data           = &perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_get_page,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_fast_dursum_pre_ttf_2_post_ttf",
+		.data           = &perf_count_direct_reclaim_fast_dursum_pre_ttf_2_post_ttf,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page",
+		.data           = &perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_get_page",
+		.data           = &perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_get_page,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname       = "perf_count_congestion_wait",
 		.data           = &perf_count_congestion_wait,
 		.mode           = 0666,
Index: linux-2.6-git/mm/page_alloc.c
===================================================================
--- linux-2.6-git.orig/mm/page_alloc.c	2010-02-16 11:06:29.000000000 +0100
+++ linux-2.6-git/mm/page_alloc.c	2010-02-16 13:38:24.000000000 +0100
@@ -51,6 +51,7 @@
 #include <trace/events/kmem.h>
 
 #include <asm/tlbflush.h>
+#include <asm/timex.h>
 #include <asm/div64.h>
 #include "internal.h"
 
@@ -1655,6 +1656,17 @@
 unsigned long perf_count_failed_pages_direct_reclaim = 0;
 unsigned long perf_count_failed_pages_direct_reclaim_but_progress = 0;
 
+unsigned long long perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf = 0;
+unsigned long long perf_count_direct_reclaim_slow_dursum_post_ttf_2_pre_get_page = 0;
+unsigned long long perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_get_page = 0;
+unsigned long long perf_count_direct_reclaim_fast_dursum_pre_ttf_2_post_ttf = 0;
+unsigned long long perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page = 0;
+unsigned long long perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_get_page = 0;
+
+static inline unsigned long long tod_duration_ns(unsigned long long from, unsigned long long to) {
+	return ((to*125)>>9)-((from*125)>>9);
+}
+
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -1665,6 +1677,7 @@
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
 	struct task_struct *p = current;
+	unsigned long long t1,t2,t3,t4;
 
 	cond_resched();
 
@@ -1675,8 +1688,12 @@
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
+	t1 = get_clock();
+
 	*did_some_progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
 
+	t2 = get_clock();
+
 	p->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
 	p->flags &= ~PF_MEMALLOC;
@@ -1686,17 +1703,28 @@
 	if (order != 0)
 		drain_all_pages();
 
+	t3 = get_clock();
 	if (likely(*did_some_progress))
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
 					migratetype);
+	t4 = get_clock();
 
 	perf_count_pages_direct_reclaim++;
 	if (!page)
 		perf_count_failed_pages_direct_reclaim++;
-	if (!page && (*did_some_progress))
+	if (!page && (*did_some_progress)) {
 		perf_count_failed_pages_direct_reclaim_but_progress++;
+		perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf += tod_duration_ns(t1,t2);
+		perf_count_direct_reclaim_slow_dursum_post_ttf_2_pre_get_page += tod_duration_ns(t2,t3);
+		perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_get_page += tod_duration_ns(t3,t4);
+	}
+	else {
+		perf_count_direct_reclaim_fast_dursum_pre_ttf_2_post_ttf += tod_duration_ns(t1,t2);
+		perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page += tod_duration_ns(t2,t3);
+		perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_get_page += tod_duration_ns(t3,t4);
+	}
 
 	return page;
 }

--------------010002040105070909020804
Content-Type: text/x-patch;
 name="perf-count-direct-reclaim-orderandprogress.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-direct-reclaim-orderandprogress.diff"

Index: linux-2.6-git/kernel/sysctl.c
===================================================================
--- linux-2.6-git.orig/kernel/sysctl.c	2010-02-16 13:38:48.000000000 +0100
+++ linux-2.6-git/kernel/sysctl.c	2010-02-16 15:07:21.000000000 +0100
@@ -267,13 +267,49 @@
 
 extern unsigned long long perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf;
 extern unsigned long long perf_count_direct_reclaim_slow_dursum_post_ttf_2_pre_get_page;
-extern unsigned long long perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_ttf;
+extern unsigned long long perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_get_page;
 extern unsigned long long perf_count_direct_reclaim_fast_dursum_pre_ttf_2_post_ttf;
 extern unsigned long long perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page;
-extern unsigned long long perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_ttf;
+extern unsigned long long perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_get_page;
+extern unsigned long perf_count_direct_reclaim_fast_sum_progress;
+extern unsigned long perf_count_direct_reclaim_slow_sum_progress;
+extern unsigned long perf_count_direct_reclaim_fast_sum_order;
+extern unsigned long perf_count_direct_reclaim_slow_sum_order;
 static struct ctl_table perf_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_slow_sum_progress",
+		.data           = &perf_count_direct_reclaim_slow_sum_progress,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_slow_sum_order",
+		.data           = &perf_count_direct_reclaim_slow_sum_order,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_fast_sum_progress",
+		.data           = &perf_count_direct_reclaim_fast_sum_progress,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_direct_reclaim_fast_sum_order",
+		.data           = &perf_count_direct_reclaim_fast_sum_order,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname       = "perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf",
 		.data           = &perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf,
 		.mode           = 0666,
Index: linux-2.6-git/mm/page_alloc.c
===================================================================
--- linux-2.6-git.orig/mm/page_alloc.c	2010-02-16 14:58:28.000000000 +0100
+++ linux-2.6-git/mm/page_alloc.c	2010-02-16 15:06:15.000000000 +0100
@@ -1663,6 +1663,11 @@
 unsigned long long perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page = 0;
 unsigned long long perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_get_page = 0;
 
+unsigned long perf_count_direct_reclaim_fast_sum_progress = 0;
+unsigned long perf_count_direct_reclaim_slow_sum_progress = 0;
+unsigned long perf_count_direct_reclaim_fast_sum_order = 0;
+unsigned long perf_count_direct_reclaim_slow_sum_order = 0;
+
 static inline unsigned long long tod_duration_ns(unsigned long long from, unsigned long long to) {
 	return ((to*125)>>9)-((from*125)>>9);
 }
@@ -1719,11 +1724,17 @@
 		perf_count_direct_reclaim_slow_dursum_pre_ttf_2_post_ttf += tod_duration_ns(t1,t2);
 		perf_count_direct_reclaim_slow_dursum_post_ttf_2_pre_get_page += tod_duration_ns(t2,t3);
 		perf_count_direct_reclaim_slow_dursum_pre_get_page_2_post_get_page += tod_duration_ns(t3,t4);
+
+		perf_count_direct_reclaim_slow_sum_progress += *did_some_progress;
+		perf_count_direct_reclaim_slow_sum_order += order;
 	}
 	else {
 		perf_count_direct_reclaim_fast_dursum_pre_ttf_2_post_ttf += tod_duration_ns(t1,t2);
 		perf_count_direct_reclaim_fast_dursum_post_ttf_2_pre_get_page += tod_duration_ns(t2,t3);
 		perf_count_direct_reclaim_fast_dursum_pre_get_page_2_post_get_page += tod_duration_ns(t3,t4);
+
+		perf_count_direct_reclaim_fast_sum_progress += *did_some_progress;
+		perf_count_direct_reclaim_fast_sum_order += order;
 	}
 
 	return page;

--------------010002040105070909020804--
