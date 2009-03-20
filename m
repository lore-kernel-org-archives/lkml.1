Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZCTQY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZCTQY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbZCTQYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:24:46 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:65222 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZCTQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=P5OrmET+e0VkZRQloxfXOB8gENiZIDaL+DqXQk/qXlQZa3AI9fEOt1NJB+jUiZ0bcG
         pNTyMDQNu+E8CqPUp9alE+fH7sSw9Cak7shSlZnfdMofONDhb8QP3wYpNnuhU1kdyHwG
         mSMoJx0i4OA1iBs2KUxV3jfIAvfHcFKFRStoc=
Message-ID: <49C3C321.8080508@vflare.org>
Date: Fri, 20 Mar 2009 21:54:01 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
References: <49C3A31D.6070208@vflare.org> <49C3A435.7060703@vflare.org> <alpine.DEB.1.10.0903201042570.3740@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0903201042570.3740@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 20 Mar 2009, Nitin Gupta wrote:
> 
>> xvmalloc is a memory allocator designed specifically for compcache project.
> 
> Its an allocator that is highmem capable? Looks like an entirely new
> animal to me.
> 
>> * Features:
>>  - Low metadata overhead (just 4 bytes per object)
> 
> SLUB has 0 byte overhead. SLOB has 2 bytes.

SLUB: 0 metadata but lot of wastage due to rounding-off.
SLOB: 2 bytes header but I think we should really return object aligned to
at least 4 bytes on most archs (including x86 and x64). Apart from smaller
header, it has too many other problems as I detailed in previous mail.

> 
>>  - O(1) Alloc/Free - except when we have to call system page allocator to
>>     get additional memory.
> 
> SLOB is not O(1) okay but the others are.

Only SLOB is currently there for good packing, so it is the only one worth
comparing against. We loose this mem-compression game if we waste too much :)

> 
>>  - Very low fragmentation: In all tests, xvMalloc memory usage is within 12%
>>     of "Ideal".
> 
> Maybe try a fair test instead of relying on kmalloc rounding up to
> the next power of 2 size?
> 

Okay, for testing, I will make some wrappers around SLOB that directly use
slob_alloc() to avoid any of this rounding-off. I hope to show some data on
this soon. But considering other SLOB issues, this should not, hopefully,
be a blocker for compcache.


>> One of the main highlights is that it maps pages only when required.
>> So, it does not hog vmalloc area which is very small on 32-bit systems.
> 
> Got some difficulty understanding what is going on here. So this allocator
> is highmem capable? Doesnt that mean that you must make function calls to
> ensure that an object is mapped before accessing it.
> 

Yes. xvmalloc caller gets <pagenum, offset> pair. Caller has to
separately map it to get dereferenceable pointer.

>> +#include "xvmalloc_int.h"
>> +
>> +static void stat_inc(u64 *value)
>> +{
>> +	*value = *value + 1;
>> +}
> 
> (*value) += 1?
> 
Looks better.

> atomic_inc?
> 
There is really no need to make these stat variables atomic.

> local_inc?
> 

This one looks useful when we work on making compcache code scalable.

>> +static void bitmap_set(u32 *map, u32 idx)
>> +{
>> +	*map |= (u32)(1 << idx);
>> +}
> 
> We have bitops for that purpose. Please use those.
> 

Ok.

>> +/*
>> + * Get index of free list having blocks of size greater than
>> + * or equal to requested size.
>> + */
>> +static u32 get_index(u32 size)
>> +{
>> +	size = (size + FL_DELTA_MASK) & ~FL_DELTA_MASK;
> 
> See the ALIGN macro.
> 

ALIGN is doing same thing - will use it instead.

>> +/*
>> + * Allocate a memory page. Called when a pool needs to grow.
>> + */
>> +static u32 xv_alloc_page(void)
>> +{
>> +	struct page *page;
>> +
>> +	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
> 
> Yes a highmem based allocator!!!!
> 
>> +
>> +	if (unlikely(!page))
>> +		return INVALID_PGNUM;
> 
> Return NULL?
> 
>> +#define INVALID_PGNUM	((u32)(-1))
> 
> NULL
> 

okay, INVALID_PGNUM -> NULL

>> +#define ROUNDUP(x, y)	(((x) + (y) - 1) / (y) * (y))
> 
> There is a global macro available for that purpose
> 
Ok, will use that.

>> +/* Each individual bitmap is 32-bit */
>> +#define BITMAP_BITS	32
> 
> Use kernel constants please BITS_PER_LONG here.
> 
Ok.

>> +#define ROUNDUP_ALIGN(x)	(((x) + XV_ALIGN_MASK) & ~XV_ALIGN_MASK)
> 
> == ALIGN?

Yup.

> 
> Well I think this allocator is pretty useful for systems that depend to a
> large degree on highmem. This is basically x86 32 bit configuration swith
> more than 1G memmory.
> 

Not just highmem.
1) Its O(1) and as a side effect causes less cache pollution than SLOB which
does this absolutely crazy freelist scanning.
2) Better packing (will post comparison data soon).

I think, with a bit playing around with interfaces, it can be turned into
general purpose allocator (this will most probably lack highmem support).


Thanks for your feedback.
Nitin

