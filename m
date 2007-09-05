Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXIEANz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXIEANz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 20:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbXIEANs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 20:13:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34332 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbXIEANr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 20:13:47 -0400
Date: Wed, 5 Sep 2007 05:56:47 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Eugene Teo <eugeneteo@kernel.sg>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix tsk->exit_state usage (resend)
In-Reply-To: <20070819142401.GA27823@kernel.sg>
Message-ID: <alpine.LFD.0.999.0709050544070.20571@enigma.security.iitk.ac.in>
References: <20070819142401.GA27823@kernel.sg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eugene,

This already got merged into -mm, but ...


On Sun, 19 Aug 2007, Eugene Teo wrote:
> 
> tsk->exit_state can only be 0, EXIT_ZOMBIE, or EXIT_DEAD. A non-zero test
> is the same as tsk->exit_state & (EXIT_ZOMBIE | EXIT_DEAD), so just testing
> tsk->exit_state is sufficient.

... IMHO this change harms the readability of the code.


> +++ b/fs/proc/array.c
> @@ -145,8 +145,7 @@ static inline const char *get_task_state(struct task_struct *tsk)
>  					    TASK_UNINTERRUPTIBLE |
>  					    TASK_STOPPED |
>  					    TASK_TRACED)) |
> -			(tsk->exit_state & (EXIT_ZOMBIE |
> -					    EXIT_DEAD));
> +					   tsk->exit_state;

Here, for example, the code is /purposefully/ enumerating all the task
states, probably it makes sense to explicitly enumerate the exit states
as well?


> +++ b/kernel/fork.c
> @@ -115,7 +115,7 @@ EXPORT_SYMBOL(free_task);
>  
>  void __put_task_struct(struct task_struct *tsk)
>  {
> -	WARN_ON(!(tsk->exit_state & (EXIT_DEAD | EXIT_ZOMBIE)));
> +	WARN_ON(!tsk->exit_state);


> +++ b/kernel/sched.c
> @@ -5190,7 +5190,7 @@ static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
>  	struct rq *rq = cpu_rq(dead_cpu);
>  
>  	/* Must be exiting, otherwise would be on tasklist. */
> -	BUG_ON(p->exit_state != EXIT_ZOMBIE && p->exit_state != EXIT_DEAD);
> +	BUG_ON(!p->exit_state);

Regarding above two changes -- agreed, we want to catch /any/ exiting task
state, so (!p->exit_state) is /correct/, but still, enumerating those
explicitly helps readability. And although it's unlikely, in the future,
we may have an exit_state value for which we may _not_ want to complain
(WARN or BUG) in this code. So I'd still vote to keep the code explicit
like it was ...


Satyam
