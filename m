Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYLOKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYLOKoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYLOKoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:44:02 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:4346 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYLOKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:43:54 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49462890.1040002@cn.fujitsu.com>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>
	 <4944754F.8050503@cn.fujitsu.com>
	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	 <4945B200.7020207@cn.fujitsu.com> <1229328783.14605.11.camel@twins>
	 <49462890.1040002@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 11:43:49 +0100
Message-Id: <1229337829.14605.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 17:51 +0800, Li Zefan wrote:
> >>> Can't we detect a dead task-group and skip those instead of adding this
> >>> global lock?
> >>>
> >> I tried it, but I don't think it's feasable, without lock syncronization:
> >>
> >> 			     | print_cfs_rq()
> >> 			     |   check task_group is dead
> >>   cgroup_diput()	     |
> >>     ..			     |
> >>     mark task_group as dead  |
> >>     ..			     |
> >>     kfree(cgrp)		     |
> >> 			     |   call cgroup_path()
> > 
> > rcu free cgrp
> > 
> 
> I got your point, thanks.
> 
> Another way is use css_tryget(), and thus can avoid touching cgroup.c and adding
> synchronize_rcu(). css_tryget() is proposed by Kamezawa but I think won't be
> available until 2.6.29.
> 
> Anyway, here is the fix. I'll post a complete version with changelog when we
> agree on how to fix it.

Yeah, the below looks like a suitable fix.

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c      |    6 ++++++
>  kernel/sched_debug.c |   17 +++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index fe00b3b..3c54d1b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -624,6 +624,12 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  		 * created the cgroup */
>  		deactivate_super(cgrp->root->sb);
>  
> +		/*
> +		 * Some subsystems (cpu cgroup) might still be able to
> +		 * accessing the cgroup in rcu section.
> +		 */
> +		synchronize_rcu();
> +
>  		kfree(cgrp);
>  	}
>  	iput(inode);

Is there any reason we cannot use call_rcu() ?

> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 26ed8e3..174c072 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -127,8 +127,14 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>  	if (tg)
>  		cgroup = tg->css.cgroup;
>  
> -	if (cgroup)
> +	if (cgroup) {
> +		/*
> +		 * This task_group is dead or we race with cgroup creating.
> +		 */
> +                if (cgroup_is_removed(cgroup) || !cgroup->dentry)
> +                        return;
>  		cgroup_path(cgroup, path, sizeof(path));
> +	}

Perhaps wrap that check in a cgroup_*() helper? That would avoid the
duplication, be clearer and not open code the ->dentry assumption.

cgroup_is_active() perhaps?

>  	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
>  #else
> @@ -181,8 +187,15 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
>  	if (tg)
>  		cgroup = tg->css.cgroup;
>  
> -	if (cgroup)
> +	if (cgroup) {
> +		/*
> +		 * This task_group is dead or we race with cgroup creating.
> +		 */
> +		if (cgroup_is_removed(cgroup) || !cgroup->dentry)
> +			return;
> +
>  		cgroup_path(cgroup, path, sizeof(path));
> +	}
>  
>  	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
>  #else

