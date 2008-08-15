Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbYHOQeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbYHOQeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYHOQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:34:06 -0400
Received: from outbound-mail-148.bluehost.com ([67.222.38.38]:51813 "HELO
	outbound-mail-148.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756022AbYHOQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:34:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=CR1+dQH4yP466a0v05ZS7YTIvtRtg/41CCx5A1ZRELxQ6mHvRrwxROfOpLeB5ppzeKwKjNIXkSkDj3TxQApnBpVbCw99NLm/HROl9OLXGD1MbkZLURPi1rTCLIu9xlxI;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] PCI: acpi_pcihp, run _OSC on a root bridge
Date: Fri, 15 Aug 2008 09:33:55 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristen.c.accardi@intel.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>
References: <1218469660-24230-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1218469660-24230-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808150933.55881.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc'ing Alex & Kenji-san for their comments on this fix.]

On Monday, August 11, 2008 8:47 am Jiri Slaby wrote:
> _OSC should be ran on a root bridge instead of the device itself.
> Do this before touching OSHP since PCI fw specs states that _OSC
> should be preferred over OSHP (however if the device has OSHP but
> not _OSC -- not a root bridge -- it's not).
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: kristen.c.accardi@intel.com
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/hotplug/acpi_pcihp.c |   41
> ++++++++++++++++++++++++++----------- 1 files changed, 29 insertions(+), 12
> deletions(-)
>
> diff --git a/drivers/pci/hotplug/acpi_pcihp.c
> b/drivers/pci/hotplug/acpi_pcihp.c index 93e37f0..bd83197 100644
> --- a/drivers/pci/hotplug/acpi_pcihp.c
> +++ b/drivers/pci/hotplug/acpi_pcihp.c
> @@ -382,7 +382,7 @@ EXPORT_SYMBOL_GPL(acpi_get_hp_params_from_firmware);
>  int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags)
>  {
>  	acpi_status status;
> -	acpi_handle chandle, handle = DEVICE_ACPI_HANDLE(&(dev->dev));
> +	acpi_handle chandle, handle;
>  	struct pci_dev *pdev = dev;
>  	struct pci_bus *parent;
>  	struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
> @@ -399,10 +399,28 @@ int acpi_get_hp_hw_control_from_firmware(struct
> pci_dev *dev, u32 flags) * Per PCI firmware specification, we should run
> the ACPI _OSC
>  	 * method to get control of hotplug hardware before using it. If
>  	 * an _OSC is missing, we look for an OSHP to do the same thing.
> -	 * To handle different BIOS behavior, we look for _OSC and OSHP
> -	 * within the scope of the hotplug controller and its parents,
> +	 * To handle different BIOS behavior, we look for _OSC on a root
> +	 * bridge preferentially (according to PCI fw spec). Later for
> +	 * OSHP within the scope of the hotplug controller and its parents,
>  	 * upto the host bridge under which this controller exists.
>  	 */
> +	while (pdev->bus->self)
> +		pdev = pdev->bus->self;
> +	handle = acpi_get_pci_rootbridge_handle(pci_domain_nr(pdev->bus),
> +			pdev->bus->number);
> +	if (handle) {
> +		acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
> +		dbg("Trying to get hotplug control for %s\n",
> +				(char *)string.pointer);
> +		status = pci_osc_control_set(handle, flags);
> +		if (ACPI_SUCCESS(status))
> +			goto got_one;
> +		kfree(string.pointer);
> +		string = (struct acpi_buffer){ ACPI_ALLOCATE_BUFFER, NULL };
> +	}
> +
> +	pdev = dev;
> +	handle = DEVICE_ACPI_HANDLE(&dev->dev);
>  	while (!handle) {
>  		/*
>  		 * This hotplug controller was not listed in the ACPI name
> @@ -427,15 +445,9 @@ int acpi_get_hp_hw_control_from_firmware(struct
> pci_dev *dev, u32 flags) acpi_get_name(handle, ACPI_FULL_PATHNAME,
> &string);
>  		dbg("Trying to get hotplug control for %s \n",
>  		    (char *)string.pointer);
> -		status = pci_osc_control_set(handle, flags);
> -		if (status == AE_NOT_FOUND)
> -			status = acpi_run_oshp(handle);
> -		if (ACPI_SUCCESS(status)) {
> -			dbg("Gained control for hotplug HW for pci %s (%s)\n",
> -			    pci_name(dev), (char *)string.pointer);
> -			kfree(string.pointer);
> -			return 0;
> -		}
> +		status = acpi_run_oshp(handle);
> +		if (ACPI_SUCCESS(status))
> +			goto got_one;
>  		if (acpi_root_bridge(handle))
>  			break;
>  		chandle = handle;
> @@ -449,6 +461,11 @@ int acpi_get_hp_hw_control_from_firmware(struct
> pci_dev *dev, u32 flags)
>
>  	kfree(string.pointer);
>  	return -ENODEV;
> +got_one:
> +	dbg("Gained control for hotplug HW for pci %s (%s)\n", pci_name(dev),
> +			(char *)string.pointer);
> +	kfree(string.pointer);
> +	return 0;
>  }
>  EXPORT_SYMBOL(acpi_get_hp_hw_control_from_firmware);



-- 
Jesse Barnes, Intel Open Source Technology Center
