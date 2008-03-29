Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYC2Kfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYC2Kfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 06:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYC2Kfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 06:35:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35766 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYC2Kff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 06:35:35 -0400
Date: Sat, 29 Mar 2008 13:35:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] do_wait reorganization
Message-ID: <20080329103513.GA359@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329033412.120EE26FA1D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Roland McGrath wrote:
>
> +static int wait_consider_task(struct task_struct *parent,
> +			      struct task_struct *p, int *retval,
> +			      enum pid_type type, struct pid *pid, int options,
> +			      struct siginfo __user *infop,
> +			      int __user *stat_addr, struct rusage __user *ru)
> +{
> +	int ret = eligible_child(type, pid, options, p);
> +	if (!ret)
> +		return 0;
> +
> +	if (unlikely(ret < 0)) {
> +		read_unlock(&tasklist_lock);
> +		*retval = ret;

Please note that eligible_child() drops tasklist_lock if it returns error
(ret < 0), so the "read_unlock" above is wrong.

> +static int do_wait_thread(struct task_struct *tsk, int *retval,
> +			  enum pid_type type, struct pid *pid, int options,
> +			  struct siginfo __user *infop, int __user *stat_addr,
> +			  struct rusage __user *ru)
> +{
> +	struct task_struct *p;
> +
> +	list_for_each_entry(p, &tsk->children, sibling) {
> +		if (wait_consider_task(tsk, p, retval, type, pid, options,
> +				       infop, stat_addr, ru))
> +			return 1;
> +	}
> +
> +	/*
> +	 * If we never saw an eligile child, check for children stolen by
> +	 * ptrace.  We don't leave -ECHILD in *@retval if there are any,
> +	 * because we will eventually be allowed to wait for them again.
> +	 */
> +	if (*retval)
> +		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
> +			int ret = eligible_child(type, pid, options, p);
> +			if (ret) {
> +				*retval = unlikely(ret < 0) ? ret : 0;

This is not right. If ret < 0, we set *retval = ret, but then return 0.
We should return 1, so that the caller (do_wait) will report the error.

Note again that eligible_child() has already dropped tasklist, so not
only we don't return the error, we continue to run without tasklist
held, this is bug.

>  static long do_wait(enum pid_type type, struct pid *pid, int options,
>  		    struct siginfo __user *infop, int __user *stat_addr,
>  		    struct rusage __user *ru)
>  {
>
> [...snip...]
>
> -	if (flag) {
> -		if (options & WNOHANG)
> -			goto end;
> +	if (!retval && !(options & WNOHANG)) {
>  		retval = -ERESTARTSYS;
> -		if (signal_pending(current))
> -			goto end;
> -		schedule();
> -		goto repeat;
> +		if (!signal_pending(current)) {
> +			schedule();
> +			goto repeat;
> +		}
>  	}
> -	retval = -ECHILD;
> +
>  end:
>  	current->state = TASK_RUNNING;
>  	remove_wait_queue(&current->signal->wait_chldexit,&wait);

If !retval and WNOHANG, we should return -ECHILD, but with this patch
we return 0.

Perhaps I missed something, but personally I don't like the usage of
"int *retval", imho this really complicates the code. I think it is better
to use the returned values directly, but pass "&flag" to do_wait_thread().
We only need the pointer to avoid the unnecessary scanning of ->ptrace_children.
Better yet, we can split do_wait_thread() into 2 functions, and do not pass
the pointer at all. But I didn't read the next patch yet (will do tomorrow),
perhaps I missed the point of this approach.

Oleg.

