Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYCLUh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYCLUh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYCLUhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:37:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40801 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYCLUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:37:11 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5250"; a="1251469"
Message-ID: <47D83EF5.6070302@qualcomm.com>
Date: Wed, 12 Mar 2008 13:37:09 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 0/7] IO CPU affinity testing series
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> Here's a new round of patches to play with io cpu affinity. It can,
> as always, also be found in the block git repo. The branch name is
> 'io-cpu-affinity'.
> 
> The major change since last post is the abandonment of the kthread
> approach. It was definitely slower then may 'add IPI to signal remote
> block softirq' hack. So I decided to base this on the scalable
> smp_call_function_single() that Nick posted. I tweaked it a bit to
> make it more suitable for my use and also faster.
> 
> As for functionality, the only change is that I added a bio hint
> that the submitter can use to ask for completion on the same CPU
> that submitted the IO. Pass in BIO_CPU_AFFINE for that to occur.
> 
> Otherwise the modes are the same as last time:
> 
> - You can set a specific cpumask for queuing IO, and the block layer
>   will move submitters to one of those CPUs.
> - You can set a specific cpumask for completion of IO, in which case
>   the block layer will move the completion to one of those CPUs.
> - You can set rq_affinity mode, in which case IOs will always be
>   completed on the CPU that submitted them.
> 
> Look in /sys/block/<dev>/queue/ for the three sysfs variables that
> modify this behaviour.
> 
> I'd be interested in getting some testing done on this, to see if
> it really helps the larger end of the scale. Dave, I know you
> have a lot of experience in this area and would appreciate your
> input and/or testing. I'm not sure if any of the above modes will
> allow you to do what you need for eg XFS - if you want all meta data
> IO completed on one (or a set of) CPU(s), then I can add a mode
> that will allow you to play with that. Or if something else, give me
> some input and we can take it from there!

Very cool stuff. I think I can use it for cpu isolation purposes.
ie Isolating a cpu from the io activity.

You may have noticed that I started a bunch of discussion on CPU isolation.
One thing that came out of that is the suggestion to use cpusets for managing 
this affinity masks. We're still discussing the details, the general idea is 
to provide extra flags in the cpusets that enable/disable various activities
on the cpus that belong to the set.

For example in this particular case we'd have something like "cpusets.io" flag 
that would indicate whether cpus in the set are allowed to to the IO or not.
In other words:
	/dev/cpuset/io (cpus=0,1,2; io=1)
	/dev/cpuset/no-io (cpus=3,4,5; io=0)

I'm not sure whether this makes sense or not. One advantage is that it's more 
dynamic and more flexible. If for example you add cpu to the io cpuset it will 
automatically start handling io requests.

btw What did you mean by "to see if it really helps the larger end of the 
scale", what problem were you guys trying to solve ? I'm guessing cpu 
isolation would probably be an unexpected user of io cpu affinity :).

Max
