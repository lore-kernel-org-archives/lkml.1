Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXCVKjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXCVKjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934093AbXCVKjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:39:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:49138 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934098AbXCVKjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:39:03 -0400
Subject: Re: [RFC/PATCH 0/15] Pass MAP_FIXED down to get_unmapped_area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Memory Management <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
In-Reply-To: <46025A6E.60603@yahoo.com.au>
References: <1174543217.531981.572863804039.qpush@grosgo>
	 <46023055.1030004@yahoo.com.au>
	 <1174558498.10836.30.camel@localhost.localdomain>
	 <46025A6E.60603@yahoo.com.au>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 21:38:57 +1100
Message-Id: <1174559937.10836.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Well if we use a set of valid ranges, then we can start with generic code
> that will set up ranges allowed by the syscall semantics.
> 
> Then the arch code could be called with that set of ranges, and perform
> its modifications to that set.

A bit complicated in practice... "set of ranges" can be big... depend on
what hthe restrictions actually are.

On powerpc, for example, the fs/driver don't even know. With my multiple
page size thingy for example, the only thing I want to rely on is the
page size of a given mapping. The arch code can open/close segments for
different page sizes depending if they have already some VMAs in them or
not. Thus providing ranges isn't a good idea.

With my slices patch (you can find it on linuxppc-dev, at least an older
version not base on that serie, I can post a newer one if you want), you
can see that hugetlbfs g_u_a basically turns into a single slice request
for a given page size and the arch code will automatically try to find a
segment already converted for that page size if any, if not, will try to
convert one that has no other VMAs in it.

Another counter example to you proposal is cacheable vs. cache
invalidate. A driver like /dev/mem or /proc/bus/pci only knows "cache
invalidate" in most case (and currently has no way to tell that to the
arch). It doesn't and shouldn't have to know what kind of rstrictions
the arch might have on such a mapping. Thus it shouldn't have to pick up
ranges. It doesn't care.
 
> This would add some constraint onto the ordering of whether driver or
> arch gets called first, but still wouldn't invalidate the above...

Problem is as I said above, driver doesn't really know about "ranges".
Driver really knows about constraints
> 
> > I'm still thinking about it. I think my first patch set is a good step
> > to give some more flexibility to archs but is by no mean something to
> > settle on.
> 
> Yeah definitely a nice start. And of course things should be done
> incrementally rather than thinking about a complete rewrite first ;)

Yeah...

Ben.


