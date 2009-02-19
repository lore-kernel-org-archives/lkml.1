Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZBSUEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZBSUEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbZBSUEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:04:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbZBSUEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:04:34 -0500
Date: Thu, 19 Feb 2009 12:03:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove
Message-Id: <20090219120333.af992d9e.akpm@linux-foundation.org>
In-Reply-To: <m1ocx5ve8o.fsf@fess.ebiederm.org>
References: <m1ocx5ve8o.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 20:23:03 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> pcie_port_device_remove currently calls the remove method
> of port drivers twice.  Ouch!
> 
> We don't get the correct interrupt mode unless there is a port device
> present.
> 
> We are calling device_for_each_child multiple times for no apparent
> reason.
> 
> So make it simple.  Use pcie_port_driver_ext so we always properly
> know the interrupt mode the we placed the pci device in.  Place
> put_device and device_unregister into remove_iter, and throw out the
> rest.  Only call device_for_each_child once.
> 
> The code is simpler and actually works!
> 

What's happening with this?

> 
> ---
>  drivers/pci/pcie/portdrv_core.c |   31 +++++++------------------------
>  1 files changed, 7 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 8b3f8c1..c642828 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -326,16 +326,9 @@ int pcie_port_device_resume(struct pci_dev *dev)
>  
>  static int remove_iter(struct device *dev, void *data)
>  {
> -	struct pcie_port_service_driver *service_driver;
> -
>  	if (dev->bus == &pcie_port_bus_type) {
> -		if (dev->driver) {
> -			service_driver = to_service_driver(dev->driver);
> -			if (service_driver->remove)
> -				service_driver->remove(to_pcie_device(dev));
> -		}
> -		*(unsigned long*)data = (unsigned long)dev;
> -		return 1;
> +		put_device(dev);
> +		device_unregister(dev);
>  	}
>  	return 0;
>  }
> @@ -349,24 +342,14 @@ static int remove_iter(struct device *dev, void *data)
>   */
>  void pcie_port_device_remove(struct pci_dev *dev)
>  {
> -	struct device *device;
> -	unsigned long device_addr;
> -	int interrupt_mode = PCIE_PORT_INTx_MODE;
> -	int status;
> +	struct pcie_port_device_ext *p_ext = pci_get_drvdata(dev);
> +
> +	device_for_each_child(&dev->dev, NULL, remove_iter);
>  
> -	do {
> -		status = device_for_each_child(&dev->dev, &device_addr, remove_iter);
> -		if (status) {
> -			device = (struct device*)device_addr;
> -			interrupt_mode = (to_pcie_device(device))->interrupt_mode;
> -			put_device(device);
> -			device_unregister(device);
> -		}
> -	} while (status);
>  	/* Switch to INTx by default if MSI enabled */
> -	if (interrupt_mode == PCIE_PORT_MSIX_MODE)
> +	if (p_ext->interrupt_mode == PCIE_PORT_MSIX_MODE)
>  		pci_disable_msix(dev);
> -	else if (interrupt_mode == PCIE_PORT_MSI_MODE)
> +	else if (p_ext->interrupt_mode == PCIE_PORT_MSI_MODE)
>  		pci_disable_msi(dev);
>  }
>  

There are large-scale and conflicting changes to this file in linux-next.

If we want to jam this fix into 2.6.29 (and it looks like something we
want) then this will trash the linux-next changes.  It will cause me
grief, and will cause Stephen grief unless the pci tree is suitably
changed, which will cause Jesse grief. Either way: grief.

