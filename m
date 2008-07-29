Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYG2CqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYG2CqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYG2Cpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:45:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43254 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYG2Cpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:45:54 -0400
Message-ID: <488E83E9.6030108@jp.fujitsu.com>
Date: Tue, 29 Jul 2008 11:43:53 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807251518.53462.jbarnes@virtuousgeek.org> <488D86EC.1010903@jp.fujitsu.com> <200807280916.44664.jbarnes@virtuousgeek.org>
In-Reply-To: <200807280916.44664.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, July 28, 2008 1:44 am Kenji Kaneshige wrote:
>> Jesse Barnes wrote:
>>> I think that's fine (automatically creating duplicate devices with names
>>> to differentiate them), but I think we should also try harder to avoid
>>> adding duplicates.
>>>
>>> In Pierre's case, and on my T61, there's only one actual hotplug slot
>>> available, but the firmware creates duplicate physical slot numbers and
>>> sets the HP_CAP bit on everything, both of which are obviously wrong
>>> (well I suppose you could pop these chips off the board, but it's not
>>> very practical).  However, afaict that "other" OS uses the _RMV method to
>>> determine whether a given slot is actually hot pluggable.  On my T61 at
>>> least, this seems to be accurate: only one of my EXP* objects has a _RMV
>>> method.
>>>
>>> So maybe the PCIe hotplug driver should be checking for that method when
>>> ACPI is available?  We already try to use _OSC etc., so checking for _RMV
>>> first would make sense...
>> As you pointed out, the root cause might not a problem of slot naming,
>> but a problem of slots detection, because pciehp driver detects multiple
>> PCIe hotplug slots even thought your and Pierre's system seems to have
>> only one hotplug slot. So I think we should also consider the problem
>> from this view point (slot detection).
>>
>> But, I think simply checking for _RMV method first is dangerous because
>> I think there are many systems that doesn't implement _RMV for PCIe
>> hotplug slots (at least, my system doesn't implement that. Anyway,
>> I would like to look at the documents/specifications that mention _RMV
>> method for determining whether a given slot is hot pluggable. Do you
>> have any information about that? I think PCI Local Bus, PCI Express and
>> PCI Firmware specification don't mention that. I think hot pluggable slots
>> on your, Pierre's and Matthew's system are ExpressCard slots. So I guess
>> ExpressCard specification might define something about this. But
>> unfortunately, I don't have ExpressCard specification. Can anyone access
>> ExpressCard spec?
> 
> Your systems don't have _RMV methods for the hotpluggable PCIe slots in the 
> DSDT?  That's a shame; the Windows docs I found on PCIe hotplug seemed to 
> indicate that _RMV and _OSC (under Vista) were used to detect whether a given 
> slot was hot pluggable (I just googled for "windows pcie hotplug" or 
> something) so I was hoping that would be a reliable method...  Any other 
> ideas?  I'll go see if I can dig up some ExpressCard info.
> 

My systems don't have _RMV methods for the hot pluggable PCIe slots in the
DSDT, but I don't think that's a shame. I suppose that the document you are
referring describes how Windows handles ExpressCard slots. In my
understanding, Hot Plug Surprise bit in the Slot Capabilities register is
set to 1b on ExpressCard slots, and I believe that ACPI _RVM method is for
the device that only supports surprise-style removal. I think this is why
your system implements _RMV method for slots.

On the other hand, hot pluggable slots on my servers are *not* ExpressCard
slots, and all of them have Power Controller instead of surprise-style
removal (Hot Plug Surprise bit in the Slot Capabilities register is set to
0b). So I believe there is no reason to implement _RMV methods for the hot
pluggable PCIe slots on my systems.

Here is an idea. How about using _RMV method to determine whether a given
slot is actually hot pluggable when Hot Plug Surprise bit in the Slot
Capabilities register is set to 1b on the slot? This is based on a little
rough assumption that all PCIe slots that support surprise-style removal
have _RMV method, though. Does this work for you?

Thanks,
Kenji Kaneshige

