Return-Path: <linux-kernel-owner+w=401wt.eu-S1751020AbZLIIAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbZLIIAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZLIIAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:00:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:38851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZLIIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:00:01 -0500
Subject: Re: [patch 1/2] sched: Protect task->cpus_allowed access in
 sched_getaffinity()
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091208202026.769251187@linutronix.de>
References: <20091208202026.769251187@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 09:00:01 +0100
Message-ID: <1260345601.5489.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 20:24 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (sched-fix-sched-get-affinity-racy-access.patch)
> sched_getaffinity() is not protected against a concurrent modification
> of the tasks affinity.
> 
> Serialize the access with task_rq_lock(task).
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/sched.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6-tip/kernel/sched.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/sched.c
> +++ linux-2.6-tip/kernel/sched.c
> @@ -6631,6 +6631,8 @@ SYSCALL_DEFINE3(sched_setaffinity, pid_t
>  long sched_getaffinity(pid_t pid, struct cpumask *mask)
>  {
>  	struct task_struct *p;
> +	unsigned long flags;
> +	struct rq *rq;
>  	int retval;
>  
>  	get_online_cpus();
> @@ -6645,7 +6647,9 @@ long sched_getaffinity(pid_t pid, struct
>  	if (retval)
>  		goto out_unlock;
>  
> +	rq = task_rq_lock(p, &flags);
>  	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
> +	task_rq_unlock(rq, &flags);
>  
>  out_unlock:
>  	read_unlock(&tasklist_lock);
> 

Hehe, I wrote the exact same patch last night :-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

