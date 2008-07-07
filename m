Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYGGM0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYGGM0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYGGM0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:26:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbYGGM0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:26:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Mon, 7 Jul 2008 14:28:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <20080707071706.GA3326@elte.hu> <Pine.LNX.4.55.0807071224491.16767@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0807071224491.16767@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071428.53598.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Maciej W. Rozycki wrote:
> On Mon, 7 Jul 2008, Ingo Molnar wrote:
> 
> > > Please note two things:
> > > (1) The whole acpi_dmi_table[] thing originally depended on __i386__, so it
> > >     wouldn't work on x86-64 no matter what.  I removed that dependecy, but
> > >     I have no idea why it was there and so I'm not sure if that's correct. 
> 
>  Well spottedd -- perhaps the x86-64 was though to be perfect. ;)
> 
> > > (2) The clear_IO_APIC_pin(apic1, pin1) done if 
> > >     disable_irq0_through_ioapic is true is absolutely essential.  The 
> > >     symptoms are 100% reproducible without it.
> > 
> > thanks, applied to tip/x86, to give this some more testing.
> > 
> > the clear_IO_APIC_pin() is the most worrisome aspect of the change - but 
> > since we are already in limited quirk mode, does it hurt? Maciej, any 
> > preferences?
> 
>  It makes absolutely no sense and should be harmful to call
> clear_IO_APIC_pin(apic1, pin1) here, because both apic1 and pin1 should be
> equal to -1 here.  If it has to be called, then I suppose the DMI matching 
> did not work and the workaround has not been enabled.

BTW, did you even to look at the code _as_ _is_ in linux-next?

In fact, it is _impossible_ that either apic1 or pin1 are equal to -1 at this
point, because of this part:

	/*
	 * Some BIOS writers are clueless and report the ExtINTA
	 * I/O APIC input from the cascaded 8259A as the timer
	 * interrupt input.  So just in case, if only one pin
	 * was found above, try it both directly and through the
	 * 8259A.
	 */
	if (pin1 == -1) {
		pin1 = pin2;
		apic1 = apic2;
		no_pin1 = 1;
	} else if (pin2 == -1) {
		pin2 = pin1;
		apic2 = apic1;
	}

that originates from your patch.

End even without this part apic1 and pin1 are _not_ equal to -1 on this box
(apic2 and pin2 are, but that's a different matter).

Thanks,
Rafael
