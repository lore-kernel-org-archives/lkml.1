Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab0CIBRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:17:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50344 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab0CIBRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:17:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B95A171.5000207@jp.fujitsu.com>
Date: Tue, 09 Mar 2010 10:16:33 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, willy@linux.intel.com
Subject: Re: [PATCH] PCI: create function symlinks in /sys/bus/pci/slots/N/
References: <20100308172429.GA20953@ldl.fc.hp.com>
In-Reply-To: <20100308172429.GA20953@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Create convenience symlinks in sysfs, linking slots to device
> functions, and vice versa. These links make it easier for users to
> figure out which devices actually live in what slots.
> 
> For example:
> 
> sapphire:/sys/bus/pci/slots # ls
> 1  10  2  3  4  5  6  7  8  9
> 
> sapphire:/sys/bus/pci/slots # ls -l 3
> total 0
> -r--r--r-- 1 root root 65536 Aug 18 14:10 address
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 ->
> ../../../../devices/pci0000:23/0000:23:01.0
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 ->
> ../../../../devices/pci0000:23/0000:23:01.1
>

I usually get the similar information like the followings. Is it not enough
for you?

# /sbin/lspci -s `cat /sys/bus/pci/slots/1/address`
40:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
40:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)

 
> sapphire:/sys/bus/pci/slots # ls -l 3/function0/slot
> lrwxrwxrwx 1 root root 0 Aug 18 14:13 3/function0/slot ->
> ../../../bus/pci/slots/3

