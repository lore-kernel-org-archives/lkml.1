Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbYHUKZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbYHUKZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYHUKZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:25:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34864 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYHUKZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:25:41 -0400
Message-ID: <48AD4265.10108@jp.fujitsu.com>
Date: Thu, 21 Aug 2008 19:24:37 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH 02/13] PCI: prevent duplicate slot names
References: <20080816235504.5461.20733.stgit@blender.achiang> <20080817001516.5461.59384.stgit@blender.achiang>
In-Reply-To: <20080817001516.5461.59384.stgit@blender.achiang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

Thank you for updated patches and I'm sorry for delayed comment.
I reviewed your patch and I found two problems. Please see below.

Alex Chiang wrote:
> Prevent callers of pci_create_slot() from registering slots with
> duplicate names. This condition occurs most often when PCI hotplug
> drivers are loaded on platforms with broken firmware that assigns
> identical names to multiple slots.
> 
> We now rename these duplicate slots on behalf of the user.
> 
> If firmware assigns the name N to multiple slots, then:
> 
> 	The first registered slot is assigned N
> 	The second registered slot is assigned N-1
> 	The third registered slot is assigned N-2
> 	The Mth registered slot becomes N-M
> 
> A side effect of this patch is that the error condition for when
> multiple drivers attempt to claim the same slot becomes much more
> prominent.
> 
> In other words, the previous error condition returned for
> duplicate slot names (-EEXIST) masked the case when multiple
> drivers attempted to claim the same slot. Now, the -EBUSY return
> makes the true error more obvious.
> 
> Finally, since we now prevent duplicate slot names, we remove
> the logic introduced by the following commits:
> 
> 	pci hotplug core: add check of duplicate slot name
> 	a86161b3134465f072d965ca7508ec9c1e2e52c7
> 
> 	pciehp: fix slot name
> 	3800345f723fd130d50434d4717b99d4a9f383c8
> 
> 	pciehp: add message about pciehp_slot_with_bus option
> 	9e4f2e8d4ddb04ad16a3828cd9a369a5a5287009
> 
> 	shpchp: fix slot name
> 	ef0ff95f136f0f2d035667af5d18b824609de320
> 
> 	shpchp: add message about shpchp_slot_with_bus option
> 	b3bd307c628af2f0a581c42d5d7e4bcdbbf64b6a
> 
> Cc: jbarnes@virtuousgeek.org
> Cc: kristen.c.accardi@intel.com
> Cc: matthew@wil.cx
> Cc: kaneshige.kenji@jp.fujitsu.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/hotplug/pci_hotplug_core.c |    4 -
>  drivers/pci/hotplug/pciehp.h           |    1 
>  drivers/pci/hotplug/pciehp_core.c      |    7 --
>  drivers/pci/hotplug/pciehp_hpc.c       |    6 --
>  drivers/pci/hotplug/shpchp_core.c      |   14 -----
>  drivers/pci/slot.c                     |   93 +++++++++++++++++++++++++-------
>  6 files changed, 76 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
> index 96f274e..da5908f 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -570,10 +570,6 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>  		return -EINVAL;
>  	}
>  
> -	/* Check if we have already registered a slot with the same name. */
> -	if (get_slot_from_name(name))
> -		return -EEXIST;
> -
>  	/*
>  	 * No problems if we call this interface from both ACPI_PCI_SLOT
>  	 * driver and call it here again. If we've already created the
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index e3a1e7e..9e6cec6 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -43,7 +43,6 @@ extern int pciehp_poll_mode;
>  extern int pciehp_poll_time;
>  extern int pciehp_debug;
>  extern int pciehp_force;
> -extern int pciehp_slot_with_bus;
>  extern struct workqueue_struct *pciehp_wq;
>  
>  #define dbg(format, arg...)						\
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 5952315..bed77af 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -41,7 +41,6 @@ int pciehp_debug;
>  int pciehp_poll_mode;
>  int pciehp_poll_time;
>  int pciehp_force;
> -int pciehp_slot_with_bus;
>  struct workqueue_struct *pciehp_wq;
>  
>  #define DRIVER_VERSION	"0.4"
> @@ -56,12 +55,10 @@ module_param(pciehp_debug, bool, 0644);
>  module_param(pciehp_poll_mode, bool, 0644);
>  module_param(pciehp_poll_time, int, 0644);
>  module_param(pciehp_force, bool, 0644);
> -module_param(pciehp_slot_with_bus, bool, 0644);
>  MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
>  MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
>  MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
>  MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
> -MODULE_PARM_DESC(pciehp_slot_with_bus, "Use bus number in the slot name");
>  
>  #define PCIE_MODULE_NAME "pciehp"
>  
> @@ -226,10 +223,6 @@ static int init_slots(struct controller *ctrl)
>  					 slot->name);
>  		if (retval) {
>  			err("pci_hp_register failed with error %d\n", retval);
> -			if (retval == -EEXIST)
> -				err("Failed to register slot because of name "
> -				    "collision. Try \'pciehp_slot_with_bus\' "
> -				    "module option.\n");
>  			goto error_info;
>  		}
>  		/* create additional sysfs entries */
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index ad27e9e..43ff979 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -1032,11 +1032,7 @@ static void pcie_shutdown_notification(struct controller *ctrl)
>  
>  static void make_slot_name(struct slot *slot)
>  {
> -	if (pciehp_slot_with_bus)
> -		snprintf(slot->name, SLOT_NAME_SIZE, "%04d_%04d",
> -			 slot->bus, slot->number);
> -	else
> -		snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
> +	snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
>  }
>  
>  static int pcie_init_slot(struct controller *ctrl)
> diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
> index 7bc06c0..136d9ea 100644
> --- a/drivers/pci/hotplug/shpchp_core.c
> +++ b/drivers/pci/hotplug/shpchp_core.c
> @@ -39,7 +39,6 @@
>  int shpchp_debug;
>  int shpchp_poll_mode;
>  int shpchp_poll_time;
> -static int shpchp_slot_with_bus;
>  struct workqueue_struct *shpchp_wq;
>  
>  #define DRIVER_VERSION	"0.4"
> @@ -53,11 +52,9 @@ MODULE_LICENSE("GPL");
>  module_param(shpchp_debug, bool, 0644);
>  module_param(shpchp_poll_mode, bool, 0644);
>  module_param(shpchp_poll_time, int, 0644);
> -module_param(shpchp_slot_with_bus, bool, 0644);
>  MODULE_PARM_DESC(shpchp_debug, "Debugging mode enabled or not");
>  MODULE_PARM_DESC(shpchp_poll_mode, "Using polling mechanism for hot-plug events or not");
>  MODULE_PARM_DESC(shpchp_poll_time, "Polling mechanism frequency, in seconds");
> -MODULE_PARM_DESC(shpchp_slot_with_bus, "Use bus number in the slot name");
>  
>  #define SHPC_MODULE_NAME "shpchp"
>  
> @@ -101,12 +98,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
>  
>  static void make_slot_name(struct slot *slot)
>  {
> -	if (shpchp_slot_with_bus)
> -		snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%04d_%04d",
> -			 slot->bus, slot->number);
> -	else
> -		snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%d",
> -			 slot->number);
> +	snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%d", slot->number);
>  }
>  
>  static int init_slots(struct controller *ctrl)
> @@ -162,10 +154,6 @@ static int init_slots(struct controller *ctrl)
>  				hotplug_slot->name);
>  		if (retval) {
>  			err("pci_hp_register failed with error %d\n", retval);
> -			if (retval == -EEXIST)
> -				err("Failed to register slot because of name "
> -                                    "collision. Try \'shpchp_slot_with_bus\' "
> -				    "module option.\n");
>  			goto error_info;
>  		}
>  
> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> index 7e5b85c..42f0e12 100644
> --- a/drivers/pci/slot.c
> +++ b/drivers/pci/slot.c
> @@ -73,6 +73,50 @@ static struct kobj_type pci_slot_ktype = {
>  	.default_attrs = pci_slot_default_attrs,
>  };
>  
> +static char *make_slot_name(const char *name)
> +{
> +	char *new_name;
> +	int len, width, dup = 1;
> +	struct kobject *dup_slot;
> +
> +	new_name = kstrdup(name, GFP_KERNEL);
> +	if (!new_name)
> +		goto out;
> +
> +	/*
> +	 * Start off allocating enough room for "name-X"
> +	 */
> +	len = strlen(name) + 2;
> +	width = 1;
> +
> +try_again:
> +	dup_slot = kset_find_obj(pci_slots_kset, new_name);
> +	if (!dup_slot)
> +		goto out;
> +

The kset_find_obj() increments reference counter of specified kobject. So
we must call kobject_put() for 'dup_slot', otherwise it leaks reference
counter of 'dup_slot' kobject and the corresponding slot directory will
never be removed. Here is a sample to fix this problem.

	dup_slot = kset_find_ojb(pci_slots_kset, new_name);
	if (!dup_slot)
		goto out;
	kobject_put(dup_slot);
	^^^^^^^^^^^^^^^^^^^^^^ Added this line


I found another problem in pci_hp_register() that would be more complex
to fix than above-mentioned problem. Here is a pci_hp_register() with
all of your patch applied.

int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
                        const char *name)
{
	(snip...)

        /*
         * No problems if we call this interface from both ACPI_PCI_SLOT
         * driver and call it here again. If we've already created the
         * pci_slot, the interface will simply bump the refcount.
         */
        pci_slot = pci_create_slot(bus, slot_nr, name);
        if (IS_ERR(pci_slot))
                return PTR_ERR(pci_slot);

        if (pci_slot->hotplug) {
                dbg("%s: already claimed\n", __func__);
                pci_destroy_slot(pci_slot);
                return -EBUSY;
        }

        slot->pci_slot = pci_slot;
        pci_slot->hotplug = slot;

        /*
         * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
         */
        if (strcmp(kobject_name(&pci_slot->kobj), name)) {
                result = kobject_rename(&pci_slot->kobj, name);
                if (result) {
                        pci_destroy_slot(pci_slot);
                        return result;
                }
        }

	(snip...)
}

If name duplication was detected in pci_create_slot(), it renames the
slot name like 'N-1' and return successfully. Even though slot's kobject
name was registered as 'N-1', 'name' array still have 'N' at this point.
So the following 'if' statement becomes true unexpectedly.

	/*
         * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
         */
        if (strcmp(kobject_name(&pci_slot->kobj), name)) {

Then pci_hp_register() attempt to rename the slot name with 'N' again
by calling kobject_rename(), but it fails because there already exists
kobject with name 'N'. As a result, pci_hp_register() will fail.

Thanks,
Kenji Kaneshige


