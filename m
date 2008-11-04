Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYKDQXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYKDQXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYKDQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:23:12 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50734 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754156AbYKDQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:23:11 -0500
Message-Id: <1225815789.30706.1282936457@webmail.messagingengine.com>
X-Sasl-Enc: hUzN+PwWJJcAOIbftUwd/n6XSD2eE6xrGlEFYfy4gZmj 1225815789
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, "Mike Travis" <travis@sgi.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andi Kleen" <andi@firstfloor.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081104140030.GA16178@elte.hu>
Date: Tue, 04 Nov 2008 17:23:09 +0100
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu>
 <1225805399.25337.1282903253@webmail.messagingengine.com>
 <20081104140030.GA16178@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 15:00:30 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > On Tue, 4 Nov 2008 13:42:42 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> > > 
> > > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > An x86 processor handles an interrupt (from an external source, 
> > > > software generated or due to an exception), depending on the 
> > > > contents if the IDT. Normally the IDT contains mostly interrupt 
> > > > gates. Linux points each interrupt gate to a unique function. Some 
> > > > are specific to some task (handling traps, IPI's, ...), the others 
> > > > are stubs that push the interrupt number to the stack and jump to 
> > > > 'common_interrupt'.
> > > > 
> > > > This patch removes the need for the stubs.
> > > 
> > > hm, the cost would be this new code:
> > > 
> > > > +.p2align
> > > > +ENTRY(maininterrupt)
> > > >  	RING0_INT_FRAME
> > > > -vector=0
> > > > -.rept NR_VECTORS
> > > > -	ALIGN
> > > > - .if vector
> > > > -	CFI_ADJUST_CFA_OFFSET -4
> > > > - .endif
> > > > -1:	pushl $~(vector)
> > > > -	CFI_ADJUST_CFA_OFFSET 4
> > > > +	push %eax
> > > > +	push %eax
> > > > +	mov %cs,%eax
> > > > +	shr $3,%eax
> > > > +	and $0xff,%eax
> > > > +	not %eax
> > > > +	mov %eax,4(%esp)
> > > > +	pop %eax
> > > >  	jmp common_interrupt
> > > 
> > > .. which we were able to avoid before. A couple of segment register 
> > > accesses, shifts, etc to calculate the vector - each of which can be 
> > > quite costly (especially the segment register access - this is a 
> > > relatively rare instruction pattern).
> > 
> > The way it is written now is just so I did not have to change 
> > common_interrupt (to keep changes small). All those accesses so 
> > close together will cost some cycles, but much can be avoided if it 
> > is integrated. If the precise content of the stack can be changed, 
> > this could be as simple as "push %cs". Even that can be delayed, 
> > because the content of the cs register will still be there.
> > 
> > Note that the specialized interrupts (including page fault, etc.) 
> > will not go via this path. As far as I understand now, it is only 
> > the interrupts from external devices that normally go via 
> > common_interrupt. There I think the overhead is really tiny compared 
> > to the rest of the handling of the interrupt.
> 
> no complaints from me about the cleanup/simplification effect - that's 
> really great. To make the reasoning all iron-clad please post timings 
> of "push %cs" costs measured via RDTSC or so - can be done in 
> user-space as well. (you can simulate the entry+exit sequence in 
> user-space as well and prove that the overhead is near zero.) In the 
> end it could all even be faster (perhaps), besides smaller.

I did some timings using the little program below (32-bit only), doing
1024 times the same sequence. TEST1 is just pushing a constant onto
the stack; TEST2 is pushing the cs register; TEST3 is the sequence
from the patch to extract the vector number from the cs register.

Opteron    (cycles): 1024 / 1157 / 3527
Xeon E5345 (cycles): 1092 / 1085 / 6622
Athlon XP  (cycles): 1028 / 1166 / 5192

I'ld say that the cost of the push %cs itself is negligible.

> ( another advantage is that the 6 bytes GDT descriptor is more 
>   compressed and hence uses up less L1/L2 cache footprint than the 
>   larger (~7 byte) trampolines we have at the moment. )

A GDT descriptor has to be read and processed anyhow... It might
just not be in cache. But at least it is aligned. The trampolines
are 7 bytes (irq#<128) or 10 bytes (irq#>127) on i386 and x86_64.
And one is data, and the other is code, which might also cause
different behaviour. It's just a bit too complicated to decide by
just reasoning about it ;).

> plus it's possible to observe the typical cost of irqs from user-space 
> as well: run a task on a single CPU and save away all the RDTSC deltas 
> that are larger than ~10 cycles - these will be the IRQ entry costs. 
> Print out these deltas after 60 seconds of runtime (or something like 
> that), and look at the histogram.

I'll see if I can do that. Maybe in a few days...

Thanks,
    Alexander

> 	Ingo


#include <stdio.h>
#include <stdlib.h>

#define TEST 3

int main(void)
{
        int i, ticks[1024];

        for (i=0; i<(sizeof(ticks)/sizeof(*ticks)); i++) {
                asm volatile (
                "push %%edx\n\t"
                "push %%ecx\n\t"
                "rdtsc\n\t"
                "mov %%eax,%%ecx\n\t"
                ".rept 1024\n\t"
#if TEST==1
                "push $-255\n\t"
#endif
#if TEST==2
                "push %%cs\n\t"
#endif
#if TEST==3
                "push %%eax\n\t"
                "push %%eax\n\t"
                "mov %%cs,%%eax\n\t"
                "shr $3,%%eax\n\t"
                "and $0xff,%%eax\n\t"
                "not %%eax\n\t"
                "mov %%eax,4(%%esp)\n\t"
                "pop %%eax\n\t"
#endif
                ".endr\n\t"
                "rdtsc\n\t"
                ".rept 1024\n\t"
                "pop %%edx\n\t"
                ".endr\n\t"
                "sub %%ecx,%%eax\n\t"
                "pop %%ecx\n\t"
                "pop %%edx"
                : "=a" (ticks[i]) );
        }

        for (i=0; i<(sizeof(ticks)/sizeof(*ticks)); i++) {
                printf("%i\n", ticks[i]);
        }
}
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

