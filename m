Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZFCS0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZFCS0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZFCS0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:26:18 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:18829 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZFCS0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:26:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 07/10] ACPI: eviscerate pci_bind.c
Date: Wed, 3 Jun 2009 12:26:09 -0600
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20090602152351.7346.48697.stgit@bob.kio> <20090602152511.7346.46378.stgit@bob.kio>
In-Reply-To: <20090602152511.7346.46378.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031226.09800.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009 09:25:11 am Alex Chiang wrote:
> Now that we can dynamically convert an ACPI CA handle to a
> struct pci_dev at runtime, there's no need to statically bind
> them during boot.
> 
> acpi_pci_bind/unbind are vastly simplified, and are only used
> to evaluate _PRT methods on P2P bridges and non-bridge children.
> 
> This patchset lays further groundwork to eventually eliminate
> the acpi_driver_ops.bind callback.
> 
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/acpi/pci_bind.c     |  268 ++++++-------------------------------------
>  drivers/acpi/pci_root.c     |    2 
>  include/acpi/acpi_drivers.h |    3 
>  3 files changed, 41 insertions(+), 232 deletions(-)
> 
> diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
> index 10e3ffc..0469cf2 100644
> --- a/drivers/acpi/pci_bind.c
> +++ b/drivers/acpi/pci_bind.c
> @@ -3,6 +3,8 @@
>   *
>   *  Copyright (C) 2001, 2002 Andy Grover <andrew.grover@intel.com>
>   *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
> + *  Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
> + *	Alex Chiang <achiang@hp.com>
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   *
> @@ -24,12 +26,7 @@
>   */
>  
>  #include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/types.h>
> -#include <linux/proc_fs.h>
> -#include <linux/spinlock.h>
> -#include <linux/pm.h>
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
>  #include <acpi/acpi_bus.h>
> @@ -38,24 +35,6 @@
>  #define _COMPONENT		ACPI_PCI_COMPONENT
>  ACPI_MODULE_NAME("pci_bind");
>  
> -struct acpi_pci_data {
> -	struct acpi_pci_id id;
> -	struct pci_bus *bus;
> -	struct pci_dev *dev;
> -};
> -
> -static int acpi_pci_bind(struct acpi_device *device);
> -static int acpi_pci_unbind(struct acpi_device *device);
> -
> -static void acpi_pci_data_handler(acpi_handle handle, u32 function,
> -				  void *context)
> -{
> -
> -	/* TBD: Anything we need to do here? */
> -
> -	return;
> -}
> -
>  struct acpi_handle_node {
>  	struct list_head node;
>  	acpi_handle handle;
> @@ -139,241 +118,72 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
>  
> -
> -static int acpi_pci_bind(struct acpi_device *device)
> +static int acpi_pci_unbind(struct acpi_device *device)
>  {
> -	int result = 0;
> -	acpi_status status;
> -	struct acpi_pci_data *data;
> -	struct acpi_pci_data *pdata;
> -	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> -	acpi_handle handle;
> -
> -	if (!device || !device->parent)
> -		return -EINVAL;
> -
> -	data = kzalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
> -	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
> -	if (ACPI_FAILURE(status)) {
> -		kfree(data);
> -		return -ENODEV;
> -	}
> -
> -	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Binding PCI device [%s]...\n",
> -			  (char *)buffer.pointer));
> +	struct pci_dev *dev;
>  
> -	/* 
> -	 * Segment & Bus
> -	 * -------------
> -	 * These are obtained via the parent device's ACPI-PCI context.
> -	 */
> -	status = acpi_get_data(device->parent->handle, acpi_pci_data_handler,
> -			       (void **)&pdata);
> -	if (ACPI_FAILURE(status) || !pdata || !pdata->bus) {
> -		ACPI_EXCEPTION((AE_INFO, status,
> -				"Invalid ACPI-PCI context for parent device %s",
> -				acpi_device_bid(device->parent)));
> -		result = -ENODEV;
> -		goto end;
> -	}
> -	data->id.segment = pdata->id.segment;
> -	data->id.bus = pdata->bus->number;
> +	dev = acpi_get_pci_dev(device->handle);
> +	if (!dev)
> +		return 0;

I think you need some pci_put_dev() calls to correspond with the new
acpi_get_pci_dev() calls.

