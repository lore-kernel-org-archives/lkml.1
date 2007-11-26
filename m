Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbXKZPBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbXKZPBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXKZPA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:00:58 -0500
Received: from sacred.ru ([62.205.161.221]:46260 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXKZPA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:00:57 -0500
Message-ID: <474ADF94.5050500@openvz.org>
Date: Mon, 26 Nov 2007 18:00:36 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fix setsid() for sub-namespace /sbin/init
References: <20071126142553.GA16525@tv-sign.ru>
In-Reply-To: <20071126142553.GA16525@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 26 Nov 2007 18:00:36 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> sys_setsid() still deals with pid_t's from the global namespace. This means
> that the "session > 1" check can't help for sub-namespace init, setsid() can't
> succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.
> 
> Remove the usage of task_struct->pid and convert the code to use "struct pid".
> This also simplifies and speedups the code, saves one find_pid().
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> --- PT/kernel/sys.c~1_setsid	2007-11-26 15:52:15.000000000 +0300
> +++ PT/kernel/sys.c	2007-11-26 16:10:43.000000000 +0300
> @@ -1045,35 +1045,33 @@ asmlinkage long sys_getsid(pid_t pid)
>  asmlinkage long sys_setsid(void)
>  {
>  	struct task_struct *group_leader = current->group_leader;
> -	pid_t session;
> +	struct pid *sid = task_pid(group_leader);
> +	pid_t session = pid_vnr(sid);
>  	int err = -EPERM;
>  
>  	write_lock_irq(&tasklist_lock);
> -
>  	/* Fail if I am already a session leader */
>  	if (group_leader->signal->leader)
>  		goto out;
>  
> -	session = group_leader->pid;
> -	/* Fail if a process group id already exists that equals the
> -	 * proposed session id.
> +	/* Fail if a process group id already exists that equals the proposed
> +	 * session id.
>  	 *
> -	 * Don't check if session id == 1 because kernel threads use this
> -	 * session id and so the check will always fail and make it so
> -	 * init cannot successfully call setsid.
> +	 * Don't check if session == 1 because kernel threads and CLONE_NEWPID
> +	 * tasks use this session id and so the check will always fail and make
> +	 * it so init cannot successfully call setsid.
>  	 */
> -	if (session > 1 && find_task_by_pid_type_ns(PIDTYPE_PGID,
> -				session, &init_pid_ns))
> +	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
>  		goto out;
>  
>  	group_leader->signal->leader = 1;
> -	__set_special_pids(session, session);
> +	__set_special_pids(pid_nr(sid), pid_nr(sid));
>  
>  	spin_lock(&group_leader->sighand->siglock);
>  	group_leader->signal->tty = NULL;
>  	spin_unlock(&group_leader->sighand->siglock);
>  
> -	err = task_pgrp_vnr(group_leader);
> +	err = session;
>  out:
>  	write_unlock_irq(&tasklist_lock);
>  	return err;
> 
> 

