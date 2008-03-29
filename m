Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYC2QQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYC2QQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 12:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYC2QQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 12:16:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbYC2QQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 12:16:32 -0400
Date: Sat, 29 Mar 2008 09:16:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] do_wait reorganization
In-Reply-To: <20080329033412.120EE26FA1D@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Roland McGrath wrote:
>
> The control flow is less nonobvious without so much goto.

How about a further non-obviousness?

> +static int wait_consider_task(struct task_struct *parent,
> +			      struct task_struct *p, int *retval,
> +			      enum pid_type type, struct pid *pid, int options,
> +			      struct siginfo __user *infop,
> +			      int __user *stat_addr, struct rusage __user *ru)
> +{
...
> +	if (task_is_stopped_or_traced(p)) {
> +		/*
> +		 * It's stopped now, so it might later
> +		 * continue, exit, or stop again.
> +		 */
> +		*retval = 0;
> +		if ((p->ptrace & PT_PTRACED) ||
> +		    (options & WUNTRACED)) {
> +			*retval = wait_task_stopped(p, (options & WNOWAIT),
> +						    infop, stat_addr, ru);
> +			if (*retval)
> +				return 1;
> +		}
> +	} else if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p)) {
...
> +	return 0;

I think it would be even more obvious (or, to use your phrase, "less 
nonobvious") if this was written like so:

	if (task_is_stopped_or_traced(p)) {
		...
		....
			if (*retval}
				return 1;
		}
		return 0;
	}

	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p)) {
		...
		return 0;
	}

	if (...)

because then you can clearly see that smething like the
"task_is_stopped_or_traced(p)" case is complete in itself, and only has 
its own local stuff going on.

(And at some point I'd also almost make each case a trivial small inline 
function of its on, but in this case there are so many arguments to pass 
around that it probably becomes _less_ readable that way).

I also wonder if you really need both "int *retval" and the return value. 
Isn't "retval" always going to be zero or a negative errno? And the return 
value is going to be either true of false? Why not just fold them into one 
single thing:

 - negative: all done, with error
 - zero: this didn't trigger, continue with the next one in caller
 - positive: this thread triggered, all done, return 0 in the caller.

which is (I think) close to what we already do in eligible_child() (so 
this would not be a new calling convention for this particular code).

		Linus
