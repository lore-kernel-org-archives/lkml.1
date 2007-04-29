Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbXD2Ske@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbXD2Ske (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031066AbXD2Ske
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:40:34 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:6629 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800AbXD2Sk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:40:26 -0400
Date: Sun, 29 Apr 2007 12:39:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI Express MMCONFIG and BIOS Bug messages..
In-reply-to: <200704291127.21263.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <ak@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Message-id: <4634E64D.7030206@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <4626C514.5010605@shaw.ca> <200704291212.03171.ak@suse.de>
 <4634E1F8.5000806@shaw.ca> <200704291127.21263.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Sunday, April 29, 2007, Robert Hancock wrote:
>> Problem is that even if we read the MMCONFIG table location from the
>> hardware registers, that doesn't mean we can trust the result. It could
>> be that the BIOS hasn't lied about where it put the table, it just stuck
>> it someplace completely unsuitable like on top of RAM or other
>> registers. It seems that with some of those 965 chipsets the latter is
>> what the BIOS is actually doing, and so when we think we're writing to
>> the table we're really writing to random chipset registers and hosing
>> things. (Jesse Barnes ran into this while trying to add chipset support
>> for the 965).
> 
> Right, I've updated the BIOS since, but at least that version was totally 
> buggy wrt MMconfig support.  I haven't yet looked at the new one to see if 
> it properly reserves MCFG space in ACPI _CRS yet or properly programs it.
> 
>> Likely what we need to do is:
>>
>> -If chipset is known, take table address from registers, otherwise check
>> the MCFG table
>> -Take the resulting area (Ideally not just the first minimum part as we
>> check now, but the full area based on the expected length) and make sure
>> that the entire area is covered by a reservation in ACPI motherboard
>> resources.
>> -If that passes, then we still need to sanity check the result by making
>> sure it hasn't been mapped over top of something else important. How to
>> do this depends on exactly how they've set up the ACPI reservations on
>> these broken boxes.. Does someone have a full dmesg from one on a recent
>> kernel that shows all the pnpacpi resource reservation output?
>> -If these checks fail, we don't use the table, and the chipset is known,
>> we should likely try to disable decoding of the region so that it won't
>> get in the way of anything else.
> 
> Yeah, that sounds like a good algorithm.
> 
> I'm not sure how to handle the fact that we don't have access to the _CRS 
> until late in boot though...  Len?

We'd likely have to split the MMCONFIG initialization into two parts. 
The early part enables MMCONFIG only on systems where we require it 
(like the Macs that Andi mentioned). On all other systems we defer 
enabling it (use the regular PCI configuration mechanism) until the 
second part, after the ACPI interpreter is enabled, where we can poke 
around in ACPI and verify the table is suitable.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

