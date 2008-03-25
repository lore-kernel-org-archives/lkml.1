Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYCYQLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYCYQLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYCYQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:10:53 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53881 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbYCYQKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:10:53 -0400
Date: Tue, 25 Mar 2008 19:16:06 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Discard notification signals when a tracer exits
Message-ID: <20080325161606.GA93@tv-sign.ru>
References: <1206455513.17227.4.camel@elijah.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206455513.17227.4.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch needs Roland's opinion. I can't really judge, but I
have some (perhaps wrong) doubts.

On 03/25, Petr Tesarik wrote:
>
> When a tracer exits without detaching from the traced process, the
> tracee may be at a tracer notification stop and will thus interpret
> the value in task->exit_code (SIGTRAP | 0x80) as the signal to be
> delivered.
> 
> This patch fixes the problem by clearing exit_code when detaching
> the traced process from a dying tracer.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> 
> ---
>  exit.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -642,8 +642,10 @@ reparent_thread(struct task_struct *p, s
>  			/*
>  			 * If it was at a trace stop, turn it into
>  			 * a normal stop since it's no longer being
> -			 * traced.
> +			 * traced.  Cancel the notification signal,
> +			 * or the tracee may get a SIGTRAP.
>  			 */
> +			p->exit_code = 0;
>  			ptrace_untrace(p);
>  		}
>  	}
> @@ -713,6 +715,10 @@ static void forget_original_parent(struc
>  			p->real_parent = reaper;
>  			reparent_thread(p, father, 0);
>  		} else {
> +			/* cancel the notification signal at a trace stop */
> +			if (p->state == TASK_TRACED)
> +				p->exit_code = 0;

This reduce the likelihood that the tracee will be SIGTRAP'ed, but doesn't
solve the problem, no?

Suppose that the tracee does send_sigtrap(current) in do_syscall_trace()
and then ptracer exits. Or ptracer wakes up the TASK_TRACED tracee without
clearing its ->exit_code and then you kill(ptracer, SIGKILL).

If we really need this, _perhaps_ it is better to change do_syscall_trace(),
so that the tracee checks ->ptrace before sending the signal to itself.


But actually, I don't understand what is the problem. Ptracer has full control,
you should not kill it with SIGKILL, this may leave the child in some bad/
inconsistent change. If strace/whatever itself exits without taking care about
its tracees, then we should fix the tracer, not the kernel.

Yes, I think this can prevent the death of the tracee if you do kill(strace,9),
but why this is important? Why should you kill it with SIGKILL?


But again, let's see what Roland thinks.

Oleg.

