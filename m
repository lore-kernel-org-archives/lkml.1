Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZHCKpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZHCKpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZHCKpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:45:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49678 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZHCKpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:45:10 -0400
Date: Mon, 3 Aug 2009 12:44:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@linux.ie>, Arjan van de Ven <arjan@infradead.org>,
       "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86: Fix CPA memtype reserving in the set_pages_array
	cases
Message-ID: <20090803104454.GB18165@elte.hu>
References: <1249284345-7654-1-git-send-email-thellstrom@vmware.com> <20090803081110.GB32258@elte.hu> <alpine.DEB.2.00.0908030928280.496@skynet.skynet.ie> <4A76A24F.1030505@vmware.com> <20090803091954.GB9074@elte.hu> <4A76B985.40202@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A76B985.40202@vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Hellstrom <thellstrom@vmware.com> wrote:

> Ingo Molnar wrote:
>> * Thomas Hellstrom <thellstrom@vmware.com> wrote:
>>
>>   
>>> Dave Airlie wrote:
>>>     
>>>>> hm, i'm missing a description about how this bug was triggered. 
>>>>> How did you end up getting highmem pages to a cpa call?
>>>>>             
>>>> GEM and TTM both allocate page arrays and just pass them to cpa,
>>>> we don't know what type of pages the allocator gives us back and we 
>>>> really shouldn't have to, so having cpa ignore highmem pages is  
>>>> certainly the right option.
>>>>
>>>> GEM just uses shmem code to alloc the pages and TTM has its own allocator.
>>>>
>>>>         
>>> Yes, Dave is right.
>>>
>>> Although I'm not 100% sure the TTM code I was using that triggered 
>>> this  has made it into 2.6.31.
>>> Old AGP uses (GFP_KERNEL | GFP_DMA32 | __GFP_ZERO), which (correct me 
>>> if  I'm wrong) never hands back highmem pages. This means that 
>>> Intel's GEM  is the only likely user for 2.6.31.
>>>     
>>
>> (please dont top-post) I'm not sure you folks noticed this bit of my  
>> mail:
>>
>>   
>>>>> ok, that's a bug introduced in .29 but which was latent until 
>>>>> now:  drivers/char/agp/generic.c now uses it plus (indirectly) a 
>>>>> number of  AGP drivers, since:
>>>>>
>>>>>  commit 07613ba2f464f59949266f4337b75b91eb610795
>>>>>  Author: Dave Airlie <airlied@redhat.com>
>>>>>  Date:   Fri Jun 12 14:11:41 2009 +1000
>>>>>
>>>>>      agp: switch AGP to use page array instead of unsigned long array
>>>>>
>>>>> I dont see how it can end up with highmem pages though. All the  
>>>>> graphics apperture allocations happen to lowmem AFAICS. Did GEM 
>>>>> add the possibility for user pages (highmem amongst them) ending 
>>>>> up in that pool? Which code does that?
>>>>>         
>>
>> 	Ingo
>>   
> Sorry, my bad.
>
> The TTM code I tested is not in yet, and after double-checking it 
> looks like Intel's gem is not changing caching policy before 
> binding to AGP.
>
> This means the highmem problems that I saw were triggered by a 
> combination of the virtual->physical bugfix and code that's not in 
> the kernel yet, and since it's an optimization of the current code 
> it's not likely to land in 2.6.31. The highmem fixes could thus, 
> AFAICT be stripped out of the patch, unless GFP_DMA32 on a highmem 
> system can actually hand back highmem pages, in which case AGP 
> will not work correctly.
>
> As for highmem use in the future, the TTM page arrays are 
> populated using fault(), which means that there will be an 
> overhead ordering the pages so that we can use the 
> set_pages_array() interface instead of set_memory() that we use 
> today. Therefore, if possible, I'd prefer if we could pass arrays 
> containing highmem pages to the set_pages_array() interface.
>
> There are no aliased mappings since
>
> 1) Any user space mappings to these pages are killed before changing  
>    caching policy.
> 2) The pages are allocated and owned by the driver.
> 3) kmap_atomic_prot() and vmap() are used to map these pages in kernel  
> space.
>
> Code is in ttm_tt.c ttm_bo.c and ttm_bo_util.c

ok - thanks for the explanation. Since you intentionally want to use 
highmem pages (and your use is safe) i concur with your original 
patch in its entirety - even if that planned highmem use is not 
upstream yet. Will get it .31-wards ASAP.

	Ingo
