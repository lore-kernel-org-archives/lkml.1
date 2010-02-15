Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab0BOWIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:08:20 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:51207 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932076Ab0BOWIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:08:19 -0500
Date: Tue, 16 Feb 2010 09:08:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: bug list: range checking issues
Message-ID: <20100215220815.GF28392@discord.disaster>
References: <20100215124046.GB18821@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215124046.GB18821@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 03:40:56PM +0300, Dan Carpenter wrote:
> This is the results from:
>     make C=1 CHECK="/path/to/smatch -p=kernel" bzImage modules | tee warns.txt
>     grep -w overflow warns.txt | uniq -f 3 | tee err-list
> 
> I hacked on the buffer overflow check last weekend and these are the 
> results.  It has way more false positives than the other bug lists 
> I've posted, but it's still kinda neat.

I'll come back to this.

> It works like this:
> 
> lib/zlib_inflate/inftrees.c
>    112      for (min = 1; min <= MAXBITS; min++)
>    113          if (count[min] != 0) break;
>    114      if (root < min) root = min;
> smatch thinks "min" can be MAXBITS here.
> 
> One bad thing is that if you have code like:
>         if (foo == 42)
> 		frob();
> Smatch thinks that "foo" can be 43 after the if statement.

I think you understate the number of problems this matching rule
has.

.....
> fs/xfs/xfs_attr_leaf.c +1097 xfs_attr_leaf_add_work(33) warn: buffer overflow 'hdr->freemap' 3 <= 3

	ASSERT((mapindex >= 0) && (mapindex < XFS_ATTR_LEAF_MAPSIZE));
	.....
	map = &hdr->freemap[mapindex];

=> False positive.

> fs/xfs/xfs_da_btree.c +159 xfs_da_split(15) error: buffer overflow 'state->path.blk' 5 <= 5
> fs/xfs/xfs_da_btree.c +162 xfs_da_split(18) warn: buffer overflow 'state->path.blk' 5 <= 5

	ASSERT((max >= 0) && (max < XFS_DA_NODE_MAXDEPTH));
	.....
	addblk = &state->path.blk[max];

=> False positives.

> fs/xfs/xfs_dir2_block.c +1152 xfs_dir2_sf_to_block(128) error: buffer overflow 'dep->name' 1 <= 1

	dep->name is a variable length array, size determined by
	dep->namelen.

=> False positives.

> fs/xfs/xfs_dir2_leaf.c +504 xfs_dir2_leaf_addname(343) warn: buffer overflow 'leaf->ents' 1 <= 1
> fs/xfs/xfs_dir2_leaf.c +585 xfs_dir2_leaf_check(30) error: buffer overflow 'leaf->ents' 1 <= 1
> fs/xfs/xfs_dir2_node.c +253 xfs_dir2_leafn_add(69) warn: buffer overflow 'leaf->ents' 1 <= 1
> fs/xfs/xfs_dir2_node.c +286 xfs_dir2_leafn_add(102) error: buffer overflow 'leaf->ents' 1 <= 1
> fs/xfs/xfs_dir2_node.c +305 xfs_dir2_leafn_add(121) warn: buffer overflow 'leaf->ents' 1 <= 1
> fs/xfs/xfs_dir2_node.c +316 xfs_dir2_leafn_add(132) error: buffer overflow 'leaf->ents' 1 <= 1
> fs/xfs/xfs_dir2_node.c +320 xfs_dir2_leafn_add(136) warn: buffer overflow 'leaf->ents' 1 <= 2
> fs/xfs/xfs_dir2_node.c +321 xfs_dir2_leafn_add(137) warn: buffer overflow 'leaf->ents' 1 <= 1
> fs/xfs/xfs_dir2_node.c +361 xfs_dir2_leafn_check(15) error: buffer overflow 'leaf->ents' 1 <= 1

	leaf->ents is a varaible length array, size determined by
	the directory block header.

=> False positives.

> fs/xfs/xfs_dir2_sf.c +115 xfs_dir2_block_sfsize(44) error: buffer overflow 'dep->name' 1 <= 1

	as per above

=> False positive.

> fs/xfs/xfs_inode.c +3562 xfs_iext_remove_inline(14) warn: buffer overflow 'ifp->if_u2.if_inline_ext' 2 <= 2

	ASSERT(idx < XFS_INLINE_EXTS);
	....
	ASSERT(((nextents - ext_diff) > 0) &&
		(nextents - ext_diff) < XFS_INLINE_EXTS);

=> False positive

So for XFS your tool has produced 100% false positives. I think you
really need to spend more time reducing the incidence of false
positives before reporting lists of potential buffer overflows to
lkml. There may be some real ones in this list, but reporting tens
of false positives with no real substance just wastes everyone's
time. Static code checking only has value if there is a
high signal to noise ratio....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
