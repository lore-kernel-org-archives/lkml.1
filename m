Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZFPJFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZFPJFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZFPJFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:05:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:55128 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753575AbZFPJFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:05:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18MIdNQXaEMzS0dz/BhzS6qUXFEajppji+FkNIeBc
	7XYxSL8lR/jsg2
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
 policy flag, fourth try
From: Mike Galbraith <efault@gmx.de>
To: Lennart Poettering <lennart@poettering.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090615152714.GA29092@tango.0pointer.de>
References: <20090615152714.GA29092@tango.0pointer.de>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 11:05:08 +0200
Message-Id: <1245143108.6038.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 17:27 +0200, Lennart Poettering wrote: 
> (this is the fourth version of the patch, only change is that I added
> the missing Signed-off-by line, as Ingo requested)
> 
> This patch introduces a new flag SCHED_RESET_ON_FORK which can be passed
> to the kernel via sched_setscheduler(), ORed in the policy parameter. If
> set this will make sure that when the process forks a) the scheduling
> priority is reset to DEFAULT_PRIO if it was higher and b) the scheduling
> policy is reset to SCHED_NORMAL if it was either SCHED_FIFO or SCHED_RR.
> 
> Why have this?
> 
> Currently, if a process is real-time scheduled this will 'leak' to all
> its child processes. For security reasons it is often (always?) a good
> idea to make sure that if a process acquires RT scheduling this is
> confined to this process and only this process. More specifically this
> makes the per-process resource limit RLIMIT_RTTIME useful for security
> purposes, because it makes it impossible to use a fork bomb to
> circumvent the per-process RLIMIT_RTTIME accounting.
> 
> This feature is also useful for tools like 'renice' which can then
> change the nice level of a process without having this spill to all its
> child processes.

That didn't work for me, reniced tasks with the flag set retained their
-nice status.  See patchlet and comments below. 

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8ec9d13..1db3e4a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2613,12 +2613,26 @@ void sched_fork(struct task_struct *p, int clone_flags)
>  	set_task_cpu(p, cpu);
>  
>  	/*
> -	 * Make sure we do not leak PI boosting priority to the child:
> +	 * Revert to default priority/policy on fork if requested. Make sure we
> +	 * do not leak PI boosting priority to the child.
>  	 */
> -	p->prio = current->normal_prio;

Nit: that comment/assignment was placed there to make sure that readers
knew that this specific line was critical to PI.  Now, it's mixed in
with something unrelated.
 
> +	if (current->sched_reset_on_fork &&
> +			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
> +		p->policy = SCHED_NORMAL;
> +
> +	if (current->sched_reset_on_fork &&
> +			(current->normal_prio < DEFAULT_PRIO))
> +		p->prio = DEFAULT_PRIO;
> +	else
> +		p->prio = current->normal_prio;
> +

I think it's cleaner to keep reset_on_fork functionality separate.
Thoughts on the below?

Make SCHED_RESET_ON_FORK to DTRT for reniced tasks, and make the sched_fork()
SCHED_RESET_ON_FORK bits a self-contained unlikely code block.

Signed-off-by: Mike Galbraith <efault@gmx.de>

 kernel/sched.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 80636ed..cb6bbc6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2613,28 +2613,35 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	set_task_cpu(p, cpu);
 
 	/*
-	 * Revert to default priority/policy on fork if requested. Make sure we
-	 * do not leak PI boosting priority to the child.
+	 * Make sure we do not leak PI boosting priority to the child.
 	 */
-	if (current->sched_reset_on_fork &&
-			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
-		p->policy = SCHED_NORMAL;
+	p->prio = current->normal_prio;
 
-	if (current->sched_reset_on_fork &&
-			(current->normal_prio < DEFAULT_PRIO))
-		p->prio = DEFAULT_PRIO;
-	else
-		p->prio = current->normal_prio;
+	/*
+	 * Revert to default priority/policy on fork if requested.
+	 */
+	if (unlikely(p->sched_reset_on_fork)) {
+		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR)
+			p->policy = SCHED_NORMAL;
+
+		if (p->normal_prio < DEFAULT_PRIO)
+			p->prio = DEFAULT_PRIO;
+
+		if (PRIO_TO_NICE(p->static_prio) < 0) {
+			p->static_prio = NICE_TO_PRIO(0);
+			set_load_weight(p);
+		}
+
+		/*
+		 * We don't need the reset flag anymore after the fork. It has
+		 * fulfilled its duty:
+		 */
+		p->sched_reset_on_fork = 0;
+	}
 
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
-	/*
-	 * We don't need the reset flag anymore after the fork. It has
-	 * fulfilled its duty:
-	 */
-	p->sched_reset_on_fork = 0;
-
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));


