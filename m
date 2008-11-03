Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYKCWYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYKCWYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYKCWXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:23:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbYKCWXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:23:53 -0500
Date: Mon, 3 Nov 2008 14:23:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
Message-Id: <20081103142346.05d93b0d.akpm@linux-foundation.org>
In-Reply-To: <20081029200903.GA1678@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 20:09:03 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Various pieces of hardware (such as the Acer Aspire One and Asus EEE) 
> use PCIE hotplug to change the state of devices in response to events 
> such as the removal of SD cards or disabling the wireless radio. 
> However, they do not provide firmware support for this. As a consequence 
> pciehp will refuse to load and various things break.
> 
> The existing workaround has been to use the pciehp_force option. This is 
> undesirable as there is little guarantee that manipulating the power 
> file in the slot directory will actually result in anything happening, 
> leading to potential user confusion and hardware damage. This patch adds 
> a new option, pciehp_passive. In this configuration pciehp will listen 
> for events and notify the PCI core appropriately. However, it will not 
> provide any user controllable sysfs attributes and so the risk of 
> confusion or damage is averted. Any system slots that do have firmware 
> support will continue to provide full functionality.
> 

Gad.  I don't think I understood any of that.  But that's OK - it's par for
the course.

However, what worries me a bit is how our users are to understand
whether they need to use this option, how to use it, etc.  Does it
require too much knowledge of PCIE internals to be very useful?  Is
there any way in which we can make it more user-friendly?

> 
> ---
> 
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 4b23bc3..b878432 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -41,6 +41,7 @@ int pciehp_debug;
>  int pciehp_poll_mode;
>  int pciehp_poll_time;
>  int pciehp_force;
> +int pciehp_passive;
>  struct workqueue_struct *pciehp_wq;
>  
>  #define DRIVER_VERSION	"0.4"
> @@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
>  module_param(pciehp_poll_mode, bool, 0644);
>  module_param(pciehp_poll_time, int, 0644);
>  module_param(pciehp_force, bool, 0644);
> +module_param(pciehp_passive, bool, 0644);
>  MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
>  MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
>  MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
>  MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
> +MODULE_PARM_DESC(pciehp_passive, "Listen for pciehp events, even if _OSC and OSHP are missing");

I don't think that helped much ;)

>  
>  #define PCIE_MODULE_NAME "pciehp"
>  
> @@ -85,6 +88,13 @@ static struct hotplug_slot_ops pciehp_hotplug_slot_ops = {
>    	.get_cur_bus_speed =	get_cur_bus_speed,
>  };
>  
> +static struct hotplug_slot_ops pciehp_passive_hotplug_slot_ops = {
> +	.owner =		THIS_MODULE,
> +	.get_adapter_status =	get_adapter_status,
> +  	.get_max_bus_speed =	get_max_bus_speed,
> +  	.get_cur_bus_speed =	get_cur_bus_speed,
> +};
> +
>  /*
>   * Check the status of the Electro Mechanical Interlock (EMI)
>   */
> @@ -212,7 +222,11 @@ static int init_slots(struct controller *ctrl)
>  		hotplug_slot->info = info;
>  		hotplug_slot->private = slot;
>  		hotplug_slot->release = &release_slot;
> -		hotplug_slot->ops = &pciehp_hotplug_slot_ops;
> +		if (pciehp_passive &&
> +		    pciehp_get_hp_hw_control_from_firmware(ctrl->pci_dev))
> +			hotplug_slot->ops = &pciehp_passive_hotplug_slot_ops;
> +		else
> +			hotplug_slot->ops = &pciehp_hotplug_slot_ops;
>  		slot->hotplug_slot = hotplug_slot;
>  		snprintf(name, SLOT_NAME_SIZE, "%u", slot->number);
>  
> @@ -407,7 +421,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
>  	u8 value;
>  	struct pci_dev *pdev = dev->port;
>  
> -	if (pciehp_force)
> +	if (pciehp_force || pciehp_passive)
>  		dev_info(&dev->device,
>  			 "Bypassing BIOS check for pciehp use on %s\n",
>  			 pci_name(pdev));
> @@ -435,7 +449,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
>  	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
>  
>  	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
> -	if (value && pciehp_force) {
> +	if (value && (pciehp_force || pciehp_passive)) {
>  		rc = pciehp_enable_slot(t_slot);
>  		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
>  			value = 0;
> @@ -474,7 +488,7 @@ static int pciehp_suspend (struct pcie_device *dev, pm_message_t state)
>  static int pciehp_resume (struct pcie_device *dev)
>  {
>  	dev_info(&dev->device, "%s ENTRY\n", __func__);
> -	if (pciehp_force) {
> +	if (pciehp_force || pciehp_passive) {
>  		struct controller *ctrl = get_service_data(dev);
>  		struct slot *t_slot;
>  		u8 status;

Was this change so obvious that no code comments were needed? 
Perhaps...

