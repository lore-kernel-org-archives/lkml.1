Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZEBHBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZEBHBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 03:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZEBHBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 03:01:09 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:48038 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751488AbZEBHBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 03:01:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFAJqL+0lMQW1W/2dsb2JhbACBUMtRg30F
Date: Sat, 2 May 2009 03:01:06 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090502070105.GA2772@Krystal>
References: <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com> <20090501202400.GA20280@Krystal> <alpine.DEB.1.10.0905011623450.16255@qirst.com> <20090501204355.GB20280@Krystal> <alpine.DEB.1.10.0905011640480.16255@qirst.com> <20090501211911.GA22134@Krystal> <alpine.DEB.1.10.0905012257510.32364@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905012257510.32364@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:48:18 up 63 days,  3:14,  1 user,  load average: 0.93, 0.65,
	0.51
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 1 May 2009, Mathieu Desnoyers wrote:
> 
> > Then, if I understand you correctly, you propose :
> >
> > void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
> > {
> >         ... assuming p references percpu "u8" counters ...
> >         u8 p_new;
> >
> >         p_new = percpu_add_return(p, 1);
> >
> >         if (unlikely(!(p_new & pcp->stat_threshold_mask)))
> >                 zone_page_state_add(pcp->stat_threshold, zone, item);
> > }
> >
> > void inc_zone_state(struct zone *zone, enum zone_stat_item item)
> > {
> >         ... assuming p references percpu "u8" counters ...
> >         u8 p_new;
> >
> >         p_new = percpu_add_return_irqsafe(p, 1);
> >
> >         if (unlikely(!(p_new & pcp->stat_threshold_mask)))
> >                 zone_page_state_add(pcp->stat_threshold, zone, item);
> > }
> >
> > (therefore opting for code duplication)
> >
> > Am I correct ?
> 
> Well __inc_zone_state is fine by itself. inc_zone_state will currently
> disable irqs. But we can do it your way and duplicate the code.
> 

OK, I think I see the source of disagreement here. Leaving
local_irq_save in place in inc_zone_state as you propose will degrade
performance significantly. x86 is not the only architecture not that
fast at disabling interrupts.

Let met get my hands on the numbers I've prepared for my upcoming paper
about tracer locking... here they are. These are in cycles.

Architecture           Speedup             CAS        Interrupts
                (cli+sti) / local CAS  local sync     sti   cli

AMD Athlon(tm)64 X2         4.57       7     17       17    15
Intel Core2                 6.33       6     30       20    18
Intel Xeon E5405            5.25       8     20       20    22
PowerPC G5                  4.00       1      2        3     1
PowerPC POWER6 4.2 GHz      1.77       9     17       14     2
Itanium 2 (single and dual-core, 1.6GHz)
                            1.33       3      3        2     2
UltraSPARC-IIIi (1.2GHz)(a) 0.64     0.394 0.394    0.094  0.159
        (a)  (in system bus clock cycles)

I've also got numbers for atomic add return.. it's usually a bit faster
than local CAS, except on architectures where atomic add return must be
emulated by a CAS (it's then very slightly slower). But in any case,
disabling/enabling interrupts is _WAY_ slower than local CAS or local
add return.

> > void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
> > {
> >         ... assuming p references percpu "u8" counters ...
> >         u8 p_new;
> >
> >         p_new = __percpu_add_return_irqsafe(p, 1);
> >
> >         if (unlikely(!(p_new & pcp->stat_threshold_mask)))
> >                 zone_page_state_add(pcp->stat_threshold, zone, item);
> > }
> >
> > void inc_zone_state(struct zone *zone, enum zone_stat_item item)
> > {
> > 	unsigned long flags;
> >
> > 	percpu_local_irqsave(flags);
> > 	__inc_zone_state(zone, item);
> > 	percpu_local_irqrestore(flags);
> > }
> >
> > Which is more compact and does not duplicate code.
> 
> This is almost like the current code. But lets avoid percpu_local_irqs
> etc if we can.

If we want to get good performance out of those percpu ops, we have to
leave interrupts enabled. It's a factor ~5 slowdown otherwise on x86. So
the choice really comes down to : either we duplicate code, or we create
those percpu_local_irqsave-like primitives. BTW if the name is bad, we
may have to just find something better.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
