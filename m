Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbXHFST0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbXHFST0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbXHFSTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:19:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58854 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbXHFSTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:19:15 -0400
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <200708061035.18742.phillips@phunq.net>
References: <20070806102922.907530000@chello.nl>
	 <200708061035.18742.phillips@phunq.net>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 20:17:28 +0200
Message-Id: <1186424248.11797.66.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 10:35 -0700, Daniel Phillips wrote:
> On Monday 06 August 2007 03:29, Peter Zijlstra wrote:

> > We want a guarantee for N bytes from kmalloc(), this translates to a
> > demand on the slab allocator for 2*N+m (due to the power-of-two
> > nature of kmalloc slabs), where m is the meta-data needed by the
> > allocator itself.
> 
> Where does the 2* come from?  Isn't it exp2(ceil(log2(N + m)))?

Given a size distribution of 2^n the worst slack space is 100% - see how
allocations of (2^m) + 1 will always need 2^(m+1) bytes.

lim_{n -> inf} (2^(n+1)/((2^n)+1)) = 
2^lim_{n -> inf} ((n+1)-n) = 2^1 = 2

> Patch [3/10] adds a new field to struct page.

No it doesn't.

>   I do not think this is 
> necessary.   Allocating a page from reserve does not make it special.  
> All we care about is that the total number of pages taken out of 
> reserve is balanced by the total pages freed by a user of the reserve.

And how do we know a page was taken out of the reserves?

This is done by looking at page->reserve (overload of page->index) and
this value can be destroyed as soon as its observed. It is in a sense an
extra return value.

> We do care about slab fragmentation in the sense that a slab page may be 
> pinned in the slab by an unprivileged allocation and so that page may 
> never be returned to the global page reserve.

A slab page obtained from the reseserve will never serve an object to an
unprivilidged allocation.

>   One way to solve this is 
> to have a per slabpage flag indicating the page came from reserve, and 
> prevent mixing of privileged and unprivileged allocations on such a 
> page.

is done.

> This patch set is _way_ less intimidating than its predecessor.  
> However, I see we have entered the era of sets of patch sets, since it 
> is impossible to understand the need for this allocation infrastructure 
> without reading the dependent network patch set.  Waiting with 
> breathless anticipation.

Yeah, there were some objections to the size of it.

