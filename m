Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbXKQI6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbXKQI6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 03:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXKQI6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 03:58:24 -0500
Received: from smtp-out.google.com ([216.239.45.13]:13027 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbXKQI6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 03:58:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DBA+y2SkurS0T6mmnEz52yQ1AMwXJ20T40SPiKL3k9TX0vgthSKWp8AfVyNh9Wb11
	SGHxsSY4XeWBbOqhUCCGQ==
Message-ID: <d9885f0f0711170058p183b09b7g11ae93c1f11716db@mail.gmail.com>
Date: Sat, 17 Nov 2007 00:58:21 -0800
From: "Abhishek Rai" <abhishekrai@google.com>
To: "Theodore Tso" <tytso@mit.edu>, "Abhishek Rai" <abhishekrai@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
In-Reply-To: <20071117025841.GK11339@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
	 <20071115230219.1fe9338c.akpm@linux-foundation.org>
	 <20071116211133.GJ11339@thunk.org>
	 <d9885f0f0711161625u76c6e6dbgf3fbabe8a11e771b@mail.gmail.com>
	 <20071117025841.GK11339@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments.

On Nov 16, 2007 6:58 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Nov 16, 2007 at 04:25:38PM -0800, Abhishek Rai wrote:
> > Ideally, this is how things should be done, but I feel in practice, it
> > will make little difference. To summarize, the difference between
> > my approach and above approach is that when out of free blocks in a
> > block group while allocating indirect block, the above approach repeats
> > the same allocation algorithm in the next block group, while I fully
> > fall back to old-style allocation meaning the indirect block gets
> > co-located with the data block in the next block group with a free
> > block.
>
> Well, also I suggested that if the metacluster region is full, that it
> attempt to find a block starting at end of the metacluster region and
> then wrap around, instead of starting at the beginning of the block
> group.  That way it's more likely that subsequent metadata block is
> nearer to the previous metadata blocks.

Ah ok. I think a generalization of this idea is that when we must mix
indirect blocks and data blocks, at least start the search for a free
block for them from different parts of the block group. Of course, an
added benefit of your suggestion is that the non-metaclustered
indirect blocks will likely be close to the metacluster.

I think this approach will help fsck but from a design point of view it
may not be good for IO performance. E.g., the reason sequential
read performance with metaclustering is same as regular is
because we prefetch co-located indirect blocks (I have verified this by
turning off prefetching). When allocating indirect
blocks outside the metacluster using the above scheme, co-location of
indirect blocks is still likely but less so. OTOH, by falling back to the
old-style allocation routines, we at least make sure that the indirect
block is close to its data block which is good for performance. I think
both approaches are pretty close. One thumb rule we've followed during
metaclustering design is: "when in doubt, favor IO performance over
fsck performance" so I tend to lean towards the latter approach.

> [More comments which I will incorporate in the code]
>
> > Allow me to propose a solution that will most likely address the above
> > issue and please ignore its complexity for a moment. Instead of a two
> > level partitioning in the block space between data blocks and
> > metacluster blocks, have a 3 or 4 level partitioning. E.g., a block
> > group with 'd' blocks can have d/32 blocks in metacluster level 1,
> > d/64 blocks in metacluster level 2, and d/128 blocks in metacluster
> > level 3 (define level 0 has having the remaining blocks = d - d/32 -
> > d/64 - d/128). Data block allocation starts looking for a free block
> > starting from the lowest possible level. If it is unable to find any
> > free blocks at that level in all block groups, it moves up a level and
> > so on. Indirect block allocation proceeds in the opposite direction
> > starting from higher levels. This approach has several benefits:
>
> That is clever.  Oh, one other thing.  You didn't mention what
> happened when the metacluster field was placed at the end of the block
> group.  I assume you tried that in your experiments; what were the
> results?  The obvious thing to do to avoid further fragmentation of
> the block group would be to put level 1 at the end of the block group,
> level 2 just before it, and level 3 before that, and then allocate the
> data blocks starting at the beginning of the block group, i.e:
>
> +----------------------------------+---------------+---------+-------+
> |     data                         | level 3       | level 2 | lvl 1 |
> +----------------------------------+---------------+---------+-------+
>

Thanks for this nice visualization :-)

I agree with your and Andreas' concern about fragmentation due to the
current scheme of putting metacluster in the middle of the block group.
Here are some stats concerning different metacluster locations:
- Placing metacluster at the end of the block group results in 2%
degradation in sequential reads from large files. Putting it at the
beginning improves sequential read performance by 0.5%.
- For random reads the beginning and ending configurations have
idential performance which is almost the same as regular ext3 performance
but 1% worse than the middle configuration.
- I haven't compared the different metacluster locations for sequential
reads from small files, but in general I've found the behavior to be
very similar to random reads from a large file.

So I think putting metacluster levels at the beginning of the block group
is an obvious choice.

>
> > In traditional metaclustering, once we run out of metacluster blocks
> > or data blocks, all bets are off. This forces us to keep small
> > metaclusters in order to avoid this situation altogether. But with small
> > metaclusters, we cannot optimize indirect block allocation on file
> > systems with many small files (>48KB).There is only one glitch in
> > implementing this. If a block group doesn't have any free blocks at a
> > given level, we should be able to find that out quickly instead of
> > having to scan its entire bitmap. gdp->bg_free_blocks_count is not good
> > enough for this.
>
> Ideally, true, but this was a defect with the original metacluster
> scheme as well.  We could steal some bits in the block_group
> descriptor structure to indicate whether a particular level is full,
> though.  This would be another data format change that would require
> e2fsprogs support, though.
>
> Regards,
>
>                                                 - Ted
>

Thanks,
Abhishekj
