Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZKQWls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZKQWls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZKQWlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:41:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbZKQWlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:41:44 -0500
Date: Tue, 17 Nov 2009 17:38:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091117223828.GA2966@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091117141411.GA22462@redhat.com> <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com> <20091117164026.GE22462@redhat.com> <4e5e476b0911171259r69e7a3cfn33fc9b06aa682801@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911171259r69e7a3cfn33fc9b06aa682801@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 09:59:38PM +0100, Corrado Zoccolo wrote:
> On Tue, Nov 17, 2009 at 5:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > I thought more about it. We idle on sync-noidle group only in case of
> > rotational media not supporting NCQ (hw_tag = 0). So for all the fast
> > hardware out there (SSD and fast arrays), we should not be idling on
> > sync-noidle group hence should not additional idling per group.
> 
> Your description is not complete. The relevant code is:
> 
>         /* are we servicing noidle tree, and there are more queues?
>          * non-rotational or NCQ: no idle
>          * non-NCQ rotational : very small idle, to allow
>          *     fair distribution of slice time for a process doing
> back-to-back
>          *     seeks.
>          */
>         st = service_tree_for(cfqq->cfqg, cfqd->serving_prio,
>                                 SYNC_NOIDLE_WORKLOAD, cfqd);
>         if (!wait_busy && cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
>             && st->count > 0) {
>                 if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
>                         return false; /* here we don't idle */
>                 sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
>         }
>         /* here we idle */
> 
> Notice the condition on count > 0? We will still idle "at the end" of
> the no-idle service tree, i.e. when there are no more no-idle queues.

Ok, now I understand it better. I had missed the st->count part. So if
there are other sync-noidle queues backlogged (st->count > 0), then we
don't idle on same process to get more request, if hw_tag=1 or is is SSD
and move onto to next sync-noidle process to dispatch requests from.

But if this is last cfqq on the service tree under this workload, we will
still idle on the service tree/workload type and not start dispatching
request from other service tree (of same prio class).

> Without this idle, we won't get fair behaviour for no-idle queues.
> This idle is enabled regardless of NCQ for rotational media. It is
> only disabled on NCQ SSDs (the whole function is skipped in that
> case).

So If I have a fast storage array with NCQ, we will still idle and not
let sync-idle queues or async queues get to dispatch. Anyway, that's a
side issue for the moment.

> So, having more than one no-idle service tree, as in your approach to
> groups, introduces the problem we see.
> 

True, having multiple no-idle workload is problem here. Can't think of
a solution. Putting workload type on top also is not logically good where
workload type determines the share of disk/array. This is so unintuitive.

I guess I will document this issue with random IO workload issue.

May be we can do little optimization in the sense, in cfq_should_idle(), I can
check if there are other competing sync and async queues in the cfq_group or
not. If there are no competing queues then we don't have to idle on the
sync-noidle service tree. That's a different thing that we might still
want to idle on the group as a whole to make sure a single random reader
has got good latencies and is not overwhelmed by other groups running
sequential readers.

> >
> > This is all subjected to the fact that we have done a good job in
> > detecting the queue depth and have updated hw_tag accordingly.
> >
> > On slower rotational hardware, where we will actually do idling on
> > sync-noidle per group, idling can infact help you because it will reduce
> > the number of seeks (As it does on my locally connected SATA disk).
> Right. We will do a small idle between no-idle queues, and a larger
> one at the end.

If we do want to do a small idle between no-idle queues, why do you allow
preemption of one sync-noidle queue with other sync-noidle queue.

IOW, what's the point of waiting for small period between queues? They are
anyway random seeky readers.

Idling between queues can help a bit if we have sync-noidle reader and
multiple sync-nodile sync writers. A sync-noidle reader can still witness
higher latencies if multiple libaio driven sync writers are present. We
discussed this issue briefly in private mail. But at the moment, allowing
preemption will wipe out that advantage.

