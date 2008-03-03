Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYCCStR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYCCStR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYCCStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:49:00 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:51296 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753069AbYCCSs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:48:59 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 1/4] Remove path attribute from sgi_hotplug
Date: Mon, 3 Mar 2008 10:48:20 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002640.GB21420@ldl.fc.hp.com>
In-Reply-To: <20080229002640.GB21420@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031048.20762.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Prarit to cc since I think this is his code.]

On Thursday, February 28, 2008 4:26 pm Alex Chiang wrote:
> Rename the slot to be the contents of the 'path' sysfs attribute, and
> delete the attribute.  The mapping from pci address to slot name is
> supposed to be done through the 'address' file, which will be provided
> automatically later in this series of patches.
>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> ---
>  drivers/pci/hotplug/sgi_hotplug.c |   32 +-------------------------------
>  1 files changed, 1 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/pci/hotplug/sgi_hotplug.c
> b/drivers/pci/hotplug/sgi_hotplug.c index ef07c36..693519e 100644
> --- a/drivers/pci/hotplug/sgi_hotplug.c
> +++ b/drivers/pci/hotplug/sgi_hotplug.c
> @@ -91,21 +91,6 @@ static struct hotplug_slot_ops sn_hotplug_slot_ops = {
>
>  static DEFINE_MUTEX(sn_hotplug_mutex);
>
> -static ssize_t path_show (struct hotplug_slot *bss_hotplug_slot,
> -	       		  char *buf)
> -{
> -	int retval = -ENOENT;
> -	struct slot *slot = bss_hotplug_slot->private;
> -
> -	if (!slot)
> -		return retval;
> -
> -	retval = sprintf (buf, "%s\n", slot->physical_path);
> -	return retval;
> -}
> -
> -static struct hotplug_slot_attribute sn_slot_path_attr = __ATTR_RO(path);
> -
>  static int sn_pci_slot_valid(struct pci_bus *pci_bus, int device)
>  {
>  	struct pcibus_info *pcibus_info;
> @@ -173,18 +158,10 @@ static int sn_hp_slot_private_alloc(struct
> hotplug_slot *bss_hotplug_slot, return -ENOMEM;
>  	bss_hotplug_slot->private = slot;
>
> -	bss_hotplug_slot->name = kmalloc(SN_SLOT_NAME_SIZE, GFP_KERNEL);
> -	if (!bss_hotplug_slot->name) {
> -		kfree(bss_hotplug_slot->private);
> -		return -ENOMEM;
> -	}
> +	bss_hotplug_slot->name = slot->physical_path;
>
>  	slot->device_num = device;
>  	slot->pci_bus = pci_bus;
> -	sprintf(bss_hotplug_slot->name, "%04x:%02x:%02x",
> -		pci_domain_nr(pci_bus),
> -		((u16)pcibus_info->pbi_buscommon.bs_persist_busnum),
> -		device + 1);
>
>  	sn_generate_path(pci_bus, slot->physical_path);
>
> @@ -203,8 +180,6 @@ static struct hotplug_slot * sn_hp_destroy(void)
>  		bss_hotplug_slot = slot->hotplug_slot;
>  		list_del(&((struct slot *)bss_hotplug_slot->private)->
>  			 hp_list);
> -		sysfs_remove_file(&bss_hotplug_slot->kobj,
> -				  &sn_slot_path_attr.attr);
>  		break;
>  	}
>  	return bss_hotplug_slot;
> @@ -653,11 +628,6 @@ static int sn_hotplug_slot_register(struct pci_bus
> *pci_bus) rc = pci_hp_register(bss_hotplug_slot);
>  		if (rc)
>  			goto register_err;
> -
> -		rc = sysfs_create_file(&bss_hotplug_slot->kobj,
> -				       &sn_slot_path_attr.attr);
> -		if (rc)
> -			goto register_err;
>  	}
>  	dev_dbg(&pci_bus->self->dev, "Registered bus with hotplug\n");
>  	return rc;