> -	/*
> -	 * Device & Function
> -	 * -----------------
> -	 * These are simply obtained from the device's _ADR method.  Note
> -	 * that a value of zero is valid.
> -	 */
> -	data->id.device = device->pnp.bus_address >> 16;
> -	data->id.function = device->pnp.bus_address & 0xFFFF;
> +	if (dev->subordinate)
> +		acpi_pci_irq_del_prt(pci_domain_nr(dev->bus),
> +				     dev->subordinate->number);
>  
> -	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "...to %04x:%02x:%02x.%d\n",
> -			  data->id.segment, data->id.bus, data->id.device,
> -			  data->id.function));
> +	return 0;
> +}
>  
> -	/*
> -	 * TBD: Support slot devices (e.g. function=0xFFFF).
> -	 */
> +static int acpi_pci_bind(struct acpi_device *device)
> +{
> +	acpi_status status;
> +	acpi_handle handle;
> +	unsigned char bus;
> +	struct pci_dev *dev;
>  
> -	/* 
> -	 * Locate PCI Device
> -	 * -----------------
> -	 * Locate matching device in PCI namespace.  If it doesn't exist
> -	 * this typically means that the device isn't currently inserted
> -	 * (e.g. docking station, port replicator, etc.).
> -	 */
> -	data->dev = pci_get_slot(pdata->bus,
> -				PCI_DEVFN(data->id.device, data->id.function));
> -	if (!data->dev) {
> -		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -				  "Device %04x:%02x:%02x.%d not present in PCI namespace\n",
> -				  data->id.segment, data->id.bus,
> -				  data->id.device, data->id.function));
> -		result = -ENODEV;
> -		goto end;
> -	}
> -	if (!data->dev->bus) {
> -		printk(KERN_ERR PREFIX
> -			    "Device %04x:%02x:%02x.%d has invalid 'bus' field\n",
> -			    data->id.segment, data->id.bus,
> -			    data->id.device, data->id.function);
> -		result = -ENODEV;
> -		goto end;
> -	}
> +	dev = acpi_get_pci_dev(device->handle);
> +	if (!dev)
> +		return 0;
>  
>  	/*
> -	 * PCI Bridge?
> -	 * -----------
> -	 * If so, set the 'bus' field and install the 'bind' function to 
> -	 * facilitate callbacks for all of its children.
> +	 * Install the 'bind' function to facilitate callbacks for
> +	 * children of the P2P bridge.
>  	 */
> -	if (data->dev->subordinate) {
> +	if (dev->subordinate) {
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  				  "Device %04x:%02x:%02x.%d is a PCI bridge\n",
> -				  data->id.segment, data->id.bus,
> -				  data->id.device, data->id.function));
> -		data->bus = data->dev->subordinate;
> +				  pci_domain_nr(dev->bus), dev->bus->number,
> +				  PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn)));
>  		device->ops.bind = acpi_pci_bind;
>  		device->ops.unbind = acpi_pci_unbind;
>  	}
>  
>  	/*
> -	 * Attach ACPI-PCI Context
> -	 * -----------------------
> -	 * Thus binding the ACPI and PCI devices.
> -	 */
> -	status = acpi_attach_data(device->handle, acpi_pci_data_handler, data);
> -	if (ACPI_FAILURE(status)) {
> -		ACPI_EXCEPTION((AE_INFO, status,
> -				"Unable to attach ACPI-PCI context to device %s",
> -				acpi_device_bid(device)));
> -		result = -ENODEV;
> -		goto end;
> -	}
> -
> -	/*
> -	 * PCI Routing Table
> -	 * -----------------
> -	 * Evaluate and parse _PRT, if exists.  This code is independent of 
> -	 * PCI bridges (above) to allow parsing of _PRT objects within the
> -	 * scope of non-bridge devices.  Note that _PRTs within the scope of
> -	 * a PCI bridge assume the bridge's subordinate bus number.
> +	 * Evaluate and parse _PRT, if exists.  This code allows parsing of
> +	 * _PRT objects within the scope of non-bridge devices.  Note that
> +	 * _PRTs within the scope of a PCI bridge assume the bridge's
> +	 * subordinate bus number.
>  	 *
>  	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
>  	 */
>  	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
> -	if (ACPI_SUCCESS(status)) {
> -		if (data->bus)	/* PCI-PCI bridge */
> -			acpi_pci_irq_add_prt(device->handle, data->id.segment,
> -					     data->bus->number);
> -		else		/* non-bridge PCI device */
> -			acpi_pci_irq_add_prt(device->handle, data->id.segment,
> -					     data->id.bus);
> -	}
> -
> -      end:
> -	kfree(buffer.pointer);
> -	if (result) {
> -		pci_dev_put(data->dev);
> -		kfree(data);
> -	}
> -	return result;
> -}
> -
> -static int acpi_pci_unbind(struct acpi_device *device)
> -{
> -	int result = 0;
> -	acpi_status status;
> -	struct acpi_pci_data *data;
> -	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> -
> -
> -	if (!device || !device->parent)
> -		return -EINVAL;
> -
> -	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
>  	if (ACPI_FAILURE(status))
> -		return -ENODEV;
> -
> -	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unbinding PCI device [%s]...\n",
> -			  (char *) buffer.pointer));
> -	kfree(buffer.pointer);
> +		return 0;
>  
> -	status =
> -	    acpi_get_data(device->handle, acpi_pci_data_handler,
> -			  (void **)&data);
> -	if (ACPI_FAILURE(status)) {
> -		result = -ENODEV;
> -		goto end;
> -	}
> +	if (dev->subordinate)
> +		bus = dev->subordinate->number;
> +	else
> +		bus = dev->bus->number;
>  
> -	status = acpi_detach_data(device->handle, acpi_pci_data_handler);
> -	if (ACPI_FAILURE(status)) {
> -		ACPI_EXCEPTION((AE_INFO, status,
> -				"Unable to detach data from device %s",
> -				acpi_device_bid(device)));
> -		result = -ENODEV;
> -		goto end;
> -	}
> -	if (data->dev->subordinate) {
> -		acpi_pci_irq_del_prt(data->id.segment, data->bus->number);
> -	}
> -	pci_dev_put(data->dev);
> -	kfree(data);
> +	acpi_pci_irq_add_prt(device->handle, pci_domain_nr(dev->bus), bus);
>  
> -      end:
> -	return result;
> +	return 0;
>  }
>  
>  int
> -acpi_pci_bind_root(struct acpi_device *device,
> -		   struct acpi_pci_id *id, struct pci_bus *bus)
> +acpi_pci_bind_root(struct acpi_device *device)

