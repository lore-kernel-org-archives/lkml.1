Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZADHzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZADHzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 02:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZADHzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 02:55:39 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:40091 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbZADHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 02:55:37 -0500
Message-ID: <49606B7C.7050403@lougher.demon.co.uk>
Date: Sun, 04 Jan 2009 07:55:40 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH V2 00/16] Squashfs: compressed read-only filesystem
References: <E1Kv0C3-0006GU-ES@dylan> <20081028192919.94def38b.akpm@linux-foundation.org>
In-Reply-To: <20081028192919.94def38b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote a couple of months ago (sadly how time flies):

> - what are the limitations of squashfs (please add this to the
>   changelog of patch #1 or something).  Does it support nfsd? (yes, it
>   does!)  xatrs and acls?  File size limits, entries-per-directory,
>   etc, etc?

Xattrs and acls are not supported, this is a todo.

Filesize limits are in theory 2^64.  In practice about 2 TiB.

No limits on the entries per directory.

> 
>   What is on the todo list?
> 

Xattrs and ACLs.

The above information has been added to a squashfs.txt file.

> - Please check that all non-static identifiers really did need global
>   scope.  I saw some which surprised me a bit.
> 
> - Please check that all global identifiers have suitable names.  For
>   example "get_fragment_location" is a poor choice for a kernel-wide
>   identifier.  It could clash with other subsystems, mainly.  Plus it
>   is hardly self-identifying.  I see quite a few such cases.

Done and fixed.

> 
> - The fs uses vmalloc() rather a lot.  I'd suggest that this be
>   explained and justified in the design/implementation overview,
>   wherever that is.  This should include a means by which we can
>   estimate (or at least understand) the amount of memory which will be
>   allocated in this way.
> 
>   Because vmalloc() is unreliable.  It is a fixed-size resource on
>   each machine.  Some machines will run out much much earlier than
>   others.  It will set an upper limit on the number of filesystems
>   which can be concurrently mounted, and presumably upon the size of
>   those filesystems.  One a per-machine basis, which is worse.
> 
>   It also exposes users to vmalloc arena fragmentation.  eg: mount
>   ten 1G filesystems, then unmount every second one, then try to mount
>   a 2G filesystem and you find you have no contiguous vmalloc space
>   (simplified example).
> 
>   See, this vmalloc thing is a fairly big deal.  What's up with all
>   of this??

Vmalloc was used to allocate block data (128 Kib by default).

I've removed all vmallocs from Squashfs.  All buffers are now kmalloced 
in PAGE_CACHE_SIZEd chunks.

> 
> - The fs uses brelse() in quite a few places where the bh is known to
>   be non-zero.  Suggest that these be converted to the more efficient
>   and modern put_bh().
> 

Fixed.

> - this:
> 
> +/*
> + * Blocks in Squashfs are compressed.  To avoid repeatedly decompressing
> + * recently accessed data Squashfs uses two small metadata and fragment caches.
> + *
> + * This file implements a generic cache implementation used for both caches,
> + * plus functions layered ontop of the generic cache implementation to
> + * access the metadata and fragment caches.
> + */
> 
>   confuses me.  Why not just decompress these blocks into pagecache
>   and let the VFS handle the caching??
> 

The cache is not used for file datablocks, these are decompressed and 
cached in the page-cache in the normal way.  The cache is only used to 
temporarily cache fragment and metadata blocks which have been read as 
as a result of a metadata (i.e. inode or directory) or fragment access. 
  Because metadata and fragments are packed together into blocks (to 
gain greater compression) the read of a particular piece of metadata or 
fragment will retrieve other metadata/fragments which have been packed 
with it, these because of locality-of-reference may be read in the near 
future. Temporarily caching them ensures they are available for near 
future access without requiring an additional read and decompress.

The cache is deliberately kept small to only cache the last couple of 
blocks read.  The total overhead is 3 x block_size (128 KiB) for 
fragments and 8 x 8 KiB for metadata blocks, or a total of 448 KiB.

If you think this is too large I can reduce the number of fragments and 
metadata blocks cached.

Because these blocks are greater than PAGE_CACHE_SIZE is not easy to use 
the page cache.  As Joern said "there really isn't any infrastructure to 
deal with such cases yet.  Bufferheads deal with blocks smaller than a 
page, not the other way around."  Storing these in the page cache 
introduces a lot more complexity in terms of locking and associated race 
conditions.

As previously mentioned I have rewritten the cache implementation to 
avoid vmalloc and to use PAGE_CACHE_SIZE blocks.  This eliminates the 
vmalloc fragment issues, and is a first step in moving the 
implementation over to using the page cache in the future.

>   The real bug here is that this rather obvious question wasn't
>   answered anywhere in the patch submission (afaict).  How to fix that?
> 
>   Methinks we need a squashfs.txt which covers these things.

Added to a new squashfs.txt file.

> 
> - I suspect that squashfs_cache_put() has races around the handling
>   of cache->waiting.  Does it assume that another CPU wrote that flag
>   prior to adding itself to the waitqueue?  How can the other task do
>   that atomically?  What about memory ordering issues?
> 
>   Suggest that cache->lock coverage be extended to clear all this up.
> 

Fixed.

> - Quite a few places do kzalloc(a * b, ...).  Please convert to
>   kcalloc() which has checks for multiplicative overflows.

Fixed.

> 
>> There is now a public git repository on kernel.org. Pull/clone from
>> git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-2.6.git
> 
> Generally looks OK to me.  Please prepare a tree for linx-next
> inclusion and unless serious problems are pointed out I'd suggest
> shooting for a 2.6.29 merge.
> 

Ok.  I'll re-spin the patches against 2.6.28 tomorrow (Sunday), and I'll 
prepare a tree for linux-next.

Thanks

Phillip

