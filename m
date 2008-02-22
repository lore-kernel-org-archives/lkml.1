Return-Path: <linux-kernel-owner+w=401wt.eu-S1765520AbYBVMTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765520AbYBVMTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbYBVMT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:19:28 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:47064 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbYBVMT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:19:27 -0500
Message-ID: <47BEBCB7.8000607@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2008 17:44:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <200802211535.38932.nickpiggin@yahoo.com.au> <47BD06C2.5030602@linux.vnet.ibm.com> <47BD55F6.5030203@firstfloor.org> <47BE527D.2070109@linux.vnet.ibm.com> <47BE9B11.7090809@firstfloor.org>
In-Reply-To: <47BE9B11.7090809@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Balbir Singh wrote:
>> Andi Kleen wrote:
>>>> 1. We could create something similar to mem_map, we would need to handle 4
>>> 4? At least x86 mainline only has two ways now. flatmem and vmemmap.
>>>
>>>> different ways of creating mem_map.
>>> Well it would be only a single way to create the "aux memory controller
>>> map" (or however it will be called). Basically just a call to single
>>> function from a few different places.
>>>
>>>> 2. On x86 with 64 GB ram, 
>>> First i386 with 64GB just doesn't work, at least not with default 3:1
>>> split. Just calculate it yourself how much of the lowmem area is left
>>> after the 64GB mem_map is allocated. Typical rule of thumb is that 16GB
>>> is the realistic limit for 32bit x86 kernels. Worrying about
>>> anything more does not make much sense.
>>>
>> I understand what you say Andi, but nothing in the kernel stops us from
>> supporting 64GB.
> 
> Well in practice it just won't work at least at default page offset.
> 
>> Should a framework like memory controller make an assumption
>> that not more than 16GB will be configured on an x86 box?
> 
> It doesn't need to. Just increase __VMALLOC_RESERVE by the
> respective amount (end_pfn * sizeof(unsigned long))
> 
> Then 64GB still won't work in practice, but at least you made no such
> assumption in theory @)
> 
> Also there is the issue of memory hotplug. In theory later
> memory hotplugs could fill up vmalloc. Luckily x86 BIOS
> are supposed to declare how much they plan to hot add memory later
> using the SRAT memory hotplug area (in fact the old non sparsemem
> hotadd implementation even relied on that). It would
> be possible to adjust __VMALLOC_RESERVE at boot even for that. I suspect
> this issue could be also just ignored at first; it is unlikely
> to be serious.
> 

My concern with all the points you mentioned is that this solution might need to
change again, depending on the factors you've mentioned. vmalloc() is good and
straightforward, but it has these dependencies which could call for another
rewrite of the code.

> 
>>>> if we decided to use vmalloc space, we would need 64
>>>> MB of vmalloc'ed memory
>>> Yes and if you increase mem_map you need exactly the same space
>>> in lowmem too. So increasing the vmalloc reservation for this is
>>> equivalent. Just make sure you use highmem backed vmalloc.
>>>
>> I see two problems with using vmalloc. One, the reservation needs to be done
>> across architectures. 
> 
> Only on 32bit. Ok hacking it into all 32bit architectures might be
> difficult, but I assume it would be ok to rely on the architecture
> maintainers for that and only enable it on some selected architectures
> using Kconfig for now.
> 

Yes, but that's not such a good idea

> On 64bit vmalloc should be by default large enough so it could
> be enabled for all 64bit architectures.
> 
>> Two, a big vmalloc chunk is not node aware, 
> 
> vmalloc_node()
> 

vmalloc_node() would need to work much the same way as mem_map does. I am
tempted to try the mem_map and radix tree approaches. I think KAMEZAWA is
already working and has a first draft of the radix tree changes ready.

> -Andi


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
