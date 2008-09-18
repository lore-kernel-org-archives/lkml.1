Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYIRTLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYIRTLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYIRTLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:11:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50390 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753963AbYIRTLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:11:10 -0400
Date: Thu, 18 Sep 2008 14:10:52 -0500
From: Jack Steiner <steiner@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dean Nelson <dcn@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Mayer <ajm@sgi.com>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080918191052.GA22864@sgi.com>
References: <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu> <20080916204654.GA3532@sgi.com> <48D1575E.1050306@zytor.com> <20080917202102.GA166524@sgi.com> <m1zlm6zafo.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlm6zafo.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 03:15:07PM -0700, Eric W. Biederman wrote:
> Jack Steiner <steiner@sgi.com> writes:
> 
> > On Wed, Sep 17, 2008 at 12:15:42PM -0700, H. Peter Anvin wrote:
> >> Dean Nelson wrote:
> >> >
> >> >    sgi-gru driver
> >> >
> >> >The GRU is not an actual external device that is connected to an IOAPIC.
> >> >The gru is a hardware mechanism that is embedded in the node controller
> >> >(UV hub) that directly connects to the cpu socket. Any cpu (with 
> >> >permission)
> >> >can do direct loads and stores to the gru. Some of these stores will result
> >> >in an interrupt being sent back to the cpu that did the store.
> >> >
> >> >The interrupt vector used for this interrupt is not in an IOAPIC. Instead
> >> >it must be loaded into the GRU at boot or driver initialization time.
> >> >
> >> 
> >> Could you clarify there: is this one vector number per CPU, or are you 
> >> issuing a specific vector number and just varying the CPU number?
> >
> > It is one vector for each cpu.
> >
> > It is more efficient for software if the vector # is the same for all cpus
> Why?  Especially in terms of irq counting that would seem to lead to cache
> line conflicts.

Functionally, it does not matter. However, if the IRQ is not a per-cpu IRQ, a
very large number of IRQs (and vectors) may be needed. The GRU requires 32 interrupt
lines on each blade. A large system can currently support up to 512 blades.

After looking thru the MSI code, we are starting to believe that we should separate
the GRU requirements from the XPC requirements. It looks like XPC can easily use
the MSI infrastructure.  XPC needs a small number of IRQs, and interrupts are typically
targeted to a single cpu. They can also be retargeted using the standard methods.

The GRU, OTOH, is more like a timer interrupt or like a co-processor interrupt.
GRU interrupts can occur on any cpu using the GRU. When interrupts do occur, all that
needs to happen is to call an interrupt handler. I'm thinking of something like
the following:

	- permanently reserve 2 system vectors in include/asm-x86/irq_vectors.h
	- in uv_system_init(), call alloc_intr_gate() to route the
	  interrupts to a function in the file containing uv_system_init().
	- initialize the GRU chipset with the vector, etc, ...
	- if an interrupt occurs and the GRU driver is NOT loaded, print
	  an error message (rate limited or one time)

	- provide a special UV hook for the GRU driver to register/deregister a
	  special callback function for GRU interrupts


> 
> > but the software/hardware can support a unique vector for each cpu. This
> > assumes, of course, that the driver can determine the irq->vector mapping for
> > each cpu.
> >
> >
> > <probably-more-detail-than-you-want>
> >
> > Physically, the system contains a large number of blades. Each blade has
> > several processor sockets plus a UV hub (node controller).  There are 2 GRUs
> > located in each UV hub.
> >
> > Each GRU supports multiple users simultaneously using the GRU.
> > Each user is assigned a context number (0 .. N-1). If an exception occurs,
> > the GRU uses the context number as an index into an array of [vector-apicid]
> > pairs.
> > The [vector-apicid] identifies the cpu & vector for the interrupt.
> >
> > Although supported by hardware, we do not intend to send interrupts
> > off-blade.
> >
> > The array of [vector-apicid] pairs is located in each GRU and must be
> > initialized at boot time or when the driver is loaded. There is a
> > separate array for each GRU.
> >
> > When the driver receives the interrupt, the vector number (or IRQ number) is
> > used by the driver to determine the GRU that sent the interrupt.
> >
> >
> > The simpliest scheme would be to assign 2 vectors - one for each GRU in the UV
> > hub.
> > Vector #0 would be loaded into each "vector" of the [vector-apicid] array for
> > GRU
> > #0; vector #1 would be loaded into the [vector-apicid] array for GRU #1.
> >
> > The [vector-apicid] arrays on all nodes would be identical as far as vectors are
> > concerned. (Apicids would be different and would target blade-local cpus).
> > Since interrupts are not sent offnode, the driver can use the vector (irq)
> > to uniquely identify the source of the interrupt.
> >
> > However, we have a lot of flexibilty here. Any scheme that provides the right
> > information to the driver is ok. Note that servicing of these interrupts
> > is likely to be time critical. We need this path to be as efficient as possible.
> 
> That sounds like you have a non-standard MSI-X vector.  You certainly have all of
> the same properties.  At which point create_irq() sounds like what you want.
> 
> One irq per cpu, per device.
> 
> It is the trend.  Don't worry all of the high performance drivers are doing it.
> That is the path that will be optimized.
> 
> What you are proposing is some silly side path that will be ignored, and will be
> increasingly less well supported over time as no other hardware does that.  Please
> join the rest of the world.  Weird formats formats for programming irq information
> into the hardware are easier to support than many other weird restrictions.
> 
> What function does the GRU perform that makes it more important and more special
> than other hardware devices that requires it to have a high priority interrupt?
> 
> Eric
