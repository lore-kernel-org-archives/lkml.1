Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYLAWrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYLAWrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYLAWrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:47:43 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:37850 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYLAWrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:47:42 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Subject: Re: [PATCH] PNPACPI: Enable Power Management
Date: Mon, 1 Dec 2008 15:47:33 -0700
User-Agent: KMail/1.9.10
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, rjw@sisk.pl
References: <4929C66F.1040206@gmx.net>
In-Reply-To: <4929C66F.1040206@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200812011547.34660.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 November 2008 02:09:03 pm Witold Szczeponik wrote:
> Subject: Enable PNPACI Power Management

Hi Witold,

Thanks for your patch.  I'm glad somebody is paying attention to
PNP and power.  I CC'd Adam and Rafael because they care about this
area, too, but might not read everything on linux-acpi.

> This patch sets the power of PnP ACPI devices to D0 when they
> are activated and to D3 when they are disabled.  The latter is
> in correspondence with the ACPI 3.0 specification, whereas the
> former is added in order to be able to power up a device after
> it has been previously disabled (or when booting up a system).
> (As a consequence, the patch makes the PnP ACPI code more ACPI
> compliant.)

Do you know of anything that specifies the order of the _CRS/_PS0
and the _PS3/_DIS evaluation?  I don't know much about power
management, and I couldn't find anything obvious in the spec.
It seems plausible that we should run _CRS before turning on
the power, but I really don't know.

> The patch fixes the problem with some IBM ThinkPads (at least
> the 600E and the 600X) where the serial ports have a dedicated
> power source that needs to be brought up before the serial port
> can be used.  Without this patch, the serial port is enabled
> but has no power.

Is pnpacpi_set_resources() the only place that needs this change?
For active devices, we normally don't call pnpacpi_set_resources()
at all.  So I suppose on these ThinkPads, we exercise this path
because the serial ports are initially disabled?

> No regressions were observed on hardware that does not require
> this patch.
> 
> The patch is applied against 2.6.27.7 (vanilla).
> 
> 
> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
> 
> 
> Index: linux/drivers/pnp/pnpacpi/core.c
> ===================================================================
> --- linux.orig/drivers/pnp/pnpacpi/core.c
> +++ linux/drivers/pnp/pnpacpi/core.c
> @@ -98,18 +98,24 @@ static int pnpacpi_set_resources(struct
>   	status = acpi_set_current_resources(handle, &buffer);
>   	if (ACPI_FAILURE(status))
>   		ret = -EINVAL;
> +	else if (acpi_bus_power_manageable(handle))
> +		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);

I don't really like testing acpi_bus_power_manageable() first.
I think we should just call acpi_bus_set_power() and let *it*
bail out if the device doesn't support it.

>   	kfree(buffer.pointer);
>   	return ret;
>   }
> 
>   static int pnpacpi_disable_resources(struct pnp_dev *dev)
>   {
> +	acpi_handle handle = dev->data;
> +	int ret = 0;
>   	acpi_status status;
> 
> -	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */

Can you leave the "unregister_gsi" comment there, since it's not
related to your patch?  It's a reminder that we need to think about
how to handle interrupts when enabling/disabling devices.

> -	status = acpi_evaluate_object((acpi_handle) dev->data,
> -				      "_DIS", NULL, NULL);
> -	return ACPI_FAILURE(status) ? -ENODEV : 0;
> +	if (acpi_bus_power_manageable(handle))
> +		ret = acpi_bus_set_power(handle, ACPI_STATE_D3);
> +	status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
> +	if (ACPI_FAILURE(status))
> +		ret = -ENODEV;
> +	return ret;
>   }
> 
>   #ifdef CONFIG_ACPI_SLEEP
