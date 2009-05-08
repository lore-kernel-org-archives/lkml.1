Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZEHQs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZEHQs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZEHQsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:48:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37859 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbZEHQsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:48:46 -0400
Date: Fri, 8 May 2009 09:48:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090508164845.GI6788@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A03E644.5000103@redhat.com> <20090508104228.GD3011@amt.cnet> <4A0428FC.8080304@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0428FC.8080304@novell.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 08:43:40AM -0400, Gregory Haskins wrote:
> Marcelo Tosatti wrote:
> > On Fri, May 08, 2009 at 10:59:00AM +0300, Avi Kivity wrote:
> >   
> >> Marcelo Tosatti wrote:
> >>     
> >>> I think comparison is not entirely fair. You're using
> >>> KVM_HC_VAPIC_POLL_IRQ ("null" hypercall) and the compiler optimizes that
> >>> (on Intel) to only one register read:
> >>>
> >>>         nr = kvm_register_read(vcpu, VCPU_REGS_RAX);
> >>>
> >>> Whereas in a real hypercall for (say) PIO you would need the address,
> >>> size, direction and data.
> >>>   
> >>>       
> >> Well, that's probably one of the reasons pio is slower, as the cpu has  
> >> to set these up, and the kernel has to read them.
> >>
> >>     
> >>> Also for PIO/MMIO you're adding this unoptimized lookup to the  
> >>> measurement:
> >>>
> >>>         pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
> >>>         if (pio_dev) {
> >>>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
> >>>                 complete_pio(vcpu);                 return 1;
> >>>         }
> >>>   
> >>>       
> >> Since there are only one or two elements in the list, I don't see how it  
> >> could be optimized.
> >>     
> >
> > speaker_ioport, pit_ioport, pic_ioport and plus nulldev ioport. nulldev 
> > is probably the last in the io_bus list.
> >
> > Not sure if this one matters very much. Point is you should measure the
> > exit time only, not the pio path vs hypercall path in kvm. 
> >   
> 
> The problem is the exit time in of itself isnt all that interesting to
> me.  What I am interested in measuring is how long it takes KVM to
> process the request and realize that I want to execute function "X". 
> Ultimately that is what matters in terms of execution latency and is
> thus the more interesting data.  I think the exit time is possibly an
> interesting 5th data point, but its more of a side-bar IMO.   In any
> case, I suspect that both exits will be approximately the same at the
> VT/SVM level.
> 
> OTOH: If there is a patch out there to improve KVMs code (say
> specifically the PIO handling logic), that is fair-game here and we
> should benchmark it.  For instance, if you have ideas on ways to improve
> the find_pio_dev performance, etc....   One item may be to replace the
> kvm->lock on the bus scan with an RCU or something.... (though PIOs are
> very frequent and the constant re-entry to an an RCU read-side CS may
> effectively cause a perpetual grace-period and may be too prohibitive). 
> CC'ing pmck.

Hello, Greg!

Not a problem.  ;-)

A grace period only needs to wait on RCU read-side critical sections that
started before the grace period started.  As soon as those pre-existing
RCU read-side critical get done, the grace period can end, regardless
of how many RCU read-side critical sections might have started after
the grace period started.

If you find a situation where huge numbers of RCU read-side critical
sections do indefinitely delay a grace period, then that is a bug in
RCU that I need to fix.

Of course, if you have a single RCU read-side critical section that
runs for a very long time, that -will- delay a grace period.  As long
as you don't do it too often, this is not a problem, though if running
a single RCU read-side critical section for more than a few milliseconds
is probably not a good thing.  Not as bad as holding a heavily contended
spinlock for a few milliseconds, but still not a good thing.

							Thanx, Paul

> FWIW: the PIOoHCs were about 140ns slower than pure HC, so some of that
> 140 can possibly be recouped.  I currently suspect the lock acquisition
> in the iobus-scan is the bulk of that time, but that is admittedly a
> guess.  The remaining 200-250ns is elsewhere in the PIO decode.
> 
> -Greg
> 
> 
> 
> 


