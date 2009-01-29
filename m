Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZA2Heb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZA2Heb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZA2HeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:34:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60757 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZA2HeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:34:20 -0500
Message-ID: <49815BF6.7060402@jp.fujitsu.com>
Date: Thu, 29 Jan 2009 16:34:14 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
References: <m1pri623g9.fsf@fess.ebiederm.org>
In-Reply-To: <m1pri623g9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't understand what this patch is trying to fix. Could you
please tell me more about the problem?

And I have a worry. With this patch, the hotplug operation files
under /sys/bus/pci/slots/*/ directory will be created before the
interrupt is initialized. If hotplug operation is initiated (power
on/off, change attention indicator and so on) by user before
interrupt is initialized (though I think it's rare), command
completion event could not be handled. 

Thanks,
Kenji Kaneshige


Eric W. Biederman wrote:
> Move the enabling of interrupts after all of the data structures
> are setup so that we can safely run the interrupt handler as
> soon as it is registered.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  drivers/pci/hotplug/pciehp.h      |    2 ++
>  drivers/pci/hotplug/pciehp_core.c |    7 +++++++
>  drivers/pci/hotplug/pciehp_hpc.c  |   15 +++++++--------
>  3 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index db85284..39ae375 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -111,6 +111,7 @@ struct controller {
>  	int cmd_busy;
>  	unsigned int no_cmd_complete:1;
>  	unsigned int link_active_reporting:1;
> +	unsigned int notification_enabled:1;
>  };
>  
>  #define INT_BUTTON_IGNORE		0
> @@ -170,6 +171,7 @@ extern int pciehp_configure_device(struct slot *p_slot);
>  extern int pciehp_unconfigure_device(struct slot *p_slot);
>  extern void pciehp_queue_pushbutton_work(struct work_struct *work);
>  struct controller *pcie_init(struct pcie_device *dev);
> +int pcie_init_notification(struct controller *ctrl);
>  int pciehp_enable_slot(struct slot *p_slot);
>  int pciehp_disable_slot(struct slot *p_slot);
>  int pcie_enable_notification(struct controller *ctrl);
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index c248554..681e391 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -434,6 +434,13 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
>  		goto err_out_release_ctlr;
>  	}
>  
> +	/* Enable events after we have setup the data structures */
> +	rc = pcie_init_notification(ctrl);
> +	if (rc) {
> +		ctrl_err(ctrl, "Notification initialization failed\n");
> +		goto err_out_release_ctlr;
> +	}
> +
>  	/* Check if slot is occupied */
>  	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
>  	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index 71a8012..7a16c68 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -934,7 +934,7 @@ static void pcie_disable_notification(struct controller *ctrl)
>  		ctrl_warn(ctrl, "Cannot disable software notification\n");
>  }
>  
> -static int pcie_init_notification(struct controller *ctrl)
> +int pcie_init_notification(struct controller *ctrl)
>  {
>  	if (pciehp_request_irq(ctrl))
>  		return -1;
> @@ -942,13 +942,17 @@ static int pcie_init_notification(struct controller *ctrl)
>  		pciehp_free_irq(ctrl);
>  		return -1;
>  	}
> +	ctrl->notification_enabled = 1;
>  	return 0;
>  }
>  
>  static void pcie_shutdown_notification(struct controller *ctrl)
>  {
> -	pcie_disable_notification(ctrl);
> -	pciehp_free_irq(ctrl);
> +	if (ctrl->notification_enabled) {
> +		pcie_disable_notification(ctrl);
> +		pciehp_free_irq(ctrl);
> +		ctrl->notification_enabled = 0;
> +	}
>  }
>  
>  static int pcie_init_slot(struct controller *ctrl)
> @@ -1110,13 +1114,8 @@ struct controller *pcie_init(struct pcie_device *dev)
>  	if (pcie_init_slot(ctrl))
>  		goto abort_ctrl;
>  
> -	if (pcie_init_notification(ctrl))
> -		goto abort_slot;
> -
>  	return ctrl;
>  
> -abort_slot:
> -	pcie_cleanup_slot(ctrl);
>  abort_ctrl:
>  	kfree(ctrl);
>  abort:


