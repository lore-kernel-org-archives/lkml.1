Return-Path: <linux-kernel-owner+w=401wt.eu-S933850AbXGWSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850AbXGWSlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbXGWSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:41:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57706 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbXGWSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:41:06 -0400
Subject: Re: [PATCH] add __GFP_ZERP to GFP_LEVEL_MASK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20070723113712.c0ee29e5.akpm@linux-foundation.org>
References: <1185185020.8197.11.camel@twins>
	 <20070723113712.c0ee29e5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 20:40:48 +0200
Message-Id: <1185216048.5535.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 11:37 -0700, Andrew Morton wrote:
> On Mon, 23 Jul 2007 12:03:40 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Daniel recently spotted that __GFP_ZERO is not (and has never been)
> > part of GFP_LEVEL_MASK. I could not find a reason for this in the
> > original patch: 3977971c7f09ce08ed1b8d7a67b2098eb732e4cd in the -bk
> > tree.
> 
> It doesn't make a lot of sense to be passing __GFP_ZERO into slab
> allocation functions.  It's not really for the caller to be telling slab
> how it should arrange for its new memory to get zeroed.
> 
> And the caller of slab functions will need to zero the memory anyway,
> because you don't know whether your new object came direct from the page
> allocator or if it is recycled memory from a partial slab.
> 
> I have a feeling that we did support passing __GFP_ZERO into the slab
> allocation functions for a while, but took it out.

Didn't we just reinstate doing that?

/me goes look at .23-rc1

# grep __GFP_ZERO mm/sl[uoa]b.c
mm/slab.c:      BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
mm/slab.c:      if (unlikely((flags & __GFP_ZERO) && ptr))
mm/slab.c:      if (unlikely((flags & __GFP_ZERO) && objp))
mm/slob.c:      if (unlikely((gfp & __GFP_ZERO) && b))
mm/slub.c:      BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
mm/slub.c:      if (unlikely((gfpflags & __GFP_ZERO) && object))


seems to suggest we do.

