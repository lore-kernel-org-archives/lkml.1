Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbYFSST2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbYFSST2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYFSSTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:19:19 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64270 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbYFSSTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:19:17 -0400
Date: Thu, 19 Jun 2008 19:17:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080619093541.GC15228@elte.hu>
Message-ID: <Pine.LNX.4.55.0806191619560.12929@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806180053.40044.rjw@sisk.pl>
 <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl> <200806190011.38548.rjw@sisk.pl>
 <Pine.LNX.4.55.0806182345380.7802@cliff.in.clinika.pl> <20080619093541.GC15228@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008, Ingo Molnar wrote:

> * Maciej W. Rozycki <macro@linux-mips.org> wrote:
> 
> > --- a/arch/x86/kernel/io_apic_64.c	2008-06-18 22:53:34.000000000 +0000
> > +++ b/arch/x86/kernel/io_apic_64.c	2008-06-18 22:58:45.000000000 +0000
> > @@ -1714,6 +1714,7 @@ static inline void __init check_timer(vo
> >  		/* replace_pin_at_irq(0, apic1, pin1, apic2, pin2); */
> >  		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
> >  		unmask_IO_APIC_irq(0);
> > +		clear_IO_APIC_pin(apic2, pin2);
> >  		enable_8259A_irq(0);
> >  		if (timer_irq_works()) {
> >  			apic_printk(APIC_VERBOSE," works.\n");
> 
> would it be fine with you if we applied this to tip/x86, as it unbreaks 
> Rafael's box?

 It makes no sense to push it anyweher -- it is a diagnostic check only
which makes most of the surrounding code useless.  It masks the APIC input
selected for use so that it can be seen whether the 8259A delivers its
interrupt regardless.  Obviously in this case it does not, so I must
conclude the 8259A is really wired to this I/O APIC input.

 As expressed before, unfortunately a lot of diagnostic APIC messages have
been disabled in the 64-bit variation.  The result is I was unable to get
good results from my Internet search for bootstrap logs from other systems
using this southbridge.  Fortunately at least ACPI messages are present
and what I noticed is some of the systems do not provide an IRQ0 override
and still work correctly.  So it is quite possible the chip actually wires
the timer interrupt to INTIN0 and the virtual wire cascade to INTIN2 (that
would make the ACPI override provided by this machine incorrect).  That
would be unusual, but not unreasonable, especially for someone like ATI
doing their first chipset with no legacy burden carried over.  I'll post a
patch shortly, that will make it possible to determine that.

 Overall, it would really help to see the a piece of documentation for the
SB400.  Now that ATI has been taken over by AMD it might be a bit easier.  
Both companies have a reasonably good record of providing technical
documentation, but AMD's track seems a little bit better.  At least to me.
Perhaps someone who cooperates with AMD officially could approach them?

> does PIT programming matter? One detail which might matter and which 
> touches IRQ0 generation is the clockevent driver on nohz/highres. See 
> arch/x86/kernel/i8253.c:init_pit_timer():
> 
>         case CLOCK_EVT_MODE_SHUTDOWN:
>         case CLOCK_EVT_MODE_UNUSED:
>                 if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
>                     evt->mode == CLOCK_EVT_MODE_ONESHOT) {
>                         outb_pit(0x30, PIT_MODE);
>                         outb_pit(0, PIT_CH0);
>                         outb_pit(0, PIT_CH0);
>                 }
>                 pit_disable_clocksource();
>                 break;
> 
>         case CLOCK_EVT_MODE_ONESHOT:
>                 /* One shot setup */
>                 pit_disable_clocksource();
>                 outb_pit(0x38, PIT_MODE);
>                 break;

 It does, though not necessarily in this case.  In principle all this
8254-through-APIC timer validation code assumes the source retriggers
automatically and if an edge is lost because the APIC input targeted is
masked or not configured yet, another one will follow shortly by itself.  
It used to be the case when this code was implemented as we never used any
of the single-shot modes of the 8254 back then.

 Is it now possible at the time check_timer() is called the 8254 has been
put in one of the single-shot modes?  If so, then additional code has to
be put in place either to switch the timer into the periodic mode for the
duration of check_timer() or to rearm the timer if in a single-shot mode
each time timer_irq_works() is called.

  Maciej
