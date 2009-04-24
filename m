Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZDXGNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZDXGNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZDXGNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:13:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:15063 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZDXGNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tb6avONxnkMFUMZVwiH+V6XugMWyubWjqgLv3ApZ7/rYn54F5xuCjznL8bRk8DSO0D
         SM/QKRTUw52+tJzrMIoQjNX8ffNQKW4KIU83r7oA/kEQ20kMf/dk5Bt+L1BFw9ZY+YbI
         uPRCUGvPgaJMaDRwHGrerZhrIg27+F4d2RS+U=
MIME-Version: 1.0
In-Reply-To: <49F0FA2F.5030808@cse.unsw.edu.au>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
	 <49F05699.2070006@cse.unsw.edu.au>
	 <4e5e476b0904230910r685e8300oa2323e8985c97a00@mail.gmail.com>
	 <49F0FA2F.5030808@cse.unsw.edu.au>
Date: Fri, 24 Apr 2009 08:13:13 +0200
Message-ID: <4e5e476b0904232313l3ea26213y9a93a1f95c7de6bb@mail.gmail.com>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority 
	requests in deadline IO scheduler
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: jens.axboe@oracle.com, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron
On Fri, Apr 24, 2009 at 1:30 AM, Aaron Carroll <aaronc@cse.unsw.edu.au> wrote:
> Hi Corrado,
>
> Corrado Zoccolo wrote:
>>
>> On Thu, Apr 23, 2009 at 1:52 PM, Aaron Carroll <aaronc@cse.unsw.edu.au>
>> wrote:
>>>
>>> Corrado Zoccolo wrote:
>>>>
>>>> Hi,
>>>> deadline I/O scheduler currently classifies all I/O requests in only 2
>>>> classes, reads (always considered high priority) and writes (always
>>>> lower).
>>>> The attached patch, intended to reduce latencies for syncronous writes
>>>
>>> Can be achieved by switching to sync/async rather than read/write.  No
>>> one has shown results where this makes an improvement.  Let us know if
>>> you have a good example.
>>
>> Yes, this is exactly what my patch does, and the numbers for
>> fsync-tester are much better than baseline deadline, almost comparable
>> with cfq.
>
> The patch does a bunch of other things too.  I can't tell what is due to
> the read/write -> sync/async change, and what is due to the rest of it.

Ok, I got it. I'm splitting it in smaller patches.

>>>> and high I/O priority requests, introduces more levels of priorities:
>>>> * real time reads: highest priority and shortest deadline, can starve
>>>> other levels
>>>> * syncronous operations (either best effort reads or RT/BE writes),
>>>> mid priority, starvation for lower level is prevented as usual
>>>> * asyncronous operations (async writes and all IDLE class requests),
>>>> lowest priority and longest deadline
>>>>
>>>> The patch also introduces some new heuristics:
>>>> * for non-rotational devices, reads (within a given priority level)
>>>> are issued in FIFO order, to improve the latency perceived by readers
>>>
>>> This might be a good idea.
>>
>> I think Jens doesn't like it very much.
>
> Let's convince him :)
>
> I think a nice way to do this would be to make fifo_batch=1 the default
> for nonrot devices.  Of course this will affect writes too...

Fifo_batch has various implications, concerning also the alternation
between reads and writes.
Moreover, too low numbers also negatively affect merging.
In deadline, often merging on writeback requests happens because the
scheduler is handling unrelated requests for some time, so incoming
requests have time to accumulate.

>
> One problem here is the definition of nonrot.  E.g. if H/W RAID drivers
> start setting that flag, it will kill performance.  Sorting is important for
> arrays of rotational disks.
>
The flag should have a well defined semantics.
In RAID, I think it could be defined for the aggregated disk, while
single disks will be rotational or not depending on the technology.
This could work very well, since each disk will sort only its
requests, and the scheduler will not waste time on other disk
requests.
A random read workload with reads smaller than the RAID stripe will
shine with this.
Clearly, for writes, since multiple disks are touched, the sorting
must be performed at the aggregated disk level to have some
opportunity of reducing data transfers: this corresponds to what my
patch does.

>>> Can you make this a separate patch?
>>
>> I have an earlier attempt, much simpler, at:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0904.1/00667.html
>>>
>>> Is there a good reason not to do the same for writes?
>>
>> Well, in that case you could just use noop.
>
> Noop doesn't merge as well as deadline, nor does is provide read/write
> differentiation.  Is there a performance/QoS argument for not doing it?

I think only experimentation can tell. But the RAID argument above
could make a case.

>> I found that this scheme outperforms noop. Random writes, in fact,
>> perform quite bad on most SSDs (unless you use a logging FS like
>> nilfs2, that transforms them into sequential writes), so having all
>> the deadline ioscheduler machinery to merge write requests is much
>> better. As I said, my patched IO scheduler outperforms noop on my
>> normal usage.
>
> You still get the merging... we are only talking about the issue
> order here.
>

Ditto, more experimentation is needed.

>>>> * minimum batch timespan (time quantum): partners with fifo_batch to
>>>> improve throughput, by sending more consecutive requests together. A
>>>> given number of requests will not always take the same time (due to
>>>> amount of seek needed), therefore fifo_batch must be tuned for worst
>>>> cases, while in best cases, having longer batches would give a
>>>> throughput boost.
>>>> * batch start request is chosen fifo_batch/3 requests before the
>>>> expired one, to improve fairness for requests with lower start sector,
>>>> that otherwise have higher probability to miss a deadline than
>>>> mid-sector requests.
>>>
>>> I don't like the rest of it.  I use deadline because it's a simple,
>>> no surprises, no bullshit scheduler with reasonably good performance
>>> in all situations.  Is there some reason why CFQ won't work for you?
>>
>> I actually like CFQ, and use it almost everywhere, and switch to
>> deadline only when submitting an heavy-duty workload (having a SysRq
>> combination to switch I/O schedulers could sometimes be very handy).
>>
>> However, on SSDs it's not optimal, so I'm developing this to overcome
>> those limitations.
>
> Is this due to the stall on each batch switch?

Possibly (CFQ is too complex to start hacking with it without some
experience on something simpler).
AFAIK, it should be disabled when ronrot=1, but actually only if the
device supports tag queuing.
I think, however, that the whole machinery of CFQ is too heavy for
non-rotational devices, where a simple fifo scheme, adjusted with
priorities, can achieve fair handling of requests.

>
>> In the meantime, I wanted to overcome also deadline limitations, i.e.
>> the high latencies on fsync/fdatasync.
>
> Did you try dropping the expiry times and/or batch size?

Yes. Expiry times are soft, so often they are not satisfied.
Dropping batch size will cause bandwidth drop, causing expiry times to
miss more often due to longer queues (I'm speaking of rotational
devices here, since the latencies affect also them).

>
>
>   -- Aaron
>
>>
>> Corrado
>>
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
