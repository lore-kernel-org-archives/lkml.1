Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbYCWFmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbYCWFmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 01:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYCWFmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 01:42:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbYCWFmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 01:42:44 -0400
Date: Sat, 22 Mar 2008 22:41:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, rjw@sisk.pl
Subject: Re: 103 sec. latency: sync_page() with TASK_UNINTERRUPTIBLE (?)
 (bisected)
Message-Id: <20080322224143.0e2901cd.akpm@linux-foundation.org>
In-Reply-To: <20080323034725.GA3781@localhost.ift.unesp.br>
References: <20080322220134.GA4559@localhost.ift.unesp.br>
	<20080323034725.GA3781@localhost.ift.unesp.br>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2008 00:47:25 -0300 "Carlos R. Mafra" <crmafra2@gmail.com> wrote:

> > Cause                                                Maximum     Percentage
> > sync_page __lock_page handle_mm_fault do_page_faul103659.0 msec         59.8 %
> > get_request_wait __make_request generic_make_reque1992.0 msec         10.2 %
> > get_request_wait __make_request generic_make_reque1620.7 msec          4.6 %
> > sync_page __lock_page find_lock_page filemap_fault399.3 msec          3.4 %
> > sync_buffer __wait_on_buffer __bread ext3_get_bran292.9 msec          1.3 %
> > sync_page __lock_page handle_mm_fault do_page_faul200.5 msec          0.3 %
> > Scheduler: waiting for cpu                        155.9 msec         18.9 %
> > sync_page __lock_page handle_mm_fault do_page_faul117.5 msec          0.1 %
> > congestion_wait try_to_free_pages __alloc_pages re103.5 msec          0.2 %
> > r_code
> > 
> > 
> > Process X (2910)
> > sync_page __lock_page handle_mm_fault do_page_faul103659.0 msec         98.5 %
> > Scheduler: waiting for cpu                         64.6 msec          1.3 %
> > sync_page __lock_page find_lock_page filemap_fault 51.4 msec          0.2 %lt do_page_fault error_code
> > sync_buffer __wait_on_buffer __bread ext3_get_bran 17.8 msec          0.0 % ext3_get_block do_mpage_readpage mpage_readpa
> > sync_page __lock_page handle_mm_fault do_page_faul  9.1 msec          0.0 %ig ault
> > 
> > The experience goes like this:
> > 
> > 1) Boot with 2.6.25-rc6-00243-g028011e
> > 2) Log into X 
> > 3) Open a 380MB file with xjed
> > 
> > It takes more than 6 minutes to load the file, and meanwhile
> > I experience very bad desktop interactivity (like 1 minute to
> > the result of pressing F12 in Window Maker to appear in the
> > screen).
> > 
> > If, after step 2), I start using firefox, thunderbird, play some
> > music etc and then close all these apps and go to step 3),
> > the loading finishes in about 2 minutes (and I have very
> > good interactivity meanwhile).
> > 
> > So I noticed that when xjed is opening the file it is in
> > 'D' state (reported by ps), and while greping the kernel
> > source code for 'sync_page' I've found this comment 
> > in mm/filemap.c:
> > 
> > /**
> >  * __lock_page - get a lock on the page, assuming we need to sleep to get it
> >  * @page: the page to lock
> >  *
> >  * Ugly. Running sync_page() in state TASK_UNINTERRUPTIBLE is scary.  If some
> >  * random driver's requestfn sets TASK_RUNNING, we could busywait.  However
> >  * chances are that on the second loop, the block layer's plug list is empty,
> >  * so sync_page() will then return in state TASK_UNINTERRUPTIBLE.
> >  */
> > 
> > "Ugly. Running sync_page() in state TASK_UNINTERRUPTIBLE is scary."
> > 
> > It appears that my problem with xjed in 'D' state while loading,
> > and sync_page() appearing in latencytop with 103 secs of latency
> > may be related through the "ugliness" described above.
> > 
> > So I was wondering if there is a way to fix this. Note that 
> > this issue does not happen if I load the file after using the
> > computer for a while, so it is not impossible to have good
> > interactivity while loading that big file.
> 
> 
> After lots of tests, it turned out to be a regression from
> 2.6.24.
> 
> I bisected it down to f1a9ee758de7de1e040de849fdef46e6802ea117
> ("kswapd should only wait on IO if there is IO").
> 
> If a revert the above commit from the latest git kernel
> (v2.6.25-rc6-243-g028011e), then I get an very good interactivity
> while xjed is loading the 380MB file (meaning that I can do other things
> during the load). Otherwise it takes almost 3 times longer to load,
> and interactivity is very bad in the meanwhile. I doubled checked it.
> 
> I hope this information will be useful, and I can try any patches
> if necessary.
> 

