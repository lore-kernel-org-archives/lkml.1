Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZCSCPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZCSCPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 22:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZCSCPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 22:15:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47540 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZCSCPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 22:15:39 -0400
Message-ID: <49C1AAC3.80406@jp.fujitsu.com>
Date: Thu, 19 Mar 2009 11:15:31 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] PCI: beef up pci_do_scan_bus()
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309054900.3918.4473.stgit@bob.kio> <49B8D2F4.1030206@jp.fujitsu.com> <20090312232226.GD31042@ldl.fc.hp.com> <49BA235C.4040703@jp.fujitsu.com> <20090315164841.GA24570@ldl.fc.hp.com> <49C0B0E3.2090208@jp.fujitsu.com> <20090318203934.GC20467@ldl.fc.hp.com>
In-Reply-To: <20090318203934.GC20467@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Alex Chiang wrote:
>>> The more I think about it though, the more I think that even
>>> without the below patch to clean up the callers of
>>> pci_do_scan_bus, we should be ok, because:
>>>
>>> 	- all the old code (which I removed below) existed
>>> 	  because the old PCI core would refuse to scan PCI buses
>>> 	  that had already been discovered
>>>
>>> 	- that meant that it would never descend past a known
>>> 	  bridge to try and find new child bridges
>>>
>>> 	- that meant that hotplug drivers had to manually
>>> 	  discover new bridges and add them, essentially
>>> 	  duplicating functionality in pci_scan_bridge
>>>
>>> This patch series allows the PCI core to scan existing bridges
>>> and descend down into the children every time, looking for new
>>> bridges and devices, so all the code in shpchp, cpcihp, and other
>>> callers of pci_do_scan_bus shouldn't be necessary anymore.
>>>
>>> Also, if we do add new bridges once manually in shpchp, and then
>>> call the new pci_do_scan_bus again, we will _not_ add devices
>>> twice because the core should check each bridge and device for
>>> struct pci_dev.is_added.
>>>
>>> So anyway, I think that cleaning up the callers of
>>> pci_do_scan_bus is a good idea, but multiple calls to the
>>> interface definitely should not result in problems. If they do,
>>> then that's a bug in my patch series.
>>>
>> I'm sorry, but I didn't have enough time to try your patch on
>> my environment. So I'm still just looking at the code.
> 
> Ok.
> 
>> I looked at shpchp_configure_device() from the view point of
>> bridge hot-add. I think it is broken regardless of your change
>> because it calls pci_bus_add_devices() (through pci_do_scan_bus)
>> before assigning resources. So I think it must be changed
>> regardless of your change. But it's a little difficult for me
>> because I don't have any test environment as I mentioned before.
> 
> Hm, what you say makes sense.
> 
> I managed to find a very old machine supported by cpqphp, and
> also found a card with a bridge.
> 
> cpqhp_configure_device() follows a similar algorithm to
> shpchp_configure_device(). I'm just starting my testing now, and
> there is good news and bad news.
> 
> The bad news is that although cpqphp loads successfully, and we
> can successfully offline a card, we cannot online it again
> afterwards due to BAR collisions. This failure occurs even
> without my changes (2.6.27 kernel), and I haven't had time to
> track the regression down yet.
> 
> We do discover the bridge on the device correctly and it is added
> back into the device tree correctly, but we can't use it because
> it's not programmed correctly.
> 
> The good news is, after rewriting cpqphp_configure_device() to
> resemble the shpchp patch I gave you, we still discover the
> bridge correctly and add it back into the device tree in the
> proper place. We no longer get BAR collisions, but we fail in a
> slightly different way.
> 
> At least I'm not introducing a new regression in cpqphp, and I
> suspect shpchp will be similar.
> 
>> But I'm still worrying about your change against pci_do_scan_bus().
>> Without your change, pci_do_scan_bus() scans child buses and add
>> devices without assigning resources. I guess that it means existing
>> callers of pci_do_scan_bus() have some mechanism to assign resource
>> by theirselves and they don't expect pci_do_scan_bus() assigns
>> resources.
> 
> I looked through shpchp and couldn't find this assumption. Is it
> stored in the struct controller, under mmio_base and mmio_size?
>

Yes, shpchp doesn't have this assumption. As I mentioned in
the previous e-mail, I think shpchp's bridge hot-add code is
broken even without your change. I'm worrying about the other
hotplug drivers such as cpqphp, cpcihp, rpaphp and ibmphp, though
I don't have any knowledge about those hotplug drivers.
 
> I am motivated to get this patch series into 2.6.30 for several
> reasons, so I think for now, I will not change pci_do_scan_bus().
> Instead, I'll create a new interface that only the PCI core will
> use, and leave the drivers alone.
>
> Over time, we can migrate the drivers to the PCI core interface.
>

I think it's much safer way.
 
>> By the way, I have one question about rescan. Please suppose that
>> we enable the bridge(B) and its children using rescan interface
>> in the picture below.
>>
>>                   |
>> -------------------------------------- parent bus
>>         |                  |
>>     bridge(A)          bridge(B)
>>     (working)        (Not working)
>>         |                  |
>>   -------------      -------------
>>    |         |        |         |
>>   dev       dev      dev       dev
>> (working) (working)   (Not working)
>>
>> In this case, your rescan mechanism calls pci_do_scan_bus() for
>> parent bus, and pci_do_scan_bus() calls pci_bus_assign_resources()
>> for parent bus. My question is, does pci_bus_assign_resources() do
>> nothing against bridge(A) that is currently working? I guess  
>> pci_bus_assign_resources() would update some registers of bridge(A)
>> and it would breaks currently working devices.
> 
> This is a very good catch, thank you.
> 
> I added another patch to prevent this situation. We now check to
> see if the bridge is already added inside of pci_setup_bridge().
> 

Sounds good to me.

Thanks,
Kenji Kaneshige


> Thanks.
> 
> /ac
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


