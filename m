Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbZE1Qdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbZE1Qdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZE1Qdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:33:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:65006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZE1Qdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KpaCvO4WV7+pszwQX8QeVRLGbwEf8F4NLF/9kxUER6c9W/brBG4cQOu2Kr4GZShoUU
         DeLdBfRUNxQt9ZMCfC93szfq34UWTZMeBW3mASeO4UlbvLf+sn/4jLXBUo6rW46bXVmf
         GCfkY3GLdY5N0UZSWnQ4IZE+GiNzdW0h//lB8=
Date: Thu, 28 May 2009 20:33:42 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC v16][PATCH 19/43] c/r: external checkpoint of a task other
	than ourself
Message-ID: <20090528163342.GA18962@x200.localdomain>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu> <1243445589-32388-20-git-send-email-orenl@cs.columbia.edu> <20090527211950.GA7855@x200.localdomain> <Pine.LNX.4.64.0905271831030.7284@takamine.ncl.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905271831030.7284@takamine.ncl.cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 06:32:28PM -0400, Oren Laadan wrote:
> On Thu, 28 May 2009, Alexey Dobriyan wrote:
> 
> > On Wed, May 27, 2009 at 01:32:45PM -0400, Oren Laadan wrote:
> > > Now we can do "external" checkpoint, i.e. act on another task.
> > 
> > > +static int may_checkpoint_task(struct ckpt_ctx *ctx, struct task_struct *t)
> > > +{
> > > +	if (t->state == TASK_DEAD) {
> > > +		pr_warning("c/r: task %d is TASK_DEAD\n", task_pid_vnr(t));
> > > +		return -EAGAIN;
> > > +	}
> > > +
> > > +	if (!ptrace_may_access(t, PTRACE_MODE_READ)) {
> > > +		__ckpt_write_err(ctx, "access to task %d (%s) denied",
> > > +				 task_pid_vnr(t), t->comm);
> > > +		return -EPERM;
> > > +	}
> > > +
> > > +	/* verify that the task is frozen (unless self) */
> > > +	if (t != current && !frozen(t)) {
> > > +		__ckpt_write_err(ctx, "task %d (%s) is not frozen",
> > > +				 task_pid_vnr(t), t->comm);
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	/* FIX: add support for ptraced tasks */
> > > +	if (task_ptrace(t)) {
> > > +		__ckpt_write_err(ctx, "task %d (%s) is ptraced",
> > > +				 task_pid_vnr(t), t->comm);
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int get_container(struct ckpt_ctx *ctx, pid_t pid)
> > > +{
> > > +	struct task_struct *task = NULL;
> > > +	struct nsproxy *nsproxy = NULL;
> > > +	int ret;
> > > +
> > > +	ctx->root_pid = pid;
> > > +
> > > +	read_lock(&tasklist_lock);
> > > +	task = find_task_by_vpid(pid);
> > > +	if (task)
> > > +		get_task_struct(task);
> > > +	read_unlock(&tasklist_lock);
> > > +
> > > +	if (!task)
> > > +		return -ESRCH;
> > > +
> > > +	ret = may_checkpoint_task(ctx, task);
> > > +	if (ret) {
> > > +		ckpt_write_err(ctx, NULL);
> > > +		put_task_struct(task);
> > > +		return ret;
> > > +	}
> > > +
> > > +	rcu_read_lock();
> > > +	nsproxy = task_nsproxy(task);
> > > +	get_nsproxy(nsproxy);
> > 
> > Will oops if init is multi-threaded and thread group leader exited
> > (nsproxy = NULL). I need to think what to do, too.
> 
> 
> ood catch. Since all threads share same nsproxy (except those
> who exits.. duh) we can test for this case, and get the nsproxy
> from any of the other threads, something like this (untested):

I don't know if such behaviour was intented, but threads have only common
pid_ns not whole nsproxy. CLONE_THREAD|CLONE_NEWUTS works just fine.

> --- a/checkpoint/checkpoint.c
> +++ b/checkpoint/checkpoint.c
> @@ -522,9 +522,33 @@ static int get_container(struct ckpt_ctx *ctx, pid_t pid)
>  
>  	rcu_read_lock();
>  	nsproxy = task_nsproxy(task);
> -	get_nsproxy(nsproxy);
> +	if (nsproxy)
> +		get_nsproxy(nsproxy);
>  	rcu_read_unlock();
>  
> +	/*
> +	 * If we hit a zombie thread-group-leader, nsproxy will be NULL,
> +	 * and we instead grab it from one of the other threads.
> +	 */
> +	if (!nsproxy) {
> +		struct task_struct *p = next_thread(task);
> +
> +		BUG_ON(task->state != TASK_DEAD);
> +		read_lock(&tasklist_lock);
> +		while (p != task && !task_nsproxy(p))
> +			p = next_thread(p);
> +		nsproxy = get_nsproxy(p);
> +		if (nsproxy)
> +			get_nsproxy(nsproxy);
> +		read_unlock(&tasklist_lock);
> +	}
> +
> +	/* still not ... too bad ... */
> +	if (!nsproxy) {
> +		put_task_struct(task);
> +		return -ESRCH;
> +	}
> +
>  	ctx->root_task = task;
>  	ctx->root_nsproxy = nsproxy;
>  	ctx->root_init = is_container_init(task);
