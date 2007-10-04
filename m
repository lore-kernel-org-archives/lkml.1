Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbXJDFET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbXJDFET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXJDFEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:04:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41904 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751304AbXJDFEJ (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:04:09 -0400
Date: Thu, 4 Oct 2007 15:03:44 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 5/5] writeback: introduce writeback_control.more_io to indicate more io
Message-ID: <20071004050344.GF23367404@sgi.com>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.987182999@mail.ustc.edu.cn> <20071002214736.GJ995458@sgi.com> <20071003013439.GA6501@mail.ustc.edu.cn> <20071003024119.GL23367404@sgi.com> <20071004022133.GA6244@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004022133.GA6244@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 10:21:33AM +0800, Fengguang Wu wrote:
> On Wed, Oct 03, 2007 at 12:41:19PM +1000, David Chinner wrote:
> > On Wed, Oct 03, 2007 at 09:34:39AM +0800, Fengguang Wu wrote:
> > > On Wed, Oct 03, 2007 at 07:47:45AM +1000, David Chinner wrote:
> > > > On Tue, Oct 02, 2007 at 04:41:48PM +0800, Fengguang Wu wrote:
> > > > >  		wbc.pages_skipped = 0;
> > > > > @@ -560,8 +561,9 @@ static void background_writeout(unsigned
> > > > >  		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> > > > >  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> > > > >  			/* Wrote less than expected */
> > > > > -			congestion_wait(WRITE, HZ/10);
> > > > > -			if (!wbc.encountered_congestion)
> > > > > +			if (wbc.encountered_congestion || wbc.more_io)
> > > > > +				congestion_wait(WRITE, HZ/10);
> > > > > +			else
> > > > >  				break;
> > > > >  		}
> > > > 
> > > > Why do you call congestion_wait() if there is more I/O to issue?  If
> > > > we have a fast filesystem, this might cause the device queues to
> > > > fill, then drain on congestion_wait(), then fill again, etc. i.e. we
> > > > will have trouble keeping the queues full, right?
> > > 
> > > You mean slow writers and fast RAID? That would be exactly the case
> > > these patches try to improve.
> > 
> > I mean any writers and a fast block device (raid or otherwise).
> > 
> > > This patchset makes kupdate/background writeback more responsible,
> > > so that if (avg-write-speed < device-capabilities), the dirty data are
> > > synced timely, and we don't have to go for balance_dirty_pages().
> > 
> > Sure, but I'm asking about the effect of the patches on the
> > (avg-write-speed == device-capabilities) case. I agree that
> > they are necessary for timely syncing of data but I'm trying
> > to understand what effect they have on the normal write case
> 
> > (i.e. keeping the disk at full write throughput).
> 
> OK, I guess it is the focus of all your questions: Why should we sleep
> in congestion_wait() and possibly hurt the write throughput? I'll try
> to summary it:
> 
> - congestion_wait() is necessary
> Besides device congestions, there may be other blockades we have to
> wait on, e.g. temporary page locks, NFS/journal issues(I guess).

We skip locked pages in writeback, and if some filesystems have
blocking issues that require non-blocking writeback waits for some
I/O to complete before re-entering writeback, then perhaps they should be
setting wbc->encountered_congestion to tell writeback to back off.

The question I'm asking is that if more_io tells us we have more
work to do, why do we have to sleep first if the block dev is
able to take more I/O?

> 
> - congestion_wait() is called only when necessary
> congestion_wait() will only be called we saw blockades:
>         if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
>                 congestion_wait(WRITE, HZ/10);
>         }
> So in normal case, it may well write 128MB data without any waiting.

Sure, but wbc.more_io doesn't indicate a blockade - just that there
is more work to do, right?

> - congestion_wait() won't hurt write throughput
> When not congested, congestion_wait() will be wake up on each write
> completion.

What happens if there I/O we issued has already completed before we
got back up to the congestion_wait() call? We'll spend 100ms
sleeping when we shouldn't have and throughput goes down by 10% on
every occurrence....

if we've got more work to do, then we should do it without an
arbitrary, non-deterministic delay being inserted. If the delay is
needed to prevent he system from "going mad" (whatever tht means),
then what's the explaination for the system "going mad"?

> Note that MAX_WRITEBACK_PAGES=1024 and
> /sys/block/sda/queue/max_sectors_kb=512(for me),
> which means we are gave the chance to sync 4MB on every 512KB written,
> which means we are able to submit write IOs 8 times faster than the
> device capability. congestion_wait() is a magical timer :-)

So, with Jens Axboe's sglist chaining, that single I/O could now
be up to 32MB on some hardware. IOWs, we push 1024 pages, and that
could end up as a single I/O being issued to disk.

Your magic just broke. :/

> > > So for your question of queue depth, the answer is: the queue length
> > > will not build up in the first place. 
> > 
> > Which queue are you talking about here? The block deivce queue?
> 
> Yes, the elevator's queues.

I think this is the wrong thing to be doing and is detrimental
to I/o perfomrance because it wil reduce elevator efficiency.

The elevator can only work efficiently if we allow the queues to
build up. The deeper the queue, the better the elevator can sort the
I/o requests and keep the device at maximum efficiency.  If we don't
push enough I/O into the queues the we miss opportunities to combine
adjacent I/Os and reduce the seek load of writeback. Also, a shallow
queue will run dry if we don't get back to it in time which is
possible if we wait for I/o to complete before we go and flush
more....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
