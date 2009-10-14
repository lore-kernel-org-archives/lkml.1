Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZJNLXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZJNLXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbZJNLXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:23:36 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:17191 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670AbZJNLXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:23:35 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Staubach <staubach@redhat.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091014013832.GA11882@localhost>
References: <20091007073818.318088777@intel.com>
	 <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz>
	 <20091010213339.GA8644@localhost> <20091012211838.GA3965@duck.suse.cz>
	 <20091013032405.GA20405@localhost> <20091013181214.GA31440@duck.suse.cz>
	 <1255458499.8967.711.camel@laptop>  <20091014013832.GA11882@localhost>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 13:22:28 +0200
Message-Id: <1255519348.8392.412.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 09:38 +0800, Wu Fengguang wrote:
> > >   Hmm, probably you've discussed this in some other email but why do we
> > > cycle in this loop until we get below dirty limit? We used to leave the
> > > loop after writing write_chunk... So the time we spend in
> > > balance_dirty_pages() is no longer limited, right?
> 
> Right, this is a legitimate concern.

Quite.

> > Wu was saying that without the loop nr_writeback wasn't limited, but
> > since bdi_writeback_wakeup() is driven from writeout completion, I'm not
> > sure how again that was so.
> 
> Let me summarize the ideas :)
> 
> There are two cases:
> 
> - there are no bdi or block io queue to limit nr_writeback
>   This must be fixed. It either let nr_writeback grow to dirty_thresh
>   (with loop) and thus squeeze nr_dirty, or grow out of control
>   totally (without loop). Current state is, the nr_writeback wait
>   queue for NFS is there; the one for btrfs is still missing.
> 
> - there is a nr_writeback limit, but is larger than dirty_thresh
>   In this case nr_dirty will be close to 0 regardless of the loop.
>   The loop will help to keep
>           nr_dirty + nr_writeback + nr_unstable < dirty_thresh
>   Without the loop, the "real" dirty threshold would be larger
>   (determined by the nr_writeback limit).
> 
> > We can move all of bdi_dirty to bdi_writeout, if the bdi writeout queue
> > permits, but it cannot grow beyond the total limit, since we're actually
> > waiting for writeout completion.
> 
> Yes, this explains the second case. It's some trade-off like: the
> nr_writeback limit can not be trusted in small memory systems, so do
> the loop to impose the dirty_thresh, which unfortunately can hurt
> responsiveness on all systems with prolonged wait time..

Ok, so I'm still puzzled.

  set_page_dirty()
  balance_dirty_pages_ratelimited()
    balance_dirty_pages_ratelimited_nr(1)
      balance_dirty_pages(nr);

So we call balance_dirty_pages() with an appropriate count for each
set_page_dirty() successful invocation, right?

balance_dirty_pages() guarantees that:

  nr_dirty + nr_writeback + nr_unstable < dirty_thresh &&
  (nr_dirty + nr_writeback + nr_unstable < 
	(dirty_thresh + background_thresh)/2 ||
   bdi_dirty + bdi_writeback + bdi_unstable < bdi_thresh)

Now without loop, without writeback limit, I still see no way to
actually generate more 'dirty' pages than dirty_thresh.

As soon as we hit dirty_thresh a process will wait for exactly the same
amount of pages to get cleaned (writeback completed) as were dirtied
(+/- the ratelimit fuzz which should even out over processes).

That should bound things to dirty_thresh -- the wait is on writeback
complete, so nr_writeback is bounded too.

[ I forgot the exact semantics of unstable, if we clear writeback before
unstable, we need to fix something ]

Now, a nr_writeback queue that limits writeback will still be useful,
esp for high speed devices. Once they ramp up and bdi_thresh exceeds the
queue size, it'll take effect. So you reap the benefits when needed.

