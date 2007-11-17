Return-Path: <linux-kernel-owner+w=401wt.eu-S1764324AbXKQC7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764324AbXKQC7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 21:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbXKQC7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 21:59:04 -0500
Received: from thunk.org ([69.25.196.29]:58504 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXKQC7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 21:59:03 -0500
Date: Fri, 16 Nov 2007 21:58:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Abhishek Rai <abhishekrai@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Mike Waychison <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Message-ID: <20071117025841.GK11339@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Abhishek Rai <abhishekrai@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
	Ken Chen <kenchen@google.com>, Mike Waychison <mikew@google.com>
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com> <20071115230219.1fe9338c.akpm@linux-foundation.org> <20071116211133.GJ11339@thunk.org> <d9885f0f0711161625u76c6e6dbgf3fbabe8a11e771b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9885f0f0711161625u76c6e6dbgf3fbabe8a11e771b@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 04:25:38PM -0800, Abhishek Rai wrote:
> Ideally, this is how things should be done, but I feel in practice, it
> will make little difference. To summarize, the difference between
> my approach and above approach is that when out of free blocks in a
> block group while allocating indirect block, the above approach repeats
> the same allocation algorithm in the next block group, while I fully
> fall back to old-style allocation meaning the indirect block gets
> co-located with the data block in the next block group with a free
> block.

Well, also I suggested that if the metacluster region is full, that it
attempt to find a block starting at end of the metacluster region and
then wrap around, instead of starting at the beginning of the block
group.  That way it's more likely that subsequent metadata block is
nearer to the previous metadata blocks.

> In practice, this will make a difference only for one indirect
> block as from next request onwards the goal will be updated to the new
> group making the behavior like what you propose. Still, I think your
> suggestion is cleaner and I'll change to that.

The practice of starting search in the next block block in the
metadata area only makes a difference for one indirect block, yes, but
it's the right thing to do.  And if you fold the ext3_new_blocks and
ext3_new_indirect_blocks(), it's really not that hard.  You can
basically do something like this:

	if (alloc_for_metadata)
		strategy = 0x132;
	else
		strategy = 0x231;
	for (; strategy; strategy = strategy >> 8) {
		switch (strategy & 0xF) {
		case 1:
		     start = block_group_start;
		     end = mc_start - 1;
		     break;
		case 2:
		     start = mc_start;
		     end = mc_end;
		     break;
		case 3:
		     start = mc_end + 1;
		     end = block_group_end;
		     break;
		}
		<search region between start.. end>
	}

> We initially avoided making metaclustering a superblock tunable as we
> didn't want to make any changes to the on-disk format as then ext4
> extents are also a good option.

Allocating a superblock field is no big deal.  I'll note further that
metaclustering is not necessarily mutually exclusive with ext4
extents.  Allocating the extent tree data blocks out of the
metacluster blocks can be a good idea, depending on the average size
of the blocks and how fragmented the filesystem gets (and hence how
many contiguous extents can be expected).  If the filesystem is
storing lots of really big files where being contiguous across
multiple blockgroups are productive, then the metacluster area would
actually be counterproductive.  And if files are all small so the
extents fit the inode, the metadata cluster area wouldn't be necessary
at all.  But if there are multiple external extent blocks in a block
group, it would be useful for them to be allocated together.  

> If metaclustering gains acceptance
> it might make sense to make it a superblock tunable. However, I would
> avoid putting metacluster size into the superblock for the following
> reason. Ideally, we should not have to bother about finding the sweet
> spot of metacluster size as
> (1) a given file system can be used for storing different kinds
> of files at different times and it would be a pain to tune it every now
> and then, and

Yes, it doesn't make sense to retune the filesystem.  I was assuming
that this would only be done at mke2fs time.

> (2) it opens the possibility of doubting metcluster size for unrelated
> ext3/fsck performance anomalies.

I'm not sure I understand your concern.  The reality is that 99% of
the time users will never change it from the defaults, but making it
tunable makes it much, much easier for us to try various experiments
to determine what is the best initial value for different workloads.
What might get used for a Usenet news spool or a Squid cache might be
quite different from series of DVD image files.

> Allow me to propose a solution that will most likely address the above
> issue and please ignore its complexity for a moment. Instead of a two
> level partitioning in the block space between data blocks and
> metacluster blocks, have a 3 or 4 level partitioning. E.g., a block
> group with 'd' blocks can have d/32 blocks in metacluster level 1,
> d/64 blocks in metacluster level 2, and d/128 blocks in metacluster
> level 3 (define level 0 has having the remaining blocks = d - d/32 -
> d/64 - d/128). Data block allocation starts looking for a free block
> starting from the lowest possible level. If it is unable to find any
> free blocks at that level in all block groups, it moves up a level and
> so on. Indirect block allocation proceeds in the opposite direction
> starting from higher levels. This approach has several benefits:

That is clever.  Oh, one other thing.  You didn't mention what
happened when the metacluster field was placed at the end of the block
group.  I assume you tried that in your experiments; what were the
results?  The obvious thing to do to avoid further fragmentation of
the block group would be to put level 1 at the end of the block group,
level 2 just before it, and level 3 before that, and then allocate the
data blocks starting at the beginning of the block group, i.e:

+----------------------------------+---------------+---------+-------+
|     data                         | level 3       | level 2 | lvl 1 |
+----------------------------------+---------------+---------+-------+


> In traditional metaclustering, once we run out of metacluster blocks
> or data blocks, all bets are off. This forces us to keep small
> metaclusters in order to avoid this situation altogether. But with small
> metaclusters, we cannot optimize indirect block allocation on file
> systems with many small files (>48KB).There is only one glitch in
> implementing this. If a block group doesn't have any free blocks at a
> given level, we should be able to find that out quickly instead of
> having to scan its entire bitmap. gdp->bg_free_blocks_count is not good
> enough for this.

Ideally, true, but this was a defect with the original metacluster
scheme as well.  We could steal some bits in the block_group
descriptor structure to indicate whether a particular level is full,
though.  This would be another data format change that would require
e2fsprogs support, though.

Regards,

						- Ted
