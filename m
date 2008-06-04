Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYFDLhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYFDLhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYFDLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:37:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:50471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYFDLg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:36:59 -0400
Date: Wed, 4 Jun 2008 13:37:30 +0200
From: Olaf Dabrunz <od@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stefan Assmann <sassmann@suse.de>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
Message-ID: <20080604113730.GE16200@suse.de>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Stefan Assmann <sassmann@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
References: <12124107071847-git-send-email-od@suse.de> <m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de> <m1ve0pqy06.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1ve0pqy06.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-Jun-08, Eric W. Biederman wrote:
> Stefan Assmann <sassmann@suse.de> writes:
> 
> > On the chips (ICHx, ...) we saw, the interrupt lines on the PIC also go
> > to the first IO-APIC. So the boot interrupts go to both the PIC and the
> > first IO-APIC.
> >
> > When running in APIC mode all PIC IRQs are disabled, except for the
> > timer maybe. Boot interrupts still arrive on the first IO-APIC and end
> > up as being counted as spurious interrupts.
> 
> So the boot interrupt comes in on one of the legacy irq vectors on
> the first ioapic, but it is a native ioapic irq.
> 
> What is the reason why you don't simply disable the ioapic vector of
> the boot interrupt?  Do some devices not use anything else?

Yes, other devices do use the same ioapic irq. Depending on the chipset
and mainboard wiring, these other devices can or cannot be moved to a
different IRQ. Also, this changes with chipset generations and there are
several registers to consider for every chipset to re-route these
devices.

This solution would need to be worked on intesively, it will not work
often enough and also maintenance would cost a lot of time.

On the other hand, we see the reroute patch as a legacy support
workaround. Newer chipsets can usually disable the boot interrupt. But
devices like the 6700PXH are still around a lot.

None of the newer chipsets we looked at needs a workaround like
re-routing.

> > The lines where the boot interrupts show up are usually hard wired to
> > the first IO-APIC. It might be possible to move devices that share these
> > lines to other interrupts but in many cases, especially on older ICHs,
> > this is not possible.
> 
> Not what I was suggesting.
> 
> As I read the above.  It says:
> When you can not disable the boot interrupt you don't attempt to use
> the non-boot interrupts and use the boot interrupt for everything.

Right.

> If that is what your patches implement I disagree with that approach
> for the mainstream kernel.

Amongst all the approaches we discussed before creating the patch, this
was the only working solution.

What would be your suggestion to handle boot interrupts that cannot be
disabled?

> > The wiring of the boot interrupts follows a fixed pattern on most
> > bridges and generates a PCI IRQ. This ends up on the ICH or equivalent,
> > where it either is hard-wired to IRQ 16 to 24, or can be routed to
> > some IRQ through a programmable mapping. An example for the mappings
> > on intel chips is in another mail in this thread.
> 
> I will have to look.  I am familiar with the concept but I have

Yes, please. :)

> not looked at any of these in detail for a while.
>
> >> For the mainstream kernel I expect we can even teach the drivers
> >> not to call disable_irq.  As a function of last resort to deal
> >> with screaming irqs, disable_irq seems reasonable.  Using disable_irq
> >> on a regular basis appears to be asking for a trouble (as you have
> >> found).
> >
> > We see these boot interrupts mainly in the RT kernels, which handle
> > interrupts in threads. To do this, they mask the IRQ until it has been
> > handled. The masking sets up the conditions on the chip so that boot
> > interrupts are generated.
> 
> Yes.  My point being that because we don't do that in the mainstream
> kernels we have more robust alternatives in the mainstream kernel.

The mainline kernel uses masking to disable IRQ lines. The IRQ should
then not appear somewhere else and cause spurious interrupts. This is
the reason why we believe the reroute patch is also beneficial to the
mainline kernel.

That being said, I also would be glad if we had an elegant solution.

> > Some chips (6700PXH, ...) are not PCIe 2.x (IIR the version correctly)
> > compatible, and they do not support switching off INTx generation.
> > We tried this anyway for the 6700PXH and it did not work.
> 
> So much for that idea then.
> 
> Eric

Thanks a lot, :)

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

