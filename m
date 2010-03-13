Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab0CMNnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 08:43:01 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62093 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188Ab0CMNnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 08:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nblrAcuXpduet1t5jWemV+tay/mgSBUwi2MVeGFIaP9mkdPcsrFe5JavDf2b9RwIUt
         JdDkCL8Us4Kmwa5VgggwW3Ew4JRwP6HsobCCp59p+izz5iJe8weUVZZeYcKWUJxLUYUu
         7ldKUHbCOuFMLe/ohf5SFivYrVN+WT8Fzahww=
Date: Sat, 13 Mar 2010 16:42:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,perf: Unmask LVTPC only if we have APIC supported
Message-ID: <20100313134256.GB18623@lenovo>
References: <20100313081116.GA5179@lenovo> <20100313122432.GA10810@elte.hu> <20100313123256.GC5179@lenovo> <20100313124036.GA17769@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313124036.GA17769@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 01:40:36PM +0100, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > On Sat, Mar 13, 2010 at 01:24:32PM +0100, Ingo Molnar wrote:
> > > 
> > > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > > 
> > > > Ingo reported
> > > > |
> > > > | There's a build failure on -tip with the P4 driver, on UP 32-bit, if
> > > > | PERF_EVENTS is enabled but UP_APIC is disabled:
> > > > |
> > > > | arch/x86/built-in.o: In function `p4_pmu_handle_irq':
> > > > | perf_event.c:(.text+0xa756): undefined reference to `apic'
> > > > | perf_event.c:(.text+0xa76e): undefined reference to `apic'
> > > > |
> > > > 
> > > > So we have to unmask LVTPC only if we're configured to have one.
> > > > 
> > > > Reported-by: Ingo Molnar <mingo@elte.hu>
> > > > CC: Lin Ming <ming.m.lin@intel.com>
> > > > CC: Peter Zijlstra <peterz@infradead.org>
> > > > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > > > ---
> > > >  arch/x86/kernel/cpu/perf_event_p4.c |    2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> > > > =====================================================================
> > > > --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> > > > +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> > > > @@ -365,8 +365,10 @@ static int p4_pmu_handle_irq(struct pt_r
> > > >  	}
> > > >  
> > > >  	if (handled) {
> > > > +#ifdef CONFIG_X86_LOCAL_APIC
> > > >  		/* p4 quirk: unmask it again */
> > > >  		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> > > > +#endif
> > > >  		inc_irq_stat(apic_perf_irqs);
> > > 
> > > This ugly #ifdef looks like a workaround though. Why doesnt apic_write() map 
> > > to nothing in that case?
> > > 
> > > 	Ingo
> > > 
> > 
> > It is. I mean -- it maps to nothing if apic is disabled. But the scenario is 
> > that no apic configured at all. Actually I wonder how this code is supposed 
> > to work without apic support.
> > 
> > Pehpaps better to make a p4 quirk helper here, since #ifdef at this point 
> > looks ugly indeed.
> > 
> > Don't apply it then. Will back with other solution.
> 
> apic_write() is really just equivalent to a spin_lock() on UP without 
> UP_IOAPIC set - it should do nothing. So if it does something and fails the 
> build, then that should be fixed - not the P4 PMU code.
> 
> 	Ingo
> 

Looking at code a bit and config deps I think the former proposal with
#ifdef is minimal (in amount of changes) and sufficient. perf_event.c
uses #ifdef CONFIG_X86_LOCAL_APIC for the very same reason.

The former issue with config dependencies is that we may need to compile
perf_event.c without CONFIG_LOCAL_APIC support at all (and this is a case
for which you've posted the config). CONFIG_LOCAL_APIC deps on X86_UP_APIC,
the config has no X86_UP_APIC support and as result -- no CONFIG_LOCAL_APIC and
no apic.o compiled.

So, as expected, no apic_write/read and friends there. We may introduce
apic_write/read weak(s) but this would only mess the code more and would
smell unpleasant I think :) .

All-in-once: unresolved external symbol here, which could be fixed either
by introducing dummy symbol, or conditional compilation. I think the second
is preferred if the issue is just one line code.

Or you mean something different and I took a wrong mind-path?

	-- Cyrill
