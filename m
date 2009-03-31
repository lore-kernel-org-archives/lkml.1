Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbZCaBpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbZCaBpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZCaBpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:45:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:45151 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbZCaBpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,449,1233561600"; 
   d="scan'208";a="125908128"
Subject: Re: [PATCH] PNPACPI: Enable PNPACPI _PSx Support, v3
From: yakui_zhao <yakui.zhao@intel.com>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "abelay@mit.edu" <abelay@mit.edu>, "rjw@sisk.pl" <rjw@sisk.pl>
In-Reply-To: <49D101DA.50201@gmx.net>
References: <49D101DA.50201@gmx.net>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Tue, 31 Mar 2009 09:45:39 +0800
Message-Id: <1238463939.3625.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 01:31 +0800, Witold Szczeponik wrote:
> Subject: Enable PNPACPI _PSx Support, v3
> 
    Very good patch.
    Do you have the hardware on which the dedicated power source is
required by the serial port(PnP device) in your hand?

When the Pnp ACPI device is started, it should be changed to D0 state if
there exists the _PSX object or the power resource is required. 
When it is disabled, it should be changed to D3 state.

   acked-by: Zhao Yakui <yakui.zhao@intel.com>

Thanks.
> 
> (This is an update to the patch presented earlier in
> http://lkml.org/lkml/2008/12/8/284, with new error handling.)
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
> The error handlers that handle any errors that can occur during
> the power up/power down phases return the error codes to the
> caller directly.  Comments welcome! :-)
> 
> No regressions were observed on hardware that does not require
> this patch.
> 
> The patch is applied against 2.6.27.x.
> 
> 
> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
> 
> 
> Index: linux/drivers/pnp/pnpacpi/core.c
> ===================================================================
> --- linux.orig/drivers/pnp/pnpacpi/core.c
> +++ linux/drivers/pnp/pnpacpi/core.c
> @@ -84,7 +84,6 @@ static int pnpacpi_set_resources(struct
>   	acpi_handle handle = dev->data;
>   	struct acpi_buffer buffer;
>   	int ret;
> -	acpi_status status;
> 
>   	dev_dbg(&dev->dev, "set resources\n");
>   	ret = pnpacpi_build_resource_template(dev, &buffer);
> @@ -95,21 +94,30 @@ static int pnpacpi_set_resources(struct
>   		kfree(buffer.pointer);
>   		return ret;
>   	}
> -	status = acpi_set_current_resources(handle, &buffer);
> -	if (ACPI_FAILURE(status))
> +	if (ACPI_FAILURE(acpi_set_current_resources(handle, &buffer)))
>   		ret = -EINVAL;
> +	else if (acpi_bus_power_manageable(handle))
> +		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);
How about changing the power state before calling _SRS object?
>   	kfree(buffer.pointer);
>   	return ret;
>   }
> 
>   static int pnpacpi_disable_resources(struct pnp_dev *dev)
>   {
> -	acpi_status status;
> +	acpi_handle handle = dev->data;
> +	int ret;
> 
> +	dev_dbg(&dev->dev, "disable resources\n");
>   	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
> -	status = acpi_evaluate_object((acpi_handle) dev->data,
> -				      "_DIS", NULL, NULL);
> -	return ACPI_FAILURE(status) ? -ENODEV : 0;
> +	ret = 0;
> +	if (acpi_bus_power_manageable(handle)) {
> +		ret = acpi_bus_set_power(handle, ACPI_STATE_D3);
> +		if (ret)
> +			return ret;
> +	}
> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DIS", NULL, NULL)))
> +		ret = -ENODEV;
> +	return ret;
>   }
> 
>   #ifdef CONFIG_ACPI_SLEEP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

