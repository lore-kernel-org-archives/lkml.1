Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZBCEH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZBCEH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZBCEHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:07:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbZBCEHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:07:12 -0500
Date: Mon, 2 Feb 2009 20:06:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090202200649.c1af2fd1.akpm@linux-foundation.org>
In-Reply-To: <200902022305.51344.rusty@rustcorp.com.au>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200901310829.17099.rusty@rustcorp.com.au>
	<20090130141744.007fe725.akpm@linux-foundation.org>
	<200902022305.51344.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 23:05:50 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> +/**
> + * __work_on_cpu - run a function in a workqueue on a particular cpu
> + * @swq: the (singlethreaded) workqueue
> + * @cpu: the cpu to run on
> + * @fn: the function to run
> + * @arg: the function arg
> + *
> + * This will return the value @fn returns.
> + * It is up to the caller to ensure that the cpu doesn't go offline.
> + *
> + * Example:
> + *	int ret;
> + *	struct workqueue_struct *wq = create_singlethread_workqueue("myq");
> + *	if (unlikely(!wq))
> + *		ret = -ENOMEM;
> + *	else {
> + *		ret = __work_on_cpu(wq, cpu, fn, arg);
> + *		destroy_workqueue(wq);
> + *	}
> + */
> +long __work_on_cpu(struct workqueue_struct *swq,
> +		   unsigned int cpu, long (*fn)(void *), void *arg)
> +{
> +	struct work_for_cpu wfc;
> +
> +	INIT_WORK(&wfc.work, do_work_for_cpu);
> +	wfc.fn = fn;
> +	wfc.arg = arg;
> +	wfc.cpu = cpu;
> +	BUG_ON(!swq->singlethread);
> +	queue_work(swq, &wfc.work);
> +	flush_work(&wfc.work);
> +
> +	return wfc.ret;
> +}
> +EXPORT_SYMBOL_GPL(__work_on_cpu);

If we're going to do this then we might as well create the thread right
here, use it once and then let it exit.

That's slower, but I suspect that we could get a lot of that inefficiency
back by coming up with a kernel_thread_on_cpu(), so we don't go and schedule
the function on a random CPU only to immediately switch it over to a different
one, dunno.

But as you say, rdmsr_on_cpu() is easy to do, using
smp_call_function_single().  Then we can easily convert all other
work_on_cpu() callers to smp_call_function_single() and zap
work_on_cpu().  The best outcome, methinks.
