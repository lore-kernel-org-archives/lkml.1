Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbZDAPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbZDAPxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbZDAPxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:53:17 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:9032 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760172AbZDAPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:53:17 -0400
Message-ID: <49D38D4B.7020701@panasas.com>
Date: Wed, 01 Apr 2009 18:50:35 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org>
In-Reply-To: <1238593472-30360-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 15:52:35.0098 (UTC) FILETIME=[DFEC97A0:01C9B2E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: more modular implementation
> 
> Break down bio_copy_user_iov() into the following steps.
> 
> 1. bci and page allocation
> 2. copying data if WRITE
> 3. create bio accordingly
> 
> bci is now responsible for managing any copy related resources.  Given
> source iov, bci_create() allocates bci and fills it with enough pages
> to cover the source iov.  The allocated pages are described with a
> sgl.
> 
> Note that new allocator always rounds up rq_map_data->offset to page
> boundary to simplify implementation and guarantee enough DMA padding
> area at the end.  As the only user, scsi sg, always passes in zero
> offset, this doesn't cause any actual behavior difference.  Also,
> nth_page() is used to walk to the next page rather than directly
> adding to struct page *.
> 
> Copying back and forth is done using bio_memcpy_sgl_uiov() which is
> implemented using sg mapping iterator and iov iterator.
> 
> The last step is done using bio_create_from_sgl().
> 
> This patch by itself adds one more level of indirection via sgl and
> more code but components factored out here will be used for future
> code refactoring.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Hi dear Tejun

I've looked hard and deep into your patchset, and I would like to
suggest an improvement.

[Option 1]
What your code is actually using from sgl-code base is:
 for_each_sg
 sg_mapping_iter and it's
	sg_miter_start, sg_miter_next
 ... (what else)

I would like if you can define above for bvec(s) just the way you like
them. Then code works directly on the destination bvect inside the final
bio. One less copy no intermediate allocation, and no kmalloc of
bigger-then-page buffers.

These are all small inlines, duplicating those will not affect
Kernel size at all. You are not using the chaining ability of sgl(s)
so it can be simplified. You will see that not having the intermediate
copy simplifies the code even more.

Since no out-side user currently needs sgl(s) no functionality is lost.

[Option 2]
Keep pointer to sgl and not bvec at bio, again code works on final destination.
Later users of block layer that call blk_rq_fill_sgl (blk_rq_map_sg) will just
get a copy of the pointer and another allocation and copy is gained.
This option will spill outside of the current patches scope. Into bvec hacking
code.


I do like your long term vision of separating the DMA part from the virtual part
of scatterlists. Note how they are actually two disjoint lists altogether. After
the dma_map does its thing the dma physical list might be shorter then virtual
and sizes might not correspond at all. The dma mapping code regards the dma part
as an empty list that gets appended while processing, any segments match is
accidental. (That is: inside the scatterlist the virtual address most probably
does not match the dma address)

So [option 1] matches more closely to that vision.

Historically code was doing
  Many-sources => scatterlist => biovec => scatterlist => dma-scatterlist

Only at 2.6.30 we can say that we shorten a step to do:
  Many-sources => biovec => scatterlist => dma-scatterlist

Now you want to return the extra step, I hate it.
[Option 2] can make that even shorter.
  Many-sources => scatterlist => dma-scatterlist

Please consider [option 1] it will only add some source code
but it will not increase code size, maybe it will decrease,
and it will be fast.

Please consider that this code-path is used by me, in exofs and
pNFS-objcets in a very very hot path, where memory pressure is a
common scenario.

And I have one more question.
Are you sure kmalloc of bigger-then-page buffers are safe? As I
understood it, that tries to allocate physically contiguous pages
which degrades as time passes, and last time I tried this with a kmem_cache
(do to a bug) it crashed the kernel randomly after 2 minutes of use.

Thanks
Boaz
