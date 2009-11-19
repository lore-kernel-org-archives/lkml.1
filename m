Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZKSAGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZKSAGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZKSAGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:06:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbZKSAGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:06:47 -0500
Date: Wed, 18 Nov 2009 19:04:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091119000455.GC2974@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091117141411.GA22462@redhat.com> <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com> <20091117164026.GE22462@redhat.com> <4e5e476b0911171259r69e7a3cfn33fc9b06aa682801@mail.gmail.com> <20091117223828.GA2966@redhat.com> <4e5e476b0911171511m4da177dcl30f7151e5b259161@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911171511m4da177dcl30f7151e5b259161@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 12:11:06AM +0100, Corrado Zoccolo wrote:
> On Tue, Nov 17, 2009 at 11:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Ok, now I understand it better. I had missed the st->count part. So if
> > there are other sync-noidle queues backlogged (st->count > 0), then we
> > don't idle on same process to get more request, if hw_tag=1 or is is SSD
> > and move onto to next sync-noidle process to dispatch requests from.
> Yes.
> >
> > But if this is last cfqq on the service tree under this workload, we will
> > still idle on the service tree/workload type and not start dispatching
> > request from other service tree (of same prio class).
> Yes.
> >
> >> Without this idle, we won't get fair behaviour for no-idle queues.
> >> This idle is enabled regardless of NCQ for rotational media. It is
> >> only disabled on NCQ SSDs (the whole function is skipped in that
> >> case).
> >
> > So If I have a fast storage array with NCQ, we will still idle and not
> > let sync-idle queues or async queues get to dispatch. Anyway, that's a
> > side issue for the moment.
> It is intended. If we don't idle, random readers will dispatch just
> once and then the sequential readers will monopolize the disk for too
> much time. This was teh former CFQ behaviour, and various tests showed
> an improvement with this idle.

Actually I was assuming that we will not idle even on sync-idle queues
on fast arrays. I am wondering what happens when we are running sync-idle
workload on an storage array with lots of disks. By letting only one
process/queue dispatch IO, are we not introducing lot of serialization 
here and can we get more out of array by dispatching requests from more
sync-idle queues and stop if it becomes seek bound.

I got an array of 5 striped disks. I did some experements with
slice_idle=0. I don't see performance improvement in case of buffered reads. As
I increase the number of processes seek cost is significant and total
throughput drops. I think readahead logic reads in bigger block sizes, and
that should keep all the disks busy hence no gains here.

I did see some gains if I was doing direct sequential IO with 4K block
size. With slice_idle=8 following is total throughput with 1,2,4,8,16
readers.

16,278KB/s 16,173KB/s 15,891KB/s 15,678KB/s 15,847KB/s

With slice_idle=0, following is total throughput.

16,206KB/s 22,851KB/s 26,368KB/ 29,197KB/s 28,806KB/s

So by allowing more sequential direct readers to dispatch simultaneously,
I can get more out of array in this case.

> 
> >> So, having more than one no-idle service tree, as in your approach to
> >> groups, introduces the problem we see.
> >>
> >
> > True, having multiple no-idle workload is problem here. Can't think of
> > a solution. Putting workload type on top also is not logically good where
> > workload type determines the share of disk/array. This is so unintuitive.
> If you think that sequential and random are incommensurable, then it
> becomes natural to do all the weighting and the scheduling
> independently.

I am not ruling out the option of keeping workload type on top. For
determining the workload share out of 300ms, we can use total of group
weights on all the tree workload trees and proportion out the share. That
way at least number of queues in a group don't change the share of group
based on workload type.

That will still leave the issue of a disk share being decided by number of
groups doing a particular type of IO. 

I am first trying to make the more intutive thing work. If it does not
work reasonably, we can always switch to groups with-in workload method.

> > I guess I will document this issue with random IO workload issue.
> >
> > May be we can do little optimization in the sense, in cfq_should_idle(), I can
> > check if there are other competing sync and async queues in the cfq_group or
> > not. If there are no competing queues then we don't have to idle on the
> > sync-noidle service tree. That's a different thing that we might still
> > want to idle on the group as a whole to make sure a single random reader
> > has got good latencies and is not overwhelmed by other groups running
> > sequential readers.
> It will not change the outcome. You just rename the end of tree idle
> as group idle, but the performance drop is the same.

True. I am trying to cleanup the group_idle=0 path. So that we don't incur
this additional wait penatly there. Also trying to see if I can make
group_idle=0 as default so that we get reasonable isolation and resonable
performance from the box. 

