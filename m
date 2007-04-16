Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXDPV3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXDPV3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbXDPV3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:29:07 -0400
Received: from smtp-4.hut.fi ([130.233.228.94]:52532 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXDPV3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:29:06 -0400
Date: Tue, 17 Apr 2007 00:28:31 +0300 (EEST)
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: Andi Kleen <andi@firstfloor.org>
cc: clemens@ladisch.de, bob.picco@hp.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
In-Reply-To: <p734png6s1t.fsf@bingen.suse.de>
Message-ID: <Pine.OSF.4.64.0704162337320.487506@kosh.hut.fi>
References: <1176708094.22969.7.camel@dual.local> <p734png6s1t.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 16 Apr 2007, Andi Kleen wrote:

> Mikko Tiihonen <mikko.tiihonen@iki.fi> writes:
>
>> It looks probable that most NVidia chipsets have the HPET address at
>> 0x44. It might be possible to enable the HPET even if BIOS did not
>
> That seems like a dangerous assumption. If anything this needs to  be keyed
> on specific PCI IDs.

The patch contains a list of PCI IDs. Currently the CK804 and MCP55 have been
verified to work. Other PCI IDs can be added if needed.

> And the way you coded a recursive PCI scan is just .... <looking for words, censoring
> some that come to mind first> ... not nice.

I actually was more worried that someone might complain that the pci scanning 
is copy & paste code from end of the same file. I did try to use the generic 
pci functions first but because they insist on enabling interrupts they cannot 
be used this early. And this code needs to be run before the timer 
initialization.

If you want I can submit a separate patch to move the ... not nice pci 
scanning code to pci directory under some early_pci_scan(u32 *pci_ids, hook) 
function. The same code was already cut&pasted in 
i386/kernel/acpi/earlyquik.c, in x86_64/kernel/aperture.c and in 
x86_64/kernel/early-quirks.c. Moving the uglyness to a central place would at 
least hide it from the casual browser. Or would a global flag that the pci
scanning code checks to see if locks should be used or not be better?

>> initialize it properly by writing the wanted address there. Some other
>> pci config space bits might need to be fiddled around too, most likely
>> candidates are 0x74 bit 2 and 0xA3 bit ?. One or both of them have been
>> identified to change in some motherboards when HPET is enabled/disabled
>> in BIOS.
>
> Or just add a random generator and poke random bits? Should be roughly
> equivalent.

Fair enough, that was just my written hope that some day someone might reverse 
engineer how HPET is enabled on NVidia chipsets. The patch does not try write 
to any registers so it should be safe? The code also properly checks that the
memory area does not collide with any existing resource. I could of course add
a check that there is a HPET at that address, but the hpet driver already 
checks it itself later and disabled itself it cannot see valid data.

> Also there should be done anything here without confirmation from
> Nvidia that HPET is actually supposed to work. Sometimes hardware
> is disabled by BIOS because it is seriously broken (there was at least
> one other chipset that could corrupt your flash if you force enabled
> HPET in some steppings)

I hope someone has some secret contacts at NVidia because they have not been 
very open with their chipsets. I looked at LinuxBios and their NForce4 chipset 
code had just had commented out code that wrote to 0x44 register. So obviously 
something more is needed.

Even Intel just posted code a while ago that allows enabling HPET from a quirk 
even if BIOS did not set it up properly.


Does anyone know how to _really_ test if HPET works properly (from user space 
for example). I've just tested with busylooping gettimeofday while changing 
the clocksource and measured the speed difference. We could then change the 
quirk to point to instructions on how to test the HPET manually and then 
request to submit the PCI ID.

-Mikko
