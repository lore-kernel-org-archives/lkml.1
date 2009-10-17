Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbZJQFa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbZJQFa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 01:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbZJQFa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 01:30:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:26997 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZJQFa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 01:30:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,577,1249282800"; 
   d="scan'208";a="200069200"
Date: Sat, 17 Oct 2009 13:30:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091017053016.GA20086@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <20091010213339.GA8644@localhost> <20091012211838.GA3965@duck.suse.cz> <20091013032405.GA20405@localhost> <20091013181214.GA31440@duck.suse.cz> <1255458499.8967.711.camel@laptop> <20091014013832.GA11882@localhost> <1255519348.8392.412.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255519348.8392.412.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 07:22:28PM +0800, Peter Zijlstra wrote:
> On Wed, 2009-10-14 at 09:38 +0800, Wu Fengguang wrote:
> > > >   Hmm, probably you've discussed this in some other email but why do we
> > > > cycle in this loop until we get below dirty limit? We used to leave the
> > > > loop after writing write_chunk... So the time we spend in
> > > > balance_dirty_pages() is no longer limited, right?
> > 
> > Right, this is a legitimate concern.
> 
> Quite.
> 
> > > Wu was saying that without the loop nr_writeback wasn't limited, but
> > > since bdi_writeback_wakeup() is driven from writeout completion, I'm not
> > > sure how again that was so.
> > 
> > Let me summarize the ideas :)
> > 
> > There are two cases:
> > 
> > - there are no bdi or block io queue to limit nr_writeback
> >   This must be fixed. It either let nr_writeback grow to dirty_thresh
> >   (with loop) and thus squeeze nr_dirty, or grow out of control
> >   totally (without loop). Current state is, the nr_writeback wait
> >   queue for NFS is there; the one for btrfs is still missing.
> > 
> > - there is a nr_writeback limit, but is larger than dirty_thresh
> >   In this case nr_dirty will be close to 0 regardless of the loop.
> >   The loop will help to keep
> >           nr_dirty + nr_writeback + nr_unstable < dirty_thresh
> >   Without the loop, the "real" dirty threshold would be larger
> >   (determined by the nr_writeback limit).
> > 
> > > We can move all of bdi_dirty to bdi_writeout, if the bdi writeout queue
> > > permits, but it cannot grow beyond the total limit, since we're actually
> > > waiting for writeout completion.
> > 
> > Yes, this explains the second case. It's some trade-off like: the
> > nr_writeback limit can not be trusted in small memory systems, so do
> > the loop to impose the dirty_thresh, which unfortunately can hurt
> > responsiveness on all systems with prolonged wait time..
> 
> Ok, so I'm still puzzled.

Big sorry - it's me that was confused (by some buggy tests).

>   set_page_dirty()
>   balance_dirty_pages_ratelimited()
>     balance_dirty_pages_ratelimited_nr(1)
>       balance_dirty_pages(nr);
> 
> So we call balance_dirty_pages() with an appropriate count for each
> set_page_dirty() successful invocation, right?

Right.

> balance_dirty_pages() guarantees that:
> 
>   nr_dirty + nr_writeback + nr_unstable < dirty_thresh &&
>   (nr_dirty + nr_writeback + nr_unstable < 
> 	(dirty_thresh + background_thresh)/2 ||
>    bdi_dirty + bdi_writeback + bdi_unstable < bdi_thresh)
> 
> Now without loop, without writeback limit, I still see no way to
> actually generate more 'dirty' pages than dirty_thresh.
>
> As soon as we hit dirty_thresh a process will wait for exactly the same
> amount of pages to get cleaned (writeback completed) as were dirtied
> (+/- the ratelimit fuzz which should even out over processes).

Ah yes, we now wait for writeback _completed_ in bdi_writeback_wait(),
instead of _start_ writeback in the old fashioned writeback_inodes().

> That should bound things to dirty_thresh -- the wait is on writeback
> complete, so nr_writeback is bounded too.

Right. It was not bounded in the tests because bdi_writeback_wait()
quits _prematurely_, because the background writeback finds it was
already under background threshold, and so wakeup the throttled tasks
and then quit. Fixed by simply removing the wakeup-all in background
writeback and this change:

                if (args->for_background && !over_bground_thresh() &&
+                   list_empty(&wb->bdi->throttle_list))
                        break;

So now
- the throttled tasks are guaranteed to be wakeup
- it will only be wakeup in __bdi_writeout_inc()
- once wakeup, at least write_chunk pages have been written on behalf of it

> [ I forgot the exact semantics of unstable, if we clear writeback before
> unstable, we need to fix something ]

New tests show that NFS is working fine without loop and without NFS
nr_writeback limit:

      $ dd if=/dev/zero of=/mnt/test/zero3 bs=1M count=200 &
      $ vmmon -d 1 nr_writeback nr_dirty nr_unstable

     nr_writeback         nr_dirty      nr_unstable
                0                2                0
                0                2                0
                0            22477               65
                2            20849             1697
                2            19153             3393
                2            17420             5126
            27825                7             5979
            27816                0               41
            26925                0              907
            31064              286              159
            32531                0              213
            32548                0               89
            32405                0              155
            32464                0               98
            32517                0               45
            32560                0              194
            32534                0              220
            32601                0              222
            32490                0               72
            32447                0              115
            32511                0               48
            32535                0              216
            32535                0              216
            32535                0              216
            32535                0              216
            31555                0             1180
            29732                0             3003
            29277                0             3458
            27721                0             5014
            25955                0             6780
            24356                0             8379
            22763                0             9972
            21083                0            11652
            19371                0            13364
            17564                0            15171
            15781                0            16954
            14005                0            18730
            12230                0            20505
            12177                0            20558
            11383                0            21352
             9489                0            23246
             7621                0            25115
             5866                0            26870
             4790                0            27947
             2962                0            29773
             1089                0            31646
                0                0            32735
                0                0            32735
                0                0                0
                0                0                0
 
> Now, a nr_writeback queue that limits writeback will still be useful,
> esp for high speed devices. Once they ramp up and bdi_thresh exceeds the
> queue size, it'll take effect. So you reap the benefits when needed.

Right, the nr_writeback limit avoids

        nr_writeback => dirty_thresh
+
        nr_dirty + nr_writeback < dirty_thresh
=>
        nr_dirty => 0

Thanks for the clarification, it looks less obscure now :)

Thanks,
Fengguang
