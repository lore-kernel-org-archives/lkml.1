Return-Path: <linux-kernel-owner+w=401wt.eu-S1030959AbXD2SUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030959AbXD2SUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030951AbXD2SUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:20:49 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8097 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030840AbXD2SUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:20:47 -0400
Date: Sun, 29 Apr 2007 12:20:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI Express MMCONFIG and BIOS Bug messages..
In-reply-to: <200704291212.03171.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Message-id: <4634E1F8.5000806@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <4626C514.5010605@shaw.ca> <46279358.1010002@redhat.com>
 <4633F363.4000009@shaw.ca> <200704291212.03171.ak@suse.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I tried adapting a patch by Rajesh Shah to do this for current kernels:
> 
> The Intel patches checked against ACPI which also didn't work in all cases.
> 
> You're right the e820 check is overzealous and has a lot of false positives,
> but it is the only generic way we know right now to handle a common i965 BIOS
> bug. Also there is the nasty case of the Apple EFI boxes where only mmconfig
> works which has to be handled too.
> 
> I expect eventually the logic to be:
> 
> - If we know the hardware: read it from hw registers; trust them; ignore BIOS.
> - Otherwise check e820 and ACPI resources and be very trigger happy at not using
> it

Problem is that even if we read the MMCONFIG table location from the 
hardware registers, that doesn't mean we can trust the result. It could 
be that the BIOS hasn't lied about where it put the table, it just stuck 
it someplace completely unsuitable like on top of RAM or other 
registers. It seems that with some of those 965 chipsets the latter is 
what the BIOS is actually doing, and so when we think we're writing to 
the table we're really writing to random chipset registers and hosing 
things. (Jesse Barnes ran into this while trying to add chipset support 
for the 965).

Likely what we need to do is:

-If chipset is known, take table address from registers, otherwise check 
the MCFG table
-Take the resulting area (Ideally not just the first minimum part as we 
check now, but the full area based on the expected length) and make sure 
that the entire area is covered by a reservation in ACPI motherboard 
resources.
-If that passes, then we still need to sanity check the result by making 
sure it hasn't been mapped over top of something else important. How to 
do this depends on exactly how they've set up the ACPI reservations on 
these broken boxes.. Does someone have a full dmesg from one on a recent 
kernel that shows all the pnpacpi resource reservation output?
-If these checks fail, we don't use the table, and the chipset is known, 
we should likely try to disable decoding of the region so that it won't 
get in the way of anything else.

The current check we have really should go, though. It only excludes 
these broken chipsets based on luck, not on anything that is guaranteed, 
and ends up disabling the table on systems where it's perfectly functional.

> 
>> It walks through all the motherboard resource devices and tries to pull 
>> out the resource settings for all of them using the _CRS method. 
> 
> I tested it originally on a Intel system with the above BIOS problem
> and it didn't help there.
> 
>> (Depending on how you do the probing, the _STA method is called as well, 
>> either before or after.) From my limited ACPI knowledge, the problem is 
>> that the PCI MMCONFIG initialization is called before the main ACPI 
>> interpreter is enabled, and these control methods may try to access 
>> operation regions who don't have handlers set up for them yet, so a 
>> bunch of "no handler for region" errors show up.
> 
> mmconfig access can be switched later without problems; so it would
> be possible to boot using Type1 if it works (e.g. detect the Apple case) 
> and switch later.
> 
> It's all quite tricky unfortunately; that is why i left it at the current
> relatively safe state for now. After all mmconfig is normally not needed.
> 
>> So essentially if we want to do this check based on ACPI resource 
>> reservations, we need to be able to execute control methods at the point 
>> that MMCONFIG is set up. Is there a reason why this can't be made 
>> possible (like by moving the necessary parts of ACPI initialization 
>> earlier)?
> 
> ACPI Interpreter wants to allocate memory and use other kernel services that
> are not available in really early boot. It could be probably done somehow,
> but would be quite ugly with lots of special cases.

Yeah, if we can do this part of MMCONFIG initialization later that would 
likely be a better solution.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


