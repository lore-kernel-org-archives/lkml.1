Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXD2BYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXD2BYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXD2BYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:24:07 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26533 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXD2BYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:24:04 -0400
Date: Sat, 28 Apr 2007 19:22:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI Express MMCONFIG and BIOS Bug messages..
In-reply-to: <46279358.1010002@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Message-id: <4633F363.4000009@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <4626C514.5010605@shaw.ca> <46279358.1010002@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Robert Hancock wrote:
>> I've seen a lot of systems (including brand new Xeon-based servers from
>> IBM and HP) that output messages on boot like:
>>
>> PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
>> PCI: Not using MMCONFIG.
>>
>>
>> So Microsoft is explicitly telling the BIOS developers that there is no
>> need to reserve the MMCONFIG space in the E820 table because Windows
>> doesn't care. On that basis it doesn't seem like a valid check to
>> require it to be so reserved, then.
>>
>> Really, I think we should be basing this check on whether the
>> corresponding memory range is reserved in the ACPI resources, like
>> Windows expects. This does require putting more fingers into ACPI from
>> this early boot stage, though..
>>
> 
> Intel had posted patches to do exactly that, but they were rejected.
> I don't remember why now...

I tried adapting a patch by Rajesh Shah to do this for current kernels:

http://lkml.org/lkml/2006/6/23/365

It walks through all the motherboard resource devices and tries to pull 
out the resource settings for all of them using the _CRS method. 
(Depending on how you do the probing, the _STA method is called as well, 
either before or after.) From my limited ACPI knowledge, the problem is 
that the PCI MMCONFIG initialization is called before the main ACPI 
interpreter is enabled, and these control methods may try to access 
operation regions who don't have handlers set up for them yet, so a 
bunch of "no handler for region" errors show up.

I think some earlier version of this patch was in -mm for a while back 
in 2.6.18 times, I actually complained about it back then because it 
falsely detected the region wasn't reserved on my system since it bailed 
out on the first such error before it found the reservation. On my 
system it turns out that the device called EXPL that has the MCFG table 
reservation in it has the addresses statically defined in the _CRS 
method and doesn't need to access any regions, so if you make the search 
continue on after errors, it does actually work, but there's probably no 
guarantee that all systems will have the MCFG reservation statically 
defined like this, and we can't have all those ACPI errors from other 
devices clogging the logs either.

So essentially if we want to do this check based on ACPI resource 
reservations, we need to be able to execute control methods at the point 
that MMCONFIG is set up. Is there a reason why this can't be made 
possible (like by moving the necessary parts of ACPI initialization 
earlier)?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


