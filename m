Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZGAEeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZGAEeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZGAEeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:34:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37463 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZGAEef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:34:35 -0400
Message-ID: <4A4AE73A.7050907@jp.fujitsu.com>
Date: Wed, 01 Jul 2009 13:34:02 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: kristen.c.accardi@intel.com, linux-pci@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pciehp resume handler - racy?
References: <4A4A3697.7020804@tuffmail.co.uk>
In-Reply-To: <4A4A3697.7020804@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Hi,
> 
> I've been hacking on the PCI hotplug driver otherwise known as
> eeepc-laptop.  At one point I reliably triggered a race on resume.  In
> the hot-unplug case, it seemed that the resume handler would try to
> remove the PCI device at the same time as an acpi notification (run in a
> workqueue) tried to do the same thing.  The result was an OOPS.  My
> conclusion is that the PCI hotplug core does not protect against
> multiple simultaneous removals of the same device.

Though I don't know hotplug driver for eeepc-laptop at all, I guess
it doesn't use pci_hp_register(), which is for registering a hotplug
slot to pci hotplug core. The pci_hp_register() prevents a hot-plug
slot from being managed by multiple hotplug controller drivers at
the same time. Using pci_hp_register() would be one of the solution
for eeepc-laptop hotplug driver.

> 
> pciehp appears to have an analogous problem.  Assuming pciehp_force is
> set, the resume handler can hot-unplug the device.  The interrupt
> handler could try to hot-unplug the device at the same time.  Should the
> resume handler take the slot mutex to avoid this problem?
> 

Hot-plug operations for the same hotplug slot are serialized by
crit_sect mutex of struct controller in pciehp_enable_slot() and
pciehp_disable_slot(). So I don't think multiple hot-plug
operations for the same slot would be executed at the same time.

Thanks,
Kenji Kaneshige


> diff --faked-up a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -382,15 +382,18 @@ static int pciehp_resume (struct pcie_device *dev)
>  		/* reinitialize the chipset's event detection logic */
>  		pcie_enable_notification(ctrl);
>  
>  		t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
> +		mutex_lock(&t_slot->lock);
>  
>  		/* Check if slot is occupied */
>  		t_slot->hpc_ops->get_adapter_status(t_slot, &status);
>  		if (status)
>  			pciehp_enable_slot(t_slot);
>  		else
>  			pciehp_disable_slot(t_slot);
> +
> +		mutex_unlock(&t_slot->lock);
>  	}
>  	return 0;
>  }
>  #endif /* PM */
> 
> 
> Regards
> Alan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


