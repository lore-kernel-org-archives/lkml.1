Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0BAKfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:35:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:36666 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0BAKfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:35:31 -0500
Date: Mon, 1 Feb 2010 21:35:26 +1100
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
Message-ID: <20100201103526.GG12759@laptop>
References: <20100129204931.789743493@quilx.com>
 <20100129205007.832823807@quilx.com>
 <20100129220044.GA31305@ZenIV.linux.org.uk>
 <20100201070835.GE9085@laptop>
 <20100201101013.GG29555@one.firstfloor.org>
 <20100201101645.GF12759@laptop>
 <20100201102253.GI29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201102253.GI29555@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:22:53AM +0100, Andi Kleen wrote:
> On Mon, Feb 01, 2010 at 09:16:45PM +1100, Nick Piggin wrote:
> > On Mon, Feb 01, 2010 at 11:10:13AM +0100, Andi Kleen wrote:
> > > On Mon, Feb 01, 2010 at 06:08:35PM +1100, Nick Piggin wrote:
> > > > I always preferred to do defrag in the opposite way. Ie. query the
> > > > slab allocator from existing shrinkers rather than opposite way
> > > > around. This lets you reuse more of the locking and refcounting etc.
> > > 
> > > I looked at this for hwpoison soft offline.
> > > 
> > > But it works really badly because the LRU list ordering 
> > > has nothing to do with the actual ordering inside the slab pages.
> > 
> > No, you don't *have* to follow LRU order. The most important thing
> 
> What list would you follow then?

You can follow the slab, as I said in the first mail.

> There's LRU, there's hast (which is as random) and there's slab
> itself. The only one who is guaranteed to match the physical
> layout in memory is slab. That is what this patchkit is trying
> to attempt.
> 
> > is if you followed what I wrote is to get a pin on the objects and
> 
> Which objects? You first need to collect all that belong to a page.
> How else would you do that?

Objects that you're interested in reclaiming, I guess. I don't
understand the question.

 
> > > > whether we are in this slab defrag mode, and if so, whether the slab
> > > > is very sparse. If yes, then reclaim aggressively.
> > > 
> > > The typical result is that you need to get through most of the LRU
> > > list (and prune them all) just to free the page.
> > 
> > Really? If you have a large proportion of slabs which are quite
> > internally fragmented, then I would have thought it would give a
> > significant improvement (aggressive reclaim, that is)
> 
> 
> You wrote the same as me?

Aggressive reclaim: as-in, ignoring referenced bit on the LRU,
*possibly* even trying to actively invalidate the dentry.


> > > > If that doesn't perform well enough and you have to go further and
> > > 
> > > It doesn't.
> > 
> > Can we see your numbers? And the patches you tried?
> 
> What I tried (in some dirty patches you probably don't want to see)
> was to just implement slab shrinking for a single page for soft hwpoison.
> But it didn't work too well because it couldn't free the objects
> still actually in the dcache.
> 
> Then I called the shrinker and tried to pass in the page as a hint
> and drop only objects on that page, but I realized that it's terrible
> inefficient to do it this way.
> 
> Now soft hwpoison doesn't care about a little inefficiency, but I still
> didn't like to be terrible inefficient.
> 
> That is why I asked Christoph to repost his old patchkit that can 
> do the shrink from the slab side (which is the right order here)

Right, but as you can see it is complex to do it this way. And I
think for reclaim driven targetted reclaim, then it needn't be so
inefficient because you aren't restricted to just one page, but
in any page which is heavily fragmented (and by definition there
should be a lot of them in the system).

Hwpoison I don't think adds much weight, frankly. Just panic and
reboot if you get unrecoverable error. We have everything to handle
that so I can't see how it's worth adding much complexity to the
kernel for.

