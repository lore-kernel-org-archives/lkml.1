Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXGHSDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXGHSDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXGHSDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:03:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354AbXGHSDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:03:31 -0400
Date: Sun, 8 Jul 2007 11:02:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-Id: <20070708110224.9cd9df5b.akpm@linux-foundation.org>
In-Reply-To: <20070708075119.GA16631@elte.hu>
References: <20070708034952.022985379@sgi.com>
	<20070708035018.074510057@sgi.com>
	<20070708075119.GA16631@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007 09:51:19 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> (added Matt to the Cc: list)
> 
> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> > Maintenance of slab allocators becomes a problem as new features for 
> > allocators are developed. The SLOB allocator in particular has been 
> > lagging behind in many ways in the past:
> > 
> > - Had no support for SLAB_DESTROY_BY_RCU for years (but no one 
> >   noticed)
> > 
> > - Still has no support for slab reclaim counters. This may currently 
> >   not be necessary if one would restrict the supported configurations 
> >   for functionality relying on these. But even that has not been done.
> > 
> > The only current advantage over SLUB in terms of memory savings is 
> > through SLOBs kmalloc layout that is not power of two based like SLAB 
> > and SLUB which allows to eliminate some memory waste.
> > 
> > Through that SLOB has still a slight memory advantage over SLUB of 
> > ~350k in for a standard server configuration. It is likely that the 
> > savings are is smaller for real embedded configurations that have less 
> > functionality.
> 
> actually, one real advantage of the SLOB is that it is a minimal, really 
> simple allocator. Its text and data size is so small as well.
> 
> here's the size comparison:
> 
>    text    data     bss     dec     hex filename
>   10788     837      16   11641    2d79 mm/slab.o
>    6205    4207     124   10536    2928 mm/slub.o
>    1640      44       4    1688     698 mm/slob.o
> 
> slab/slub have roughly the same footprint, but slob is 10% of that size. 
> Would be a waste to throw this away.
> 
> A year ago the -rt kernel defaulted to the SLOB for a few releases, and 
> barring some initial scalability issues (which were solved in -rt) it 
> worked pretty well on generic PCs, so i dont buy the 'it doesnt work' 
> argument either.
> 

I don't think a saving of a few k of text would justify slob's retention.

A reason for retaining slob would be that it has some O(n) memory saving
due to better packing, etc.  Indeed that was the reason for merging it in
the first place.  If slob no longer retains that advantage (wrt slub) then
we no longer need it.


Guys, look at this the other way.  Suppose we only had slub, and someone
came along and said "here's a whole new allocator which saves 4.5k of
text", would we merge it on that basis?  Hell no, it's not worth it.  What
we might do is to get motivated to see if we can make slub less porky under
appropriate config settings.


Let's not get sentimental about these things: in general, if there's any
reasonable way in which we can rid ourselves of any code at all, we should
do so, no?
