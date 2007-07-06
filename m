Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbXGFGDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbXGFGDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbXGFGD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:03:28 -0400
Received: from mail.screens.ru ([213.234.233.54]:57550 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663AbXGFGD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:03:28 -0400
Date: Fri, 6 Jul 2007 10:02:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070706060257.GA188@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>
> This patch adds the ability to protect critical sections from migration to
> another CPU without disabling preemption.
>
> Typical use:
>
> migration_disable();
> local_inc(&__get_cpu_var(&my_local_t_var));
> migration_enable();
>
> --- linux-2.6-lttng.orig/kernel/sched.c	2007-07-05 16:28:15.000000000 -0400
> +++ linux-2.6-lttng/kernel/sched.c	2007-07-05 16:53:24.000000000 -0400
> @@ -1996,6 +1996,7 @@
>  	 * 1) running (obviously), or
>  	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
>  	 * 3) are cache-hot on their current CPU.
> +	 * 4) migration preemption is non 0 for this non running task.
>  	 */
>  	if (!cpu_isset(this_cpu, p->cpus_allowed))
>  		return 0;
> @@ -2003,6 +2004,8 @@
>
>  	if (task_running(rq, p))
>  		return 0;
> +	if (task_thread_info(p)->migration_count)
> +		return 0;

Question: This means that the task could be preempted, but can't sleep, yes?

Because try_to_wake_up() can change ->cpu. Shouldn't might_sleep() check
->migration_count then? Or we can change try_to_wake_up().

What if the task does copy_process() under migration_disable() ? Child
gets a copy of ->migration_count.

Also, cpu_down() still can migrate this task to another CPU.

Oleg.

