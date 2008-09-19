Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYISItk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYISItk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbYISIt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:49:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYISItX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:49:23 -0400
Date: Fri, 19 Sep 2008 10:48:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Dean Nelson <dcn@sgi.com>, Alan Mayer <ajm@sgi.com>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080919084856.GF17592@elte.hu>
References: <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu> <20080916204654.GA3532@sgi.com> <48D1575E.1050306@zytor.com> <20080917202102.GA166524@sgi.com> <m1zlm6zafo.fsf@frodo.ebiederm.org> <20080918191052.GA22864@sgi.com> <m1zlm5rnb2.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlm5rnb2.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Jack Steiner <steiner@sgi.com> writes:
> 
> > On Wed, Sep 17, 2008 at 03:15:07PM -0700, Eric W. Biederman wrote:
> >> Jack Steiner <steiner@sgi.com> writes:
> >> 
> >> > On Wed, Sep 17, 2008 at 12:15:42PM -0700, H. Peter Anvin wrote:
> >> >> Dean Nelson wrote:
> >> >> >
> >> >> >    sgi-gru driver
> >> >> >
> >> >> >The GRU is not an actual external device that is connected to an IOAPIC.
> >> >> >The gru is a hardware mechanism that is embedded in the node controller
> >> >> >(UV hub) that directly connects to the cpu socket. Any cpu (with 
> >> >> >permission)
> >> >> >can do direct loads and stores to the gru. Some of these stores will
> > result
> >> >> >in an interrupt being sent back to the cpu that did the store.
> >> >> >
> >> >> >The interrupt vector used for this interrupt is not in an IOAPIC. Instead
> >> >> >it must be loaded into the GRU at boot or driver initialization time.
> >> >> >
> >> >> 
> >> >> Could you clarify there: is this one vector number per CPU, or are you 
> >> >> issuing a specific vector number and just varying the CPU number?
> >> >
> >> > It is one vector for each cpu.
> >> >
> >> > It is more efficient for software if the vector # is the same for all cpus
> >> Why?  Especially in terms of irq counting that would seem to lead to cache
> >> line conflicts.
> >
> > Functionally, it does not matter. However, if the IRQ is not a per-cpu IRQ, a
> > very large number of IRQs (and vectors) may be needed. The GRU requires 32
> > interrupt
> > lines on each blade. A large system can currently support up to 512 blades.
> 
> Every vendor of high end hardware is saying they intend to provide
> 1 or 2 queues per cpu and 1 irq per queue.  So the GRU is not special in
> that regard.  Also a very large number of IRQs is not a problem as
> soon as we start dynamically allocating them, which is currently
> in progress.
> 
> Once we start dynamically allocating irq_desc structures we can put
> them in node-local memory and guarantee there is no data shared between
> cpus.
> 
> > After looking thru the MSI code, we are starting to believe that we should
> > separate
> > the GRU requirements from the XPC requirements. It looks like XPC can easily use
> > the MSI infrastructure.  XPC needs a small number of IRQs, and interrupts are
> > typically
> > targeted to a single cpu. They can also be retargeted using the standard
> > methods.
> 
> Alright. 
> 
> I would be completely happy if there were interrupts who's affinity we can
> not change, and are always targeted at a single cpu.
> 
> > The GRU, OTOH, is more like a timer interrupt or like a co-processor interrupt.
> > GRU interrupts can occur on any cpu using the GRU. When interrupts do occur, all
> > that
> > needs to happen is to call an interrupt handler. I'm thinking of something like
> > the following:
> >
> > 	- permanently reserve 2 system vectors in include/asm-x86/irq_vectors.h
> > 	- in uv_system_init(), call alloc_intr_gate() to route the
> > 	  interrupts to a function in the file containing uv_system_init().
> > 	- initialize the GRU chipset with the vector, etc, ...
> > 	- if an interrupt occurs and the GRU driver is NOT loaded, print
> > 	  an error message (rate limited or one time)
> >
> > 	- provide a special UV hook for the GRU driver to register/deregister a
> > 	  special callback function for GRU interrupts
> 
> That would work.  So far the GRU doesn't sound that special.
> 
> For a lot of this I would much rather solve the general case on this 
> giving us a solution that works for all high end interrupts rather 
> than one specific solution just for the GRU.  Especially since it 
> looks like we have most of the infrastructure already present to solve 
> the general case and we have to develop and review the specific case 
> from scratch.

ok, great.

Dean, just to make sure the useful bits are not lost now that the 
direction has been changed: could you please repost the patchset but 
without the driver API bits? It's still all a nice and useful 
generalization and cleanup of the x86 vector allocation code, and we can 
check it in -tip how well it works in practice.

	Ingo
