Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbXJLMLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbXJLMLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbXJLMLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:11:13 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:53772 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXJLMLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:11:12 -0400
Date: Fri, 12 Oct 2007 08:10:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] RT: Only consider online CPUs when pushing rt tasks
In-Reply-To: <20071011215959.27097.71140.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0710120809490.8900@gandalf.stny.rr.com>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
 <20071011215959.27097.71140.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Thu, 11 Oct 2007, Gregory Haskins wrote:

> task->cpus_allowed can have bit positions that are set for CPUs that are
> not currently online.  So we optimze our search by ANDing against the online
> set.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/sched.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 24b38b4..0ca3905 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1510,10 +1510,14 @@ static int push_rt_task(struct rq *this_rq)
>
>  	/* Only try this algorithm three times */
>  	for (tries = 0; tries < 3; tries++) {
> +		cpumask_t mask;
> +
> +		cpus_and(mask, cpu_online_map, next_task->cpus_allowed);
> +

Gag! I definitely sent you an old patch. I fixed this a while ago :-(

-- Steve

>  		/*
>  		 * Scan each rq for the lowest prio.
>  		 */
> -		for_each_cpu_mask(cpu, next_task->cpus_allowed) {
> +		for_each_cpu_mask(cpu, mask) {
>  			struct rq *rq = &per_cpu(runqueues, cpu);
>
>  			if (cpu == smp_processor_id())
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
