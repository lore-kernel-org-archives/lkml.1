Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYFTNMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYFTNMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYFTNM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:12:27 -0400
Received: from www.tglx.de ([62.245.132.106]:46176 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYFTNMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:12:25 -0400
Date: Fri, 20 Jun 2008 15:11:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <Pine.LNX.4.55.0806191619560.12929@cliff.in.clinika.pl>
Message-ID: <alpine.LFD.1.10.0806201507190.3395@apollo.tec.linutronix.de>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806180053.40044.rjw@sisk.pl> <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl> <200806190011.38548.rjw@sisk.pl> <Pine.LNX.4.55.0806182345380.7802@cliff.in.clinika.pl> <20080619093541.GC15228@elte.hu>
 <Pine.LNX.4.55.0806191619560.12929@cliff.in.clinika.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008, Maciej W. Rozycki wrote:
> On Thu, 19 Jun 2008, Ingo Molnar wrote:
> > * Maciej W. Rozycki <macro@linux-mips.org> wrote:
> > does PIT programming matter? One detail which might matter and which 
> > touches IRQ0 generation is the clockevent driver on nohz/highres. See 
> > arch/x86/kernel/i8253.c:init_pit_timer():
> > 
> >         case CLOCK_EVT_MODE_SHUTDOWN:
> >         case CLOCK_EVT_MODE_UNUSED:
> >                 if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
> >                     evt->mode == CLOCK_EVT_MODE_ONESHOT) {
> >                         outb_pit(0x30, PIT_MODE);
> >                         outb_pit(0, PIT_CH0);
> >                         outb_pit(0, PIT_CH0);
> >                 }
> >                 pit_disable_clocksource();
> >                 break;
> > 
> >         case CLOCK_EVT_MODE_ONESHOT:
> >                 /* One shot setup */
> >                 pit_disable_clocksource();
> >                 outb_pit(0x38, PIT_MODE);
> >                 break;
> 
>  It does, though not necessarily in this case.  In principle all this
> 8254-through-APIC timer validation code assumes the source retriggers
> automatically and if an edge is lost because the APIC input targeted is
> masked or not configured yet, another one will follow shortly by itself.  
> It used to be the case when this code was implemented as we never used any
> of the single-shot modes of the 8254 back then.
> 
>  Is it now possible at the time check_timer() is called the 8254 has been
> put in one of the single-shot modes?  If so, then additional code has to
> be put in place either to switch the timer into the periodic mode for the
> duration of check_timer() or to rearm the timer if in a single-shot mode
> each time timer_irq_works() is called.

At this point the PIT is in periodic mode.

Let me explain how the timer startup works:

PIT is started in periodic mode
... basic CPU bring up
APIC timer initialization (switches PIT off)
...
Highres/Dyntick mode switches local apic timers to one shot mode

When the system has C2/C3 or C1E states, then we restart the PIT in
one shot mode and reprogram it every time when the system goes into
idle to replace the local apic timer, which stops in those states.

Thanks,
	tglx
