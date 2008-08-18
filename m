Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYHROac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYHROac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHROaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:30:24 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13751 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYHROaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:30:22 -0400
Date: Mon, 18 Aug 2008 08:30:19 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 1/1] PCI: acpi_pcihp, run _OSC on a root bridge
Message-ID: <20080818143019.GC2537@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jiri Slaby <jirislaby@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <1218469660-24230-1-git-send-email-jirislaby@gmail.com> <200808150933.55881.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808150933.55881.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> [Cc'ing Alex & Kenji-san for their comments on this fix.]
> 
> On Monday, August 11, 2008 8:47 am Jiri Slaby wrote:
> > _OSC should be ran on a root bridge instead of the device itself.
> > Do this before touching OSHP since PCI fw specs states that _OSC
> > should be preferred over OSHP (however if the device has OSHP but
> > not _OSC -- not a root bridge -- it's not).

Reviewed the PCI fw spec (v3.0) and this code, and Jiri's change
seems sane to me.

One minor nit below.

> >
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > Cc: kristen.c.accardi@intel.com
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > ---
> >  drivers/pci/hotplug/acpi_pcihp.c |   41
> > ++++++++++++++++++++++++++----------- 1 files changed, 29 insertions(+), 12
> > deletions(-)
> >
> > diff --git a/drivers/pci/hotplug/acpi_pcihp.c
> > b/drivers/pci/hotplug/acpi_pcihp.c index 93e37f0..bd83197 100644
> > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > @@ -382,7 +382,7 @@ EXPORT_SYMBOL_GPL(acpi_get_hp_params_from_firmware);
> >  int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags)
> >  {
> >  	acpi_status status;
> > -	acpi_handle chandle, handle = DEVICE_ACPI_HANDLE(&(dev->dev));
> > +	acpi_handle chandle, handle;
> >  	struct pci_dev *pdev = dev;
> >  	struct pci_bus *parent;
> >  	struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
> > @@ -399,10 +399,28 @@ int acpi_get_hp_hw_control_from_firmware(struct
> > pci_dev *dev, u32 flags) * Per PCI firmware specification, we should run
> > the ACPI _OSC
> >  	 * method to get control of hotplug hardware before using it. If
> >  	 * an _OSC is missing, we look for an OSHP to do the same thing.
> > -	 * To handle different BIOS behavior, we look for _OSC and OSHP
> > -	 * within the scope of the hotplug controller and its parents,
> > +	 * To handle different BIOS behavior, we look for _OSC on a root
> > +	 * bridge preferentially (according to PCI fw spec). Later for
> > +	 * OSHP within the scope of the hotplug controller and its parents,
> >  	 * upto the host bridge under which this controller exists.
> >  	 */
> > +	while (pdev->bus->self)
> > +		pdev = pdev->bus->self;
> > +	handle = acpi_get_pci_rootbridge_handle(pci_domain_nr(pdev->bus),
> > +			pdev->bus->number);

This looks an awful lot like the first few lines of
aer_osc_setup(). Any chance you could factor those lines out into
a common inline?

static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
{
	while (pdev->bus->self)
		pdev = pdev->bus->self;

	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pdev->bus),
					      pdev->bus->number);
}

<linux/pci-acpi.h> might be a good place for that.

Just a thought.

But otherwise,

Acked-by: Alex Chiang <achiang@hp.com>

Thanks.

/ac

> > +	if (handle) {
> > +		acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
> > +		dbg("Trying to get hotplug control for %s\n",
> > +				(char *)string.pointer);
> > +		status = pci_osc_control_set(handle, flags);
> > +		if (ACPI_SUCCESS(status))
> > +			goto got_one;
> > +		kfree(string.pointer);
> > +		string = (struct acpi_buffer){ ACPI_ALLOCATE_BUFFER, NULL };
> > +	}
> > +
> > +	pdev = dev;
> > +	handle = DEVICE_ACPI_HANDLE(&dev->dev);
> >  	while (!handle) {
> >  		/*
> >  		 * This hotplug controller was not listed in the ACPI name
> > @@ -427,15 +445,9 @@ int acpi_get_hp_hw_control_from_firmware(struct
> > pci_dev *dev, u32 flags) acpi_get_name(handle, ACPI_FULL_PATHNAME,
> > &string);
> >  		dbg("Trying to get hotplug control for %s \n",
> >  		    (char *)string.pointer);
> > -		status = pci_osc_control_set(handle, flags);
> > -		if (status == AE_NOT_FOUND)
> > -			status = acpi_run_oshp(handle);
> > -		if (ACPI_SUCCESS(status)) {
> > -			dbg("Gained control for hotplug HW for pci %s (%s)\n",
> > -			    pci_name(dev), (char *)string.pointer);
> > -			kfree(string.pointer);
> > -			return 0;
> > -		}
> > +		status = acpi_run_oshp(handle);
> > +		if (ACPI_SUCCESS(status))
> > +			goto got_one;
> >  		if (acpi_root_bridge(handle))
> >  			break;
> >  		chandle = handle;
> > @@ -449,6 +461,11 @@ int acpi_get_hp_hw_control_from_firmware(struct
> > pci_dev *dev, u32 flags)
> >
> >  	kfree(string.pointer);
> >  	return -ENODEV;
> > +got_one:
> > +	dbg("Gained control for hotplug HW for pci %s (%s)\n", pci_name(dev),
> > +			(char *)string.pointer);
> > +	kfree(string.pointer);
> > +	return 0;
> >  }
> >  EXPORT_SYMBOL(acpi_get_hp_hw_control_from_firmware);
> 
> 
> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center
> 
