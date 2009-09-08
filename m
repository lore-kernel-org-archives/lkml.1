Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZIHRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZIHRqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZIHRqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:46:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZIHRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:46:24 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090908172842.GC2975@think>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
	 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
	 <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins>
	 <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins>
	 <20090908172842.GC2975@think>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Sep 2009 19:46:14 +0200
Message-Id: <1252431974.7746.151.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 13:28 -0400, Chris Mason wrote:
> > Right, so what can we do to make it useful? I think the intent is to
> > limit the number of pages in writeback and provide some progress
> > feedback to the vm.
> > 
> > Going by your experience we're failing there.
> 
> Well, congestion_wait is a stop sign but not a queue.  So, if you're
> being nice and honoring congestion but another process (say O_DIRECT
> random writes) doesn't, then you back off forever and none of your IO
> gets done.
> 
> To get around this, you can add code to make sure that you do
> _some_ io, but this isn't enough for your work to get done
> quickly, and you do end up waiting in get_request() so the async
> benefits of using the congestion test go away.
> 
> If we changed everyone to honor congestion, we end up with a poll model
> because a ton of congestion_wait() callers create a thundering herd.
> 
> So, we could add a queue, and then congestion_wait() would look a lot
> like get_request_wait().  I'd rather that everyone just used
> get_request_wait, and then have us fix any latency problems in the
> elevator.

Except you'd need to lift it to the BDI layer, because not all backing
devices are a block device.

Making it into a per-bdi queue sounds good to me though.

> For me, perfect would be one or more threads per-bdi doing the
> writeback, and never checking for congestion (like what Jens' code
> does).  The congestion_wait inside balance_dirty_pages() is really just
> a schedule_timeout(), on a fully loaded box the congestion doesn't go
> away anyway.  We should switch that to a saner system of waiting for
> progress on the bdi writeback + dirty thresholds.

Right, one of the things we could possibly do is tie into
__bdi_writeout_inc() and test levels there once every so often and then
flip a bit when we're low enough to stop writing.

> Btrfs would love to be able to send down a bio non-blocking.  That would
> let me get rid of the congestion check I have today (I think Jens said
> that would be an easy change and then I talked him into some small mods
> of the writeback path).

Wont that land us into trouble because the amount of writeback will
become unwieldy?

> > > > Now, suppose it were to do something useful, I'd think we'd want to
> > > > limit write-out to whatever it takes so saturate the BDI.
> > > 
> > > If we don't want a blanket increase, 
> > 
> > The thing is, this sysctl seems an utter cop out, we can't even explain
> > how to calculate a number that'll work for a situation, the best we can
> > do is say, prod at it and pray -- that's not good.
> > 
> > Last time I also asked if an increased number is good for every
> > situation, I have a machine with a RAID5 array and USB storage, will it
> > harm either situation?
> 
> If the goal is to make sure that pdflush or balance_dirty_pages only
> does IO until some condition is met, we should add a flag to the bdi
> that gets set when that condition is met.  Things will go a lot more
> smoothly than magic numbers.

Agreed - and from what I can make out, that really is the only goal
here.

> Then we can add the fs_hint as another change so the FS can tell
> write_cache_pages callers how to do optimal IO based on its allocation
> decisions.

I think you lost me here, but I think you mean to provide some FS
specific feedback to the generic write page routines -- whatever
works ;-)