Since you're slicing and dicing anyway, can you make the proto
indentation here match the rest of the file ("int acpi_pci...")?

>  {
> -	int result = 0;
> -	acpi_status status;
> -	struct acpi_pci_data *data = NULL;
> -	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> -
> -	if (!device || !id || !bus) {
> -		return -EINVAL;
> -	}
> -
> -	data = kzalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
> -	data->id = *id;
> -	data->bus = bus;
>  	device->ops.bind = acpi_pci_bind;
>  	device->ops.unbind = acpi_pci_unbind;
>  
> -	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
> -	if (ACPI_FAILURE(status)) {
> -		kfree (data);
> -		return -ENODEV;
> -	}
> -
> -	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Binding PCI root bridge [%s] to "
> -			"%04x:%02x\n", (char *)buffer.pointer,
> -			id->segment, id->bus));
> -
> -	status = acpi_attach_data(device->handle, acpi_pci_data_handler, data);
> -	if (ACPI_FAILURE(status)) {
> -		ACPI_EXCEPTION((AE_INFO, status,
> -				"Unable to attach ACPI-PCI context to device %s",
> -				(char *)buffer.pointer));
> -		result = -ENODEV;
> -		goto end;
> -	}
> -
> -      end:
> -	kfree(buffer.pointer);
> -	if (result != 0)
> -		kfree(data);
> -
> -	return result;
> +	return 0;
>  }
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index bcab69a..25ddbb6 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -526,7 +526,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>  	 * -----------------------
>  	 * Thus binding the ACPI and PCI devices.
>  	 */
> -	result = acpi_pci_bind_root(device, &root->id, root->bus);
> +	result = acpi_pci_bind_root(device);
>  	if (result)
>  		goto end;
>  
> diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
> index 310f5ff..1c50f4f 100644
> --- a/include/acpi/acpi_drivers.h
> +++ b/include/acpi/acpi_drivers.h
> @@ -98,8 +98,7 @@ void acpi_pci_irq_del_prt(int segment, int bus);
>  struct pci_bus;
>  
>  struct pci_dev *acpi_get_pci_dev(acpi_handle);
> -int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
> -		       struct pci_bus *bus);
> +int acpi_pci_bind_root(struct acpi_device *device);
>  
>  /* Arch-defined function to add a bus to the system */
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


