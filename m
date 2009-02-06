Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbZBFSK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbZBFSK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760641AbZBFSHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:07:44 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:45046 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018AbZBFSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:07:43 -0500
Date: Fri, 6 Feb 2009 11:07:42 -0700
From: Alex Chiang <achiang@hp.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64: prevent irq migration race in __cpu_disable path
Message-ID: <20090206180742.GC2445@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	tony.luck@intel.com, linux-ia64@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090206162213.GD8208@ldl.fc.hp.com> <20090206170055.GI10918@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206170055.GI10918@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[removing stable@kernel.org for now while we figure this out]

* Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Fri, Feb 06, 2009 at 09:22:13AM -0700, Alex Chiang wrote:
> > ---
> > In my opinion, this is .29 material.
> > 
> > Sorry for the huge changelog:patch ratio, but this area is tricky
> > enough that more explanation is better than less, I think.
> > 
> > Also, I'm still a little troubled by Paul's original patch. What
> > happens if we're trying to offline the CPEI target? The code in
> > migrate_platform_irqs() uses cpu_online_map to select the new
> > CPEI target, and it seems like we can end up in the same
> > situation as the problem I'm trying to fix now.
> > 
> > Paul?
> > 
> > My patch has held up for over 24 hours of stress testing, where
> > we put the system under a heavy load and then randomly
> > offline/online CPUs every 2 seconds. Without this patch, the
> > machine would crash reliably within 15 minutes.
> 
> I don't claim much expertise on IA64 low-level architectural details,

I'm starting to get a bit out of my depth here too... :-/

> so am reduced to asking the usual question...  Does this patch guarantee
> that a given CPU won't be executing irq handlers while marked offline?
> If there is no such guarantee, things can break.  (See below.)

My patch makes no guarantee. What it does do is prevent a NULL
deref while we are, in fact, executing an irq handler while
marked offline.
 
> In any case, apologies for failing to correctly fix the original
> problem!!!

I'm curious, reading through your old change log:

    Make ia64 refrain from clearing a given to-be-offlined CPU's
    bit in the cpu_online_mask until it has processed pending
    irqs.  This change prevents other CPUs from being blindsided
    by an apparently offline CPU nevertheless changing globally
    visible state. 

Was your patch fixing a theoretical problem or a real bug? What
globally visible state were you referencing there?

> > ---
> > 
> > diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
> > index 1146399..2a17d1c 100644
> > --- a/arch/ia64/kernel/smpboot.c
> > +++ b/arch/ia64/kernel/smpboot.c
> > @@ -742,8 +742,8 @@ int __cpu_disable(void)
> >  	}
> > 
> >  	remove_siblinginfo(cpu);
> > -	fixup_irqs();
> >  	cpu_clear(cpu, cpu_online_map);
> > +	fixup_irqs();
> 
> So you argument is that because we are running in the context of
> stop_machine(), even though fixup_irqs() does in fact cause irq handlers
> to run on the current CPU which is marked offline, the fact that there
> is no one running to notice this misbehavior makes it OK?  (Which
> perhaps it is, just asking the question.)

I wouldn't say that I have a solid argument, per se, just fixing
symptoms. ;)

My reading of the cpu_down() path makes it seem like we need to
process pending interrupts on the current CPU, and the original
author certainly thought it was ok to call an irq handler on the
current CPU. We don't disable local irqs until the very last step
of fixup_irqs().

So the actual design of this path assumed it was ok to call an
irq handler on a marked-offline CPU.

Can you educate me on the danger of doing such a thing? That
might help in how I interpret the code.

Thanks.

/ac

