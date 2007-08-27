Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbXH0QXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbXH0QXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbXH0QXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:23:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44003 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbXH0QXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:23:35 -0400
Date: Mon, 27 Aug 2007 20:25:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cliff Wickman <cpw@sgi.com>
Cc: akpm@linux-foundation.org, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V3: hotplug cpu: migrate a task within its cpuset
Message-ID: <20070827162516.GA1398@tv-sign.ru>
References: <20070827160703.GA2446@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827160703.GA2446@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Cliff Wickman wrote:
> 
> --- linus.070821.orig/kernel/sched.c
> +++ linus.070821/kernel/sched.c
> @@ -61,6 +61,7 @@
>  #include <linux/delayacct.h>
>  #include <linux/reciprocal_div.h>
>  #include <linux/unistd.h>
> +#include <linux/cpuset.h>
>  
>  #include <asm/tlb.h>
>  
> @@ -5091,6 +5092,19 @@ restart:
>  	if (dest_cpu == NR_CPUS)
>  		dest_cpu = any_online_cpu(p->cpus_allowed);
>  
> +	/* try to stay on the same cpuset */
> +	if (dest_cpu == NR_CPUS) {
> +		rq = task_rq_lock(p, &flags);
> +		/*
> +		 * The cpuset_cpus_allowed_locked() variant of
> +		 * cpuset_cpus_allowed() will not block
> +		 * It must be called within calls to cpuset_lock/cpuset_unlock.
> +		 */
> +		p->cpus_allowed = cpuset_cpus_allowed_locked(p);
> +		dest_cpu = any_online_cpu(p->cpus_allowed);
> +		task_rq_unlock(rq, &flags);

No, no, we can't take task_lock() under rq->lock, nesting error. I think we
need a local "cpumask_t cpus_allowed = cpuset_cpus_allowed_locked()", like
sched_setaffinity() does.

task_lock() doesn't disable irqs, this means that it can't be used under any
lock which can be used from interrupt context.

Oleg.

