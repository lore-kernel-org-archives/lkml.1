Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbYCUTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbYCUTnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYCUTnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:43:04 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:14299 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYCUTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:43:01 -0400
Date: Fri, 21 Mar 2008 13:42:59 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH  6/16][BUG] ACPI pci_slot: Fix slot removal path (Not
	for mainline!)
Message-ID: <20080321194259.GL17292@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E3360B.1010506@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3360B.1010506@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Current ACPI pci slot driver scans ACPI namespace and slot list on
> pci_bus structure to find the pci_slot pointer. It is definitely
> redundant. In addition, it scans slot list on pci_bus without holding
> pci_bus_sem. This patch fixes those problems.

Tested and merged, thanks.

/ac

> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/acpi/pci_slot.c |  104 +++++++++++++++++++++++++-----------------------
>  1 file changed, 55 insertions(+), 49 deletions(-)
> 
> Index: linux-2.6.25-rc6/drivers/acpi/pci_slot.c
> ===================================================================
> --- linux-2.6.25-rc6.orig/drivers/acpi/pci_slot.c
> +++ linux-2.6.25-rc6/drivers/acpi/pci_slot.c
> @@ -55,9 +55,17 @@ ACPI_MODULE_NAME("pci_slot");
>  				MY_NAME , ## arg);		\
>  	} while (0)
>  
> +struct acpi_pci_slot {
> +	acpi_handle root_handle;	/* handle of the root bridge */
> +	struct pci_slot *pci_slot;	/* corresponding pci_slot */
> +	struct list_head list;		/* node in the list of slots */
> +};
> +
>  static int acpi_pci_slot_add(acpi_handle handle);
>  static void acpi_pci_slot_remove(acpi_handle handle);
>  
> +static LIST_HEAD(slot_list);
> +static DEFINE_MUTEX(slot_list_lock);
>  static struct acpi_pci_driver acpi_pci_slot_driver = {
>  	.add = acpi_pci_slot_add,
>  	.remove = acpi_pci_slot_remove,
> @@ -105,34 +113,11 @@ out:
>  	return retval;
>  }
>  
> -/*
> - * unregister_slot
> - *
> - * Called once for each SxFy object in the namespace. Each call to
> - * pci_destroy_slot decrements the refcount on the pci_slot, and
> - * eventually calls kobject_unregister at the appropriate time.
> - */
> -static acpi_status
> -unregister_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -	int device;
> -	unsigned long sun;
> -	struct pci_slot *slot, *tmp;
> -	struct pci_bus *pci_bus = context;
> -
> -	if (check_slot(handle, &device, &sun))
> -		return AE_OK;
> -
> -	/* FIXME - Need pci_bus_sem to be held */
> -	list_for_each_entry_safe(slot, tmp, &pci_bus->slots, list) {
> -		if (slot->number == device) {
> -			pci_destroy_slot(slot);
> -			break;
> -		}
> -	}
> -
> -	return AE_OK;
> -}
> +struct callback_args {
> +	acpi_walk_callback	user_function;	/* only for walk_p2p_bridge */
> +	struct pci_bus		*pci_bus;
> +	acpi_handle		root_handle;
> +};
>  
>  /*
>   * register_slot
> @@ -150,17 +135,33 @@ register_slot(acpi_handle handle, u32 lv
>  	int device;
>  	unsigned long sun;
>  	char name[KOBJ_NAME_LEN];
> -
> +	struct acpi_pci_slot *slot;
>  	struct pci_slot *pci_slot;
> -	struct pci_bus *pci_bus = context;
> +	struct callback_args *parent_context = context;
> +	struct pci_bus *pci_bus = parent_context->pci_bus;
>  
>  	if (check_slot(handle, &device, &sun))
>  		return AE_OK;
>  
> +	slot = kmalloc(sizeof(*slot), GFP_KERNEL);
> +	if (!slot) {
> +		err("%s: cannot allocate memory\n", __FUNCTION__);
> +		return AE_OK;
> +	}
> +
>  	snprintf(name, sizeof(name), "%u", (u32)sun);
>  	pci_slot = pci_create_slot(pci_bus, device, name);
> -	if (IS_ERR(pci_slot))
> +	if (IS_ERR(pci_slot)) {
>  		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
> +		kfree(slot);
> +	}
> +
> +	slot->root_handle = parent_context->root_handle;
> +	slot->pci_slot = pci_slot;
> +	INIT_LIST_HEAD(&slot->list);
> +	mutex_lock(&slot_list_lock);
> +	list_add(&slot->list, &slot_list);
> +	mutex_unlock(&slot_list_lock);
>  
>  	dbg("pci_slot: %#lx, pci_bus: %x, device: %d, name: %s\n",
>  		(uint64_t)pci_slot, pci_bus->number, device, name);
> @@ -168,11 +169,6 @@ register_slot(acpi_handle handle, u32 lv
>  	return AE_OK;
>  }
>  
> -struct p2p_bridge_context {
> -	acpi_walk_callback	user_function;
> -	struct pci_bus		*pci_bus;
> -};
> -
>  /*
>   * walk_p2p_bridge - discover and walk p2p bridges
>   * @handle: points to an acpi_pci_root
> @@ -192,8 +188,8 @@ walk_p2p_bridge(acpi_handle handle, u32 
>  
>  	struct pci_dev *dev;
>  	struct pci_bus *pci_bus;
> -	struct p2p_bridge_context child_context;
> -	struct p2p_bridge_context *parent_context = context;
> +	struct callback_args child_context;
> +	struct callback_args *parent_context = context;
>  
>  	pci_bus = parent_context->pci_bus;
>  	user_function = parent_context->user_function;
> @@ -213,14 +209,16 @@ walk_p2p_bridge(acpi_handle handle, u32 
>  	if (!dev || !dev->subordinate)
>  		goto out;
>  
> +	child_context.pci_bus = dev->subordinate;
> +	child_context.user_function = user_function;
> +	child_context.root_handle = parent_context->root_handle;
> +
>  	dbg("p2p bridge walk, pci_bus = %x\n", dev->subordinate->number);
>  	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
> -				     user_function, dev->subordinate, NULL);
> +				     user_function, &child_context, NULL);
>  	if (ACPI_FAILURE(status))
>  		goto out;
>  
> -	child_context.pci_bus = dev->subordinate;
> -	child_context.user_function = user_function;
>  	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
>  				     walk_p2p_bridge, &child_context, NULL);
>  out:
> @@ -246,7 +244,7 @@ walk_root_bridge(acpi_handle handle, acp
>  	acpi_status status;
>  	acpi_handle dummy_handle;
>  	struct pci_bus *pci_bus;
> -	struct p2p_bridge_context context;
> +	struct callback_args context;
>  
>  	/* If the bridge doesn't have _STA, we assume it is always there */
>  	status = acpi_get_handle(handle, "_STA", &dummy_handle);
> @@ -271,14 +269,16 @@ walk_root_bridge(acpi_handle handle, acp
>  	if (!pci_bus)
>  		return 0;
>  
> +	context.pci_bus = pci_bus;
> +	context.user_function = user_function;
> +	context.root_handle = handle;
> +
>  	dbg("root bridge walk, pci_bus = %x\n", pci_bus->number);
>  	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
> -				     user_function, pci_bus, NULL);
> +				     user_function, &context, NULL);
>  	if (ACPI_FAILURE(status))
>  		return status;
>  
> -	context.pci_bus = pci_bus;
> -	context.user_function = user_function;
>  	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
>  				     walk_p2p_bridge, &context, NULL);
>  	if (ACPI_FAILURE(status))
> @@ -310,11 +310,17 @@ acpi_pci_slot_add(acpi_handle handle)
>  static void
>  acpi_pci_slot_remove(acpi_handle handle)
>  {
> -	acpi_status status;
> +	struct acpi_pci_slot *slot, *tmp;
>  
> -	status = walk_root_bridge(handle, unregister_slot);
> -	if (ACPI_FAILURE(status))
> -		err("%s: unregister_slot failure - %d\n", __func__, status);
> +	mutex_lock(&slot_list_lock);
> +	list_for_each_entry_safe(slot, tmp, &slot_list, list) {
> +		if (slot->root_handle == handle) {
> +			list_del(&slot->list);
> +			pci_destroy_slot(slot->pci_slot);
> +			kfree(slot);
> +		}
> +	}
> +	mutex_unlock(&slot_list_lock);
>  }
>  
>  #ifdef CONFIG_DMI
> 
> 
