Return-Path: <linux-kernel-owner+w=401wt.eu-S939990AbXGaETb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939990AbXGaETb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbXGaETX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:19:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:59089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbXGaETW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:19:22 -0400
Date: Tue, 31 Jul 2007 06:19:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, mingo@elte.hu, ak@suse.de, jens.axboe@oracle.com,
       James.Bottomley@SteelEye.com, andrea@suse.de, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20070731041917.GA25874@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <Pine.LNX.4.64.0707301114060.743@schroedinger.engr.sgi.com> <20070730203519.GD10033@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730203519.GD10033@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 01:35:19PM -0700, Suresh B wrote:
> On Mon, Jul 30, 2007 at 11:20:04AM -0700, Christoph Lameter wrote:
> > On Fri, 27 Jul 2007, Siddha, Suresh B wrote:
> 
> > > Observation #2: This introduces some migration overhead during IO submission.
> > > With the current prototype, every incoming IO request results in an IPI and
> > > context switch(to kblockd thread) on the interrupt processing cpu.
> > > This issue needs to be addressed and main challenge to address is
> > > the efficient mechanism of doing this IO migration(how much batching to do and
> > > when to send the migrate request?), so that we don't delay the IO much and at
> > > the same point, don't cause much overhead during migration.
> > 
> > Right.
> 
> So any suggestions for making this clean and acceptable to everyone?

It is obviously a good idea to hand over the IO at the point which
requires the least number of cachelines to be moved, and I think doing
it in the block layer is right. Mostly you have to convince the block
and driver maintainers I guess.

The scheduler really should be made interrupt-load aware anyway, so I
don't have a problem with changing that; or scheduling kblockd at a
higher priority, but I don't know if SCHED_FIFO is a good idea. Couldn't
it be done in a softirq instead?

Latency for IO migration could be the most difficult problem to solve
really. You don't give much details of the workload, profiles, etc... I
hope this is for a real world test? Can the locking be improved in simpler
ways first?

Just some random questions...

It looks like the main source of cacheline bouncing you're eliminating
is from the initial starting of IO from an empty queue (ie. unplug).
>From then on, the submission is driven by completion, right?

Why is the queue allowed to go empty in the first place in an IO critical
workload?

Are you loading up each CPU with as many disks as it can possibly handle
plus a few more? If so, is that realistic? (I honestly don't know).

You say that you'd like to do this for direct IO only, but if it is more
efficient, why not for buffered IO as well? (or is it not more efficient
for buffered IO? if not, why?)

AFAIKS, you'd still have significant queue_lock contention from other
CPUs inserting requests into the list? What IO scheduler are you using?
I assume noop... as a crazy experiment, what happens if you create per-cpu
request queues?

