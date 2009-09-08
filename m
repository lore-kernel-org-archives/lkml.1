Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbZIHSga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbZIHSga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZIHSg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:36:29 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:55367 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZIHSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:36:28 -0400
Date: Tue, 8 Sep 2009 14:35:26 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090908183526.GI2975@think>
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
 <1252432501.7746.156.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252432501.7746.156.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AA6A3F1.0195:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 07:55:01PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 19:46 +0200, Peter Zijlstra wrote:
> > On Tue, 2009-09-08 at 13:28 -0400, Chris Mason wrote:
> > > > Right, so what can we do to make it useful? I think the intent is to
> > > > limit the number of pages in writeback and provide some progress
> > > > feedback to the vm.
> > > > 
> > > > Going by your experience we're failing there.
> > > 
> > > Well, congestion_wait is a stop sign but not a queue.  So, if you're
> > > being nice and honoring congestion but another process (say O_DIRECT
> > > random writes) doesn't, then you back off forever and none of your IO
> > > gets done.
> > > 
> > > To get around this, you can add code to make sure that you do
> > > _some_ io, but this isn't enough for your work to get done
> > > quickly, and you do end up waiting in get_request() so the async
> > > benefits of using the congestion test go away.
> > > 
> > > If we changed everyone to honor congestion, we end up with a poll model
> > > because a ton of congestion_wait() callers create a thundering herd.
> > > 
> > > So, we could add a queue, and then congestion_wait() would look a lot
> > > like get_request_wait().  I'd rather that everyone just used
> > > get_request_wait, and then have us fix any latency problems in the
> > > elevator.
> > 
> > Except you'd need to lift it to the BDI layer, because not all backing
> > devices are a block device.
> > 
> > Making it into a per-bdi queue sounds good to me though.
> > 
> > > For me, perfect would be one or more threads per-bdi doing the
> > > writeback, and never checking for congestion (like what Jens' code
> > > does).  The congestion_wait inside balance_dirty_pages() is really just
> > > a schedule_timeout(), on a fully loaded box the congestion doesn't go
> > > away anyway.  We should switch that to a saner system of waiting for
> > > progress on the bdi writeback + dirty thresholds.
> > 
> > Right, one of the things we could possibly do is tie into
> > __bdi_writeout_inc() and test levels there once every so often and then
> > flip a bit when we're low enough to stop writing.
> 
> I think I'm somewhat confused here though..
> 
> There's kernel threads doing writeout, and there's apps getting stuck in
> balance_dirty_pages().
> 
> If we want all writeout to be done by kernel threads (bdi/pd-flush like
> things) then we still need to manage the actual apps and delay them.
> 
> As things stand now, we kick pdflush into action when dirty levels are
> above the background level, and start writing out from the app task when
> we hit the full dirty level.
> 
> Moving all writeout to a kernel thread sounds good from writing linear
> stuff pov, but what do we make apps wait on then?

I suppose we could come up with the perfect queuing system where procs
got in line and came out as the bdi became less busy.  The problem is
that schedule_timeout(HZ/10) isn't really a great idea because HZ/10
might be much much too long for fast devices.

congestion_wait() isn't a great idea because the block device might stay
congested long after we've crossed below the threshold.

If there was a flag on the bdi that got cleared as things improved, we
could wait on that.

Otherwise, schedule_timeout() with increasing timeout values per
iteration and a poll on the thresholds isn't too far from what we have
now.

-chris

