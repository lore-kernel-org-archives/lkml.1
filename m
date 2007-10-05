Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbXJEHle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbXJEHle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 03:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXJEHlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 03:41:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37701 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751734AbXJEHlY (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 03:41:24 -0400
Date: Fri, 5 Oct 2007 17:41:03 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 5/5] writeback: introduce writeback_control.more_io to indicate more io
Message-ID: <20071005074103.GM23367404@sgi.com>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.987182999@mail.ustc.edu.cn> <20071002214736.GJ995458@sgi.com> <20071003013439.GA6501@mail.ustc.edu.cn> <20071003024119.GL23367404@sgi.com> <20071004022133.GA6244@mail.ustc.edu.cn> <20071004050344.GF23367404@sgi.com> <20071005033652.GA6448@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005033652.GA6448@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 11:36:52AM +0800, Fengguang Wu wrote:
> On Thu, Oct 04, 2007 at 03:03:44PM +1000, David Chinner wrote:
> > On Thu, Oct 04, 2007 at 10:21:33AM +0800, Fengguang Wu wrote:
> > > OK, I guess it is the focus of all your questions: Why should we sleep
> > > in congestion_wait() and possibly hurt the write throughput? I'll try
> > > to summary it:
> > > 
> > > - congestion_wait() is necessary
> > > Besides device congestions, there may be other blockades we have to
> > > wait on, e.g. temporary page locks, NFS/journal issues(I guess).
> > 
> > We skip locked pages in writeback, and if some filesystems have
> > blocking issues that require non-blocking writeback waits for some
> > I/O to complete before re-entering writeback, then perhaps they should be
> > setting wbc->encountered_congestion to tell writeback to back off.
> 
> We have wbc->pages_skipped for that :-)

I walked right into that one ;)

> if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {    /* all-written or blockade... */
>         if (wbc.encountered_congestion || wbc.more_io) /* blockade! */
>                 congestion_wait(WRITE, HZ/10);
>         else                                           /* all-written! */
>                 break;
> }

>From this, if we have more_io on one superblock and we skip pages on a
different superblock, the combination of the two will causes us to stop
writeback for a while. Is this the right thing to do?

> We can also read the whole background_writeout() logic as
> 
> while (!done) {
>         /* sync _all_ sync-able data */
>         congestion_wait(100ms);
> }

To me it reads as:

	while (!done) {
		/* sync all data or until one inode skips */
		congestion_wait(up to 100ms);
	}

and it ignores that we might have more superblocks with dirty data
on them that we haven't flushed because we skipped pages on
an inode on a different block device.


> Note that it's far from "wait 100ms for every 4MB" (which is merely
> the worst possible case).

If that's the worst case, then it's far better than the current
"wait 30s for every 4MB".  ;)

Still, if it can be improved....

> > > - congestion_wait() won't hurt write throughput
> > > When not congested, congestion_wait() will be wake up on each write
> > > completion.
> > 
> > What happens if the I/O we issued has already completed before we
> > got back up to the congestion_wait() call? We'll spend 100ms
> > sleeping when we shouldn't have and throughput goes down by 10% on
> > every occurrence....
> 
> Ah, that was out of my imagination. Maybe we could do with
> 
>         if (wbc.more_io)
>                 congestion_wait(WRITE, 1);
> 
> It's at least 10 times better.

And probably good enough to make it unnoticable.

> "going mad" means "busy waiting".

Ah, ok. that I understand ;)

