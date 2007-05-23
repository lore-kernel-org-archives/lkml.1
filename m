Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbXEWV3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbXEWV3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbXEWV3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:29:18 -0400
Received: from mail.screens.ru ([213.234.233.54]:38000 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384AbXEWV3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:29:16 -0400
Date: Thu, 24 May 2007 01:29:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: cpw@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070523212902.GA235@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
>
> In order to do this, move_task_off_dead_cpu() must make a call to
> cpuset_cpus_allowed(), which may block.
>
> move_task_off_dead_cpu() has been within a critical region when called
> from migrate_live_tasks().  So this patch also changes migrate_live_tasks()
> to enable interrupts before calling move_task_off_dead_cpu().
> Since the tasklist_lock is dropped, the list scan must be restarted from
> the top.
>
> [... snip ...]
>
> - * NOTE: interrupts should be disabled by the caller
> + * NOTE: interrupts are not disabled by the caller
>   */
>  static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
>  {
> @@ -5008,6 +5008,17 @@ restart:
>  	if (dest_cpu == NR_CPUS)
>  		dest_cpu = any_online_cpu(p->cpus_allowed);
>
> +	/* try to stay on the same cpuset */
> +	if (dest_cpu == NR_CPUS) {
> +		/*
> +		 * Call to cpuset_cpus_allowed may sleep, so we depend
> +		 * on move_task_off_dead_cpu() being called in a non-critical
> +		 * region.
> +		 */
> +		p->cpus_allowed = cpuset_cpus_allowed(p);
> +		dest_cpu = any_online_cpu(p->cpus_allowed);
> +	}

I know nothing about cpuset.c, a _very_ naive question.

Do we really need task_lock() (used by cpuset_cpus_allowed) here ?

If not, probably we can make this simpler. CPU_DEAD takes cpuset_lock(),
move_task_off_dead_cpu() uses guarantee_online_cpus() which doesn't sleep,
so we don't need other changes.

Possible?

If not, this patch should also change migrate_dead(), it still calls
move_task_off_dead_cpu() with irqs disabled, no?

Oleg.

