Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYG1Iq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYG1Iq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYG1IqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:46:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51118 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYG1IqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:46:18 -0400
Message-ID: <488D86EC.1010903@jp.fujitsu.com>
Date: Mon, 28 Jul 2008 17:44:28 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <20080725012916.06679a6d@mjolnir.drzeus.cx> <48895BA1.1030606@jp.fujitsu.com> <200807251518.53462.jbarnes@virtuousgeek.org>
In-Reply-To: <200807251518.53462.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Thursday, July 24, 2008 9:50 pm Kenji Kaneshige wrote:
>> Thank you for debug info, Pierre.
>>
>> According to the debugging output, five slots are detected (five
>> slots on laptop!?) and two of them have the same physical slots
>> number '2'. This is the reason why Pierre's machine needs
>> 'pciehp_slot_with_bus' option.
>>
>> Before 2.6.26 (from 2.6.xx), pciehp did the workaround for the
>> problem (some platform wrongly assign the same physical slot
>> number to multiple slots) by default. But this was not a good
>> idea because of the several reasons like follows:
>>
>>   - Slot name should be a physical identifier of physical slot
>>     on the system. Using bus number as a part of slot name is
>>     not a idea because bus number is logical number and it can
>>     be changed.
>>
>>   - As Jesse explained, some hotplug slot can be handled through
>>     several type of controllers. For example, some hotplug slot
>>     can be handled by either acpiphp or pciehp. But those drivers
>>     must not handle the same slot at the same time. The pci
>>     hotplug core is checking this by checking duplicate names.
>>     This check didn't work because pciehp had started using bus
>>     number as a part of slot name and slot names became different
>>     between acpiphp and pciehp.
>>
>> About the former, I'm ok with using bus number as a part of slot
>> name on the problematic platform. But it should not be used on
>> the normal platform.
>>
>> About the latter, IIRC, thanks to Alex's pci slot framework from
>> 2.6.26, pci hotplug core can check if multiple drivers attempts
>> to handle the same slot even if those drivers uses the different
>> names.
>>
>> Based on my thought above, I have a following idea to remove
>> "pciehp_slot_with_bus".
>>
>>   - Try to use physical slot number as a slot name, first.
>>
>>   - If pci_hp_register() success, no problem.
>>
>>   - If pci_hp_register() returns -EBUSY, that means another
>>     hotplug driver already handling the slot. So return as error.
>>
>>   - If pci_hp_register() returns -EEXIST, that means there is a
>>     existing slot with the same name. In this case, retry to
>>     register slots with logical name (bus number + physical slot
>>     number, or other).
>>
>> With this idea, slots names will become as follows on Pierre's
>> machine.
>>
>> <Before 2.6.26>
>> 0001_0001, 0002_0002, 0003_0003, 0004_0004, 0005_0005, 000d_0002
>>
>> <Current>
>> 1, 2, 3, 4, 5
>>
>> <With my idea>
>> 1, 2, 3, 4, 5, 000d_0002
>>
>>
>> Please give me comments.
> 
> I think that's fine (automatically creating duplicate devices with names to 
> differentiate them), but I think we should also try harder to avoid adding 
> duplicates.
> 
> In Pierre's case, and on my T61, there's only one actual hotplug slot 
> available, but the firmware creates duplicate physical slot numbers and sets 
> the HP_CAP bit on everything, both of which are obviously wrong (well I 
> suppose you could pop these chips off the board, but it's not very 
> practical).  However, afaict that "other" OS uses the _RMV method to 
> determine whether a given slot is actually hot pluggable.  On my T61 at 
> least, this seems to be accurate: only one of my EXP* objects has a _RMV 
> method.
> 
> So maybe the PCIe hotplug driver should be checking for that method when ACPI 
> is available?  We already try to use _OSC etc., so checking for _RMV first 
> would make sense...
> 

As you pointed out, the root cause might not a problem of slot naming,
but a problem of slots detection, because pciehp driver detects multiple
PCIe hotplug slots even thought your and Pierre's system seems to have
only one hotplug slot. So I think we should also consider the problem
from this view point (slot detection).

But, I think simply checking for _RMV method first is dangerous because
I think there are many systems that doesn't implement _RMV for PCIe
hotplug slots (at least, my system doesn't implement that. Anyway,
I would like to look at the documents/specifications that mention _RMV
method for determining whether a given slot is hot pluggable. Do you
have any information about that? I think PCI Local Bus, PCI Express and
PCI Firmware specification don't mention that. I think hot pluggable slots
on your, Pierre's and Matthew's system are ExpressCard slots. So I guess
ExpressCard specification might define something about this. But
unfortunately, I don't have ExpressCard specification. Can anyone access
ExpressCard spec?

Thanks,
Kenji Kaneshige


