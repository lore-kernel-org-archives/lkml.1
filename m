Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXDICzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXDICzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 22:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXDICzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 22:55:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49242 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbXDICzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 22:55:37 -0400
Date: Mon, 9 Apr 2007 08:25:33 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: Avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
Message-ID: <20070409025533.GB30109@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070406214150.GA3545@linux-os.sc.intel.com> <20070406232500.3fd84c77.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406232500.3fd84c77.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 11:25:00PM -0700, Andrew Morton wrote:
> On Fri, 6 Apr 2007 14:41:50 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> > Subject: Avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
> > 
> > Avoid checking for cpu gone in mm hot path when
> > CONFIG_HOTPLUG_CPU is not defined.
> > 
> > Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > 
> > ---
> >  arch/i386/kernel/smp.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: work/arch/i386/kernel/smp.c
> > ===================================================================
> > --- work.orig/arch/i386/kernel/smp.c
> > +++ work/arch/i386/kernel/smp.c
> > @@ -365,10 +365,12 @@ static void flush_tlb_others(cpumask_t c
> >  	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
> >  	BUG_ON(!mm);
> >  
> > +#ifdef CONFIG_HOTPLUG_CPU
> >  	/* If a CPU which we ran on has gone down, OK. */
> >  	cpus_and(cpumask, cpumask, cpu_online_map);
> > -	if (cpus_empty(cpumask))
> > +	if (unlikely(cpus_empty(cpumask)))
> >  		return;
> > +#endif
> >  
> >  	/*
> >  	 * i'm not happy about this global shared spinlock in the
> 
> Fair enough.
> 
> The code you're touching in with the original CPU-hotplug-for-i386 patches.
> 
> x86_64 doesn't do it.  It handles tlb flushing differently anyway.  But I
> suspect that x86_64 is just buggy, unless all callers of flush_tlb_others()
> have taken care to disable preemption prior to their calculation of the
> passed-in cpumask.
> 
> Shudder.  Gautham, this is code which we can cheerfully delete when we get
> the freezer stuff done.  Fortunately, Anil's patch will make it nice and
> easy to find again.

Ok, I will make a note of this one.

If the IO-test results are good, I hope to post the patchset sometime
this week.


Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
