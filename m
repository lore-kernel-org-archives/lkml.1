Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873Ab0AZJTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0AZJTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752Ab0AZJTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:19:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:61069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0AZJTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:19:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,345,1262592000"; 
   d="scan'208";a="767361763"
Subject: Re: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264419342.5888.42.camel@marge.simson.net>
References: <1264413826.3642.88.camel@minggr.sh.intel.com>
	 <1264419342.5888.42.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 26 Jan 2010 17:03:01 +0800
Message-Id: <1264496581.3642.114.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 19:35 +0800, Mike Galbraith wrote:
> On Mon, 2010-01-25 at 18:03 +0800, Lin Ming wrote:
> 
> > With above commit, the idle balance was rate limited, so CPU 15(server,
> > waiting data from client) is idle at most time.
> > 
> > CPU0(client) executes as below,
> > 
> > try_to_wake_up
> >    check_preempt_curr_idle
> >       resched_task
> >          smp_send_reschedule
> > 
> > This causes a lot of rescheduling IPI.
> > 
> > This commit can't be reverted due to conflict, so I just add below code
> > to disable "Rate-limit newidle" and the performance was recovered.
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 18cceee..588fdef 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4421,9 +4421,6 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
> >  
> >  	this_rq->idle_stamp = this_rq->clock;
> >  
> > -	if (this_rq->avg_idle < sysctl_sched_migration_cost)
> > -		return;
> > -
> >  	for_each_domain(this_cpu, sd) {
> >  		unsigned long interval;
> >  
> 
> Heh, so you should see the same thing with newidle disabled, as it was
> in .31 and many kernels prior.  Do you?

Weird.
2.6.31 does not have so many reschedule IPI.

This Nehalem machine has 3 domain levels,
$ grep . cpu0/domain*/name
cpu0/domain0/name:SIBLING
cpu0/domain1/name:MC
cpu0/domain2/name:NODE

For 2.6.31, SD_BALANCE_NEWIDLE is only set on SIBLING level.
For 2.6.32-rc1, SD_BALANCE_NEWIDLE is set on all 3 levels.

I can see many reschedule IPI in 2.6.32-rc1 if SD_BALANCE_NEWIDLE is
cleared for all 3 levels.
But for 2.6.31, I didn't see so many IPI even SD_BALANCE_NEWIDLE is
cleared on SIBLING level.

So it seems something happens between 2.6.31 and 2.6.32-rc1.
I'll bisect ...

Lin Ming

