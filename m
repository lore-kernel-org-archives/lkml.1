Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZIBNc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZIBNc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZIBNc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:32:26 -0400
Received: from kroah.org ([198.145.64.141]:45591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZIBNcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:32:25 -0400
Date: Wed, 2 Sep 2009 06:30:20 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Shane Huang <Shane.Huang@amd.com>
Subject: Re: [PATCH] pci: separate out pci_add_dynid()
Message-ID: <20090902133020.GA25201@kroah.com>
References: <4A9E38FA.3000506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9E38FA.3000506@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 06:20:58PM +0900, Tejun Heo wrote:
> Separate out pci_add_dynid() from store_new_id() and export it so that
> in-kernel code can add PCI IDs dynamically.  As the function will be
> available regardless of HOTPLUG, put it and pull pci_free_dynids()
> outside of CONFIG_HOTPLUG.
> 
> This will be used by pci-stub to initialize initial IDs via module
> param.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/pci/pci-driver.c |  119 +++++++++++++++++++++++++++++------------------
>  include/linux/pci.h      |    5 +
>  2 files changed, 79 insertions(+), 45 deletions(-)
> 
> Index: ata/drivers/pci/pci-driver.c
> ===================================================================
> --- ata.orig/drivers/pci/pci-driver.c
> +++ ata/drivers/pci/pci-driver.c
> @@ -19,37 +19,98 @@
>  #include <linux/cpu.h>
>  #include "pci.h"
> 
> -/*
> - * Dynamic device IDs are disabled for !CONFIG_HOTPLUG
> - */
> -
>  struct pci_dynid {
>  	struct list_head node;
>  	struct pci_device_id id;
>  };
> 
> -#ifdef CONFIG_HOTPLUG
> +/**
> + * pci_add_dynid - add a new PCI device ID to this driver and re-probe devices
> + * @drv: target pci driver
> + * @vendor: PCI vendor ID
> + * @device: PCI device ID
> + * @subvendor: PCI subvendor ID
> + * @subdevice: PCI subdevice ID
> + * @class: PCI class
> + * @class_mask: PCI class mask
> + * @driver_data: private driver data
> + *
> + * Adds a new dynamic pci device ID to this driver and causes the
> + * driver to probe for all devices again.  @drv must have been
> + * registered prior to calling this function.
> + *
> + * CONTEXT:
> + * Does GFP_KERNEL allocation.
> + *
> + * RETURNS:
> + * 0 on success, -errno on failure.
> + */
> +int pci_add_dynid(struct pci_driver *drv,
> +		  unsigned int vendor, unsigned int device,
> +		  unsigned int subvendor, unsigned int subdevice,
> +		  unsigned int class, unsigned int class_mask,
> +		  unsigned long driver_data)
> +{
> +	struct pci_dynid *dynid;
> +	int retval;
> +
> +	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
> +	if (!dynid)
> +		return -ENOMEM;
> +
> +	dynid->id.vendor = vendor;
> +	dynid->id.device = device;
> +	dynid->id.subvendor = subvendor;
> +	dynid->id.subdevice = subdevice;
> +	dynid->id.class = class;
> +	dynid->id.class_mask = class_mask;
> +	dynid->id.driver_data = driver_data;
> 
> +	spin_lock(&drv->dynids.lock);
> +	list_add_tail(&dynid->node, &drv->dynids.list);
> +	spin_unlock(&drv->dynids.lock);
> +
> +	get_driver(&drv->driver);
> +	retval = driver_attach(&drv->driver);
> +	put_driver(&drv->driver);
> +
> +	return retval;
> +}
> +
> +static void pci_free_dynids(struct pci_driver *drv)
> +{
> +	struct pci_dynid *dynid, *n;
> +
> +	spin_lock(&drv->dynids.lock);
> +	list_for_each_entry_safe(dynid, n, &drv->dynids.list, node) {
> +		list_del(&dynid->node);
> +		kfree(dynid);
> +	}
> +	spin_unlock(&drv->dynids.lock);
> +}
> +
> +/*
> + * Dynamic device ID manipulation via sysfs is disabled for !CONFIG_HOTPLUG
> + */
> +#ifdef CONFIG_HOTPLUG
>  /**
> - * store_new_id - add a new PCI device ID to this driver and re-probe devices
> + * store_new_id - sysfs frontend to pci_add_dynid()
>   * @driver: target device driver
>   * @buf: buffer for scanning device ID data
>   * @count: input size
>   *
> - * Adds a new dynamic pci device ID to this driver,
> - * and causes the driver to probe for all devices again.
> + * Allow PCI IDs to be added to an existing driver via sysfs.
>   */
>  static ssize_t
>  store_new_id(struct device_driver *driver, const char *buf, size_t count)
>  {
> -	struct pci_dynid *dynid;
>  	struct pci_driver *pdrv = to_pci_driver(driver);
>  	const struct pci_device_id *ids = pdrv->id_table;
>  	__u32 vendor, device, subvendor=PCI_ANY_ID,
>  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
>  	unsigned long driver_data=0;
>  	int fields=0;
> -	int retval=0;
> +	int retval;
> 
>  	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
>  			&vendor, &device, &subvendor, &subdevice,
> @@ -72,27 +133,8 @@ store_new_id(struct device_driver *drive
>  			return retval;
>  	}
> 
> -	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
> -	if (!dynid)
> -		return -ENOMEM;
> -
> -	dynid->id.vendor = vendor;
> -	dynid->id.device = device;
> -	dynid->id.subvendor = subvendor;
> -	dynid->id.subdevice = subdevice;
> -	dynid->id.class = class;
> -	dynid->id.class_mask = class_mask;
> -	dynid->id.driver_data = driver_data;
> -
> -	spin_lock(&pdrv->dynids.lock);
> -	list_add_tail(&dynid->node, &pdrv->dynids.list);
> -	spin_unlock(&pdrv->dynids.lock);
> -
> -	if (get_driver(&pdrv->driver)) {
> -		retval = driver_attach(&pdrv->driver);
> -		put_driver(&pdrv->driver);
> -	}
> -
> +	retval = pci_add_dynid(pdrv, vendor, device, subvendor, subdevice,
> +			       class, class_mask, driver_data);
>  	if (retval)
>  		return retval;
>  	return count;
> @@ -145,19 +187,6 @@ store_remove_id(struct device_driver *dr
>  }
>  static DRIVER_ATTR(remove_id, S_IWUSR, NULL, store_remove_id);
> 
> -static void
> -pci_free_dynids(struct pci_driver *drv)
> -{
> -	struct pci_dynid *dynid, *n;
> -
> -	spin_lock(&drv->dynids.lock);
> -	list_for_each_entry_safe(dynid, n, &drv->dynids.list, node) {
> -		list_del(&dynid->node);
> -		kfree(dynid);
> -	}
> -	spin_unlock(&drv->dynids.lock);
> -}
> -
>  static int
>  pci_create_newid_file(struct pci_driver *drv)
>  {
> @@ -186,7 +215,6 @@ static void pci_remove_removeid_file(str
>  	driver_remove_file(&drv->driver, &driver_attr_remove_id);
>  }
>  #else /* !CONFIG_HOTPLUG */
> -static inline void pci_free_dynids(struct pci_driver *drv) {}
>  static inline int pci_create_newid_file(struct pci_driver *drv)
>  {
>  	return 0;
> @@ -1106,6 +1134,7 @@ static int __init pci_driver_init(void)
> 
>  postcore_initcall(pci_driver_init);
> 
> +EXPORT_SYMBOL(pci_add_dynid);

scripts/checkpatch.pl will complain about this :)

Care to mark it EXPORT_SYMBOL_GPL() please?

With that change, then feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
