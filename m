Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZGTUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZGTUzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZGTUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:55:49 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37089 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZGTUzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:55:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH v2 2/2] PCI Hotplug: acpiphp: get pci_bus from acpi handle correctly
Date: Mon, 20 Jul 2009 14:55:43 -0600
User-Agent: KMail/1.9.10
Cc: jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20090714204823.18933.40768.stgit@bob.kio> <20090714205333.18933.73027.stgit@bob.kio>
In-Reply-To: <20090714205333.18933.73027.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907201455.44959.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 July 2009 02:53:33 pm Alex Chiang wrote:
> We cannot simply call acpi_get_pci_dev() on any random ACPI handle
> and hope that it works, because a PCI root bridge may not have
> an associated struct pci_dev.
> 
> This is allowed per the PCI specification, and is referred to as a
> non-materialized bridge.
> 
> So, depending on the type of PCI bridge that the handle points to,
> use the appropriate interface to return the struct pci_bus correctly.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++++++-----------
>  1 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 0cb0f83..fa4658b 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -62,6 +62,21 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus);
>  static void acpiphp_set_hpp_values(acpi_handle handle, struct pci_bus *bus);
>  static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
>  
> +static struct pci_bus *pci_bus_from_handle(acpi_handle handle)
> +{
> +	struct pci_bus *pbus;
> +
> +	if (acpi_is_root_bridge(handle)) {
> +		struct acpi_pci_root *root = acpi_pci_find_root(handle);
> +		pbus = root->bus;
> +	} else {
> +		struct pci_dev *pdev = acpi_get_pci_dev(handle);
> +		pbus = pdev->subordinate;
> +		pci_dev_put(pdev);
> +	}
> +	return pbus;

I worry that acpi_is_root_bridge() merely checks the device IDs of
"handle", which isn't quite the same as checking whether the pci_root
driver has claimed "handle".

Are you confident that it's safe to move the pci_dev_put(), so it is
released before configuring the bridge?

What do you think about something like this (even though the get/put
is still a little clunky):

	struct pci_dev *dev = NULL;

	root = acpi_pci_find_root(handle);
	if (root)
		bus = root->bus;
	else {
		dev = acpi_get_pci_dev(handle);
		if (dev)
			bus = pdev->subordinate;
		else {
			err("cannot get PCI domain and bus number for bridge\n");
			return -EINVAL;
		}
	}

	pci_bus_size_bridges(bus);
	...
	if (dev)
		pci_dev_put(dev);
	return 0;

> +}
> +
>  /* callback routine to check for the existence of a pci dock device */
>  static acpi_status
>  is_pci_dock_device(acpi_handle handle, u32 lvl, void *context, void **rv)
> @@ -1387,16 +1402,7 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
>  /* Program resources in newly inserted bridge */
>  static int acpiphp_configure_bridge (acpi_handle handle)
>  {
> -	struct pci_dev *dev;
> -	struct pci_bus *bus;
> -
> -	dev = acpi_get_pci_dev(handle);
> -	if (!dev) {
> -		err("cannot get PCI domain and bus number for bridge\n");
> -		return -EINVAL;
> -	}
> -
> -	bus = dev->bus;
> +	struct pci_bus *bus = pci_bus_from_handle(handle);
>  
>  	pci_bus_size_bridges(bus);
>  	pci_bus_assign_resources(bus);
> @@ -1404,7 +1410,6 @@ static int acpiphp_configure_bridge (acpi_handle handle)
>  	acpiphp_set_hpp_values(handle, bus);
>  	pci_enable_bridges(bus);
>  	acpiphp_configure_ioapics(handle);
> -	pci_dev_put(dev);
>  	return 0;
>  }
