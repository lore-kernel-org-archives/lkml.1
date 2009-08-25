Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZHYJex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZHYJex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbZHYJew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:34:52 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59910 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbZHYJev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:34:51 -0400
Date: Tue, 25 Aug 2009 15:04:42 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/15] sched: Check sched_mn_power_savings when setting
	flags for CPU and MN domains
Message-ID: <20090825093442.GB4268@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090820131243.GO29327@alberich.amd.com> <20090820134013.GX29327@alberich.amd.com> <1251125862.7538.270.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251125862.7538.270.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 04:57:42PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-20 at 15:40 +0200, Andreas Herrmann wrote:
> > Use new function sd_balance_for_mn_power() and adapt
> > sd_balance_for_package_power() and sd_power_saving_flags() for correct
> > setting of flags SD_POWERSAVINGS_BALANCE and SD_BALANCE_NEWIDLE in CPU
> > and MN domains.
> > 
> > Furthermore add flag SD_SHARE_PKG_RESOURCES to MN domain.
> > Rational: a multi-node processor most likely shares package resources
> > (on Magny-Cours the package constitues a "voltage domain").
> 
> IIRC SD_SHARE_PKG_RESOURCES plays games with the cpu_pwer of a
> sched_domain, which breaks in all kinds of curious ways, this adds more
> breakage afaict.
> 
> ego?

A domain which has SD_SHARE_PKG_RESOURCES, will always have the
__cpu_power = SD_LOAD_SCALE if the domain hasn't set
SD_POWERSAVINGS_BALANCE flag.

The problem which you are talking about is
when you offline a CPU of such a domain, it will still show the same
cpu_power, which can confuse the scheduler.

Eg:
A Dual socket Dual core machine, in the absense of
SD_POWERSAVINGS_BALANCE the SD_LV_CPU which has SD_SHARE_PKG_RESOURCES
set will have both of it's group->cpu_power set to SD_LOAD_SCALE.
If we offline, say one of the four cores,
the group->cpu_power the corresponding group will will still be SD_LOAD_SCALE.

This might affect the fairness calculations. For eg, if you have 6 tasks
running, the ideal placement should have been 4 on the socket whose CPUs
are online and 2 on which one of the cpus has been offlined. But in this
case, we will have 3 + 3, which is not correct.


> 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/include/asm/topology.h |    3 ++-
> >  include/linux/sched.h           |   14 ++++++++++++--
> >  2 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> > index 6d7d133..4a520b8 100644
> > --- a/arch/x86/include/asm/topology.h
> > +++ b/arch/x86/include/asm/topology.h
> > @@ -198,7 +198,8 @@ static inline void setup_node_to_cpumask_map(void) { }
> >  				| SD_BALANCE_EXEC	\
> >  				| SD_WAKE_AFFINE	\
> >  				| SD_WAKE_BALANCE	\
> > -				| sd_balance_for_package_power()\
> > +				| SD_SHARE_PKG_RESOURCES\
> > +				| sd_balance_for_mn_power()\
> >  				| sd_power_saving_flags(),\
> >  	.last_balance		= jiffies,		\
> >  	.balance_interval	= 1,			\
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 5755643..c53bdd8 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -844,9 +844,18 @@ static inline int sd_balance_for_mc_power(void)
> >  	return 0;
> >  }
> >  
> > +static inline int sd_balance_for_mn_power(void)
> > +{
> > +	if (sched_mc_power_savings || sched_smt_power_savings)
> > +		return SD_POWERSAVINGS_BALANCE;
> > +
> > +	return 0;
> > +}
> > +
> >  static inline int sd_balance_for_package_power(void)
> >  {
> > -	if (sched_mc_power_savings | sched_smt_power_savings)
> > +	if (sched_mn_power_savings || sched_mc_power_savings ||
> > +	    sched_smt_power_savings)
> >  		return SD_POWERSAVINGS_BALANCE;
> >  
> >  	return 0;
> > @@ -860,7 +869,8 @@ static inline int sd_balance_for_package_power(void)
> >  
> >  static inline int sd_power_saving_flags(void)
> >  {
> > -	if (sched_mc_power_savings | sched_smt_power_savings)
> > +	if (sched_mn_power_savings || sched_mc_power_savings ||
> > +	    sched_smt_power_savings)
> >  		return SD_BALANCE_NEWIDLE;
> >  
> >  	return 0;

-- 
Thanks and Regards
gautham
