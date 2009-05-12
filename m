Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZELJiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZELJiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZELJig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:38:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37327 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZELJif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:38:35 -0400
Date: Tue, 12 May 2009 10:38:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11 -mmotm] oom: fix possible oom_dump_tasks NULL
	pointer
Message-ID: <20090512093832.GC25923@csn.ul.ie>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101501050.18804@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905101501050.18804@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 03:07:16PM -0700, David Rientjes wrote:
> When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
> pointer for tasks that have detached mm's since task_lock() is not held
> during the tasklist scan.
> 
> Acked-by: Nick Piggin <npiggin@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>

Minor nit. The Acked-by should come after the Signed-off-by.

The window during which p->mm was a valid point and become an invalid
one is *extremely* small but sure, it's there.

Acked-by: Mel Gorman <mel@csn.ul.ie>

I would have preferred if the core VM patches were in a different set to
the driver patches. Maybe there is an interdependency later but this patch
at least looks standalone.

> ---
>  mm/oom_kill.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -284,22 +284,28 @@ static void dump_tasks(const struct mem_cgroup *mem)
>  	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
>  	       "name\n");
>  	do_each_thread(g, p) {
> -		/*
> -		 * total_vm and rss sizes do not exist for tasks with a
> -		 * detached mm so there's no need to report them.
> -		 */
> -		if (!p->mm)
> -			continue;
> +		struct mm_struct *mm;
> +
>  		if (mem && !task_in_mem_cgroup(p, mem))
>  			continue;
>  		if (!thread_group_leader(p))
>  			continue;
>  
>  		task_lock(p);
> +		mm = p->mm;
> +		if (!mm) {
> +			/*
> +			 * total_vm and rss sizes do not exist for tasks with no
> +			 * mm so there's no need to report them; they can't be
> +			 * oom killed anyway.
> +			 */
> +			task_unlock(p);
> +			continue;
> +		}
>  		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
> -		       p->pid, __task_cred(p)->uid, p->tgid,
> -		       p->mm->total_vm, get_mm_rss(p->mm), (int)task_cpu(p),
> -		       p->oomkilladj, p->comm);
> +		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
> +		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
> +		       p->comm);
>  		task_unlock(p);
>  	} while_each_thread(g, p);
>  }
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
