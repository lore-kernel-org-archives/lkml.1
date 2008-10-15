Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYJORdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYJORdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYJORd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:33:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbYJORd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:33:28 -0400
Date: Wed, 15 Oct 2008 10:33:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] SLOB memory ordering issue
In-Reply-To: <200810160410.49894.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0810151028110.3288@nehalem.linux-foundation.org>
References: <200810160334.13082.nickpiggin@yahoo.com.au> <1224089658.3316.218.camel@calx> <200810160410.49894.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Nick Piggin wrote:
> 
> Now they allocate these guys, take a lock, then insert them into the
> page tables. The lock is only an acquire barrier, so it can leak past
> stores.

I think that Matt's point was that the code is buggy regardless of any 
ctor or not.

If you make an allocation visible to other CPU's, you would need to make 
sure that allocation is stable with a smp_wmb() before you update the 
pointer to that allocation.

So the code that makes a page visible should just always do that 
synchronization.

And it has nothing to do with ctors or not. It's true whether you do the 
initialization by hand, or whether you use a ctor.

And more importantly, putting the write barrier in the ctor or in the 
memory allocator is simply broken. It's not a ctor/allocator issue. Why? 
Because even if you have a ctor, there is absolutely *nothing* that says 
that the ctor will be sufficient to initialize everything. Most ctors, in 
fact, are just initializing the basic fields - the person that does the 
allocation should finish things up.

The fact that _some_ people using an allocator with a ctor may not do 
anything but the ctor to the page is immaterial.

		Linus
