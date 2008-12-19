Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbYLSEhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbYLSEhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYLSEhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:37:12 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49476 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbYLSEhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:37:10 -0500
Date: Fri, 19 Dec 2008 10:07:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
Message-ID: <20081219043702.GA5453@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
	Paul Menage <menage@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu> <4944754F.8050503@cn.fujitsu.com> <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-12-14 13:48:10]:

> On Sun, 2008-12-14 at 10:54 +0800, Li Zefan wrote:
> > > i merged it up in tip/master, could you please check whether it's ok?
> > > 
> > 
> > Sorry, though this patch avoids accessing a half-created cgroup, but I found
> > current code may access a cgroup which has been destroyed.
> > 
> > The simplest fix is to take cgroup_lock() before for_each_leaf_cfs_rq.
> > 
> > Could you revert this patch and apply the following new one? My box has
> > survived for 16 hours with it applied.
> > 
> > ==========
> > 
> > From: Li Zefan <lizf@cn.fujitsu.com>
> > Date: Sun, 14 Dec 2008 09:53:28 +0800
> > Subject: [PATCH] sched: fix another race when reading /proc/sched_debug
> > 
> > I fixed an oops with the following commit:
> > 
> > | commit 24eb089950ce44603b30a3145a2c8520e2b55bb1
> > | Author: Li Zefan <lizf@cn.fujitsu.com>
> > | Date:   Thu Nov 6 12:53:32 2008 -0800
> > |
> > |    cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
> > |
> > |    This fixes an oops when reading /proc/sched_debug.
> > 
> > The above commit fixed a race that reading /proc/sched_debug may access
> > NULL cgrp->dentry if a cgroup is being removed (via cgroup_rmdir), but
> > hasn't been destroyed (via cgroup_diput).
> > 
> > But I found there's another different race, in that reading sched_debug
> > may access a cgroup which is being created or has been destroyed, and thus
> > dereference NULL cgrp->dentry!
> > 
> > task_group is added to the global list while the cgroup is being created,
> > and is removed from the global list while the cgroup is under destruction.
> > So running through the list should be protected by cgroup_lock(), if
> > cgroup data will be accessed (here by calling cgroup_path).
> 
> Can't we detect a dead task-group and skip those instead of adding this
> global lock?
> 

Now we can, there is a css_is_removed() function.

-- 
	Balbir
