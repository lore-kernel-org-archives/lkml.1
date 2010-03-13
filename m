Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab0CMMk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:40:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828Ab0CMMky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:40:54 -0500
Date: Sat, 13 Mar 2010 13:40:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,perf: Unmask LVTPC only if we have APIC supported
Message-ID: <20100313124036.GA17769@elte.hu>
References: <20100313081116.GA5179@lenovo>
 <20100313122432.GA10810@elte.hu>
 <20100313123256.GC5179@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313123256.GC5179@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Sat, Mar 13, 2010 at 01:24:32PM +0100, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> > > Ingo reported
> > > |
> > > | There's a build failure on -tip with the P4 driver, on UP 32-bit, if
> > > | PERF_EVENTS is enabled but UP_APIC is disabled:
> > > |
> > > | arch/x86/built-in.o: In function `p4_pmu_handle_irq':
> > > | perf_event.c:(.text+0xa756): undefined reference to `apic'
> > > | perf_event.c:(.text+0xa76e): undefined reference to `apic'
> > > |
> > > 
> > > So we have to unmask LVTPC only if we're configured to have one.
> > > 
> > > Reported-by: Ingo Molnar <mingo@elte.hu>
> > > CC: Lin Ming <ming.m.lin@intel.com>
> > > CC: Peter Zijlstra <peterz@infradead.org>
> > > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > > ---
> > >  arch/x86/kernel/cpu/perf_event_p4.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> > > =====================================================================
> > > --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> > > +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> > > @@ -365,8 +365,10 @@ static int p4_pmu_handle_irq(struct pt_r
> > >  	}
> > >  
> > >  	if (handled) {
> > > +#ifdef CONFIG_X86_LOCAL_APIC
> > >  		/* p4 quirk: unmask it again */
> > >  		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> > > +#endif
> > >  		inc_irq_stat(apic_perf_irqs);
> > 
> > This ugly #ifdef looks like a workaround though. Why doesnt apic_write() map 
> > to nothing in that case?
> > 
> > 	Ingo
> > 
> 
> It is. I mean -- it maps to nothing if apic is disabled. But the scenario is 
> that no apic configured at all. Actually I wonder how this code is supposed 
> to work without apic support.
> 
> Pehpaps better to make a p4 quirk helper here, since #ifdef at this point 
> looks ugly indeed.
> 
> Don't apply it then. Will back with other solution.

apic_write() is really just equivalent to a spin_lock() on UP without 
UP_IOAPIC set - it should do nothing. So if it does something and fails the 
build, then that should be fixed - not the P4 PMU code.

	Ingo
