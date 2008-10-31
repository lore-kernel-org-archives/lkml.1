Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYJaH4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYJaH4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYJaHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:55:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48675 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYJaHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:55:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <490AB9ED.2060005@s5r6.in-berlin.de>
Date: Fri, 31 Oct 2008 08:55:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: firewire: struct device - replace bus_id with dev_name(),	dev_set_name()
References: <1225327316.5970.33.camel@nga.site>
In-Reply-To: <1225327316.5970.33.camel@nga.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".
> 
> To set and read the device name dev_name(dev) and dev_set_name(dev)
> must be used. If your code uses static kobjects, which it shouldn't
> do, "const char *init_name" can be used to statically provide the
> name the registered device should have. At registration time, the
> init_name field is cleared, to enforce the use of dev_name(dev) to
> access the device name at a later time.
> 
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.
> 
> We want to submit a patch to -next, which will remove bus_id from
> "struct device", to find the remaining pieces to convert, and finally
> switch over to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.
> 
> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: firewire: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> CC: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> ---

Committed to linux1394-2.6.git.  Thanks.

> 
> 
> diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
> index 3fccdd4..6b9be42 100644
> --- a/drivers/firewire/fw-device.c
> +++ b/drivers/firewire/fw-device.c
> @@ -587,8 +587,7 @@ static void create_units(struct fw_device *device)
>  		unit->device.bus = &fw_bus_type;
>  		unit->device.type = &fw_unit_type;
>  		unit->device.parent = &device->device;
> -		snprintf(unit->device.bus_id, sizeof(unit->device.bus_id),
> -			 "%s.%d", device->device.bus_id, i++);
> +		dev_set_name(&unit->device, "%s.%d", dev_name(&device->device), i++);
>  
>  		init_fw_attribute_group(&unit->device,
>  					fw_unit_attributes,
> @@ -711,8 +710,7 @@ static void fw_device_init(struct work_struct *work)
>  	device->device.type = &fw_device_type;
>  	device->device.parent = device->card->device;
>  	device->device.devt = MKDEV(fw_cdev_major, minor);
> -	snprintf(device->device.bus_id, sizeof(device->device.bus_id),
> -		 "fw%d", minor);
> +	dev_set_name(&device->device, "fw%d", minor);
>  
>  	init_fw_attribute_group(&device->device,
>  				fw_device_attributes,
> @@ -741,13 +739,13 @@ static void fw_device_init(struct work_struct *work)
>  		if (device->config_rom_retries)
>  			fw_notify("created device %s: GUID %08x%08x, S%d00, "
>  				  "%d config ROM retries\n",
> -				  device->device.bus_id,
> +				  dev_name(&device->device),
>  				  device->config_rom[3], device->config_rom[4],
>  				  1 << device->max_speed,
>  				  device->config_rom_retries);
>  		else
>  			fw_notify("created device %s: GUID %08x%08x, S%d00\n",
> -				  device->device.bus_id,
> +				  dev_name(&device->device),
>  				  device->config_rom[3], device->config_rom[4],
>  				  1 << device->max_speed);
>  		device->config_rom_retries = 0;
> @@ -883,12 +881,12 @@ static void fw_device_refresh(struct work_struct *work)
>  		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
>  		goto gone;
>  
> -	fw_notify("refreshed device %s\n", device->device.bus_id);
> +	fw_notify("refreshed device %s\n", dev_name(&device->device));
>  	device->config_rom_retries = 0;
>  	goto out;
>  
>   give_up:
> -	fw_notify("giving up on refresh of device %s\n", device->device.bus_id);
> +	fw_notify("giving up on refresh of device %s\n", dev_name(&device->device));
>   gone:
>  	atomic_set(&device->state, FW_DEVICE_SHUTDOWN);
>  	fw_device_shutdown(work);
> diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
> index 251416f..964c697 100644
> --- a/drivers/firewire/fw-ohci.c
> +++ b/drivers/firewire/fw-ohci.c
> @@ -2454,7 +2454,7 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
>  		goto fail_self_id;
>  
>  	fw_notify("Added fw-ohci device %s, OHCI version %x.%x\n",
> -		  dev->dev.bus_id, version >> 16, version & 0xff);
> +		  dev_name(&dev->dev), version >> 16, version & 0xff);
>  	return 0;
>  
>   fail_self_id:
> diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
> index ef0b9b4..0a87127 100644
> --- a/drivers/firewire/fw-sbp2.c
> +++ b/drivers/firewire/fw-sbp2.c
> @@ -1119,7 +1119,7 @@ static int sbp2_probe(struct device *dev)
>  	tgt->unit = unit;
>  	kref_init(&tgt->kref);
>  	INIT_LIST_HEAD(&tgt->lu_list);
> -	tgt->bus_id = unit->device.bus_id;
> +	tgt->bus_id = dev_name(&unit->device);
>  	tgt->guid = (u64)device->config_rom[3] << 32 | device->config_rom[4];
>  
>  	if (fw_device_enable_phys_dma(device) < 0)
> 
> 


-- 
Stefan Richter
-=====-==--- =-=- =====
http://arcgraph.de/sr/
