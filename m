Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYGYMku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYGYMku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYGYMkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:40:42 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:61230 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYGYMkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:40:41 -0400
Subject: Re: [patch, rfc: 2/2] sched, hotplug: ensure a task is on the
	valid cpu after set_cpus_allowed_ptr()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1216937730.5368.16.camel@earth>
References: <1216937730.5368.16.camel@earth>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 14:40:49 +0200
Message-Id: <1216989649.7257.381.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 00:15 +0200, Dmitry Adamushko wrote:
> 	
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: sched, hotplug: ensure a task is on the valid cpu after
> set_cpus_allowed_ptr()
> 
> ---
>     sched, hotplug: ensure a task is on the valid cpu after set_cpus_allowed_ptr()
>     
>     The 'new_mask' may not include task_cpu(p) so we migrate 'p' on another 'cpu'.
>     In case it can't be placed on this 'cpu' immediately, we submit a request
>     to the migration thread and wait for its completion.
>     
>     Now, by the moment this request gets handled by the migration_thread,
>     'cpu' may well be offline/non-active. As a result, 'p' continues
>     running on its old cpu which is not in the 'new_mask'.
>     
>     Fix it: ensure 'p' ends up on a valid cpu.
>     
>     Theoreticaly (but unlikely), we may get an endless loop if someone cpu_down()'s
>     a new cpu we have choosen on each iteration.
>     
>     Alternatively, we may introduce a special type of request to migration_thread,
>     namely "move_to_any_allowed_cpu" (e.g. by specifying dest_cpu == -1).
>     
>     Note, any_active_cpu() instead of any_online_cpu() would be better here.

Hrmm,.. this is all growing into something of a mess.. defeating the
whole purpose of introducing that cpu_active_map stuff.

Would the suggested SRCU logic simplify all this?

>     Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index b4ccc8b..c3bd78a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5774,21 +5774,23 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
>  	}
>  
>  	/* Can the task run on the task's current CPU? If so, we're done */
> -	if (cpu_isset(task_cpu(p), *new_mask))
> -		goto out;
> +	while (!cpu_isset(task_cpu(p), p->cpus_allowed)) {
> +		int cpu = any_online_cpu(p->cpus_allowed);
>  
> -	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
> -		/* Need to wait for migration thread (might exit: take ref). */
> -		struct task_struct *mt = rq->migration_thread;
> +		if (migrate_task(p, cpu, &req)) {
> +			/* Need to wait for migration thread (might exit: take ref). */
> +			struct task_struct *mt = rq->migration_thread;
>  
> -		get_task_struct(mt);
> -		task_rq_unlock(rq, &flags);
> -		wake_up_process(mt);
> -		put_task_struct(mt);
> +			get_task_struct(mt);
> +			task_rq_unlock(rq, &flags);
> +			wake_up_process(mt);
> +			put_task_struct(mt);
>  
> -		wait_for_completion(&req.done);
> -		tlb_migrate_finish(p->mm);
> -		return 0;
> +			wait_for_completion(&req.done);
> +			tlb_migrate_finish(p->mm);
> +
> +			rq = task_rq_lock(p, &flags);
> +		}
>  	}
>  out:
>  	task_rq_unlock(rq, &flags);
> 
> 

