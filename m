Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZIWKbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZIWKbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZIWKbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:31:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:56956 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZIWKbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:31:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190700559"
Date: Wed, 23 Sep 2009 18:30:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>
Subject: Re: regression in page writeback
Message-ID: <20090923103055.GA15291@localhost>
References: <20090922155259.GL10825@think> <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <1253697598.2277.13.camel@castor> <1253697811.7695.127.camel@twins> <20090923093753.GA4579@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923093753.GA4579@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 05:37:53PM +0800, Wu Fengguang wrote:
> On Wed, Sep 23, 2009 at 05:23:31PM +0800, Peter Zijlstra wrote:
> > On Wed, 2009-09-23 at 10:19 +0100, Richard Kennedy wrote:
> > > 
> > > I am concerned that the background writeout no longer stops when it
> > > reaches the background threshold, as balance_dirty_pages requests all
> > > dirty pages to be written. No doubt this is good for large linear writes
> > > but what about more random write workloads? 
> > 
> > I've not had time to look over the current code, but write-out not
> > stopping on reaching background threshold is a definite bug and needs to
> > get fixed.
> 
> Yes, 2.6.31 code stops writeback when background threshold is reached.
> But new behavior in latest git is to writeback all pages.
> 
> The code only checks over_bground_thresh() for kupdate works:
> 
>                 if (args->for_kupdate && args->nr_pages <= 0 &&
>                     !over_bground_thresh())
>                         break;
> 
> However the background work started by balance_dirty_pages() won't check
> over_bground_thresh(). So it will move all dirty pages.
> 
> I think it's very weird to check over_bground_thresh() for kupdate
> instead of background work. Jens must intended for the latter case.

Here is the patch to fix it. Tested to work OK. This is an RFC.

Thanks,
Fengguang
---
writeback: stop background writeback when below background threshold

Treat bdi_start_writeback(0) as a special request to do background write,
and stop such work when we are below the background dirty threshold.

Also simplify the (nr_pages <= 0) checks. Since we already pass in
nr_pages=LONG_MAX for WB_SYNC_ALL and background writes, we don't
need to worry about it being decreased to zero.

Reported-by: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Jan Kara <jack@suse.cz>
CC: Jens Axboe <jens.axboe@oracle.com> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c   |   28 +++++++++++++++++-----------
 mm/page-writeback.c |    6 +++---
 2 files changed, 20 insertions(+), 14 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-23 17:47:23.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-23 18:13:36.000000000 +0800
@@ -41,8 +41,9 @@ struct wb_writeback_args {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
-	int for_kupdate;
-	int range_cyclic;
+	int for_kupdate:1;
+	int range_cyclic:1;
+	int for_background:1;
 };
 
 /*
@@ -260,6 +261,15 @@ void bdi_start_writeback(struct backing_
 		.range_cyclic	= 1,
 	};
 
+	/*
+	 * We treat @nr_pages=0 as the special case to do background writeback,
+	 * ie. to sync pages until the background dirty threshold is reached.
+	 */
+	if (!nr_pages) {
+		args.nr_pages = LONG_MAX;
+		args.for_background = 1;
+	}
+
 	bdi_alloc_queue_work(bdi, &args);
 }
 
@@ -723,20 +733,16 @@ static long wb_writeback(struct bdi_writ
 
 	for (;;) {
 		/*
-		 * Don't flush anything for non-integrity writeback where
-		 * no nr_pages was given
+		 * Stop writeback when nr_pages has been consumed
 		 */
-		if (!args->for_kupdate && args->nr_pages <= 0 &&
-		     args->sync_mode == WB_SYNC_NONE)
+		if (args->nr_pages <= 0)
 			break;
 
 		/*
-		 * If no specific pages were given and this is just a
-		 * periodic background writeout and we are below the
-		 * background dirty threshold, don't do anything
+		 * For background writeout, stop when we are below the
+		 * background dirty threshold
 		 */
-		if (args->for_kupdate && args->nr_pages <= 0 &&
-		    !over_bground_thresh())
+		if (args->for_background && !over_bground_thresh())
 			break;
 
 		wbc.more_io = 0;
--- linux.orig/mm/page-writeback.c	2009-09-23 17:45:58.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-23 17:47:17.000000000 +0800
@@ -589,10 +589,10 @@ static void balance_dirty_pages(struct a
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && ((nr_writeback = global_page_state(NR_FILE_DIRTY)
-					  + global_page_state(NR_UNSTABLE_NFS))
+	    (!laptop_mode && ((global_page_state(NR_FILE_DIRTY)
+			       + global_page_state(NR_UNSTABLE_NFS))
 					  > background_thresh)))
-		bdi_start_writeback(bdi, nr_writeback);
+		bdi_start_writeback(bdi, 0);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
