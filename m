Return-Path: <linux-kernel-owner+w=401wt.eu-S1764606AbYBULJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764606AbYBULJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYBULJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:09:21 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:32986 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYBULJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:09:20 -0500
Message-ID: <47BD5A85.5010401@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 16:33:33 +0530
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
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <200802211535.38932.nickpiggin@yahoo.com.au> <47BD546B.1050504@firstfloor.org>
In-Reply-To: <47BD546B.1050504@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Nick Piggin wrote:
>> On Wednesday 20 February 2008 23:52, Balbir Singh wrote:
>>> Andi Kleen wrote:
>>>> Document huge memory/cache overhead of memory controller in Kconfig
>>>>
>>>> I was a little surprised that 2.6.25-rc* increased struct page for the
>>>> memory controller.  At least on many x86-64 machines it will not fit into
>>>> a single cache line now anymore and also costs considerable amounts of
>>>> RAM.
>>> The size of struct page earlier was 56 bytes on x86_64 and with 64 bytes it
>>> won't fit into the cacheline anymore? Please also look at
>>> http://lwn.net/Articles/234974/
>> BTW. We'll probably want to increase the width of some counters
>> in struct page at some point for 64-bit, 
> 
> You mean change count to atomic64_t? Do you have real evidence
> the 32bit counter is a problem?
> 
>> so then it really will
>> go over with the memory controller!
> 
> Not sure how they are related? The count and the memory controller
> data would be always separate.
> 
> BTW if the memory controllers were limited in number it would
> be also possible on 64bit to encode them in the high bits of
> ->flags. I assume 16bit or so could be spared in there. Probably
> would not be enough though.
> 
>> Actually, an external data structure is a pretty good idea. We
>> could probably do it easily with a radix tree (pfn->memory
>> controller). And that might be a better option for distros.
> 
> I would think just a separate vmalloc()ed array for the counters
> would be easy enough. That array could be allocated the first time
> the memory controller is used (so making it zero cost for
> distribution kernels when it is not used at all) and then also on
> memory hotplug etc. If we assume most memory will be in
> memory controllers that is also more efficient (in terms of
> memory and of cache consumption) than any kind
> of tree.
> 
> Balbir mentioned one reason they didn't do that earlier was
> that they worried about the limited vmalloc space on 32bit,
> but I don't think that's a good reason against it. That is because
> vmalloc on 32bit is limited because of the limited direct
> mapped kernel memory, but increasing mem_map size eats that
> the same limited resource. So rather the 32bit vmalloc
> reservation can be just increased by the same amount as the
> mem_map increase would be (ok modulo hotplug, but that
> is difficult anyways on 32bit)
> 
> Another issue is that it will slightly increase TLB/cache
> cost of the memory controller, but I think that would be a fair
> trade off for it being zero cost when disabled but compiled
> in.
> 
> Doing it with vmalloc should be easy enough. I can do such
> a patch later unless someone beats me to it...
> 

I'll get to it, but I have too many things on my plate at the moment. KAMEZAWA
also wanted to look at it. I looked through some vmalloc() internals yesterday
and I am worried about allocating all the memory on a single node in a NUMA
system and changing VMALLOC_XXXX on every architecture to provide more vmalloc
space. I might be missing something obvious.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
