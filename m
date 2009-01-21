Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbZAUMU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbZAUMU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbZAUMUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:20:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbZAUMUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:20:47 -0500
Date: Wed, 21 Jan 2009 13:17:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
Message-ID: <20090121121756.GA11942@redhat.com>
References: <4976EE0B.5090200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4976EE0B.5090200@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Lai Jiangshan wrote:
>
> allocating memory for every cpu for single workqueue is waste.

Yes, perhaps this makes sense, we can save a bit of per-cpu memory
for each single-threaded wq, and the patch looks correct.

> -static struct cpu_workqueue_struct *
> -init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
> +static void init_cpu_workqueue(struct workqueue_struct *wq,
> +		struct cpu_workqueue_struct *cwq)
>  {
> -	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> -
>  	cwq->wq = wq;
>  	spin_lock_init(&cwq->lock);
>  	INIT_LIST_HEAD(&cwq->worklist);
>  	init_waitqueue_head(&cwq->more_work);
> -
> -	return cwq;
>  }

Do we really need to change the prototype of init_cpu_workqueue()
and change then change __create_workqueue_key() accordingly?
Afaics, the only change in init_cpu_workqueue() we need is

	-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
	+	struct cpu_workqueue_struct *cwq = wq_per_cpu(wq, cpu);

no?

> @@ -906,6 +907,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  	const struct cpumask *cpu_map = wq_cpu_map(wq);
>  	int cpu;
>
> +	if (is_wq_single_threaded(wq)) {
> +		cleanup_workqueue_thread(wq->cpu_wq);
> +		kfree(wq->cpu_wq);
> +		kfree(wq);
> +		return;
> +	}

again, not sure I understand why this change is needed. Afaics we
only need to use kfree(wq->cpu_wq) instead of free_percpu() if
it is single-threaded.

Oleg.

