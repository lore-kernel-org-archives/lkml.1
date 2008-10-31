Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYJaEn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYJaEn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYJaEnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:43:41 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:4569 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbYJaEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:43:40 -0400
Message-ID: <490A8D02.4090407@lougher.demon.co.uk>
Date: Fri, 31 Oct 2008 04:43:46 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: [PATCH V2 10/16] Squashfs: cache operations
References: <E1Kv0C4-0006HO-BC@dylan> <20081029093218.GA26456@logfs.org>
In-Reply-To: <20081029093218.GA26456@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Wed, 29 October 2008 01:49:56 +0000, Phillip Lougher wrote:
>> +/*
>> + * Blocks in Squashfs are compressed.  To avoid repeatedly decompressing
>> + * recently accessed data Squashfs uses two small metadata and fragment caches.
>> + *
>> + * This file implements a generic cache implementation used for both caches,
>> + * plus functions layered ontop of the generic cache implementation to
>> + * access the metadata and fragment caches.
>> + */
> 
> I tend to agree with Andrew that a lot of this should be done by the
> page cache instead.  One of the problems seems to be that your blocksize
> can exceed page size and there really isn't any infrastructure to deal
> with such cases yet.  Bufferheads deal with blocks smaller than a page,
> not the other way around.
> 

I thought about using the page cache, but, the fact that blocksizes 
exceed the page cache size is only one of a number of reasons why I 
prefer the current solution, there is also simplicity and speed to consider.

There are three types of compressed block in Squashfs: datablocks, 
fragments, and metadata blocks.  Of these datablocks (by far the largest 
number of blocks) are decompressed and pushed into the page cache, and 
are not otherwise cached by Squashfs.  This, obviously (?), is because 
they contain data for only one file, and so at time of access there is a 
readily available address space to push the data into.

Metadata and fragment blocks are different in that when accessed and 
decompressed (say for an inode or for a particular tail-end block) they 
will contain metadata or tail-ends for other files.  This data could be 
thrown away but due to locality of reference it makes sense to 
temporarily cache it in-case a near future file access references the 
data.  But it doesn't make much sense to cache it more than temporarily, 
  much of the data will probably not be reused, and it exists compressed 
in the buffer cache.

The squashfs cache is therefore designed to cache only the last couple 
of metadata and fragment blocks.  It is also designed to be simple and 
extremely fast.  The maximum size of the metadata cache is only 64 KiB.

Simplicity and speed is extremely important.  The 
squashfs_metadata_read() wrapper around the cache is designed to step 
through the metadata a structure at a time (20 or so bytes), updating 
the read position in the metadata each call, with more metadata cache 
blocks being read and decompressed as necessary.  The common case where 
the metadata is already in the cache (because we're stepping through it 
20 or so bytes at a time), is designed to be extremely fast - a spinlock 
and array search only.  I recently optimised the cache to use spinlocks 
rather than mutexes and reduced the lock holding time (necessary to move 
to spinlocks), and this resulted in a 20%+ speed improvement in reading 
squashfs filesystems.

Given the above using an address space in the page cache will result in 
greater complexity, more memory overhead, and much slower operation. 
There's a number of reasons for this.

1. The amount and life-span of the data stored in the page cache is 
outside of Squashfs' control.  As explained above it only makes sense to 
temporarily cache the last couple of metadata and fragment blocks. 
Using the page cache (if a 'large' address space is used) for these 
keeps more of them around for longer than necessary, and will 
potentially cause more worthy datablocks to be flushed on memory pressure.

2. The address space will be caching uncompressed data, the squashfs 
references to this data are the compressed locations within the 
filesystem.  There doesn't exist a one-to-one linear mapping from 
compressed location to decompressed location in the address space.  This 
means a lookup table still needs to be used to store the mapping from 
compressed location to decompressed location in the address space.  Now 
this lookup table (however implemented) is itself at least as complex as 
my current cache implementation.

3. Once the locations of the decompressed pages in the address space 
have been found, they'll need to be looked up in the page cache, and 
this has to be done for every 4K page.  With the default fragment size 
of 128 KiB this means 32 separate lookups.  Somewhat slower than one 
spinlock and array search per 128 KiB block in the squashfs cache 
implementation.

Comments, especially those of the form "you've got this completely 
wrong, and you can use the page cache like this, which will be simpler 
and faster than your current implementation" welcome :)  I'm not adverse 
  to using the page cache, but I can't see how it will be simpler or 
faster than the current implementation.

Phillip
