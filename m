Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbYESO03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbYESO03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbYESO0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:26:19 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61556 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756403AbYESO0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:26:18 -0400
Date: Mon, 19 May 2008 15:25:47 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I/O APIC: Timer through 8259A revamp
In-Reply-To: <87hccubgni.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.55.0805191459220.19879@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl>
 <87hccubgni.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Andi Kleen wrote:

> I tried to clean up this code in the past too, but one experience I got
> was that even a lot of relatively modern systems (<5 years old) fall into the fallback
> paths unfortunately and it's quite difficult to find out why.

 The new burst of breakage came with the invention of ACPI and its tables 
for interrupt routing for the APIC.

 Old MP tables coming from the MP spec used to get the timer interrupt
setup right almost always if not in all the cases.  The code we had got up
to that point was meant to handle hardware variations the best we could.  
The most common problem was some integrated chipset components predated
the existence of the APIC and had the output of the timer #0 of their
embedded 8254 core routed directly to the IRQ0 input of their embedded
8259A component only.  The I/O APIC was external and there was no way to
route IRQ0 there directly.

 With the ACPI tables, hardware is modern enough the timer interrupt 
should be directly available, but is usually wired in the way recommended 
by the MP spec.  That is the output of the master 8259A goes to INT0 of 
the I/O APIC (or is only connected to local APICs) and the timer is routed 
to INT2.  However the default for ACPI tables is to map 8259A one-to-one 
to the I/O APIC.  Perhaps the intention of the authors of the spec was 
that hardware will gradually get designed this way or perhaps there was no 
clear reason at all.  Anyway the reality is most systems out there need 
an override for the timer interrupt and practice has shown it is sometimes 
missing.  As a result the pin that our code assumes is for the timer 
interrupt in fact is the 8259A ExtINTA interrupt, which as it happens, can 
be used for the timer, but we have to be careful

 The end result is we are trying to reuse the same logic in the code for 
a different purpose and while it is a reasonable approach, care has to be 
taken to take the slightly different circumstances into account.

 Of course if there is no INT2 override in the ACPI table, we might 
consider blindly checking whether it actually is a timer interrupt, 
because for systems which have the legacy 8259A chips IRQ2 makes no sense.

> Also Windows uses a different timer set up so this configuration is often
> not well tested.

 Well, they must have figured out the setup of the 8254 timer is
unreliable as well. ;-)  Actually the original i82489DX documents
explicitly discouraged SMP operating systems from using the 8254 because
of the missing wiring to the I/O APIC in some, especially early, systems
mentioned above.  The use of the mixed interrupt mode was implied if the
use of timer was found inevitable, which was recognised as not fully in
the spirit of an SMP system.  Later on the mixed mode proved problematic
too, because of various APIC errata.  Still we arrange for such a set-up
as the last resort in check_timer().

 The use of the local APIC timer as a replacement was recommended back
then, but I think IRQ8 from the RTC was also a good solution, as it was
still before the time the functionality started getting integrated into
chipsets and the line was always available to the I/O APIC.

  Maciej
