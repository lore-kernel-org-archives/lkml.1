Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbXLDNDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbXLDNDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXLDNDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:03:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50649 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXLDNDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:03:05 -0500
Message-ID: <47554EBD.1090106@jp.fujitsu.com>
Date: Tue, 04 Dec 2007 21:57:33 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       pcihpd-discuss@lists.sourceforge.net, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <474E6E82.40307@jp.fujitsu.com> <20071130015105.GH24707@ldl.fc.hp.com> <4753786F.1040703@jp.fujitsu.com> <20071203224331.GA29227@ldl.fc.hp.com>
In-Reply-To: <20071203224331.GA29227@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

> Hi Kenji-san,
> 
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Hi Alex-san,
>>
>>>> On my system, hotplug slots themselves can be added, removed
>>>> and replaced with the ohter type of I/O box. 
> 
> Are you talking about some sort of I/O cabinet/chassis that you
> can attach to the actual computer? Can the I/O expander unit be
> hotplugged? Or do you need to power your machine down to attach
> it?
> 
> If you can hotplug it, I'm guessing that is why your firmware
> presents SxFy objects in the namespace with "weird" _SUN values,
> and it's why you have to check _STA to see if the slots are valid
> or not. That means the value returned by _SUN will change too,
> right? What will it turn into?
>

Currently, it's not hotpluggable (will be hotpluggable in the future).
Here is a sample AML code to explain what my firmware is doing.

Device (PCI0) {
	Device (P2PA) {
		Device (P2PB) {	// for I/O unit (A)
			Name (_ADR, ...)
			Method (_STA) { ... }
		}
		Device (S0F0) {	// for I/O unit (B)
			Name (_ADR, ...)
			Method (_STA) { ... }
			Method (_EJx) { ... }
			Method (_SUN) { ... }
		}
		...
	}
	...
}

If the I/O unit (A) is connected, _STA of P2PB returns as present
and _STA of S0F0 returns as not present.
If the I/O unit (B) is connected, _STA of P2PB returns as not
present and _STA of S0F0 returns as present.

>> In addtion, I think we should not trust the _SUN value of
>> non-existing device because the ACPI spec says in "6.5.1 _INI
>> (Init)" that _INI method is run before _ADR, _CID, _HID, _SUN, and
>> _UID are run. It means _SUN could be initialized in _INI method
>> implecitely. And it also says that "If the _STA method indicates
>> that the device is not present, OSPM will not run the _INI and will
>> not examine the children of the device for _INI methods.". After all,
>> _SUN for non-existing device is not reliable because it might not
>> initialized by _INI method.
> 
> This is true, but HP platforms provide _INI at the root
> device/host bridge level, not on SxFy objects, so it doesn't seem
> that we would need to call _STA before calling _SUN for SxFy.
> 
> Does your firmware provide _INI on SxFy objects?

No, it doesn't. But what I wanted to say was we should not use _SUN
value of non-existing device object.

> 
> Our firmware teams seem to think that _STA should give the status
> of the card for hotplug support and general functional state.
> They claim that it doesn't makes much sense to support _STA on
> the slot itself unless you can physically change the slot
> topology on the machine at runtime, which we can't do (although
> maybe you can).
> 
> The section of the spec you quoted is correct as long as we are
> talking ACPI 2.0 or later. My platforms implement ACPI 1.0b for
> legacy reasons. :-/
> 
> In ACPI 1.0b, _EJx definition says (section 6.3.2):
> 
> 	For hot removal, the device must be immediately ejected
> 	when the OS calls the _EJ0 control method. The _EJ0
> 	control method does not return until ejection is
> 	complete. After calling _EJ0, the OS will call _STA to
> 	determine whether or not the eject succeeded.
> 
> So your firmware implementation does not seem backward compatible
> with the 1.0b spec. The different versions of ACPI is part of the
> reason why my patch is breaking on your machine.
> 

I think this is the real reason. My platform implements ACPI 2.0 or
later. I didn't notice the chage to_EJx definition. Maybe we need to
check ACPI version in pci_slot driver.

> But as long as we are quoting the spec...  :)
> 
> 	_SUN evaluates to a DWORD that is the number to be used
> 	in the user interface. This number is required to be
> 	unique among the slots of the same type. It is also
> 	recommended that this number match the slot number
> 	printed on the physical slot whenever possible.
> 
> 	section 6.1.6 of ACPI 2.0c
> 
> My question is, why is your firmware returning multiple values of
> 1023 then? This seems to be the real reason why my patch is
> breaking on your machine.
> 
> While depending on ACPI 1.0b behavior might be somewhat risky,
> returning the same value for _SUN multiple times, for slots of
> the same type, definitely seems non-compliant.
> 

The reason is very simple. The reason is your patch is evaluating
invalid _SUN method. We must skip non-existing device object. This
is what your patch is already doing for pci root bridges.
In addition, even if those _SUN method were changed to return unique
number, none of the problems would be solved. Maybe pci_slot driver
would detect many unknown slots.

Thanks,
Kenji Kaneshige


