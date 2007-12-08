Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXLHWRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXLHWRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXLHWRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:17:32 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:38256 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXLHWRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:17:31 -0500
Date: Sat, 8 Dec 2007 17:16:24 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
In-Reply-To: <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0712081702450.23837@gandalf.stny.rr.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

> On Fri, 7 Dec 2007, Linus Torvalds wrote:
> >
> > Can you do one run with oprofile, and see exactly where the cost is? It
> > should hopefully be pretty darn obvious, considering your timing.

The results are here:

http://people.redhat.com/srostedt/slub/results/slab.op
http://people.redhat.com/srostedt/slub/results/slub.op


>
> Anyway, it's unclear whether the reason it goes into the slow-path because
> the freelist is just always empty, or whether it hits the
>
> 	... || !node_match(c, node)

I did two things. First I tried making node_match always return true,
the second was just commenting out the above check. They both had pretty
much the exact same results. It slowed down by double! Instead of taking
15 seconds to complete, both took 30 seconds to complete.

Here's the oprofiles of those runs.

  node_match return 1:
http://people.redhat.com/srostedt/slub/results/slub-nonode.op

  comment out node_match check:
http://people.redhat.com/srostedt/slub/results/slub-nochecknode.op


>
> [ The whole node match thing is likely totally bogus. I suspect we pay
>   *more* in trying to match nodes than we'd ever likely pay in just
>   returning the wrong node for an allocation, but that's neither here nor
>   there ]

I don't think it's bogus by the result that removing it slowes it down
by half.


I'm wondering if there's not some other cache thrashing happening
somewhere else in the slub code. I'll start adding some stats in the code
to see where the congestion might lie. I'll look into this on Monday.

Seems that both SLAB and SLUB run kernel compiles the same. Here's the
results of my compile test. (make -j256 and chrt -f 10 make -j256)

http://people.redhat.com/srostedt/slub/

-- Steve


