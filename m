Return-Path: <linux-kernel-owner+w=401wt.eu-S1762162AbZAOHg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162AbZAOHg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZAOHgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:36:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:40100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbZAOHgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:36:19 -0500
Subject: Re: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, dev@jaysonking.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1231986636.10565.159.camel@minggr.sh.intel.com>
References: <1231837036.11429.27.camel@ymzhang>
	 <1231839464.14655.12.camel@marge.simson.net>
	 <1231986636.10565.159.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jan 2009 08:36:13 +0100
Message-Id: <1232004974.14825.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 10:30 +0800, Lin Ming wrote:
> On Tue, 2009-01-13 at 17:37 +0800, Mike Galbraith wrote:
> > On Tue, 2009-01-13 at 16:57 +0800, Zhang, Yanmin wrote:
> > > Comparing with 2.6.28's results, specjbb2005 has about 7% regression with 2.6.29-rc1
> > > on my a couple of x86_64 machines. aim7 has about 1.7% regression.
> > > 
> > > Ming did a quick bisect with aim7 and located below patch.
> > > 
> > > ﻿commit 0a582440ff546e2c6610d1acec325e91b4efd313
> > > Author: Mike Galbraith <efault@gmx.de>
> > > Date:   Fri Jan 2 12:16:42 2009 +0100
> > > 
> > >     sched: fix sched_slice()
> > >     
> > >     Impact: fix bad-interactivity buglet
> > >     
> > >     Fix sched_slice() to emit a sane result whether a task is currently
> > >     enqueued or not.
> > >     
> > >     Signed-off-by: Mike Galbraith <efault@gmx.de>
> > >     Tested-by: Jayson King <dev@jaysonking.com>
> > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > 
> > > After we revert the patch, aim7 regression disappeared. specjbb2005 regression becomes
> > > less than 1.5% on 8-core stokley and disappears on 16-core tigerton. I don't know what
> > > causes the last 1.5% regression.
> > > 
> > > As tbench has about 5% improvement and oltp(mysql+sysbench) has 5% improvement, we also tested
> > > to make sure such improvement isn't related to above patch. volanoMark's improvement is also not
> > > related to the patch. So it seems safe to revert it.
> > 
> > No, it's not safe to just revert.  You can replace it with something
> > else, but as long as sched_slice() is called for unqueued tasks, it must
> > emit sane slices, otherwise you can experience a latency-hit-from-hell.
> > 
> > See thread: problem with "sched: revert back to per-rq vruntime"?
> 
> Below patch fixes aim7 regression and specjbb2005 regression becomes
> less than 1.5% on 8-core stokley.
> 
> Jayson,
> Mike's patch fixed the latency problem you reported
> would you please help to test this patch to see if it still works fine now?
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 8e1352c..617e54c 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -429,10 +429,10 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
>  
>  	for_each_sched_entity(se) {
> -		struct load_weight *load = &cfs_rq->load;
> +		struct load_weight *load = &cfs_rq_of(se)->load;
>  
>  		if (unlikely(!se->on_rq)) {
> -			struct load_weight lw = cfs_rq->load;
> +			struct load_weight lw = cfs_rq_of(se)->load;
>  
>  			update_load_add(&lw, se->load.weight);
>  			load = &lw;
> 

Ugh, that's not making sense, the thing is, if !se->on_rq it doesn't yet
have a sensible cfs_rq_of().



