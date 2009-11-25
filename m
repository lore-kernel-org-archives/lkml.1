Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbZKYS1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbZKYS1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbZKYS1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:27:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:56738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039AbZKYS1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:27:50 -0500
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258891781.14325.34.camel@marge.simson.net>
References: <1258891781.14325.34.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 19:27:52 +0100
Message-ID: <1259173672.4027.732.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 13:09 +0100, Mike Galbraith wrote:
> sched: fix set_task_cpu() and provide an unlocked runqueue variant.
> 
> set_task_cpu() falsifies migration stats by unconditionally generating migration
> stats whether a task's cpu actually changed or not.  As used in copy_process(),
> the runqueue is unlocked, so we need to provide an unlocked variant which does
> the locking to provide a write barrier.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> 
> ---

> +void set_task_cpu_unlocked(struct task_struct *p, unsigned int new_cpu)
> +{
> +	unsigned long flags;
> +	struct rq *rq, *new_rq = cpu_rq(new_cpu);
> +
> +	smp_wmb();
> +	rq = task_rq_lock(p, &flags);
> +	update_rq_clock(rq);
> +	if (rq != new_rq)
> +		update_rq_clock(new_rq);
> +	set_task_cpu(p, new_cpu);
> +	task_rq_unlock(rq, &flags);
> +}

I've got to ask, what's that barrier for?



