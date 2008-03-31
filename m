Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYCaJvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYCaJvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYCaJvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:51:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59718 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYCaJvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:51:31 -0400
Date: Mon, 31 Mar 2008 12:51:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] do_wait reorganization
Message-ID: <20080331085110.GA400@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org> <20080331035701.3926726F8E9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331035701.3926726F8E9@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I apologize in advance if I missed something, I'm not able to study this series
 carefully now. But I hope that a false alarm is better than a probable bug.)

On 03/30, Roland McGrath wrote:
> +static int wait_consider_task(struct task_struct *parent,
> +			      struct task_struct *p, int *retval,
> +			      enum pid_type type, struct pid *pid, int options,
> +			      struct siginfo __user *infop,
> +			      int __user *stat_addr, struct rusage __user *ru)
> +{
> +	int ret = eligible_child(type, pid, options, p);
> +	if (ret <= 0)
> +		return ret;
> +
> +	/*
> +	 * We don't reap group leaders with subthreads.
> +	 */
> +	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
> +		return wait_task_zombie(p, options, infop, stat_addr, ru);
> +
> +	/*
> +	 * It's stopped or running now, so it might
> +	 * later continue, exit, or stop again.
> +	 */
> +	*retval = 0;
> +
> +	if (task_is_stopped_or_traced(p))
> +		return wait_task_stopped(p, options, infop, stat_addr, ru);
> +
> +	if (p->exit_state != EXIT_DEAD)
> +		return wait_task_continued(p, options, infop, stat_addr, ru);
> +
> +	return 0;
> +}

This looks wrong, we shouldn't clear *retval if the child is EXIT_DEAD.

We can race with another thread which changed EXIT_ZOMBIE->EXIT_DEAD but
hasn't released the child yet. Suppose we don't have other childs, in that
case do_wait() will falsely sleep on ->wait_chldexit (unless WHOHANG).

Oleg.

