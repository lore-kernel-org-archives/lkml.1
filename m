Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbXHABYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbXHABYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXHABYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:24:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:55708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbXHABYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:24:24 -0400
Date: Wed, 1 Aug 2007 03:24:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, mingo@elte.hu, ak@suse.de, jens.axboe@oracle.com,
       James.Bottomley@SteelEye.com, andrea@suse.de, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20070801012421.GF31006@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <Pine.LNX.4.64.0707301114060.743@schroedinger.engr.sgi.com> <20070730203519.GD10033@linux-os.sc.intel.com> <20070731041917.GA25874@wotan.suse.de> <20070731171403.GL3318@linux-os.sc.intel.com> <20070801004117.GE31006@wotan.suse.de> <20070801005513.GE10033@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801005513.GE10033@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 05:55:13PM -0700, Suresh B wrote:
> On Wed, Aug 01, 2007 at 02:41:18AM +0200, Nick Piggin wrote:
> > On Tue, Jul 31, 2007 at 10:14:03AM -0700, Suresh B wrote:
> > > task by taking away some of its cpu time. With CFS micro accounting, perhaps
> > > we can track irq, softirq time and avoid penalizing the running task's cpu
> > > time.
> > 
> > But you "penalize" the running task in the completion handler as well
> > anyway.
> 
> Yes.
> 
> Ingo, in general with CFS micro accounting, we should be able to avoid
> penalizing the running task by tracking irq/softirq time. Isn't it?
> 
> > Doing this with a SCHED_FIFO task is sort of like doing interrupt
> > threading which AFAIK has not been accepted (yet).
> 
> I am not recommending SCHED_FIFO. I will take a look at softirq
> infrastructure for this.

I think that would be a fine way to go.


> > > This workload is using direct IO and there is no batching at the block layer
> > > for direct IO. IO is submitted to the HW as it arrives.
> > 
> > So you aren't putting concurrent requests into the queue? Sounds like
> > userspace should be improved.
> 
> Nick remember that there are hundreds of disks in this setup and at
> an instance, there will be max 1 or 2 requests per disk.

Well if there is 2 requests per disk, that's a good thing; you won't
need to unplug. If there is only 1, then as well as the plugging cost,
the hardeware loses some ability to pipeline things effectively.

I'm not saying the kernel shouldn't be improved in the latter case, but
if you're looking for performance, it is nice to ensure you have at
least 2 requests. Presumably you're using some pretty well tuned db
software though, so I guess this is not always possible.

Do you have stats for these things (queue empty vs not empty events,
unplugs, etc)? 


> > > It is applicable for both direct IO and buffered IO. But the implementations
> > > will differ. For example in buffered IO, we can setup in such a way that the
> > > block plug timeout function runs on the IO completion cpu.
> > 
> > It would be nice to be doing that anyway. But unplug via request submission
> > rather than timeout is fairly common in buffered loads too.
> 
> Ok. Currently the patch handles both direct and buffered IO. While making
> improvements to this patch I will make sure that both the paths take
> advantage of this.

Sounds good!

