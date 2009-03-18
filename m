Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZCRPSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZCRPSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZCRPSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:18:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:44343 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbZCRPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:18:13 -0400
Message-ID: <49C11088.7000205@vflare.org>
Date: Wed, 18 Mar 2009 20:47:28 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>  <alpine.DEB.1.10.0903171237180.21582@qirst.com> <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com> <alpine.DEB.1.10.0903171355410.26058@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0903171355410.26058@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090317-0, 17-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 17 Mar 2009, Nitin Gupta wrote:
> 
>> Creating slabs for sizes in range, say, [32, 3/4*PAGE_SIZE] separated by
>> 64bytes
>> will require 48 slabs! Then for slab of each size class will have wastage
>> due to
>> unused slab objects in each class.
>> Larger difference in slab sizes (and thus small no. of them), will surely
>> cause too much
>> wastage due to internal fragmentation.
> 
> The slabs that match existing other slabs of similar sizes will be aliased
> and not created. Create the 48 slabs and you likely will only use 10 real
> additional ones. The rest will just be pointing to existing ones.
> 
>> Another (more important) point to consider is that, use of slabs will
>> eat-up vmalloc area to keep slab memory backed by VA space. On 32-bit
>> systems, vmalloc area is small and limits amount of memory that can be
>> allocated for compressed pages. With xvmalloc we map/unmap pages on
>> demand thus removing dependence on vmalloc VA area.
> 
> Slab memory is not backed by vmalloc space.
> 

Oh, it uses "low memory". Still not good for compcache :)

>>> Have you had a look at the SLOB approach?
>> Nope. I will see how this may help.
> 
> Slob is another attempt to reduce wastage due to the rounding up of
> object sizes to 2^N in SLAB/SLUB.
> 
> 

I had detailed look at SLOB allocator and found it unacceptable to be
used for compcache.

To begin with, SLOB maintains just 3 freelists:
  - for size < 256     - free_slob_small
  - [256, 1024)        - free_slob_medium
  - [1024, PAGE_SIZE)  - free_slob_large

and allocates from one of these lists depending on size requested. No need to
create 50+ caches, we only get to use these 3 lists.

Why SLOB is bad:

1) O(n) allocation:
To find block of given size, it _linearaly_ scans corresponding free list to
find a page with _total_ free space >= requested size. This free space might not
be contiguous. So it runs through free blocks within each such candidate
page until it finally finds some page with free contiguous area >= requested
size.

2) When growing SLOB cache, page is added to one of 3 freelists (depending on
what size we are currently allocating). After this, this page can never move to
any other list - even if its free space drops down to fall in next range below
or vice versa. This has two problems:
   - Potentially large wastage due to "page internal fragmentation": e.g.:
alloc(3096) is satisfied from a page in 'large free list'. Now it has
1000b free (assuming 4k page) which will now never be used.
   - It can trigger unnecessary cache grows: e.g.: even though we have such
unfilled pages in 'large' list, allocation in 'small' range can still cause
cache grow if 'small free list' is empty.

3) It only allocates from "low memory". This is clearly not acceptable for
compcache.

In contrast xvmalloc is O(1): do a simple search in two-level bitmap to find
freelist containing block of required size. Obviously not O(1) in case it has
to go to system page allocator to grow pool.

Also, xvmalloc doesn't dedicate a page to any single size class - so it doesn't
suffer from above problems. Note that this might not be good in general - say,
in cases where majority of alloc requests are for some select sizes only. But
for compcache, this is not true. Also, in our case, there is no correlation
between object sizes and object lifetime - so no benefit keeping similar sized
objects together. Considering these, there's no point dedicating pages to size
classes. Instead, better go for freely mixing these objects to get maximum
packing.

...and xvmalloc is not restricted to "low memory".

Thanks,
Nitin


