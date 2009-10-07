Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbZJGQa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbZJGQa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbZJGQa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:30:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759541AbZJGQa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:30:27 -0400
Date: Wed, 7 Oct 2009 18:29:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091007162949.GV30316@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 07:56:33AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Oct 2009, Nick Piggin wrote:
> > 
> > OK, I have a really basic patch that does store-free path walking
> > (except on the final element).
> 
> Yay!
> 
> > dbench is pretty nasty still because it seems to do a lot of stupid 
> > things like reading from /proc/mounts all the time.
> 
> You should largely forget about dbench, it can certainly be a useful 
> benchmark, but at the same time it's certainly not a _meaningful_ one.
> There are better things to try.

Yes, sure. I'm just pointing out that it seems to do insane things
(like reading /proc/mounts at regular intervals, although I don't
see that in dbench source so I really hope it isn't libc being
"smart").

I agree it is not a very good benchmark.

 
> > The seqlock in the dentry is for getting consistent name,len pointer,
> > and also not giving a false positive if a rename has partially
> > overwritten the name string (false negatives are always fine in the
> > lock free lookup path but false positives are not). Possibly we
> > could make do with a per-sb seqlock for this (or just rename_lock).
> 
> My plan was always to just use rename_lock, and only do it at the outer 
> level (and do it for both lookup failures _and_ for the success case). 
> Your approach is _way_ more conservative than I would have done, and also 
> potentially much slower due to the seqlock-per-path-component thing. 

Hmm, the only issue is that we need a consistent load of the name
pointer and the length, otherwise our memcmp might go crazy. We
could solve this by another level of indirection so a rename only
requires a pointer swap...

But anyway at this approach I only use a single seqlock, because
the negative case always falls out to the locked walk anyway (this
again might be a bit conservative and something we could tighten
up).

 
> Remember: seqlocks are almost free on x86, but they can be reasonably 
> expensive in other places.
> 
> Hmm. Regardless, this very much does look like what I envisioned, apart 
> from details like that. And maybe your per-dentry seqlock is the right 
> choice. On x86, it certainly doesn't have the performance issues it could 
> have in other places.

Yeah, well at least the basics seem to be there. I agree it is not
totally clean and will have some cases that need optimising, but it
is something people can start looking at...

