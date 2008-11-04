Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYKDB7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYKDB7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKDB7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:59:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35242 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYKDB7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:59:43 -0500
Message-ID: <490FAC33.9050808@jp.fujitsu.com>
Date: Tue, 04 Nov 2008 10:58:11 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
References: <20081029200903.GA1678@srcf.ucam.org>
In-Reply-To: <20081029200903.GA1678@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
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

I have several comments/questions below.

- Even with pciehp_passive option, pciehp driver controls hotplug
  related registers at the initialization time, enabling software
  notification mechanism for hotplug events, trying to turn power
  on the slot and so on. Is this your intended behaviour?

- Maybe I don't understand what "pciehp will listen for events..."
  in your patch description means. But if you expect the pciehp's
  interrupts for hotplug events, it would not work properly when
  hotplug control is not granted through _OSC or OSHP.

- Using pciehp_passive or pciehp_force option causes system reset
  on my system because of Master-Abort. I think it is an already
  existing problem with pciehp_force option. The cause of this
  problem is the code below.

>  	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
> -	if (value && pciehp_force) {
> +	if (value && (pciehp_force || pciehp_passive)) {
>  		rc = pciehp_enable_slot(t_slot);
>  		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
>  			value = 0;

  The pciehp_enable_slot() here returns error on my system because
  it detects the slot is already powered on state when it tries to
  turn power on the slot. As a result 'value' is set with 0. After
  that, pciehp turn power off the slot by the following code even
  though the adapter card on the slot is currently working, and it
  caused Master-Abort.

        if ((POWER_CTRL(ctrl)) && !value) {
                rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot
if not occupied*/
                if (rc)
                        goto err_out_free_ctrl_slot;
        }

  I guess the reason why you didn't encounter this problem is that
  your laptop doesn't have power controller on hotplug controller.
  I'll try to make a patch to fix this problem soon.

Thanks,
Kenji Kaneshige




> Signed-off-by: Matthew Garrett <mjg@redhat.com>
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
> 


