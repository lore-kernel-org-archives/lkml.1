Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0BDJeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:34:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:37033 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0BDJeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:34:00 -0500
Date: Thu, 4 Feb 2010 20:33:50 +1100
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: tytso@mit.edu, Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100204093350.GE13318@laptop>
References: <20100129204931.789743493@quilx.com>
 <20100129205004.405949705@quilx.com>
 <20100130192623.GE788@thunk.org>
 <20100131083409.GF29555@one.firstfloor.org>
 <20100131135933.GM15853@discord.disaster>
 <alpine.DEB.2.00.1002030920500.5671@router.home>
 <20100204003410.GD5332@discord.disaster>
 <20100204030736.GB25885@thunk.org>
 <20100204033911.GE5332@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204033911.GE5332@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 02:39:11PM +1100, Dave Chinner wrote:
> On Wed, Feb 03, 2010 at 10:07:36PM -0500, tytso@mit.edu wrote:
> > On Thu, Feb 04, 2010 at 11:34:10AM +1100, Dave Chinner wrote:
> > > What it comes down to is that the slab has two states for objects -
> > > allocated and free - but what we really need here is 3 states -
> > > allocated, unused and freed. We currently track unused objects
> > > outside the slab in LRU lists and, IMO, that is the source of our
> > > fragmentation problems because it has no knowledge of the spatial
> > > layout of the slabs and the state of other objects in the page.
> > > 
> > > What I'm suggesting is that we ditch the external LRUs and track the
> > > "unused" state inside the slab and then use that knowledge to decide
> > > which pages to reclaim.
> > 
> > Or maybe we need to have the way to track the LRU of the slab page as
> > a whole?  Any time we touch an object on the slab page, we touch the
> > last updatedness of the slab as a hole.
> 
> Yes, that's pretty much what I have been trying to describe. ;)
> (And, IIUC, what I think Nick has been trying to describe as well
> when he's been saying we should "turn reclaim upside down".)

Well what I described is to do the slab pinning from the reclaim path
(rather than from slab calling into the subsystem). All slab locking
basically "innermost", so you can pretty much poke the slab layer as
much as you like from the subsystem.

After that, LRU on slabs should be fairly easy. Slab could provide a
private per-slab pointer for example that is managed by the caller.
Subsystem can then call into slab to find the objects.

 
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
> 
> > It's actually more complicated than that, though.  Even if no one has
> > touched a particular inode, if one of the inode in the slab page is
> > pinned down because it is in use,
> 
> A single active object like this would the slab page Active, and
> therefore not a candidate for reclaim. Also, we already reclaim
> dentries before inodes because dentries pin inodes, so our
> algorithms for reclaim already deal with these ordering issues for
> us.
> 
> ...
> 
> > And of course, if the inode is pinned down because it is opened and/or
> > mmaped, then its associated dcache entry can't be freed either, so
> > there's no point trying to trash all of its sibling dentries on the
> > same page as that dcache entry.
> 
> Agreed - that's why I think preventing fragemntation caused by LRU
> reclaim is best dealt with internally to slab where both object age
> and locality can be taken into account.

