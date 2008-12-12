Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYLLKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYLLKBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYLLKBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:01:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYLLKBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:01:05 -0500
Date: Fri, 12 Dec 2008 11:00:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
Message-ID: <20081212100044.GB18152@elte.hu>
References: <494234B0.5@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494234B0.5@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> I fixed an oops with the following commit:
> 
> | commit 24eb089950ce44603b30a3145a2c8520e2b55bb1
> | Author: Li Zefan <lizf@cn.fujitsu.com>
> | Date:   Thu Nov 6 12:53:32 2008 -0800
> |
> |    cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
> |
> |    This fixes an oops when reading /proc/sched_debug.
> 
> The above commit fixed a race that reading /proc/sched_debug may access
> NULL cgrp->dentry if a cgroup is being removed.
> 
> But I found there's another different race, in that reading sched_debug
> may access a cgroup which hasn't been completed created, and thus
> dereference NULL cgrp->dentry!
> 
> cgroup_create()
>   cpu_cgroup_create()
>     register_fair_sched_group()
>       list_add_rcu(...)
> 				print_cfs_stats()
> 				  for_each_leaf_cfs_rq()
> 				    print_cfs_rq()
> 				      cgroup_path()
>   cgroup->dentry = dentry;
> 
> task_group is added to the global list before the cgroup has been created
> completely, if at this time print_cfs_stats() is called, it will access
> the half-created cgroup.
> 
> This patch fixes the bug by holding cgroup_lock() to wait the cgroup to
> be created completely before calling cgroup_path().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

applied to tip/sched/urgent, thanks!

> The patch is based on linus's git tree, and should go into 2.6.28,
> but it conflicts with the cleanup patch in sched/core:
> 	0a0db8f5c9d4bbb9bbfcc2b6cb6bce2d0ef4d73d

i merged it up in tip/master, could you please check whether it's ok?

	Ingo
