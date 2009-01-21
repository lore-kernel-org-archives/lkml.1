Return-Path: <linux-kernel-owner+w=401wt.eu-S1764251AbZAUKsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764251AbZAUKsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbZAUKs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:48:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbZAUKs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:48:27 -0500
Date: Wed, 21 Jan 2009 11:48:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
Message-ID: <20090121104811.GB25531@elte.hu>
References: <4976EE0B.5090200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4976EE0B.5090200@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> allocating memory for every cpu for single workqueue is waste.

good idea.

One detail:

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
> +
>  	cpu_maps_update_begin();
>  	spin_lock(&workqueue_lock);
>  	list_del(&wq->list);

Arent we forgetting to remove the workqueue from the &workqueues list in 
the new single-thread case?

Also, see the checkpatch output from kernel/workqueue.c - the warnings 
below are correct and should be cleaned up.

	Ingo

WARNING: printk() should include KERN_ facility level
#268: FILE: workqueue.c:268:
+		printk("%s: recursion depth exceeded: %d\n",

ERROR: code indent should use tabs where possible
#304: FILE: workqueue.c:304:
+^I^I^I^I       ^Itask_pid_nr(current));$

ERROR: "foo* bar" should be "foo *bar"
#555: FILE: workqueue.c:555:
+				struct timer_list* timer)

ERROR: code indent should use tabs where possible
#916: FILE: workqueue.c:916:
+ ^Icpu_maps_update_done();$

kernel/workqueue.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
