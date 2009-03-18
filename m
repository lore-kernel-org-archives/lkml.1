Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZCRI3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZCRI3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZCRI3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:29:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37117 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZCRI3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:29:32 -0400
Message-ID: <49C0B0E3.2090208@jp.fujitsu.com>
Date: Wed, 18 Mar 2009 17:29:23 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] PCI: beef up pci_do_scan_bus()
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309054900.3918.4473.stgit@bob.kio> <49B8D2F4.1030206@jp.fujitsu.com> <20090312232226.GD31042@ldl.fc.hp.com> <49BA235C.4040703@jp.fujitsu.com> <20090315164841.GA24570@ldl.fc.hp.com>
In-Reply-To: <20090315164841.GA24570@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Hello Kenji-san,
> 
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Alex Chiang wrote:
>>> I hadn't gotten around to verifying/fixing existing callers of
>>> pci_do_scan_bus yet. I was focusing on the core first.
>>>
>>> There aren't too many callers, but unfortunately, I don't have
>>> any hardware that actually uses the existing drivers.
>>>
>>> I seem to recall that your machines support shpchp. Would you
>>> mind testing this patch and telling me if your machine still
>>> behaves properly?
>>>
>> I have machines that support shpchp. But unfortunately I don't
>> have any adapter card that contains bridge, which is needed to
>> test your change.
> 
> You're right.
> 
> The more I think about it though, the more I think that even
> without the below patch to clean up the callers of
> pci_do_scan_bus, we should be ok, because:
> 
> 	- all the old code (which I removed below) existed
> 	  because the old PCI core would refuse to scan PCI buses
> 	  that had already been discovered
> 
> 	- that meant that it would never descend past a known
> 	  bridge to try and find new child bridges
> 
> 	- that meant that hotplug drivers had to manually
> 	  discover new bridges and add them, essentially
> 	  duplicating functionality in pci_scan_bridge
> 
> This patch series allows the PCI core to scan existing bridges
> and descend down into the children every time, looking for new
> bridges and devices, so all the code in shpchp, cpcihp, and other
> callers of pci_do_scan_bus shouldn't be necessary anymore.
> 
> Also, if we do add new bridges once manually in shpchp, and then
> call the new pci_do_scan_bus again, we will _not_ add devices
> twice because the core should check each bridge and device for
> struct pci_dev.is_added.
> 
> So anyway, I think that cleaning up the callers of
> pci_do_scan_bus is a good idea, but multiple calls to the
> interface definitely should not result in problems. If they do,
> then that's a bug in my patch series.
>

I'm sorry, but I didn't have enough time to try your patch on
my environment. So I'm still just looking at the code.

I looked at shpchp_configure_device() from the view point of
bridge hot-add. I think it is broken regardless of your change
because it calls pci_bus_add_devices() (through pci_do_scan_bus)
before assigning resources. So I think it must be changed
regardless of your change. But it's a little difficult for me
because I don't have any test environment as I mentioned before.

But I'm still worrying about your change against pci_do_scan_bus().
Without your change, pci_do_scan_bus() scans child buses and add
devices without assigning resources. I guess that it means existing
callers of pci_do_scan_bus() have some mechanism to assign resource
by theirselves and they don't expect pci_do_scan_bus() assigns
resources.

By the way, I have one question about rescan. Please suppose that
we enable the bridge(B) and its children using rescan interface
in the picture below.

                   |
-------------------------------------- parent bus
         |                  |
     bridge(A)          bridge(B)
     (working)        (Not working)
         |                  |
   -------------      -------------
    |         |        |         |
   dev       dev      dev       dev
(working) (working)   (Not working)

In this case, your rescan mechanism calls pci_do_scan_bus() for
parent bus, and pci_do_scan_bus() calls pci_bus_assign_resources()
for parent bus. My question is, does pci_bus_assign_resources() do
nothing against bridge(A) that is currently working? I guess 
pci_bus_assign_resources() would update some registers of bridge(A)
and it would breaks currently working devices.

Thanks,
Kenji Kaneshige



>>> I looked at shpchp_configure_device and I think that simply
>>> scanning the device's parent bus should work.
>>>
>> Ok, I'll try it.
> 
> I set up a git tree to make it easier to test:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/achiang/pci-hotplug.git
> 
> The 'test-20090313' branch contains all the latest fixes to
> enable this patch series. It does not contain the patch below, so
> you will have to apply it by hand.
> 
> Thanks for testing!
> 
> /ac
> 
>>> Thanks.
>>>
>>> /ac
>>>
>>> diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
>>> index aa315e5..7e8457b 100644
>>> --- a/drivers/pci/hotplug/shpchp_pci.c
>>> +++ b/drivers/pci/hotplug/shpchp_pci.c
>>> @@ -110,11 +110,7 @@ int __ref shpchp_configure_device(struct slot *p_slot)
>>>  		return -EINVAL;
>>>  	}
>>>  
>>> -	num = pci_scan_slot(parent, PCI_DEVFN(p_slot->device, 0));
>>> -	if (num == 0) {
>>> -		ctrl_err(ctrl, "No new device found\n");
>>> -		return -ENODEV;
>>> -	}
>>> +	pci_do_scan_bus(parent);
>>>  
>>>  	for (fn = 0; fn < 8; fn++) {
>>>  		dev = pci_get_slot(parent, PCI_DEVFN(p_slot->device, fn));
>>> @@ -126,40 +122,10 @@ int __ref shpchp_configure_device(struct slot *p_slot)
>>>  			pci_dev_put(dev);
>>>  			continue;
>>>  		}
>>> -		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
>>> -				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
>>> -			/* Find an unused bus number for the new bridge */
>>> -			struct pci_bus *child;
>>> -			unsigned char busnr, start = parent->secondary;
>>> -			unsigned char end = parent->subordinate;
>>> -			for (busnr = start; busnr <= end; busnr++) {
>>> -				if (!pci_find_bus(pci_domain_nr(parent),
>>> -							busnr))
>>> -					break;
>>> -			}
>>> -			if (busnr > end) {
>>> -				ctrl_err(ctrl,
>>> -					 "No free bus for hot-added bridge\n");
>>> -				pci_dev_put(dev);
>>> -				continue;
>>> -			}
>>> -			child = pci_add_new_bus(parent, dev, busnr);
>>> -			if (!child) {
>>> -				ctrl_err(ctrl, "Cannot add new bus for %s\n",
>>> -					 pci_name(dev));
>>> -				pci_dev_put(dev);
>>> -				continue;
>>> -			}
>>> -			child->subordinate = pci_do_scan_bus(child);
>>> -			pci_bus_size_bridges(child);
>>> -		}
>>>  		program_fw_provided_values(dev);
>>>  		pci_dev_put(dev);
>>>  	}
>>>  
>>> -	pci_bus_assign_resources(parent);
>>> -	pci_bus_add_devices(parent);
>>> -	pci_enable_bridges(parent);
>>>  	return 0;
>>>  }
>>>  
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


