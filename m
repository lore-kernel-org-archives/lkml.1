Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZHXRd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZHXRd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZHXRd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:33:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49842 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbZHXRdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RRnr829TZGXzcfUYiyrOQMDxB1Ml197KiQutep4kL2ZJn1bheXxTfjXcNYKu2MHZjp
         oltd1me8ayAMtOHGIw9kkNYhasXqY/cL0RWFY0pEZmgGGhaX2+dBka9V2IZO5oFkYqkK
         sML9bfsCzvohPDM4Ul9qvLyezy2vLEvbg10bA=
MIME-Version: 1.0
In-Reply-To: <200908241007.47910.ngupta@vflare.org>
References: <200908241007.47910.ngupta@vflare.org>
Date: Mon, 24 Aug 2009 20:33:25 +0300
X-Google-Sender-Auth: 1f156cd136f11c82
Message-ID: <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

[ Nit: the name xmalloc() is usually reserved for non-failing allocators in
  user-space which is why xvmalloc() looks so confusing to me. Can we
  get a better name for the thing? Also, I'm not sure why xvmalloc is a
  separate module. Can't you just make it in-kernel or compile it in to the
  ramzswap module? ]

On Mon, Aug 24, 2009 at 7:37 AM, Nitin Gupta<ngupta@vflare.org> wrote:
> +/**
> + * xv_malloc - Allocate block of given size from pool.
> + * @pool: pool to allocate from
> + * @size: size of block to allocate
> + * @pagenum: page no. that holds the object
> + * @offset: location of object within pagenum
> + *
> + * On success, <pagenum, offset> identifies block allocated
> + * and 0 is returned. On failure, <pagenum, offset> is set to
> + * 0 and -ENOMEM is returned.
> + *
> + * Allocation requests with size > XV_MAX_ALLOC_SIZE will fail.
> + */
> +int xv_malloc(struct xv_pool *pool, u32 size, u32 *pagenum, u32 *offset,
> +                                                       gfp_t flags)
> +{
> +       int error;
> +       u32 index, tmpsize, origsize, tmpoffset;
> +       struct block_header *block, *tmpblock;
> +
> +       *pagenum = 0;
> +       *offset = 0;
> +       origsize = size;
> +
> +       if (unlikely(!size || size > XV_MAX_ALLOC_SIZE))
> +               return -ENOMEM;
> +
> +       size = ALIGN(size, XV_ALIGN);
> +
> +       spin_lock(&pool->lock);
> +
> +       index = find_block(pool, size, pagenum, offset);
> +
> +       if (!*pagenum) {
> +               spin_unlock(&pool->lock);
> +               if (flags & GFP_NOWAIT)
> +                       return -ENOMEM;
> +               error = grow_pool(pool, flags);
> +               if (unlikely(error))
> +                       return -ENOMEM;
> +
> +               spin_lock(&pool->lock);
> +               index = find_block(pool, size, pagenum, offset);
> +       }
> +
> +       if (!*pagenum) {
> +               spin_unlock(&pool->lock);
> +               return -ENOMEM;
> +       }
> +
> +       block = get_ptr_atomic(*pagenum, *offset, KM_USER0);
> +
> +       remove_block_head(pool, block, index);
> +
> +       /* Split the block if required */
> +       tmpoffset = *offset + size + XV_ALIGN;
> +       tmpsize = block->size - size;
> +       tmpblock = (struct block_header *)((char *)block + size + XV_ALIGN);
> +       if (tmpsize) {
> +               tmpblock->size = tmpsize - XV_ALIGN;
> +               set_flag(tmpblock, BLOCK_FREE);
> +               clear_flag(tmpblock, PREV_FREE);
> +
> +               set_blockprev(tmpblock, *offset);
> +               if (tmpblock->size >= XV_MIN_ALLOC_SIZE)
> +                       insert_block(pool, *pagenum, tmpoffset, tmpblock);
> +
> +               if (tmpoffset + XV_ALIGN + tmpblock->size != PAGE_SIZE) {
> +                       tmpblock = BLOCK_NEXT(tmpblock);
> +                       set_blockprev(tmpblock, tmpoffset);
> +               }
> +       } else {
> +               /* This block is exact fit */
> +               if (tmpoffset != PAGE_SIZE)
> +                       clear_flag(tmpblock, PREV_FREE);
> +       }
> +
> +       block->size = origsize;
> +       clear_flag(block, BLOCK_FREE);
> +
> +       put_ptr_atomic(block, KM_USER0);
> +       spin_unlock(&pool->lock);
> +
> +       *offset += XV_ALIGN;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(xv_malloc);

What's the purpose of passing PFNs around? There's quite a lot of PFN
to struct page conversion going on because of it. Wouldn't it make
more sense to return (and pass) a pointer to struct page instead?

                        Pekka
