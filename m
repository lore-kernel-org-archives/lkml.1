Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZBUTI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZBUTI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZBUTIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:08:20 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:60189 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZBUTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:08:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KpY79Pb2OkyDMG0fl5iIRupde1Jv7mKq/C2WELKVBvnZmlo1jHkQShMAVwV39vzboy
         7sKGROKfhPt8htqcyE4NCtuUsQJKmWsGUOXkTHLyd/UyFFKqPKsu0jwyJKLhWlPiofp7
         TXmy90GWAN6vK0SxHEZUsJY7vmAVDXnzmD9WU=
Message-ID: <49A0511F.1010509@gmail.com>
Date: Sat, 21 Feb 2009 13:08:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Mr. Berkley Shands" <bshands@exegy.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: AMD 8132 parity issue causes interrupt storms
References: <499F1729.9010700@exegy.com> <499F4E56.4050305@gmail.com> <499F6468.3080907@exegy.com> <49A050BF.4080904@gmail.com>
In-Reply-To: <49A050BF.4080904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Mr. Berkley Shands wrote:
>> I am certainly not doing that :-)
>> Some supermicro H8QME-2 motherboards (about 40%) show up with that 
>> enabled.
>> Something generates a parity error, and the machine is instantly on 
>> its knees until it gets power cycled.
>>
>> My thought was to look and report that parity was being enabled (bios 
>> bug?)
> 
> That would be a BIOS bug then, if it sets the parity interrupts enabled 
> by default. If the OS installs a driver to handle those interrupts, the 
> driver can enable them, otherwise they should stay off.
> 
> We could probably create a PCI quirk for this chip that would disable 
> the parity interrupts on bootup if it found them enabled.. CCing linux-pci.

Really ccing linux-pci, this time..

> 
>>
>> I can fix it in a number of ways with setpci. It has taken a year to 
>> find the cause of my troubles.
>> And a $15K scope, ...
>>
>> Berkley
>>
>>
>> Robert Hancock wrote:
>>> Mr. Berkley Shands wrote:
>>>> It seems that the 8132 should be blacklisted :-)
>>>>
>>>> INT-A will be asserted forever if any channel sees a parity error.
>>>> This can be blocked by several means;
>>>>
>>>> 1) setpci -s <bus address of 8132> 5.b=05   /* disable interrupts 
>>>> from the bridge */
>>>> This is the I don't see you method.
>>>>
>>>> Shouldn't the interrupt handler (is there one?) trap and clear this?
>>>> Shouldn't the kernel at least report this error and reset those bits?
>>>
>>> What's enabling this interrupt generation? Interrupting on parity 
>>> errors is not part of the PCI spec. Unless there's some driver that's 
>>> set up to handle these interrupts, whoever's enabling them shouldn't 
>>> be..
>>>
>>>>
>>>> All,
>>>>
>>>> OK, here's what I know so far.  The interrupt storm is coming from 
>>>> the parity error detector in the 8132.  The parity error is reported 
>>>> in two locations using sticky bits:
>>>>
>>>> 0x1c bits 31 and 24
>>>>   Here there seems to be some differentiation between which party 
>>>> detected the parity error.  The 8132 spec is pretty vague here (see 
>>>> page 75) but it looks like the 8132 is detecting a parity error from 
>>>> the HBA not the other way around.
>>>> 0x80 bit 0
>>>>   Here it just states that someone asserted the PERR_L signal, no 
>>>> distinction on who did it.
>>>>
>>>> All these bits are write-one-to-clear.  If 0x80 bit 0 is cleared, 
>>>> the storm stops.  Clearly the OS does not know how to handle these 
>>>> conditions and the error flag is left on while the interrupt is 
>>>> continuously handled.
>>>>
>>>> One way to handle this is to set 0x48 bit 19 to 0.  This prevents 
>>>> the 8132 from interrupting when 0x80 bit 0 is set.
>>>>
>>>> A much better way to handle this is to have the interrupt handler 
>>>> actually check the error bits on the 8132 when it is called.  This 
>>>> would slow down the interrupt handler, but actually give us a much 
>>>> better visibility into this problem (when, where and how often this 
>>>> happens).  The irritating thing here is that this is chipset 
>>>> dependent.  The interrupt handler would have to know what PCI-X 
>>>> chipset it was talking through to know how to handle this (way to go 
>>>> AMD).
>>>>
>>>> The really odd thing is that the parity error is reported through 
>>>> INTB on the 8132.  The spec claims that fatal errors (the category 
>>>> they put PERR in) go to INTB while hot plug conditions trigger 
>>>> INTA.  Masking off fatal errors in the IOAPIC turns off the storm 
>>>> too.  I have no idea why this is showing up on INTA.
>>>>
>>>> Berkley
>>>>
>>>
>>>
>>
>>
>> -- 
>>
>> // E. F. Berkley Shands, MSc//
>>
>> ** Exegy Inc.**
>>
>> 349 Marshall Road, Suite 100
>>
>> St. Louis , MO  63119
>>
>> Direct:  (314) 218-3600 X450
>>
>> Cell:  (314) 303-2546
>>
>> Office:  (314) 218-3600
>>
>> Fax:  (314) 218-3601
>>
>>  
>>
>> The Usual Disclaimer follows...
>>
>>  
>>
> 

