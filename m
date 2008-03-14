Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYCNFmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYCNFmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYCNFly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:41:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45517 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYCNFlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:41:53 -0400
Message-ID: <47DA0E77.9010706@jp.fujitsu.com>
Date: Fri, 14 Mar 2008 14:34:47 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>, Alex Chiang <achiang@hp.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
References: <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com> <20080311110403.7db9527c@appleyard> <20080311191406.GB29344@ldl.fc.hp.com> <47D7BF6C.3080306@jp.fujitsu.com> <20080313032410.GA17561@ldl.fc.hp.com> <20080314021646.GC6145@us.ibm.com>
In-Reply-To: <20080314021646.GC6145@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex-san, Gary-san and Kristen-san,

Thank you for your explanation.

Ok, I understood what you mean and I agreed both implementations
are legal. Also I explained it to our firmware team, and they
understood your situation.

I don't know which implementation is more popular. But according
to the current score (2 : 1), you win the "majority rule".

Alex-san, could you send me the updated patches? I'll Ack the
patch after adding Fujitsu firmware versions to the DMI list
and testing it.

Kristen-san, as I told you in another thread, we might need
a same fix for acpiphp driver. I'll check it and send the patch.

Thanks,
Kenji Kaneshige



Gary Hade wrote:
> Hi Alex/Kenji-san,
> 
> Time for my 2 cents.
> 
> On Wed, Mar 12, 2008 at 09:24:10PM -0600, Alex Chiang wrote:
>> Hi Kenji-san,
>>
>> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>> Hi Alex-san,
>>>
>>>> On my machine, it is legal to evaluate S1F0._SUN independent of
>>>> S1F0._STA because L001._INI has already been evaluated.
>>>> It would be helpful to know what Fujitsu's namespace looks like.
>>>> If Fujitsu slot objects contain _STA and _INI, then I agree with
>>>> Kenji-san -- I definitely need to check _STA before evaluating
>>>> _SUN.
>>> Thank you for explanation. Maybe I understood the summary of
>>> implementation of HP firmware. But how to use or where to put _INI
>>> method in the ACPI namespace never becomes reasonable reason why
>>> your driver may ignore _STA before evaluating _SUN.
>>>
>>>> But in any case, I think both HP and Fujitsu firmware are doing
>>>> legal things -- neither firmware is breaking the spec.
>>> My understanding of your explanation so far is:
>>>
>>> - evaluating _SUN without checking _STA doesn't cause problem,
>>>  from the view point of HP's implementation.
>>> - some IBM machine is doing same as HP
>>>
>>> I never think those are reasonable reasons why ignoring _STA
>>> before evaluating _SUN is legal. Am I missing something?
>> I think the piece that I did not explain clearly is that the spec
>> does not require checking _STA immediately before _SUN. The spec
>> says: 
>>
>> 	- you must check _STA before calling _INI
> Agreed. 
> 
>> 	- _INI must be called to initialize _SUN
> Based on my review of ACPI spec 3.0b I would add:
>   1. For a specific device that has only _STA and _SUN methods,
>      _SUN can be run and it's results can be trusted irrespective
>      of the _STA return value.
>   2. For a specific device that has _STA, _INI, and _SUN methods,
>      _SUN can be run and it's results can be trusted even if
>     _INI is not run because the device is absent.  If the device
>     is present and _INI is run then _SUN cannot be run until
>     after _INI is run.
> 
>   See ACPI spec 3.0b "6.1.8 _SUN (Slot User Number)" which
>   says nothing about a required presence of the device.
> 
>> 	- _INI is called once, when the table is loaded
> Agreed.
> 
>> On HP's implementation, we do obey those rules. We call _INI on
>> the PCI bridge during boot, which then initializes the children
>> SxFy objects. From that point on, it is legal for us to call
>> _SUN.
>>
>> The other issue is that the spec does not specify the *semantics*
>> of _STA. P/IBM firmware engineers think _STA should indicate card
>> presence, 
> 
> I checked this on the IBM x3850 and it appears to be true.  I 
> instrumented register_slot() in drivers/pci/hotplug/acpiphp_glue.c
> to print _STA and _SUN returns and got the following results with
> slot 1 (PCI-X) populated, slot 2 (PCI-X) vacant, slot 3 (PCIe) vacant,
> slot 4 (PCIe) populated, slot 5 (PCIe) vacant, and slot 6 (PCIe)
> populated.  When a card is present _STA returns non-zero status
> for all functions, otherwise it returns zero.  None of the SxFy
> devices have an _INI method.
> 
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> acpiphp_glue: found PCI host-bus bridge with hot-pluggable slots
> acpiphp_glue: register_slot: \_SB_.VP02.S1F0 sta=0 sun=1
> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:02:01
> acpiphp: Slot [1] registered
> acpiphp_glue: register_slot: \_SB_.VP02.S1F1 sta=0 sun=1
> acpiphp_glue: register_slot: \_SB_.VP02.S1F2 sta=0 sun=1
> acpiphp_glue: register_slot: \_SB_.VP02.S1F3 sta=0 sun=1
> acpiphp_glue: register_slot: \_SB_.VP02.S1F4 sta=0 sun=1
> acpiphp_glue: register_slot: \_SB_.VP02.S1F5 sta=0 sun=1
> acpiphp_glue: register_slot: \_SB_.VP02.S1F6 sta=0 sun=1
> acpiphp_glue: register_slot: \_SB_.VP02.S1F7 sta=0 sun=1
> acpiphp_glue: found PCI host-bus bridge with hot-pluggable slots
> acpiphp_glue: register_slot: \_SB_.VP03.S2F0 sta=f sun=2
> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:06:01
> acpiphp: Slot [2] registered
> acpiphp_glue: register_slot: \_SB_.VP03.S2F1 sta=f sun=2
> acpiphp_glue: register_slot: \_SB_.VP03.S2F2 sta=f sun=2
> acpiphp_glue: register_slot: \_SB_.VP03.S2F3 sta=f sun=2
> acpiphp_glue: register_slot: \_SB_.VP03.S2F4 sta=f sun=2
> acpiphp_glue: register_slot: \_SB_.VP03.S2F5 sta=f sun=2
> acpiphp_glue: register_slot: \_SB_.VP03.S2F6 sta=f sun=2
> acpiphp_glue: register_slot: \_SB_.VP03.S2F7 sta=f sun=2
> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:0a:00.0
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F0 sta=0 sun=3
> acpiphp_glue: found ACPI PCI Hotplug slot 3 at PCI 0000:0b:00
> acpiphp: Slot [3] registered
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F1 sta=0 sun=3
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F2 sta=0 sun=3
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F3 sta=0 sun=3
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F4 sta=0 sun=3
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F5 sta=0 sun=3
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F6 sta=0 sun=3
> acpiphp_glue: register_slot: \_SB_.VP04.CALG.E3F7 sta=0 sun=3
> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:0f:00.0
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F0 sta=f sun=4
> acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
> acpiphp: Slot [4] registered
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F1 sta=f sun=4
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F2 sta=f sun=4
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F3 sta=f sun=4
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F4 sta=f sun=4
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F5 sta=f sun=4
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F6 sta=f sun=4
> acpiphp_glue: register_slot: \_SB_.VP05.CALG.E4F7 sta=f sun=4
> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:14:00.0
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F0 sta=0 sun=5
> acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
> acpiphp: Slot [5] registered
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F1 sta=0 sun=5
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F2 sta=0 sun=5
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F3 sta=0 sun=5
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F4 sta=0 sun=5
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F5 sta=0 sun=5
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F6 sta=0 sun=5
> acpiphp_glue: register_slot: \_SB_.VP06.CALG.E5F7 sta=0 sun=5
> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:19:00.0
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F0 sta=f sun=6
> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:1a:00
> acpiphp: Slot [6] registered
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F1 sta=f sun=6
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F2 sta=f sun=6
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F3 sta=f sun=6
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F4 sta=f sun=6
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F5 sta=f sun=6
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F6 sta=f sun=6
> acpiphp_glue: register_slot: \_SB_.VP07.CALG.E6F7 sta=f sun=6
> acpiphp_glue: Bus 0000:1a has 1 slot
> acpiphp_glue: Bus 0000:15 has 1 slot
> acpiphp_glue: Bus 0000:10 has 1 slot
> acpiphp_glue: Bus 0000:0b has 1 slot
> acpiphp_glue: Bus 0000:06 has 1 slot
> acpiphp_glue: Bus 0000:02 has 1 slot
> acpiphp_glue: Total 6 slots
> 
>> but Fujitsu firmware engineers think _STA should
>> indicate slot presence.
>>
>> I don't think either firmware team is incorrect -- it is simply
>> the case that the specification was not precise enough, to the
>> point where separate teams following the same spec came up with
>> implementations with different behaviors and different semantics.
>>
>> I believe that we both have compliant, legal firmware.
>>
>>>> If one list is shorter than the other, then that should be the
>>>> list to put in the kernel, and the default behavior should be
>>>> "majority rule".
>>> I don't want to consider "majority rule" before I understand why
>>> ignoring _STA is legal.
>> On HP and IBM machines, it *is* legal because we *did* call _STA,
>> then _INI, then _SUN. That is one interpretation of the spec.
>>
>> On Fujitsu machines, the semantics of _STA are different, and it
>> is not legal to ignore _STA. That is another interpretation of
>> the spec.
> 
> I am not convinced that this a correct interpretation.  I believe
> that the ACPI spec indicates that it is legal to call _SUN and
> trust it's results no matter what _STA returns.  I believe the
> only constraint on running _SUN is that it be run after _INI is run
> if _INI exists for the same device and _STA for that device
> indicates that it should be run.
> 
> Gary
> 


