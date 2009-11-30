Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZK3RHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZK3RHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZK3RHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:07:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZK3RHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:07:22 -0500
Date: Mon, 30 Nov 2009 12:06:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, mel@csn.ul.ie, efault@gmx.de
Subject: Re: [RFC,PATCH] cfq-iosched: improve async queue ramp up formula
Message-ID: <20091130170657.GG11670@redhat.com>
References: <200911261710.40719.czoccolo@gmail.com> <20091127082316.GY8742@kernel.dk> <4e5e476b0911270103u61ed5a95t3997e28ae79bac82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911270103u61ed5a95t3997e28ae79bac82@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 10:03:35AM +0100, Corrado Zoccolo wrote:
> Hi Jens,
> let me explain why my improved formula should work better.
> 
> The original problem was that, even if an async queue had a slice of 40ms,
> it could take much more to complete since it could have up to 31
> requests dispatched at the moment of expiry.
> In total, it could take up to 40 + 16 * 8 = 168 ms (worst case) to
> complete all dispatched requests, if they were seeky (I'm taking 8ms
> average service time of a seeky request).
> 
> With your patch, within the first 200ms from last sync, the max depth
> will be 1, so a slice will take at most 48ms.
> My patch still ensures that a slice will take at most 48ms within the
> first 200ms from last sync, but lifts the restriction that depth will
> be 1 at all time.
> In fact, after the first 100ms, a new async slice will start allowing
> 5 requests (async_slice/slice_idle). Then, whenever a request
> completes, we compute remaining_slice / slice_idle, and compare this
> with the number of dispatched requests. If it is greater, it means we
> were lucky, and the requests were sequential, so we can allow more
> requests to be dispatched. The number of requests dispatched will
> decrease when reaching the end of the slice, and at the end we will
> allow only depth 1.
> For next 100ms, you will allow just depth 2, and my patch will allow
> depth 2 at the end of the slice (but larger at the beginning), and so
> on.

Got a query. Here assumption is that async queues are not being preempted.
So driving shallower queue depths at the end of slice will help in terms
of max latencies and driving deeper queue depths at the beginning of slice
will help in getting more out of disk, without increasing max latencies.

But if we allow deeper queue depths at the beginning of the async slice,
and then async queue is preempted, then we are back to the old problem of
first request taking more time to complete.

But I guess that problem will be less severe this time as for sync-noidle
workload we will idle. So ideally we will experience the higher delays
only for first request and not on subsequent request. Previously, we did
not enable idling on random seeky queues and after one dispatch from the
queue, we will again run async queue and there was high delay after every
read request. This is assuming if upon preemption, we started running
sync-noidle workload and did not continue to dispatch from async workload.

Corrodo, you can clear up the air here. What's the policy w.r.t to
preemption of async queues and workload slice.

Thanks
Vivek

> 
> I think the numbers by Mel show that this idea can give better and
> more stable timings, and they were just with a single NCQ rotational
> disk. I wonder how much improvement we can get on a raid, where
> keeping the depth at 1 hits performance really hard.
> Probably, waiting until memory reclaiming is noticeably active (since
> in CFQ we will be sampling) may be too late.
> 
> Thanks,
> Corrado
> 
> On Fri, Nov 27, 2009 at 9:23 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Nov 26 2009, Corrado Zoccolo wrote:
> >> The introduction of ramp-up formula for async queue depths has
> >> slowed down dirty page reclaim, by reducing async write performance.
> >> This patch improves the formula by considering the remaining slice.
> >>
> >> The new formula will allow more dispatches at the beginning of the
> >> slice, reducing them at the end.
> >> This will ensure that we achieve good throughput, without the risk of
> >> overrunning the allotted timeslice.
> >>
> >> The threshold is automatically increased when sync I/O is not
> >> intermingled with async, in accordance with the previous incarnation of
> >> the formula.
> >
> > The slow ramp up is pretty much essential to being able to have low
> > latency for the sync reads, so I'm afraid this will break that. I would
> > prefer doing it through memory reclaim detection, like the other patch
> > you and Motohiro suggested.
> >
> > --
> > Jens Axboe
> >
> >
> 
> 
> 
> -- 
> __________________________________________________________________________
> 
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------
> The self-confidence of a warrior is not the self-confidence of the average
> man. The average man seeks certainty in the eyes of the onlooker and calls
> that self-confidence. The warrior seeks impeccability in his own eyes and
> calls that humbleness.
>                                Tales of Power - C. Castaneda
