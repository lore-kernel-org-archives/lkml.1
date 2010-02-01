Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0BAK4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:56:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0BAK4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:56:41 -0500
Date: Mon, 1 Feb 2010 21:56:35 +1100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dentries: dentry defragmentation
Message-ID: <20100201105635.GI12759@laptop>
References: <20100129204931.789743493@quilx.com>
 <20100129205007.832823807@quilx.com>
 <20100129220044.GA31305@ZenIV.linux.org.uk>
 <20100201070835.GE9085@laptop>
 <20100201101013.GG29555@one.firstfloor.org>
 <20100201101645.GF12759@laptop>
 <20100201102253.GI29555@one.firstfloor.org>
 <20100201103526.GG12759@laptop>
 <20100201104544.GJ29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201104544.GJ29555@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:45:44AM +0100, Andi Kleen wrote:
> On Mon, Feb 01, 2010 at 09:35:26PM +1100, Nick Piggin wrote:
> > > > > > I always preferred to do defrag in the opposite way. Ie. query the
> > > > > > slab allocator from existing shrinkers rather than opposite way
> > > > > > around. This lets you reuse more of the locking and refcounting etc.
> > > > > 
> > > > > I looked at this for hwpoison soft offline.
> > > > > 
> > > > > But it works really badly because the LRU list ordering 
> > > > > has nothing to do with the actual ordering inside the slab pages.
> > > > 
> > > > No, you don't *have* to follow LRU order. The most important thing
> > > 
> > > What list would you follow then?
> > 
> > You can follow the slab, as I said in the first mail.
> 
> That's pretty much what Christoph's patchkit is about (with yes some details
> improved)

I know what the patch is about. Can you re-read my first mail?


> > > There's LRU, there's hast (which is as random) and there's slab
> > > itself. The only one who is guaranteed to match the physical
> > > layout in memory is slab. That is what this patchkit is trying
> > > to attempt.
> > > 
> > > > is if you followed what I wrote is to get a pin on the objects and
> > > 
> > > Which objects? You first need to collect all that belong to a page.
> > > How else would you do that?
> > 
> > Objects that you're interested in reclaiming, I guess. I don't
> > understand the question.
> 
> Objects that are in the same page

OK, well you can pin an object, and from there you can find other
objects in the same page.

This is totally different to how Christoph's patch has to pin the
slab, then (in a restrictive context) pin the objects, then go to
a more relaxed context to reclaim the objects. This is where much
of the complexity comes from.


> There are really two different cases here:
> - Run out of memory: in this case i just want to find all the objects
> of any page, ideally of not that recently used pages.
> - I am very fragmented and want a specific page freed to get a 2MB
> region back or for hwpoison:  same, but do it for a specific page.
> 
> 
> > Right, but as you can see it is complex to do it this way. And I
> > think for reclaim driven targetted reclaim, then it needn't be so
> > inefficient because you aren't restricted to just one page, but
> > in any page which is heavily fragmented (and by definition there
> > should be a lot of them in the system).
> 
> Assuming you can identify them quickly.

Well because there are a large number of them, then you are likely
to encounter one very quickly just off the LRU list.


> > Hwpoison I don't think adds much weight, frankly. Just panic and
> > reboot if you get unrecoverable error. We have everything to handle
> 
> This is for soft hwpoison :- offlining pages that might go bad
> in the future.

I still don't think it adds much weight. Especially if you can just
try an inefficient scan.
 

> But soft hwpoison isn't the only user. The other big one would
> be for large pages or other large page allocations.
