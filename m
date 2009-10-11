Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZJKC3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZJKC3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 22:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZJKC3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 22:29:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:44955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842AbZJKC3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 22:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,540,1249282800"; 
   d="scan'208";a="197533272"
Date: Sun, 11 Oct 2009 10:28:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091011022813.GA21315@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <1255101512.8802.65.camel@laptop> <20091009154759.GJ7654@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009154759.GJ7654@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:47:59PM +0800, Jan Kara wrote:
> On Fri 09-10-09 17:18:32, Peter Zijlstra wrote:
> > On Fri, 2009-10-09 at 17:12 +0200, Jan Kara wrote:
> > >   Ugh, but this is not equivalent! We would block the writer on some BDI
> > > without any dirty data if we are over global dirty limit. That didn't
> > > happen before.
> > 
> > It should have, we should throttle everything calling
> > balance_dirty_pages() when we're over the total limit.
>   OK :) I agree it's reasonable. But Wu, please note this in the
> changelog because it might be a substantial change for some loads.

Thanks, I added the note by Peter :)

Note that the total limit check itself may not be sufficient. For
example, there are no nr_writeback limit for NFS (and maybe btrfs)
after removing the congestion waits.  Therefore it is very possible

        nr_writeback => dirty_thresh
        nr_dirty     => 0

which is obviously undesirable: everything newly dirtied are soon put
to writeback. It violates the 30s expire time and the background
threshold rules, and will hurt write-and-truncate operations (ie. temp
files).

So the better solution would be to impose a nr_writeback limit for
every filesystem that didn't already have one (the block io queue).
NFS used to have that limit with congestion_wait, but now we need
to do a wait queue for it.

With the nr_writeback wait queue, it can be guaranteed that once
balance_dirty_pages() asks for writing 1500 pages, it will be done
with necessary sleeping in the bdi flush thread. So we can safely
remove the loop and double checking of global dirty limit in
balance_dirty_pages().


However, there is still one problem - there are no general
coordinations between max nr_writeback and the background/dirty
limits.

It is possible (and very likely for some small memory systems) that

	nr_writeback > dirty_thresh - background_thresh
	10,000         20,000         15,000

In this case, it is possible that an application to be throttled because
of
	nr_reclaimable + nr_writeback > dirty_thresh
	12,000           10,000         20,000

starts a background writeback work to do job for it, however that work
quits immediately because

	nr_reclaimable < background_thresh
	12,000           15,000

In the end, the application did not get throttled at all at dirty_thresh.
Instead, it will be throttled at (background_thresh + max_nr_writeback).

One solution (aka. the old behavior) is to respect the dirty_thresh, by
not quiting background writeback when there are throttled tasks (this
patch). It has the drawback of background writeback not doing its job
_actively_. Instead, it will frequently be started and quit at times
when applications enter and leave balanced_dirty_pages().

In the above scheme, the background_thresh is disregarded. The other
ways would be to disregard dirty_thresh (may be undesirable) or to
limit max_nr_writeback (not as easy).

It is still very possible to hit nr_dirty all the way down to 0 if
max_nr_writeback > background_thresh.

This is a bit twisting. Any ideas?

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-10-11 09:19:49.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-11 09:21:50.000000000 +0800
@@ -781,7 +781,8 @@ static long wb_writeback(struct bdi_writ
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
-		if (args->for_background && !over_bground_thresh())
+		if (args->for_background && !over_bground_thresh() &&
+		    !list_empty(&wb->bdi->throttle_list))
 			break;
 
 		wbc.more_io = 0;
