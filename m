Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbZCaFAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbZCaFAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZCaFA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:00:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57329 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZCaFA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:00:28 -0400
Message-ID: <49D1A35B.5080305@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 14:00:11 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH v2 3/3] PCI: pci_slot: grab refcount on slot's bus
References: <20090330164737.18855.7137.stgit@bob.kio> <20090330165019.18855.69386.stgit@bob.kio>
In-Reply-To: <20090330165019.18855.69386.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I confirmed this patch fix the kernel oops problem I reported.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

By the way, /sys/bus/pci/slots/<slot> directory by pci_slot are
remaining even after the parent bridge/bus of the slots are
removed. At this point, pci_slot is working with struct pci_bus
for the already disabled pci bus. This might cause something
problem. So I think we also need something mechanism to
unregister slots by pci_slot when the parent bus is removed.

Thanks,
Kenji Kaneshige


Alex Chiang wrote:
> If a logical hot unplug (remove) is performed on a physical PCI slot's
> parent bridge, and then pci_slot is unloaded, we will encounter an oops:
> 
>   [<ffffffff803a788a>] kobject_release+0x9a/0x290
>   [<ffffffff803a77f0>] ? kobject_release+0x0/0x290
>   [<ffffffff803a8ce7>] kref_put+0x37/0x80
>   [<ffffffff803a76f7>] kobject_put+0x27/0x60
>   [<ffffffff803bebcc>] ? pci_destroy_slot+0x3c/0xc0
>   [<ffffffff803bebd5>] pci_destroy_slot+0x45/0xc0
>   [<ffffffffa000f05c>] acpi_pci_slot_remove+0x5c/0x91 [pci_slot]
>   [<ffffffff8040064b>] acpi_pci_unregister_driver+0x4b/0x62
>   [<ffffffffa000f5c8>] acpi_pci_slot_exit+0x10/0x12 [pci_slot]
>   [<ffffffff80276ce1>] sys_delete_module+0x161/0x250
> 
> We need to grab a reference to the parent PCI bus, which will pin
> the bus and prevent it from being released until pci_slot is unloaded.
> 
> Cc: lenb@kernel.org
> Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/acpi/pci_slot.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
> index cd1f446..12158e0 100644
> --- a/drivers/acpi/pci_slot.c
> +++ b/drivers/acpi/pci_slot.c
> @@ -164,6 +164,8 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	list_add(&slot->list, &slot_list);
>  	mutex_unlock(&slot_list_lock);
>  
> +	get_device(&pci_bus->dev);
> +
>  	dbg("pci_slot: %p, pci_bus: %x, device: %d, name: %s\n",
>  		pci_slot, pci_bus->number, device, name);
>  
> @@ -310,12 +312,15 @@ static void
>  acpi_pci_slot_remove(acpi_handle handle)
>  {
>  	struct acpi_pci_slot *slot, *tmp;
> +	struct pci_bus *pbus;
>  
>  	mutex_lock(&slot_list_lock);
>  	list_for_each_entry_safe(slot, tmp, &slot_list, list) {
>  		if (slot->root_handle == handle) {
>  			list_del(&slot->list);
> +			pbus = slot->pci_slot->bus;
>  			pci_destroy_slot(slot->pci_slot);
> +			put_device(&pbus->dev);
>  			kfree(slot);
>  		}
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


