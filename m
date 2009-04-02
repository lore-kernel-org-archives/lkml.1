Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbZDBBX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbZDBBX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZDBBXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:23:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42935 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZDBBXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:23:47 -0400
Message-ID: <49D4139C.9040207@jp.fujitsu.com>
Date: Thu, 02 Apr 2009 10:23:40 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pci logical vs. physical hotplug
References: <20090331210045.GD16311@ldl.fc.hp.com>
In-Reply-To: <20090331210045.GD16311@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> I confirmed this patch fix the kernel oops problem I reported.
>>
>> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>> Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> Thank you for reviewing and testing.
> 
>> By the way, /sys/bus/pci/slots/<slot> directory by acpiphp are
>> remaining even after the parent bridge/bus of the slots are
>> removed. At this point, acpiphp is working with struct pci_bus
>> for the already disabled pci bus. I guess some operation against
>> the files under /sys/bus/pci/slots/<slot> directory would cause
>> something problems. So I think we also need something mechanism
>> to unregister acpiphp slots when the parent bus is removed.
> 
> Yes, I've been thinking about this (and thank you for your other
> mail confirming the issue).
> 

The pciehp (and probably also shpchp) doesn't have this problem because
/sys/bus/pci/slots/<slot> directories are unregistered when the parent
bridge of those slots is removed. This is done with PCI driver model.
The acpiphp and pci_slot driver doesn't match the PCI driver model, so
I think those drivers need something other notification mechanism of
PCI device removal. I guess this kind of notification mechanism might
already exist in the kernel to bind ACPI device and PCI device, though
it's still just my guess.

Please note that I'm not saying that pciehp doesn't have any problem
about the interaction with logical hotplug mechanism. I think there
are still remaining issues, and we need to solve them one by one.

> The logical hotplug and physical hotplug don't play very nicely
> with each other.
> 
> I think one of the core issues is that logical hotplug allows
> function level granularity while physical hotplug is naturally
> restricted to physical slot granularity, which includes an entire
> hierarchy, from host bus down to function.
> 
> If a user uses logical hotplug to take out a piece of the tree,
> what does that mean if it's part of the physical slot/device?
> 
> What should happen?
> 
> Take something like this:
> 
> [0000:2e-4f]----00.0-[0000:2f-4f]--+-02.0-[0000:30-3f]--+-00.0  Intel GigE
>                                    |                    \-00.1  Intel GigE
>                                    \-04.0-[0000:40-4f]--+-00.0  Intel GigE
>                                                         \-00.1  Intel GigE
> 
> Assume that this is a quad-port NIC with a bridge in it, and that
> the physical slot is 0000:2e:00.0.
> 
> What should we do if the user does a logical hotplug on
> 0000:2f:04.0 and has acpiphp loaded?
> 
> If acpiphp tries to do anything to 0000:40: we'll probably get an
> oops.
> 
> But just because the user took out one piece of that tree doesn't
> mean that we should disable the entire slot. If that was the
> case, then he could just use the existing hotplug drivers.
> 
> I don't have a good answer for right now, other than, "don't try
> to mix logical and physical hotplug". I'm open to any ideas that
> you may have.
> 

Physical hotplug is:

	physical hot-add = physical power on + logical hot-add;
	physical hot-removal = logical hot-removal + physical power off;

In the above case, some pieces of logical hot-removal has already
been done. So I think what acpiphp need to do is remaining pieces
of logical hot-removal of tree and power off.

Thanks,
Kenji Kaneshige


