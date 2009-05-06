Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZEFKMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZEFKMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZEFKM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:12:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZEFKMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:12:25 -0400
Date: Wed, 6 May 2009 12:12:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched: emit thread info flags with stack trace
Message-ID: <20090506101211.GD15323@elte.hu>
References: <alpine.DEB.2.00.0905040136390.15831@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905040136390.15831@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> When a thread is oom killed and fails to exit, it's helpful to know which
> threads have access to memory reserves if the machine livelocks.  This is
> done by testing for the TIF_MEMDIE thread info flag and should be
> displayed alongside stack traces to identify tasks that have access to
> such reserves but are still stuck allocating pages, for instance.
> 
> It would probably be helpful in other cases as well, so all thread info
> flags are emitted when showing a task.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  kernel/sched.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6490,8 +6490,9 @@ void sched_show_task(struct task_struct *p)
>  #ifdef CONFIG_DEBUG_STACK_USAGE
>  	free = stack_not_used(p);
>  #endif
> -	printk(KERN_CONT "%5lu %5d %6d\n", free,
> -		task_pid_nr(p), task_pid_nr(p->real_parent));
> +	printk(KERN_CONT "%5lu %5d %6d 0x%08x\n", free,
> +		task_pid_nr(p), task_pid_nr(p->real_parent),
> +		task_thread_info(p)->flags);
>  
>  	show_stack(p, NULL);
>  }

ok. We just seem to have enough space to do that with 
printk-timestamps enabled, without wrapping the line:

Before:

 [62034.343909] as            R  running task     6240 27598  27596

After:

 [62034.343909] as            R  running task     6240 27598  27596 0x12345678

Applied to tip/sched/core, thanks David!

	Ingo
