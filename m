Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYAGM0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYAGM0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYAGM0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:26:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38813 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYAGM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:26:24 -0500
Date: Mon, 7 Jan 2008 12:26:18 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] udf: convert some macros to functions
Message-ID: <20080107122617.GB3710@infradead.org>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com> <1199580275-2487-6-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199580275-2487-6-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:44:34AM +0100, marcin.slusarz@gmail.com wrote:
> +static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, __u32 index)
> +{
> +	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
> +	int nr_groups = (map->s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +
> +		(sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
> +	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
> +	struct udf_bitmap *bitmap;
> +
> +	if (size <= PAGE_SIZE)
> +		bitmap = kmalloc(size, GFP_KERNEL);
> +	else
> +		bitmap = vmalloc(size);
> +	if (bitmap != NULL) {
> +		memset(bitmap, 0x00, size);
> +		bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
> +		bitmap->s_nr_groups = nr_groups;
> +	} else
> +		udf_error(sb, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);
> +	return bitmap;
> +}

There's some overly long lines here and some odd style, this should look
more like:

static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb,
		u32 index)
{
	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
	struct udf_bitmap *bitmap;
	int nr_groups;
	int size;

	nr_groups = (map->s_partition_len +
		(sizeof(struct spaceBitmapDesc) << 3) +
		 (sb->s_blocksize * 8) - 1) /
		(sb->s_blocksize * 8);
	size = sizeof(struct udf_bitmap) +
		(sizeof(struct buffer_head *) * nr_groups);
	if (size <= PAGE_SIZE)
		bitmap = kmalloc(size, GFP_KERNEL);
	else
		bitmap = vmalloc(size);

	if (!bitmap) {
		udf_error(sb, __FUNCTION__,
			  "Unable to allocate space for bitmap "
			  "and %d buffer_head pointers", nr_groups);
		return NULL;
	}

	memset(bitmap, 0, size);
	bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
	bitmap->s_nr_groups = nr_groups;
	return bitmap;
}

But even that is not quite optimal.  The nr_groups calculation should
probably move to a helper (I suspect it's used elsewhere too anyway),
and instead of using vmalloc for large allocations I'd rather split
the allocation of the bitmap from s->block_bitmap and use individual
smaller allocations.  But that latter part is probably better left
for a separate patch.

But in generally this is a good cleanup and thanks a lot for working
on this filesystem driver.
