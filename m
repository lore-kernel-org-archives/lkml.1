Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYJALf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYJALf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYJALfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:35:47 -0400
Received: from phunq.net ([64.81.85.152]:45825 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269AbYJALfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:35:45 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 Report: Extolling the Extensive Virtues of Extents
Date: Wed, 1 Oct 2008 04:35:39 -0700
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010435.39891.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a couple of weeks of painstakingly slow progress, Tux3 now is 
close enough to having extents that I feel it is time to sit back, 
limber up the proverbial knuckle joints for some heavy typing, and 
launch yet another Tux3 design missive into the wild blue yonder.

What is all this noise about extents and why is everybody doing it?  And 
what is an extent anyway?

Traditional filesystems record a pointer to each individual disk block, 
whereas modern extent-based filesystems record pointers to runs of disk 
blocks, each such extent having a starting address and a count of data 
blocks that store all or part of some file.  A file may consist of many 
extents, and may be sparse, which requires that logical addresses also 
be stored, in order to know the position of each extent within a file.  
An extent can therefore be thought of as a triple {logical address, 
physical address, block count} or alternatively, as a pair {physical 
address, block count} indexed by a logical address.  Tux3 uses the 
latter approach while Ext4 uses the former.

Extents themselves are simple things: just add a count to a block 
pointer and you have an extent, which is just what we did in Tux3.  The 
extent count is packed into 6 unused bits of a 64 bit physical block 
pointer.  "For free" you could say.

On the other hand, algorithms to handle extents are far from simple.  It 
is amazing how much complexity jumped out of the woodwork when that 
innocent little count field appeared.  For one thing, extents 
constitute variable sized logical objects so you can't store them in a 
radix tree as with the classic direct/indirect/double/triple scheme 
inherited by Ext2 from UFS.  A considerably more complex b-tree scheme 
is required.  Well, we had the b-trees anyway for other reasons 
(variable sized inodes, multiple block pointers per logical address) 
but that is just one of the issues.

Extents introduce a large number of new boundary conditions into file 
allocation and access code.  To illustrate, consider the complexity of 
rewriting a region of a file on top of some number of pre-existing 
extents, which can have gaps between them.  We want to overwrite some 
extents and allocate new extents to fill in the gaps.  Maybe we want to 
enlarge some existing extents where possible, or delete some of the 
pre-existing extents in favor of a larger, newly allocated contiguous 
region.  Maybe beginning or end of the region we are writing lands in 
the middle of a pre-existing extent, and we have to handle that.  This 
is a whole lot more detail to worry about than just writing a block at 
a time, no?  Indeed it is.  So why would we want to put ourselves 
through such pain anyway?

The answer is: extents yield huge performance benefits.  Recently, 
somebody said that extents are just a performance hack, and that is 
true, but then cache is just a performance hack too.  Extents are 
simply the biggest performance optimization to come along for 
filesystems since... buffer cache.

We get all of these benefits from extents:

  * Allocate an entire range of blocks at once - fewer trips into
    the allocator.

  * Each extent is allocated contiguously - fragmentation reduction
    without guesswork.

  * Assign disk addresses to entire ranges of a file write at once -
    fewer walks through the file index blocks.

  * At sync time, form larger and fewer bio transactions that can be
    merged more efficiently by the disk elevator and require less
    handling in the block IO path than individual blocks.

  * Fewer edits of file metadata - don't trash the cache.

  * More compact representation on disk - less metadata to load into
    memory and write back out to disk.

  * Lower ratio of metadata blocks to data blocks - less seeking on
    read.

  * More compact representation in memory - less cache pressure.

  * Extent data is handled in batches at each step: allocation,
    index editing, io submission, freeing, so code execution is well
    localized - better use of processor execution cache.

To quantify some of these benefits, consider that a block-oriented 
filesystem like Ext3 must read one index block for each thousand data 
blocks, 4 MB of data, which takes about 16 milliseconds to read.  If an 
extra seek is required to pick up the next index block, and then back 
to where the next data will be read, that is maybe 12 ms on top of the 
16 ms linear transfer time, a 75% performance penalty.  Tux3 indexes 
about 85 MB of data per index block, which translates into about 3% 
seek overhead for a large linear read.

An even more dramatic improvement can be expected with file deletion.  
Ext3 has to read one metadata block per 4 MB of deleted data in order 
to find the blocks that should be freed.  This overhead is about 1.5 
seconds per Gigabyte, or 25 minutes per terabyte.  Tux3 will reduce 
that to about .07 seconds per gigabyte or about 1.2 minutes per 
terabyte, using extents.

In both cases, further savings can be had using larger extents, but 
Tux3's modest 64 block extent limit already promises upwards of 95% of 
the benefit that is to be had.  That said, Tux3 may well add an 
optimization to support larger extents later.  This is not very hard, 
it is just more code, but for the time being we have a better use in 
mind for those bits we saved (versioning).

As mentioned above, the one big drawback of extents is that they are 
hard to code and get right.  That is why they have only slowly appeared 
in our grassroots open source filesystems on Linux.  Big iron Unix 
vendors have known about the benefits of extents for decades, and have 
had the workloads to showcase them.  Well now we have those loads on 
Linux too.  Time to get our collective act together.

I did not get into the details of Tux3's extent design because this post 
is already long enough.  But they are interesting, at least I think so, 
and do deserve a post of their own.  Please stay tuned.  And please 
keep in mind: Halloween is fast approaching, and therefore so is the 
Tux3 Halloween Cabal party.

Regards,

Daniel
