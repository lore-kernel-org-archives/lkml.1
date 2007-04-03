Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbXDCGKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbXDCGKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXDCGKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:10:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34757 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbXDCGKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:10:06 -0400
Date: Mon, 2 Apr 2007 23:09:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, xfs-masters@oss.sgi.com, reiserfs-dev@namesys.com
Subject: Re: [PATCH] Cleanup and kernelify shrinker registration (rc5-mm2)
Message-Id: <20070402230954.27840721.akpm@linux-foundation.org>
In-Reply-To: <1175579225.12230.504.camel@localhost.localdomain>
References: <1175571885.12230.473.camel@localhost.localdomain>
	<20070402205825.12190e52.akpm@linux-foundation.org>
	<1175575503.12230.484.camel@localhost.localdomain>
	<20070402215702.6e3782a9.akpm@linux-foundation.org>
	<1175579225.12230.504.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 15:47:05 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 2007-04-02 at 21:57 -0700, Andrew Morton wrote:
> > On Tue, 03 Apr 2007 14:45:02 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > Does that mean the to function correctly every user needs some internal
> > > cursor so it doesn't end up scanning the first N entries over and over?
> > > 
> > 
> > If it wants to be well-behaved, and to behave as the VM expects, yes. 
> > 
> > There's an expectation that the callback will be performing some scan-based
> > aging operation and of course to do LRU (or whatever) aging, the callback
> > will need to remember where it was up to last time it was called.
> > 
> > But it's just a guideline - callbacks could do something different but
> > in-the-spirit, I guess.
> 
> Hmm, actually the callers I looked at (nfs, dcache, mbcache) seem to use
> an LRU list and just walk the first "nr_to_scan" entries, and nr_to_scan
> is always 128.

That's just because of the batching logic up in shrink_slab().  And iirc we
only break the scanning into lumps of 128 items so we can add a
cond_resched() into it.

> Someone who keeps a cursor will be disadvantaged: the other shrinkers
> could well get less effective on repeated calls, but we won't.  Someone
> who picks entries at random might have the same issue.

To examine the balancing one would need to examine the value of total_scan
in shrink_slab(), rather than looking at the value which shrink_slab()
passes into the callback.

> I think it is clearest to describe how we expect everyone to work, and
> let whoever is getting creative worry about it themselves.
> 
> How's this:
> ==
> Cleanup and kernelify shrinker registration.

hm, well, six-of-one, VI of the other.  We save maybe four kmallocs across
the entire uptime at the cost of exposing stuff kernel-side which doesn't
need to be exposed.

But I think we need to weed that crappiness out of XFS first.