> > > > > So for your question of queue depth, the answer is: the queue length
> > > > > will not build up in the first place. 
> > > > 
> > > > Which queue are you talking about here? The block deivce queue?
> > > 
> > > Yes, the elevator's queues.
> > 
> > I think this is the wrong thing to be doing and is detrimental
> > to I/o perfomrance because it wil reduce elevator efficiency.
> > 
> > The elevator can only work efficiently if we allow the queues to
> > build up. The deeper the queue, the better the elevator can sort the
> > I/o requests and keep the device at maximum efficiency.  If we don't
> > push enough I/O into the queues the we miss opportunities to combine
> > adjacent I/Os and reduce the seek load of writeback. Also, a shallow
> > queue will run dry if we don't get back to it in time which is
> > possible if we wait for I/o to complete before we go and flush
> > more....
> 
> Sure, the queues should be filled as fast as possible.
> How fast can we fill the queue? Let's measure it:
> 
> //generated by the patch below
> 
> [  871.430700] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 54289 global 29911 0 0 wc _M tw -12 sk 0
> [  871.444718] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 53253 global 28857 0 0 wc _M tw -12 sk 0
> [  871.458764] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 52217 global 27834 0 0 wc _M tw -12 sk 0
> [  871.472797] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 51181 global 26780 0 0 wc _M tw -12 sk 0
> [  871.486825] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 50145 global 25757 0 0 wc _M tw -12 sk 0
> [  871.500857] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 49109 global 24734 0 0 wc _M tw -12 sk 0
> [  871.514864] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 48073 global 23680 0 0 wc _M tw -12 sk 0
> [  871.528889] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 47037 global 22657 0 0 wc _M tw -12 sk 0
> [  871.542894] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 46001 global 21603 0 0 wc _M tw -12 sk 0
> [  871.556927] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 44965 global 20580 0 0 wc _M tw -12 sk 0
> [  871.570961] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 43929 global 19557 0 0 wc _M tw -12 sk 0
> [  871.584992] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 42893 global 18503 0 0 wc _M tw -12 sk 0
> [  871.599005] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 41857 global 17480 0 0 wc _M tw -12 sk 0
> [  871.613027] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 40821 global 16426 0 0 wc _M tw -12 sk 0
> [  871.628626] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 39785 global 15403 961 0 wc _M tw -12 sk 0
> [  871.644439] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 38749 global 14380 1550 0 wc _M tw -12 sk 0
> [  871.660267] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 37713 global 13326 2573 0 wc _M tw -12 sk 0
> [  871.676236] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 36677 global 12303 3224 0 wc _M tw -12 sk 0
> [  871.692021] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 35641 global 11280 4154 0 wc _M tw -12 sk 0
> [  871.707824] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 34605 global 10226 4929 0 wc _M tw -12 sk 0
> [  871.723638] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 33569 global 9203 5735 0 wc _M tw -12 sk 0
> [  871.739708] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 32533 global 8149 6603 0 wc _M tw -12 sk 0
> [  871.756407] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 31497 global 7126 7409 0 wc _M tw -12 sk 0
> [  871.772165] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 30461 global 6103 8246 0 wc _M tw -12 sk 0
> [  871.788035] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 29425 global 5049 9052 0 wc _M tw -12 sk 0
> [  871.803896] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 28389 global 4026 9982 0 wc _M tw -12 sk 0
> [  871.820427] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 27353 global 2972 10757 0 wc _M tw -12 sk 0
> [  871.836728] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 26317 global 1949 11656 0 wc _M tw -12 sk 0
> [  871.853286] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 25281 global 895 12431 0 wc _M tw -12 sk 0
> [  871.868762] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 24245 global 58 13051 0 wc __ tw 168 sk 0
> 
> It's an Intel Core 2 2.93GHz CPU and a SATA disk.
> The trace shows that
> - there's no congestion_wait() called in wb_kupdate()
> - it takes wb_kupdate() ~15ms to sync every 4MB 

But it takes a modern SATA disk ~40-50ms to write 4MB (80-100MB/s).
IOWs, what you've timed above is a burst workload, not a steady
state behaviour. And it actually shows that the elevator queues
are growing in constrast to your goal of preventing them from
growing.

In more detail, the first half of the trace indicates no pages under
writeback, that tends to imply that all I/O is complete by the
time wb_kupdate is woken - it's been sucked into the drive
cache as fast as possible.

About half way through we start to see windup of the the number of
pages under writeback of about 800-900 pages per printk.  That's
1024 pages minus 1 or 2 512k I/Os. This implies that the disk cache
is now full and the disk has reached saturation. I/O is now
being queued in the elevator. The last trace has 13051 pages under
writeback, which at 128 pages per I/O is ~100 queued 512k I/Os.

The default queue depth with cfq is 128 requests, and IIRC it
congests at 7/8s full, or 112 requests. IOWs, you file that you
wrote was about 10MB short of what is needed to see congestion on
your test rig.

So the trace shows we slept on neither congestion or more_io
and it points towards congestion being the thing will typically
block us on large file I/O. Before drawing any conclusions on
whether wbc.more_io is needed or not, do you have any way of
producing skipped pages when more_io is set?

> However, wb_kupdate() is syncing the data a bit slow(4*1000/15=266MB/s),
> could it be because of a lot of cond_resched()?

You are using ext3? That would be my guess based simply on the write
rate - ext3 has long been stuck at about that speed for buffered
writes even on much faster block devices.  If I'm right, try using
XFS and see how much differently it behaves. I bet you hit
congestion much sooner than you expect. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
