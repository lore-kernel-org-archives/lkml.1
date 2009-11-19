Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZKSUMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZKSUMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZKSUMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:12:52 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48687 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbZKSUMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:12:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BNOOUjX0f4SblqPErlFIG03ilqqyyCM1whJVlgRCKWJ+jt+XF/pEJJot91M8a2Xukc
         q4gGKDl9nPbXdwqph+a7KAcHvreTHi3BlzKR+GemaMEEO4PEdW+zUgtjqT7skecM5p3i
         ee2Pj7bcV/aV7JAadX8mvIMXvngWVnG+BCiyE=
MIME-Version: 1.0
In-Reply-To: <20091119000455.GC2974@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091117141411.GA22462@redhat.com>
	 <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
	 <20091117164026.GE22462@redhat.com>
	 <4e5e476b0911171259r69e7a3cfn33fc9b06aa682801@mail.gmail.com>
	 <20091117223828.GA2966@redhat.com>
	 <4e5e476b0911171511m4da177dcl30f7151e5b259161@mail.gmail.com>
	 <20091119000455.GC2974@redhat.com>
Date: Thu, 19 Nov 2009 21:12:56 +0100
Message-ID: <4e5e476b0911191212r5e0a255fqde6ba428204e9c6c@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Thu, Nov 19, 2009 at 1:04 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Actually I was assuming that we will not idle even on sync-idle queues
> on fast arrays. I am wondering what happens when we are running sync-idle
> workload on an storage array with lots of disks. By letting only one
> process/queue dispatch IO, are we not introducing lot of serialization
> here and can we get more out of array by dispatching requests from more
> sync-idle queues and stop if it becomes seek bound.
As alan's test with slice_idle = 0 showed, not idling will quickly
reduce sequential throughput as soon as you add more readers.
So we prefer to idle even on fast arrays.

>
> I got an array of 5 striped disks. I did some experements with
> slice_idle=0. I don't see performance improvement in case of buffered reads. As
> I increase the number of processes seek cost is significant and total
> throughput drops. I think readahead logic reads in bigger block sizes, and
> that should keep all the disks busy hence no gains here.
>
> I did see some gains if I was doing direct sequential IO with 4K block
> size. With slice_idle=8 following is total throughput with 1,2,4,8,16
> readers.
>
> 16,278KB/s 16,173KB/s 15,891KB/s 15,678KB/s 15,847KB/s
>
> With slice_idle=0, following is total throughput.
>
> 16,206KB/s 22,851KB/s 26,368KB/ 29,197KB/s 28,806KB/s
>
> So by allowing more sequential direct readers to dispatch simultaneously,
> I can get more out of array in this case.

Right, but I don't think this scenario is realistic. The people that
are using direct I/O, are smart enough not to submit a single small
request at a time, especially if they are doing sequential I/O. They
will probably use large requests and/or aio to submit multiple
requests at a time.

>>
>> >> So, having more than one no-idle service tree, as in your approach to
>> >> groups, introduces the problem we see.
>> >>
>> >
>> > True, having multiple no-idle workload is problem here. Can't think of
>> > a solution. Putting workload type on top also is not logically good where
>> > workload type determines the share of disk/array. This is so unintuitive.
>> If you think that sequential and random are incommensurable, then it
>> becomes natural to do all the weighting and the scheduling
>> independently.
>
> I am not ruling out the option of keeping workload type on top. For
> determining the workload share out of 300ms, we can use total of group
> weights on all the tree workload trees and proportion out the share. That
> way at least number of queues in a group don't change the share of group
> based on workload type.
>
> That will still leave the issue of a disk share being decided by number of
> groups doing a particular type of IO.
>
> I am first trying to make the more intutive thing work. If it does not
> work reasonably, we can always switch to groups with-in workload method.
>
> I am not sure if waiting a bit between queues on non-rotational media is
> working. Because even in select queue, we should expire the current
> sync-noidle queue and move onto next sync-noidle queue.
The small idle is enabled only on non-NCQ rotational media.

>> My proposed solution for this is to classify those queues are idling,
>> to get the usual time based fairness.
>
> But these sync reads/writes could just be random and you will suffer the
> servere performance penalty if you treat these as sync-idle queues? It is
> like going back to enabling idling on random seeky reader.

Here, again, I suppose that if someone is using aio or readahead, then
he is already optimizing for full utilization of the disks. In that
case, giving him a full slice of exclusive access to the disks is the
best thing to do, and exactly what he expects.

