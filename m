Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXLCWoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXLCWoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXLCWoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:44:25 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:32981 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXLCWoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:44:22 -0500
Date: Mon, 3 Dec 2007 15:43:31 -0700
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: pcihpd-discuss@lists.sourceforge.net, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071203224331.GA29227@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	pcihpd-discuss@lists.sourceforge.net,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <474E6E82.40307@jp.fujitsu.com> <20071130015105.GH24707@ldl.fc.hp.com> <4753786F.1040703@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4753786F.1040703@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Hi Alex-san,
>
>>> On my system, hotplug slots themselves can be added, removed
>>> and replaced with the ohter type of I/O box. 

Are you talking about some sort of I/O cabinet/chassis that you
can attach to the actual computer? Can the I/O expander unit be
hotplugged? Or do you need to power your machine down to attach
it?

If you can hotplug it, I'm guessing that is why your firmware
presents SxFy objects in the namespace with "weird" _SUN values,
and it's why you have to check _STA to see if the slots are valid
or not. That means the value returned by _SUN will change too,
right? What will it turn into?

Is that right? Or am I completely wrong? :)

>>> The ACPI firmware tells OS the presence of those slots using
>>> _STA method (That is, it doesn't use 'LoadTable()' AML
>>> operator). On the other hand, current pci_slot driver doesn't
>>> check _STA.  As a result, pci_slot driver tryied to register
>>> the invalid (non-existing) slots. The ACPI firmware of my
>>> system returns '1023' if the invalid slot's _SUN is
>>> evaluated. This is the cause of Call Traces mentioned above.
>>> To fix this problem, pci_slot driver need to check _STA when
>>> scanning ACPI Namespace.
>>
>> Now this is very curious. The relevant line in pci_slot is:
>> check_slot()
>> 	status = acpi_evaluate_integer(handle, "_SUN", NULL, sun);
>> 	if (ACPI_FAILURE(status))
>> 		return -1;
>> Why does your firmware return the error information inside sun,
>> instead of returning an error in status? That doesn't seem right
>> to me...
>
> Because ACPI spec doesn't provide any way for firmware (AML)
> to return as error.

You are right -- I got confused about the interpreter returning
AE_NOT_FOUND vs the actual firmware returning an error value.
Thank you for this clarification.

> In addtion, I think we should not trust the _SUN value of
> non-existing device because the ACPI spec says in "6.5.1 _INI
> (Init)" that _INI method is run before _ADR, _CID, _HID, _SUN, and
> _UID are run. It means _SUN could be initialized in _INI method
> implecitely. And it also says that "If the _STA method indicates
> that the device is not present, OSPM will not run the _INI and will
> not examine the children of the device for _INI methods.". After all,
> _SUN for non-existing device is not reliable because it might not
> initialized by _INI method.

This is true, but HP platforms provide _INI at the root
device/host bridge level, not on SxFy objects, so it doesn't seem
that we would need to call _STA before calling _SUN for SxFy.

Does your firmware provide _INI on SxFy objects?

>>> I'm sorry for reporting this so late. I'm attaching the patch
>>> to fix the problem. This is against 2.6.24-rc3 with your
>>> patches applied. Could you try it?
>> Applying this patch causes me to only detect populated slots in
>> my system, which isn't what I want -- otherwise, I could have
>> just enumerated the PCI bus and found the devices that way. :)
>> Maybe on your machine, checking existence of _STA might do the
>> right thing, but I don't think we should actually be looking at
>> any of the actual bits returned. If we check ACPI_STA_DEVICE_PRESENT, then 
>> we will not detect
>> empty slots on my system. Can you try this patch to see if at
>> least the first call to acpi_evaluate_integer helps? If that
>> doesn't help, maybe the second block will help you, but it breaks
>> my machine...
>
> Maybe the result is as you guess.
> The first block doesn't help me (with the first block, all of the
> slot disappeared. Please see the bottom of this mail for details).
> The second block helps me.
>
> There seems a difference of the interpretation about _STA for PCI
> hotplug slot between your firmware and my firmware. The difference
> is:
>
>  - Your firmware provides the _STA method to represent the presence
>    of PCI adapter card on the slot.
>
>  - My firmware provides the _STA method to represent the presence
>    of the slot.

Yes, that sounds right...

> Providing _STA method to represent the presence of PCI adpater card
> on the slot (as your firmware does) doesn't seem right to me because
> of the following reasons.
>
>  - ACPI spec says "After calling _EJ0, OSPM verifies the device no
>    longer exists to determine if the eject succeeded. For _HID devices,
>    OSPM evaluates the _STA method. For _ADR devices, OSPM checks with
>    the bus driver for that device." in "6.3.3 _EJx (Eject)". Because
>    PCI adapter card on the slot is _ADR device, the presence of the
>    card must be checked with bus driver, not _STA.
>
>  - ACPI spec provides the example AML code which uses _STA to
>    represent Docking Station (See 6.3.2 _EJD (Ejection Dependent
>    Device)". The usage of this is same as my firmware.
>
> What do you think about that?

Our firmware teams seem to think that _STA should give the status
of the card for hotplug support and general functional state.
They claim that it doesn't makes much sense to support _STA on
the slot itself unless you can physically change the slot
topology on the machine at runtime, which we can't do (although
maybe you can).

The section of the spec you quoted is correct as long as we are
talking ACPI 2.0 or later. My platforms implement ACPI 1.0b for
legacy reasons. :-/

In ACPI 1.0b, _EJx definition says (section 6.3.2):

	For hot removal, the device must be immediately ejected
	when the OS calls the _EJ0 control method. The _EJ0
	control method does not return until ejection is
	complete. After calling _EJ0, the OS will call _STA to
	determine whether or not the eject succeeded.

So your firmware implementation does not seem backward compatible
with the 1.0b spec. The different versions of ACPI is part of the
reason why my patch is breaking on your machine.

But as long as we are quoting the spec...  :)

	_SUN evaluates to a DWORD that is the number to be used
	in the user interface. This number is required to be
	unique among the slots of the same type. It is also
	recommended that this number match the slot number
	printed on the physical slot whenever possible.

	section 6.1.6 of ACPI 2.0c

My question is, why is your firmware returning multiple values of
1023 then? This seems to be the real reason why my patch is
breaking on your machine.

While depending on ACPI 1.0b behavior might be somewhat risky,
returning the same value for _SUN multiple times, for slots of
the same type, definitely seems non-compliant.

What is your opinion?

> P.S. None of the slots except the strange slot named '1023'
> were detected with your patch. It would happen on other
> machines (might including hp machine) too. The reason is _STA
> evaluation fails on the hotplug slot which doesn't have _STA
> method. If the device object doesn't have a _STA method, we
> need to handle it as if it is present. 

Thanks for this explanation about treating non-present _STA as
present. It makes sense.

> I believe firmware normally doesn't provide _STA method for PCI
> hotplug slots.

I somewhat disagree that firmware doesn't normally provide _STA
for PCI hotplug slots, but I think that is a side-issue. :)

Thanks.

/ac

