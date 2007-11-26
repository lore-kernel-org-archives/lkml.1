Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbXKZI4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbXKZI4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXKZI4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:56:38 -0500
Received: from sacred.ru ([62.205.161.221]:51126 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbXKZI4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:56:37 -0500
Message-ID: <474A8A2D.4020300@openvz.org>
Date: Mon, 26 Nov 2007 11:56:13 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sys_setpgid: simplify pid/ns interaction
References: <20071125144428.GA6304@tv-sign.ru>
In-Reply-To: <20071125144428.GA6304@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 26 Nov 2007 11:56:16 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> sys_setpgid() does unneeded conversions from pid_t to "struct pid" and vice
> versa. Use "struct pid" more consistently. Saves one find_vpid() and eliminates
> the explicit usage of ->nsproxy->pid_ns. Imho, cleanups the code.
> 
> Also use the same_thread_group() helper.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Looks good :)

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> --- PT/kernel/sys.c~	2007-11-20 17:16:10.000000000 +0300
> +++ PT/kernel/sys.c	2007-11-25 17:16:59.000000000 +0300
> @@ -916,8 +916,8 @@ asmlinkage long sys_setpgid(pid_t pid, p
>  {
>  	struct task_struct *p;
>  	struct task_struct *group_leader = current->group_leader;
> -	int err = -EINVAL;
> -	struct pid_namespace *ns;
> +	struct pid *pgrp;
> +	int err;
>  
>  	if (!pid)
>  		pid = task_pid_vnr(group_leader);
> @@ -929,12 +929,10 @@ asmlinkage long sys_setpgid(pid_t pid, p
>  	/* From this point forward we keep holding onto the tasklist lock
>  	 * so that our parent does not change from under us. -DaveM
>  	 */
> -	ns = current->nsproxy->pid_ns;
> -
>  	write_lock_irq(&tasklist_lock);
>  
>  	err = -ESRCH;
> -	p = find_task_by_pid_ns(pid, ns);
> +	p = find_task_by_vpid(pid);
>  	if (!p)
>  		goto out;
>  
> @@ -942,7 +940,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
>  	if (!thread_group_leader(p))
>  		goto out;
>  
> -	if (p->real_parent->tgid == group_leader->tgid) {
> +	if (same_thread_group(p->real_parent, group_leader)) {
>  		err = -EPERM;
>  		if (task_session(p) != task_session(group_leader))
>  			goto out;
> @@ -959,10 +957,12 @@ asmlinkage long sys_setpgid(pid_t pid, p
>  	if (p->signal->leader)
>  		goto out;
>  
> +	pgrp = task_pid(p);
>  	if (pgid != pid) {
>  		struct task_struct *g;
>  
> -		g = find_task_by_pid_type_ns(PIDTYPE_PGID, pgid, ns);
> +		pgrp = find_vpid(pgid);
> +		g = pid_task(pgrp, PIDTYPE_PGID);
>  		if (!g || task_session(g) != task_session(group_leader))
>  			goto out;
>  	}
> @@ -971,13 +971,10 @@ asmlinkage long sys_setpgid(pid_t pid, p
>  	if (err)
>  		goto out;
>  
> -	if (task_pgrp_nr_ns(p, ns) != pgid) {
> -		struct pid *pid;
> -
> +	if (task_pgrp(p) != pgrp) {
>  		detach_pid(p, PIDTYPE_PGID);
> -		pid = find_vpid(pgid);
> -		attach_pid(p, PIDTYPE_PGID, pid);
> -		set_task_pgrp(p, pid_nr(pid));
> +		attach_pid(p, PIDTYPE_PGID, pgrp);
> +		set_task_pgrp(p, pid_nr(pgrp));
>  	}
>  
>  	err = 0;
> 
> 

