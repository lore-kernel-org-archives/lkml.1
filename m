Return-Path: <linux-kernel-owner+w=401wt.eu-S1751638AbZJTEYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbZJTEYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZJTEYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:24:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZJTEYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:24:20 -0400
Subject: Re: RFC [patch] sched: strengthen LAST_BUDDY and minimize buddy
 induced latencies V3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1255775063.32691.5.camel@marge.simson.net>
References: <1255775063.32691.5.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 06:24:16 +0200
Message-Id: <1256012656.17774.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-17 at 12:24 +0200, Mike Galbraith wrote:
> sched: strengthen LAST_BUDDY and minimize buddy induced latencies.
> 
> This patch restores the effectiveness of LAST_BUDDY in preventing pgsql+oltp
> from collapsing due to wakeup preemption.  It also minimizes buddy induced
> latencies.  x264 testcase spawns new worker threads at a high rate, and was
> being affected badly by NEXT_BUDDY.  It turned out that CACHE_HOT_BUDDY was
> thwarting idle balancing.  This patch ensures that the load can disperse,
> and that buddies can't make any task excessively late.

> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2007,8 +2007,12 @@ task_hot(struct task_struct *p, u64 now,
>  
>  	/*
>  	 * Buddy candidates are cache hot:
> +	 *
> +	 * Do not honor buddies if there may be nothing else to
> +	 * prevent us from becoming idle.
>  	 */
>  	if (sched_feat(CACHE_HOT_BUDDY) &&
> +			task_rq(p)->nr_running >= sched_nr_latency &&
>  			(&p->se == cfs_rq_of(&p->se)->next ||
>  			 &p->se == cfs_rq_of(&p->se)->last))
>  		return 1;

I'm not sure about this. The sched_nr_latency seems arbitrary, 1 seems
like a more natural boundary.

Also, one thing that arjan found was that we don't need to consider
buddies cache hot if we're migrating them within a cache domain. So we
need to add a SD_flag and sched_domain to properly represent the cache
hierarchy.