> 
> >> However, we can check few things:
> >> * is this kernel built with HZ < 1000? The smallest idle CFQ will do
> >> is given by 2/HZ, so running with a small HZ will increase the impact
> >> of idling.
> >>
> >> On Tue, Nov 17, 2009 at 3:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Regarding the reduced throughput for random IO case, ideally we should not
> >> > idle on sync-noidle group on this hardware as this seems to be a fast NCQ
> >> > supporting hardware. But I guess we might not be detecting the queue depth
> >> > properly which leads to idling on per group sync-noidle workload and
> >> > forces the queue depth to be 1.
> >>
> >> * This can be ruled out testing my NCQ detection fix patch
> >> (http://groups.google.com/group/linux.kernel/browse_thread/thread/3b62f0665f0912b6/34ec9456c7da1bb7?lnk=raot)
> >
> > This will be a good patch to test here. Alan, can you also apply this
> > patch and see if we see any improvement.
> >
> > My core concern is that hardware Alan is testing on is a fast NCQ
> > supporting hardware and we should see hw_tag=1 and hence no idling on
> > sync-noidle group should happen.
> >
> See my explanation above.

I understand now up to some extent. One question still remains though is
that why do we choose to idle on fast arrays. Faster the array (backed by
more disks), more harmful the idling becomes.

May be using your dyanamic cfq tuning patches might help here. If average
read time is less, than driver deeper queue depths otherwise reduce the
queue depth as underlying device/array can't handle that much.

> 
> >>
> >> However, my feeling is that the real problem is having multiple
> >> separate sync-noidle trees.
> >> Inter group idle is marginal, since each sync-noidle tree already has
> >> its end-of-tree idle enabled for rotational devices (The difference in
> >> the table is in fact small).
> >> > ---- ---- - ----------- ----------- ----------- -----------
> >> > Mode RdWr N    base       ioc off   ioc no idle  ioc idle
> >> > ---- ---- - ----------- ----------- ----------- -----------
> >> >  rnd   rd 2        17.3        17.1         9.4         9.1
> >> >  rnd   rd 4        27.1        27.1         8.1         8.2
> >> >  rnd   rd 8        37.1        37.1         6.8         7.1
> >>
> >> 2 random readers without groups have bw = 17.3 ; this means that a
> >> single random reader will have bw > 8.6 (since the two readers go
> >> usually in parallel when no groups are involved, unless two random
> >> reads are actually queued to the same disk).
> >>
> >
> > Agreed. Without groups I guess we are driving queue depth as 2 hence
> > two random readers are able to work in paralle. Because this is striped
> > array of multiple disks, there are chances that reads will happen on
> > different disks and we can support more random readers in parallel without
> > dropping the throughput of box.
> >
> >> When the random readers are in separate groups, we give the full disk
> >> to only one at a time, so the max aggregate bw achievable is the bw of
> >> a single random reader less the overhead proportional to number of
> >> groups. This is compatible with the numbers.
> >>
> >
> > Yes it is but with group_idle=0, we don't wait for a group to get
> > backlogged. So in that case we should have been driving queue depth as 2
> > and allow both the groups go in parallel. But looking at Alan's number
> > with with group_ilde=0, he is not achieving close to 17MB/s and I suspect
> > this is coming from that fact that hw_tag=0 somehow and we are idling on
> > sync-nodile workload hence effectively driving queue depth as 1.
> Its because of the idle at the end of the service tree.
> If you recall, I commented about the group idle being useless, since
> we already do an idle in any case, even after the no-idle service
> tree.
> 

I am still trying to understand your patches fully. So are you going to
idle even on sync-idle and async trees? In cfq_should_idle(), I don't see
any distinction between various kind of trees so it looks like we are
going to idle on async and sync-idle trees also? That looks unnecessary?

Regular idle does not work if slice has expired. There are situations with
sync-idle readers that I need to wait for next request for group to get
backlogged. So it is not useless. It does kick-in only in few circumstances. 

> >
> >> So, an other thing to mention in the docs is that having one process
> >> per group is not a good idea (cfq already has I/O priorities to deal
> >> with single processes). Groups are coarse grain entities, and they
> >> should really be used when you need to get fairness between groups of
> >> processes.
> >>
> >
> > I think number of processes in the group will be a more dynamic
> > information that changes with time. For example, if we put a virtual
> > machine in a group, number of processes will vary depending on what
> > virtual machine is doing.
> Yes, this is one scenario. An other would be each user has a group, so
> the bandwidth is divided evenly between users, and an user cannot
> steal bandwidth by using more processes.
> The point is that using groups to control priorities between processes
> is not the best option.
> 
> >
> > I think group_idle is a more controllable parameter here. If some group
> > has higher weight but low load (like single process running), then should
> > we slow down the whole array and give the group exclusive access, or we
> > continue we just let slow group go away and continue to dispatch from rest
> > of the more active (but possibly low weight) groups. In first case
> > probably our latencies might be better as comapred to second case.
> As Alan's test shows, disabling group_idle doesn't actually improve
> the situation, since we already idle at the end of each tree.
> What you want is that if a no-idle service_tree is finished, you
> should immediately jump to an other no-idle service tree.
> Unfortunately, this would be equivalent to having just one global
> no-idle service tree, so the counter-arguments you did for my
> proposals still apply here.
> You can either get isolation, or performance. Not both at the same time.

Agreed.

Thanks
Vivek
