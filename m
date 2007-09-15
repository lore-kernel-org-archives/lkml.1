Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbXIOWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbXIOWas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 18:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXIOWai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 18:30:38 -0400
Received: from ns1.suse.de ([195.135.220.2]:34525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbXIOWag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 18:30:36 -0400
Date: Sun, 16 Sep 2007 00:30:32 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070915223032.GA6708@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzpvy9cb.fsf@informatik.uni-tuebingen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 10:14:44PM +0200, Goswin von Brederlow wrote:
> How does that help? Will slabs move objects around to combine two

1. It helps providing a few guarantees: when you run "/usr/bin/free"
you won't get a random number, but a strong _guarantee_. That ram will
be available no matter what.

With variable order page size you may run oom by mlocking some half
free ram in pagecache backed by largepages. "free" becomes a fake
number provided by a weak design.

Apps and admin need to know for sure the ram that is available to be
able to fine-tune the workload to avoid running into swap but while
using all available ram at the same time.

> partially filled slabs into nearly full one? If not consider this:

2. yes, slab can indeed be freed to release an excessive number of 64k
   pages pinned by an insignificant number of small objects. I already
   told to Mel even at the VM summit, that the slab defrag can payoff
   regardless, and this is nothing new, since it will payoff even
   today with 2.6.23 with regard to kmalloc(32).

> - You create a slab for 4k objects based on 64k compound pages.
>   (first of all that wastes you a page already for the meta infos)

There's not just 1 4k object in the system... The whole point is to
make sure all those 4k objects goes into the same 64k page. This way
for you to be able to reproduce Nick's worst case scenario you have to
allocate total_ram/4k objects large 4k...

> - Something movable allocates a 14 4k page in there making the slab
>   partially filled.

Movable? I rather assume all slab allocations aren't movable. Then
slab defrag can try to tackle on users like dcache and inodes. Keep in
mind that with the exception of updatedb, those inodes/dentries will
be pinned and you won't move them, which is why I prefer to consider
them not movable too... since there's no guarantee they are.

> - Something unmovable alloactes a 4k page making the slab mixed and
>   full.

The entire slab being full is a perfect scenario. It means zero memory
waste, it's actually the ideal scenario, I can't follow your logic...

> - Repeat until out of memory.

for(;;) kmalloc(32); is supposed to run oom, no breaking news here...

> - Userspace allocates a lot of memory in those slabs.

If with slabs you mean slab/slub, I can't follow, there has never been
a single byte of userland memory allocated there since ever the slab
existed in linux.

> - Userspace frees one in every 15 4k chunks.

I guess you're confusing the config-page-shift design with the sgi
design where userland memory gets mixed with slab entries in the same
64k page... Also with config-page-shift the userland pages will all be
64k.

Things will get more complicated if we later decide to allow
kmalloc(4k) pagecache to be mapped in userland instead of only being
available for reads. But then we can restrict that to a slab and to
make it relocatable by following the ptes. That will complicate things
a lot.

But the whole point is that you don't need all that complexity,
and that as long as you're ok to lose some memory, you will get a
strong guarantee when "free" tells you 1G is free or available as
cache.

> - Userspace forks 1000 times causing an unmovable task structure to
>   appear in 1000 slabs. 

If 1000 kmem_cache_alloc(kernel_stack) in a row will keep pinned 1000
64k slab pages it means previously there have at least been
64k/8k*1000 simultaneous tasks allocated at once, not just your 1000
fork.

Even if when "free" says there's 1G free, it wouldn't be a 100% strong
guarantee, and even if the slab wouldn't provide strong defrag
avoidance guarantees by design, splitting pages down in the core, and
then merging them up outside the core, sounds less efficient than
keeping the pages large in the core, and then splitting them outside
the core for the few non-performance critical small users. We're not
talking about laptops here, if the major load happens on tiny things
and tiny objects nobody should compile a kernel with 64k page size,
which is why there need to be 2 rpm to get peak performance.
