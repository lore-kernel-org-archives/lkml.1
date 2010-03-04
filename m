Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0CDQEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:04:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab0CDQEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:04:14 -0500
Date: Thu, 4 Mar 2010 08:03:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Josef Bacik <josef@redhat.com>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup __generic_block_fiemap and fix a few minor
 issues
In-Reply-To: <20100303163715.GB2215@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003040754150.7046@localhost.localdomain>
References: <20100303163715.GB2215@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Josef Bacik wrote:
> 
> 1) Some filesystems (gfs2) do not like being given non-block-aligned b_size's to
> map, so make sure we block align the b_size.

As far as I can tell, that alignment is wrong.

You can't just align "len". If "start" wasn't aligned, then just aligning 
"len" is wrong. And if start is guaranteed to be aligned, how?

Also, the alignment itself is ugly as hell, doing

> +	len = (len + (1 << inode->i_blkbits) - 1) &
> +		~((1 << inode->i_blkbits) - 1);
> +	map_end = start + len;

When what you probably should have done is to do

	map_end = start + len;

_before_ rounding 'start', and then after that you can now map 'start' and 
'map_end' just using the regular "logical_to_blk" that you already use (up 
or down depending on whether the thing should be inclusive or exclusive of 
partial blocks). No?

IOW, the whole thing should probably look something like

	sector_t start_blk, last_blk;

	start_blk = logical_to_blk(inode, start);
	last_blk = logical_to_blk(inode, start + len - 1);

and you're done. Short, sweet, and to the point (note that "last_blk" 
really is the _last_ block, so if you want the length in blocks, it would 
be "last_blk - start_blk + 1").

			Linus
