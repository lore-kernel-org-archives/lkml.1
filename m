Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZBGFis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZBGFis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 00:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZBGFij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 00:38:39 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:20527 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZBGFih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 00:38:37 -0500
Date: Sat, 07 Feb 2009 00:38:32 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, shaohuhua.li@intel.com,
       kristen.c.accardi@intel.com, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv2] ACPI: add missing KERN_* constants to printks
In-reply-to: <4989BC3B.2070508@suse.de>
Message-id: <alpine.LFD.2.00.0902070022160.26256@localhost.localdomain>
References: <4989A784.3030604@suse.de> <4989BC3B.2070508@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied -- though I changed the two in acpi_os_vprintf()
to be KERN_CONT, or we'd get a bunch of <4>'s in
constructed messages.  Yes, we take our chances with SMP on those.

thanks,
Len Brown, Intel Open Source Technology Center

On Wed, 4 Feb 2009, Frank Seidel wrote:

> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing peaces here for the acpi subsystem.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/acpi/container.c |    5 +++--
>  drivers/acpi/dock.c      |    8 ++++----
>  drivers/acpi/osl.c       |    4 ++--
>  drivers/acpi/pci_link.c  |    2 +-
>  drivers/acpi/sleep.c     |    2 +-
>  drivers/acpi/video.c     |    2 +-
>  6 files changed, 12 insertions(+), 11 deletions(-)
> 
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -1260,7 +1260,7 @@ static int acpi_video_bus_POST_info_seq_
>  			printk(KERN_WARNING PREFIX
>  			       "This indicates a BIOS bug. Please contact the manufacturer.\n");
>  		}
> -		printk("%llx\n", options);
> +		printk(KERN_WARNING "%llx\n", options);
>  		seq_printf(seq, "can POST: <integrated video>");
>  		if (options & 2)
>  			seq_printf(seq, " <PCI video>");
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -163,7 +163,7 @@ static void container_notify_cb(acpi_han
>  	case ACPI_NOTIFY_BUS_CHECK:
>  		/* Fall through */
>  	case ACPI_NOTIFY_DEVICE_CHECK:
> -		printk("Container driver received %s event\n",
> +		printk(KERN_WARNING "Container driver received %s event\n",
>  		       (type == ACPI_NOTIFY_BUS_CHECK) ?
>  		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
>  		status = acpi_bus_get_device(handle, &device);
> @@ -174,7 +174,8 @@ static void container_notify_cb(acpi_han
>  					kobject_uevent(&device->dev.kobj,
>  						       KOBJ_ONLINE);
>  				else
> -					printk("Failed to add container\n");
> +					printk(KERN_WARNING
> +					       "Failed to add container\n");
>  			}
>  		} else {
>  			if (ACPI_SUCCESS(status)) {
> --- a/drivers/acpi/pci_link.c
> +++ b/drivers/acpi/pci_link.c
> @@ -593,7 +593,7 @@ static int acpi_pci_link_allocate(struct
>  		return -ENODEV;
>  	} else {
>  		acpi_irq_penalty[link->irq.active] += PIRQ_PENALTY_PCI_USING;
> -		printk(PREFIX "%s [%s] enabled at IRQ %d\n",
> +		printk(KERN_WARNING PREFIX "%s [%s] enabled at IRQ %d\n",
>  		       acpi_device_name(link->device),
>  		       acpi_device_bid(link->device), link->irq.active);
>  	}
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -984,7 +984,7 @@ static int dock_add(acpi_handle handle)
>  
>  	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
>  	if (ret) {
> -		printk("Error %d adding sysfs file\n", ret);
> +		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
>  		platform_device_unregister(dock_device);
>  		kfree(dock_station);
>  		dock_station = NULL;
> @@ -992,7 +992,7 @@ static int dock_add(acpi_handle handle)
>  	}
>  	ret = device_create_file(&dock_device->dev, &dev_attr_undock);
>  	if (ret) {
> -		printk("Error %d adding sysfs file\n", ret);
> +		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
>  		device_remove_file(&dock_device->dev, &dev_attr_docked);
>  		platform_device_unregister(dock_device);
>  		kfree(dock_station);
> @@ -1001,7 +1001,7 @@ static int dock_add(acpi_handle handle)
>  	}
>  	ret = device_create_file(&dock_device->dev, &dev_attr_uid);
>  	if (ret) {
> -		printk("Error %d adding sysfs file\n", ret);
> +		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
>  		device_remove_file(&dock_device->dev, &dev_attr_docked);
>  		device_remove_file(&dock_device->dev, &dev_attr_undock);
>  		platform_device_unregister(dock_device);
> @@ -1011,7 +1011,7 @@ static int dock_add(acpi_handle handle)
>  	}
>  	ret = device_create_file(&dock_device->dev, &dev_attr_flags);
>  	if (ret) {
> -		printk("Error %d adding sysfs file\n", ret);
> +		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
>  		device_remove_file(&dock_device->dev, &dev_attr_docked);
>  		device_remove_file(&dock_device->dev, &dev_attr_undock);
>  		device_remove_file(&dock_device->dev, &dev_attr_uid);
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -228,10 +228,10 @@ void acpi_os_vprintf(const char *fmt, va
>  	if (acpi_in_debugger) {
>  		kdb_printf("%s", buffer);
>  	} else {
> -		printk("%s", buffer);
> +		printk(KERN_WARNING "%s", buffer);
>  	}
>  #else
> -	printk("%s", buffer);
> +	printk(KERN_WARNING "%s", buffer);
>  #endif
>  }
>  
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -679,7 +679,7 @@ static void acpi_power_off_prepare(void)
>  static void acpi_power_off(void)
>  {
>  	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
> -	printk("%s called\n", __func__);
> +	printk(KERN_DEBUG "%s called\n", __func__);
>  	local_irq_disable();
>  	acpi_enable_wakeup_device(ACPI_STATE_S5);
>  	acpi_enter_sleep_state(ACPI_STATE_S5);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
