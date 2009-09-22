Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZIVDvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZIVDvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 23:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZIVDvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 23:51:37 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:65325 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZIVDvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 23:51:36 -0400
Message-ID: <4AB8498C.6040804@vflare.org>
Date: Tue, 22 Sep 2009 09:20:36 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 1/4] xvmalloc memory allocator
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org> <1253227412-24342-2-git-send-email-ngupta@vflare.org> <4AB3F60D.2030808@gmail.com>
In-Reply-To: <4AB3F60D.2030808@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late reply. I nearly missed this mail. My comments inline.

On 09/19/2009 02:35 AM, Marcin Slusarz wrote:
> Nitin Gupta wrote:
>> (...)
>> +
>> +/*
>> + * Allocate a memory page. Called when a pool needs to grow.
>> + */
>> +static struct page *xv_alloc_page(gfp_t flags)
>> +{
>> +	struct page *page;
>> +
>> +	page = alloc_page(flags);
>> +	if (unlikely(!page))
>> +		return 0;
>> +
>> +	return page;
>> +}
> 
> When alloc_page returns 0 it returns 0, when not - it returns page.
> Why not call alloc_page directly?
> 

We now call alloc_page() and __free_page directly. Removed these wrappers.

>> (...)
>> +/*
>> + * Remove block from freelist. Index 'slindex' identifies the freelist.
>> + */
>> +static void remove_block(struct xv_pool *pool, struct page *page, u32 offset,
>> +			struct block_header *block, u32 slindex)
>> +{
>> +	u32 flindex;
>> +	struct block_header *tmpblock;
<snip>
>> +
>> +	return;
>> +}
> 
> needless return
> 

Removed.


>> +int xv_malloc(struct xv_pool *pool, u32 size, struct page **page,
>> +		u32 *offset, gfp_t flags)
>> +{
>> +	int error;
>> +	
<snip>
>> +	if (!*page) {
>> +		spin_unlock(&pool->lock);
>> +		if (flags & GFP_NOWAIT)
>> +			return -ENOMEM;
>> +		error = grow_pool(pool, flags);
>> +		if (unlikely(error))
>> +			return -ENOMEM;
> 
> shouldn't it return error? (grow_pool returns 0 or -ENOMEM for now but...)
>

Yes, it should return error. Corrected.

 
>> +
>> +		spin_lock(&pool->lock);
>> +		index = find_block(pool, size, page, offset);
>> +	}
>> +
>> +	if (!*page) {
>> +		spin_unlock(&pool->lock);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	block = get_ptr_atomic(*page, *offset, KM_USER0);
>> +
>> +	remove_block_head(pool, block, index);
>> +
>> +	/* Split the block if required */
>> +	tmpoffset = *offset + size + XV_ALIGN;
>> +	tmpsize = block->size - size;
>> +	tmpblock = (struct block_header *)((char *)block + size + XV_ALIGN);
>> +	if (tmpsize) {
>> +		tmpblock->size = tmpsize - XV_ALIGN;
>> +		set_flag(tmpblock, BLOCK_FREE);
>> +		clear_flag(tmpblock, PREV_FREE);
>> +
>> +		set_blockprev(tmpblock, *offset);
>> +		if (tmpblock->size >= XV_MIN_ALLOC_SIZE)
>> +			insert_block(pool, *page, tmpoffset, tmpblock);
>> +
>> +		if (tmpoffset + XV_ALIGN + tmpblock->size != PAGE_SIZE) {
>> +			tmpblock = BLOCK_NEXT(tmpblock);
>> +			set_blockprev(tmpblock, tmpoffset);
>> +		}
>> +	} else {
>> +		/* This block is exact fit */
>> +		if (tmpoffset != PAGE_SIZE)
>> +			clear_flag(tmpblock, PREV_FREE);
>> +	}
>> +
>> +	block->size = origsize;
>> +	clear_flag(block, BLOCK_FREE);
>> +
>> +	put_ptr_atomic(block, KM_USER0);
>> +	spin_unlock(&pool->lock);
>> +
>> +	*offset += XV_ALIGN;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Free block identified with <page, offset>
>> + */
>> +void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
>> +{
<snip>
>> +	return;
>> +}
> 
> needless return
> 
> 

Removed.


Regarding your comments on page_zero_filled: I'm not sure if using unsigned
long is better or just u64 irrespective of arch. I just changed it to ulong
 -- some bechmarks can help decide which one is optimal. Maybe we need arch
specific optimized versions which means moving it to lib/ or something.


Thanks for your feedback.

Nitin
