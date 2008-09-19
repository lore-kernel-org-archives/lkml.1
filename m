Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbYISD3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbYISD3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 23:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYISD3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 23:29:21 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:32914 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbYISD3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 23:29:21 -0400
Message-ID: <48D31C59.7050404@linux.vnet.ibm.com>
Date: Thu, 18 Sep 2008 20:28:25 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: righi.andrea@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] memrlimit: fix task_lock() recursive locking (v2)
References: <48D2CD1D.9040202@gmail.com>
In-Reply-To: <48D2CD1D.9040202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:

> Since we hold task_lock(), we know that p->mm cannot change and we don't have
> to worry about incrementing mm_users. So, just use p->mm directly and
> check that we've not picked a kernel thread.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  kernel/cgroup.c      |    3 ++-
>  mm/memrlimitcgroup.c |   10 ++++------
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 678a680..03cc925 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2757,7 +2757,8 @@ void cgroup_fork_callbacks(struct task_struct *child)
>   * invoke this routine, since it assigns the mm->owner the first time
>   * and does not change it.
>   *
> - * The callbacks are invoked with mmap_sem held in read mode.
> + * The callbacks are invoked with task_lock held and mmap_sem held in read
> + * mode.
>   */
>  void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
>  {
> diff --git a/mm/memrlimitcgroup.c b/mm/memrlimitcgroup.c
> index 8ee74f6..b3d20f5 100644
> --- a/mm/memrlimitcgroup.c
> +++ b/mm/memrlimitcgroup.c
> @@ -238,7 +238,7 @@ out:
>  }
> 
>  /*
> - * This callback is called with mmap_sem held
> + * This callback is called with mmap_sem and task_lock held
>   */
>  static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  						struct cgroup *old_cgrp,
> @@ -246,9 +246,9 @@ static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  						struct task_struct *p)
>  {
>  	struct memrlimit_cgroup *memrcg, *old_memrcg;
> -	struct mm_struct *mm = get_task_mm(p);
> +	struct mm_struct *mm = p->mm;
> 
> -	BUG_ON(!mm);
> +	BUG_ON(!mm || (p->flags & PF_KTHREAD));
> 
>  	/*
>  	 * If we don't have a new cgroup, we just uncharge from the old one.
> @@ -258,7 +258,7 @@ static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  		memrcg = memrlimit_cgroup_from_cgrp(cgrp);
>  		if (res_counter_charge(&memrcg->as_res,
>  				mm->total_vm << PAGE_SHIFT))
> -			goto out;
> +			return;
>  	}
> 
>  	if (old_cgrp) {
> @@ -266,8 +266,6 @@ static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  		res_counter_uncharge(&old_memrcg->as_res,
>  				mm->total_vm << PAGE_SHIFT);
>  	}
> -out:
> -	mmput(mm);
>  }

Seems reasonable

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
