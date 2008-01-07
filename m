Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbYAGUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbYAGUnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYAGUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:43:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:20209 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYAGUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QbKVoLaERnDySF8PPsN7m/FjFr2tWOkkUXuyl4xaZ8/qkXsbKsc4Lcse3oQLi1dz6wdsWXIOZMaAgRdFXPdLbUVk1AvpBkfpSYJyQE5x5XH7TdLl0F7tcRPIzZD0ktAeRQht6FyDEkUKHCxieNu7nKDIbbGB2G8U86KmgFUaRLc=
Date: Mon, 7 Jan 2008 21:44:26 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] udf: convert some macros to functions
Message-ID: <20080107204413.GB22144@joi>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com> <1199580275-2487-6-git-send-email-marcin.slusarz@gmail.com> <20080107122617.GB3710@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080107122617.GB3710@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 12:26:18PM +0000, Christoph Hellwig wrote:
> On Sun, Jan 06, 2008 at 01:44:34AM +0100, marcin.slusarz@gmail.com wrote:
> > +static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, __u32 index)
> > +{
> > +	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
> > +	int nr_groups = (map->s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +
> > +		(sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
> > +	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
> > +	struct udf_bitmap *bitmap;
> > +
> > +	if (size <= PAGE_SIZE)
> > +		bitmap = kmalloc(size, GFP_KERNEL);
> > +	else
> > +		bitmap = vmalloc(size);
> > +	if (bitmap != NULL) {
> > +		memset(bitmap, 0x00, size);
> > +		bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
> > +		bitmap->s_nr_groups = nr_groups;
> > +	} else
> > +		udf_error(sb, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);
> > +	return bitmap;
> > +}
> 
> There's some overly long lines here and some odd style, this should look
> more like:
These long lines were split later in "[PATCH 1/7] udf: fix coding style"
(but I will fix it in next version of this patch).

> static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb,
> 		u32 index)
> {
> 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
> 	struct udf_bitmap *bitmap;
> 	int nr_groups;
> 	int size;
> 
> 	nr_groups = (map->s_partition_len +
> 		(sizeof(struct spaceBitmapDesc) << 3) +
> 		 (sb->s_blocksize * 8) - 1) /
> 		(sb->s_blocksize * 8);
> 	size = sizeof(struct udf_bitmap) +
> 		(sizeof(struct buffer_head *) * nr_groups);
> 	if (size <= PAGE_SIZE)
> 		bitmap = kmalloc(size, GFP_KERNEL);
> 	else
> 		bitmap = vmalloc(size);
> 
> 	if (!bitmap) {
> 		udf_error(sb, __FUNCTION__,
> 			  "Unable to allocate space for bitmap "
> 			  "and %d buffer_head pointers", nr_groups);
> 		return NULL;
> 	}
> 
> 	memset(bitmap, 0, size);
> 	bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
> 	bitmap->s_nr_groups = nr_groups;
> 	return bitmap;
> }
Yep. This looks better.

> But even that is not quite optimal.  The nr_groups calculation should
> probably move to a helper (I suspect it's used elsewhere too anyway),
I will look for them. I've seen many weird calculations in udf code
and I think it's a good idea to move some of them into helpers.

> and instead of using vmalloc for large allocations I'd rather split
> the allocation of the bitmap from s->block_bitmap and use individual
> smaller allocations.  But that latter part is probably better left
> for a separate patch.
So every struct buffer_head * in bitmap will be indexed by a pair of:
idx >> ilog2(PAGE_SIZE / sizeof(struct buffer_head *))
idx & ((PAGE_SIZE / sizeof(struct buffer_head *)) - 1)
Am I right? Or did I misunderstand something?
I don't know how big nr_groups could be, but it might still need vmalloc
when array of pages won't fit on one page...

> But in generally this is a good cleanup and thanks a lot for working
> on this filesystem driver.
Thanks! :)

Marcin
