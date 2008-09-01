Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYIAPJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYIAPJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYIAPJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:09:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:54984 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYIAPJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:09:02 -0400
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce
	PRIO_THREAD extension
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <1220280138.3866.31.camel@localhost.localdomain>
References: <1220278355.3866.21.camel@localhost.localdomain>
	 <1220280138.3866.31.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 17:08:57 +0200
Message-Id: <1220281737.8426.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 16:42 +0200, Denys Vlasenko wrote:
> On Mon, 2008-09-01 at 16:12 +0200, Denys Vlasenko wrote:
> > Patch is run tested. I will post test program etc as a reply.
> 
> Looks like Evolution word-wrapped the patch. Let me try again.

Patch looks simple enough, although a few comments below.
Also, I guess the glibc people (Ulrich added to CC) might have an
opinion.

> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> --
> vda
> 
> 
> diff --git a/include/linux/resource.h b/include/linux/resource.h
> index aaa423a..f292690 100644
> --- a/include/linux/resource.h
> +++ b/include/linux/resource.h
> @@ -51,6 +51,7 @@ struct rlimit {
>  #define	PRIO_PROCESS	0
>  #define	PRIO_PGRP	1
>  #define	PRIO_USER	2
> +#define	PRIO_THREAD	3
>  
>  /*
>   * Limit the stack by to some sane default: root can always
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 038a7bc..d339c1a 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -142,9 +142,9 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
>  	struct task_struct *g, *p;
>  	struct user_struct *user;
>  	int error = -EINVAL;
> -	struct pid *pgrp;
> +	struct pid *pgrp, *pid;
>  
> -	if (which > PRIO_USER || which < PRIO_PROCESS)
> +	if (which > PRIO_THREAD || which < PRIO_PROCESS)
>  		goto out;
>  
>  	/* normalize: avoid signed division (rounding problems) */
> @@ -156,7 +156,7 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
>  
>  	read_lock(&tasklist_lock);
>  	switch (which) {
> -		case PRIO_PROCESS:
> +		case PRIO_THREAD:
>  			if (who)
>  				p = find_task_by_vpid(who);
>  			else
> @@ -164,6 +164,19 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
>  			if (p)
>  				error = set_one_prio(p, niceval, error);
>  			break;
> +		case PRIO_PROCESS:
> +			if (who)
> +				pid = find_vpid(who);
> +			else {
> +				pid = task_pid(current);
> +				who = current->pid;
> +			}
> +			do_each_pid_thread(pid, PIDTYPE_PID, p) {
> +				if (who == p->pid || who == p->tgid) {
> +					error = set_one_prio(p, niceval, error);
> +				}
> +			} while_each_pid_thread(pid, PIDTYPE_PID, p);

I worry about destroying the return value here, support one thread
fails, but the next succeeds, should we still report failure?

> +			break;
>  		case PRIO_PGRP:
>  			if (who)
>  				pgrp = find_vpid(who);
> @@ -206,14 +219,14 @@ asmlinkage long sys_getpriority(int which, int who)
>  	struct task_struct *g, *p;
>  	struct user_struct *user;
>  	long niceval, retval = -ESRCH;
> -	struct pid *pgrp;
> +	struct pid *pgrp, *pid;
>  
> -	if (which > PRIO_USER || which < PRIO_PROCESS)
> +	if (which > PRIO_THREAD || which < PRIO_PROCESS)
>  		return -EINVAL;
>  
>  	read_lock(&tasklist_lock);
>  	switch (which) {
> -		case PRIO_PROCESS:
> +		case PRIO_THREAD:
>  			if (who)
>  				p = find_task_by_vpid(who);
>  			else
> @@ -224,6 +237,21 @@ asmlinkage long sys_getpriority(int which, int who)
>  					retval = niceval;
>  			}
>  			break;
> +		case PRIO_PROCESS:
> +			if (who)
> +				pid = find_vpid(who);
> +			else {
> +				pid = task_pid(current);
> +				who = current->pid;
> +			}
> +			do_each_pid_thread(pid, PIDTYPE_PID, p) {
> +				if (who == p->pid || who == p->tgid) {
> +					niceval = 20 - task_nice(p);
> +					if (niceval > retval)
> +						retval = niceval;
> +				}
> +			} while_each_pid_thread(pid, PIDTYPE_PID, p);

So we basically return the highest prio amongst the threads?

> +			break;
>  		case PRIO_PGRP:
>  			if (who)
>  				pgrp = find_vpid(who);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

