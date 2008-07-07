Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYGGRMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYGGRMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYGGRML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:12:11 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64167 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753493AbYGGRMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:12:09 -0400
Date: Mon, 7 Jul 2008 18:10:48 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
 systems
In-Reply-To: <200807071428.53598.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0807071743280.20615@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
 <20080707071706.GA3326@elte.hu> <Pine.LNX.4.55.0807071224491.16767@cliff.in.clinika.pl>
 <200807071428.53598.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Rafael J. Wysocki wrote:

> BTW, did you even to look at the code _as_ _is_ in linux-next?

 Well, I hope it has not changed too much since my recent work in this 
area...

> In fact, it is _impossible_ that either apic1 or pin1 are equal to -1 at this
> point, because of this part:

 With the workaround activated it is virtually certain.

> 	/*
> 	 * Some BIOS writers are clueless and report the ExtINTA
> 	 * I/O APIC input from the cascaded 8259A as the timer
> 	 * interrupt input.  So just in case, if only one pin
> 	 * was found above, try it both directly and through the
> 	 * 8259A.
> 	 */
> 	if (pin1 == -1) {
> 		pin1 = pin2;
> 		apic1 = apic2;
> 		no_pin1 = 1;
> 	} else if (pin2 == -1) {
> 		pin2 = pin1;
> 		apic2 = apic1;
> 	}
> 
> that originates from your patch.

 And the conclusion is?  If we leave MP-table setups aside as irrelevant
for this configuration, we can be almost certain apic2 and pin2 are both
equal to -1 at this point.  This is because (unlike the MP table) ACPI has
no provisions in its tables for ExtINTA APIC interrupt inputs.  Therefore
the only case apic2 and pin2 may not be equal -1 here is when the firmware
had set up one of the inputs as such in the hardware before initiating
bootstrap which has been subsequently noted by a piece of code in
enable_IO_APIC() which examines the I/O APIC for such a condition.

 I have taken these circumstances very much into account when preparing
the workaround, based on the assumption that if the firmware has set up an
I/O APIC line as an ExtINTA interrupt, then it means it considers it
suitable to use in such a manner.  This furthermore implies the line
should be safe to be used in any valid 8259A mode of operation, such as
one we use to forward IRQ0 transparently through the 8259A (we
double-check it just in case though, as workarounds for hardware bugs in
the past made it not always true).  The workaround therefore applies to
genuine IRQ0 routing as reported by ACPI only and not any possible legacy
ExtINTA fallback that we may attempt to use.

 Of course, as determined previously, the ExtINTA line is not safe to be
used on your box, but it has not been set up by the firmware as an ExtINTA
interrupt either, so the assumption mentioned above remains valid and has
no negative impact on your system.  At this point all of apic1, apic2,
pin1 and pin2 should be equal -1, which means the reassignments you quoted
make no changes to the variables.

> End even without this part apic1 and pin1 are _not_ equal to -1 on this box
> (apic2 and pin2 are, but that's a different matter).

 Which means the workaround has not triggered and the rest of cosideration 
is therefore irrelevant.  Please get us these DMI IDs, so that we can see 
what's wrong with the quirk.

  Maciej
