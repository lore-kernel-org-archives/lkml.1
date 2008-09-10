Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYIJNoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYIJNoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYIJNoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:44:21 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38595 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYIJNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:44:20 -0400
Date: Wed, 10 Sep 2008 19:15:44 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
Message-ID: <20080910134544.GA17984@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com> <1220880346.12278.17.camel@twins.programming.kicks-ass.net> <20080908134843.GA4053@dirshya.in.ibm.com> <20080908135834.GH26079@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080908135834.GH26079@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2008-09-08 15:58:34]:

> > 1. Detailed documentation
> 
> Messy code cannot be really made good with documentation. It's
> not that your patches are that messy, it's more that it makes
> something already overcomplicated even worse.
> 
> > 2. Cleanup the group_min and group_leader stuff in
> >    find_busiest_group()
> 
> I think one issue is that there are general too many special cases
> that completely change the algorithm especially for power saving.
> Perhaps it would make sense to refactor the code a bit and then
> use different high level code paths for those?  I assume that
> would make it all simpler and easier to understand.

Hi Andi,

I will try to refactor the code and see if it can look cleaner.  Power
saving balance is actually just a corner case in general load_balance.
We will have to do default load_balance for performance each time we
enter this section of the scheduler, except when certain complex
conditions are met and we see an opportunity to save power. When that
window of opportunity to save power exist, the code will take
a different path and do things that will normally not be done by the
default load balancer logic.

I think we can split the statistics (load) computation part and the
decision part to separate functions and call the power save balance
conditions first and if there is no opportunity to save power, then
recommend the default load balancing decision.

> 
> The other alternative would be to dynamically change the domains
> so that a generic graph walker without knowledge of power savings
> could DTRT in all cases. But I assume that would be much harder.

This option may not work because we will have to change the decision
only when a power saving opportunity exist.  Hence more often the
power save balance code should just fall through into the default
balancer.  Splitting them this way may add duplicate code in both the
paths.

--Vaidy