Thanks, I queued the below reversion.  It would be great if you could
confirm that this patch does indeed make 2.6.25-rc6 work as well as 2.6.24.

From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit f1a9ee758de7de1e040de849fdef46e6802ea117
Author: Rik van Riel <riel@redhat.com>
Date:   Thu Feb 7 00:14:08 2008 -0800

    kswapd should only wait on IO if there is IO
    
    The current kswapd (and try_to_free_pages) code has an oddity where the
    code will wait on IO, even if there is no IO in flight.  This problem is
    notable especially when the system scans through many unfreeable pages,
    causing unnecessary stalls in the VM.
    
    Additionally, tasks without __GFP_FS or __GFP_IO in the direct reclaim path
    will sleep if a significant number of pages are encountered that should be
    written out.  This gives kswapd a chance to write out those pages, while
    the direct reclaim task sleeps.
    
    Signed-off-by: Rik van Riel <riel@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Because of large latencies and interactivity problems reported by Carlos,
here: http://lkml.org/lkml/2008/3/22/211

Cc: Rik van Riel <riel@redhat.com>
Cc: "Carlos R.  Mafra" <crmafra2@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff -puN mm/vmscan.c~revert-kswapd-should-only-wait-on-io-if-there-is-io mm/vmscan.c
--- a/mm/vmscan.c~revert-kswapd-should-only-wait-on-io-if-there-is-io
+++ a/mm/vmscan.c
@@ -70,13 +70,6 @@ struct scan_control {
 
 	int order;
 
-	/*
-	 * Pages that have (or should have) IO pending.  If we run into
-	 * a lot of these, we're better off waiting a little for IO to
-	 * finish rather than scanning more pages in the VM.
-	 */
-	int nr_io_pages;
-
 	/* Which cgroup do we reclaim from */
 	struct mem_cgroup *mem_cgroup;
 
@@ -512,10 +505,8 @@ static unsigned long shrink_page_list(st
 			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
-			else {
-				sc->nr_io_pages++;
+			else
 				goto keep_locked;
-			}
 		}
 
 		referenced = page_referenced(page, 1, sc->mem_cgroup);
@@ -554,10 +545,8 @@ static unsigned long shrink_page_list(st
 		if (PageDirty(page)) {
 			if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
 				goto keep_locked;
-			if (!may_enter_fs) {
-				sc->nr_io_pages++;
+			if (!may_enter_fs)
 				goto keep_locked;
-			}
 			if (!sc->may_writepage)
 				goto keep_locked;
 
@@ -568,10 +557,8 @@ static unsigned long shrink_page_list(st
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
-				if (PageWriteback(page) || PageDirty(page)) {
-					sc->nr_io_pages++;
+				if (PageWriteback(page) || PageDirty(page))
 					goto keep;
-				}
 				/*
 				 * A synchronous write - probably a ramdisk.  Go
 				 * ahead and try to reclaim the page.
@@ -1344,7 +1331,6 @@ static unsigned long do_try_to_free_page
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
-		sc->nr_io_pages = 0;
 		if (!priority)
 			disable_swap_token();
 		nr_reclaimed += shrink_zones(priority, zones, sc);
@@ -1379,8 +1365,7 @@ static unsigned long do_try_to_free_page
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc->nr_scanned && priority < DEF_PRIORITY - 2 &&
-				sc->nr_io_pages > sc->swap_cluster_max)
+		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
@@ -1514,7 +1499,6 @@ loop_again:
 		if (!priority)
 			disable_swap_token();
 
-		sc.nr_io_pages = 0;
 		all_zones_ok = 1;
 
 		/*
@@ -1607,8 +1591,7 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2 &&
-					sc.nr_io_pages > sc.swap_cluster_max)
+		if (total_scanned && priority < DEF_PRIORITY - 2)
 			congestion_wait(WRITE, HZ/10);
 
 		/*
_

