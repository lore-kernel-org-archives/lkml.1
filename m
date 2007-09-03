Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbXICUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbXICUJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 16:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXICUJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 16:09:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46821 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXICUJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 16:09:10 -0400
Date: Mon, 3 Sep 2007 13:09:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       josh@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Make rcutorture RNG use temporal entropy
Message-ID: <20070903200905.GA647@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070816024904.GA5312@linux.vnet.ibm.com> <20070817115356.cb201e42.akpm@linux-foundation.org> <20070817200022.GH8464@linux.vnet.ibm.com> <20070823180658.GQ11166@waste.org> <20070823185830.GC8371@linux.vnet.ibm.com> <20070823194037.GW30556@waste.org> <20070828011554.GB31860@linux.vnet.ibm.com> <20070903132904.GV21720@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903132904.GV21720@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 08:29:04AM -0500, Matt Mackall wrote:
> On Mon, Aug 27, 2007 at 06:15:54PM -0700, Paul E. McKenney wrote:
> > On Thu, Aug 23, 2007 at 02:40:37PM -0500, Matt Mackall wrote:
> > > Yes. Using a hash function rather than a trivial LFSR is preferable.
> > > But pulling the guts out and giving it an n-bytes interface like
> > > get_random_bytes().
> > 
> > OK.  But this cannot be the first discussion of getting a fast and loose
> > version of get_random_bytes() into the kernel.  Anyplace I should look
> > for cautionary tales?  A quick search located a spirited discussion of
> > proposed kernel infrastructure for user-mode random number generation
> > back in 2003, but...
> > 
> > Also a 2006 proposal from Stephan Eranian: http://lkml.org/lkml/2006/8/23/41
> > This appears to have gotten zero replies.  :-/  (Though not hash-based.)
> 
> You probably did the same searches I would do, so no, don't have any
> pointers, just vague recollections.

I was afraid of that.  ;-)

> > Other semi-related threads:
> > 
> > 	http://lkml.org/lkml/2005/3/15/102
> > 	http://lkml.org/lkml/2004/9/23/337
> > 
> > Some years back, my reflexive design would have been per-CPU state,
> > accessed with interrupts disabled.  Not so good for realtime usage,
> > though.  One could go with per-task state in order to avoid the
> > interrupt disabling, which might be OK if the state is quite small.
> 
> We only need be concerned here with locking insofar as we'd produce
> duplicate output without it. So it's fairly easy to imagine a lockless
> design using percpu data and perhaps folding in the preemption state.

And if we have a hash on the output, conflicting updates to the state
should be tolerable as well.  Still want per-CPU state in order to
avoid cache thrashing, of course, but should be able to avoid preemption
disabling.  So the trick will be getting a performance/size/entropy
tradeoff that 75% of the current roll-your-own random-number-generator
uses can live with.

						Thanx, Paul
