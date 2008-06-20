Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYFTKpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYFTKpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYFTKp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:45:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYFTKp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:45:28 -0400
Date: Fri, 20 Jun 2008 12:44:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080620104452.GA7439@elte.hu>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806180053.40044.rjw@sisk.pl> <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl> <200806190011.38548.rjw@sisk.pl> <Pine.LNX.4.55.0806182345380.7802@cliff.in.clinika.pl> <20080619093541.GC15228@elte.hu> <Pine.LNX.4.55.0806191619560.12929@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806191619560.12929@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  As expressed before, unfortunately a lot of diagnostic APIC messages 
> have been disabled in the 64-bit variation.  The result is I was 
> unable to get good results from my Internet search for bootstrap logs 
> from other systems using this southbridge.  Fortunately at least ACPI 
> messages are present and what I noticed is some of the systems do not 
> provide an IRQ0 override and still work correctly. [...]

okay, so when those files are unified, the diagnostics should remain and 
be prominent. (or even be put back into the 64-bit version right now.)

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
> automatically and if an edge is lost because the APIC input targeted 
> is masked or not configured yet, another one will follow shortly by 
> itself.  It used to be the case when this code was implemented as we 
> never used any of the single-shot modes of the 8254 back then.
> 
>  Is it now possible at the time check_timer() is called the 8254 has 
> been put in one of the single-shot modes?  If so, then additional code 
> has to be put in place either to switch the timer into the periodic 
> mode for the duration of check_timer() or to rearm the timer if in a 
> single-shot mode each time timer_irq_works() is called.

that's a question for Thomas i guess, he wrote the PIT single-shot code.

	Ingo
