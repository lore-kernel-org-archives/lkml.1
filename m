Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYHGXpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYHGXpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYHGXp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:45:28 -0400
Received: from gw.goop.org ([64.81.55.164]:58380 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYHGXp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:45:27 -0400
Message-ID: <489B8908.2010007@goop.org>
Date: Thu, 07 Aug 2008 16:45:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ehabkost@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make PFN_PHYS return a properly-formed physical address
References: <489B6B40.5050705@goop.org>	<20080807145648.ab3dfa90.akpm@linux-foundation.org>	<489B72C3.30603@goop.org> <20080807162741.8dfcd336.akpm@linux-foundation.org>
In-Reply-To: <20080807162741.8dfcd336.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yes, but resource_size_t is for IO addressing, not for memory addressing.
>
> Lots of X86_32 machines can happily support 32-bit physical addresses
> for IO while needing >32 bit addresses for physical memory.
>   

Really?  The resource tree treats normal memory as just another 
resource.  Is it expected that you could have usable memory not 
represented by /proc/iomem?

Hm, looks like memory hotplug assumes that resource_size_t is always 
64-bits, but the e820->resource conversion simply skips over-large 
addresses.

>>>>  #define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
>>>>  #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
>>>>  #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
>>>> -#define PFN_PHYS(x)	((x) << PAGE_SHIFT)
>>>> +#define PFN_PHYS(x)	((resource_size_t)(x) << PAGE_SHIFT)
>>>>     
>>>>         
>>> Busted on PAE with CONFIG_RESOURCES_64BIT=n, surely?
>>>   
>>>       
>> Not an option:
>>
>> config X86_PAE
>> 	def_bool n
>> 	prompt "PAE (Physical Address Extension) Support"
>> 	depends on X86_32 && !HIGHMEM4G
>> 	select RESOURCES_64BIT
>>
>>     
>
> err, OK, that was a bit arbitrary of us.
>
> Oh well, scrub the above assertion.
>
> Then again, do all architectures disallow 32-bit resource_size_t on
> 64-bit?  And there's ppc32's CONFIG_HIGHMEM option to think about.
>   

x86 and ppc were the only archs to touch it; they otherwise use the 
default of "default 64BIT".

I didn't look at the ppc use case.   I wasn't terribly concerned about 
current users of PFN_PHYS, because it presumably works OK for them.

>> "Properly" would be to define a phys_addr_t which can always represent a 
>> physical address.  We have one in x86-land, but I hesitate to add it for 
>> everyone else.
>>     
>
> hm.  It is a distinct and singular concept - it makes sense to have a
> specific type to represet "a physical address for memory".
>   

Yes.  We had to be particularly careful with it on x86 because of all 
the problems it's caused, but it is a generally useful thing to be able 
to talk about.

Shall we go with just using plain u64 (or unsigned long long if we want 
a really consistent type) in the meantime, and then waffle about 
introducing a new type everywhere?

Or we could redefine resource_size_t to be big enough to refer to any 
resource, including all memory.  It's close to being that anyway.

> nope ;) We don't know what type u64 has - some architectures use
> `unsigned long' (we might fix this soon).
>
> For now, a full cast to `unsigned long long' is needed.
>   

Yep.

    J

