Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0BDRBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:01:07 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44154 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0BDRBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:01:05 -0500
Date: Thu, 4 Feb 2010 10:59:26 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Dave Chinner <david@fromorbit.com>
cc: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
In-Reply-To: <20100204033911.GE5332@discord.disaster>
Message-ID: <alpine.DEB.2.00.1002041046170.28165@router.home>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131135933.GM15853@discord.disaster> <alpine.DEB.2.00.1002030920500.5671@router.home>
 <20100204003410.GD5332@discord.disaster> <20100204030736.GB25885@thunk.org> <20100204033911.GE5332@discord.disaster>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Dave Chinner wrote:

> > Or maybe we need to have the way to track the LRU of the slab page as
> > a whole?  Any time we touch an object on the slab page, we touch the
> > last updatedness of the slab as a hole.
>
> Yes, that's pretty much what I have been trying to describe. ;)
> (And, IIUC, what I think Nick has been trying to describe as well
> when he's been saying we should "turn reclaim upside down".)
>
> It seems to me to be pretty simple to track, too, if we define pages
> for reclaim to only be those that are full of unused objects. i.e.
> the pages have the two states:
>
> 	- Active: some allocated and referenced object on the page
> 		=> no need for LRU tracking of these
> 	- Unused: all allocated objects on the page are not used
> 		=> these pages are LRU tracked within the slab
>
> A single referenced object is enough to change the state of the
> page from Unused to Active, and when page transitions from
> Active to Unused is goes on the MRU end of the LRU queue.
> Reclaim would then start with the oldest pages on the LRU....

These are describing ways of reclaim that could be implemented by the fs
layer. The information what item is "unused" or "referenced" is a notion
of the fs. The slab caches know only of two object states: Free or
allocated. LRU handling of slab pages is something entirely different
from the LRU of the inodes and dentries.

> > And of course, if the inode is pinned down because it is opened and/or
> > mmaped, then its associated dcache entry can't be freed either, so
> > there's no point trying to trash all of its sibling dentries on the
> > same page as that dcache entry.
>
> Agreed - that's why I think preventing fragemntation caused by LRU
> reclaim is best dealt with internally to slab where both object age
> and locality can be taken into account.

Object age is not known by the slab. Locality is only considered in terms
of hardware placement (Numa nodes) not in relationship to objects of other
caches (like inodes and dentries) or the same caches.

If we want this then we may end up with a special allocator for the
filesystem.

You and I have discussed a couple of years ago to add a reference count to
the objects of the slab allocator. Those explorations resulted in am much
more complicated and different allocator that is geared to the needs of
the filesystem for reclaim.

