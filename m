Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXITL7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXITL7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXITL64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:58:56 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58481 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXITL6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:58:55 -0400
Date: Thu, 20 Sep 2007 12:31:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
In-Reply-To: <20070919224409.24baa75b@lappy>
Message-ID: <Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <20070919164348.GC2519@shadowen.org> <Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com>
 <20070919224409.24baa75b@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Peter Zijlstra wrote:
> On Wed, 19 Sep 2007 21:03:19 +0100 (BST) Hugh Dickins
> <hugh@veritas.com> wrote:
> 
> > On Wed, 19 Sep 2007, Andy Whitcroft wrote:
> > > Seems I have a case of a largish i386 NUMA (NUMA-Q) which has a mkfs
> > > stuck in a 'D' wait:
> > > 
> > >  =======================
> > > mkfs.ext2     D c10220f4     0  6233   6222
> > >  [<c12194da>] io_schedule_timeout+0x1e/0x28
> > >  [<c10454b4>] congestion_wait+0x62/0x7a
> > >  [<c10402af>] get_dirty_limits+0x16a/0x172
> > >  [<c104040b>] balance_dirty_pages+0x154/0x1be
> > >  [<c103bda3>] generic_perform_write+0x168/0x18a
> > >  [<c103be38>] generic_file_buffered_write+0x73/0x107
> > >  [<c103c346>] __generic_file_aio_write_nolock+0x47a/0x4a5
> > >  [<c103c3b9>] generic_file_aio_write_nolock+0x48/0x9b
> > >  [<c105d2d6>] do_sync_write+0xbf/0xfc
> > >  [<c105d3a0>] vfs_write+0x8d/0x108
> > >  [<c105d4c3>] sys_write+0x41/0x67
> > >  [<c100260a>] syscall_call+0x7/0xb
> > >  =======================
> > 
> > [edited out some bogus lines from stale stack]
> > 
> > > This machine and others have run numerous test runs on this kernel and
> > > this is the first time I've see a hang like this.
> > 
> > I've been seeing something like that on 4-way PPC64: in my case I've
> > shells hanging in D state trying to append to kernel build log on ext3
> > (the builds themselves going on elsewhere, in tmpfs): one of the shells
> > holding i_mutex and stuck doing congestion_waits from balance_dirty_pages.
> > 
> > > I wonder if this is the ultimate cause of the couple of mainline hangs
> > > which were seen, but not diagnosed.
> > 
> > My *guess* is that this is peculiar to 2.6.23-rc6-mm1, and from Peter's
> > mm-per-device-dirty-threshold.patch.  printks showed bdi_nr_reclaimable
> > 0, bdi_nr_writeback 24, bdi_thresh 1 in balance_dirty_pages (though I've
> > not done enough to check if those really correlate with the hangs),
> > and I'm wondering if the bdi_stat_sum business is needed on the
> > !nr_reclaimable path.
> 
> FWIW my tired brain seems to think it the !nr_reclaimable path needs it
> just the same. So this change seems to make sense for now :-)

Thanks.

> > So I'm running now with the patch below, good so far, but can't judge
> > until tomorrow whether it has actually addressed the problem seen.

Last night's run went well: that patch does indeed seem to have fixed it.
Looking at the timings (some variance but _very_ much less than the night
before), there does appear to be some other occasional slight slowdown -
but I've no reason to suspect your patch for it, nor to suppose it's
something new: it may just be an artifact of my heavy swap thrashing.


[PATCH mm] mm per-device dirty threshold fix

Fix occasional hang when a task couldn't get out of balance_dirty_pages:
mm-per-device-dirty-threshold.patch needs to reevaluate bdi_nr_writeback
across all cpus when bdi_thresh is low, even in the case when there was
no bdi_nr_reclaimable.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 mm/page-writeback.c |   53 +++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

--- 2.6.23-rc6-mm1/mm/page-writeback.c	2007-09-18 12:28:25.000000000 +0100
+++ linux/mm/page-writeback.c	2007-09-19 20:00:46.000000000 +0100
@@ -379,7 +379,7 @@ static void balance_dirty_pages(struct a
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
-				break;
+			break;
 
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
@@ -392,39 +392,34 @@ static void balance_dirty_pages(struct a
 		 */
 		if (bdi_nr_reclaimable) {
 			writeback_inodes(&wbc);
-
+			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+		}
 
-			/*
-			 * In order to avoid the stacked BDI deadlock we need
-			 * to ensure we accurately count the 'dirty' pages when
-			 * the threshold is low.
-			 *
-			 * Otherwise it would be possible to get thresh+n pages
-			 * reported dirty, even though there are thresh-m pages
-			 * actually dirty; with m+n sitting in the percpu
-			 * deltas.
-			 */
-			if (bdi_thresh < 2*bdi_stat_error(bdi)) {
-				bdi_nr_reclaimable =
-					bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-				bdi_nr_writeback =
-					bdi_stat_sum(bdi, BDI_WRITEBACK);
-			} else {
-				bdi_nr_reclaimable =
-					bdi_stat(bdi, BDI_RECLAIMABLE);
-				bdi_nr_writeback =
-					bdi_stat(bdi, BDI_WRITEBACK);
-			}
+		/*
+		 * In order to avoid the stacked BDI deadlock we need
+		 * to ensure we accurately count the 'dirty' pages when
+		 * the threshold is low.
+		 *
+		 * Otherwise it would be possible to get thresh+n pages
+		 * reported dirty, even though there are thresh-m pages
+		 * actually dirty; with m+n sitting in the percpu
+		 * deltas.
+		 */
+		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
+			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
+			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+		} else if (bdi_nr_reclaimable) {
+			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
+			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+		}
 
-			if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
-				break;
+		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+			break;
+		if (pages_written >= write_chunk)
+			break;		/* We've done our duty */
 
-			pages_written += write_chunk - wbc.nr_to_write;
-			if (pages_written >= write_chunk)
-				break;		/* We've done our duty */
-		}
 		congestion_wait(WRITE, HZ/10);
 	}
 
