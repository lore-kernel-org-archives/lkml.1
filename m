Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZJNBjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZJNBjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZJNBjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:39:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:46292 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZJNBjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:39:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,554,1249282800"; 
   d="scan'208";a="198639863"
Date: Wed, 14 Oct 2009 09:38:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Staubach <staubach@redhat.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091014013832.GA11882@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <20091010213339.GA8644@localhost> <20091012211838.GA3965@duck.suse.cz> <20091013032405.GA20405@localhost> <20091013181214.GA31440@duck.suse.cz> <1255458499.8967.711.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255458499.8967.711.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 02:28:19AM +0800, Peter Zijlstra wrote:
> On Tue, 2009-10-13 at 20:12 +0200, Jan Kara wrote:
> > >       for (;;) {
> > >               nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> > >                                global_page_state(NR_UNSTABLE_NFS);
> > >               nr_writeback = global_page_state(NR_WRITEBACK) +
> > >                              global_page_state(NR_WRITEBACK_TEMP);
> > > 
> > >               global_dirty_thresh(&background_thresh, &dirty_thresh);
> > > 
> > >               /*
> > >                * Throttle it only when the background writeback cannot
> > >                * catch-up. This avoids (excessively) small writeouts
> > >                * when the bdi limits are ramping up.
> > >                */
> > >               if (nr_reclaimable + nr_writeback <
> > >                   (background_thresh + dirty_thresh) / 2)
> > >                       break;
> > > 
> > >               bdi_thresh = bdi_dirty_thresh(bdi, dirty_thresh);
> > > 
> > >               /*
> > >                * In order to avoid the stacked BDI deadlock we need
> > >                * to ensure we accurately count the 'dirty' pages when
> > >                * the threshold is low.
> > >                *
> > >                * Otherwise it would be possible to get thresh+n pages
> > >                * reported dirty, even though there are thresh-m pages
> > >                * actually dirty; with m+n sitting in the percpu
> > >                * deltas.
> > >                */
> > >               if (bdi_thresh < 2*bdi_stat_error(bdi)) {
> > >                       bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
> > >                       bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
> > >               } else {
> > >                       bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> > >                       bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> > >               }
> > > 
> > >               /*
> > >                * The bdi thresh is somehow "soft" limit derived from the
> > >                * global "hard" limit. The former helps to prevent heavy IO
> > >                * bdi or process from holding back light ones; The latter is
> > >                * the last resort safeguard.
> > >                */
> > >               dirty_exceeded =
> > >                       (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
> > >                       || (nr_reclaimable + nr_writeback >= dirty_thresh);
> > > 
> > >               if (!dirty_exceeded)
> > >                       break;
> > > 
> > >               bdi->dirty_exceed_time = jiffies;
> > > 
> > >               bdi_writeback_wait(bdi, write_chunk);
> >   Hmm, probably you've discussed this in some other email but why do we
> > cycle in this loop until we get below dirty limit? We used to leave the
> > loop after writing write_chunk... So the time we spend in
> > balance_dirty_pages() is no longer limited, right?

Right, this is a legitimate concern.

> Wu was saying that without the loop nr_writeback wasn't limited, but
> since bdi_writeback_wakeup() is driven from writeout completion, I'm not
> sure how again that was so.

Let me summarize the ideas :)

There are two cases:

- there are no bdi or block io queue to limit nr_writeback
  This must be fixed. It either let nr_writeback grow to dirty_thresh
  (with loop) and thus squeeze nr_dirty, or grow out of control
  totally (without loop). Current state is, the nr_writeback wait
  queue for NFS is there; the one for btrfs is still missing.

- there is a nr_writeback limit, but is larger than dirty_thresh
  In this case nr_dirty will be close to 0 regardless of the loop.
  The loop will help to keep
          nr_dirty + nr_writeback + nr_unstable < dirty_thresh
  Without the loop, the "real" dirty threshold would be larger
  (determined by the nr_writeback limit).

> We can move all of bdi_dirty to bdi_writeout, if the bdi writeout queue
> permits, but it cannot grow beyond the total limit, since we're actually
> waiting for writeout completion.

Yes, this explains the second case. It's some trade-off like: the
nr_writeback limit can not be trusted in small memory systems, so do
the loop to impose the dirty_thresh, which unfortunately can hurt
responsiveness on all systems with prolonged wait time..

We could possibly test (nr_dirty < nr_writeback). If so, the
nr_writeback limit could be too large to deserve the loop.

It still don't address the nr_dirty=0 problem for small memory system,
that should be acceptable since its nr_dirty will be small anyway.

> Possibly unstable is peculiar.

unstable can also go wild. I saw (in current linux-next with the
following patch) balance_dirty_pages() sleeping for >30s waiting for
the NFS nr_unstable to drop. That is, waiting for the dirty inode to
be _expired_ and written to disk on the server.

It's a general uncoordinated double caching problem for NFS (and maybe more).

Thanks,
Fengguang
---

[   45.614799] balance_dirty_pages sleeped 228ms
[   45.954821] balance_dirty_pages sleeped 324ms
[   46.294874] balance_dirty_pages sleeped 324ms
[   46.638810] balance_dirty_pages sleeped 328ms
[   46.670769] balance_dirty_pages sleeped 28ms
[   46.802779] balance_dirty_pages sleeped 128ms
[   46.934788] balance_dirty_pages sleeped 124ms
[   47.066778] balance_dirty_pages sleeped 124ms
[   47.198774] balance_dirty_pages sleeped 128ms
[   47.330763] balance_dirty_pages sleeped 124ms
[   47.462768] balance_dirty_pages sleeped 128ms
[   47.594768] balance_dirty_pages sleeped 124ms
[   47.662763] balance_dirty_pages sleeped 60ms
[   47.798781] balance_dirty_pages sleeped 132ms
[   47.871435] balance_dirty_pages sleeped 64ms
[   48.002749] balance_dirty_pages sleeped 124ms
[   48.138787] balance_dirty_pages sleeped 132ms
[   48.270824] balance_dirty_pages sleeped 124ms
[   48.410762] balance_dirty_pages sleeped 128ms
[   48.542758] balance_dirty_pages sleeped 128ms
[   48.678786] balance_dirty_pages sleeped 132ms
[   48.810781] balance_dirty_pages sleeped 124ms
[   48.946755] balance_dirty_pages sleeped 124ms
[   49.182753] balance_dirty_pages sleeped 228ms
[   49.318773] balance_dirty_pages sleeped 128ms
[   49.666784] balance_dirty_pages sleeped 324ms
[   49.914774] balance_dirty_pages sleeped 228ms
[   79.998354] balance_dirty_pages sleeped 30068ms
[   80.062346] balance_dirty_pages sleeped 60ms
[   80.290414] balance_dirty_pages sleeped 224ms
[   80.542413] balance_dirty_pages sleeped 228ms
[   80.782384] balance_dirty_pages sleeped 228ms
[   81.142379] balance_dirty_pages sleeped 336ms
[  116.005926] balance_dirty_pages sleeped 34852ms
[  141.049584] balance_dirty_pages sleeped 25040ms


Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux.orig/mm/page-writeback.c	2009-10-09 10:22:58.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-09 10:31:53.000000000 +0800
@@ -490,6 +490,7 @@ static void balance_dirty_pages(struct a
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long pause = 1;
+	unsigned long start = jiffies;
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
@@ -566,7 +567,8 @@ static void balance_dirty_pages(struct a
 		if (pages_written >= write_chunk)
 			break;		/* We've done our duty */
 
-		schedule_timeout_interruptible(pause);
+		__set_current_state(TASK_INTERRUPTIBLE);
+		io_schedule_timeout(pause);
 
 		/*
 		 * Increase the delay for each loop, up to our previous
@@ -577,6 +579,9 @@ static void balance_dirty_pages(struct a
 			pause = HZ / 10;
 	}
 
+	if (pause > 1)
+		printk("balance_dirty_pages sleeped %lums\n", (jiffies - start) * 1000/HZ);
+
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
 			bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
