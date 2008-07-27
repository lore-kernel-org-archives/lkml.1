Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYG0LFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYG0LFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYG0LEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:04:53 -0400
Received: from smtp1.extricom.com ([212.235.24.249]:55575 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751030AbYG0LEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:04:52 -0400
Message-ID: <488C5570.1050305@extricom.com>
Date: Sun, 27 Jul 2008 14:01:04 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Eran Liberty <liberty@extricom.com>
CC: Matthew Wilcox <matthew@wil.cx>, eran liberty <eran.liberty@gmail.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org> <4885DD41.9010202@extricom.com> <20080722141327.GB7337@parisc-linux.org> <4885FBF4.6070306@extricom.com> <20080722165241.GD7337@parisc-linux.org> <48861BAC.1080009@extricom.com> <20080722181132.GE7337@parisc-linux.org> <488778FD.1050206@extricom.com>
In-Reply-To: <488778FD.1050206@extricom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eran Liberty wrote:

> Soooo ...
>   
> If I really wanted to make it, working my way around the current code, I would have done something like this.
>   
> bus = null;
>   
> while ((bus = pci_find_next_bus(bus)) != NULL) {
>   
>     for (devfn = 0; devfn < 0x100; devfn += 8) {
>   
>         for (func = 0; func < 8; func++) {
>   
>             struct pci_dev *dev =  <http://liberty/lxr/ident?v=e500-linux-2.6.26-rc4;i=pci_get_slot>pci_get_slot(struct pci_bus *bus, unsigned int devfn);
>   
>             if (dev) 
>                 continue;
>   
>             dev = pci_scan_single_device(bus, devfn);
>   
>             if (!dev)
>   
>                 continue;
>   
>             pci_device_add(dev, bus);
>   
>         }
>   
>     }
>   
>        pci_bus_assign_resources(bus);
>   
>        pci_bus_add_devices(bus);
>   
> }
>   
Found some time to test my own idea... it seems to work. :)

Its final version looks like this:

Before reloading the programmable unit, remove all the device implemented by it

	struct pci_dev *dev;
	while ((dev = pci_get_device(PCI_VENDOR_ID_MYCOMP,PCI_DEVICE_ID_MYCOMP_MYDEV,NULL)) != NULL) {
		pci_remove_bus_device(dev);
		pci_dev_put(dev);
	}

After the programmable unit is loaded, scan and add only newly added device!

 	struct pci_bus *bus = NULL;
	while ((bus = pci_find_next_bus(bus)) != NULL) {
		int devfn;
		for (devfn = 0; devfn < 0x100; devfn++) {
			struct pci_dev *dev=pci_get_slot(bus,devfn);
			if (dev) 
				continue;  // <---- do not scan devices already present on the bus. Missing magic line :)
			(void)pci_scan_single_device(bus, devfn);
		}
		pci_bus_assign_resources(bus);
		pci_bus_add_devices(bus);
	}

So... no need for patch after all.
Unless... Hey whats this... behind it... on the side.... naaa, no need of patch... :(

Liberty

