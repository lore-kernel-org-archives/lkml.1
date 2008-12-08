Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYLHEaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYLHEaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 23:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbYLHE3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 23:29:53 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:39537 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYLHE3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 23:29:52 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Subject: Re: [PATCH] PNPACPI: Enable Power Management
Date: Sun, 7 Dec 2008 21:29:29 -0700
User-Agent: KMail/1.9.10
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, rjw@sisk.pl
References: <4929C66F.1040206@gmx.net> <200812011547.34660.bjorn.helgaas@hp.com> <493BC487.1050103@gmx.net>
In-Reply-To: <493BC487.1050103@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072129.29954.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2008 5:41:43 am Witold Szczeponik wrote:
> Bjorn Helgaas wrote:
> > Do you know of anything that specifies the order of the _CRS/_PS0
> > and the _PS3/_DIS evaluation?  I don't know much about power
> > management, and I couldn't find anything obvious in the spec.
> > It seems plausible that we should run _CRS before turning on
> > the power, but I really don't know.
>
> There's some info the ACPI Specification that says a device needs
> to be put to D3 before _DIS is called (section 6.2.2) but there
> is no clear statement as to when to put a device to D0... :-(
>
> I think it should be _SRS/_PS0 and _PS3/_DIS.

Thanks for the pointer.  That makes sense, and your proposed order
makes the enable/disable paths symmetric, so I think you're right.
Can you put that spec pointer in your changelog?

> > Is pnpacpi_set_resources() the only place that needs this change?
> > For active devices, we normally don't call pnpacpi_set_resources()
> > at all.  So I suppose on these ThinkPads, we exercise this path
> > because the serial ports are initially disabled?
>
> I'm not sure.  I would guess that we need to put any device that is
> enabled (either via _SRS or by default) into D0.  My patch does that
> for the _SRS case but the generic ACPI code does not.  On my 600E,
> the serial port has power when the machine is booted but has no power
> once GRUB kicks in.  It remains in this state until the 8250-pnp module
> gets loaded, where my patch enables it.

Interesting.  I'd be surprised if GRUB does anything with ACPI to
disable the port.  I don't know how you determine when the port has
power.  Maybe the power-up default state is powered, and the BIOS
turns it off before launching GRUB?

I wonder if _STA is influenced by the power state.  I would think
if _STA said a device was "enabled and decoding resources," that
would only make sense if the device were already in D0.  But let's
say we start with an active device, then run _PS3 and _DIS.  What
would _STA say in the interval between _PS3 and _DIS?

This is just idle curiousity on my part, I guess.  I just don't
know much about ACPI power states, and I'm afraid of getting in
trouble if we change too much.  The _SRS path is a little less
scary because it won't be exercised much (most devices are already
enabled, and we don't change their settings).

> The ACPI Specification says for _SRS: the device is enabled after the
> method has returned.  There is no statement as to when to call _PS0...

> >>   static int pnpacpi_disable_resources(struct pnp_dev *dev)
> >>   {
> >> +	acpi_handle handle = dev->data;
> >> +	int ret = 0;
> >>   	acpi_status status;
> >>
> >> -	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
> >
> > Can you leave the "unregister_gsi" comment there, since it's not
> > related to your patch?  It's a reminder that we need to think about
> > how to handle interrupts when enabling/disabling devices.
>
> I'd rather remove the comment as it is misleading, IMHO.  This call
> should be made by a driver.  After all, the PNPACPI core does not
> register any IRQs, either.  Otherwise, we need to think about
> "pnp_irq(dev, 1)", too.  Either way, with my patch there should be
> no IRQ handling possible.

The comment is logically unrelated to the rest of your patch, so I
would at least split it into a separate patch just on that grounds.

The PNP core *does* register IRQs: we call acpi_register_gsi()
in pnpacpi_parse_allocated_irqresource(), but there's no
corresponding unregister.  I think this asymmetry is a bug,
but I haven't looked at how to handle it yet.  PNP currently
does the registration "eagerly," when the device is discovered.
I think we should instead do the registration/unregistration
"lazily," when a driver claims the device, as PCI does.

I haven't changed this yet because there are some issues related to
pcibios_penalize_isa_irq() -- we don't know the IRQ to penalize until
we register the GSI.

Anyway, that's a long-winded explanation of why that stupid-looking
comment still has some value to me :-)

Bjorn
