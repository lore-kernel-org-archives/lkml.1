Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbXLJXCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbXLJXCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXLJXC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:02:26 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:10022 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbXLJXCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:02:25 -0500
Date: Mon, 10 Dec 2007 16:02:22 -0700
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: pcihpd-discuss@lists.sourceforge.net, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071210230222.GA16573@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	pcihpd-discuss@lists.sourceforge.net,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <474E6E82.40307@jp.fujitsu.com> <20071130015105.GH24707@ldl.fc.hp.com> <4753786F.1040703@jp.fujitsu.com> <20071203224331.GA29227@ldl.fc.hp.com> <47554EBD.1090106@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47554EBD.1090106@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

I have been thinking about this problem for quite a bit, and
think that there are no good solutions...

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>>>> On my system, hotplug slots themselves can be added, removed
>>>>> and replaced with the ohter type of I/O box. 
>> Are you talking about some sort of I/O cabinet/chassis that you
>> can attach to the actual computer? Can the I/O expander unit be
>> hotplugged? Or do you need to power your machine down to attach
>> it?
>> If you can hotplug it, I'm guessing that is why your firmware
>> presents SxFy objects in the namespace with "weird" _SUN values,
>> and it's why you have to check _STA to see if the slots are valid
>> or not. That means the value returned by _SUN will change too,
>> right? What will it turn into?
>>
>
> Currently, it's not hotpluggable (will be hotpluggable in the future).
> Here is a sample AML code to explain what my firmware is doing.
>
> Device (PCI0) {
> 	Device (P2PA) {
> 		Device (P2PB) {	// for I/O unit (A)
> 			Name (_ADR, ...)
> 			Method (_STA) { ... }
> 		}
> 		Device (S0F0) {	// for I/O unit (B)
> 			Name (_ADR, ...)
> 			Method (_STA) { ... }
> 			Method (_EJx) { ... }
> 			Method (_SUN) { ... }
> 		}
> 		...
> 	}
> 	...
> }
>
> If the I/O unit (A) is connected, _STA of P2PB returns as present
> and _STA of S0F0 returns as not present.
> If the I/O unit (B) is connected, _STA of P2PB returns as not
> present and _STA of S0F0 returns as present.

If I/O unit A or B can never appear while the system is turned on
(aka not hotpluggable), then it is incorrect to present them in
the current namespace. 

>>> In addtion, I think we should not trust the _SUN value of
>>> non-existing device because the ACPI spec says in "6.5.1 _INI
>>> (Init)" that _INI method is run before _ADR, _CID, _HID, _SUN, and
>>> _UID are run. It means _SUN could be initialized in _INI method
>>> implecitely. And it also says that "If the _STA method indicates
>>> that the device is not present, OSPM will not run the _INI and will
>>> not examine the children of the device for _INI methods.". After all,
>>> _SUN for non-existing device is not reliable because it might not
>>> initialized by _INI method.
>> This is true, but HP platforms provide _INI at the root
>> device/host bridge level, not on SxFy objects, so it doesn't seem
>> that we would need to call _STA before calling _SUN for SxFy.
>> Does your firmware provide _INI on SxFy objects?
>
> No, it doesn't. But what I wanted to say was we should not use _SUN
> value of non-existing device object.

There is nothing illegal about evaluating _SUN for an object that
returns 0x0 for _STA. 

Also, when you say "non-existing", I think of the ACPI CA
exception code AE_NOT_EXIST which means "absent from
the namespace", and is the reason why my code works on both HP
and IBM machines. It does not mean "_STA == 0x0".

>> Our firmware teams seem to think that _STA should give the status
>> of the card for hotplug support and general functional state.
>> They claim that it doesn't makes much sense to support _STA on
>> the slot itself unless you can physically change the slot
>> topology on the machine at runtime, which we can't do (although
>> maybe you can).
>> The section of the spec you quoted is correct as long as we are
>> talking ACPI 2.0 or later. My platforms implement ACPI 1.0b for
>> legacy reasons. :-/
>> In ACPI 1.0b, _EJx definition says (section 6.3.2):
>> 	For hot removal, the device must be immediately ejected
>> 	when the OS calls the _EJ0 control method. The _EJ0
>> 	control method does not return until ejection is
>> 	complete. After calling _EJ0, the OS will call _STA to
>> 	determine whether or not the eject succeeded.
>> So your firmware implementation does not seem backward compatible
>> with the 1.0b spec. The different versions of ACPI is part of the
>> reason why my patch is breaking on your machine.
>
> I think this is the real reason. My platform implements ACPI 2.0 or
> later. I didn't notice the chage to_EJx definition. Maybe we need to
> check ACPI version in pci_slot driver.

I did some experiments on HP low-end ia64 (ACPI 1.0b only) and
our mid-range and high-end ia64 platforms (ACPI 2.0c). Checking
for _STA before evaluating _SUN leads to the same result for me:
we only detect populated slots.

I think that the real issue is not 1.0 vs 2.0, but the semantics
that our different firmware teams have placed on _STA. Again,

  - HP firmware thinks _STA should give status of the card
  - Fujitsu firmware thinks _STA should give status of the slot

So we are at an impasse. :(

>> But as long as we are quoting the spec...  :)
>> 	_SUN evaluates to a DWORD that is the number to be used
>> 	in the user interface. This number is required to be
>> 	unique among the slots of the same type. It is also
>> 	recommended that this number match the slot number
>> 	printed on the physical slot whenever possible.
>> 	section 6.1.6 of ACPI 2.0c
>> My question is, why is your firmware returning multiple values of
>> 1023 then? This seems to be the real reason why my patch is
>> breaking on your machine.
>> While depending on ACPI 1.0b behavior might be somewhat risky,
>> returning the same value for _SUN multiple times, for slots of
>> the same type, definitely seems non-compliant.
>
> The reason is very simple. The reason is your patch is evaluating
> invalid _SUN method. We must skip non-existing device object. This
> is what your patch is already doing for pci root bridges.
> In addition, even if those _SUN method were changed to return unique
> number, none of the problems would be solved. Maybe pci_slot driver
> would detect many unknown slots.

I did some experiments to see if I could write a quick hack, like

  - do not register a slot if we've already seen this _SUN

But it broke my reference counting, and I don't think it would be
robust enough if users wanted to modprobe/rmmod pci_slot and
acpiphp/pciehp in random order.

I do not agree that _SUN should return a repeating, non-compliant
value even if _STA says the device is not present. A truly
non-existent device is one that does not appear in the namespace.
If you cannot hotplug an I/O unit on your machine, then your
firmware shouldn't be presenting those devices in the namespace.

I think the best option would be for your firmware to return the
actual value of _SUN if I/O unit A and/or B was plugged in. That
way, nothing special has to happen when the units are hotplugged
-- they'll already have correct entries in sysfs. If they are
never hotplugged, it shouldn't be confusing for the user, since
they will never actually get any devices in those slots anyway.

What happens if you try to load acpiphp on your system today?
Does it work, or do you get the same messages about trying to
create multiple entries in sysfs with the same name?

Do you have any better ideas for detecting all physical slots in
a system, regardless of whether they are populated?

Thanks.

/ac

