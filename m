Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZJZH4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZJZH4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZJZH4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:56:01 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47385 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbZJZHz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:55:59 -0400
Date: Mon, 26 Oct 2009 13:25:50 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v9 PATCH 4/9]: x86: refactor x86 idle power management code
	and remove all instances of pm_idle.
Message-ID: <20091026075550.GB17689@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091016093850.GB27350@linux.vnet.ibm.com> <20091016094308.GF27350@linux.vnet.ibm.com> <20091023160711.GB1431@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091023160711.GB1431@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [2009-10-23 18:07:11]:

> On Fri 2009-10-16 15:13:08, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-16 15:08:50]:
> > 
> > This patch cleans up x86 of all instances of pm_idle.
> > 
> > pm_idle which was earlier called from cpu_idle() idle loop
> > is replaced by cpuidle_idle_call.
> > 
> > x86 also registers to cpuidle when the idle routine is selected,
> > by populating the cpuidle_device data structure for each cpu.
> > 
> > This is replicated for apm module and for xen, which also used pm_idle.
> > 
> > 
> > Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
> > ---
> >  arch/x86/kernel/apm_32.c      |   55 ++++++++++++++++++++++++-
> >  arch/x86/kernel/process.c     |   90 ++++++++++++++++++++++++++++++++----------
> >  arch/x86/kernel/process_32.c  |    3 -
> >  arch/x86/kernel/process_64.c  |    3 -
> >  arch/x86/xen/setup.c          |   40 ++++++++++++++++++
> >  drivers/acpi/processor_core.c |    9 ++--
> >  drivers/cpuidle/cpuidle.c     |   16 +++++--
> >  7 files changed, 182 insertions(+), 34 deletions(-)
> ...
> > +static int local_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
> > +{
> > +	ktime_t t1, t2;
> > +	s64 diff;
> > +	int ret;
> > +
> > +	t1 = ktime_get();
> > +	local_idle();
> > +	t2 = ktime_get();
> > +
> > +	diff = ktime_to_us(ktime_sub(t2, t1));
> > +	if (diff > INT_MAX)
> > +		diff = INT_MAX;
> > +	ret = (int) diff;
> > +
> > +	return ret;
> > +}
> 
> So we get this routine essentially 3 times. Is there no way to share
> the code?
> 

We can move this code to a common place, but that would mean exporting
the idle function pointer to be called from within this routine, which
is exactly what we wanted to avoid.

Any suggestions are welcome.

arun

> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
