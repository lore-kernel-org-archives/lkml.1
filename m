Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFRXnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFRXnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYFRXnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:43:08 -0400
Received: from [213.77.9.205] ([213.77.9.205]:64179 "EHLO serum.com.pl"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752161AbYFRXnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:43:06 -0400
Date: Thu, 19 Jun 2008 00:39:33 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806190011.38548.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806182345380.7802@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806180053.40044.rjw@sisk.pl>
 <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl> <200806190011.38548.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008, Rafael J. Wysocki wrote:

> >  With such a configuration the "x86: I/O APIC: timer through 8259A
> > second-chance" patch should not matter, because the only change it
> > introduces is an attempt to try the same I/O APIC pin again, but with the
> > IRQ0 line of the master 8259A enabled.  That's not a terribly unusual 
> > configuration and nothing should get confused in the system.
> 
> But it _does_ get confused, really.

 Something certainly gets confused, but so far I am not sure which bit 
exactly it is, are you?

> >  Barring the unlikely possibility of the 8259A actually being wired to 
> > INTIN2 of the I/O APIC I can see two possible explanations:
> > 
> > 1. The 8259A interrupt actually escapes to the CPU somehow and is handled
> >    as an ExtINTA interrupt.  This would make the code in check_timer()  
> >    decide it has found a working configuration, while actually it has been
> >    fooled.
[...]
> Here you go:
> 
> [    0.108006] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.108006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.108006] ...trying to set up timer (IRQ0) through the 8259A ... <3>
> [    0.108006] ..... (found apic 0 pin 2) ...<3> works.
> 
> The full dmesg is at: http://www.sisk.pl/kernel/debug/20080618/dmesg-1.log

 Thanks.  In this case I suspect the case #1 quoted above happens, that is
the 8259A manages to deliver its interrupt somehow.  Note at this stage it
is meant to be in the AEOI mode, so it can happily resubmit the interrupt
indefinitely with no additional handling as long as it receives INTA
cycles.

 Can you please try the patch below on top of "x86: I/O APIC: timer
through 8259A second-chance" to see whether my hypothesis is true?  It
modifies the through-8259A setup path so that the APIC input gets masked,
but the 8259A has the timer interrupt still enabled.  Let me know how the
timer interrupt is routed in this case.

 BTW, do we have any piece of technical information about the chipset
used?  The southbridge used is an ATI SB400, which is where I would
normally expect two 8259A and an I/O APIC core to be placed.

  Maciej

--- a/arch/x86/kernel/io_apic_64.c	2008-06-18 22:53:34.000000000 +0000
+++ b/arch/x86/kernel/io_apic_64.c	2008-06-18 22:58:45.000000000 +0000
@@ -1714,6 +1714,7 @@ static inline void __init check_timer(vo
 		/* replace_pin_at_irq(0, apic1, pin1, apic2, pin2); */
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		unmask_IO_APIC_irq(0);
+		clear_IO_APIC_pin(apic2, pin2);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
