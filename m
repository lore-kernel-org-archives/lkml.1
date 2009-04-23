Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZDWQKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZDWQKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZDWQKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:10:46 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:23157 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZDWQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hHkN9Ippce2jFSzUyVDvOdMDhM2XOLx9JVa5sF4XEZDiKdnwdzxbMsTS1zhjPK/nJZ
         l8CsCyyGQbf3wZZfImazUEcwhOu4/MMtpp9JEY4s8WJ5jnc8bdPQGoxPUQUGSEsICPvT
         Nh1eyjcH0ecmHtB6f+/bwOVxZnn0FLMj+jCZ4=
MIME-Version: 1.0
In-Reply-To: <49F05699.2070006@cse.unsw.edu.au>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
	 <49F05699.2070006@cse.unsw.edu.au>
Date: Thu, 23 Apr 2009 18:10:43 +0200
Message-ID: <4e5e476b0904230910r685e8300oa2323e8985c97a00@mail.gmail.com>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority 
	requests in deadline IO scheduler
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: jens.axboe@oracle.com, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 1:52 PM, Aaron Carroll <aaronc@cse.unsw.edu.au> wrote:
> Corrado Zoccolo wrote:
>> Hi,
>> deadline I/O scheduler currently classifies all I/O requests in only 2
>> classes, reads (always considered high priority) and writes (always
>> lower).
>> The attached patch, intended to reduce latencies for syncronous writes
>
> Can be achieved by switching to sync/async rather than read/write.  No
> one has shown results where this makes an improvement.  Let us know if
> you have a good example.

Yes, this is exactly what my patch does, and the numbers for
fsync-tester are much better than baseline deadline, almost comparable
with cfq.

>
>> and high I/O priority requests, introduces more levels of priorities:
>> * real time reads: highest priority and shortest deadline, can starve
>> other levels
>> * syncronous operations (either best effort reads or RT/BE writes),
>> mid priority, starvation for lower level is prevented as usual
>> * asyncronous operations (async writes and all IDLE class requests),
>> lowest priority and longest deadline
>>
>> The patch also introduces some new heuristics:
>> * for non-rotational devices, reads (within a given priority level)
>> are issued in FIFO order, to improve the latency perceived by readers
>
> This might be a good idea.
I think Jens doesn't like it very much.
> Can you make this a separate patch?
I have an earlier attempt, much simpler, at:
http://lkml.indiana.edu/hypermail/linux/kernel/0904.1/00667.html
> Is there a good reason not to do the same for writes?
Well, in that case you could just use noop.
I found that this scheme outperforms noop. Random writes, in fact,
perform quite bad on most SSDs (unless you use a logging FS like
nilfs2, that transforms them into sequential writes), so having all
the deadline ioscheduler machinery to merge write requests is much
better. As I said, my patched IO scheduler outperforms noop on my
normal usage.


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
> I don't like the rest of it.  I use deadline because it's a simple,
> no surprises, no bullshit scheduler with reasonably good performance
> in all situations.  Is there some reason why CFQ won't work for you?

I actually like CFQ, and use it almost everywhere, and switch to
deadline only when submitting an heavy-duty workload (having a SysRq
combination to switch I/O schedulers could sometimes be very handy).

However, on SSDs it's not optimal, so I'm developing this to overcome
those limitations.
In the meantime, I wanted to overcome also deadline limitations, i.e.
the high latencies on fsync/fdatasync.

Corrado

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
