Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYGANEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYGANEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYGANCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:02:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44365 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757564AbYGANCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:02:44 -0400
Date: Tue, 1 Jul 2008 08:02:40 -0500
From: Robin Holt <holt@sgi.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dean Nelson <dcn@sgi.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Delayed interrupt work, thread pools
Message-ID: <20080701130240.GD10511@sgi.com>
References: <1214916335.20711.141.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214916335.20711.141.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Dean Nelson to this discussion.  I don't think he actively
follows lkml.  We do something similar to this in xpc by managing our
own pool of threads.  I know he has talked about this type thing in the
past.

Thanks,
Robin


On Tue, Jul 01, 2008 at 10:45:35PM +1000, Benjamin Herrenschmidt wrote:
> Here's something that's been running in the back of my mind for some
> time that could be a good topic of discussion at KS.
> 
> In various areas (I'll come up with some examples later), kernel code
> such as drivers want to defer some processing to "task level", for
> various reasons such as locking (taking mutexes), memory allocation,
> interrupt latency, or simply doing things that may take more time than
> is reasonable to do at interrupt time or do things that may block.
> 
> Currently, the main mechanism we provide to do that is workqueues. They
> somewhat solve the problem, but at the same time, somewhat can make it
> worse.
> 
> The problem is that delaying a potentially long/sleeping task to a work
> queue will have the effect of delaying everything else waiting on that
> work queue.
> 
> The ability to have per-cpu work queues helps in areas where the problem
> scope is mostly per-cpu, but doesn't necessarily cover the case where
> the problem scope depends on the driver's activity, not necessarily tied
> to one CPU.
> 
> Let's take some examples: The main one (which triggers my email) is
> spufs, ie, the management of the SPU "co-processors" on the cell
> processor, though the same thing mostly applies to any similar
> co-processor architecture that would require the need to service page
> faults to access user memory.
> 
> In this case, various contexts running on the device may want to service
> long operations (ie. handle_mm_fault in this case), but using the main
> work queue or even a dedicated per-cpu one will cause a context to
> potentially hog other contexts or other drivers trying to do the same
> while the first one is blocked in the page fault code waiting for IOs...
> 
> The basic interface that such drivers want it still about the same as
> workqueues tho: "call that function at task level as soon as possible".
> 
> Thus the idea of turning workqueues into some kind of pool of threads. 
> 
> At a given point in time, if none are available (idle) and work stacks
> up, the kernel can allocate a new bunch and dispatch more work. Of
> course, we would have to find tune what the actual algorithm is to
> decide whether to allocate new threads or just wait / throttle for
> current delayed work to complete. But I believe the basic premise still
> stand.
> 
> So what about we allocate a "pool" of task structs, initially blocked,
> ready to service jobs dispatched from interrupt time, with some
> mechanism, possibly based on the existing base work queue, that can
> allocate more if too much work stacks up or (via some scheduler
> feedback) too many of the current ones are blocked (ie. waiting for IOs
> for example).
> 
> For the specific SPU management issue we've been thinking about, we
> could just implement an ad-hoc mechanism locally, but it occurs to me
> that maybe this is a more generic problem and thus some kind of
> extension to workqueues would be a good idea here.
> 
> Any comments ?
> 
> Cheers,
> Ben.
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
