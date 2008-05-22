Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbYEVIEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbYEVIEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761002AbYEVIEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:04:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760617AbYEVIED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:04:03 -0400
Date: Thu, 22 May 2008 01:03:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Pagecache usage optimization on pagesize
 !=blocksize environment
Message-Id: <20080522010355.32590474.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
	<20080521001930.202446eb.akpm@linux-foundation.org>
	<6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 16:31:15 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> I modified my patch based on your comment.

Looks pretty close to me.

> I added is_partially_uptodate method to address_space_operations, and
> I registered block_is_partially_uptodate in fs/buffer.c to ext2,ext3,ext4's aops.
> Thanks.
> 
> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> 
> diff -Nrup linux-2.6.26-rc3.org/fs/buffer.c linux-2.6.26-rc3/fs/buffer.c
> --- linux-2.6.26-rc3.org/fs/buffer.c	2008-05-19 11:35:10.000000000 +0900
> +++ linux-2.6.26-rc3/fs/buffer.c	2008-05-22 13:23:29.000000000 +0900
> @@ -2084,6 +2084,51 @@ int generic_write_end(struct file *file,
>  EXPORT_SYMBOL(generic_write_end);
>  
>  /*
> + * block_is_partially_uptodate checks whether buffers within a page are
> + * uptodate or not.
> + *
> + * Returns true if all buffers which correspond to a file portion
> + * we want to read are uptodate.
> + */
> +int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
> +					unsigned long from)
> +{
> +	struct inode *inode = page->mapping->host;
> +	unsigned long block_start, block_end, blocksize;
> +	unsigned long to;

These functions can get quite confusing, and the appropriate use of
types can help.

For offsets within a page I'd suggest `unsigned'.  I expect that the
32-bit quantities are more efficient on at least some 64-bit machines.

For page indices use pgoff_t.

For byte-offset-within-a-file use loff_t.

For byte-range-within-a-file use size_t.

Be careful about overflows and truncation when shifting, comparing,
assigning, etc.  Be sure that the code is still correct outside the
4Gbyte mark on 32-bit and outside the 4Gpage mark on 64-bit.

It doesn't hurt at all to put each variable definition on its own line
with a little comment off to the right.  It helps to mention what the
variable's units are too - bytes/pages/sectors/etc.

> +	struct buffer_head *bh, *head;
> +	int ret = 1;
> +
> +	if (!page_has_buffers(page))
> +		return 0;
> +
> +	blocksize = 1 << inode->i_blkbits;
> +	to = from + desc->count;
> +	if (to > PAGE_CACHE_SIZE)
> +		to = PAGE_CACHE_SIZE;
> +	if (from < blocksize && to > PAGE_CACHE_SIZE - blocksize)
> +		return 0;
> +
> +	head = page_buffers(page);
> +
> +	for (bh = head, block_start = 0; bh != head || !block_start;
> +	     block_start = block_end, bh = bh->b_this_page) {
> +		block_end = block_start + blocksize;
> +		if (block_end <= from || block_start >= to)
> +			continue;

Oh dear, you've copied one of my least favourite parts of the VFS :(
Just look at it!

Do you think it can be simplified or clarified?

> +		else {
> +			if (!buffer_uptodate(bh)) {
> +				ret = 0;
> +				break;
> +			}
> +			if (block_end >= to)
> +				break;
> +		}
> +	}
> +	return ret;
> +}

We'll need the EXPORT_SYMBOL() here.

> --- linux-2.6.26-rc3.org/fs/ext2/inode.c	2008-05-19 11:35:10.000000000 +0900
> +++ linux-2.6.26-rc3/fs/ext2/inode.c	2008-05-22 12:39:46.000000000 +0900
> @@ -791,6 +791,7 @@ const struct address_space_operations ex
>  	.direct_IO		= ext2_direct_IO,
>  	.writepages		= ext2_writepages,
>  	.migratepage		= buffer_migrate_page,
> +	.is_partially_uptodate	= block_is_partially_uptodate,

Sometime we should update Documentation/Locking to reflect the new
address_space_operation.


One other thing we should think about here is the `nobh' mode which the
extX filesystems support (although I have a feeling that Nick might
have broken this ;)) We also have data=ordered, data=writeback and
data=journal to think about.  This optimisation might not be
appropriate at all to data=journal mode, but I haven't looked into
that.


