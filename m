Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbXJRLUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbXJRLUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbXJRLUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:20:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41978 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbXJRLUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:20:17 -0400
Message-ID: <47174069.9000108@jp.fujitsu.com>
Date: Thu, 18 Oct 2007 20:15:53 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
Cc: kristen.c.accardi@intel.com, greg@kroah.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 1/3] pciehp: hotplug: deal with	pre-inserted
 ExpressCards
References: <4716CB9D.6080503@rtr.ca> <4716D3C0.20808@rtr.ca>
In-Reply-To: <4716D3C0.20808@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I still don't understand what the problems is very much. Could
you give me answers against the following questions?

  (1) Did you try "echo 1 > /sys/bus/pci/slots/XXX/power"?
      (XXX is the slot number to which your card had been inserted)
  (2) If the answer against (1) is yes, did "echo 1 > ..." work?
  (3) If the answer against (1) is no, could you try that?
  (4) If the "echo 1 > ..." works, does it solve your problem?
  (5) If the "echo 1 > ..." doesn't work, could you give me the
      output of "cat /sys/bus/pci/slots/XXX/*"?
  (6) I think your slot is surprise removable. Is it correct?

Thanks,
Kenji Kaneshige


> (repost to conform with akpm's subject line conventions)
> 
> One of three patches to fix PCIe Hotplug so that it works with ExpressCard slots
> on Dell notebooks (and others?) in conjunction with modparam of pciehp_force=1.
> 
> Fix pciehp_probe() to deal with ExpressCard cards
> that were inserted prior to the driver being loaded.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
> --- a/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-17 22:30:19.000000000 -0400
> +++ b/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-17 22:29:59.000000000 -0400
> @@ -37,7 +37,6 @@
>  #include "pciehp.h"
>  
>  static void interrupt_event_handler(struct work_struct *work);
> -static int pciehp_enable_slot(struct slot *p_slot);
>  static int pciehp_disable_slot(struct slot *p_slot);
>  
>  static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
> --- git12/drivers/pci/hotplug/pciehp.h	2007-10-17 22:30:19.000000000 -0400
> +++ linux/drivers/pci/hotplug/pciehp.h	2007-10-17 22:29:59.000000000 -0400
> @@ -161,6 +161,7 @@
>  extern int pciehp_unconfigure_device(struct slot *p_slot);
>  extern void pciehp_queue_pushbutton_work(struct work_struct *work);
>  int pcie_init(struct controller *ctrl, struct pcie_device *dev);
> +int pciehp_enable_slot(struct slot *p_slot);
>  
>  static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
>  {
> --- git12/drivers/pci/hotplug/pciehp_core.c	2007-10-17 22:30:19.000000000 -0400
> +++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-17 22:36:06.000000000 -0400
> @@ -471,6 +471,11 @@
>  	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
>  
>  	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
> +	if (value) {
> +		rc = pciehp_enable_slot(t_slot);
> +		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
> +			value = 0;
> +	}
>  	if ((POWER_CTRL(ctrl->ctrlcap)) && !value) {
>  		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
>  		if (rc)
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> Pcihpd-discuss mailing list
> Pcihpd-discuss@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/pcihpd-discuss
> 
> 


