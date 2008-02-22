Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbYBVJtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbYBVJtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBVJte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:49:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41178 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYBVJtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:49:32 -0500
Message-ID: <47BE9B11.7090809@firstfloor.org>
Date: Fri, 22 Feb 2008 10:51:13 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <200802211535.38932.nickpiggin@yahoo.com.au> <47BD06C2.5030602@linux.vnet.ibm.com> <47BD55F6.5030203@firstfloor.org> <47BE527D.2070109@linux.vnet.ibm.com>
In-Reply-To: <47BE527D.2070109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Andi Kleen wrote:
>>> 1. We could create something similar to mem_map, we would need to handle 4
>> 4? At least x86 mainline only has two ways now. flatmem and vmemmap.
>>
>>> different ways of creating mem_map.
>> Well it would be only a single way to create the "aux memory controller
>> map" (or however it will be called). Basically just a call to single
>> function from a few different places.
>>
>>> 2. On x86 with 64 GB ram, 
>> First i386 with 64GB just doesn't work, at least not with default 3:1
>> split. Just calculate it yourself how much of the lowmem area is left
>> after the 64GB mem_map is allocated. Typical rule of thumb is that 16GB
>> is the realistic limit for 32bit x86 kernels. Worrying about
>> anything more does not make much sense.
>>
> 
> I understand what you say Andi, but nothing in the kernel stops us from
> supporting 64GB.

Well in practice it just won't work at least at default page offset.

> Should a framework like memory controller make an assumption
> that not more than 16GB will be configured on an x86 box?

It doesn't need to. Just increase __VMALLOC_RESERVE by the
respective amount (end_pfn * sizeof(unsigned long))

Then 64GB still won't work in practice, but at least you made no such
assumption in theory @)

Also there is the issue of memory hotplug. In theory later
memory hotplugs could fill up vmalloc. Luckily x86 BIOS
are supposed to declare how much they plan to hot add memory later
using the SRAT memory hotplug area (in fact the old non sparsemem
hotadd implementation even relied on that). It would
be possible to adjust __VMALLOC_RESERVE at boot even for that. I suspect
this issue could be also just ignored at first; it is unlikely
to be serious.


>>> if we decided to use vmalloc space, we would need 64
>>> MB of vmalloc'ed memory
>> Yes and if you increase mem_map you need exactly the same space
>> in lowmem too. So increasing the vmalloc reservation for this is
>> equivalent. Just make sure you use highmem backed vmalloc.
>>
> 
> I see two problems with using vmalloc. One, the reservation needs to be done
> across architectures. 

Only on 32bit. Ok hacking it into all 32bit architectures might be
difficult, but I assume it would be ok to rely on the architecture
maintainers for that and only enable it on some selected architectures
using Kconfig for now.

On 64bit vmalloc should be by default large enough so it could
be enabled for all 64bit architectures.

>Two, a big vmalloc chunk is not node aware, 

vmalloc_node()

-Andi
