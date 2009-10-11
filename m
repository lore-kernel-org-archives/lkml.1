Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZJKKvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZJKKvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZJKKvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:51:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:7638 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352AbZJKKvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:51:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,541,1249282800"; 
   d="scan'208";a="197615364"
Date: Sun, 11 Oct 2009 18:50:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <20091011105012.GB10409@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <1255101512.8802.65.camel@laptop> <20091009154759.GJ7654@duck.suse.cz> <20091011022813.GA21315@localhost> <1255247080.11081.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1255247080.11081.3.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 03:44:40PM +0800, Peter Zijlstra wrote:
> On Sun, 2009-10-11 at 10:28 +0800, Wu Fengguang wrote:
> > 
> > Note that the total limit check itself may not be sufficient. For
> > example, there are no nr_writeback limit for NFS (and maybe btrfs)
> > after removing the congestion waits.  Therefore it is very possible
> > 
> >         nr_writeback => dirty_thresh
> >         nr_dirty     => 0
> > 
> > which is obviously undesirable: everything newly dirtied are soon put
> > to writeback. It violates the 30s expire time and the background
> > threshold rules, and will hurt write-and-truncate operations (ie. temp
> > files).
> > 
> > So the better solution would be to impose a nr_writeback limit for
> > every filesystem that didn't already have one (the block io queue).
> > NFS used to have that limit with congestion_wait, but now we need
> > to do a wait queue for it.
> > 
> > With the nr_writeback wait queue, it can be guaranteed that once
> > balance_dirty_pages() asks for writing 1500 pages, it will be done
> > with necessary sleeping in the bdi flush thread. So we can safely
> > remove the loop and double checking of global dirty limit in
> > balance_dirty_pages().
> 
> nr_reclaim = nr_dirty + nr_writeback + nr_unstable, so anything calling
> into balance_dirty_pages() would still block on seeing such large
> amounts of nr_writeback.

Our terms are a bit different. In my previous mail,
        nr_reclaim = nr_dirty + nr_unstable
nr_writeback is added separated when comparing with dirty_thresh, just
as the code in balance_dirty_pages().

But that's fine. You are right that the application will be blocked
and dirty limit be guaranteed, if we do
        while (over dirty limit) {
                bdi_writeback_wait(pages to write);
        }

But it has a problem: as long as the bdi-flush thread for NFS don't
limit nr_writeback, its nr_writeback will grow to near
(dirty_thresh-nr_unstable), and its nr_dirty will approach 0.
That's not desirable.

So I did this:
-       while (over dirty limit) {
+       if (over dirty limit) {
                bdi_writeback_wait(pages to write);
        }
_after_ adding the NFS nr_writeback wait queue ([PATCH 20/45] NFS:
introduce writeback wait queue). With that it's safe to remove the
loop.

> Having the constraint nr_dirty + nr_writeback + nr_unstable <
> dirty_thresh should ensure we never have nr_writeback > dirty_thresh,
> simply because you cannot dirty more, which then cannot be converted to
> more writeback.
> 
> Or am I missing something?

You are right with the assumption that the loop is still there.

Sorry for the confusion, but I mean, filesystems have to limit
nr_writeback (directly or indirectly via the block io queue),
otherwise it either hit nr_dirty to 0 (with the loop), or let
nr_writeback grow out of control (without the loop).

Thanks,
Fengguang
