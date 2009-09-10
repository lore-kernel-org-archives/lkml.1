Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbZIJBqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbZIJBqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZIJBqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:46:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43106 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZIJBqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:46:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AA85A6D.9040302@jp.fujitsu.com>
Date: Thu, 10 Sep 2009 10:46:21 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI Hotplug: convert acpi_pci_detect_ejectable()
 to take	an acpi_handle
References: <20090909204738.11037.26974.stgit@bob.kio> <20090909204935.11037.98403.stgit@bob.kio>
In-Reply-To: <20090909204935.11037.98403.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> acpi_pci_detect_ejectable() goes through effort to convert its
> struct pci_bus arg to an acpi_handle, but every time we use this
> interface, we already have the handle available.
> 
> So let's just use the handle instead of converting back and forth.
> 
> Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/hotplug/acpi_pcihp.c   |    9 +++------
>  drivers/pci/hotplug/acpiphp_glue.c |   33 +++++++++++----------------------
>  drivers/pci/hotplug/pciehp_acpi.c  |    5 +++--
>  include/linux/pci_hotplug.h        |    2 +-
>  4 files changed, 18 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> index eb15958..80af75c 100644
> --- a/drivers/pci/hotplug/acpi_pcihp.c
> +++ b/drivers/pci/hotplug/acpi_pcihp.c
> @@ -500,18 +500,15 @@ check_hotplug(acpi_handle handle, u32 lvl, void *context, void **rv)
>  
>  /**
>   * acpi_pci_detect_ejectable - check if the PCI bus has ejectable slots
> - * @pbus - PCI bus to scan
> + * @handle - handle of the PCI bus to scan
>   *
>   * Returns 1 if the PCI bus has ACPI based ejectable slots, 0 otherwise.
>   */
> -int acpi_pci_detect_ejectable(struct pci_bus *pbus)
> +int acpi_pci_detect_ejectable(acpi_handle handle)
>  {
> -	acpi_handle handle;
>  	int found = 0;
>  
> -	if (!(handle = acpi_pci_get_bridge_handle(pbus)))
> -		return 0;
> -	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,

I think we need NULL check here.

	if (!handle)
		return 0;

(snip.)

> diff --git a/drivers/pci/hotplug/pciehp_acpi.c b/drivers/pci/hotplug/pciehp_acpi.c
> index 9604801..0c6aa99 100644
> --- a/drivers/pci/hotplug/pciehp_acpi.c
> +++ b/drivers/pci/hotplug/pciehp_acpi.c
> @@ -47,7 +47,7 @@ int pciehp_acpi_slot_detection_check(struct pci_dev *dev)
>  {
>  	if (slot_detection_mode != PCIEHP_DETECT_ACPI)
>  		return 0;
> -	if (acpi_pci_detect_ejectable(dev->subordinate))
> +	if (acpi_pci_detect_ejectable(dev->dev.archdata.acpi_handle))
>  		return 0;

How about:

	handle = DEVICE_ACPI_HANDLE(&dev->dev);
	if (acpi_pci_detect_ejectable(handle))
		return 0;


>  	return -ENODEV;
>  }
> @@ -94,7 +94,8 @@ static int __init dummy_probe(struct pcie_device *dev)
>  			dup_slot_id++;
>  	}
>  	list_add_tail(&slot->slot_list, &dummy_slots);
> -	if (!acpi_slot_detected && acpi_pci_detect_ejectable(pbus))
> +	if (!acpi_slot_detected &&
> +		acpi_pci_detect_ejectable(pbus->self->dev.archdata.acpi_handle))
>  		acpi_slot_detected = 1;

How about:

	handle = DEVICE_ACPI_HANDLE(&pdev->dev);
	if (!acpi_slot_detected && acpi_pci_detect_ejectable(handle))

And the following line at the head of dummy_probe() seems no longer
needed.

	struct pci_bus *pbus = pdev->subordinate;

Thanks,
Kenji Kaneshige



