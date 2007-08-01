Return-Path: <linux-kernel-owner+w=401wt.eu-S1761211AbXHABB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211AbXHABB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXHABBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:01:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:50772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXHABBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:01:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,206,1183359600"; 
   d="scan'208";a="257113541"
Date: Tue, 31 Jul 2007 17:55:13 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, mingo@elte.hu, ak@suse.de, jens.axboe@oracle.com,
       James.Bottomley@SteelEye.com, andrea@suse.de, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20070801005513.GE10033@linux-os.sc.intel.com>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <Pine.LNX.4.64.0707301114060.743@schroedinger.engr.sgi.com> <20070730203519.GD10033@linux-os.sc.intel.com> <20070731041917.GA25874@wotan.suse.de> <20070731171403.GL3318@linux-os.sc.intel.com> <20070801004117.GE31006@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801004117.GE31006@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 02:41:18AM +0200, Nick Piggin wrote:
> On Tue, Jul 31, 2007 at 10:14:03AM -0700, Suresh B wrote:
> > Yes, softirq context is one way. But just didn't want to penalize the running
> > task by taking away some of its cpu time. With CFS micro accounting, perhaps
> > we can track irq, softirq time and avoid penalizing the running task's cpu
> > time.
> 
> But you "penalize" the running task in the completion handler as well
> anyway.

Yes.

Ingo, in general with CFS micro accounting, we should be able to avoid
penalizing the running task by tracking irq/softirq time. Isn't it?

> Doing this with a SCHED_FIFO task is sort of like doing interrupt
> threading which AFAIK has not been accepted (yet).

I am not recommending SCHED_FIFO. I will take a look at softirq
infrastructure for this.

> > This workload is using direct IO and there is no batching at the block layer
> > for direct IO. IO is submitted to the HW as it arrives.
> 
> So you aren't putting concurrent requests into the queue? Sounds like
> userspace should be improved.

Nick remember that there are hundreds of disks in this setup and at
an instance, there will be max 1 or 2 requests per disk.

> > It is applicable for both direct IO and buffered IO. But the implementations
> > will differ. For example in buffered IO, we can setup in such a way that the
> > block plug timeout function runs on the IO completion cpu.
> 
> It would be nice to be doing that anyway. But unplug via request submission
> rather than timeout is fairly common in buffered loads too.

Ok. Currently the patch handles both direct and buffered IO. While making
improvements to this patch I will make sure that both the paths take
advantage of this.

thanks,
suresh
