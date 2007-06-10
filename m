Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXFJOBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXFJOBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 10:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbXFJOAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 10:00:51 -0400
Received: from waste.org ([66.93.16.53]:47832 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbXFJOAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 10:00:50 -0400
Date: Sun, 10 Jun 2007 08:59:56 -0500
From: Matt Mackall <mpm@selenic.com>
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Message-ID: <20070610135956.GS11115@waste.org>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <20070609201159.GC11166@waste.org> <466B0C3F.3040300@garzik.org> <466B46D5.1020004@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466B46D5.1020004@cs.cmu.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 08:33:25PM -0400, Benjamin Gilbert wrote:
> Jeff Garzik wrote:
> >Matt Mackall wrote:
> >>Have you benchmarked this against lib/sha1.c? Please post the results.
> >>Until then, I'm frankly skeptical that your unrolled version is faster
> >>because when I introduced lib/sha1.c the rolled version therein won by
> >>a significant margin and had 1/10th the cache footprint.
> 
> See the benchmark tables in patch 0 at the head of this thread. 
> Performance improved by at least 25% in every test, and 40-60% was more 
> common for the 32-bit version (on a Pentium IV).
> 
> It's not just the loop unrolling; it's the register allocation and 
> spilling.  For comparison, I built SHATransform() from the 
> drivers/char/random.c in 2.6.11, using gcc 3.3.5 with -O2 and 
> SHA_CODE_SIZE == 3 (i.e., fully unrolled); I'm guessing this is pretty 
> close to what you tested back then.  The resulting code is 49% MOV 
> instructions, and 80% of *those* involve memory.  gcc4 is somewhat 
> better, but it still spills a whole lot, both for the 2.6.11 unrolled 
> code and for the current lib/sha1.c.

Wait, your benchmark is comparing against the unrolled code?

> In contrast, the assembly implementation in this patch only has to go to 
> memory for data and workspace (with one small exception in the F3 
> rounds), and the workspace has a fifth of the cache footprint of the 
> default implementation.

How big is the -code- footprint?

Earlier you wrote:

> On the aforementioned Pentium IV, /dev/urandom throughput goes from
> 3.7 MB/s to 5.6 MB/s with the patches; on the Core 2, it increases
> from 5.5 MB/s to 8.1 MB/s.

Whoa. We've regressed something horrible here:

http://groups.google.com/group/linux.kernel/msg/fba056363c99d4f9?dmode=source&hl=en

In 2003, I was getting 17MB/s out of my Athlon. Now I'm getting 2.7MB/s.
Were your tests with or without the latest /dev/urandom fixes? This
one in particular:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=commitdiff;h=374f167dfb97c1785515a0c41e32a66b414859a8

-- 
Mathematics is the supreme nostalgia of our time.
