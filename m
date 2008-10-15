Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYJOSDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYJOSDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYJOSDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:03:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYJOSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:03:25 -0400
Date: Wed, 15 Oct 2008 11:03:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] SLOB memory ordering issue
In-Reply-To: <200810160445.28781.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0810151058540.3288@nehalem.linux-foundation.org>
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160410.49894.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0810151028110.3288@nehalem.linux-foundation.org> <200810160445.28781.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Nick Piggin wrote:
> 
> What do you mean by the allocation is stable?

"all writes done to it before it's exposed".

> 2. I think it could be easy to assume that the allocated object that was
> initialised with a ctor for us already will have its initializing stores
> ordered when we get it from slab.

You make tons of assumptions.

You assume that
 (a) unlocked accesses are the normal case and should be something the 
     allocator should prioritize/care about.
 (b) that if you have a ctor, it's the only thing the allocator will do.

I don't think either of those assumptions are at all relevant or 
interesting. Quite the reverse - I'd expect them to be in a very small 
minority.

Now, obviously, on pretty much all machines out there (ie x86[-64] and UP 
ARM), smp_wmb() is a no-op, so in that sense we could certainly say that 
"sure, this is a total special case, but we can add a smp_wmb() anyway 
since it won't cost us anything".

On the other hand, on the machines where it doesn't cost us anything, it 
obviously doesn't _do_ anything either, so that argument is pretty 
dubious. 

And on machines where the memory ordering _can_ matter, it's going to add 
cost to the wrong point.

		Linus
