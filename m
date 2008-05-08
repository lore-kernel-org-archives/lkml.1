Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbYEHGgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbYEHGgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYEHGgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:36:45 -0400
Received: from mga10.intel.com ([192.55.52.92]:26991 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754286AbYEHGgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="562131908"
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 08 May 2008 14:35:31 +0800
Message-Id: <1210228531.3453.124.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 18:26 +0200, Peter Zijlstra wrote: 
> On Wed, 2008-05-07 at 12:55 +0800, Zhang, Yanmin wrote:
> > ﻿Comparing with kernel 2.6.25, sysbench+mysql(oltp, readonly) has many
> > regression with 2.6.26-rc1.
> > 
> > 1) 8-core stoakley: 28%;
> > 2) 16-core tigerton: 20%;
> > 3) Itanium Montvale: 50%.
> > 
> > Bisect located below patch.
> > 
> > 8f1bc385cfbab474db6c27b5af1e439614f3025c is first bad commit
> > commit 8f1bc385cfbab474db6c27b5af1e439614f3025c
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Sat Apr 19 19:45:00 2008 +0200
> > 
> >     sched: fair: weight calculations
> >     
> >     In order to level the hierarchy, we need to calculate load based on the
> >     root view. That is, each task's load is in the same unit.
> > 
> > 
> > 
> > After I manually reverted the patch against 2.6.26-rc1 while fixing a couple of
> > conflictions/errors, sysbench oltp regression became less than 3% on 8-core
> > stoakley.
> 
> Does this patch help?
With the patch, oltp testing result is about 50% worse than the one of pure
2.6.26-rc1.

cpu idle with 16 threads( a parameter of sysbench):
1) 2.6.25: 1%
2) 2.6.26-rc1: 33%
3) 2.6.26-rc1+new_patch: 70%.

> 
> ---
> From: Mike Galbraith <efault@gmx.de>
> Subject: sched: fix weight calculations
> 
> The conversion between virtual and real time is as follows:
> 
>   dvt = rw/w * dt <=> dt = w/rw * dvt
> 
> Since we want the fair sleeper granularity to be in real time, we actually
> need to do:
> 
>   dvt = - rw/w * l
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_fair.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6-2/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6-2.orig/kernel/sched_fair.c
> +++ linux-2.6-2/kernel/sched_fair.c
> @@ -662,10 +662,15 @@ place_entity(struct cfs_rq *cfs_rq, stru
>  	if (!initial) {
>  		/* sleeps upto a single latency don't count. */
>  		if (sched_feat(NEW_FAIR_SLEEPERS)) {
> +			unsigned long thresh = sysctl_sched_latency;
> +
> +			/*
> +			 * convert the sleeper threshold into virtual time
> +			 */
>  			if (sched_feat(NORMALIZED_SLEEPER))
> -				vruntime -= calc_delta_weight(sysctl_sched_latency, se);
> -			else
> -				vruntime -= sysctl_sched_latency;
> +				thresh = calc_delta_fair(thresh, se);
> +
> +			vruntime -= thresh;
>  		}
>  
>  		/* ensure we never gain time by being placed backwards. */
> 
> 

