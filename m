Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbXE3Vqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbXE3Vqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXE3Vpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:45:53 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759900AbXE3Vpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:45:52 -0400
Date: Wed, 30 May 2007 14:45:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 3/8] Add container pointer on mm_struct
Message-Id: <20070530144512.4984a56c.akpm@linux-foundation.org>
In-Reply-To: <465D9856.8050303@openvz.org>
References: <465D9739.8070209@openvz.org>
	<465D9856.8050303@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 19:29:26 +0400
Pavel Emelianov <xemul@openvz.org> wrote:

> Naturally mm_struct determines the resource consumer in memory
> accounting. So each mm_struct should have a pointer on container
> it belongs to. When a new task is created its mm_struct is
> assigned to the container this task belongs to.
> 
>
> 
> diff -upr linux-2.6.22-rc2-mm1.orig/include/linux/sched.h linux-2.6.22-rc2-mm1-0/include/linux/sched.h
> --- linux-2.6.22-rc2-mm1.orig/include/linux/sched.h	2007-05-30 16:13:08.000000000 +0400
> +++ linux-2.6.22-rc2-mm1-0/include/linux/sched.h	2007-05-30 16:13:09.000000000 +0400
> @@ -390,6 +390,9 @@ struct mm_struct {
>  	/* aio bits */
>  	rwlock_t		ioctx_list_lock;
>  	struct kioctx		*ioctx_list;
> +#ifdef CONFIG_RSS_CONTAINER
> +	struct rss_container	*rss_container;
> +#endif
>  };
>  
>  struct sighand_struct {
> diff -upr linux-2.6.22-rc2-mm1.orig/kernel/fork.c linux-2.6.22-rc2-mm1-0/kernel/fork.c
> --- linux-2.6.22-rc2-mm1.orig/kernel/fork.c	2007-05-30 16:13:08.000000000 +0400
> +++ linux-2.6.22-rc2-mm1-0/kernel/fork.c	2007-05-30 16:13:09.000000000 +0400
> @@ -57,6 +57,8 @@
>  #include <asm/cacheflush.h>
>  #include <asm/tlbflush.h>
>  
> +#include <linux/rss_container.h>
> +
>  /*
>   * Protected counters by write_lock_irq(&tasklist_lock)
>   */
> @@ -329,7 +331,7 @@ static inline void mm_free_pgd(struct mm
>  
>  #include <linux/init_task.h>
>  
> -static struct mm_struct * mm_init(struct mm_struct * mm)
> +static struct mm_struct * mm_init(struct mm_struct *mm, struct task_struct *tsk)
>  {
>  	atomic_set(&mm->mm_users, 1);
>  	atomic_set(&mm->mm_count, 1);
> @@ -344,11 +346,14 @@ static struct mm_struct * mm_init(struct
>  	mm->ioctx_list = NULL;
>  	mm->free_area_cache = TASK_UNMAPPED_BASE;
>  	mm->cached_hole_size = ~0UL;
> +	mm_init_container(mm, tsk);

mm_init_container() doesn't get added until the next patch, so you just
broke git-bisect.

Please try to ensure that the kernel builds and runs at each stage of your
patch series.  You can assume that your newly-added CONFIG_ items are set
to =n for this purpose.

