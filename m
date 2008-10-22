Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYJVHiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYJVHiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYJVHh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:37:56 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:64624 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYJVHhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:37:55 -0400
Message-ID: <48FED820.8030401@fr.ibm.com>
Date: Wed, 22 Oct 2008 09:37:04 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] freezer_cg: use thaw_process() in unfreeze_cgroup()
References: <48FD26F5.1070809@cn.fujitsu.com>	<48FD273F.3040505@cn.fujitsu.com>	<48FD2784.30906@cn.fujitsu.com>	<48FD81B8.5030103@fr.ibm.com> <20081021135813.e77d3015.akpm@linux-foundation.org>
In-Reply-To: <20081021135813.e77d3015.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 21 Oct 2008 09:16:08 +0200
> Cedric Le Goater <clg@fr.ibm.com> wrote:
> 
>> Li Zefan wrote:
>>> Don't duplicate the implementation of thaw_process().
>> looks OK but you should remove  __thaw_process() which is unused 
>> now.
> 
> It's called by thaw_process().
> 
> But that's the only callsite, I believe, so...

yes it is. it was added by dc52ddc0e6f45b04780b26fc0813509f8e798c42
and was inline before.

thanks,

C.

> 
> --- a/include/linux/freezer.h~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
> +++ a/include/linux/freezer.h
> @@ -44,11 +44,6 @@ static inline bool should_send_signal(st
>  	return !(p->flags & PF_FREEZER_NOSIG);
>  }
>  
> -/*
> - * Wake up a frozen process
> - */
> -extern int __thaw_process(struct task_struct *p);
> -
>  /* Takes and releases task alloc lock using task_lock() */
>  extern int thaw_process(struct task_struct *p);
>  
> diff -puN kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix kernel/freezer.c
> --- a/kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
> +++ a/kernel/freezer.c
> @@ -121,16 +121,7 @@ void cancel_freezing(struct task_struct 
>  	}
>  }
>  
> -/*
> - * Wake up a frozen process
> - *
> - * task_lock() is needed to prevent the race with refrigerator() which may
> - * occur if the freezing of tasks fails.  Namely, without the lock, if the
> - * freezing of tasks failed, thaw_tasks() might have run before a task in
> - * refrigerator() could call frozen_process(), in which case the task would be
> - * frozen and no one would thaw it.
> - */
> -int __thaw_process(struct task_struct *p)
> +static int __thaw_process(struct task_struct *p)
>  {
>  	if (frozen(p)) {
>  		p->flags &= ~PF_FROZEN;
> @@ -140,6 +131,15 @@ int __thaw_process(struct task_struct *p
>  	return 0;
>  }
>  
> +/*
> + * Wake up a frozen process
> + *
> + * task_lock() is needed to prevent the race with refrigerator() which may
> + * occur if the freezing of tasks fails.  Namely, without the lock, if the
> + * freezing of tasks failed, thaw_tasks() might have run before a task in
> + * refrigerator() could call frozen_process(), in which case the task would be
> + * frozen and no one would thaw it.
> + */
>  int thaw_process(struct task_struct *p)
>  {
>  	task_lock(p);
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

