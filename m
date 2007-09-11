Return-Path: <linux-kernel-owner+w=401wt.eu-S967028AbXIKUYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967028AbXIKUYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934345AbXIKUXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:23:41 -0400
Received: from lazybastard.de ([212.112.238.170]:41671 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328AbXIKUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:23:38 -0400
Date: Tue, 11 Sep 2007 22:19:29 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <clameter@sgi.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911201928.GA20688@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <1189524967.32731.58.camel@localhost> <20070911164702.GD10831@v2.random> <1189535461.32731.75.camel@localhost> <20070911192052.GA14675@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070911192052.GA14675@v2.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Odd.  I keep arguing against the solution I prefer.

On Tue, 11 September 2007 21:20:52 +0200, Andrea Arcangeli wrote:
> 
> The the problem with the slub fragmentation isn't a new problem, it
> happens in today kernels as well and at least the slab by design is
> meant to _defrag_ internally. So it's practically already solved and
> it provides some guarantee unlike the buddy allocator.

Slab defrag doesn't look like a solved problem.  Basically, slab
allocator was designed to group similar objects together.  Main reason
in this context is that similar objects have similar lifetimes.  And it
is true that one dentry's lifetime is more likely to match another one's
that, say, a struct bio's.

But different dentries still have vastly different lifetimes.  And with
that, fragmentation will continue to occur.  So the problem is not
solved.  It is a hell of a lot better than pre-slab days, just not
perfect.

> What I think you're missing is that for Nick's worst case to trigger
> with the config_page_shift design, you would need the _whole_ ram to
> be _at_least_once_ allocated completely in kernel stacks. If the whole
> 100% of ram wouldn't go allocated in slub as a pure kernel stack, such
> a scenario could never materialize.

Things get somewhat worse with multiple attack vectors (whether
malicious or accidental).  Spending 20% of ram on each of {kernel
stacks, dentries, inodes, mlocked pages, size-XXX} would be sufficient.
The system can spend 20% on kernel stacks with 80% free, then spend 20%
on dentries with 60% free and 20% wasted in almost-free kernel stack
slabs, etc.

To argue in favor, for a change, the exact same scenario would be
possible with Christoph's solution as well.  It would even be more
likely.  Where in your case 20% of all memory has to go to each slab
cache at one time, only one page per largepage of that would be
necessary in Christophs case.  The rest could be allocated for other
purposes.

So overall I prefer your approach, for whatever my two cents of armchair
oppinion are worth.

Jörn

-- 
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
