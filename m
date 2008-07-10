Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbYGJHbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbYGJHbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYGJHbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:31:11 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:54190 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYGJHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:31:10 -0400
Date: Thu, 10 Jul 2008 09:30:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, miaox@cn.fujitsu.com,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080710073055.GA7127@osiris.boeblingen.de.ibm.com>
References: <1215642760.5310.12.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215642760.5310.12.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:32:40AM +0200, Dmitry Adamushko wrote:
> 
> hm, while looking at this code again...
> 
> 
> Ingo,
> 
> I think we may have a race between try_to_wake_up() and migrate_live_tasks() -> move_task_off_dead_cpu()
> when the later one may end up looping endlessly.
> 
> 
> Subject: sched: prevent a potentially endless loop in move_task_off_dead_cpu()
> 
> Interrupts are enabled on other CPUs when migration_call(CPU_DEAD, ...) is called so we may get a race
> between try_to_wake_up() and migrate_live_tasks() -> move_task_off_dead_cpu(). The former one may push
> a task out of a dead CPU causing the later one to loop endlessly.

That's exactly what explains a dump I got yesterday. Thanks for fixing! :)

Will apply your patch and let you know if it fixes the problem.
(may take until next week unfortunately).

> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 94ead43..9397b87 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5621,8 +5621,10 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
> 
>  	double_rq_lock(rq_src, rq_dest);
>  	/* Already moved. */
> -	if (task_cpu(p) != src_cpu)
> +	if (task_cpu(p) != src_cpu) {
> +		ret = 1;
>  		goto out;
> +	}
>  	/* Affinity changed (again). */
>  	if (!cpu_isset(dest_cpu, p->cpus_allowed))
>  		goto out;
> 
> ---
> 
