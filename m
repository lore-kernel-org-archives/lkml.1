Return-Path: <linux-kernel-owner+w=401wt.eu-S1762402AbXJRAJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402AbXJRAJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759350AbXJRAI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:08:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:26382 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604AbXJRAI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="249608413"
Date: Wed, 17 Oct 2007 17:01:06 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4] Fix PCIe hotplug for non-ACPI ExpressCard slots
 (version 2)
Message-Id: <20071017170106.5d9e0a9f.kristen.c.accardi@intel.com>
In-Reply-To: <47156B92.7070501@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
	<47150982.6050102@rtr.ca>
	<471509FE.7080505@rtr.ca>
	<47151191.40406@rtr.ca>
	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
	<4715217D.2000803@rtr.ca>
	<20071016214143.GC21815@kroah.com>
	<471533AF.60100@rtr.ca>
	<47156B14.2080608@rtr.ca>
	<47156B40.4060006@rtr.ca>
	<47156B62.3070807@rtr.ca>
	<47156B7B.8010800@rtr.ca>
	<47156B92.7070501@rtr.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 21:55:30 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Make use of the previously split out pcie_init_enable_events() function
> to reinitialize the hotplug hardware on resume from suspend,
> but only when pciehp_force==1.  Otherwise behaviour is unmodified.

OK - definitely in this case the right thing to do is not use this code
unless you are forcing pciehp, thanks.

I think I'd be careful when you rename this patch - non-ACPI
ExpressCard slots is not what you want to say, as this fix is very
specific for your machine.  We have no idea if this will fix any other
problems that occur when people force pciehp - and in many cases this
either may not be needed, or may not be enough.  I only care about the
name because I don't want people mislead when they are reading git commits.


> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
> --- old/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 21:17:27.000000000 -0400
> +++ linux/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 21:28:36.000000000 -0400
> @@ -37,7 +37,6 @@
>  #include "pciehp.h"
>  
>  static void interrupt_event_handler(struct work_struct *work);
> -static int pciehp_disable_slot(struct slot *p_slot);
>  
>  static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
>  {
> --- old/drivers/pci/hotplug/pciehp.h	2007-10-16 21:17:27.000000000 -0400
> +++ linux/drivers/pci/hotplug/pciehp.h	2007-10-16 21:28:42.000000000 -0400
> @@ -162,6 +162,8 @@
>  extern void pciehp_queue_pushbutton_work(struct work_struct *work);
>  int pcie_init(struct controller *ctrl, struct pcie_device *dev);
>  int pciehp_enable_slot(struct slot *p_slot);
> +int pciehp_disable_slot(struct slot *p_slot);
> +int pcie_init_enable_events(struct controller *ctrl, struct pcie_device *dev);
>  
>  static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
>  {
> --- old/drivers/pci/hotplug/pciehp_core.c	2007-10-16 21:17:27.000000000 -0400
> +++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-16 21:30:19.000000000 -0400
> @@ -512,6 +512,24 @@
>  static int pciehp_resume (struct pcie_device *dev)
>  {
>  	printk("%s ENTRY\n", __FUNCTION__);	
> +	if (pciehp_force) {
> +		struct pci_dev *pdev = dev->port;
> +		struct controller *ctrl = pci_get_drvdata(pdev);
> +		struct slot *t_slot;
> +		u8 status;
> +
> +		/* reinitialize the chipset's event detection logic */
> +		pcie_init_enable_events(ctrl, dev);
> +
> +		t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
> +
> +		/* Check if slot is occupied */
> +		t_slot->hpc_ops->get_adapter_status(t_slot, &status);
> +		if (status)
> +			pciehp_enable_slot(t_slot);
> +		else
> +			pciehp_disable_slot(t_slot);
> +	}
>  	return 0;
>  }
>  #endif
> 
