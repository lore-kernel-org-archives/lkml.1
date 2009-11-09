Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZKIXN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZKIXN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZKIXNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:13:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbZKIXNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:13:25 -0500
Date: Mon, 9 Nov 2009 18:12:57 -0500
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
Message-ID: <20091109231257.GG22860@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com> <20091106222257.GB2969@redhat.com> <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 10:47:48PM +0100, Corrado Zoccolo wrote:
> On Fri, Nov 6, 2009 at 11:22 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi All,
> >
> > I am now rebasing my patches to for-2.6.33 branch. There are significant
> > number of changes in that branch, especially changes from corrado bring
> > in an interesting question.
> >
> > Currently corrado has introduced the functinality of kind of grouping the
> > cfq queues based on workload type and gives the time slots to these sub
> > groups (sync-idle, sync-noidle, async).
> >
> > I was thinking of placing groups on top of this model, so that we select
> > the group first and then select the type of workload and then finally
> > the queue to run.
> >
> > Corrodo came up with an interesting suggestion (in a private mail), that
> > what if we implement workload type at top and divide the share among
> > groups with-in workoad type.
> >
> > So one would first select the workload to run and then select group
> > with-in workload and then cfq queue with-in group.
> >
> > The advantage of this approach are.
> >
> > - for sync-noidle group, we will not idle per group. We will idle only
> >  only at root level. (Well if we don't idle on the group once it becomes
> >  empty, we will not see fairness for group. So it will be fairness vs
> >  throughput call).
> >
> > - It allows us to limit system wide share of workload type. So for
> >  example, one can kind of fix system wide share of async queues.
> >  Generally it might not be very prudent to allocate a group 50% of
> >  disk share and then that group decides to just do async IO and sync
> >  IO in rest of the groups suffer.
> >
> > Disadvantage
> >
> > - The definition of fairness becomes bit murkier. Now fairness will be
> >  achieved for a group with-in the workload type. So if a group is doing
> >  IO of type sync-idle as well as sync-noidle and other group is doing
> >  IO of type only sync-noidle, then first group will get overall more
> >  disk time even if both the groups have same weight.
> 
> The fairness definition was always debated (disk time vs data transferred).
> I think that the two have both some reason to exist.
> Namely, disk time is good for sync-idle workloads, like sequential readers,
> while data transferred is good for sync-noidle workloads, like random readers.

I thought it was reverse. For sync-noidle workoads (typically seeky), we
do lot less IO and size of IO is not the right measure otherwise most of
the disk time we will be giving to this sync-noidle queue/group and
sync-idle queues will be heavily punished in other groups.

time based fairness generally should work better on seeky media. As the
seek cost starts to come down, size of IO also starts making sense.

In fact on SSD, we do queue switching so fast and don't idle on the queue,
doing time accounting and providing fairness in terms of time is hard, for
the groups which are not continuously backlogged.

> Unfortunately, the two measures seems not comparable, so we seem
> obliged to schedule independently the two kinds of workloads.
> Actually, I think we can compute a feedback from each scheduling turn,
> that can be used to temporary alter weights in next turn, in order to
> reach long term fairness.

As one simple solution, I thought that on SSDs, one can think of using
higher level IO controlling policy instead of CFQ group scheduling.

Or, we bring in some measuer in CFQ for fairness based on size/amount of
IO.

Thanks
Vivek
