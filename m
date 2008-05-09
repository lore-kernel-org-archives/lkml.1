Return-Path: <linux-kernel-owner+w=401wt.eu-S934767AbYEIBR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767AbYEIBR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYEIBRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:17:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:46851 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbYEIBRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:17:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,457,1204531200"; 
   d="scan'208";a="326151136"
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1210238622.13978.193.camel@twins>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net>
	 <1210237267.3453.143.camel@ymzhang>
	 <1210238114.11887.3.camel@marge.simson.net>
	 <1210238622.13978.193.camel@twins>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 May 2008 09:16:19 +0800
Message-Id: <1210295779.3453.155.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 11:23 +0200, Peter Zijlstra wrote:
> On Thu, 2008-05-08 at 11:15 +0200, Mike Galbraith wrote:
> > On Thu, 2008-05-08 at 17:01 +0800, Zhang, Yanmin wrote:
> > > On Thu, 2008-05-08 at 10:00 +0200, Mike Galbraith wrote:
> > 
> > > > Hm.  I was doing some sysbench+postgress(oltp, ro) testing on my little
> > > > Q6600 box this morning, and saw a different picture.
> > 
> > > How many cpu are in the Q6600?
> > 
> > 1.
> > 
> > > > 
> > > > In attached pdf, .bkl refers to Linus' BKL patch, .weight is the weight
> > > > fix, both are applied to git.today.  The script I used is also attached.
> > > With my 8-core stoakley (using mysql):
> > > 1) 2.6.25:
> > > Number of threads: 6
> > >     read/write requests:                 8025024 (66874.53 per sec.)
> > > Number of threads: 8
> > >     read/write requests:                 9132816 (76106.14 per sec.)
> > > Number of threads: 10
> > >     read/write requests:                 9244998 (77040.75 per sec.)
> > > Number of threads: 12
> > >     read/write requests:                 8994174 (74950.36 per sec.)
> > > Number of threads: 14
> > >     read/write requests:                 9051322 (75426.54 per sec.)
> > > Number of threads: 16
> > >     read/write requests:                 9015412 (75126.93 per sec.)
> > > 
> > > 2) 2.6.26-rc1:
> > > Number of threads: 6
> > >     read/write requests:                 5754056 (47949.87 per sec.)
> > > Number of threads: 8
> > >     read/write requests:                 6528480 (54403.29 per sec.)
> > > Number of threads: 10
> > >     read/write requests:                 6444690 (53705.16 per sec.)
> > > Number of threads: 12
> > >     read/write requests:                 6544258 (54534.23 per sec.)
> > > Number of threads: 14
> > >     read/write requests:                 6796650 (56637.65 per sec.)
> > > Number of threads: 16
> > >     read/write requests:                 6718110 (55983.18 per sec.)
> > > 
> > > 3) 2.6.26-rc1+weight
> > > ﻿Number of threads: 16
> > > 	read/write requests:                 3219076 (26824.22 per sec.)
> > > 
> > > I'm not sure if more cpu could introduce more contention in this test.
> > 
> > -rc1.  Do you have the fix below applied?
> 
> Oooh - good catch, that seems to be a post -rc1 merge.
> 
> Yes this is required.
With below patch+previous_fix_weight_calc, the result is improved, but is still
about 10% worse than the one of pure 2.6.26-rc1.
Number of threads: 16
    read/write requests:                 6104336 (50867.11 per sec.)


> 
> > commit a992241de614dd2b7c97a9ba64e28c0e563f19bf
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Mon May 5 23:56:17 2008 +0200
> > 
> >     sched: fix normalized sleeper
> >     
> >     Normalized sleeper uses calc_delta*() which requires that the rq load is
> >     already updated, so move account_entity_enqueue() before place_entity()
> >     
> >     Tested-by: Frans Pop <elendil@planet.nl>
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 89fa32b..1295ddc 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -682,6 +682,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
> >  	 * Update run-time statistics of the 'current'.
> >  	 */
> >  	update_curr(cfs_rq);
> > +	account_entity_enqueue(cfs_rq, se);
> >  
> >  	if (wakeup) {
> >  		place_entity(cfs_rq, se, 0);
> > @@ -692,7 +693,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
> >  	check_spread(cfs_rq, se);
> >  	if (se != cfs_rq->curr)
> >  		__enqueue_entity(cfs_rq, se);
> > -	account_entity_enqueue(cfs_rq, se);
> >  }
> >  
> >  static void update_avg(u64 *avg, u64 sample)
> > 
> > 
> 

