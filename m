Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZDRXC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZDRXC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 19:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZDRXCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 19:02:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:42662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZDRXCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 19:02:17 -0400
Message-ID: <49EA5BB2.90603@kernel.org>
Date: Sat, 18 Apr 2009 16:01:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org>
In-Reply-To: <49EA57C4.1000603@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Linus Torvalds wrote:
>> On Sat, 18 Apr 2009, Yinghai Lu wrote:
>>> except need to change 
>>>> +		reserve_region_with_split(&iomem_resource, start, end, "RAM buffer");
>>> ==> > +		reserve_region_with_split(&iomem_resource, start, end - 1, "RAM buffer");
>> Yes, I sent out a later email pointing that out.
>>
>>> it will make sure dynmical allocating code will not use those range.
>>>
>>> and could make e820_setup_gap much simple.
>> ACK. In fact:
>>
>>> Index: linux-2.6/arch/x86/kernel/e820.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/e820.c
>>> +++ linux-2.6/arch/x86/kernel/e820.c
>>> @@ -635,14 +635,12 @@ __init void e820_setup_gap(void)
>>>  #endif
>>>  
>>>  	/*
>>> -	 * See how much we want to round up: start off with
>>> -	 * rounding to the next 1MB area.
>>> +	 * e820_reserve_resources_late will protect stolen RAM
>>> +	 * so just round it to 1M
>>>  	 */
>>>  	round = 0x100000;
>>> -	while ((gapsize >> 4) > round)
>>> -		round += round;
>>> -	/* Fun with two's complement */
>>> -	pci_mem_start = (gapstart + round) & -round;
>>> +
>>> +	pci_mem_start = roundup(gapstart, round);
>> You can just remove "round" entirely. It's no longer a variable, it's just 
>> an odd way of saying 1M ;)
>>
>>> Ingo, can you put those two patches in tip?
>> I would suggest that we first change "reserve_region_with_split()" to not 
>> recurse into the region.
>>
>> That function isn't used by anything else (we ended up using 
>> "expand_to_fit()" instead in the one place that migth have used it), and 
>> now th eone caller we do have would not want the recursion - if there 
>> already exists a resource at the top level, we want to just avoid it.
>>
>> This - again TOTALLY UNTESTED - patch removes the "recurse into conflicts" 
>> code. Comments? Testing?
>>
>> 			Linus
>> ---
>>  kernel/resource.c |   46 ++++++++++++----------------------------------
>>  1 files changed, 12 insertions(+), 34 deletions(-)
>>
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index fd5d7d5..ac5f3a3 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -533,43 +533,21 @@ static void __init __reserve_region_with_split(struct resource *root,
>>  	res->end = end;
>>  	res->flags = IORESOURCE_BUSY;
>>  
>> -	for (;;) {
>> -		conflict = __request_resource(parent, res);
>> -		if (!conflict)
>> -			break;
>> -		if (conflict != parent) {
>> -			parent = conflict;
>> -			if (!(conflict->flags & IORESOURCE_BUSY))
>> -				continue;
>> -		}
>> -
>> -		/* Uhhuh, that didn't work out.. */
>> -		kfree(res);
>> -		res = NULL;
>> -		break;
>> -	}
>> -
>> -	if (!res) {
>> -		/* failed, split and try again */
>> -
>> -		/* conflict covered whole area */
>> -		if (conflict->start <= start && conflict->end >= end)
>> -			return;
>> +	conflict = __request_resource(parent, res);
>> +	if (!conflict)
>> +		return;
>>  
>> -		if (conflict->start > start)
>> -			__reserve_region_with_split(root, start, conflict->start-1, name);
>> -		if (!(conflict->flags & IORESOURCE_BUSY)) {
>> -			resource_size_t common_start, common_end;
>> +	/* failed, split and try again */
>> +	kfree(res);
>>  
>> -			common_start = max(conflict->start, start);
>> -			common_end = min(conflict->end, end);
>> -			if (common_start < common_end)
>> -				__reserve_region_with_split(root, common_start, common_end, name);
>> -		}
>> -		if (conflict->end < end)
>> -			__reserve_region_with_split(root, conflict->end+1, end, name);
>> -	}
>> +	/* conflict covered whole area */
>> +	if (conflict->start <= start && conflict->end >= end)
>> +		return;
>>  
>> +	if (conflict->start > start)
>> +		__reserve_region_with_split(root, start, conflict->start-1, name);
>> +	if (conflict->end < end)
>> +		__reserve_region_with_split(root, conflict->end+1, end, name);
>>  }
>>  
>>  void __init reserve_region_with_split(struct resource *root,
> 
> with
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000100 - 0000000000097400 (usable)
> [    0.000000]  BIOS-e820: 0000000000097400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000b7fa0000 (usable)
> [    0.000000]  BIOS-e820: 00000000b7fae000 - 00000000b7fb0000 (usable)
> [    0.000000]  BIOS-e820: 00000000b7fb0000 - 00000000b7fbe000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000b7fbe000 - 00000000b7ff0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000b7ff0000 - 00000000b8000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000002048000000 (usable)
> 
> got
> 
> 00000100-000973ff : System RAM
> 00097400-0009ffff : reserved
> 000a0000-000bffff : PCI Bus #00
> 000c0000-000cffff : pnp 00:0c
> 000e0000-000fffff : pnp 00:0c
> 00100000-b7f9ffff : System RAM
>   00200000-00c68f6b : Kernel code
>   00c68f6c-01332f7f : Kernel data
>   015a6000-01fcaa57 : Kernel bss
>   20000000-23ffffff : GART
> b7fa0000-b7fadfff : RAM buffer
> b7fae000-b7faffff : System RAM
> b7fb0000-b7fbdfff : ACPI Tables
> b7fbe000-b7feffff : ACPI Non-volatile Storage
> b7ff0000-b7ffffff : reserved
> ...
> 
without your patch got
00000100-000973ff : System RAM
00097400-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
000c0000-000cffff : pnp 00:0c
000e0000-000fffff : pnp 00:0c
00100000-b7f9ffff : System RAM
  00200000-00c68f6b : Kernel code
  00c68f6c-01332f7f : Kernel data
  015a6000-01fcaa57 : Kernel bss
  20000000-23ffffff : GART
b7fa0000-b7fadfff : RAM buffer
b7fae000-b7faffff : System RAM
b7fb0000-b7fbdfff : ACPI Tables
b7fbe000-b7feffff : ACPI Non-volatile Storage
b7ff0000-b7ffffff : reserved
  b7ff0000-b7ffffff : RAM buffer
b8000000-beffffff : PCI Bus #00
bf000000-bfffffff : PCI Bus #80

