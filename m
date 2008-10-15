Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYJOS1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYJOS1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYJOS1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:27:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbYJOS1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:27:36 -0400
Date: Wed, 15 Oct 2008 11:26:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, Hugh Dickins <hugh@veritas.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc] SLOB memory ordering issue
In-Reply-To: <200810160506.14261.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0810151116430.3288@nehalem.linux-foundation.org>
References: <200810160334.13082.nickpiggin@yahoo.com.au> <1224089658.3316.218.camel@calx> <200810160410.49894.nickpiggin@yahoo.com.au> <200810160506.14261.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Nick Piggin wrote:
> 
> Who was it that said memory ordering was self-evident?

Nobody has _ever_ said that memory ordering is self-evident. Quite the 
reverse.

What we've said is that it's not a ctor issue. This has nothing 
what-so-ever to do with ctors, and everything to do with the fact that 
lockless is hard.

And the general rule is: to find a page (or any other data structures) on 
another CPU, you need to insert it into the right data structures. And 
that insertion event needs to either be locked, or it needs to be ordered.

But notice that it's the _insertion_ event. Not the ctor. Not the 
allocator. It's the person _doing_ the allocation that needs to order 
things.

See?

And no, I didn't look at your exact case. But for pages in page tables, 
we'd need to have the right smp_wmb() at the "set_pte[_at]()" stage, 
either inside that macro or in the caller.

We used to only care about the page _contents_ (because the only unlocked 
access was the one that was done by hardware), but now that we do unlocked 
lookups in software too, we need to make sure the "struct page" itself is 
also valid.

For non-page-table lookups (LRU, radix trees, etc etc), the rules are 
different. Again, it's not an _allocator_ (or ctor) issue, it's about the 
point where you insert the thing. If you insert the page using a lock, you 
need not worry about memory ordering at all. And if you insert it using 
RCU, you do.

This is *all* we have argued about. The argument is simple: this has 
NOTHING to do with the allocator, and has NOTHING to do with constructors.

			Linus
