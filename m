Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZGBSy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZGBSy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZGBSyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:54:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZGBSyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:54:22 -0400
Date: Thu, 2 Jul 2009 20:51:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: __ptrace_detach: do __wake_up_parent() if
	we reap the tracee
Message-ID: <20090702185139.GA31404@redhat.com>
References: <20090701192844.GA26624@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701192844.GA26624@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Oleg Nesterov wrote:
>
> --- WAIT/kernel/ptrace.c~PT_DETACH_WAKE_PARENT	2009-07-01 19:59:01.000000000 +0200
> +++ WAIT/kernel/ptrace.c	2009-07-01 20:52:58.000000000 +0200
> @@ -266,9 +266,10 @@ static int ignoring_children(struct sigh
>   * or self-reaping.  Do notification now if it would have happened earlier.
>   * If it should reap itself, return true.
>   *
> - * If it's our own child, there is no notification to do.
> - * But if our normal children self-reap, then this child
> - * was prevented by ptrace and we must reap it now.
> + * If it's our own child, there is no notification to do. But if our normal
> + * children self-reap, then this child was prevented by ptrace and we must
> + * reap it now, in that case we must also wake up sub-threads sleeping in
> + * do_wait().
>   */
>  static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
>  {
> @@ -278,8 +279,10 @@ static bool __ptrace_detach(struct task_
>  		if (!task_detached(p) && thread_group_empty(p)) {
>  			if (!same_thread_group(p->real_parent, tracer))
>  				do_notify_parent(p, p->exit_signal);
> -			else if (ignoring_children(tracer->sighand))
> +			else if (ignoring_children(tracer->sighand)) {
> +				__wake_up_parent(p, tracer);
>  				p->exit_signal = -1;
> +			}

I wonder if we need more fixes here.

ignoring_children() is not exactly right afaics, we assume that
tracee->exit_signal == SIGCHLD.

But I guess this can be ignored, it falls into "ptracing with SIGCHLD
ignored asks for trouble" category.

But !same_thread_group() doesn't look 100% right too, for the same
reason. If ->exit_signal != SIGCHLD, we can't assume we already had
the correct notification. Hopefully this can be ignored too.

Oleg.

