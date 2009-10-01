Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZJAGlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZJAGlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZJAGlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:41:22 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:38275 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZJAGlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:41:21 -0400
Date: Thu, 01 Oct 2009 15:41:25 +0900 (JST)
Message-Id: <20091001.154125.104044685.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: nauman@google.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: IO scheduler based IO controller V10
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090930110500.GA26631@redhat.com>
References: <20090929141049.GA12141@redhat.com>
	<20090930.174319.183036386.ryov@valinux.co.jp>
	<20090930110500.GA26631@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Sep 30, 2009 at 05:43:19PM +0900, Ryo Tsuruta wrote:
> > Hi Vivek,
> > 
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > I was thinking that elevator layer will do the merge of bios. So IO
> > > scheduler/elevator can time stamp the first bio in the request as it goes
> > > into the disk and again timestamp with finish time once request finishes.
> > > 
> > > This way higher layer can get an idea how much disk time a group of bios
> > > used. But on multi queue, if we dispatch say 4 requests from same queue,
> > > then time accounting becomes an issue.
> > > 
> > > Consider following where four requests rq1, rq2, rq3 and rq4 are
> > > dispatched to disk at time t0, t1, t2 and t3 respectively and these
> > > requests finish at time t4, t5, t6 and t7. For sake of simlicity assume
> > > time elapsed between each of milestones is t. Also assume that all these
> > > requests are from same queue/group.
> > > 
> > >         t0   t1   t2   t3  t4   t5   t6   t7
> > >         rq1  rq2  rq3 rq4  rq1  rq2  rq3 rq4
> > > 
> > > Now higher layer will think that time consumed by group is:
> > > 
> > > (t4-t0) + (t5-t1) + (t6-t2) + (t7-t3) = 16t
> > > 
> > > But the time elapsed is only 7t.
> > 
> > IO controller can know how many requests are issued and still in
> > progress. Is it not enough to accumulate the time while in-flight IOs
> > exist?
> > 
> 
> That time would not reflect disk time used. It will be follwoing.
> 
> (time spent waiting in CFQ queues) + (time spent in dispatch queue) +
> (time spent in disk)

In the case where multiple IO requests are issued from IO controller,
that time measurement is the time from when the first IO request is
issued until when the endio is called for the last IO request. Does
not it reflect disk time?

> > > Secondly if a different group is running only single sequential reader,
> > > there CFQ will be driving queue depth of 1 and time will not be running
> > > faster and this inaccuracy in accounting will lead to unfair share between
> > > groups.
> > >
> > > So we need something better to get a sense which group used how much of
> > > disk time.
> > 
> > It could be solved by implementing the way to pass on such information
> > from IO scheduler to higher layer controller.
> > 
> 
> How would you do that? Can you give some details exactly how and what
> information IO scheduler will pass to higher level IO controller so that IO
> controller can attribute right time to the group.

If you would like to know when the idle timer is expired, how about
adding a function to IO controller to be notified it from IO
scheduler? IO scheduler calls the function when the timer is expired.

> > > > How about making throttling policy be user selectable like the IO
> > > > scheduler and putting it in the higher layer? So we could support
> > > > all of policies (time-based, size-based and rate limiting). There
> > > > seems not to only one solution which satisfies all users. But I agree
> > > > with starting with proportional bandwidth control first. 
> > > > 
> > > 
> > > What are the cases where time based policy does not work and size based
> > > policy works better and user would choose size based policy and not timed
> > > based one?
> > 
> > I think that disk time is not simply proportional to IO size. If there
> > are two groups whose wights are equally assigned and they issue
> > different sized IOs repsectively, the bandwidth of each group would
> > not distributed equally as expected. 
> > 
> 
> If we are providing fairness in terms of time, it is fair. If we provide
> equal time slots to two processes and if one got more IO done because it
> was not wasting time seeking or it issued bigger size IO, it deserves that
> higher BW. IO controller will make sure that process gets fair share in
> terms of time and exactly how much BW one got will depend on the workload.
> 
> That's the precise reason that fairness in terms of time is better on
> seeky media.

