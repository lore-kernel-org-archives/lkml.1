Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0BAKQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:16:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:36062 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0BAKQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:16:51 -0500
Date: Mon, 1 Feb 2010 21:16:45 +1100
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
Message-ID: <20100201101645.GF12759@laptop>
References: <20100129204931.789743493@quilx.com>
 <20100129205007.832823807@quilx.com>
 <20100129220044.GA31305@ZenIV.linux.org.uk>
 <20100201070835.GE9085@laptop>
 <20100201101013.GG29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201101013.GG29555@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:10:13AM +0100, Andi Kleen wrote:
> On Mon, Feb 01, 2010 at 06:08:35PM +1100, Nick Piggin wrote:
> > I always preferred to do defrag in the opposite way. Ie. query the
> > slab allocator from existing shrinkers rather than opposite way
> > around. This lets you reuse more of the locking and refcounting etc.
> 
> I looked at this for hwpoison soft offline.
> 
> But it works really badly because the LRU list ordering 
> has nothing to do with the actual ordering inside the slab pages.

No, you don't *have* to follow LRU order. The most important thing
is if you followed what I wrote is to get a pin on the objects and
the slabs via the regular shrinker path first, then querying slab
rather than calling into all these subsystems from an atomic, and
non-slab-reentrant path.

Following LRU order would just be the first and simplest cut at
this.

 
> Christoph's basic approach is more efficient.

I want to see numbers because it is also the far more complex
approach.

 
> > So you have a pin on the object somehow via the normal shrinker path,
> > and therefore you get a pin on the underlying slab. I would just like
> > to see even performance of a real simple approach that just asks
> > whether we are in this slab defrag mode, and if so, whether the slab
> > is very sparse. If yes, then reclaim aggressively.
> 
> The typical result is that you need to get through most of the LRU
> list (and prune them all) just to free the page.

Really? If you have a large proportion of slabs which are quite
internally fragmented, then I would have thought it would give a
significant improvement (aggressive reclaim, that is).


> > If that doesn't perform well enough and you have to go further and
> 
> It doesn't.

Can we see your numbers? And the patches you tried?

Thanks,
Nick
