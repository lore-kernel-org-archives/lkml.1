Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYKDOBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYKDOBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYKDOBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:01:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYKDOBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:01:22 -0500
Date: Tue, 4 Nov 2008 15:00:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104140030.GA16178@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu> <1225805399.25337.1282903253@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225805399.25337.1282903253@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> On Tue, 4 Nov 2008 13:42:42 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> > 
> > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > 
> > > Hi all,
> > > 
> > > An x86 processor handles an interrupt (from an external source, 
> > > software generated or due to an exception), depending on the 
> > > contents if the IDT. Normally the IDT contains mostly interrupt 
> > > gates. Linux points each interrupt gate to a unique function. Some 
> > > are specific to some task (handling traps, IPI's, ...), the others 
> > > are stubs that push the interrupt number to the stack and jump to 
> > > 'common_interrupt'.
> > > 
> > > This patch removes the need for the stubs.
> > 
> > hm, the cost would be this new code:
> > 
> > > +.p2align
> > > +ENTRY(maininterrupt)
> > >  	RING0_INT_FRAME
> > > -vector=0
> > > -.rept NR_VECTORS
> > > -	ALIGN
> > > - .if vector
> > > -	CFI_ADJUST_CFA_OFFSET -4
> > > - .endif
> > > -1:	pushl $~(vector)
> > > -	CFI_ADJUST_CFA_OFFSET 4
> > > +	push %eax
> > > +	push %eax
> > > +	mov %cs,%eax
> > > +	shr $3,%eax
> > > +	and $0xff,%eax
> > > +	not %eax
> > > +	mov %eax,4(%esp)
> > > +	pop %eax
> > >  	jmp common_interrupt
> > 
> > .. which we were able to avoid before. A couple of segment register 
> > accesses, shifts, etc to calculate the vector - each of which can be 
> > quite costly (especially the segment register access - this is a 
> > relatively rare instruction pattern).
> 
> The way it is written now is just so I did not have to change 
> common_interrupt (to keep changes small). All those accesses so 
> close together will cost some cycles, but much can be avoided if it 
> is integrated. If the precise content of the stack can be changed, 
> this could be as simple as "push %cs". Even that can be delayed, 
> because the content of the cs register will still be there.
> 
> Note that the specialized interrupts (including page fault, etc.) 
> will not go via this path. As far as I understand now, it is only 
> the interrupts from external devices that normally go via 
> common_interrupt. There I think the overhead is really tiny compared 
> to the rest of the handling of the interrupt.

no complaints from me about the cleanup/simplification effect - that's 
really great. To make the reasoning all iron-clad please post timings 
of "push %cs" costs measured via RDTSC or so - can be done in 
user-space as well. (you can simulate the entry+exit sequence in 
user-space as well and prove that the overhead is near zero.) In the 
end it could all even be faster (perhaps), besides smaller.

( another advantage is that the 6 bytes GDT descriptor is more 
  compressed and hence uses up less L1/L2 cache footprint than the 
  larger (~7 byte) trampolines we have at the moment. )

plus it's possible to observe the typical cost of irqs from user-space 
as well: run a task on a single CPU and save away all the RDTSC deltas 
that are larger than ~10 cycles - these will be the IRQ entry costs. 
Print out these deltas after 60 seconds of runtime (or something like 
that), and look at the histogram.

	Ingo
