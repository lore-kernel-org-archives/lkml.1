Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbXHOU37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbXHOU37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXHOU3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:29:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45681 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753857AbXHOU3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:29:48 -0400
Date: Wed, 15 Aug 2007 13:29:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <1187183526.6114.45.camel@twins>
Message-ID: <Pine.LNX.4.64.0708151324121.7326@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>  <20070815122253.GA15268@wotan.suse.de>
 <1187183526.6114.45.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Peter Zijlstra wrote:

> Christoph's suggestion to set min_free_kbytes to 20% is ridiculous - nor
> does it solve all deadlocks :-(

Only if min_free_kbytes is really the mininum number of free pages and not 
the mininum number of clean pages as I suggested.

All deadlocks? There are numerous ones that can come about for different 
reasons. Which ones are we talking about?

> RX
>  - we basically need infinite memory to receive the network reply
>    to complete writeout. Consider the following scenario:

There is no infinite memory. At some point you need to bound the amount 
of memory that the network allocates.

>  - so we need a threshold of some sorts to start tossing non-critical
>    network packets away. (because the consumer of these packets may be
>    the one swapping and is therefore frozen)

Right.

> <> What Christoph is proposing is doing recursive reclaim and not
> initiating writeout. This will only work _IFF_ there are clean pages
> about. Which in the general case need not be true (memory might be
> packed with anonymous pages - consider an MPI cluster doing computation
> stuff). So this gets us a workload dependant solution - which IMHO is
> bad!

In the general case this is true even for an MPI job because the MPI job 
needs to have executable code and libraries in memory. At mininum these 
are reclaimable.
 
> Also his suggestion to crank up min_free_kbytes to 20% of machine memory
> is not workable (again imagine this MPI cluster loosing 20% of its
> collective memory, very much out of the question).

It is workable. If you crank the min_clean_pages (this is essentially 
what it is) up to 20% then you basically reserve 20% of your memory for 
executable pages and page cache pages. And in an emergency these can be 
reclaimed to resolve any OOM issues. Note that my patch only accesses 
these reserves when we would otherwise OOM. This is rare.

> Nor does that solve the TCP deadlock, you need some additional condition
> to break that.

But that is an issue that is better handled in the network stack.
