Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbYLHUlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbYLHUlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYLHUl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:41:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:40352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751985AbYLHUl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:41:27 -0500
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX19kQQtISyBkKbBDW7jHyJLy5eUJcxKFS1uTyM4nmH
	a2gfxpreWy7hUt
Message-ID: <493D862E.6010704@gmx.net>
Date: Mon, 08 Dec 2008 21:40:14 +0100
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Management
References: <4929C66F.1040206@gmx.net> <200812011547.34660.bjorn.helgaas@hp.com> <493BC487.1050103@gmx.net> <200812072129.29954.bjorn.helgaas@hp.com>
In-Reply-To: <200812072129.29954.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:

[old stuff removed]

>> I think it should be _SRS/_PS0 and _PS3/_DIS.
> 
> Thanks for the pointer.  That makes sense, and your proposed order
> makes the enable/disable paths symmetric, so I think you're right.
> Can you put that spec pointer in your changelog?
> 

Will do.  I'll send out a new version of the patch in a separate note.

>>> Is pnpacpi_set_resources() the only place that needs this change?
>>> For active devices, we normally don't call pnpacpi_set_resources()
>>> at all.  So I suppose on these ThinkPads, we exercise this path
>>> because the serial ports are initially disabled?
>> I'm not sure.  I would guess that we need to put any device that is
>> enabled (either via _SRS or by default) into D0.  My patch does that
>> for the _SRS case but the generic ACPI code does not.  On my 600E,
>> the serial port has power when the machine is booted but has no power
>> once GRUB kicks in.  It remains in this state until the 8250-pnp module
>> gets loaded, where my patch enables it.
> 
> Interesting.  I'd be surprised if GRUB does anything with ACPI to
> disable the port.  I don't know how you determine when the port has
> power.  Maybe the power-up default state is powered, and the BIOS
> turns it off before launching GRUB?

Most likely you are correct assuming that the BIOS turns the devices
off before starting GRUB.  Need to investigate...

> 
> I wonder if _STA is influenced by the power state.  I would think
> if _STA said a device was "enabled and decoding resources," that
> would only make sense if the device were already in D0.  But let's
> say we start with an active device, then run _PS3 and _DIS.  What
> would _STA say in the interval between _PS3 and _DIS?

I did not check this, but a quick look at the 600E's DSDT revealed
that powering up a device and its _STA status are not correlated,
at least on this machine.

> 
> This is just idle curiousity on my part, I guess.  I just don't
> know much about ACPI power states, and I'm afraid of getting in
> trouble if we change too much.  The _SRS path is a little less
> scary because it won't be exercised much (most devices are already
> enabled, and we don't change their settings).

ACK.

> 

[parts of the patch removed]

>>>> -	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
>>> Can you leave the "unregister_gsi" comment there, since it's not
>>> related to your patch?  It's a reminder that we need to think about
>>> how to handle interrupts when enabling/disabling devices.
>> I'd rather remove the comment as it is misleading, IMHO.  This call
>> should be made by a driver.  After all, the PNPACPI core does not
>> register any IRQs, either.  Otherwise, we need to think about
>> "pnp_irq(dev, 1)", too.  Either way, with my patch there should be
>> no IRQ handling possible.
> 
> The comment is logically unrelated to the rest of your patch, so I
> would at least split it into a separate patch just on that grounds.

ACK.  But will not tackle this any time soon.

> 
> The PNP core *does* register IRQs: we call acpi_register_gsi()
> in pnpacpi_parse_allocated_irqresource(), but there's no
> corresponding unregister.  I think this asymmetry is a bug,
> but I haven't looked at how to handle it yet.  PNP currently
> does the registration "eagerly," when the device is discovered.
> I think we should instead do the registration/unregistration
> "lazily," when a driver claims the device, as PCI does.

I find this asymmetry weird, too.  Maybe we could register when
the device is enabled and unregister when it is disabled?

> 
> I haven't changed this yet because there are some issues related to
> pcibios_penalize_isa_irq() -- we don't know the IRQ to penalize until
> we register the GSI.
> 
> Anyway, that's a long-winded explanation of why that stupid-looking
> comment still has some value to me :-)

Now I understand.  I'm giving in! :-D

> 
> Bjorn
> 

--- Witold