IIRC, the latest 'lspci' command shows physical slot information (you added
this useful feature, didn't you?). Is it not enough for you?

Thanks,
Kenji Kaneshige



> 
> The original form of this patch was written by Matthew Wilcox,
> and was enhanced to include links from the sysfs slots/ directory
> pointing back at the device functions.
> 
> Cc: willy@linux.intel.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> Not sure why I've been sitting on this patch for so long, but
> I think it would be a useful thing to have upstream.
> 
>  Documentation/ABI/testing/sysfs-bus-pci |   40 ++++++++++++++++++++++++++
>  drivers/pci/pci-sysfs.c                 |   37 ++++++++++++++++++++++++
>  drivers/pci/slot.c                      |   48 ++++++++++++++++++++++++++++++++
>  3 files changed, 125 insertions(+)
> ---
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 25be325..428676c 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -133,6 +133,46 @@ Description:
>  		The symbolic link points to the PCI device sysfs entry of the
>  		Physical Function this device associates with.
>  
> +
> +What:		/sys/bus/pci/slots/...
> +Date:		April 2005 (possibly older)
> +KernelVersion:	2.6.12 (possibly older)
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		When the appropriate driver is loaded, it will create a
> +		directory per claimed physical PCI slot in
> +		/sys/bus/pci/slots/.  The names of these directories are
> +		specific to the driver, which in turn, are specific to the
> +		platform, but in general, should match the label on the
> +		machine's physical chassis.
> +
> +		The drivers that can create slot directories include the
> +		PCI hotplug drivers, and as of 2.6.27, the pci_slot driver.
> +
> +		The slot directories contain, at a minimum, a file named
> +		'address' which contains the PCI bus:device:function tuple.
> +		Other files may appear as well, but are specific to the
> +		driver.
> +
> +What:		/sys/bus/pci/slots/.../function[0-7]
> +Date:		March 2010
> +KernelVersion:	2.6.35
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		If PCI slot directories (as described above) are created,
> +		and the physical slot is actually populated with a device,
> +		symbolic links in the slot directory pointing to the
> +		device's PCI functions are created as well.
> +
> +What:		/sys/bus/pci/devices/.../slot
> +Date:		March 2010
> +KernelVersion:	2.6.35
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		If PCI slot directories (as described above) are created,
> +		a symbolic link pointing to the slot directory will be
> +		created as well.
> +
>  What:		/sys/bus/pci/slots/.../module
>  Date:		June 2009
>  Contact:	linux-pci@vger.kernel.org
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 807224e..d234234 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1006,6 +1006,39 @@ error:
>  	return retval;
>  }
>  
> +static void pci_remove_slot_links(struct pci_dev *dev)
> +{
> +	char func[10];
> +	struct pci_slot *slot;
> +
> +	sysfs_remove_link(&dev->dev.kobj, "slot");
> +	list_for_each_entry(slot, &dev->bus->slots, list) {
> +		if (slot->number != PCI_SLOT(dev->devfn))
> +			continue;
> +		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
> +		sysfs_remove_link(&slot->kobj, func);
> +	}
> +}
> +
> +static int pci_create_slot_links(struct pci_dev *dev)
> +{
> +	int result = 0;
> +	char func[10];
> +	struct pci_slot *slot;
> +
> +	list_for_each_entry(slot, &dev->bus->slots, list) {
> +		if (slot->number != PCI_SLOT(dev->devfn))
> +			continue;
> +		result = sysfs_create_link(&dev->dev.kobj, &slot->kobj, "slot");
> +		if (result)
> +			goto out;
> +		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
> +		result = sysfs_create_link(&slot->kobj, &dev->dev.kobj, func);
> +	}
> +out:
> +	return result;
> +}
> +
>  int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
>  {
>  	int retval;
> @@ -1067,6 +1100,8 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
>  	if (retval)
>  		goto err_vga_file;
>  
> +	pci_create_slot_links(pdev);
> +
>  	return 0;
>  
>  err_vga_file:
> @@ -1116,6 +1151,8 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
>  	if (!sysfs_initialized)
>  		return;
>  
> +	pci_remove_slot_links(pdev);
> +
>  	pci_remove_capabilities_sysfs(pdev);
>  
>  	if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> index 49c9e6c..a8e22c6 100644
> --- a/drivers/pci/slot.c
> +++ b/drivers/pci/slot.c
> @@ -96,6 +96,50 @@ static ssize_t cur_speed_read_file(struct pci_slot *slot, char *buf)
>  	return bus_speed_read(slot->bus->cur_bus_speed, buf);
>  }
>  
> +static void remove_sysfs_files(struct pci_slot *slot)
> +{
> +	char func[10];
> +	struct list_head *tmp;
> +
> +	list_for_each(tmp, &slot->bus->devices) {
> +		struct pci_dev *dev = pci_dev_b(tmp);
> +		if (PCI_SLOT(dev->devfn) != slot->number)
> +			continue;
> +		sysfs_remove_link(&dev->dev.kobj, "slot");
> +
> +		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
> +		sysfs_remove_link(&slot->kobj, func);
> +	}
> +}
> +
> +static int create_sysfs_files(struct pci_slot *slot)
> +{
> +	int result;
> +	char func[10];
> +	struct list_head *tmp;
> +
> +	list_for_each(tmp, &slot->bus->devices) {
> +		struct pci_dev *dev = pci_dev_b(tmp);
> +		if (PCI_SLOT(dev->devfn) != slot->number)
> +			continue;
> +
> +		result = sysfs_create_link(&dev->dev.kobj, &slot->kobj, "slot");
> +		if (result)
> +			goto fail;
> +
> +		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
> +		result = sysfs_create_link(&slot->kobj, &dev->dev.kobj, func);
> +		if (result)
> +			goto fail;
> +	}
> +
> +	return 0;
> +
> +fail:
> +	remove_sysfs_files(slot);
> +	return result;
> +}
> +
>  static void pci_slot_release(struct kobject *kobj)
>  {
>  	struct pci_dev *dev;
> @@ -108,6 +152,8 @@ static void pci_slot_release(struct kobject *kobj)
>  		if (PCI_SLOT(dev->devfn) == slot->number)
>  			dev->slot = NULL;
>  
> +	remove_sysfs_files(slot);
> +
>  	list_del(&slot->list);
>  
>  	kfree(slot);
> @@ -299,6 +345,8 @@ placeholder:
>  	INIT_LIST_HEAD(&slot->list);
>  	list_add(&slot->list, &parent->slots);
>  
> +	create_sysfs_files(slot);
> +
>  	list_for_each_entry(dev, &parent->devices, bus_list)
>  		if (PCI_SLOT(dev->devfn) == slot_nr)
>  			dev->slot = slot;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


