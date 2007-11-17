Return-Path: <linux-kernel-owner+w=401wt.eu-S934374AbXKQAZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbXKQAZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 19:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759756AbXKQAZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 19:25:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:51446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbXKQAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 19:25:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=w6JYNhxhDApotgCKQyy6FqX6hkGCLdvVh8bv8UjrKJVjUUTRacG9PQ5XV7Te6pU3b
	Z00ADVpac3jQmrf+FXzxQ==
Message-ID: <d9885f0f0711161625u76c6e6dbgf3fbabe8a11e771b@mail.gmail.com>
Date: Fri, 16 Nov 2007 16:25:38 -0800
From: "Abhishek Rai" <abhishekrai@google.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Abhishek Rai" <abhishekrai@google.com>,
       "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
In-Reply-To: <20071116211133.GJ11339@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
	 <20071115230219.1fe9338c.akpm@linux-foundation.org>
	 <20071116211133.GJ11339@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the great feedback.

On Nov 16, 2007 1:11 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Nov 15, 2007 at 11:02:19PM -0800, Andrew Morton wrote:
> > What happens when it fills up but we still have room for more data blocks
> > in that blockgroup?
>
> It does fall back, but it does so starting from the beginning of the
> block group by using the old-style allocation routines if it can't
> find any space in the metacluster region.  What I'd suggest that it do
> instead is to start searching from the end of metacluster region, and
> then wrap around to the beginning of the block group,

When we fallback to old-style allocation, new blocks get allocated next
to the goal and are thus co-located with the corresponding data blocks.

> and then if it
> can't find any blocks when it reaches the beginning of the metacluster
> region, then go to the next block group that would be used by
> ext3_new_blocks(), and start searching in the metacluster region ---
> that way a smart e2fsck that is doing clustering could just arrange to
> pre-read the metacluster region for each block group, and if it finds
> an indirect block that is another block group's metacluster region, it
> could try reading in those blocks too.

Ideally, this is how things should be done, but I feel in practice, it
will make little difference. To summarize, the difference between
my approach and above approach is that when out of free blocks in a
block group while allocating indirect block, the above approach repeats
the same allocation algorithm in the next block group, while I fully
fall back to old-style allocation meaning the indirect block gets
co-located with the data block in the next block group with a free
block. In practice, this will make a difference only for one indirect
block as from next request onwards the goal will be updated to the new
group making the behavior like what you propose. Still, I think your
suggestion is cleaner and I'll change to that.

>
> In order to do this, I'd suggest considering to fold ext3_new_blocks
> and ext3_new_indirect_blocks() into the same function, with just a
> passed-in flag to indicate whether for each block group the
> metacluster region or the non-metacluster region should be searched
> first.  This would also make elimiate some duplicated code.

Makes sense, will do.

>
> > Can this reserved area cause disk space wastage (all data blocks used,
> > metacluster area not yet full).
>
> No, not as far as I can see.
>
> > Less speedup, for more-and-smaller files, it appears.
> >
> > An important question is: how does it stand up over time?  Simply laying
> > files out a single time on a fresh fs is the easy case.  But what happens
> > if that disk has been in continuous create/delete/truncate/append usage for
> > six months?
>
> Another question is how does it stand up if the average size of files
> is different from what you anticipate?  If the files are bigger than
> you expect, or smaller than you expect, then the ratio of indirect
> blocks to data blocks will be different, at which point allocations
> won't be perfectly split up between metacluster region.
>
> For this reason, the exact size of the metacluster region should
> probably be a superblock tunable --- and once we have the superblock
> tunable, I'd use the non-zero metacluster size to determine whether or
> not to enable this feature, and not to use a mount option.  Mount
> options really should be avoided whenever possible, in favor of
> settings in the superblock.
>
>                                                 - Ted
>

We initially avoided making metaclustering a superblock tunable as we
didn't want to make any changes to the on-disk format as then ext4
extents are also a good option. If metaclustering gains acceptance
it might make sense to make it a superblock tunable. However, I would
avoid putting metacluster size into the superblock for the following
reason. Ideally, we should not have to bother about finding the sweet
spot of metacluster size as
(1) a given file system can be used for storing different kinds
of files at different times and it would be a pain to tune it every now
and then, and
(2) it opens the possibility of doubting metcluster size for unrelated
ext3/fsck performance anomalies.
The user should be able to just enable metaclustering and ext3 should
take care of the rest as best as it can. That said, some type of coarse
metaclustering advice can definitely be stored in the superblock.

Allow me to propose a solution that will most likely address the above
issue and please ignore its complexity for a moment. Instead of a two
level partitioning in the block space between data blocks and
metacluster blocks, have a 3 or 4 level partitioning. E.g., a block
group with 'd' blocks can have d/32 blocks in metacluster level 1,
d/64 blocks in metacluster level 2, and d/128 blocks in metacluster
level 3 (define level 0 has having the remaining blocks = d - d/32 -
d/64 - d/128). Data block allocation starts looking for a free block
starting from the lowest possible level. If it is unable to find any
free blocks at that level in all block groups, it moves up a level and
so on. Indirect block allocation proceeds in the opposite direction
starting from higher levels. This approach has several benefits:

In traditional metaclustering, once we run out of metacluster blocks
or data blocks, all bets are off. This forces us to keep small
metaclusters in order to avoid this situation altogether. But with small
metaclusters, we cannot optimize indirect block allocation on file
systems with many small files (>48KB).There is only one glitch in
implementing this. If a block group doesn't have any free blocks at a
given level, we should be able to find that out quickly instead of
having to scan its entire bitmap. gdp->bg_free_blocks_count is not good
enough for this.

Thanks,
Abhishek
