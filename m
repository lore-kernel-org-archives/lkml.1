Return-Path: <linux-kernel-owner+w=401wt.eu-S1765185AbYBHWqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765185AbYBHWqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764275AbYBHWob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:44:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:54364 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955AbYBHWoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:44:30 -0500
Date: Fri, 8 Feb 2008 23:44:27 +0100
From: Nick Piggin <npiggin@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, dgc@sgi.com, akpm@linux-foundation.org,
       vegard.nossum@gmail.com, penberg@gmail.com
Subject: Re: [patch] block layer: kmemcheck fixes
Message-ID: <20080208224427.GC4952@wotan.suse.de>
References: <20080207103136.GG15220@kernel.dk> <20080207104901.GF16735@elte.hu> <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org> <20080207.172246.31415231.davem@davemloft.net> <47AC7093.1070003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC7093.1070003@linux.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 07:09:07AM -0800, Arjan van de Ven wrote:
> David Miller wrote:
> >From: Linus Torvalds <torvalds@linux-foundation.org>
> >Date: Thu, 7 Feb 2008 09:42:56 -0800 (PST)
> >
> >>Can we please just stop doing these one-by-one assignments, and just do 
> >>something like
> >>
> >>	memset(rq, 0, sizeof(*rq));
> >>	rq->q = q;
> >>	rq->ref_count = 1;
> >>	INIT_HLIST_NODE(&rq->hash);
> >>	RB_CLEAR_NODE(&rq->rb_node);
> >>
> >>instead?
> >>
> >>The memset() is likely faster and smaller than one-by-one assignments 
> >>anyway, even if the one-by-ones can avoid initializing some field or 
> >>there ends up being a double initialization..
> >
> >The problem is store buffer compression.  At least a few years
> >ago this made a huge difference in sk_buff initialization in the
> >networking.
> >
> >Maybe cpus these days have so much store bandwith that doing
> >things like the above is OK, but I doubt it :-)
> 
> on modern x86 cpus the memset may even be faster if the memory isn't in 
> cache;
> the "explicit" method ends up doing Write Allocate on the cache lines
> (so read them from memory) even though they then end up being written 
> entirely.
> With memset the CPU is told that the entire range is set to a new value, and
> the WA can be avoided for the whole-cachelines in the range.

Don't you have write combining store buffers? Or is it still speculatively
issuing the reads even before the whole cacheline is combined?