> >> >
> >> > This is all subjected to the fact that we have done a good job in
> >> > detecting the queue depth and have updated hw_tag accordingly.
> >> >
> >> > On slower rotational hardware, where we will actually do idling on
> >> > sync-noidle per group, idling can infact help you because it will reduce
> >> > the number of seeks (As it does on my locally connected SATA disk).
> >> Right. We will do a small idle between no-idle queues, and a larger
> >> one at the end.
> >
> > If we do want to do a small idle between no-idle queues, why do you allow
> > preemption of one sync-noidle queue with other sync-noidle queue.
> The preemption is useful when you are waiting on an empty tree. In
> that case, any random request is good enough.
> In the non-NCQ case, where we can idle even if the service tree is not
> empty, I forgot to add the check. Good point.
> 
> >
> > IOW, what's the point of waiting for small period between queues? They are
> > anyway random seeky readers.
> Smaller seeks take less time. If your random readers are reading from
> contiguous files, they will be doing small seeks, so you still get an
> improvement waiting a bit.

I am not sure if waiting a bit between queues on non-rotational media is
working. Because even in select queue, we should expire the current
sync-noidle queue and move onto next sync-noidle queue.

> 
> >
> > Idling between queues can help a bit if we have sync-noidle reader and
> > multiple sync-nodile sync writers. A sync-noidle reader can still witness
> > higher latencies if multiple libaio driven sync writers are present. We
> > discussed this issue briefly in private mail. But at the moment, allowing
> > preemption will wipe out that advantage.
> This applies also if you do random reads at a deeper depth, e.g. using
> libaio or just posix_fadvise/readahead.
> My proposed solution for this is to classify those queues are idling,
> to get the usual time based fairness.

But these sync reads/writes could just be random and you will suffer the
servere performance penalty if you treat these as sync-idle queues? It is
like going back to enabling idling on random seeky reader.

> 
> >
> > I understand now up to some extent. One question still remains though is
> > that why do we choose to idle on fast arrays. Faster the array (backed by
> > more disks), more harmful the idling becomes.
> Not if you do it just once every scheduling turn, and you obtain
> fairness for random readers in this way.
> On a fast rotational array, to obtain high BW, you have two options:
> * large sequential read
> * many parallel random reads
> So it is better to devote the full array in turn to each sequential
> task, and then for some time, to all the remaining random ones.

Doing a group idle on many parallel random reads is fine. I am pointing
towards idling on sequential reads. If it is buffered sequential reads
things are probably fine. But what about if these are direct IO, with
smaller block size. Are we not keeping array underutilized here?

> >
> > May be using your dyanamic cfq tuning patches might help here. If average
> > read time is less, than driver deeper queue depths otherwise reduce the
> > queue depth as underlying device/array can't handle that much.
> 
> In autotuning, I'll allow breaking sequentiality only if random
> requests are serviced in less than 0.5 ms on average.
> Otherwise, I'll still prefer to allocate a contiguous timeslice for
> each sequential reader, and an other one for all random ones.
> Clearly, the time to idle for each process, and the contiguous
> timeslice, will be proportional to the penalty incurred by a seek, so
> I measure the average seek time for that purpose.

Ok. I have yet to test your patch.

> 
> > I am still trying to understand your patches fully. So are you going to
> > idle even on sync-idle and async trees? In cfq_should_idle(), I don't see
> > any distinction between various kind of trees so it looks like we are
> > going to idle on async and sync-idle trees also? That looks unnecessary?
> For me, the idle on the end of a service tree is equivalent to an idle
> on a queue.
> Since sequential sync already have their idle, no additional idle is introduced.

If CFQ disables idling on a queue in the middle of slice, we will continue
to idle on it and not take service tree change into account till end of
slice. This is something very minor. More than that, I think it is
confusing, on every type of service tree.

> For async, since they are always preempted by sync of the same priority,
> the idle at the end just protects from lower priority class queues.

I thought async are always preempted by sync irrespective of priority
class or priority (With the exception of idle class). Even RT asyncs are
preempted by BE sync queues. So waiting on async queue does not make sense.
 
> 
> >
> > Regular idle does not work if slice has expired. There are situations with
> > sync-idle readers that I need to wait for next request for group to get
> > backlogged. So it is not useless. It does kick-in only in few circumstances.
> Are those circumstances worth the extra complexity?
> If the only case is when there is just one process doing I/O in an
> high weight group,
> wouldn't just increase this process' slice above the usual 100ms do
> the trick, with less complexity?

Does not work all the time. If sync queue with-in group is preempted by
another queue in the group (a sync queue containing meta data), then we
lose track of old queue and meta data queue will expire almost immediately
after hence leading to deletion of group.

I had ran into these interesting issues in the past when I had tried
something similar. Will have a look at it again.

Thanks
Vivek
