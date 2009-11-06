Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbZKFWYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbZKFWYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZKFWXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbZKFWXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:50 -0500
Date: Fri, 6 Nov 2009 17:22:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: [RFC] Workload type Vs Groups (Was: Re: [PATCH 02/20] blkio:
	Change CFQ to use CFS like queue time stamps)
Message-ID: <20091106222257.GB2969@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:18:15PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Wed, Nov 4, 2009 at 12:43 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Previously CFQ had one service tree where queues of all theree prio classes
> >  were being queued. One side affect of this time stamping approach is that
> >  now single tree approach might not work and we need to keep separate service
> >  trees for three prio classes.
> >
> Single service tree is no longer true in cfq for-2.6.33.
> Now we have a matrix of service trees, with first dimension being the
> priority class, and second dimension being the workload type
> (synchronous idle, synchronous no-idle, async).
> You can have a look at the series: http://lkml.org/lkml/2009/10/26/482 .
> It may have other interesting influences on your work, as the idle
> introduced at the end of the synchronous no-idle tree, that provides
> fairness also for seeky or high-think-time queues.
> 

Hi All,

I am now rebasing my patches to for-2.6.33 branch. There are significant
number of changes in that branch, especially changes from corrado bring
in an interesting question.

Currently corrado has introduced the functinality of kind of grouping the
cfq queues based on workload type and gives the time slots to these sub
groups (sync-idle, sync-noidle, async).

I was thinking of placing groups on top of this model, so that we select
the group first and then select the type of workload and then finally 
the queue to run.

Corrodo came up with an interesting suggestion (in a private mail), that
what if we implement workload type at top and divide the share among
groups with-in workoad type.

So one would first select the workload to run and then select group
with-in workload and then cfq queue with-in group.

The advantage of this approach are.

- for sync-noidle group, we will not idle per group. We will idle only
  only at root level. (Well if we don't idle on the group once it becomes
  empty, we will not see fairness for group. So it will be fairness vs
  throughput call).

- It allows us to limit system wide share of workload type. So for
  example, one can kind of fix system wide share of async queues.
  Generally it might not be very prudent to allocate a group 50% of
  disk share and then that group decides to just do async IO and sync
  IO in rest of the groups suffer.

Disadvantage

- The definition of fairness becomes bit murkier. Now fairness will be 
  achieved for a group with-in the workload type. So if a group is doing
  IO of type sync-idle as well as sync-noidle and other group is doing
  IO of type only sync-noidle, then first group will get overall more
  disk time even if both the groups have same weight.

Looking for some feedback about which appraoch makes more sense before I 
write patches.

Thanks
Vivek
