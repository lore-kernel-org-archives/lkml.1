Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZA1TsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZA1TsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZA1Trn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:47:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZA1Trl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:47:41 -0500
Date: Wed, 28 Jan 2009 11:44:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090128114440.77abc1b2.akpm@linux-foundation.org>
In-Reply-To: <200901282332.29429.rusty@rustcorp.com.au>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200901271735.12034.rusty@rustcorp.com.au>
	<20090126232519.44f2943c.akpm@linux-foundation.org>
	<200901282332.29429.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 23:32:28 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> +static int do_work_on_cpu(void *unused)
> +{
> +	for (;;) {
> +		struct completion *done;
> +
> +		wait_event(woc_wq, current_work != NULL);
> +
> +		set_cpus_allowed_ptr(current, cpumask_of(current_work->cpu));
> +		WARN_ON(smp_processor_id() != current_work->cpu);
> +
> +		current_work->ret = current_work->fn(current_work->arg);
> +		/* Make sure ret is set before we complete().  Paranoia. */
> +		wmb();
> +
> +		/* Reset current_work so we don't spin. */
> +		done = &current_work->done;
> +		current_work = NULL;
> +
> +		/* Reset current_work for next work_on_cpu(). */
> +		complete(done);
> +	}
> +}
> +
> +/**
> + * work_on_cpu - run a function in user context on a particular cpu
> + * @cpu: the cpu to run on
> + * @fn: the function to run
> + * @arg: the function arg
> + *
> + * This will return the value @fn returns.
> + * It is up to the caller to ensure that the cpu doesn't go offline.
> + */
> +long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> +{
> +	struct work_for_cpu work;
> +
> +	work.cpu = cpu;
> +	work.fn = fn;
> +	work.arg = arg;
> +	init_completion(&work.done);
> +
> +	mutex_lock(&woc_mutex);
> +	/* Make sure all is in place before it sees fn set. */
> +	wmb();
> +	current_work = &work;
> +	wake_up(&woc_wq);
> +
> +	wait_for_completion(&work.done);
> +	BUG_ON(current_work);
> +	mutex_unlock(&woc_mutex);
> +
> +	return work.ret;
> +}

We still have a queue - it's implicit now, rather than explicit.

It's vulnerable to the same deadlock, I think?  Suppose we have:

- A lock, L

- A callback function which takes that lock, called function_which_takes_L()

- A task A which does work_on_cpu(function_which_takes_L)

- A task B which does

	lock(L);
	work_on_cpu(something_else);


Now,

- A calls work_on_cpu() and takes woc_mutex.

- Before function_which_takes_L() has started to execute, task B takes L
  then calls work_on_cpu() and task B blocks on woc_mutex.

- Now function_which_takes_L() runs, and blocks on L

Nothing else happens...
