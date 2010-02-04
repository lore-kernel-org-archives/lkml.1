Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0BDDI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:08:26 -0500
Received: from thunk.org ([69.25.196.29]:37987 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0BDDIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:08:25 -0500
Date: Wed, 3 Feb 2010 22:07:36 -0500
From: tytso@mit.edu
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100204030736.GB25885@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Chinner <david@fromorbit.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@ftp.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	Rik van Riel <riel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
References: <20100129204931.789743493@quilx.com>
 <20100129205004.405949705@quilx.com>
 <20100130192623.GE788@thunk.org>
 <20100131083409.GF29555@one.firstfloor.org>
 <20100131135933.GM15853@discord.disaster>
 <alpine.DEB.2.00.1002030920500.5671@router.home>
 <20100204003410.GD5332@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204003410.GD5332@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 11:34:10AM +1100, Dave Chinner wrote:
> 
> I completely disagree. If you have to trash all the cache hot
> information related to the cached object in the process of
> relocating it, then you've just screwed up application performance
> and in a completely unpredictable manner. Admins will be tearing out
> their hair trying to work out why their applications randomly slow
> down....

...

> You missed my point again. You're still talking about tracking pages
> with no regard to the objects remaining in the pages. A page, full
> or partial, is a candidate for object reclaim if none of the objects
> on it are referenced and have not been referenced for some time.
> 
> You are currently relying on the existing LRU reclaim to move a slab
> from full to partial to trigger defragmentation, but you ignore the
> hotness of the rest of the objects on the page by trying to reclaim
> the page that has been partial for the longest period of time.

Well said.

This is exactly what I was complaining about as well, but apparently I
wasn't understood the first time either.  :-(

This *has* to be fixed, or this set of patches is going to completely
trash the overall system performance, by trashing the page cache.



> What it comes down to is that the slab has two states for objects -
> allocated and free - but what we really need here is 3 states -
> allocated, unused and freed. We currently track unused objects
> outside the slab in LRU lists and, IMO, that is the source of our
> fragmentation problems because it has no knowledge of the spatial
> layout of the slabs and the state of other objects in the page.
> 
> What I'm suggesting is that we ditch the external LRUs and track the
> "unused" state inside the slab and then use that knowledge to decide
> which pages to reclaim.

Or maybe we need to have the way to track the LRU of the slab page as
a whole?  Any time we touch an object on the slab page, we touch the
last updatedness of the slab as a hole.

It's actually more complicated than that, though.  Even if no one has
touched a particular inode, if one of the inode in the slab page is
pinned down because it is in use, so there's no point for the
defragmenter trying to throw away valuable cached pages associated
with other inodes in the same slab page --- since because of that
single pinned inode, YOU'RE NEVER GOING TO DEFRAG THAT PAGE.

And of course, if the inode is pinned down because it is opened and/or
mmaped, then its associated dcache entry can't be freed either, so
there's no point trying to trash all of its sibling dentries on the
same page as that dcache entry.

Randomly shooting down dcache and inode entries in the hopes of
creating coalescing free pages into hugepages is just not cool.  If
you're that desperate, you might as well just do "echo 3 >
/proc/sys/vm/drop_caches".  From my read of the algorithms, it's going
to be almost as destructive to system performance.

	       	     	     	     	     - Ted
