Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYLOINS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYLOINS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYLOING
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:13:06 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:20681 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYLOINF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:13:05 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4945B200.7020207@cn.fujitsu.com>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>
	 <4944754F.8050503@cn.fujitsu.com>
	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	 <4945B200.7020207@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 09:13:03 +0100
Message-Id: <1229328783.14605.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 09:25 +0800, Li Zefan wrote:
> Peter Zijlstra wrote:
> > On Sun, 2008-12-14 at 10:54 +0800, Li Zefan wrote:
> >>> i merged it up in tip/master, could you please check whether it's ok?
> >>>
> >> Sorry, though this patch avoids accessing a half-created cgroup, but I found
> >> current code may access a cgroup which has been destroyed.
> >>
> >> The simplest fix is to take cgroup_lock() before for_each_leaf_cfs_rq.
> >>
> >> Could you revert this patch and apply the following new one? My box has
> >> survived for 16 hours with it applied.
> >>
> >> ==========
> >>
> >> From: Li Zefan <lizf@cn.fujitsu.com>
> >> Date: Sun, 14 Dec 2008 09:53:28 +0800
> >> Subject: [PATCH] sched: fix another race when reading /proc/sched_debug
> >>
> >> I fixed an oops with the following commit:
> >>
> >> | commit 24eb089950ce44603b30a3145a2c8520e2b55bb1
> >> | Author: Li Zefan <lizf@cn.fujitsu.com>
> >> | Date:   Thu Nov 6 12:53:32 2008 -0800
> >> |
> >> |    cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
> >> |
> >> |    This fixes an oops when reading /proc/sched_debug.
> >>
> >> The above commit fixed a race that reading /proc/sched_debug may access
> >> NULL cgrp->dentry if a cgroup is being removed (via cgroup_rmdir), but
> >> hasn't been destroyed (via cgroup_diput).
> >>
> >> But I found there's another different race, in that reading sched_debug
> >> may access a cgroup which is being created or has been destroyed, and thus
> >> dereference NULL cgrp->dentry!
> >>
> >> task_group is added to the global list while the cgroup is being created,
> >> and is removed from the global list while the cgroup is under destruction.
> >> So running through the list should be protected by cgroup_lock(), if
> >> cgroup data will be accessed (here by calling cgroup_path).
> > 
> > Can't we detect a dead task-group and skip those instead of adding this
> > global lock?
> > 
> 
> I tried it, but I don't think it's feasable, without lock syncronization:
> 
> 			     | print_cfs_rq()
> 			     |   check task_group is dead
>   cgroup_diput()	     |
>     ..			     |
>     mark task_group as dead  |
>     ..			     |
>     kfree(cgrp)		     |
> 			     |   call cgroup_path()

rcu free cgrp



