Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbZDWP5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbZDWP5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZDWP5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:57:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:29636 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZDWP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nszg+3UYTheDlQupwBjKvE6bHYdGLVtNdhUxE0Z9hlePt4RjaPQydhGjiANsJJTFEG
         d7Tsp9yQ14u0OHHp6MjD/mcLh2SXdRL65nVqiAeWAPoTx+nhFC0zBK6uvyUJPTjqeYND
         zGK6ldmBgUKihQr8dCsSE1zXFvJ/0seVxLRH4=
MIME-Version: 1.0
In-Reply-To: <20090423112823.GB4593@kernel.dk>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
	 <20090423112823.GB4593@kernel.dk>
Date: Thu, 23 Apr 2009 17:57:27 +0200
Message-ID: <4e5e476b0904230857q11c634c8j37c871817bfc83cf@mail.gmail.com>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority 
	requests in deadline IO scheduler
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Thu, Apr 23, 2009 at 1:28 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Apr 22 2009, Corrado Zoccolo wrote:
>> The patch also introduces some new heuristics:
>> * for non-rotational devices, reads (within a given priority level)
>> are issued in FIFO order, to improve the latency perceived by readers
>
> Danger danger... I smell nasty heuristics.

Ok, I wanted to sneak this heuristic in :), but probably I can abridge
it from the initial submission.
The fact is that many people around are using noop scheduler for SSDs,
to get the ultimate preformance out of their hardware, and I wanted to
give them a better alternative. CFQ doesn't honor non-rotational flag
when tag-queuing is not supported, so it will not be an alternative in
such cases.

>
>> * minimum batch timespan (time quantum): partners with fifo_batch to
>> improve throughput, by sending more consecutive requests together. A
>> given number of requests will not always take the same time (due to
>> amount of seek needed), therefore fifo_batch must be tuned for worst
>> cases, while in best cases, having longer batches would give a
>> throughput boost.
>> * batch start request is chosen fifo_batch/3 requests before the
>> expired one, to improve fairness for requests with lower start sector,
>> that otherwise have higher probability to miss a deadline than
>> mid-sector requests.
>
> This is a huge patch, I'm not going to be reviewing this. Make this a
> patchset, each doing that little change separately. Then it's easier to
> review, and much easier to pick the parts that can go in directly and
> leave the ones that either need more work or are not going be merged
> out.
>
Ok.
I think I can split it into:
* add new heuristics (so those can be evaluated independently of the
read/write vs. sync/async)
* read/write becomes sync/async
* add iopriorities

>> I did few performance comparisons:
>> * HDD, ext3 partition with data=writeback, tiotest with 32 threads,
>> each writing 80MB of data
>
> It doesn't seem to make a whole lot of difference, does it?

The intent is not to boost throughput, but to reduce sync latency.
The heuristics were added to avoid throughput regression.

> Main difference here seems to be random read performance, the rest are
> pretty close and could just be noise. Random write is much worse, from a
> latency view point. Is this just one run, or did you average several?

The random writes issued by tio-test are async writes, so the latency
is not an issue, and having higher latencies here actually help in
improving throughput.

>
> For something like this, you also need to consider workloads that
> consist of processes with different IO patterns running at the same
> time. With this tiotest run, you only test sequential readers competing,
> then random readers, etc.

Sure. Do you have any suggestion?
I have an other workload, that is the boot of my netbook, on which the
patched ioscheduler saves 1s out of 12s.
All other IOschedulers, including noop, perform equally worse (for
noop, I think I lose on writes).

> So, please, split the big patch into lots of little separate pieces.
> Benchmark each one separately, so they each carry their own
> justification.

Does a theoretical proof of unfairness also matter, for the
fifo_batch/3 backjump?

>> * fsync-tester results, on HDD, empty ext3 partition, mounted with
>
> At least this test looks a lot better!

This is why the subject says "reducing latencies ..." :)
Maybe I should have started the mails with this test, instead of the
other ones showing that there wasn't regression for throughput (that
in principle could happen when trying to reduce latencies).

Thanks,
Corrado


-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
