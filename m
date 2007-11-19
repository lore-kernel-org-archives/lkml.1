Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbXKSJak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbXKSJak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXKSJaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:30:15 -0500
Received: from sacred.ru ([62.205.161.221]:37009 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbXKSJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:30:13 -0500
Message-ID: <4741573E.60609@openvz.org>
Date: Mon, 19 Nov 2007 12:28:30 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@sw.ru>, Kees Cook <kees@ubuntu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait_task_stopped: don't use task_pid_nr_ns() lockless
References: <20071116172408.GA7293@tv-sign.ru>
In-Reply-To: <20071116172408.GA7293@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 19 Nov 2007 12:29:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> wait_task_stopped(WNOWAIT) does task_pid_nr_ns() without tasklist/rcu lock,
> we can read an already freed memory. Use the cached pid_t value.

Indeed. Thanks!

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> --- 24/kernel/exit.c~1_PID	2007-11-16 18:12:44.000000000 +0300
> +++ 24/kernel/exit.c	2007-11-16 18:13:54.000000000 +0300
> @@ -1357,7 +1357,7 @@ static int wait_task_stopped(struct task
>  			     int __user *stat_addr, struct rusage __user *ru)
>  {
>  	int retval, exit_code;
> -	struct pid_namespace *ns;
> +	pid_t pid;
>  
>  	if (!p->exit_code)
>  		return 0;
> @@ -1376,12 +1376,11 @@ static int wait_task_stopped(struct task
>  	 * keep holding onto the tasklist_lock while we call getrusage and
>  	 * possibly take page faults for user memory.
>  	 */
> -	ns = current->nsproxy->pid_ns;
> +	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
>  	get_task_struct(p);
>  	read_unlock(&tasklist_lock);
>  
>  	if (unlikely(noreap)) {
> -		pid_t pid = task_pid_nr_ns(p, ns);
>  		uid_t uid = p->uid;
>  		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
>  
> @@ -1451,11 +1450,11 @@ bail_ref:
>  	if (!retval && infop)
>  		retval = put_user(exit_code, &infop->si_status);
>  	if (!retval && infop)
> -		retval = put_user(task_pid_nr_ns(p, ns), &infop->si_pid);
> +		retval = put_user(pid, &infop->si_pid);
>  	if (!retval && infop)
>  		retval = put_user(p->uid, &infop->si_uid);
>  	if (!retval)
> -		retval = task_pid_nr_ns(p, ns);
> +		retval = pid;
>  	put_task_struct(p);
>  
>  	BUG_ON(!retval);
> 
> 

