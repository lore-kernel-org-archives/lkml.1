Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbXHAAlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbXHAAlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXHAAlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:41:22 -0400
Received: from mail.suse.de ([195.135.220.2]:54495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbXHAAlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:41:21 -0400
Date: Wed, 1 Aug 2007 02:41:18 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, mingo@elte.hu, ak@suse.de, jens.axboe@oracle.com,
       James.Bottomley@SteelEye.com, andrea@suse.de, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20070801004117.GE31006@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <Pine.LNX.4.64.0707301114060.743@schroedinger.engr.sgi.com> <20070730203519.GD10033@linux-os.sc.intel.com> <20070731041917.GA25874@wotan.suse.de> <20070731171403.GL3318@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731171403.GL3318@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 10:14:03AM -0700, Suresh B wrote:
> On Tue, Jul 31, 2007 at 06:19:17AM +0200, Nick Piggin wrote:
> > On Mon, Jul 30, 2007 at 01:35:19PM -0700, Suresh B wrote:
> > > So any suggestions for making this clean and acceptable to everyone?
> > 
> > It is obviously a good idea to hand over the IO at the point which
> > requires the least number of cachelines to be moved, and I think doing
> > it in the block layer is right. Mostly you have to convince the block
> > and driver maintainers I guess.
> 
> Yes. Implementation is the challenging part I guess.
> 
> > The scheduler really should be made interrupt-load aware anyway, so I
> > don't have a problem with changing that; or scheduling kblockd at a
> > higher priority, but I don't know if SCHED_FIFO is a good idea. Couldn't
> > it be done in a softirq instead?
> 
> Yes, softirq context is one way. But just didn't want to penalize the running
> task by taking away some of its cpu time. With CFS micro accounting, perhaps
> we can track irq, softirq time and avoid penalizing the running task's cpu
> time.

But you "penalize" the running task in the completion handler as well
anyway. Doing this with a SCHED_FIFO task is sort of like doing interrupt
threading which AFAIK has not been accepted (yet).


> > Latency for IO migration could be the most difficult problem to solve
> > really. You don't give much details of the workload, profiles, etc... I
> > hope this is for a real world test?
> 
> Improvement numbers quoted are from the OLTP database workload. We can look
> into other workloads.
> 
> > Can the locking be improved in simpler ways first?
> > 
> > Just some random questions...
> > 
> > It looks like the main source of cacheline bouncing you're eliminating
> > is from the initial starting of IO from an empty queue (ie. unplug).
> > From then on, the submission is driven by completion, right?
> > 
> > Why is the queue allowed to go empty in the first place in an IO critical
> > workload?
> 
> This workload is using direct IO and there is no batching at the block layer
> for direct IO. IO is submitted to the HW as it arrives.

So you aren't putting concurrent requests into the queue? Sounds like
userspace should be improved.


> > Are you loading up each CPU with as many disks as it can possibly handle
> > plus a few more? If so, is that realistic? (I honestly don't know).
> 
> There is 3-4% iowait time in the system. So the cpu's are not 100% busy,
> but there is quite a bit of direct IO going on.
> 
> > You say that you'd like to do this for direct IO only, but if it is more
> > efficient, why not for buffered IO as well? (or is it not more efficient
> > for buffered IO? if not, why?)
> 
> It is applicable for both direct IO and buffered IO. But the implementations
> will differ. For example in buffered IO, we can setup in such a way that the
> block plug timeout function runs on the IO completion cpu.

It would be nice to be doing that anyway. But unplug via request submission
rather than timeout is fairly common in buffered loads too.


> > AFAIKS, you'd still have significant queue_lock contention from other
> > CPUs inserting requests into the list?
> 
> Correct. We have more potential to explore. Current implementation
> is very elementary.
> 
> > What IO scheduler are you using? I assume noop...
> 
> yes.
> 
> > as a crazy experiment, what happens if you create per-cpu request queues?
> 
> or in other words, each kblockd thread catering multiple request queues
> (perhaps one for each cpu or one for group of cpu's).
> 
> softirq context and each kblockd thread handling multiple request queues will
> lead to further improvements.
