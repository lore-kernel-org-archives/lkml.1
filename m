Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYDEMwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYDEMwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 08:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYDEMwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 08:52:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:27435 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYDEMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 08:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fSBDwCX5z/1ed2hqoSQ+XpuaQ+Nv2h8I9Ed/XJEOC77PiqtyV6ixRhgDHFw6fYwx4Dy87Q2FT6SRLqMiIKu5rA06JQ6AxR26Va8OD50lB1lggpj+Xbh4TyeUhqrf1A85Ztj+OAxfYu824BO+ZoMCCm2LplGMTlWHz6JLHyilK94=
Date: Sat, 5 Apr 2008 16:48:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: roland@redhat.com, oleg@tv-sign.ru, linux-kernel@vger.kernel.org
Subject: Re: + procfs-mem-permission-cleanup.patch added to -mm tree
Message-ID: <20080405124801.GA4849@martell.zuzino.mipt.ru>
References: <200803312055.m2VKtLRF025622@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803312055.m2VKtLRF025622@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 01:55:21PM -0700, akpm@linux-foundation.org wrote:
> Subject: procfs: mem permission cleanup
> From: Roland McGrath <roland@redhat.com>
> 
> This cleans up the permission checks done for /proc/PID/mem i/o calls.  It
> puts all the logic in a new function, check_mem_permission().
> 
> The old code repeated the (!MAY_PTRACE(task) || !ptrace_may_attach(task))
> magical expression multiple times.  The new function does all that work in one
> place, with clear comments.
> 
> The old code called security_ptrace() twice on successful checks, once in
> MAY_PTRACE() and once in __ptrace_may_attach().  Now it's only called once,
> and only if all other checks have succeeded.

> --- a/fs/proc/base.c~procfs-mem-permission-cleanup
> +++ a/fs/proc/base.c
> @@ -195,12 +195,32 @@ static int proc_root_link(struct inode *
>  	return result;
>  }
>  
> -#define MAY_PTRACE(task) \
> -	(task == current || \
> -	(task->parent == current && \
> -	(task->ptrace & PT_PTRACED) && \
> -	 (task_is_stopped_or_traced(task)) && \
> -	 security_ptrace(current,task) == 0))
> +/*
> + * Return zero if current may access user memory in @task, -error if not.
> + */
> +static int check_mem_permission(struct task_struct *task)
> +{
> +	/*
> +	 * A task can always look at itself, in case it chooses
> +	 * to use system calls instead of load instructions.
> +	 */
> +	if (task == current)
> +		return 0;

OK.

> +	/*
> +	 * If current is actively ptrace'ing, and would also be
> +	 * permitted to freshly attach with ptrace now, permit it.
	   because it could attach and read task's memory memory.

Something like this.

> +	 */
> +	if (task->parent == current && (task->ptrace & PT_PTRACED) &&
> +	    task_is_stopped_or_traced(task) &&
> +	    ptrace_may_attach(task))
> +		return 0;
> +
> +	/*
> +	 * Noone else is allowed.
> +	 */
> +	return -EPERM;

This one is obviously from obvious comments category. :-)

> @@ -722,7 +742,7 @@ static ssize_t mem_read(struct file * fi
>  	if (!task)
>  		goto out_no_task;
>  
> -	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
> +	if (check_mem_permission(task))
>  		goto out;

I think, name should be proc_mem_permission() (a la vfs_permission()),
but don't have strong opinion on that.

> @@ -748,7 +768,7 @@ static ssize_t mem_read(struct file * fi
>  
>  		this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
>  		retval = access_process_vm(task, src, page, this_len, 0);
> -		if (!retval || !MAY_PTRACE(task) || !ptrace_may_attach(task)) {
> +		if (!retval || check_mem_permission(task)) {
>  			if (!ret)
>  				ret = -EIO;
>  			break;
> @@ -792,7 +812,7 @@ static ssize_t mem_write(struct file * f
>  	if (!task)
>  		goto out_no_task;
>  
> -	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
> +	if (check_mem_permission(task))
>  		goto out;

