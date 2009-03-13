Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZCMJM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZCMJM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZCMJMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:12:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44151 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZCMJMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:12:15 -0400
Message-ID: <49BA235C.4040703@jp.fujitsu.com>
Date: Fri, 13 Mar 2009 18:11:56 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] PCI: beef up pci_do_scan_bus()
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309054900.3918.4473.stgit@bob.kio> <49B8D2F4.1030206@jp.fujitsu.com> <20090312232226.GD31042@ldl.fc.hp.com>
In-Reply-To: <20090312232226.GD31042@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Hello Kenji-san,
> 
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Alex Chiang wrote:
>>> We have a nice interface for re-scanning a PCI bus which will
>>> discover newly added devices, add them to the device tree, and
>>> enable them properly.
>>>
>>> Ensure that the bridge resources are properly sized and assigned
>>> during the rescan.
>>>
>>> Signed-off-by: Alex Chiang <achiang@hp.com>
>>> ---
>>>
>>>  drivers/pci/hotplug-pci.c |   16 ++++++++++++----
>>>  1 files changed, 12 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
>>> index 4d4a644..33ab2d2 100644
>>> --- a/drivers/pci/hotplug-pci.c
>>> +++ b/drivers/pci/hotplug-pci.c
>>> @@ -6,13 +6,21 @@
>>>  
>>>  unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
>>>  {
>>> -	unsigned int max;
>>> +	unsigned int max, pass;
>>> +	struct pci_dev *dev;
>>>  
>>>  	max = pci_scan_child_bus(bus);
>>>  
>>> -	/*
>>> -	 * Make the discovered devices available.
>>> -	 */
>>> +	for (pass=0; pass < 2; pass++)
>>> +		list_for_each_entry(dev, &bus->devices, bus_list) {
>>> +			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
>>> +			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
>>> +				if (pass && dev->subordinate)
>>> +					pci_bus_size_bridges(dev->subordinate);
>>> +		}
>>> +
>>> +	pci_bus_assign_resources(bus);
>>> +	pci_enable_bridges(bus);
>>>  	pci_bus_add_devices(bus);
>> The "for (pass=0; pass <2; pass++)" loop doesn't look necessary.
> 
> Yes, I don't know why I had it in there originally. I can remove
> that.
> 
>> And I'm worrying that your change have some bad effect to the
>> existing user of pci_do_scan_bus(). Did you confirm that?
> 
> I hadn't gotten around to verifying/fixing existing callers of
> pci_do_scan_bus yet. I was focusing on the core first.
> 
> There aren't too many callers, but unfortunately, I don't have
> any hardware that actually uses the existing drivers.
> 
> I seem to recall that your machines support shpchp. Would you
> mind testing this patch and telling me if your machine still
> behaves properly?
>

I have machines that support shpchp. But unfortunately I don't
have any adapter card that contains bridge, which is needed to
test your change.
 
> I looked at shpchp_configure_device and I think that simply
> scanning the device's parent bus should work.
>

Ok, I'll try it.

Thanks,
Kenji Kaneshige


> Thanks.
> 
> /ac
> 
> diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
> index aa315e5..7e8457b 100644
> --- a/drivers/pci/hotplug/shpchp_pci.c
> +++ b/drivers/pci/hotplug/shpchp_pci.c
> @@ -110,11 +110,7 @@ int __ref shpchp_configure_device(struct slot *p_slot)
>  		return -EINVAL;
>  	}
>  
> -	num = pci_scan_slot(parent, PCI_DEVFN(p_slot->device, 0));
> -	if (num == 0) {
> -		ctrl_err(ctrl, "No new device found\n");
> -		return -ENODEV;
> -	}
> +	pci_do_scan_bus(parent);
>  
>  	for (fn = 0; fn < 8; fn++) {
>  		dev = pci_get_slot(parent, PCI_DEVFN(p_slot->device, fn));
> @@ -126,40 +122,10 @@ int __ref shpchp_configure_device(struct slot *p_slot)
>  			pci_dev_put(dev);
>  			continue;
>  		}
> -		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
> -				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
> -			/* Find an unused bus number for the new bridge */
> -			struct pci_bus *child;
> -			unsigned char busnr, start = parent->secondary;
> -			unsigned char end = parent->subordinate;
> -			for (busnr = start; busnr <= end; busnr++) {
> -				if (!pci_find_bus(pci_domain_nr(parent),
> -							busnr))
> -					break;
> -			}
> -			if (busnr > end) {
> -				ctrl_err(ctrl,
> -					 "No free bus for hot-added bridge\n");
> -				pci_dev_put(dev);
> -				continue;
> -			}
> -			child = pci_add_new_bus(parent, dev, busnr);
> -			if (!child) {
> -				ctrl_err(ctrl, "Cannot add new bus for %s\n",
> -					 pci_name(dev));
> -				pci_dev_put(dev);
> -				continue;
> -			}
> -			child->subordinate = pci_do_scan_bus(child);
> -			pci_bus_size_bridges(child);
> -		}
>  		program_fw_provided_values(dev);
>  		pci_dev_put(dev);
>  	}
>  
> -	pci_bus_assign_resources(parent);
> -	pci_bus_add_devices(parent);
> -	pci_enable_bridges(parent);
>  	return 0;
>  }
>  
> 

