Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0CHTEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:04:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0CHTDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:03:54 -0500
Date: Mon, 8 Mar 2010 20:01:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] cpuhog: implement cpuhog
Message-ID: <20100308190142.GA9149@redhat.com>
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268063603-7425-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268063603-7425-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Tejun Heo wrote:
>
> Implement a simplistic per-cpu maximum priority cpu hogging mechanism
> named cpuhog.  A callback can be scheduled to run on one or multiple
> cpus with maximum priority monopolozing those cpus.  This is primarily
> to replace and unify RT workqueue usage in stop_machine and scheduler
> migration_thread which currently is serving multiple purposes.
>
> Four functions are provided - hog_one_cpu(), hog_one_cpu_nowait(),
> hog_cpus() and try_hog_cpus().
>
> This is to allow clean sharing of resources among stop_cpu and all the
> migration thread users.  One cpuhog thread per cpu is created which is
> currently named "hog/CPU".  This will eventually replace the migration
> thread and take on its name.

Heh. In no way I can ack (or even review) the changes in sched.c, but
personally I like this idea.

And I think cpuhog can have more users. Say, wait_task_context_switch()
could use hog_one_cpu() to force the context switch instead of looping,
perhaps.

A simple question,

> +struct cpuhog_done {
> +	atomic_t		nr_todo;	/* nr left to execute */
> +	bool			executed;	/* actually executed? */
> +	int			ret;		/* collected return value */
> +	struct completion	completion;	/* fired if nr_todo reaches 0 */
> +};
> +
> +static void cpuhog_signal_done(struct cpuhog_done *done, bool executed)
> +{
> +	if (done) {
> +		if (executed)
> +			done->executed = true;
> +		if (atomic_dec_and_test(&done->nr_todo))
> +			complete(&done->completion);
> +	}
> +}

So, ->executed becomes T if at least one cpuhog_thread() thread calls ->fn(),

> +int __hog_cpus(const struct cpumask *cpumask, cpuhog_fn_t fn, void *arg)
> +{
> ...
> +
> +	wait_for_completion(&done.completion);
> +	return done.executed ? done.ret : -ENOENT;
> +}

Is this really right?

I mean, perhaps it makes more sense if ->executed was set only if _all_
CPUs from cpumask "ack" this call?


I guess, currently this doesn't matter, stop_machine() uses cpu_online_mask
and we can't race with hotplug.

Oleg.

