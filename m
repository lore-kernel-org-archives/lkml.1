Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYIYHUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYIYHUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYIYHU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:20:27 -0400
Received: from relay.gothnet.se ([82.193.160.251]:2030 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751630AbYIYHU0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:20:26 -0400
Message-ID: <48DB3B88.7080609@tungstengraphics.com>
Date: Thu, 25 Sep 2008 09:19:36 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: keith.packard@intel.com, eric@anholt.net, hugh@veritas.com,
       hch@infradead.org, airlied@linux.ie, jbarnes@virtuousgeek.org,
       dri-devel@lists.sourceforge.net,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
References: <20080923091017.GB29718@wotan.suse.de> <48D8C326.80909@tungstengraphics.com> <20080925001856.GB23494@wotan.suse.de>
In-Reply-To: <20080925001856.GB23494@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tue, Sep 23, 2008 at 12:21:26PM +0200, Thomas Hellström wrote:
>   
>> Nick,
>> From my point of view, this is exactly what's needed, although there 
>> might be some different opinions among the
>> DRM developers. A question:
>>
>> Sometimes it's desirable to indicate that a page / object is "cleaned", 
>> which would mean data has moved and is backed by device memory. In that 
>> case one could either free the object or indicate to it that it can 
>> release it's pages. Is freeing / recreating such an object an expensive 
>> operation? Would it, in that case, be possible to add an object / page 
>> "cleaned" function?
>>     
>
> Ah, interesting... freeing/recreating isn't _too_ expensive, but it is
> going to have to allocate a lot of pages (for a big object) and copy
> a lot of memory. It's strange to say "cleaned", in a sense, because the
> allocator itself doesn't know it is being used as a writeback cache ;)
> (and it might get confusing with the shmem implementation because your
> cleaned != shmem cleaned!).
>
> I understand the operation you need, but it's tricky to make it work in
> the existing shmem / vm infrastructure I think. Let's call it "dontneed",
> and I'll add a hook in there we can play with later to see if it helps?
>
> What I could imagine is to have a second backing store (not shmem), which
> "dontneed" pages go onto, and they simply get discarded rather than swapped
> out (eg. via the ->shrinker() memory pressure indicator). You could then
> also register a callback to recreate these parts of memory if they have been
> discarded then become used again. It wouldn't be terribly difficult come to
> think of it... would that be useful?
>
>   
Well, the typical usage pattern is:

1) User creates a texture object, the data of which lives in a pageable 
object.
2) DRM decides it needs to go into V(ideo)RAM, and doesn't need a 
backing store. It indicates "dontneed" status on the object.
3) Data is evicted from VRAM. If it's not dirtied in VRAM and the 
"dontneed" pages are still around in the
old backing object, fine. We can and should reuse them. If data is 
dirtied in VRAM or the page(s) got discarded
 we need new pages and to set up a copy operation.

So yes, that would indeed be very useful,
I think one way is to have the callback happen on a per-page basis.
 DRM can then collect a list of what pages need to be copied from VRAM 
based on the callback and its knowledge of VRAM data status and set up a 
single DMA operation. So the callback shouldn't implicitly mark the 
newly allocated pages dirty.

Another useful thing I come to think of looking through the interface 
specification again is to have a pgprot_t argument to the pageable 
object vmap function, so that the VMAP mapping can be set to uncached / 
write-combined.
This of course would imply that the caller has pinned the pages and had 
the default kernel mapping caching status changed as well.

/Thomas