>>
>> >
>> > I understand now up to some extent. One question still remains though is
>> > that why do we choose to idle on fast arrays. Faster the array (backed by
>> > more disks), more harmful the idling becomes.
>> Not if you do it just once every scheduling turn, and you obtain
>> fairness for random readers in this way.
>> On a fast rotational array, to obtain high BW, you have two options:
>> * large sequential read
>> * many parallel random reads
>> So it is better to devote the full array in turn to each sequential
>> task, and then for some time, to all the remaining random ones.
>
> Doing a group idle on many parallel random reads is fine. I am pointing
> towards idling on sequential reads. If it is buffered sequential reads
> things are probably fine. But what about if these are direct IO, with
> smaller block size. Are we not keeping array underutilized here?

The underutilization would appear even if the application is run alone
on uncontended disk, so it is not unreasonable to ask the programmer
to do his homeworks, and optimize the application in this case.

>> >
>> > May be using your dyanamic cfq tuning patches might help here. If average
>> > read time is less, than driver deeper queue depths otherwise reduce the
>> > queue depth as underlying device/array can't handle that much.
>>
>> In autotuning, I'll allow breaking sequentiality only if random
>> requests are serviced in less than 0.5 ms on average.
>> Otherwise, I'll still prefer to allocate a contiguous timeslice for
>> each sequential reader, and an other one for all random ones.
>> Clearly, the time to idle for each process, and the contiguous
>> timeslice, will be proportional to the penalty incurred by a seek, so
>> I measure the average seek time for that purpose.
>
> Ok. I have yet to test your patch.
>
>>
>> > I am still trying to understand your patches fully. So are you going to
>> > idle even on sync-idle and async trees? In cfq_should_idle(), I don't see
>> > any distinction between various kind of trees so it looks like we are
>> > going to idle on async and sync-idle trees also? That looks unnecessary?
>> For me, the idle on the end of a service tree is equivalent to an idle
>> on a queue.
>> Since sequential sync already have their idle, no additional idle is introduced.
>
> If CFQ disables idling on a queue in the middle of slice, we will continue
> to idle on it and not take service tree change into account till end of
> slice. This is something very minor. More than that, I think it is
> confusing, on every type of service tree.

Maybe not changing mind in the middle is better. The seek average can
increase sometimes when files are fragmented or you need to fetch
metadata, but the queue could still be mostly sequential. So you
should not disable idling as soon as the seek average increases.

>> For async, since they are always preempted by sync of the same priority,
>> the idle at the end just protects from lower priority class queues.
>
> I thought async are always preempted by sync irrespective of priority
> class or priority (With the exception of idle class). Even RT asyncs are
> preempted by BE sync queues. So waiting on async queue does not make sense.

It simplifies the code not having to special case something that
doesn't change the outcome.

>>
>> >
>> > Regular idle does not work if slice has expired. There are situations with
>> > sync-idle readers that I need to wait for next request for group to get
>> > backlogged. So it is not useless. It does kick-in only in few circumstances.
>> Are those circumstances worth the extra complexity?
>> If the only case is when there is just one process doing I/O in an
>> high weight group,
>> wouldn't just increase this process' slice above the usual 100ms do
>> the trick, with less complexity?
>
> Does not work all the time. If sync queue with-in group is preempted by
> another queue in the group (a sync queue containing meta data), then we
> lose track of old queue and meta data queue will expire almost immediately
> after hence leading to deletion of group.
I think this is the correct behaviour.
If you have a queue that is preempted during idle, the time servicing
the pre-empted queue, that will usually imply a large seek, will be
enough for the queue to become backlogged again. The time to service
this large seek will be comparable with the idle time, so if the old
queue is not backlogged when the pre-empting queue is expired,  then
it is correct to remove the group and switch to a new one.

>
> I had ran into these interesting issues in the past when I had tried
> something similar. Will have a look at it again.
I have an other idea, that could help reducing the code duplication in
the IO controller patches, and could support hierarchical groups.

A scheduler (like CFQ) deals with scheduling entities. Currently, the
scheduling entities for CFQ are the queues, but you should note that,
with Jeff's patch for queue merging, we already did some steps in the
direction of them being generalized.
Now, a group would be an other scheduling entity.

To define a scheduling entity you need to define few fundamental operations:
* classify() -> workload
* may_queue() -> int
* get_next_rq() -> request
* should_idle -> bool
* get_slice() -> int
* get_schedule_key() -> int
* residual_slice(int)
* add_request(request)

You will have queues, merged queues and groups, and they will all be
scheduled by the existing CFQ scheduling algorithm.
Then groups can implement their internal scheduling policy in the
get_next_rq(). You could reuse most of the CFQ scheduling inside a
group, as well as have the option to use a different I/O scheduler
within some groups.
If you reuse CFQ, then you could have sub groups inside a group.
You could also have a special case implementation for single queue
group, where you just forward all calls to the internal queue (but
scaling the slice/schedule_key according to weight), so any
discrepancy between a single group queue and a simple queue in the
root group will disappear.

Thanks
Corrado

> Thanks
> Vivek
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
