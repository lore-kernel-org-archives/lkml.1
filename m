Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXKRMGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXKRMGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 07:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXKRMGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 07:06:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbXKRMG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 07:06:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] Fix PCIe double initialization bug
Date: Sun, 18 Nov 2007 13:23:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kristen.c.accardi@intel.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
References: <4716CB9D.6080503@rtr.ca> <473F86E7.4020003@rtr.ca>
In-Reply-To: <473F86E7.4020003@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181323.52679.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of November 2007, Mark Lord wrote:
> pciehp_fix_double_init_bug.patch:
> 
> Earlier patches to split out the hardware init for PCIe hotplug
> resulted in some one-time initializations being redone on every
> resume cycle.  Eg. irq/polling initialization.
> 
> This patch splits the hardware init into two parts,
> and separates the one-time initializations from those
> so that they only ever get done once, as intended.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Which kernel is it against?

> ---
> 
> This patch is for -mm and for Kristen's queue.  Not for 2.6.24.
> 
>  drivers/pci/hotplug/pciehp.h      |    2
>  drivers/pci/hotplug/pciehp_core.c |    2
>  drivers/pci/hotplug/pciehp_hpc.c  |  119 +++++++++++++++-------------
>  3 files changed, 69 insertions(+), 54 deletions(-)
> 
> --- linux/drivers/pci/hotplug/pciehp.h.orig	2007-11-13 23:57:09.000000000 -0500
> +++ linux/drivers/pci/hotplug/pciehp.h	2007-11-17 19:10:01.000000000 -0500
> @@ -163,7 +163,7 @@
>  int pcie_init(struct controller *ctrl, struct pcie_device *dev);
>  int pciehp_enable_slot(struct slot *p_slot);
>  int pciehp_disable_slot(struct slot *p_slot);
> -int pcie_init_hardware(struct controller *ctrl, struct pcie_device *dev);
> +int pcie_init_hardware_part2(struct controller *ctrl, struct pcie_device *dev);
>  
>  static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
>  {
> --- linux/drivers/pci/hotplug/pciehp_core.c.orig	2007-11-13 23:57:09.000000000 -0500
> +++ linux/drivers/pci/hotplug/pciehp_core.c	2007-11-17 19:09:43.000000000 -0500
> @@ -521,7 +521,7 @@
>  		u8 status;
>  
>  		/* reinitialize the chipset's event detection logic */
> -		pcie_init_hardware(ctrl, dev);
> +		pcie_init_hardware_part2(ctrl, dev);
>  
>  		t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
>  
> --- linux/drivers/pci/hotplug/pciehp_hpc.c.orig	2007-11-13 23:57:09.000000000 -0500
> +++ linux/drivers/pci/hotplug/pciehp_hpc.c	2007-11-17 19:13:49.000000000 -0500
> @@ -1067,28 +1067,25 @@
>  }
>  #endif
>  
> -int pcie_init_hardware(struct controller *ctrl, struct pcie_device *dev)
> +static int pcie_init_hardware_part1(struct controller *ctrl,
> +				    struct pcie_device *dev)
>  {
>  	int rc;
>  	u16 temp_word;
> -	u16 intr_enable = 0;
>  	u32 slot_cap;
>  	u16 slot_status;
> -	struct pci_dev *pdev;
> -
> -	pdev = dev->port;
>  
>  	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
>  	if (rc) {
>  		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
> -		goto abort_free_ctlr;
> +		return -1;
>  	}
>  
>  	/* Mask Hot-plug Interrupt Enable */
>  	rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
>  	if (rc) {
>  		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
> -		goto abort_free_ctlr;
> +		return -1;
>  	}
>  
>  	dbg("%s: SLOTCTRL %x value read %x\n",
> @@ -1099,62 +1096,46 @@
>  	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
>  	if (rc) {
>  		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
> -		goto abort_free_ctlr;
> +		return -1;
>  	}
>  
>  	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
>  	if (rc) {
>  		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
> -		goto abort_free_ctlr;
> +		return -1;
>  	}
>  
>  	temp_word = 0x1F; /* Clear all events */
>  	rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
>  	if (rc) {
>  		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
> -		goto abort_free_ctlr;
> +		return -1;
>  	}
> +	return 0;
> +}
>  
> -	if (pciehp_poll_mode) {
> -		/* Install interrupt polling timer. Start with 10 sec delay */
> -		init_timer(&ctrl->poll_timer);
> -		start_int_poll_timer(ctrl, 10);
> -	} else {
> -		/* Installs the interrupt handler */
> -		rc = request_irq(ctrl->pci_dev->irq, pcie_isr, IRQF_SHARED,
> -				 MY_NAME, (void *)ctrl);
> -		dbg("%s: request_irq %d for hpc%d (returns %d)\n",
> -		    __FUNCTION__, ctrl->pci_dev->irq,
> -		    atomic_read(&pciehp_num_controllers), rc);
> -		if (rc) {
> -			err("Can't get irq %d for the hotplug controller\n",
> -			    ctrl->pci_dev->irq);
> -			goto abort_free_ctlr;
> -		}
> -	}
> -	dbg("pciehp ctrl b:d:f:irq=0x%x:%x:%x:%x\n", pdev->bus->number,
> -		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn), dev->irq);
> -
> -	/*
> -	 * If this is the first controller to be initialized,
> -	 * initialize the pciehp work queue
> -	 */
> -	if (atomic_add_return(1, &pciehp_num_controllers) == 1) {
> -		pciehp_wq = create_singlethread_workqueue("pciehpd");
> -		if (!pciehp_wq) {
> -			rc = -ENOMEM;
> -			goto abort_free_irq;
> -		}
> -	}
> +int pcie_init_hardware_part2(struct controller *ctrl, struct pcie_device *dev)
> +{
> +	int rc;
> +	u16 temp_word;
> +	u16 intr_enable = 0;
> +	u32 slot_cap;
> +	u16 slot_status;
>  
>  	rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
>  	if (rc) {
>  		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
> -		goto abort_free_irq;
> +		goto abort;
>  	}
>  
>  	intr_enable = intr_enable | PRSN_DETECT_ENABLE;
>  
> +	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
> +	if (rc) {
> +		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
> +		goto abort;
> +	}
> +
>  	if (ATTN_BUTTN(slot_cap))
>  		intr_enable = intr_enable | ATTN_BUTTN_ENABLE;
>  
> @@ -1179,7 +1160,7 @@
>  	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
>  	if (rc) {
>  		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
> -		goto abort_free_irq;
> +		goto abort;
>  	}
>  	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
>  	if (rc) {
> @@ -1214,14 +1195,7 @@
>  	}
>  	if (rc)
>  		err("%s : disabling interrupts failed\n", __FUNCTION__);
> -
> -abort_free_irq:
> -	if (pciehp_poll_mode)
> -		del_timer_sync(&ctrl->poll_timer);
> -	else
> -		free_irq(ctrl->pci_dev->irq, ctrl);
> -
> -abort_free_ctlr:
> +abort:
>  	return -1;
>  }
>  
> @@ -1318,11 +1292,52 @@
>  	ctrl->first_slot = slot_cap >> 19;
>  	ctrl->ctrlcap = slot_cap & 0x0000007f;
>  
> -	rc = pcie_init_hardware(ctrl, dev);
> +	rc = pcie_init_hardware_part1(ctrl, dev);
> +	if (rc)
> +		goto abort;
> +
> +	if (pciehp_poll_mode) {
> +		/* Install interrupt polling timer. Start with 10 sec delay */
> +		init_timer(&ctrl->poll_timer);
> +		start_int_poll_timer(ctrl, 10);
> +	} else {
> +		/* Installs the interrupt handler */
> +		rc = request_irq(ctrl->pci_dev->irq, pcie_isr, IRQF_SHARED,
> +				 MY_NAME, (void *)ctrl);
> +		dbg("%s: request_irq %d for hpc%d (returns %d)\n",
> +		    __FUNCTION__, ctrl->pci_dev->irq,
> +		    atomic_read(&pciehp_num_controllers), rc);
> +		if (rc) {
> +			err("Can't get irq %d for the hotplug controller\n",
> +			    ctrl->pci_dev->irq);
> +			goto abort;
> +		}
> +	}
> +	dbg("pciehp ctrl b:d:f:irq=0x%x:%x:%x:%x\n", pdev->bus->number,
> +		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn), dev->irq);
> +
> +	/*
> +	 * If this is the first controller to be initialized,
> +	 * initialize the pciehp work queue
> +	 */
> +	if (atomic_add_return(1, &pciehp_num_controllers) == 1) {
> +		pciehp_wq = create_singlethread_workqueue("pciehpd");
> +		if (!pciehp_wq) {
> +			rc = -ENOMEM;
> +			goto abort_free_irq;
> +		}
> +	}
> +
> +	rc = pcie_init_hardware_part2(ctrl, dev);
>  	if (rc == 0) {
>  		ctrl->hpc_ops = &pciehp_hpc_ops;
>  		return 0;
>  	}
> +abort_free_irq:
> +	if (pciehp_poll_mode)
> +		del_timer_sync(&ctrl->poll_timer);
> +	else
> +		free_irq(ctrl->pci_dev->irq, ctrl);
>  abort:
>  	return -1;
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
