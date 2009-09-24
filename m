Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZIXP1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZIXP1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZIXP1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:27:54 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:34590 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZIXP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:27:53 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: fixing "pci=use_crs"
Date: Thu, 24 Sep 2009 09:26:46 -0600
User-Agent: KMail/1.9.10
Cc: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <200909161715.24376.bjorn.helgaas@hp.com> <4AB95F41.1070500@lwfinger.net> <200909231723.31786.bjorn.helgaas@hp.com>
In-Reply-To: <200909231723.31786.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909240926.47674.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 September 2009 05:23:30 pm Bjorn Helgaas wrote:
> Would you mind trying the attached debug patch to try to confirm this?

Let me refine this patch a little before you try it out.  For
one thing, it applies on top of a bunch of patches in my queue,
so it won't apply directly for you.

> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 1014eb4..7c817f8 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -7,6 +7,7 @@
>  #include <asm/pci_x86.h>
>  
>  struct pci_root_info {
> +	struct acpi_device *device;
>  	char *name;
>  	unsigned int res_num;
>  	struct resource *res;
> @@ -77,6 +78,10 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
>  	if (!ACPI_SUCCESS(status))
>  		return AE_OK;
>  
> +	dev_info(&info->device->dev, "res %d addr %d min %#llx len %#llx tra %#llx\n",
> +		 acpi_res->type,
> +		 addr.resource_type, addr.minimum, addr.address_length,
> +		 addr.translation_offset);
>  	if (addr.resource_type == ACPI_MEMORY_RANGE) {
>  		root = &iomem_resource;
>  		flags = IORESOURCE_MEM;
> @@ -117,6 +122,8 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
>  	return AE_OK;
>  }
>  
> +#define STRUCT_TO_INT(s)        (*((int*)&s))
> +
>  static void
>  get_current_resources(struct acpi_device *device, int busnum,
>  			int domain, struct pci_bus *bus)
> @@ -124,6 +131,10 @@ get_current_resources(struct acpi_device *device, int busnum,
>  	struct pci_root_info info;
>  	size_t size;
>  
> +	dev_info(&device->dev, "getting resources (status 0x%x)\n",
> +		 STRUCT_TO_INT(device->status));
> +
> +	info.device = device;
>  	info.bus = bus;
>  	info.res_num = 0;
>  	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 31b961c..78a5fd6 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -461,6 +461,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>  	acpi_handle handle;
>  	struct acpi_device *child;
>  	u32 flags, base_flags;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>  
>  	segment = 0;
>  	status = acpi_evaluate_integer(device->handle, METHOD_NAME__SEG, NULL,
> @@ -508,9 +509,11 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>  	/* TBD: Locking */
>  	list_add_tail(&root->node, &acpi_pci_roots);
>  
> +	acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
>  	printk(KERN_INFO PREFIX "%s [%s] (%04x:%02x)\n",
> -	       acpi_device_name(device), acpi_device_bid(device),
> +	       acpi_device_name(device), (char *) buffer.pointer,
>  	       root->segment, root->bus_nr);
> +	kfree(buffer.pointer);
>  
>  	/*
>  	 * Scan the Root Bridge
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index 83b8b5a..3a0a93b 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -154,6 +154,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  	acpi_status status;
>  	struct pnp_dev *dev;
>  	struct acpi_hardware_id *id;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>  
>  	/*
>  	 * If a PnPacpi device is not present , the device
> @@ -205,7 +206,11 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  	/* clear out the damaged flags */
>  	if (!dev->active)
>  		pnp_init_resources(dev);
> +
> +	acpi_get_name(temp, ACPI_FULL_PATHNAME, &buffer);
> +	pnp_dbg(&dev->dev, "pnp device for [%s]\n", (char *) buffer.pointer);
>  	pnp_add_device(dev);
> +	kfree(buffer.pointer);
>  	num++;
>  
>  	return AE_OK;
> 


