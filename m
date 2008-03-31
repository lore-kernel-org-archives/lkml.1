Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYCaMDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYCaMDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYCaMDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:03:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53539 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbYCaMDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:03:33 -0400
Date: Mon, 31 Mar 2008 15:03:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] do_wait: return security_task_wait() error code in place of -ECHILD
Message-ID: <20080331110312.GC400@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org> <20080331035701.3926726F8E9@magilla.localdomain> <20080331035949.608A226F8E9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331035949.608A226F8E9@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Roland McGrath wrote:
>
> This reverts the effect of commit f2cc3eb133baa2e9dc8efd40f417106b2ee520f3
> "do_wait: fix security checks".  That change reverted the effect of commit
> 73243284463a761e04d69d22c7516b2be7de096c.  The rationale for the original
> commit still stands.  The inconsistent treatment of children hidden by
> ptrace was an unintended omission in the original change and in no way
> invalidates its purpose.

OK, it turns out I misunderstood the purpose of 73243284463a761e04d69d22c7516b2be7de096c,
its changelog says:

	wait* syscalls return -ECHILD even when an individual PID of a live child
	was requested explicitly, when security_task_wait denies the operation.
	This means that something like a broken SELinux policy can produce an
	unexpected failure that looks just like a bug with wait or ptrace or
	something.

I wrongly thought that "-ECHILD even when an individual PID ... was requested"
was the problem.

> This makes do_wait return the error returned by security_task_wait()
> (usually -EACCES) in place of -ECHILD when there are some children the
> caller would be able to wait for if not for the permission failure.  A
> permission error will give the user a clue to look for security policy
> problems, rather than for mysterious wait bugs.

OK, thanks. Again, I was confused and thought we should "hide" -EACCES
unless the child was explicitly requested.

> @@ -1463,9 +1460,22 @@ static int wait_consider_task(struct task_struct *parent,
>  			      int __user *stat_addr, struct rusage __user *ru)
>  {
>  	int ret = eligible_child(type, pid, options, p);
> -	if (ret <= 0)
> +	if (!ret)
>  		return ret;
>  
> +	if (unlikely(ret < 0)) {
> +		/*
> +		 * If we have not yet seen any eligible child,
> +		 * then let this error code replace -ECHILD.
> +		 * A permission error will give the user a clue
> +		 * to look for security policy problems, rather
> +		 * than for mysterious wait bugs.
> +		 */
> +		if (*retval)
> +			*retval = ret;
> +		return 0;
> +	}

Not that I blame this patch...

Suppose that we have 2 childs. The first one is running, the second is zombie
but nacked by security_task_wait(). Now waitpid(-1, WHOHANG|WEXITED) returns 0,
a bit strange/confusing.

Yes, we have the same behaviour before this patch, but after reading your
explanation I am starting to think this is not "optimal".

Don't get me wrong, I don't claim this should be changed, just I'd like to be
sure this didn't escape your attention.

Oleg.

