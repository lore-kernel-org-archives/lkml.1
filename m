Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab0BFAzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:55:04 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:41683 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757336Ab0BFAzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:55:01 -0500
Date: Sat, 6 Feb 2010 11:39:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100206003924.GH11483@discord.disaster>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131135933.GM15853@discord.disaster> <alpine.DEB.2.00.1002030920500.5671@router.home> <20100204003410.GD5332@discord.disaster> <20100204030736.GB25885@thunk.org> <20100204033911.GE5332@discord.disaster> <alpine.DEB.2.00.1002041046170.28165@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002041046170.28165@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 10:59:26AM -0600, Christoph Lameter wrote:
> On Thu, 4 Feb 2010, Dave Chinner wrote:
> 
> > > Or maybe we need to have the way to track the LRU of the slab page as
> > > a whole?  Any time we touch an object on the slab page, we touch the
> > > last updatedness of the slab as a hole.
> >
> > Yes, that's pretty much what I have been trying to describe. ;)
> > (And, IIUC, what I think Nick has been trying to describe as well
> > when he's been saying we should "turn reclaim upside down".)
> >
> > It seems to me to be pretty simple to track, too, if we define pages
> > for reclaim to only be those that are full of unused objects. i.e.
> > the pages have the two states:
> >
> > 	- Active: some allocated and referenced object on the page
> > 		=> no need for LRU tracking of these
> > 	- Unused: all allocated objects on the page are not used
> > 		=> these pages are LRU tracked within the slab
> >
> > A single referenced object is enough to change the state of the
> > page from Unused to Active, and when page transitions from
> > Active to Unused is goes on the MRU end of the LRU queue.
> > Reclaim would then start with the oldest pages on the LRU....
> 
> These are describing ways of reclaim that could be implemented by the fs
> layer. The information what item is "unused" or "referenced" is a notion
> of the fs. The slab caches know only of two object states: Free or
> allocated. LRU handling of slab pages is something entirely different
> from the LRU of the inodes and dentries.

Ah, perhaps you missed my previous email in the thread about adding
a third object state to the slab - i.e. an unused state?  And an
interface (slab_object_used()/slab_object_unused()) to allow the
external uses to tell the slab about state changes of objects
on the first/last reference to the object. That would allow the
tracking as I stated above....

> > > And of course, if the inode is pinned down because it is opened and/or
> > > mmaped, then its associated dcache entry can't be freed either, so
> > > there's no point trying to trash all of its sibling dentries on the
> > > same page as that dcache entry.
> >
> > Agreed - that's why I think preventing fragemntation caused by LRU
> > reclaim is best dealt with internally to slab where both object age
> > and locality can be taken into account.
> 
> Object age is not known by the slab.

See above.

> Locality is only considered in terms
> of hardware placement (Numa nodes) not in relationship to objects of other
> caches (like inodes and dentries) or the same caches.

And that is the defficiency we've been talking about correcting! i.e
that object <-> page locality needs tobe taken into account during
reclaim. Moving used/unused knowledge into the slab where page/object
locality is known is one way of doing that....

> If we want this then we may end up with a special allocator for the
> filesystem.

I don't see why a small extension to the slab code can't fix this...

> You and I have discussed a couple of years ago to add a reference count to
> the objects of the slab allocator. Those explorations resulted in am much
> more complicated and different allocator that is geared to the needs of
> the filesystem for reclaim.

And those discussions and explorations lead to the current defrag
code. After a couple of year, I don't think that the design we came
up with back then is the best way to approach the problem - it still
has many, many flaws. We need to explore different approaches
because none of the evolutionary approaches (i.e. tack something
on the side) appear to be sufficient.

Cheers,

Dave.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Dave Chinner
david@fromorbit.com
