Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbXKZPC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbXKZPC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXKZPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:02:20 -0500
Received: from sacred.ru ([62.205.161.221]:46365 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXKZPCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:02:19 -0500
Message-ID: <474ADFE9.90908@openvz.org>
Date: Mon, 26 Nov 2007 18:02:01 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] teach set_special_pids() to use struct pid
References: <20071126142555.GA16528@tv-sign.ru>
In-Reply-To: <20071126142555.GA16528@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 26 Nov 2007 18:02:00 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Change set_special_pids() to work with struct pid, not pid_t from global name
> space. This again speedups and imho cleanups the code.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> --- PT/include/linux/sched.h~2_set_special_pids	2007-11-26 15:52:15.000000000 +0300
> +++ PT/include/linux/sched.h	2007-11-26 16:47:35.000000000 +0300
> @@ -1568,7 +1568,7 @@ extern struct task_struct *find_task_by_
>  extern struct task_struct *find_task_by_pid_ns(pid_t nr,
>  		struct pid_namespace *ns);
>  
> -extern void __set_special_pids(pid_t session, pid_t pgrp);
> +extern void __set_special_pids(struct pid *pid);
>  
>  /* per-UID process charging. */
>  extern struct user_struct * alloc_uid(struct user_namespace *, uid_t);
> --- PT/kernel/exit.c~2_set_special_pids	2007-11-26 15:52:15.000000000 +0300
> +++ PT/kernel/exit.c	2007-11-26 16:47:35.000000000 +0300
> @@ -295,26 +295,27 @@ static void reparent_to_kthreadd(void)
>  	switch_uid(INIT_USER);
>  }
>  
> -void __set_special_pids(pid_t session, pid_t pgrp)
> +void __set_special_pids(struct pid *pid)
>  {
>  	struct task_struct *curr = current->group_leader;
> +	pid_t nr = pid_nr(pid);
>  
> -	if (task_session_nr(curr) != session) {
> +	if (task_session(curr) != pid) {
>  		detach_pid(curr, PIDTYPE_SID);
> -		set_task_session(curr, session);
> -		attach_pid(curr, PIDTYPE_SID, find_pid(session));
> +		attach_pid(curr, PIDTYPE_SID, pid);
> +		set_task_session(curr, nr);
>  	}
> -	if (task_pgrp_nr(curr) != pgrp) {
> +	if (task_pgrp(curr) != pid) {
>  		detach_pid(curr, PIDTYPE_PGID);
> -		set_task_pgrp(curr, pgrp);
> -		attach_pid(curr, PIDTYPE_PGID, find_pid(pgrp));
> +		attach_pid(curr, PIDTYPE_PGID, pid);
> +		set_task_pgrp(curr, nr);
>  	}
>  }
>  
> -static void set_special_pids(pid_t session, pid_t pgrp)
> +static void set_special_pids(struct pid *pid)
>  {
>  	write_lock_irq(&tasklist_lock);
> -	__set_special_pids(session, pgrp);
> +	__set_special_pids(pid);
>  	write_unlock_irq(&tasklist_lock);
>  }
>  
> @@ -385,7 +386,11 @@ void daemonize(const char *name, ...)
>  	 */
>  	current->flags |= PF_NOFREEZE;
>  
> -	set_special_pids(1, 1);
> +	if (current->nsproxy != &init_nsproxy) {
> +		get_nsproxy(&init_nsproxy);
> +		switch_task_namespaces(current, &init_nsproxy);
> +	}
> +	set_special_pids(find_pid(1));
>  	proc_clear_tty(current);
>  
>  	/* Block and flush all signals */
> @@ -400,11 +405,6 @@ void daemonize(const char *name, ...)
>  	current->fs = fs;
>  	atomic_inc(&fs->count);
>  
> -	if (current->nsproxy != init_task.nsproxy) {
> -		get_nsproxy(init_task.nsproxy);
> -		switch_task_namespaces(current, init_task.nsproxy);
> -	}
> -
>  	exit_files(current);
>  	current->files = init_task.files;
>  	atomic_inc(&current->files->count);
> --- PT/kernel/sys.c~2_set_special_pids	2007-11-26 16:10:43.000000000 +0300
> +++ PT/kernel/sys.c	2007-11-26 16:48:02.000000000 +0300
> @@ -1065,7 +1065,7 @@ asmlinkage long sys_setsid(void)
>  		goto out;
>  
>  	group_leader->signal->leader = 1;
> -	__set_special_pids(pid_nr(sid), pid_nr(sid));
> +	__set_special_pids(sid);
>  
>  	spin_lock(&group_leader->sighand->siglock);
>  	group_leader->signal->tty = NULL;
> --- PT/init/main.c~2_set_special_pids	2007-11-26 15:52:15.000000000 +0300
> +++ PT/init/main.c	2007-11-26 16:56:24.000000000 +0300
> @@ -829,7 +829,7 @@ static int __init kernel_init(void * unu
>  	 */
>  	init_pid_ns.child_reaper = current;
>  
> -	__set_special_pids(1, 1);
> +	__set_special_pids(task_pid(current));
>  	cad_pid = task_pid(current);
>  
>  	smp_prepare_cpus(max_cpus);
> 
> 

