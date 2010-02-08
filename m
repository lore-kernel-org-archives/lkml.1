Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0BHWNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:13:34 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:53095 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810Ab0BHWNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:13:33 -0500
Date: Tue, 9 Feb 2010 09:13:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>, tytso@mit.edu,
       Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100208221318.GL11483@discord.disaster>
References: <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131135933.GM15853@discord.disaster> <alpine.DEB.2.00.1002030920500.5671@router.home> <20100204003410.GD5332@discord.disaster> <20100204030736.GB25885@thunk.org> <20100204033911.GE5332@discord.disaster> <20100204093350.GE13318@laptop> <alpine.DEB.2.00.1002041109500.28165@router.home> <20100208073753.GC9781@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208073753.GC9781@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 06:37:53PM +1100, Nick Piggin wrote:
> On Thu, Feb 04, 2010 at 11:13:15AM -0600, Christoph Lameter wrote:
> > On Thu, 4 Feb 2010, Nick Piggin wrote:
> > 
> > > Well what I described is to do the slab pinning from the reclaim path
> > > (rather than from slab calling into the subsystem). All slab locking
> > > basically "innermost", so you can pretty much poke the slab layer as
> > > much as you like from the subsystem.
> > 
> > Reclaim/defrag is called from the reclaim path (of the VM). We could
> > enable a call from the fs reclaim code into the slab. But how would this
> > work?
> 
> Well the exact details will depend, but I feel that things should
> get easier because you pin the object (and therefore the slab) via
> the normal and well tested reclaim paths.
> 
> So for example, for dcache, you will come in and take the normal
> locks: dcache_lock, sb_lock, pin the sb, umount_lock. At which
> point you have pinned dentries without changing any locking. So
> then you can find the first entry on the LRU, and should be able
> to then build a list of dentries on the same slab.
> 
> You still have the potential issue of now finding objects that would
> not be visible by searching the LRU alone. However at least the
> locking should be simplified.

Very true, but that leads us to the same problem of fragmented
caches because we empty unused objects off slabs that are still
pinned by hot objects and don't free the page. I agree that we can't
totally avoid this problem, but I still think that using an object
based LRU for reclaim has a fundamental mismatch with page based
reclaim that makes this problem worse than it could be.

FWIW, if we change the above to keeping a page based LRU in the slab
cache and the slab picks a page to reclaim, then the problem goes
mostly away, I think. We don't need to pin the slab to select and
prepare a page to reclaim - the cache only needs to be locked before
it starts reclaim. I think this has a much better chance of
reclaiming entire pages in situations where LRU based reclaim will
leave fragmentation.

i.e. instead of:

	shrink_slab
	  -> external shrinker
	    -> lock cache
	    -> find reclaimable object
	      -> call into slab w/ object
	        -> return longer list of objects
	    -> reclaim objects

we do:

	shrink_slab
	  -> internal shrinker
	    -> find oldest page and make object list
	      -> external shrinker
	        -> lock cache
		-> reclaim objects

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
