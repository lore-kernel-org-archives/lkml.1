Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab0BQJgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:36:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:50831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab0BQJgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:36:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TtLXJnILQiQxnY26l0iPBA8EJQVbuO057hEfhp3DTpLAQGzF0eeroboulC4sSQQf8
	osX39fe1NasOi78N/O4aw==
Date: Wed, 17 Feb 2010 01:36:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm] Kill existing current task quickly
In-Reply-To: <28c262361002162226k7ec561cenf84f494618fa8c54@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1002170128230.30931@chino.kir.corp.google.com>
References: <1266335957.1709.67.camel@barrios-desktop> <alpine.DEB.2.00.1002161357170.23037@chino.kir.corp.google.com> <28c262361002162226k7ec561cenf84f494618fa8c54@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Minchan Kim wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 3618be3..d5e3d70 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -32,6 +32,8 @@ int sysctl_panic_on_oom;
>  int sysctl_oom_kill_allocating_task;
>  int sysctl_oom_dump_tasks;
>  static DEFINE_SPINLOCK(zone_scan_lock);
> +
> +unsigned int nr_memdie; /* count of TIF_MEMDIE processes */
>  /* #define DEBUG */
> 
>  /*
> @@ -295,6 +297,8 @@ static struct task_struct
> *select_bad_process(unsigned long *ppoints,
> 
>                         chosen = p;
>                         *ppoints = ULONG_MAX;
> +                       if (nr_memdie == 0)
> +                               break;
>                 }
> 
>                 if (p->signal->oom_adj == OOM_DISABLE)

Nack, finding a candidate task with TIF_MEMDIE set is not the only time we 
return ERR_PTR(-1UL) from select_bad_process(): we also do it if any other 
task other than current is PF_EXITING.  Thus, we _must_ continue the 
tasklist scan to avoid needlessly killing current simply because it was 
the first PF_EXITING task in the tasklist.

> @@ -403,8 +407,6 @@ static void __oom_kill_task(struct task_struct *p,
> int verbose)
>                        K(p->mm->total_vm),
>                        K(get_mm_counter(p->mm, MM_ANONPAGES)),
>                        K(get_mm_counter(p->mm, MM_FILEPAGES)));
> -       task_unlock(p);
> -
>         /*
>          * We give our sacrificial lamb high priority and access to
>          * all the memory it needs. That way it should be able to
> @@ -412,7 +414,11 @@ static void __oom_kill_task(struct task_struct
> *p, int verbose)
>          */
>         p->rt.time_slice = HZ;
>         set_tsk_thread_flag(p, TIF_MEMDIE);
> -
> +       /*
> +        * nr_memdie is protected by task_lock.
> +        */
> +       nr_memdie++;
> +       task_unlock(p);
>         force_sig(SIGKILL, p);
>  }
> 

task_lock() is a per-task entity, i.e. each task_struct has an alloc_lock 
spinlock.  This cannot protect a global variable.
