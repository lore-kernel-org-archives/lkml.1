Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYHVLDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYHVLDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 07:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYHVLDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 07:03:21 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:55230 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346AbYHVLDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 07:03:20 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 22 Aug 2008 21:02:54 +1000
Message-ID: <48AE9CDE.9090504@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: fix queue depth detection
References: <48AE5FE2.2060003@gelato.unsw.edu.au> <20080822090620.GY20055@kernel.dk>
In-Reply-To: <20080822090620.GY20055@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Aug 22 2008, Aaron Carroll wrote:
>> Hi Jens,
>>
>> This patch fixes a bug in the hw_tag detection logic causing a huge 
>> performance
>> hit under certain workloads on real queuing devices.  For example, an FIO 
>> load
>> of 16k direct random reads on an 8-disk hardware RAID yields about 2 MiB/s 
>> on
>> default CFQ, while noop achieves over 20 MiB/s.
>>
>> While the solution is pretty ugly, it does have the advantage of adapting to
>> queue depth changes.  Such a situation might occur if the queue depth is
>> configured in userspace late in the boot process.
> 
> I don't think it's that ugly, and I prefer this logic to the existing
> one in fact. Since it's a static property of the device, why did you
> change it to toggle the flag back and forth instead of just setting it
> once?

Because it is possible (albeit uncommon) that the queue depth can change
at run time, like the example I gave.  However, there should be no false
positives; the flag should only be toggled if the queue depth does change.
So even if it doesn't occur often, we can handle this corner case for very
little cost.

> doesn't do queueing. So the interesting window is the one where we have
> more requests pending yet the driver doesn't ask for it. I'd prefer a
> patch that took that more into account, instead of just looking at the
> past 50 samples and then toggle the hw_tag flag depending on the
> behaviour in that time frame. You could easily have a depth of 1 there
> always if it's a sync workload, even if hardware can do tagged queuing.

That's exactly what the lines

	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
	    cfqd->rq_in_driver <= CFQ_HW_QUEUE_MIN)
		return;

are for.  It's not just the past 50 samples, but rather 50 samples with
sufficient load to see whether the device could be queuing.


Thanks,
   -- Aaron

