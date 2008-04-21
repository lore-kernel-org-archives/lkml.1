Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYDUP3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYDUP3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbYDUP30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:29:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51762 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYDUP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:29:25 -0400
To: me@bobcopeland.com
CC: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       me@bobcopeland.com
In-reply-to: <1208637457-24969-6-git-send-email-me@bobcopeland.com> (message
	from Bob Copeland on Sat, 19 Apr 2008 16:37:34 -0400)
Subject: Re: [PATCH 5/8] omfs: add file routines
References: <1208637457-24969-6-git-send-email-me@bobcopeland.com>
Message-Id: <E1JnxxA-0002z2-NY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Apr 2008 17:29:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int omfs_get_block(struct inode *inode, sector_t block,
> +			  struct buffer_head *bh_result, int create)
> +{
> +	struct buffer_head *bh;
> +	sector_t next, offset;
> +	int ret = 0;
> +	u64 new_block;
> +	int extent_count;
> +	struct omfs_extent *oe;
> +	struct omfs_extent_entry *entry;
> +	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
> +	int max_blocks = bh_result->b_size >> inode->i_blkbits;
> +	int remain;
> +
> +	bh = sb_bread(inode->i_sb, clus_to_blk(sbi, inode->i_ino));
> +	if (!bh)
> +		goto err;
> +
> +	oe = (struct omfs_extent *)(&bh->b_data[OMFS_EXTENT_START]);
> +	next = inode->i_ino;
> +
> +	for (;;) {
> +
> +		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next)) {
> +			brelse(bh);
> +			goto err;

Please:
		ret = -EIO;
		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next))
			goto out_brelse;


> +		}
> +		extent_count = be32_to_cpu(oe->e_extent_count);
> +		next = be64_to_cpu(oe->e_next);
> +		entry = &oe->e_entry;
> +
> +		offset = find_block(inode, entry, block, extent_count, &remain);
> +		if (offset > 0) {
> +			brelse(bh);
> +
> +			map_bh(bh_result, inode->i_sb, offset);
> +			if (remain > max_blocks)
> +				remain = max_blocks;
> +			bh_result->b_size = (remain << inode->i_blkbits);
> +			return 0;

This instead?

		if (offset > 0) {
			ret = 0;
			map_bh(bh_result, inode->i_sb, offset);
			if (remain > max_blocks)
				remain = max_blocks;
			bh_result->b_size = (remain << inode->i_blkbits);
			goto out_brelse;
		}

Miklos

> +		}
> +		if (next == ~0)
> +			break;
> +
> +		brelse(bh);
> +		bh = sb_bread(inode->i_sb, clus_to_blk(sbi, next));
> +		if (!bh)
> +			goto err;
> +		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
> +	}
> +	if (create) {
> +		ret = omfs_grow_extent(inode, oe, &new_block);
> +		if (ret == 0) {
> +			mark_buffer_dirty(bh);
> +			mark_inode_dirty(inode);
> +			map_bh(bh_result, inode->i_sb,
> +					clus_to_blk(sbi, new_block));
> +		}
> +	}
> +	brelse(bh);
> +	return ret;
> +err:
> +	return -EIO;
> +}
