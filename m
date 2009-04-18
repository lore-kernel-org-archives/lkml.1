Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZDRRJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZDRRJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 13:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZDRRJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 13:09:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:39319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbZDRRJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 13:09:28 -0400
Message-ID: <49EA08C3.1010404@kernel.org>
Date: Sat, 18 Apr 2009 10:07:15 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <20090418092216.GP7678@elte.hu>
In-Reply-To: <20090418092216.GP7678@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Linus Torvalds wrote:
>>> On Thu, 16 Apr 2009, Yinghai Lu wrote:
>>>> please check.
>>>>
>>>> [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
>>> I like the approach. That said, I think that rather than do the "modify 
>>> the e820 array" thing, why not just do it in the in the resource tree, and 
>>> do it at "e820_reserve_resources_late()" time?
>>>
>>> IOW, something like this.
>>>
>>> TOTALLY UNTESTED! The point is to take all RAM resources we haev, and 
>>> _after_ we've added all the resources we've seen in the E820 tree, we then 
>>> _also_ try to add fake reserved entries for any "round up to X" at the end 
>>> of the RAM resources.
>>>
>>> NOTE! I really didn't want to use "reserve_region_with_split()". I didn't 
>>> want to recurse into any conflicting resources, I really wanted to just do 
>>> the other failure cases. 
>>>
>>> THIS PATCH IS NOT MEANT TO BE USED. Just a rough "almost like this" kind 
>>> of thing. That includes the rough draft of how much to round things up to 
>>> based on where the end of RAM region is etc. I'm really throwing this out 
>>> more as a "wouldn't this be a readable way to handle any missing reserved 
>>> entries" kind of thing..
>>>
>>> 			Linus
>>>
>>> ---
>>>  arch/x86/kernel/e820.c |   34 ++++++++++++++++++++++++++++++++++
>>>  1 files changed, 34 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>>> index ef2c356..e8b8d33 100644
>>> --- a/arch/x86/kernel/e820.c
>>> +++ b/arch/x86/kernel/e820.c
>>> @@ -1370,6 +1370,23 @@ void __init e820_reserve_resources(void)
>>>  	}
>>>  }
>>>  
>>> +/* How much should we pad RAM ending depending on where it is? */
>>> +static unsigned long ram_alignment(resource_size_t pos)
>>> +{
>>> +	unsigned long mb = pos >> 20;
>>> +
>>> +	/* To 64kB in the first megabyte */
>>> +	if (!mb)
>>> +		return 64*1024;
>>> +
>>> +	/* To 1MB in the first 16MB */
>>> +	if (mb < 16)
>>> +		return 1024*1024;
>>> +
>>> +	/* To 32MB for anything above that */
>>> +	return 32*1024*1024;
>>> +}
>>> +
>>>  void __init e820_reserve_resources_late(void)
>>>  {
>>>  	int i;
>>> @@ -1381,6 +1398,23 @@ void __init e820_reserve_resources_late(void)
>>>  			insert_resource_expand_to_fit(&iomem_resource, res);
>>>  		res++;
>>>  	}
>>> +
>>> +	/*
>>> +	 * Try to bump up RAM regions to reasonable boundaries to
>>> +	 * avoid stolen RAM
>>> +	 */
>>> +	for (i = 0; i < e820.nr_map; i++) {
>>> +		struct e820entry *entry = &e820_saved.map[i];
>>> +		resource_size_t start, end;
>>> +
>>> +		if (entry->type != E820_RAM)
>>> +			continue;
>>> +		start = entry->addr + entry->size;
>>> +		end = round_up(start, ram_alignment(start));
>>> +		if (start == end)
>>> +			continue;
>>> +		reserve_region_with_split(&iomem_resource, start, end, "RAM buffer");
>>> +	}
>>>  }
>>>  
>>>  char *__init default_machine_specific_memory_setup(void)
>> except need to change 
>>> +		reserve_region_with_split(&iomem_resource, start, end, "RAM buffer");
>> ==> > +		reserve_region_with_split(&iomem_resource, start, end - 1, "RAM buffer");
>>
>> it will make sure dynmical allocating code will not use those range.
>>
>> and could make e820_setup_gap much simple.
>>
>> ---
>>  arch/x86/kernel/e820.c |   10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/e820.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/e820.c
>> +++ linux-2.6/arch/x86/kernel/e820.c
>> @@ -635,14 +635,12 @@ __init void e820_setup_gap(void)
>>  #endif
>>  
>>  	/*
>> -	 * See how much we want to round up: start off with
>> -	 * rounding to the next 1MB area.
>> +	 * e820_reserve_resources_late will protect stolen RAM
>> +	 * so just round it to 1M
>>  	 */
>>  	round = 0x100000;
>> -	while ((gapsize >> 4) > round)
>> -		round += round;
>> -	/* Fun with two's complement */
>> -	pci_mem_start = (gapstart + round) & -round;
>> +
>> +	pci_mem_start = roundup(gapstart, round);
>>  
>>  	printk(KERN_INFO
>>  	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
>>
>> Ingo, can you put those two patches in tip?
> 
> I think the point would be to explore the possibility to have no 
> 'gap' logic at all - we should extend the e820 table with Linus's 
> scheme to add 'RAM buffer' entries.
> 
so you prefer the old one aka the -v4, and add new entry type for RAM Buffer?

YH