If the seek time is negligible, the bandwidth would not be distributed 
according to a proportion of weight settings. I think that it would be
unclear for users to understand how bandwidth is distributed. And I
also think that seeky media would gradually become obsolete,

> > > I am not against implementing things in higher layer as long as we can
> > > ensure tight control on latencies, strong isolation between groups and
> > > not break CFQ's class and ioprio model with-in group.
> > > 
> > > > BTW, I will start to reimplement dm-ioband into block layer.
> > > 
> > > Can you elaborate little bit on this?
> > 
> > bio is grabbed in generic_make_request() and throttled as well as
> > dm-ioband's mechanism. dmsetup command is not necessary any longer.
> > 
> 
> Ok, so one would not need dm-ioband device now, but same dm-ioband
> throttling policies will apply. So until and unless we figure out a
> better way, the issues I have pointed out will still exists even in
> new implementation.

Yes, those still exist, but somehow I would like to try to solve them.

> > The default value of io_limit on the previous test was 128 (not 192)
> > which is equall to the default value of nr_request.
> 
> Hm..., I used following commands to create two ioband devices.
> 
> echo "0 $(blockdev --getsize /dev/sdb2) ioband /dev/sdb2 1 0 0 none"
> "weight 0 :100" | dmsetup create ioband1
> echo "0 $(blockdev --getsize /dev/sdb3) ioband /dev/sdb3 1 0 0 none"
> "weight 0 :100" | dmsetup create ioband2
> 
> Here io_limit value is zero so it should pick default value. Following is
> output of "dmsetup table" command.
> 
> ioband2: 0 89899740 ioband 8:19 1 4 192 none weight 768 :100
> ioband1: 0 41961780 ioband 8:18 1 4 192 none weight 768 :100
>                                     ^^^^
> IIUC, above number 192 is reflecting io_limit? If yes, then default seems
> to be 192?

The default vaule has changed since v1.12.0 and increased from 128 to 192.

> > > I set it up to 256 as you suggested. I still see writer starving reader. I
> > > have removed "conv=fdatasync" from writer so that a writer is pure buffered
> > > writes.
> > 
> > O.K. You removed "conv=fdatasync", the new dm-ioband handles
> > sync/async requests separately, and it solves this
> > buffered-write-starves-read problem. I would like to post it soon
> > after doing some more test.
> > 
> > > On top of that can you please give some details how increasing the
> > > buffered queue length reduces the impact of writers?
> > 
> > When the number of in-flight IOs exceeds io_limit, processes which are
> > going to issue IOs are made sleep by dm-ioband until all the in-flight
> > IOs are finished. But IO scheduler layer can accept IO requests more
> > than the value of io_limit, so it was a bottleneck of the throughput.
> > 
> 
> Ok, so it should have been throughput bottleneck but how did it solve the
> issue of writer starving the reader as you had mentioned in the mail.

As wrote above, I modified dm-ioband to handle sync/async requests
separately, so even if writers do a lot of buffered IOs, readers can
issue IOs regardless writers' busyness. Once the IOs are backlogged
for throttling, the both sync and async requests are issued according
to the other of arrival.

> Secondly, you mentioned that processes are made to sleep once we cross 
> io_limit. This sounds like request descriptor facility on requeust queue
> where processes are made to sleep.
>
> There are threads in kernel which don't want to sleep while submitting
> bios. For example, btrfs has bio submitting thread which does not want
> to sleep hence it checks with device if it is congested or not and not
> submit the bio if it is congested.  How would you handle such cases. Have
> you implemented any per group congestion kind of interface to make sure
> such IO's don't sleep if group is congested.
>
> Or this limit is per ioband device which every group on the device is
> sharing. If yes, then how would you provide isolation between groups 
> because if one groups consumes io_limit tokens, then other will simply
> be serialized on that device?

There are two kind of limit and both limit the number of IO requests
which can be issued simultaneously, but one is for per ioband device, 
the other is for per ioband group. The per group limit assigned to
each group is calculated by dividing io_limit according to their
proportion of weight.

The kernel thread is not made to sleep by the per group limit, because
several kinds of kernel threads submit IOs from multiple groups and
for multiple devices in a single thread. At this time, the kernel
thread is made to sleep by the per device limit only.

Thanks,
Ryo Tsuruta
