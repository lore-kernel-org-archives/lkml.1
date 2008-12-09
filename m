Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYLIDKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYLIDKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYLIDKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:10:24 -0500
Received: from SOUTH-STATION-ANNEX.MIT.EDU ([18.72.1.2]:36716 "EHLO
	south-station-annex.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbYLIDKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:10:23 -0500
X-Greylist: delayed 862 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 22:10:23 EST
Message-ID: <20081208214910.6l58csoke98gw48w@webmail.mit.edu>
Date: Mon, 08 Dec 2008 21:49:10 -0500
From: Adam M Belay <abelay@MIT.EDU>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>, Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Support
References: <493D8A1F.2090907@gmx.net>
In-Reply-To: <493D8A1F.2090907@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.0.3)
X-Spam-Score: 0
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Witold,

All in all your patch looks good, especially in the context of
resolving the Thinkpad 600X issue.  I have some patches on the
way that will add more complete power management support to the
PNP stack and hopefully allow for runtime PM of these system
devices, but I think this is a good short-term solution.

One quick comment.  acpi_bus_set_power() can fail, and
pnpacpi_set_resources() needs to handle this gracefully.  Please
update the patch to include this.

Also, for the follow up to this patch, I'm wondering what sort
of ACPI behavior we need to support D1 and D2 states.  In PCI,
disabling resource decoding (similar to _DIS) is only required
for entering D3.  The ACPI spec seems to be ambiguous with this
issue.  Len, any thoughts?

Thanks,
Adam

Quoting Witold Szczeponik <Witold.Szczeponik@gmx.net>:

> Subject: Enable PNPACPI _PSx Support
>
>
> (This is an updated patch of http://lkml.org/lkml/2008/11/23/211)
>
> This patch sets the power of PnP ACPI devices to D0 when they
> are activated and to D3 when they are disabled.  The latter is
> in correspondence with the ACPI 3.0 specification, whereas the
> former is added in order to be able to power up a device after
> it has been previously disabled (or when booting up a system).
> (As a consequence, the patch makes the PnP ACPI code more ACPI
> compliant.)
>
> Section 6.2.2 of the ACPI Specification (at least versions 1.0b
> and 3.0a) states: "Prior to running this control method [_DIS],
> the OS[PM] will have already put the device in the D3 state."
> Unfortunately, there is no clear statement as to when to put
> a device in the D0 state. :-( Therefore, the patch executes the
> method calls as _PS3/_DIS and _SRS/_PS0. What is clear: "If the
> device is disabled, _SRS enables the device at the specified
> resources." (From the ACPI 3.0a Specification.)
>
> The patch fixes a problem with some IBM ThinkPads (at least the
> 600E and the 600X) where the serial ports have a dedicated
> power source that needs to be brought up before the serial port
> can be used.  Without this patch, the serial port is enabled
> but has no power. (In the past, the tpctl utility had to be
> utilized to turn on the power, but support for this feature
> stopped with version 5.9 as it did not support the more recent
> kernel versions.)
>
> No regressions were observed on hardware that does not require
> this patch.
>
> The patch is applied against 2.6.27.8 (vanilla).
>
>
> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
>
>
> Index: linux/drivers/pnp/pnpacpi/core.c
> ===================================================================
> --- linux.orig/drivers/pnp/pnpacpi/core.c
> +++ linux/drivers/pnp/pnpacpi/core.c
> @@ -98,17 +98,20 @@ static int pnpacpi_set_resources(struct
>  	status = acpi_set_current_resources(handle, &buffer);
>  	if (ACPI_FAILURE(status))
>  		ret = -EINVAL;
> +	else
> +		acpi_bus_set_power(handle, ACPI_STATE_D0);
>  	kfree(buffer.pointer);
>  	return ret;
>  }
>
>  static int pnpacpi_disable_resources(struct pnp_dev *dev)
>  {
> +	acpi_handle handle = dev->data;
>  	acpi_status status;
>
>  	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
> -	status = acpi_evaluate_object((acpi_handle) dev->data,
> -				      "_DIS", NULL, NULL);
> +	acpi_bus_set_power(handle, ACPI_STATE_D3);
> +	status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
>  	return ACPI_FAILURE(status) ? -ENODEV : 0;
>  }
>
>


