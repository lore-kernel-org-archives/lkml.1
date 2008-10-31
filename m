Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYJaH3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYJaH3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYJaH3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:29:34 -0400
Received: from lazybastard.de ([212.112.238.170]:49934 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJaH3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:29:33 -0400
Date: Fri, 31 Oct 2008 08:29:23 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: [PATCH V2 10/16] Squashfs: cache operations
Message-ID: <20081031072923.GA18182@logfs.org>
References: <E1Kv0C4-0006HO-BC@dylan> <20081029093218.GA26456@logfs.org> <490A8D02.4090407@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490A8D02.4090407@lougher.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 04:43:46 +0000, Phillip Lougher wrote:
> 
> Simplicity and speed is extremely important.  The 
> squashfs_metadata_read() wrapper around the cache is designed to step 
> through the metadata a structure at a time (20 or so bytes), updating 
> the read position in the metadata each call, with more metadata cache 
> blocks being read and decompressed as necessary.  The common case where 
> the metadata is already in the cache (because we're stepping through it 
> 20 or so bytes at a time), is designed to be extremely fast - a spinlock 
> and array search only.  I recently optimised the cache to use spinlocks 
> rather than mutexes and reduced the lock holding time (necessary to move 
> to spinlocks), and this resulted in a 20%+ speed improvement in reading 
> squashfs filesystems.

For the page cache, you can use read_cache_page() and
page_cache_release().  This does not even take a spinlock, hence
multiple readers can work in parallel.  The radix tree walk will take a
similar time to your array search.

You are aware that multiple cpus will play pingpong with your spinlock?

> Given the above using an address space in the page cache will result in 
> greater complexity, more memory overhead, and much slower operation. 
> There's a number of reasons for this.
> 
> 1. The amount and life-span of the data stored in the page cache is 
> outside of Squashfs' control.  As explained above it only makes sense to 
> temporarily cache the last couple of metadata and fragment blocks. 
> Using the page cache (if a 'large' address space is used) for these 
> keeps more of them around for longer than necessary, and will 
> potentially cause more worthy datablocks to be flushed on memory pressure.

I personally find it hard to guess access patterns.  If I constructed a
workload just large enough that your cache is slightly too small, it
will start thrashing.  Hit rates will go close to zero.  And unless I
missed something, such a workload can be constructed and may even be
used in real life.  With growing numbers of cores, this becomes
increasingly likely.

In other cases, an idle squashfs will still hold the 64k of unused cache
for ransom.  By giving up control, you allow your cache to grow and
shrink as desired and can avoid both cases.

> 2. The address space will be caching uncompressed data, the squashfs 
> references to this data are the compressed locations within the 
> filesystem.  There doesn't exist a one-to-one linear mapping from 
> compressed location to decompressed location in the address space.  This 
> means a lookup table still needs to be used to store the mapping from 
> compressed location to decompressed location in the address space.  Now 
> this lookup table (however implemented) is itself at least as complex as 
> my current cache implementation.

You are currently using physical offset of the medium to address blocks
in the cache, which are 64bit.  Page cache may use 32bit to address
pages.  And since blocks can be larger than pages, you effectively need
some bits extra.  This is indeed a problem.

> 3. Once the locations of the decompressed pages in the address space 
> have been found, they'll need to be looked up in the page cache, and 
> this has to be done for every 4K page.  With the default fragment size 
> of 128 KiB this means 32 separate lookups.  Somewhat slower than one 
> spinlock and array search per 128 KiB block in the squashfs cache 
> implementation.

Above you claimed the complete cache to be just 64k in size.  How can
you access 128k blocks that way?  One of the numbers appears wrong.

Ignoring that, you don't need to take either the spinlock or do a lookup
in a fast path.  If you currently have this code:

	for (some condition) {
		err = squashfs_read_metadata(address, ...);
	}

You can transform it to:

	void *handle = squashfs_get_metadata(address, ...);
	for (some condition) {
		err = squashfs_read_metadata(handle, address, ...);
	}
	squashfs_put_metadata(handle);

With the handle you can keep a reference count to your cached object.
squashfs_read_metadata() only has to call squashfs_cache_get() or
squashfs_cache_put() when moving across object boundaries.  In the
common case it simply returns data from the object referenced through
the handle.

This might be a worthwhile optimization independently of whether you use
the page cache or not.

> Comments, especially those of the form "you've got this completely 
> wrong, and you can use the page cache like this, which will be simpler 
> and faster than your current implementation" welcome :)  I'm not adverse 
>  to using the page cache, but I can't see how it will be simpler or 
> faster than the current implementation.

Only one of your problems seems to be real.  Not sure if or how we can
solve that one, though.

Jörn

-- 
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
