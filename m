Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYGWSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYGWSf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYGWSfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:35:18 -0400
Received: from smtp.extricom.com ([192.114.46.18]:47755 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750988AbYGWSfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:35:17 -0400
Message-ID: <488778FD.1050206@extricom.com>
Date: Wed, 23 Jul 2008 21:31:25 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: eran liberty <eran.liberty@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org> <4885DD41.9010202@extricom.com> <20080722141327.GB7337@parisc-linux.org> <4885FBF4.6070306@extricom.com> <20080722165241.GD7337@parisc-linux.org> <48861BAC.1080009@extricom.com> <20080722181132.GE7337@parisc-linux.org>
In-Reply-To: <20080722181132.GE7337@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

> Look at the consequences of calling fixup_resource() twice on the same
> resource:
>
>         res->start = (res->start + offset) & mask;
>         res->end = (res->end + offset) & mask;
>
> You'll add 'offset' to the other resources twice.
>   
Tring to find heads and tails in the code, I dug in. This is what I understand from the overall flow... and my points of interests:

1. pci_scan_child_bus() starts with iterating over all the devfn and scanning for a device with that devfn

drivers/pci/probe.c
1056 unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
1057 {
1063         /* Go find them, Rover! */
1064         for (devfn = 0; devfn < 0x100; devfn += 8)
1065                 pci_scan_slot(bus, devfn);

2. pci_scan_slot() will continue to scan all the functions that devfn might have to over
drivers/pci/probe.c
1019 int pci_scan_slot(struct pci_bus *bus, int devfn)
1020 {
1026         for (func = 0; func < 8; func++, devfn++) {
1029                 dev = pci_scan_single_device(bus, devfn);

3. pci_scan_single_device() will scan / test if this dev is valid.
drivers/pci/probe.c
996 struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
997 {
998         struct pci_dev *dev;
999 
1000         dev = pci_scan_device(bus, devfn);

and add it. REGARDLESS if it is already on the pci bus list or not.
1001         if (!dev)
1002                 return NULL;
1003 
1004         pci_device_add(dev, bus);
1005 
1006         return dev;
1007 }

This is the first thing that needs to be fixed IMHO.

4. pci_scan_child_bus() will go on to fixup the bus whether it needs fixing or not.
drivers/pci/probe.c
1072         pcibios_fixup_bus(bus);

This might be the second thing that needs amending.

5.  pcibios_fixup_bus(bus) calls _pcibios_fixup_bus which will call fixup_resource() once per a bus resource (in contrast of per device on that bus) and fixes the resources of that bus.
arch/powerpc/kernel/pci-common.c	
784 static void __devinit __pcibios_fixup_bus(struct pci_bus *bus)
785 {
787         struct pci_dev *dev = bus->self;
798                 for (i = 0; i < PCI_BUS_NUM_RESOURCES; ++i) {
833                         fixup_resource(res, dev);
834                 }
835         }
850 }

As you have correctly observed without other changes this would cause trouble on a bus that has resources.
Since i am not pulling the plug on the whole bus just on selected devices I can defensively skip this part

6. Now I should be able to call pci_bus_assign_resources(bus) which will go over all the newly added device and assign resource to them. 

7. Last step I should be able to pci_bus_add_devices(bus) the, now, resource fixed devices.

Steps 6 and 7 are the one I miss most over which my device wont work after being re-born.

Soooo ...

If I really wanted to make it, working my way around the current code, I would have done something like this.

bus = null;
while ((bus = pci_find_next_bus(bus)) != NULL) {
	for (devfn = 0; devfn < 0x100; devfn += 8) {
		for (func = 0; func < 8; func++) {
			struct pci_dev *dev =  <http://liberty/lxr/ident?v=e500-linux-2.6.26-rc4;i=pci_get_slot>pci_get_slot(struct pci_bus *bus, unsigned int devfn);
			if (dev) 
				continue;
			dev = pci_scan_single_device(bus, devfn);
			if (!dev)
				continue;
			pci_device_add(dev, bus);
		}
	}
        pci_bus_assign_resources(bus);
        pci_bus_add_devices(bus);
}

WOW.... first time for me to code in Mozilla Thunderbird.

Had I was this smart to begin with I would have done exactly that and go home to sleep like a decent person. 
But since we are here, I feel there should be a either correction in the existing code to allow the:
pci_scan_child_bus(bus) -> pci_bus_assign_resources(bus) -> pci_bus_add_devices(bus) sequence.
Or a new helper function to the PCI that does more or less what I have just described.

If you want I can code it, patch it, and rip the glory :)

That was a long one :)

Liberty

