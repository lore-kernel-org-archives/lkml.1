Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbYEHJXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbYEHJXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYEHJXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:23:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:29725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYEHJXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:23:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="279171066"
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1210238114.11887.3.camel@marge.simson.net>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net>
	 <1210237267.3453.143.camel@ymzhang>
	 <1210238114.11887.3.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 08 May 2008 17:22:18 +0800
Message-Id: <1210238538.3453.146.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 11:15 +0200, Mike Galbraith wrote:
> On Thu, 2008-05-08 at 17:01 +0800, Zhang, Yanmin wrote:
> > On Thu, 2008-05-08 at 10:00 +0200, Mike Galbraith wrote:
> 
> > > Hm.  I was doing some sysbench+postgress(oltp, ro) testing on my little
> > > Q6600 box this morning, and saw a different picture.
> 
> > How many cpu are in the Q6600?
> 
> 1.

> > 3) 2.6.26-rc1+weight
> > ﻿Number of threads: 16
> > 	read/write requests:                 3219076 (26824.22 per sec.)
> > 
> > I'm not sure if more cpu could introduce more contention in this test.
> 
> -rc1.  Do you have the fix below applied?
No. 

> 
> commit a992241de614dd2b7c97a9ba64e28c0e563f19bf
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon May 5 23:56:17 2008 +0200
> 
>     sched: fix normalized sleeper
>     
>     Normalized sleeper uses calc_delta*() which requires that the rq load is
>     already updated, so move account_entity_enqueue() before place_entity()
>     
>     Tested-by: Frans Pop <elendil@planet.nl>
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 89fa32b..1295ddc 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -682,6 +682,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
>  	 * Update run-time statistics of the 'current'.
>  	 */
>  	update_curr(cfs_rq);
> +	account_entity_enqueue(cfs_rq, se);
>  
>  	if (wakeup) {
>  		place_entity(cfs_rq, se, 0);
> @@ -692,7 +693,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
>  	check_spread(cfs_rq, se);
>  	if (se != cfs_rq->curr)
>  		__enqueue_entity(cfs_rq, se);
> -	account_entity_enqueue(cfs_rq, se);
>  }
>  
>  static void update_avg(u64 *avg, u64 sample)
> 
> 

