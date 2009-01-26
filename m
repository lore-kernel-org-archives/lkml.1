Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZAZRVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZAZRVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZAZRVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:21:21 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:50296 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZAZRVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:21:20 -0500
Date: Mon, 26 Jan 2009 12:17:28 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
In-Reply-To: <200901240317.26227.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0901261206500.32192@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901240241.06670.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901231057280.32253@qirst.com> <200901240317.26227.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Nick Piggin wrote:

> > Or if you prefer order-0. Do a single linked list like SLQB does.
>
> The fundamental issues I guess are that slab pages are kernel mapped, and
> within a given slab, the zone and movability are irrelevant.

Right. There are multiple subsystems that all have the same requirements.

> Other ones which could be changed but could introduce regressions are
> watermarks, buddy merging, and struct page error checking and setup.

Isnt it possible to defer that (queuing them (sigh)). A bitmap could be
used to avoid queuing and may even allow fully concurrent allocations
without locks. Use a counter to check watermarks once in a while.

Struct page error checking could only be enabled for debugging purposes.


> I brought all this up when it was discussed. Did you find any ways to
> improve anything?

I played around with some bitmap concepts having basically a bit vector
per MAX_ORDER page (plus giving a preferred order to each MAX_ORDER
chunk in order to avoid fragmenation) but I had to abandon that at the
time due to time constraints.

The bitmap / counter approach could get a way with testing/incrementing a
percpu counter and flipping a bit. One of the reasons that I am quite
pushy on the per cpu atomic ops vs. interrupts is that these would allow
a page allocator fastpath w/o disabling interrupts.

> (I did make that patch to enable refcounting to be avoided FWIW, which
> avoids a couple of atomic operations, but I don't think it brought
> performance up too much, but I still intend to dust it off at some
> point).

Well if the page stays with a refcount of one then we do not need to check
the refcount at all but just push it in an out of some queue / bitmap or
something.
