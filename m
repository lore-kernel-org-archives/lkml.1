Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbXLGShk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbXLGShk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbXLGShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:37:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720AbXLGShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:37:23 -0500
Date: Fri, 7 Dec 2007 10:36:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
In-Reply-To: <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
References: <1197049846.1645.68.camel@localhost.localdomain> <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Dec 2007, Linus Torvalds wrote:
> 
> Can you do one run with oprofile, and see exactly where the cost is? It 
> should hopefully be pretty darn obvious, considering your timing.

So I checked hackbench on my machine with oprofile, and while I'm not 
seeing anything that says "ten times slower", I do see it hitting the slow 
path all the time, and __slab_alloc() is 15% of the profile.

With __slab_free() being another 8-9%.

I assume that with many CPU's, those get horrendously worse, with cache 
trashing.

The biggest cost of __slab_alloc() in my profile is the "slab_lock()", but 
that may not be the one that causes problems in a 64-cpu setup, so it 
would be good to have that verified.

Anyway, it's unclear whether the reason it goes into the slow-path because 
the freelist is just always empty, or whether it hits the

	... || !node_match(c, node)

case which can trigger on NUMA. That's another potential explanation of 
why you'd see such a *huge* slowdown (ie if the whole node-match thing 
doesn't work out, slub just never gets the fast-case at all). That said, 
the number of places that actually pass a specific node to slub is very 
limited, so I suspect it's not the node matching. But just disabling that 
test in slab_alloc() might be one thing to test.

[ The whole node match thing is likely totally bogus. I suspect we pay 
  *more* in trying to match nodes than we'd ever likely pay in just 
  returning the wrong node for an allocation, but that's neither here nor 
  there ]

But yeah, I'm not entirely sure SLUB is working out.

		Linus
