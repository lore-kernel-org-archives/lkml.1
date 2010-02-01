Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0BAI1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:27:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:60647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab0BAI1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:27:12 -0500
Date: Mon, 1 Feb 2010 18:08:35 +1100
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dentries: dentry defragmentation
Message-ID: <20100201070835.GE9085@laptop>
References: <20100129204931.789743493@quilx.com>
 <20100129205007.832823807@quilx.com>
 <20100129220044.GA31305@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129220044.GA31305@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:00:44PM +0000, Al Viro wrote:
> On Fri, Jan 29, 2010 at 02:49:48PM -0600, Christoph Lameter wrote:
> > +		if ((d_unhashed(dentry) && list_empty(&dentry->d_lru)) ||
> > +		   (!d_unhashed(dentry) && hlist_unhashed(&dentry->d_hash)) ||
> > +		   (dentry->d_inode &&
> > +		   !mapping_cap_writeback_dirty(dentry->d_inode->i_mapping)))
> > +			/* Ignore this dentry */
> > +			v[i] = NULL;
> > +		else
> > +			/* dget_locked will remove the dentry from the LRU */
> > +			dget_locked(dentry);
> > +	}
> > +	spin_unlock(&dcache_lock);
> > +	return NULL;
> > +}
> 
> No.  As the matter of fact - fuck, no.  For one thing, it's going to race
> with umount.  For another, kicking busy dentry out of hash is worse than
> useless - you are just asking to get more and more copies of that sucker
> in dcache.  This is fundamentally bogus, especially since there is a 100%
> safe time for killing dentry - when dput() drives the refcount to 0 and
> you *are* doing dput() on the references you've acquired.  If anything, I'd
> suggest setting a flag that would trigger immediate freeing on the final
> dput().
> 
> And that does not cover the umount races.  You *can't* go around grabbing
> dentries without making sure that superblock won't be shut down under
> you.  And no, I don't know how to deal with that cleanly - simply bumping
> superblock ->s_count under sb_lock is enough to make sure it's not freed
> under you, but what you want is more than that.  An active reference would
> be enough, except that you'd get sudden "oh, sorry, now there's no way
> to make sure that superblock is shut down at umount(2), no matter what kind
> of setup you have".  So you really need to get ->s_umount held shared,
> which is, not particulary locking-order-friendly, to put it mildly.

I always preferred to do defrag in the opposite way. Ie. query the
slab allocator from existing shrinkers rather than opposite way
around. This lets you reuse more of the locking and refcounting etc.

So you have a pin on the object somehow via the normal shrinker path,
and therefore you get a pin on the underlying slab. I would just like
to see even performance of a real simple approach that just asks
whether we are in this slab defrag mode, and if so, whether the slab
is very sparse. If yes, then reclaim aggressively.

If that doesn't perform well enough and you have to go further and
discover objects on the same slab, then it does get a bit more
tricky because:
- you need the pin on the first object in order to discover more
- discovered objects may not be expected in the existing shrinker
  code that just picks objects off LRUs

However your code already has to handle the 2nd case anyway, and for
the 1st case it is probably not too hard to do with dcache/icache. And
in either case you seem to avoid the worst of the sleeping and lock
ordering and slab inversion problems of your ->get approach.

But I'm really interested to see numbers, and especially numbers of
the simpler approaches before adding this complexity.

