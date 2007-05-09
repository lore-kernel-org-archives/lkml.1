Return-Path: <linux-kernel-owner+w=401wt.eu-S969819AbXEICTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969819AbXEICTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968513AbXEICTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:19:21 -0400
Received: from waste.org ([66.93.16.53]:42980 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967829AbXEICTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:19:20 -0400
Date: Tue, 8 May 2007 21:19:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070509021911.GB11115@waste.org>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net> <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 06:32:35PM -0700, Christoph Lameter wrote:
> On Tue, 8 May 2007, Matt Mackall wrote:
> 
> > On Tue, May 08, 2007 at 05:51:27PM -0700, Christoph Lameter wrote:
> > > On Tue, 8 May 2007, Matt Mackall wrote:
> > > 
> > > > First, SLOB no longer runs on SMP because SLAB grew some RCU-related
> > > > hair. So it now effectively has no locks at all! 
> > > 
> > > Well it seems that SLOB was not well maintained. RCU has been around for a 
> > > long time and SLOB has not been updated to cope with it.
> > 
> > RCU's incursion into SLAB that broke SLOB is relatively new. And it
> > only broke for people using SMP or SPARSEMEM. Intersection with target
> > audience of SLOB: ~0.
> 
> New meaning in the last 3 years?

Whatever. I've already told you why it's a dontcare. I'm basically
done with this thread until some actual memory usage numbers are
injected into it.

> > > SLUB can put 32 objects sized 128 byte each in a 4k page. Can SLOB do 
> > > the same?
> > 
> > Yes. It can in fact put 512 8-byte objects in a 4k page. More
> 
> So can SLUB.

Not without at least a bit per-object of overhead. So you can either
fit 512 objects in 4160 bytes or 504 objects in 4k.

> > importantly, it can put 2 1k objects and 16 128-byte objects on the
> > same page instead of on two pages.
> 
> That SLUB cannot do. And I do not believe you. SLOB must have some way to 
> distinguish the objects and their sizes since kfree does not include size 
> information. You can mix slabs of different size on the same page without 
> metadata. Magic?
> 
> So how does kfree then know how to free the object? There must be some way 
> where you get the metainformation. What is the point of your 8 byte 
> metadata that keeps getting inserted? That does not consume memory on a 
> page?

I've already explained this to you once tonight and there's only 8k of
code to read. It's also explained in the comment at the top:

 * SLAB is emulated on top of SLOB by simply calling constructors and
 * destructors for every SLAB allocation. Objects are returned with
 * the 8-byte alignment unless the SLAB_HWCACHE_ALIGN flag is
 * set, in which case the low-level allocator will fragment blocks to
 * create the proper alignment. Again, objects of page-size or greater
 * are allocated by calling __get_free_pages. As SLAB objects know
 * their size, no separate size bookkeeping is necessary and there is
 * essentially no allocation space overhead.

For the kmalloc case, we do have an 8-byte header, which works out to
be about 1/8th of the slop that mainline kmalloc over SLAB has on
average due to power of two cache sizes. So in both cases, less
overhead than SLAB and different-sized objects can be comingled. SLUB
would be awfully hard-pressed to have lower space overhead.

Compare:

void *kmem_cache_alloc(struct kmem_cache *c, gfp_t flags)
{
...
                b = slob_alloc(c->size, flags, c->align);
...
}

void kmem_cache_free(struct kmem_cache *c, void *b)
{
...
                slob_free(b, c->size);
...
}

vs.

void *__kmalloc(size_t size, gfp_t gfp)
{
...
                m = slob_alloc(size + SLOB_UNIT, gfp, 0);
                return m ? (void *)(m + 1) : 0;
...
}

void kfree(const void *block)
{
...
        slob_free((slob_t *)block - 1, 0);
...
}

-- 
Mathematics is the supreme nostalgia of our time.
