Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZJHHkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZJHHkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 03:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZJHHkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 03:40:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:51270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbZJHHkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 03:40:10 -0400
Date: Thu, 8 Oct 2009 09:39:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091008073930.GZ30316@wotan.suse.de>
References: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain> <20091007210651.GB1656@one.firstfloor.org> <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain> <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain> <20091007222235.GC1656@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007222235.GC1656@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 12:22:35AM +0200, Andi Kleen wrote:
> On Wed, Oct 07, 2009 at 02:57:20PM -0700, Linus Torvalds wrote:
> > There's no question that prefetching cannot help, but it helps only if 
> > it's about fetching data that you would need anyway early. In contrast, if 
> > the option is "don't touch the other cacheline at all", prefetching is 
> > _always_ a loss. No ifs, buts and maybes about it.
> 
> My point (probably not very well written expressed)
> was that in a typical VFS operation there are hundreds
> of cache lines touched for various things (code, global, various
> objects, random stuff) and one more or less in the final dentry 
> is not that big a difference in the global picture.
> (ok I realize final in this case means the elements in the path)

Yes I do know what you were getting at... Although I would
say dcache is still fairly significant. It's 3 cachelines
for every single path element we look up. Now I suspect it
has been a while since someone closely looked at the cache
layout with an eye to the lookup code.

Actually no, it does look relatively sane (I guess it doesn't
change that much), except it might actualy be a nice idea
to move d_iname up to about above d_lru, so we could actually
do path lookup in 2 cachelines per entry (or even 1 if we
they have very short names).

I will do a bit of profiling on the lookup code and see...

