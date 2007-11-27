Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbXK0AxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbXK0AxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXK0AxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:53:08 -0500
Received: from namei.org ([69.55.235.186]:51251 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753238AbXK0AxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:53:05 -0500
Date: Tue, 27 Nov 2007 11:51:41 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH -mm 2/2] do_wait: cleanup delay_group_leader() usage
In-Reply-To: <20071123195942.GA166@tv-sign.ru>
Message-ID: <Xine.LNX.4.64.0711271147100.26171@us.intercode.com.au>
References: <20071123195942.GA166@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[added LSM list]

On Fri, 23 Nov 2007, Oleg Nesterov wrote:

> eligible_child() == 2 means delay_group_leader(). With the previous patch this
> only matters for EXIT_ZOMBIE task, we can move that special check to the only
> place it is really needed.
> 
> Also, with this patch we don't skip security_task_wait() for the group leaders
> in a non-empty thread group. I don't really understand the exact semantics of
> security_task_wait(), but imho this change is a bugfix.

The semantics in terms of SELinux are that calls to wait() type calls need 
to be mediated by policy, as information can be transfered via the exit 
status.

It looks like a correct bugfix to me, but I'd be interested to see what 
others have to say.



> Also rearrange the code a bit to kill an ugly "check_continued" backdoor.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- PT/kernel/exit.c~6_delay_leader	2007-11-23 20:31:21.000000000 +0300
> +++ PT/kernel/exit.c	2007-11-23 21:29:44.000000000 +0300
> @@ -1137,12 +1137,6 @@ static int eligible_child(pid_t pid, int
>  	if (((p->exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
>  	    && !(options & __WALL))
>  		return 0;
> -	/*
> -	 * Do not consider thread group leaders that are
> -	 * in a non-empty thread group:
> -	 */
> -	if (delay_group_leader(p))
> -		return 2;
>  
>  	err = security_task_wait(p);
>  	if (err)
> @@ -1494,10 +1488,9 @@ repeat:
>  	tsk = current;
>  	do {
>  		struct task_struct *p;
> -		int ret;
>  
>  		list_for_each_entry(p, &tsk->children, sibling) {
> -			ret = eligible_child(pid, options, p);
> +			int ret = eligible_child(pid, options, p);
>  			if (!ret)
>  				continue;
>  
> @@ -1521,19 +1514,17 @@ repeat:
>  				retval = wait_task_stopped(p,
>  						(options & WNOWAIT), infop,
>  						stat_addr, ru);
> -			} else if (p->exit_state == EXIT_ZOMBIE) {
> +			} else if (p->exit_state == EXIT_ZOMBIE &&
> +					!delay_group_leader(p)) {
>  				/*
> -				 * Eligible but we cannot release it yet:
> +				 * We don't reap group leaders with subthreads.
>  				 */
> -				if (ret == 2)
> -					goto check_continued;
>  				if (!likely(options & WEXITED))
>  					continue;
>  				retval = wait_task_zombie(p,
>  						(options & WNOWAIT), infop,
>  						stat_addr, ru);
>  			} else if (p->exit_state != EXIT_DEAD) {
> -check_continued:
>  				/*
>  				 * It's running now, so it might later
>  				 * exit, stop, or stop and then continue.
> 

-- 
James Morris
<jmorris@namei.org>
