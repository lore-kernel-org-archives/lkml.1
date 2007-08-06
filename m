Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbXHFKxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbXHFKxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXHFKxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:53:42 -0400
Received: from mail.screens.ru ([213.234.233.54]:60682 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbXHFKxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:53:41 -0400
Date: Mon, 6 Aug 2007 14:53:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Neil Brown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [NFS] 2.6.23-rc1-mm2
Message-ID: <20070806105316.GA140@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de> <20070803093830.39852a01.akpm@linux-foundation.org> <1186160608.7255.10.camel@localhost> <20070803172137.GA3783@tv-sign.ru> <1186381496.21957.30.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186381496.21957.30.camel@johannes.berg>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Johannes Berg wrote:
>
> On Fri, 2007-08-03 at 21:21 +0400, Oleg Nesterov wrote:
> 
> > To avoid a possible confusion: it is still OK if work->func() flushes
> > its own workqueue, so strictly speaking this trace is false positive,
> > but it would be very nice if we can get rid of this practice.
> 
> However, the question whether we should allow flush_workqueue from
> within a struct work is mainly an API policy issue; it doesn't hurt to
> flush a workqueue from within a work,

I am not sure, but currently I hope we can forbid this eventually, so I
personally think it is good that your patch complains.

> --- wireless-dev.orig/kernel/workqueue.c	2007-08-06 08:11:23.297846657 +0200
> +++ wireless-dev/kernel/workqueue.c	2007-08-06 08:19:54.727846657 +0200
> @@ -272,7 +272,7 @@ static void run_workqueue(struct cpu_wor
>  
>  		BUG_ON(get_wq_data(work) != cwq);
>  		work_clear_pending(work);
> -		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> +		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 1, 2, _THIS_IP_);
>  		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
>  		f(work);
>  		lock_release(&lockdep_map, 1, _THIS_IP_);
> @@ -395,7 +395,7 @@ void fastcall flush_workqueue(struct wor
>  	int cpu;
>  
>  	might_sleep();
> -	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> +	lock_acquire(&wq->lockdep_map, 0, 0, 1, 2, _THIS_IP_);
>  	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
>  	for_each_cpu_mask(cpu, *cpu_map)
>  		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
> @@ -779,7 +779,7 @@ static void cleanup_workqueue_thread(str
>  	if (cwq->thread == NULL)
>  		return;
>  
> -	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> +	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 1, 2, _THIS_IP_);
>  	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
>  
>  	flush_cpu_workqueue(cwq);

But this makes ->lockdep_map meaningless? We always take wq->lockdep_map
for reading, now we can't detect deadlocks.

	read_lock(A);
	lock(B);

vs
	lock(B);
	read_lock(A);

is valid, kernel/lockdep.c should not complain.

No?

Oleg.

