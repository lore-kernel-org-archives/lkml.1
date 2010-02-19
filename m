Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0BSMcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:32:18 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35929 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0BSMcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:32:17 -0500
Date: Fri, 19 Feb 2010 18:02:08 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
Message-ID: <20100219123208.GA16793@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
 <1266057388.557.59599.camel@twins>
 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2010-02-18 18:16:47]:

> On Sat, 2010-02-13 at 02:36 -0800, Peter Zijlstra wrote:
> > On Fri, 2010-02-12 at 17:31 -0800, Suresh Siddha wrote:
> > > 
> > > We have one more problem that Yanmin and Ling Ma reported. On a dual
> > > socket quad-core platforms (for example platforms based on NHM-EP), we
> > > are seeing scenarios where one socket is completely busy (with all the 4
> > > cores running with 4 tasks) and another socket is completely idle.
> > > 
> > > This causes performance issues as those 4 tasks share the memory
> > > controller, last-level cache bandwidth etc. Also we won't be taking
> > > advantage of turbo-mode as much as we like. We will have all these
> > > benefits if we move two of those tasks to the other socket. Now both the
> > > sockets can potentially go to turbo etc and improve performance.
> > > 
> > > In short, your recent change (shown below) broke this behavior. In the
> > > kernel summit you mentioned you made this change with out affecting the
> > > behavior of SMT/MC. And my testing immediately after kernel-summit also
> > > didn't show the problem (perhaps my test didn't hit this specific
> > > change). But apparently we are having performance issues with this patch
> > > (Ling Ma's bisect pointed to this patch). I will look more detailed into
> > > this after the long weekend (to see if we can catch this scenario in
> > > fix_small_imbalance() etc). But wanted to give you a quick heads up.
> > > Thanks.
> > 
> > Right, so the behaviour we want should be provided by SD_PREFER_SIBLING,
> > it provides the capacity==1 thing the cpu_power games used to provide.
> > 
> > Not saying it's not broken, but that's where the we should be looking to
> > fix it.
> 
> Peter, Some portions of code in fix_small_imbalance() and
> calculate_imbalance() are comparing max_load and busiest_load_per_task.
> Some of these comparisons are ok but some of them are broken. Broken
> comparisons are assuming that the cpu_power is SCHED_LOAD_SCALE. Also
> there is one check which still assumes that the world is balanced when
> max_load <= busiest_load_per_task. This is wrong with the recent changes
> (as cpu power no longer reflects the group capacity that is needed to
> implement SCHED_MC/SCHED_SMT).
> 
> The appended patch works for me and fixes the SCHED_MC performance
> behavior. I am sending this patch out for a quick review and I will do
> bit more testing tomorrow and If you don't follow what I am doing in
> this patch and why, then stay tuned for a patch with complete changelog
> that I will send tomorrow. Good night. Thanks.
> ---
> 


Hi,

I tested Suresh's patch with ebizzy on a machine with 2 package, each
with 4 cores, sched_mc_power_saveings set to 0.

I found that, on applying the patch, performance inproves
significantly for running ebizzy with 5 and 7 threads. The rest of the
cases, there is no significant improvement of performance from the baseline
kernel but there is no degradation either.

And the task placement seem to be coming out correct in the
underloaded system, although i feel that we might be ping-ponging a
bit. Will test more when i get time.

arun
