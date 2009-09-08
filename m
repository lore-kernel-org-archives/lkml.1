Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbZIHR6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbZIHR6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZIHR6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:58:54 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:31277 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZIHR6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:58:53 -0400
Date: Tue, 8 Sep 2009 13:57:56 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090908175756.GG2975@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz,
	Theodore Ts'o <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
 <4AA633FD.3080006@gmail.com>
 <1252425983.7746.120.camel@twins>
 <20090908162936.GA2975@think>
 <1252428983.7746.140.camel@twins>
 <20090908172842.GC2975@think>
 <1252431974.7746.151.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252431974.7746.151.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AA69B28.0035:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 07:46:14PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 13:28 -0400, Chris Mason wrote:
> > > Right, so what can we do to make it useful? I think the intent is to
> > > limit the number of pages in writeback and provide some progress
> > > feedback to the vm.
> > > 
> > > Going by your experience we're failing there.
> > 
> > Well, congestion_wait is a stop sign but not a queue.  So, if you're
> > being nice and honoring congestion but another process (say O_DIRECT
> > random writes) doesn't, then you back off forever and none of your IO
> > gets done.
> > 
> > To get around this, you can add code to make sure that you do
> > _some_ io, but this isn't enough for your work to get done
> > quickly, and you do end up waiting in get_request() so the async
> > benefits of using the congestion test go away.
> > 
> > If we changed everyone to honor congestion, we end up with a poll model
> > because a ton of congestion_wait() callers create a thundering herd.
> > 
> > So, we could add a queue, and then congestion_wait() would look a lot
> > like get_request_wait().  I'd rather that everyone just used
> > get_request_wait, and then have us fix any latency problems in the
> > elevator.
> 
> Except you'd need to lift it to the BDI layer, because not all backing
> devices are a block device.
> 
> Making it into a per-bdi queue sounds good to me though.
> 
> > For me, perfect would be one or more threads per-bdi doing the
> > writeback, and never checking for congestion (like what Jens' code
> > does).  The congestion_wait inside balance_dirty_pages() is really just
> > a schedule_timeout(), on a fully loaded box the congestion doesn't go
> > away anyway.  We should switch that to a saner system of waiting for
> > progress on the bdi writeback + dirty thresholds.
> 
> Right, one of the things we could possibly do is tie into
> __bdi_writeout_inc() and test levels there once every so often and then
> flip a bit when we're low enough to stop writing.
> 
> > Btrfs would love to be able to send down a bio non-blocking.  That would
> > let me get rid of the congestion check I have today (I think Jens said
> > that would be an easy change and then I talked him into some small mods
> > of the writeback path).
> 
> Wont that land us into trouble because the amount of writeback will
> become unwieldy?

The btrfs usage is a little different.  I've got a pile of bios all
setup and ready for submission, and I'm trying to send them down to N
devices from one thread.  So, if a given submit_bio call is going to
block, I'd rather move on to another device.

This is really what pdflush is using congestion for too, the difference
is that I've already got the bios made.

> 
> > > > > Now, suppose it were to do something useful, I'd think we'd want to
> > > > > limit write-out to whatever it takes so saturate the BDI.
> > > > 
> > > > If we don't want a blanket increase, 
> > > 
> > > The thing is, this sysctl seems an utter cop out, we can't even explain
> > > how to calculate a number that'll work for a situation, the best we can
> > > do is say, prod at it and pray -- that's not good.
> > > 
> > > Last time I also asked if an increased number is good for every
> > > situation, I have a machine with a RAID5 array and USB storage, will it
> > > harm either situation?
> > 
> > If the goal is to make sure that pdflush or balance_dirty_pages only
> > does IO until some condition is met, we should add a flag to the bdi
> > that gets set when that condition is met.  Things will go a lot more
> > smoothly than magic numbers.
> 
> Agreed - and from what I can make out, that really is the only goal
> here.
> 
> > Then we can add the fs_hint as another change so the FS can tell
> > write_cache_pages callers how to do optimal IO based on its allocation
> > decisions.
> 
> I think you lost me here, but I think you mean to provide some FS
> specific feedback to the generic write page routines -- whatever
> works ;-)

Going back to the streaming writer case, pretend the FS just created a
nice fat 256MB extent out of dealloc pages, but after we wrote the first
4k, we dropped below the dirty threshold and IO is no longer "required".

It would be silly to just write 4k.  We know we have a contiguous
area 256MB long on disk and 256MB of dirty pages.  In this case, pdflush
(or Jens' bdi threads) want to write some large portion of that 256MB.

You might argue a balance_dirty_pages callers wants to return quickly,
but even then we'd want to write at least 128k.

-chris

