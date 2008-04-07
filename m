Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYDGTwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYDGTwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYDGTwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:52:35 -0400
Received: from relay.gothnet.se ([82.193.160.251]:1720 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751956AbYDGTwe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:52:34 -0400
Message-ID: <47FA7B58.6040907@tungstengraphics.com>
Date: Mon, 07 Apr 2008 21:51:52 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <47F391BD.1060306@linux.intel.com> <47F3C90E.2020208@tungstengraphics.com> <200804071123.27411.jbarnes@virtuousgeek.org>
In-Reply-To: <200804071123.27411.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, April 02, 2008 10:57 am Thomas Hellström wrote:
>   
>> Arjan van de Ven wrote:
>>     
>>> Thomas Hellström wrote:
>>>       
>>>> to fix the long standing uc/wc aliasing issue, provided we
>>>>         
>>> I'm not opposed to a real fix. I am opposed to a bad hack.
>>>       
>> Great. So a real clean fix involves setting all "default" kernel
>> mappings either to WC (which will require PAT) or
>> Unmapped, for a pool of pages used in the graphics tables.
>>
>> To reduce the number of attribute changes for mappings that are
>> frequently switched, and also to reduce the number of clflushes, and to
>> avoid waiting for upcoming wc versions of set_memory_xx, I have a strong
>> preference for unmapping the pages.
>>     
>
> Hopefully the WC stuff will be upstream right after 2.6.25 comes out.  Any 
> reason why we shouldn't keep the pages mapped in the kernel as WC assuming 
> the interface is there?
>   
If the pages are unmapped, we can get reasonable speed doing 
unbind-read-bind operations, kernel accesses to the memory will need to 
use an iomap_atomic_prot_pfn() type of operation.
No IPI global tlb flushes needed for kernel mapping changes during 
unbind-read-bind and no cache flushes needed either if we write-protect 
the user-space mappings properly, or very limited cache flushes if we 
keep dirty-written-while-cached flags for each page.

If the pages are wc-d we'll need two extra IPI global tlb flushes and a 
buffer-size cache flush every time we do unbind-read-bind, but OTOH we 
don't need the iomap_atomic_prot_pfn() to access single pages from the 
kernel.

iomap_atomic_prot_pfn() should be really fast. It requires a 
single-page-single-processor tlb flush per map-unmap operation. For 
long-term and larger buffer maps we'll either use ioremap() or vmap() 
depending on memory type.
> And we really should be keeping pools of pages around with the right type--we 
> don't want to change attributes any more than absolutely necessary (the ia64 
> uncached allocator does this right already, and in the DRM we actually keep 
> the mappings around right now afaict).  We can allocate & free large chunks 
> at a time to deal with memory pressure one way or another...
>
>   
Agreed.
>> 3) Have code in x86/pageattr.c decide which "default" mappings are
>> present on the given pages and set them all as non-present.
>> In fact, there is already such a function in pageattr.c:
>>
>> kernel_map_pages(struct page *pages, int numpages, bool enable);
>>
>> But it's for debugging purposes only, could we use and export a variant
>> of this?
>>
>> I guess I need a hint as to what's considered allowable here, to avoid
>> spending a lot of time on something that will in the end get rejected
>> anyway.
>>     
>
> I think we do want an interface like this, even if only for graphics memory 
> (though I suspect some other device might like it as well).  We'll also want 
> to do it at runtime periodically to allocate new hunks of memory for graphics 
> use, so a boot-time only thing won't work.
>
> Also, to make the API readable, we'd probably want to split the function into 
> kernel_map_pages(..., enum memory_type type) and kernel_unmap_pages(...) 
> (though like I said I think we really should be mapping them WC not umapping 
> them altogether, since we do want to hit the ring buffer from the kernel with 
> the WC type for example).
>   
I think ring-buffers are using ioremap() or vmap() already today. We can 
use these to get WC-type access also in the future. The only time we use 
the linear kernel mapping today is for single page access while patching 
up command buffers.

So it's really a tradeoff between slightly faster single-page access and 
really fast unbind-read-bind operations. That's really why I'm 
suggesting unmapped pages.

> Question is, will kernel_map_pages catch all the various kernel mappings 
> (regular identity map, large page text map,e tc.), perform the proper 
> flushing, and generally make sure we don't machine check on all platforms?
>
>   
Probably not yet. OTOH, it seems like x86 is the only platform today 
that tries to do something about the AGP page aliasing.
> Jesse
>   
/Thomas



