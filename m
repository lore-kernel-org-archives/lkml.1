Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZGFWSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZGFWSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZGFWSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:18:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:37804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbZGFWSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:18:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,358,1243839600"; 
   d="scan'208";a="705478046"
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Witten <mfwitten@gmail.com>, Johannes Stezenbach <js@sig21.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200907062339.18578.rjw@sisk.pl>
References: <cNOy0-5C5-23@gated-at.bofh.it> <200907042329.04926.rjw@sisk.pl>
	 <1246915230.11545.61.camel@localhost.localdomain>
	 <200907062339.18578.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 15:16:11 -0700
Message-Id: <1246918571.11545.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 14:39 -0700, Rafael J. Wysocki wrote:
> On Monday 06 July 2009, Pallipadi, Venkatesh wrote:
> > On Sat, 2009-07-04 at 14:29 -0700, Rafael J. Wysocki wrote:
> > > On Saturday 04 July 2009, Michael Witten wrote:
> > > > On Tue, 16 Jun 2009 23:39:59 +0200, Rafael J. Wysocki wrote
> > > > (http://www.spinics.net/lists/linux-acpi/msg22661.html):
> > > > 
> > > > > In fact, we need to do this entire thing differently.
> > > > > 
> > > > > The basic problem is that cpufreq_suspend() is a sysdev thing, so it will 
> > > > > always be called with iterrupts off and *only* for CPU0.  So, it looks like
> > > > > the majority of things we do there is just unnecessary (at least).
> > > > 
> > > > What's the status? This bug is driving me nuts.
> > > 
> > > Unfortunately, still unresolved.
> > 
> > Looked at this a bit more from acpi cpufreq angle.
> 
> Thanks!
> 
> > But, I feel the patch that Johannes had here
> > http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/00335.html
> > is the right fix as we do the same saving and restoring of flags on SMP
> > when cpu==this_cpu. This change will make code in UP same as that in SMP
> > with 1 CPU active.
> 
> Andrew didn't like this patch IIRC.
> 
> > We can avoid the driver->get call from cpufreq_suspend for the drivers
> > that do not do any freq changes in their suspend methods. But, then we
> > will hit this same problem in cpufreq_resume() path and there we do want
> > to check for adjust_jiffies for all drivers as long as CONSTANT_LOOPS is
> > not set.
> 
> Why do we need to call that driver->get from cpufreq_suspend() in the first
> place?  We know we are on CPU0, there are no any other CPUs active and
> interrupts are disabled, so why do we need to care for any races?
> 

cpufreq core is trying to get the current frequency on the CPU and call
adjust_jiffies(). Both in suspend and resume. Looks like it is needed
only for some systems on suspend path, as the driver suspend routine may
change freq. But, it is probably needed for most of the systems on
resume time as CPU may come up with different freq.
It doesn't care about races. Problem is that ->get method used here is
same as the one used in normal system working state. In system working
state, ->get has to get the frequency from proper CPU using
smp_call_function and int enabled.

I thought Andrew was worried about SMP case. But, we already do this in
SMP case
kernel/smp.c:smp_call_function_single()
        if (cpu == this_cpu) {
                local_irq_save(flags);
                func(info);
                local_irq_restore(flags);
        } else {

That patch changes
kernel/up.c:smp_call_function_single()
        local_irq_disable();
        (func)(info);
        local_irq_enable();
to add save and restore flags.

Thanks,
Venki

