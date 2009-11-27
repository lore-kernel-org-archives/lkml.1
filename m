Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbZK0Lsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbZK0Lsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZK0Lsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:48:42 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58691 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZK0Lsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:48:41 -0500
Date: Fri, 27 Nov 2009 12:48:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       mel@csn.ul.ie, efault@gmx.de
Subject: Re: [RFC,PATCH] cfq-iosched: improve async queue ramp up formula
Message-ID: <20091127114847.GZ8742@kernel.dk>
References: <200911261710.40719.czoccolo@gmail.com> <20091127082316.GY8742@kernel.dk> <4e5e476b0911270103u61ed5a95t3997e28ae79bac82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911270103u61ed5a95t3997e28ae79bac82@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27 2009, Corrado Zoccolo wrote:
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
> 
> I think the numbers by Mel show that this idea can give better and
> more stable timings, and they were just with a single NCQ rotational
> disk. I wonder how much improvement we can get on a raid, where
> keeping the depth at 1 hits performance really hard.
> Probably, waiting until memory reclaiming is noticeably active (since
> in CFQ we will be sampling) may be too late.

I'm not saying it's a no-go, just that it invalidates the low latency
testing done through the 2.6.32 cycle and we should re-run those tests
before committing and submitting anything.

If the 'check for reclaim' hack isn't good enough, then that's probably
what we have to do.

-- 
Jens Axboe

