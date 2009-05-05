Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZEEKLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZEEKLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZEEKLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:11:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbZEEKLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:11:33 -0400
Date: Tue, 5 May 2009 12:11:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@android.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] oom: fix possible oom_dump_tasks NULL pointer
Message-ID: <20090505101132.GA28917@wotan.suse.de>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com> <alpine.DEB.2.00.0905041725330.11756@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905041725330.11756@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 05:27:02PM -0700, David Rientjes wrote:
> When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
> pointer for tasks that have detached mm's since task_lock() is not held
> during the tasklist scan.
> 
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>

I hope I'm not the oom killer maintainer ;) But anyway,

Acked-by: Nick Piggin <npiggin@suse.de>


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
