Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbZLQHVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbZLQHVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbZLQHVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:21:20 -0500
Received: from www84.your-server.de ([213.133.104.84]:38488 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbZLQHVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:21:20 -0500
Subject: Re: [PATCH 2/6] NOMMU: Provide per-task stack usage through /proc
 for NOMMU
From: Stefani Seibold <stefani@seibold.net>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, vapier@gentoo.org,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       uclinux-dev@uclinux.org, Robin Getz <rgetz@blackfin.uclinux.org>
In-Reply-To: <20091216235603.4310.71243.stgit@warthog.procyon.org.uk>
References: <20091216235558.4310.19365.stgit@warthog.procyon.org.uk>
	 <20091216235603.4310.71243.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Dec 2009 08:21:12 +0100
Message-ID: <1261034472.31163.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 16.12.2009, 23:56 +0000 schrieb David Howells:
> Make it possible to get the per-task stack usage through /proc on a NOMMU
> system.  The MMU-mode routine can't be used because walk_page_range() doesn't
> work on NOMMU.
> 
> It can be tested to show the stack usages of non-kernel-thread processes:
> 
> 	# grep "Stack usage:" /proc/*/status | grep -v "0 kB"
> 	/proc/1/status:Stack usage:     2 kB
> 	/proc/57/status:Stack usage:    3 kB
> 	/proc/58/status:Stack usage:    1 kB
> 	/proc/59/status:Stack usage:    3 kB
> 	/proc/60/status:Stack usage:    5 kB
> 	/proc/self/status:Stack usage:  1 kB
> 
> I've only tested it with ELF-FDPIC, though it should work with FLAT too.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Cc: Stefani Seibold <stefani@seibold.net>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Robin Getz <rgetz@blackfin.uclinux.org>

Acked-by: stefani@seibold.net

> ---
> 
>  fs/proc/array.c |   20 +++++++++++++++++---
>  1 files changed, 17 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 4badde1..c67251e 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -387,8 +387,7 @@ static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
>  	return ss.usage;
>  }
>  
> -static inline void task_show_stack_usage(struct seq_file *m,
> -						struct task_struct *task)
> +static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
>  {
>  	struct vm_area_struct	*vma;
>  	struct mm_struct	*mm = get_task_mm(task);
> @@ -404,9 +403,24 @@ static inline void task_show_stack_usage(struct seq_file *m,
>  		mmput(mm);
>  	}
>  }
> -#else
> +#else /* CONFIG_MMU */
> +/*
> + * Calculate the size of a NOMMU process's stack
> + */
>  static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
>  {
> +	unsigned long sp, base, usage;
> +
> +	base = task->stack_start;
> +	sp = KSTK_ESP(task);
> +
> +#ifdef CONFIG_STACK_GROWSUP
> +	usage = sp - base;
> +#else
> +	usage = base - sp;
> +#endif
> +
> +	seq_printf(m, "Stack usage:\t%lu kB\n", (usage + 1023) >> 10);
>  }
>  #endif		/* CONFIG_MMU */
>  
> 


