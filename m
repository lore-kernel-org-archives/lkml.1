Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbZBDQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbZBDQOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZBDQOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:14:02 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37180 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752541AbZBDQOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:14:00 -0500
Date: Wed, 4 Feb 2009 11:06:20 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <498893EE.9060107@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0902041050160.19633@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de> <1232959706.21504.7.camel@penberg-laptop> <20090203101205.GF9840@csn.ul.ie> <498893EE.9060107@cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Pekka Enberg wrote:

> Anyway, even if we did end up going forward with SLQB, it would sure as hell
> be less painful if we understood the reasons behind it.

The reasons may depend on hardware contingencies like TLB handling
overhead and various inefficiencies that depend on the exact processor
model. Also the type of applications you want to run. Some of the IA64
heritage of SLUB may be seen in the results of these tests. Note that PPC
and IA64 have larger page sizes (which results in SLUB being able to put
more objects into an order 0 page) and higher penalties for TLB handling.
The initial justification for SLUB were Mel's results on IA64 that showed
a 5-10% increase in performance through SLUB.

In my current position we need to run extremely low latency code in user
space and want to avoid any disturbance by kernel code interrupting user
space. My main concern for my current work context is that switching to
SLQB will bring back the old cache cleaning problems and introduce
latencies for our user space applications. Otherwise I am on x86 now so
the TLB issues are less of a concern for me now.

In general it may be better to have a larger selection of slab allocators.
I think this is no problem as long as we have motivated people that
maintain these. Nick seems to be very motivated at this point. So lets
merge SLQB as soon as we can and expose it to a wider audience so that it
can mature. And people can have more fun running one against the other
refining these more and more.

There are still two major things that I hope will happen soon to clean up stuff in
the slab allocators:

1. The introduction of a per cpu allocator.

This is important to optimize the fastpaths. The cpu allocator will allow
us to get rid of the arrays indexes by NR_CPUS and allow operations that
are atomic wrt. interrupts. The lookup of the kmem_cache_cpu struct
address will no longer be necessary.

2. Alloc/free without disabling interrupts.

Matthieu has written an early implementation of allocation functions that
do not require interrupt disable/enable. It seems that these are right now
the major cause of latency in the fast paths. Andi has stated that the
interrupt enable/disable has been optimized in recent releases of new
processors. The overhead may be due to the flags being pushed onto the
stack and retrieved later. Mathieus implementation can be made more
elegant if atomic per cpu ops are available. This could significantly
increase the speed of the fast paths in the allocators (may be a challenge
to SLAB and SLQB since they need to update a counter and a pointer but its
straightforward in SLUB).

