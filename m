Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYHVJGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYHVJGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYHVJGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:06:25 -0400
Received: from [93.163.65.50] ([93.163.65.50]:18637 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYHVJGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:06:23 -0400
Date: Fri, 22 Aug 2008 11:06:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: fix queue depth detection
Message-ID: <20080822090620.GY20055@kernel.dk>
References: <48AE5FE2.2060003@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AE5FE2.2060003@gelato.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22 2008, Aaron Carroll wrote:
> Hi Jens,
> 
> This patch fixes a bug in the hw_tag detection logic causing a huge 
> performance
> hit under certain workloads on real queuing devices.  For example, an FIO 
> load
> of 16k direct random reads on an 8-disk hardware RAID yields about 2 MiB/s 
> on
> default CFQ, while noop achieves over 20 MiB/s.
> 
> While the solution is pretty ugly, it does have the advantage of adapting to
> queue depth changes.  Such a situation might occur if the queue depth is
> configured in userspace late in the boot process.

I don't think it's that ugly, and I prefer this logic to the existing
one in fact. Since it's a static property of the device, why did you
change it to toggle the flag back and forth instead of just setting it
once? Defaulting to tagging on is fine, otherwise we risk running into
the problem you describe where CFQ never attempts to queue > 1 request.
Then you'd want to see if the driver ever asks more requests while one
is in the driver, if it does it's definitely TCQ. If not, then it
doesn't do queueing. So the interesting window is the one where we have
more requests pending yet the driver doesn't ask for it. I'd prefer a
patch that took that more into account, instead of just looking at the
past 50 samples and then toggle the hw_tag flag depending on the
behaviour in that time frame. You could easily have a depth of 1 there
always if it's a sync workload, even if hardware can do tagged queuing.

-- 
Jens Axboe

