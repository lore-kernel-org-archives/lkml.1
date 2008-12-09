Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYLIDAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYLIDAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYLIDAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:00:30 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21814 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYLIDA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:00:29 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Adam M Belay <abelay@mit.edu>
Subject: Re: [PATCH] PNPACPI: Enable Power Support
Date: Mon, 8 Dec 2008 20:00:05 -0700
User-Agent: KMail/1.9.10
Cc: Witold Szczeponik <Witold.Szczeponik@gmx.net>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
References: <493D8A1F.2090907@gmx.net> <20081208214910.6l58csoke98gw48w@webmail.mit.edu>
In-Reply-To: <20081208214910.6l58csoke98gw48w@webmail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812082000.05472.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008 7:49:10 pm Adam M Belay wrote:
> Hi Witold,
>
> All in all your patch looks good, especially in the context of
> resolving the Thinkpad 600X issue.  I have some patches on the
> way that will add more complete power management support to the
> PNP stack and hopefully allow for runtime PM of these system
> devices, but I think this is a good short-term solution.
>
> One quick comment.  acpi_bus_set_power() can fail, and
> pnpacpi_set_resources() needs to handle this gracefully.  Please
> update the patch to include this.

Hi Adam,

Do you have any proposals for how pnpacpi_set_resources() should
handle failure?  Witold started out with code to call acpi_bus_set_power()
only if the device is power-manageable, and he then passed the
return code up.  I suggested letting acpi_bus_set_power() do
the "is-power-manageable" check.  But then the caller would have
to distinguish the "device isn't power-manageable" error from
others, which is kind of ugly.

Bjorn

> Also, for the follow up to this patch, I'm wondering what sort
> of ACPI behavior we need to support D1 and D2 states.  In PCI,
> disabling resource decoding (similar to _DIS) is only required
> for entering D3.  The ACPI spec seems to be ambiguous with this
> issue.  Len, any thoughts?
>
> Thanks,
> Adam
>
> Quoting Witold Szczeponik <Witold.Szczeponik@gmx.net>:
> > Subject: Enable PNPACPI _PSx Support
> >
> >
> > (This is an updated patch of http://lkml.org/lkml/2008/11/23/211)
> >
> > This patch sets the power of PnP ACPI devices to D0 when they
> > are activated and to D3 when they are disabled.  The latter is
> > in correspondence with the ACPI 3.0 specification, whereas the
> > former is added in order to be able to power up a device after
> > it has been previously disabled (or when booting up a system).
> > (As a consequence, the patch makes the PnP ACPI code more ACPI
> > compliant.)
> >
> > Section 6.2.2 of the ACPI Specification (at least versions 1.0b
> > and 3.0a) states: "Prior to running this control method [_DIS],
> > the OS[PM] will have already put the device in the D3 state."
> > Unfortunately, there is no clear statement as to when to put
> > a device in the D0 state. :-( Therefore, the patch executes the
> > method calls as _PS3/_DIS and _SRS/_PS0. What is clear: "If the
> > device is disabled, _SRS enables the device at the specified
> > resources." (From the ACPI 3.0a Specification.)
> >
> > The patch fixes a problem with some IBM ThinkPads (at least the
> > 600E and the 600X) where the serial ports have a dedicated
> > power source that needs to be brought up before the serial port
> > can be used.  Without this patch, the serial port is enabled
> > but has no power. (In the past, the tpctl utility had to be
> > utilized to turn on the power, but support for this feature
> > stopped with version 5.9 as it did not support the more recent
> > kernel versions.)
> >
> > No regressions were observed on hardware that does not require
> > this patch.
> >
> > The patch is applied against 2.6.27.8 (vanilla).
> >
> >
> > Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
> >
> >
> > Index: linux/drivers/pnp/pnpacpi/core.c
> > ===================================================================
> > --- linux.orig/drivers/pnp/pnpacpi/core.c
> > +++ linux/drivers/pnp/pnpacpi/core.c
> > @@ -98,17 +98,20 @@ static int pnpacpi_set_resources(struct
> >  	status = acpi_set_current_resources(handle, &buffer);
> >  	if (ACPI_FAILURE(status))
> >  		ret = -EINVAL;
> > +	else
> > +		acpi_bus_set_power(handle, ACPI_STATE_D0);
> >  	kfree(buffer.pointer);
> >  	return ret;
> >  }
> >
> >  static int pnpacpi_disable_resources(struct pnp_dev *dev)
> >  {
> > +	acpi_handle handle = dev->data;
> >  	acpi_status status;
> >
> >  	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
> > -	status = acpi_evaluate_object((acpi_handle) dev->data,
> > -				      "_DIS", NULL, NULL);
> > +	acpi_bus_set_power(handle, ACPI_STATE_D3);
> > +	status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
> >  	return ACPI_FAILURE(status) ? -ENODEV : 0;
> >  }


