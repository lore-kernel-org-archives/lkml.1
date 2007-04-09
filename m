Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbXDIQTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbXDIQTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXDIQTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:19:30 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:38354 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752338AbXDIQT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:19:29 -0400
X-YMail-OSG: rmeYa7UVM1nwF8YAz2.FMRsZ2gECH4AxbTZODLGs6fxDpw4ditMHe1QmlYCnUfEZYGQQ7VBbJ3mqPBRo5fqBUiX_2Izb2LPAEskHPnVX4rDLdKBXJzU-
Date: Mon, 9 Apr 2007 11:19:21 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 3/3] use CLONE_KERNEL_THREAD
Message-ID: <20070409161921.GB13709@vino.hallyn.com>
References: <20070408155534.GA132@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408155534.GA132@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@tv-sign.ru):
> For review only.
> 
> Add CLONE_KERNEL_THREAD to kthread_create() and change reparent_to_init()
> to match CLONE_KERNEL_THREAD.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
>  kthread.c |    2 +-
>  exit.c    |   20 +++++++++-----------
>  2 files changed, 10 insertions(+), 12 deletions(-)
> 
> --- 2.6.21-rc5-mm4/kernel/kthread.c~3_USE	2007-04-05 12:18:28.000000000 +0400
> +++ 2.6.21-rc5-mm4/kernel/kthread.c	2007-04-08 19:18:59.000000000 +0400
> @@ -120,7 +120,7 @@ static void keventd_create_kthread(struc
>  	int pid;
>  
>  	/* We want our own signal handler (we take no signals by default). */
> -	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
> +	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | CLONE_KERNEL_THREAD);
>  	if (pid < 0) {
>  		create->result = ERR_PTR(pid);
>  	} else {
> --- 2.6.21-rc5-mm4/kernel/exit.c~3_USE	2007-04-08 19:06:27.000000000 +0400
> +++ 2.6.21-rc5-mm4/kernel/exit.c	2007-04-08 19:23:18.000000000 +0400
> @@ -279,28 +279,26 @@ static int has_stopped_jobs(struct pid *
>  }
>  
>  /**
> - * reparent_to_init - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
> + * reparent_kthread - Reparent the calling kernel thread to swapper.
>   *
>   * If a kernel thread is launched as a result of a system call, or if
> - * it ever exits, it should generally reparent itself to init so that
> - * it is correctly cleaned up on exit.
> + * it ever exits, it should generally reparent itself so that it is
> + * correctly cleaned up on exit.
>   *
>   * The various task state such as scheduling policy and priority may have
>   * been inherited from a user process, so we reset them to sane values here.
>   *
> - * NOTE that reparent_to_init() gives the caller full capabilities.
> + * NOTE that reparent_kthread() gives the caller full capabilities.
>   */
> -static void reparent_to_init(void)
> +static void reparent_kthread(void)

Thanks.  The use of 'child_reaper(current)' makes it clear that
'reparent_to_init' had turned into a confusing name in the name
of per-pidspace inits.

-serge

>  {
>  	write_lock_irq(&tasklist_lock);
>  
> -	/* Reparent to init */
>  	remove_parent(current);
> -	current->parent = child_reaper(current);
> -	add_parent(current);
>  
> -	/* Set the exit signal to SIGCHLD so we signal init on exit */
> -	current->exit_signal = SIGCHLD;
> +	current->parent = &init_task;
> +	add_parent(current);
> +	current->exit_signal = -1;
>  
>  	if (!has_rt_policy(current) && (task_nice(current) < 0))
>  		set_user_nice(current, 0);
> @@ -423,7 +421,7 @@ void daemonize(const char *name, ...)
>  	current->files = init_task.files;
>  	atomic_inc(&current->files->count);
>  
> -	reparent_to_init();
> +	reparent_kthread();
>  }
>  
>  EXPORT_SYMBOL(daemonize);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
