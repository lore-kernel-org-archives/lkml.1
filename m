Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZCaEiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZCaEiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZCaEiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:38:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57005 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZCaEiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:38:00 -0400
Message-ID: <49D19E1A.1040305@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 13:37:46 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] PCI Hotplug: acpiphp: grab refcount on p2p subordinate
 bus
References: <20090330164737.18855.7137.stgit@bob.kio> <20090330165014.18855.67275.stgit@bob.kio>
In-Reply-To: <20090330165014.18855.67275.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I confirmed this patch fix the kernel oops problem I reported.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

By the way, /sys/bus/pci/slots/<slot> directory by acpiphp are
remaining even after the parent bridge/bus of the slots are
removed. At this point, acpiphp is working with struct pci_bus
for the already disabled pci bus. I guess some operation against
the files under /sys/bus/pci/slots/<slot> directory would cause
something problems. So I think we also need something mechanism
to unregister acpiphp slots when the parent bus is removed.

Thanks,
Kenji Kaneshige


Alex Chiang wrote:
> If a logical hot unplug (remove) is performed on a bridge claimed
> by acpiphp and then acpiphp is unloaded, we will encounter an oops.
> 
> This is because acpiphp will access the bridge's subordinate bus,
> which was released by the user's prior hot unplug.
> 
> The solution is to grab a reference on the subordinate PCI bus.
> This will prevent the bus from release until acpiphp is unloaded.
> 
> Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 803d9dd..a33794d 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -38,6 +38,8 @@
>   *  - The one in acpiphp_bridge has its refcount elevated by pci_get_slot()
>   *    when the bridge is scanned and it loses a refcount when the bridge
>   *    is removed.
> + *  - When a P2P bridge is present, we elevate the refcount on the subordinate
> + *    bus. It loses the refcount when the the driver unloads.
>   */
>  
>  #include <linux/init.h>
> @@ -440,6 +442,12 @@ static void add_p2p_bridge(acpi_handle *handle, struct pci_dev *pci_dev)
>  		goto err;
>  	}
>  
> +	/*
> +	 * Grab a ref to the subordinate PCI bus in case the bus is
> +	 * removed via PCI core logical hotplug. The ref pins the bus
> +	 * (which we access during module unload).
> +	 */
> +	get_device(&bridge->pci_bus->dev);
>  	spin_lock_init(&bridge->res_lock);
>  
>  	init_bridge_misc(bridge);
> @@ -619,6 +627,12 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
>  		slot = next;
>  	}
>  
> +	/*
> +	 * Only P2P bridges have a pci_dev
> +	 */
> +	if (bridge->pci_dev)
> +		put_device(&bridge->pci_bus->dev);
> +
>  	pci_dev_put(bridge->pci_dev);
>  	list_del(&bridge->list);
>  	kfree(bridge);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


