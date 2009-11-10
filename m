Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZKJONI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZKJONI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZKJONG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:13:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZKJONF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:13:05 -0500
Date: Tue, 10 Nov 2009 09:12:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC] Workload type Vs Groups (Was: Re: [PATCH 02/20] blkio:
	Change CFQ to use CFS like queue time stamps)
Message-ID: <20091110141246.GB1083@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com> <20091106222257.GB2969@redhat.com> <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com> <20091109231257.GG22860@redhat.com> <4e5e476b0911100329v5da70aedj4a943c4b0220cee8@mail.gmail.com> <20091110133113.GA1083@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110133113.GA1083@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 08:31:13AM -0500, Vivek Goyal wrote:
> On Tue, Nov 10, 2009 at 12:29:30PM +0100, Corrado Zoccolo wrote:
> > On Tue, Nov 10, 2009 at 12:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > I thought it was reverse. For sync-noidle workoads (typically seeky), we
> > > do lot less IO and size of IO is not the right measure otherwise most of
> > > the disk time we will be giving to this sync-noidle queue/group and
> > > sync-idle queues will be heavily punished in other groups.
> > 
> > This happens only if you try to measure both sequential and seeky with
> > the same metric.
> 
> Ok, we seem to be discussing many things. I will try to pull it back on
> core points.
> 
> To me there are only two key questions.
> 
> - Whether workload type should be on topmost layer or groups should be on
>   topmost layer.
> 
> - How to define fairness in case of NCQ SSD where idling hurts and we
>   don't choose to idle.
> 
> 
> For the first issue, if we keep workoad type on top, then we weaken the
> isolation between groups. We provide isolation between only same kind of
> workload type and not across the workloads types.
> 
> So if a group is running only sequential readers and other group is runnig
> random seeky reaeder, then share of second group is not determined by the
> group weight but the number of queues in first group.
> 
> Hence as we increase number of queues in first group, share of second
> group keep on coming down. This kind of implies that sequential reads
> in first group are more important as comapred to random seeky reader in
> second group. But in this case the relative importance of workload is
> specifed by the user with the help of cgroups and weights and IO scheduler
> should honor that.
> 
> So to me, groups on topmost layer makes more sense than having workload
> type on topmost layer.
> 
> > >
> > > time based fairness generally should work better on seeky media. As the
> > > seek cost starts to come down, size of IO also starts making sense.
> > >
> > > In fact on SSD, we do queue switching so fast and don't idle on the queue,
> > > doing time accounting and providing fairness in terms of time is hard, for
> > > the groups which are not continuously backlogged.
> > The mechanism in place still gives fairness in terms of I/Os for SSDs.
> > One queue is not even nearly backlogged, then there is no point in
> > enforcing fairness for it so that the backlogged one gets lower
> > bandwidth, but the not backlogged one doesn't get higher (since it is
> > limited by its think time).
> > 
> > For me fairness for SSDs should happen only when the total BW required
> > by all the queues is more than the one the disk can deliver, or the
> > total number of active queues is more than NCQ depth. Otherwise, each
> > queue will get exactly the bandwidth it wants, without affecting the
> > others, so no idling should happen. In the mentioned cases, instead,
> > no idling needs to be added, since the contention for resource will
> > already introduce delays.
> > 
> 
> Ok, above is pertinent for the second issue of not idling on NCQ SSDs as
> it hurts and brings down the overall throughput. I tend to agree here,
> that idling on queues limited by think time does not make much sense on
> NCQ SSD. In this case probably fairness will be defined by how many a
> times a group got scheduled in for dispatch. If group has higher weight
> then it should be able to dispatch more times (in proportionate ratio),
> as compared to group lower weight group.
> 
> We should be able to achieve this without idling hence overall thoughtput
> of the system should also be good. The only catch here is that it will be
> hard to achieve this behavior if group is not continuously backlogged.
> 
> You seem to be suggesting that current CFQ formula for calculating slice
> offset provides take care of that. Looking at the formula I can't
> understand how does it enable dispatch from a queue in proportion to
> weight or priority. I will do some experiments on my NCQ SSD and do
> more discussion on this aspect later.
> 

Ok, I ran some simple tests on my NCQ SSD. I had pulled the Jen's branch
few days back and it has your patches in it.

I am running three direct sequential readers or prio 0, 4 and 7
respectively using fio for 10 seconds and then monitoring who got how
much job done.

Following is my fio job file

****************************************************************
[global]
ioengine=sync
runtime=10
size=1G
rw=read
directory=/mnt/sdc/fio/
direct=1
bs=4K
exec_prerun="echo 3 > /proc/sys/vm/drop_caches"

[seqread0]
prio=0

[seqread4]
prio=4

[seqread7]
prio=7
************************************************************************

Following are the results of 4 runs. Every run lists three jobs of prio0,
prio4 and prio7 respectively.

First run
=========
read : io=75,996KB, bw=7,599KB/s, iops=1,899, runt= 10001msec
read : io=95,920KB, bw=9,591KB/s, iops=2,397, runt= 10001msec
read : io=21,068KB, bw=2,107KB/s, iops=526, runt= 10001msec

Second run
==========
read : io=103MB, bw=10,540KB/s, iops=2,635, runt= 10001msec
read : io=102MB, bw=10,479KB/s, iops=2,619, runt= 10001msec
read : io=720KB, bw=73,728B/s, iops=18, runt= 10000msec

Third Run
=========
read : io=103MB, bw=10,532KB/s, iops=2,632, runt= 10001msec
read : io=85,728KB, bw=8,572KB/s, iops=2,142, runt= 10001msec
read : io=19,696KB, bw=1,969KB/s, iops=492, runt= 10001msec

Fourth Run
==========
read : io=50,060KB, bw=5,005KB/s, iops=1,251, runt= 10001msec
read : io=102MB, bw=10,409KB/s, iops=2,602, runt= 10001msec
read : io=54,844KB, bw=5,484KB/s, iops=1,370, runt= 10001msec

I can't see fairness being provided to processes of diff prio levels. In
first run prio4 got more BW than prio0 process.

In second run prio 7 process got completely starved. Based on slice
calculation, the difference between prio 0 and prio 7 should be 180/40=4.5

Third run is still better.

In fourth run again prio 4 got double the BW of prio 0.

So I can't see how are you achieving fariness on NCQ SSD?

One more important thing to notice is that throughput of SSD has come down
significantly. If I just run one job then I get 73MB/s. With these tree
jobs running, we are achieving close to 19 MB/s. 

I think this is happening because of seeks happening almost after every
dispatch and that brings down the overall throughput. If we had idled
here, I think probably overall throughput would have been better.

Thanks
Vivek
