Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbXLCDjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbXLCDjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 22:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXLCDjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 22:39:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58412 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbXLCDjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 22:39:41 -0500
Message-ID: <4753786F.1040703@jp.fujitsu.com>
Date: Mon, 03 Dec 2007 12:30:55 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, pcihpd-discuss@lists.sourceforge.net
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <474E6E82.40307@jp.fujitsu.com> <20071130015105.GH24707@ldl.fc.hp.com>
In-Reply-To: <20071130015105.GH24707@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

>> On my system, hotplug slots themselves can be added, removed
>> and replaced with the ohter type of I/O box. The ACPI firmware
>> tells OS the presence of those slots using _STA method (That
>> is, it doesn't use 'LoadTable()' AML operator). On the other
>> hand, current pci_slot driver doesn't check _STA.  As a result,
>> pci_slot driver tryied to register the invalid (non-existing)
>> slots. The ACPI firmware of my system returns '1023' if the
>> invalid slot's _SUN is evaluated. This is the cause of Call
>> Traces mentioned above. To fix this problem, pci_slot driver
>> need to check _STA when scanning ACPI Namespace.
> 
> Now this is very curious. The relevant line in pci_slot is:
> 
> check_slot()
> 	status = acpi_evaluate_integer(handle, "_SUN", NULL, sun);
> 	if (ACPI_FAILURE(status))
> 		return -1;
> 
> Why does your firmware return the error information inside sun,
> instead of returning an error in status? That doesn't seem right
> to me...

Because ACPI spec doesn't provide any way for firmware (AML)
to return as error.

In addtion, I think we should not trust the _SUN value of
non-existing device because the ACPI spec says in "6.5.1 _INI
(Init)" that _INI method is run before _ADR, _CID, _HID, _SUN, and
_UID are run. It means _SUN could be initialized in _INI method
implecitely. And it also says that "If the _STA method indicates
that the device is not present, OSPM will not run the _INI and will
not examine the children of the device for _INI methods.". After all,
_SUN for non-existing device is not reliable because it might not
initialized by _INI method.

> 
>> I'm sorry for reporting this so late. I'm attaching the patch
>> to fix the problem. This is against 2.6.24-rc3 with your
>> patches applied. Could you try it?
> 
> Applying this patch causes me to only detect populated slots in
> my system, which isn't what I want -- otherwise, I could have
> just enumerated the PCI bus and found the devices that way. :)
> 
> Maybe on your machine, checking existence of _STA might do the
> right thing, but I don't think we should actually be looking at
> any of the actual bits returned. 
> 
> If we check ACPI_STA_DEVICE_PRESENT, then we will not detect
> empty slots on my system. Can you try this patch to see if at
> least the first call to acpi_evaluate_integer helps? If that
> doesn't help, maybe the second block will help you, but it breaks
> my machine...

Maybe the result is as you guess.
The first block doesn't help me (with the first block, all of the
slot disappeared. Please see the bottom of this mail for details).
The second block helps me.

There seems a difference of the interpretation about _STA for PCI
hotplug slot between your firmware and my firmware. The difference
is:

  - Your firmware provides the _STA method to represent the presence
    of PCI adapter card on the slot.

  - My firmware provides the _STA method to represent the presence
    of the slot.

Providing _STA method to represent the presence of PCI adpater card
on the slot (as your firmware does) doesn't seem right to me because
of the following reasons.

  - ACPI spec says "After calling _EJ0, OSPM verifies the device no
    longer exists to determine if the eject succeeded. For _HID devices,
    OSPM evaluates the _STA method. For _ADR devices, OSPM checks with
    the bus driver for that device." in "6.3.3 _EJx (Eject)". Because
    PCI adapter card on the slot is _ADR device, the presence of the
    card must be checked with bus driver, not _STA.

  - ACPI spec provides the example AML code which uses _STA to
    represent Docking Station (See 6.3.2 _EJD (Ejection Dependent
    Device)". The usage of this is same as my firmware.

What do you think about that?

P.S. None of the slots except the strange slot named '1023' were
detected with your patch. It would happen on other machines
(might including hp machine) too. The reason is _STA evaluation
fails on the hotplug slot which doesn't have _STA method. If the
device object doesn't have a _STA method, we need to handle it as
if it is present. I believe firmware normally doesn't provide
_STA method for PCI hotplug slots.

Thanks,
Kenji Kaneshige

