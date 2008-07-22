Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYGVNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYGVNMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYGVNMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:12:09 -0400
Received: from smtp.extricom.com ([192.114.46.18]:39897 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751166AbYGVNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:12:08 -0400
Message-ID: <4885DBE9.6000904@extricom.com>
Date: Tue, 22 Jul 2008 16:08:57 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: eran liberty <eran.liberty@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org>
In-Reply-To: <20080722114929.GA7337@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

You seem to have a finer grasp of the subject then I do, please correct/educate me on any of the points I raise in the following lines.

Matthew Wilcox wrote:

> On Tue, Jul 22, 2008 at 11:21:06AM +0300, eran liberty wrote:
>>> I think this is your real problem, that you're rescanning the entire
>>> bus.  I don't think that's the route we'd recommend taking.
>> My stating point was that I have loaded a new design into a
>> programmable device which sits on the pci device. The new design can
>> implement numerous pci devices or non at all. I can think of an easy
>> way (or clean one) to scan only the programmable device. Scanning the
>> whole bus seemed reasonable.
> That's what pci_scan_slot() is for.  It scans the first function at the
> device number, then (if the header indicates it's a multifunction
> device) scans the other functions associated with that device.  eg you
> could call pci_scan_slot(bus, 0x30) and it will create function 06.0
> (and potentially 06.1, 06.2, ...)
> You presumably already have the devfn for the existing device since
> you're able to call pci_remove_bus_device().
Each slot represent a single device which can have more then one function.  pci_scan_slot is aimed for scanning these multiple functions. 
I, on the other hand, have programmable device on the pci bus which is, for the sake of this discussion, a complete black box. 
This black box up on loading can implement more then one device, which can have more then one function each. 
So as far as I see it, now I need to scan all slots on the bus.

But to be honest, upon looking a way to make my device work I dismissed the "pci_scan_slot()" option as It did not reach the "fixup_resource <http://liberty/lxr/ident?v=e500-linux-2.6.26-rc4;i=fixup_resource>()" part.

>>> Why don't you call pci_scan_slot() instead?  You won't get the benefit of
>>> pcibios_fixup_bus(), but I'm not convinced that's safe to call on a bus
>>> that's already been scanned.
>>>       
>> As said its not exactly a slot its more like a regular pci device that
>> someone suddenly welded into the pci bus. Its not a hotplug as well,
>> and I do not want to give up on the pcibios_fixup_bus()
>>     
>
> Why not?  What architecture are you using?  What does
> pcibios_fixup_bus() do for you?
>   
I work with ARCH=powerpc. pcibios_fixup_bus() will deal with all the resource bars allocation. 
I needed Linux to renegotiate the resources bars on the PCI devices.

> (as a side-note, I'd like to reimplement the pcibios_fixup_*() routines;
> I think a lot of what they do can be done more generically these days.
> It'll take a while and isn't high on my priority list).
>   
If I can lend a hand there, let me know and I will try to squeeze it in somewhere.

>   
>> As it is, with my patch applied i successfully go over the bus and
>> remove my own devices before I reprogram the
>> programmable device.
>>
>> while ((dev = pci_get_device(PCI_VENDOR_ID_MYCOMP,PCI_DEVICE_ID_MYDEV,NULL))
>> != NULL) {
>> 	pci_remove_bus_device(dev);
>> 	pci_dev_put(dev);
>> }
>>
>> Load a new design into it.
>>
>> Then scan the entire bus and add the newly discovered devices.
>>
>> bus = null;
>> while ((bus = pci_find_next_bus(bus)) != NULL) {
>> 	pci_scan_child_bus(bus);
>> 	pci_bus_assign_resources(bus);
>> 	pci_bus_add_devices(bus);
>> }
>>
>> As seen here, this sequence of instructions seems very intuitive. It
>> will fail without the patch upon pci_bus_add_devices().
>>     
>
> Seems utterly unintuitive to me.  You're doing a lot of unnecessary work
> here, and if you have two cards in your machine, you'll take away both
> of them when you reload either of them.
>   
Hmmm, I do want to remove all the devices that are implemented by the programmable unit which is reloaded. 
I have not considered the possibility of having more then one programmable unit. 
I guess that the removing part can be more fine tuned as the need arises. 

> What you should do is cache the pci_bus and the devfn at startup:
>
> static struct pci_bus *my_bus;
> static int my_devfn;
>
> 	struct pci_dev *dev = pci_get_device(PCI_VENDOR_ID_MYCOMP,
> 					PCI_DEVICE_ID_MYDEV, NULL);
> 	if (!dev)
> 		return -ENODEV;
> 	my_bus = dev->bus;
> 	my_devfn = dev->devfn;
> 	pci_dev_put(dev);
>
> when you want to remove it:
>
> 	for (func = 0; func < 8; func++)
> 		struct pci_dev *dev = pci_get_slot(my_bus, my_devfn + func);
> 		if (!dev)
> 			continue;
> 		pci_remove_bus_device(dev);
> 		pci_dev_put(dev);
> 	}
>
> when you want to rescan it:
>
> 	pci_scan_slot(my_bus, my_devfn);
>
> (this only handles one programmable card.  The basic idea could be
> extended to handle multiple cards if you need to do that).
>   
I think there is a hidden assumption in this code, again please correct me if I missed the point. 
This code assumes that the devices which will re-appear after the programmable unit is loaded has the same devfn and bus as the devices which were present before the reload. 
This assumption might be wrong. 

For example, I have a basic programmable image which has no pci devices at all. 
upon unloading I do not remove any device (as non are present) and up on reloading I suddenly have two. What is their bus? their devfn?

Ultimately I would have expected to find a "int pci_scan_bus(struct  <http://liberty/lxr/ident?v=e500-linux-2.6.26-rc4;i=pci_scan_bus>pci_bus <http://liberty/lxr/ident?v=e500-linux-2.6.26-rc4;i=pci_bus> *bus <http://liberty/lxr/ident?v=e500-linux-2.6.26-rc4;i=bus>);" the "pci_scan_child_bus <http://liberty/lxr/ident?v=e500-linux-2.6.26-rc4;i=pci_scan_child_bus>()" was the closest to the mark

Liberty

