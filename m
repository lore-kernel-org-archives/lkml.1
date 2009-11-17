Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZKQQmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZKQQmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZKQQmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:42:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbZKQQmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:42:10 -0500
Date: Tue, 17 Nov 2009 11:40:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091117164026.GE22462@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091117141411.GA22462@redhat.com> <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 05:17:53PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> the performance drop reported by Alan was my main concern about your
> approach. Probably you should mention/document somewhere that when the
> number of groups is too large, there is large decrease in random read
> performance.
> 

Hi Corrodo,

I thought more about it. We idle on sync-noidle group only in case of 
rotational media not supporting NCQ (hw_tag = 0). So for all the fast
hardware out there (SSD and fast arrays), we should not be idling on 
sync-noidle group hence should not additional idling per group.

This is all subjected to the fact that we have done a good job in
detecting the queue depth and have updated hw_tag accordingly.

On slower rotational hardware, where we will actually do idling on
sync-noidle per group, idling can infact help you because it will reduce
the number of seeks (As it does on my locally connected SATA disk).

> However, we can check few things:
> * is this kernel built with HZ < 1000? The smallest idle CFQ will do
> is given by 2/HZ, so running with a small HZ will increase the impact
> of idling.
> 
> On Tue, Nov 17, 2009 at 3:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Regarding the reduced throughput for random IO case, ideally we should not
> > idle on sync-noidle group on this hardware as this seems to be a fast NCQ
> > supporting hardware. But I guess we might not be detecting the queue depth
> > properly which leads to idling on per group sync-noidle workload and
> > forces the queue depth to be 1.
> 
> * This can be ruled out testing my NCQ detection fix patch
> (http://groups.google.com/group/linux.kernel/browse_thread/thread/3b62f0665f0912b6/34ec9456c7da1bb7?lnk=raot)

This will be a good patch to test here. Alan, can you also apply this
patch and see if we see any improvement.

My core concern is that hardware Alan is testing on is a fast NCQ
supporting hardware and we should see hw_tag=1 and hence no idling on 
sync-noidle group should happen.

> 
> However, my feeling is that the real problem is having multiple
> separate sync-noidle trees.
> Inter group idle is marginal, since each sync-noidle tree already has
> its end-of-tree idle enabled for rotational devices (The difference in
> the table is in fact small).
> > ---- ---- - ----------- ----------- ----------- -----------
> > Mode RdWr N    base       ioc off   ioc no idle  ioc idle
> > ---- ---- - ----------- ----------- ----------- -----------
> >  rnd   rd 2        17.3        17.1         9.4         9.1
> >  rnd   rd 4        27.1        27.1         8.1         8.2
> >  rnd   rd 8        37.1        37.1         6.8         7.1
> 
> 2 random readers without groups have bw = 17.3 ; this means that a
> single random reader will have bw > 8.6 (since the two readers go
> usually in parallel when no groups are involved, unless two random
> reads are actually queued to the same disk).
> 

Agreed. Without groups I guess we are driving queue depth as 2 hence
two random readers are able to work in paralle. Because this is striped
array of multiple disks, there are chances that reads will happen on
different disks and we can support more random readers in parallel without
dropping the throughput of box. 

> When the random readers are in separate groups, we give the full disk
> to only one at a time, so the max aggregate bw achievable is the bw of
> a single random reader less the overhead proportional to number of
> groups. This is compatible with the numbers.
> 

Yes it is but with group_idle=0, we don't wait for a group to get
backlogged. So in that case we should have been driving queue depth as 2
and allow both the groups go in parallel. But looking at Alan's number
with with group_ilde=0, he is not achieving close to 17MB/s and I suspect
this is coming from that fact that hw_tag=0 somehow and we are idling on
sync-nodile workload hence effectively driving queue depth as 1.

> So, an other thing to mention in the docs is that having one process
> per group is not a good idea (cfq already has I/O priorities to deal
> with single processes). Groups are coarse grain entities, and they
> should really be used when you need to get fairness between groups of
> processes.
> 

I think number of processes in the group will be a more dynamic
information that changes with time. For example, if we put a virtual
machine in a group, number of processes will vary depending on what
virtual machine is doing.

I think group_idle is a more controllable parameter here. If some group
has higher weight but low load (like single process running), then should
we slow down the whole array and give the group exclusive access, or we
continue we just let slow group go away and continue to dispatch from rest
of the more active (but possibly low weight) groups. In first case
probably our latencies might be better as comapred to second case.  

But more I look at it, sounds like on fast arrays, waiting for slow groups
does not sound very good. It might make sense on rotational hardware with
single disk head, though.

> * An other thing to do is to try setting rotational = 0, since even

what is rotational=0? Can't find any such tunable variable?

Thanks
Vivek

> with NCQ correctly detected, if the device is rotational, we still
> introduce some idle delays (that are good in the root group, but not
> when you have multiple groups).
> 
> >
> > I am also trying to setup a higher end system here and will do some
> > experiments.
> >
> > Thanks
> > Vivek
> 
> Thanks,
> Corrado
