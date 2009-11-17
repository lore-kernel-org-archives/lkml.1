Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZKQXLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZKQXLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZKQXLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:11:03 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:54384 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKQXLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BPKY7QEAVsRSwgKATBZJhBNB5kRYSsJN3aArdyGyVv09U6VFfaszecG0NR1lBTeC1Q
         rkAYzYlgnDuHUUGx2IP36FCU7dUH1DNl7uODIBmO8Dn2y0OgrdJNpkoGKDlCDiaFebYp
         GmaP9J3445v3pz6tO+FSUKPYzVLpXiliCZtRs=
MIME-Version: 1.0
In-Reply-To: <20091117223828.GA2966@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091117141411.GA22462@redhat.com>
	 <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
	 <20091117164026.GE22462@redhat.com>
	 <4e5e476b0911171259r69e7a3cfn33fc9b06aa682801@mail.gmail.com>
	 <20091117223828.GA2966@redhat.com>
Date: Wed, 18 Nov 2009 00:11:06 +0100
Message-ID: <4e5e476b0911171511m4da177dcl30f7151e5b259161@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 11:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Ok, now I understand it better. I had missed the st->count part. So if
> there are other sync-noidle queues backlogged (st->count > 0), then we
> don't idle on same process to get more request, if hw_tag=1 or is is SSD
> and move onto to next sync-noidle process to dispatch requests from.
Yes.
>
> But if this is last cfqq on the service tree under this workload, we will
> still idle on the service tree/workload type and not start dispatching
> request from other service tree (of same prio class).
Yes.
>
>> Without this idle, we won't get fair behaviour for no-idle queues.
>> This idle is enabled regardless of NCQ for rotational media. It is
>> only disabled on NCQ SSDs (the whole function is skipped in that
>> case).
>
> So If I have a fast storage array with NCQ, we will still idle and not
> let sync-idle queues or async queues get to dispatch. Anyway, that's a
> side issue for the moment.
It is intended. If we don't idle, random readers will dispatch just
once and then the sequential readers will monopolize the disk for too
much time. This was teh former CFQ behaviour, and various tests showed
an improvement with this idle.

>> So, having more than one no-idle service tree, as in your approach to
>> groups, introduces the problem we see.
>>
>
> True, having multiple no-idle workload is problem here. Can't think of
> a solution. Putting workload type on top also is not logically good where
> workload type determines the share of disk/array. This is so unintuitive.
If you think that sequential and random are incommensurable, then it
becomes natural to do all the weighting and the scheduling
independently.
> I guess I will document this issue with random IO workload issue.
>
> May be we can do little optimization in the sense, in cfq_should_idle(), I can
> check if there are other competing sync and async queues in the cfq_group or
> not. If there are no competing queues then we don't have to idle on the
> sync-noidle service tree. That's a different thing that we might still
> want to idle on the group as a whole to make sure a single random reader
> has got good latencies and is not overwhelmed by other groups running
> sequential readers.
It will not change the outcome. You just rename the end of tree idle
as group idle, but the performance drop is the same.
>> >
>> > This is all subjected to the fact that we have done a good job in
>> > detecting the queue depth and have updated hw_tag accordingly.
>> >
>> > On slower rotational hardware, where we will actually do idling on
>> > sync-noidle per group, idling can infact help you because it will reduce
>> > the number of seeks (As it does on my locally connected SATA disk).
>> Right. We will do a small idle between no-idle queues, and a larger
>> one at the end.
>
> If we do want to do a small idle between no-idle queues, why do you allow
> preemption of one sync-noidle queue with other sync-noidle queue.
The preemption is useful when you are waiting on an empty tree. In
that case, any random request is good enough.
In the non-NCQ case, where we can idle even if the service tree is not
empty, I forgot to add the check. Good point.

>
> IOW, what's the point of waiting for small period between queues? They are
> anyway random seeky readers.
Smaller seeks take less time. If your random readers are reading from
contiguous files, they will be doing small seeks, so you still get an
improvement waiting a bit.

>
> Idling between queues can help a bit if we have sync-noidle reader and
> multiple sync-nodile sync writers. A sync-noidle reader can still witness
> higher latencies if multiple libaio driven sync writers are present. We
> discussed this issue briefly in private mail. But at the moment, allowing
> preemption will wipe out that advantage.
This applies also if you do random reads at a deeper depth, e.g. using
libaio or just posix_fadvise/readahead.
My proposed solution for this is to classify those queues are idling,
to get the usual time based fairness.

>
> I understand now up to some extent. One question still remains though is
> that why do we choose to idle on fast arrays. Faster the array (backed by
> more disks), more harmful the idling becomes.
Not if you do it just once every scheduling turn, and you obtain
fairness for random readers in this way.
On a fast rotational array, to obtain high BW, you have two options:
* large sequential read
* many parallel random reads
So it is better to devote the full array in turn to each sequential
task, and then for some time, to all the remaining random ones.
>
> May be using your dyanamic cfq tuning patches might help here. If average
> read time is less, than driver deeper queue depths otherwise reduce the
> queue depth as underlying device/array can't handle that much.

In autotuning, I'll allow breaking sequentiality only if random
requests are serviced in less than 0.5 ms on average.
Otherwise, I'll still prefer to allocate a contiguous timeslice for
each sequential reader, and an other one for all random ones.
Clearly, the time to idle for each process, and the contiguous
timeslice, will be proportional to the penalty incurred by a seek, so
I measure the average seek time for that purpose.

> I am still trying to understand your patches fully. So are you going to
> idle even on sync-idle and async trees? In cfq_should_idle(), I don't see
> any distinction between various kind of trees so it looks like we are
> going to idle on async and sync-idle trees also? That looks unnecessary?
For me, the idle on the end of a service tree is equivalent to an idle
on a queue.
Since sequential sync already have their idle, no additional idle is introduced.
For async, since they are always preempted by sync of the same priority,
the idle at the end just protects from lower priority class queues.

>
> Regular idle does not work if slice has expired. There are situations with
> sync-idle readers that I need to wait for next request for group to get
> backlogged. So it is not useless. It does kick-in only in few circumstances.
Are those circumstances worth the extra complexity?
If the only case is when there is just one process doing I/O in an
high weight group,
wouldn't just increase this process' slice above the usual 100ms do
the trick, with less complexity?

>> You can either get isolation, or performance. Not both at the same time.
>
> Agreed.
>
> Thanks
> Vivek
>

Thanks,
Corrado
