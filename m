Return-Path: <linux-kernel-owner+w=401wt.eu-S933892AbZJOL1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbZJOL1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762686AbZJOL1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:27:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:44374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758428AbZJOL1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:27:22 -0400
Date: Thu, 15 Oct 2009 13:26:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [rfc][patch 4a/6] brlock: "fast" brlocks
Message-ID: <20091015112645.GD3127@wotan.suse.de>
References: <20091015044026.319860788@suse.de> <20091015050048.777261867@suse.de> <20091015065839.GA4262@wotan.suse.de> <1255604722.8392.467.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255604722.8392.467.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 01:05:21PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-10-15 at 08:58 +0200, Nick Piggin wrote:
> > [Not for merge. Stop reading if you're not interested in locking minutiae.]
> > 
> > OK, this is untested but I think the theory is right. Basically it is taking
> > the idea from Dave M's cool brlock optimisation stuff with one further
> > optimisation in that the read locker does not check the spinlock but
> > rather we keep another wlocked variable together inthe same cacheline per
> > CPU, so the read locker only has to touch one cacheline rather than 2.
> > 
> > This actually will reduce the number of atomics by 2 per path lookup,
> > however we have an smp_mb() there now which is really nasty on some
> > architectures (like ia64 and ppc64), and not that nice on x86 either.
> > We can probably do something interesting on ia64 and ppc64 so that we
> > take advantage of the fact rlocked and wlocked are in the same cacheline
> > so cache coherency (rather than memory consistency) should always provide
> > a strict ordering there. We still do need an acquire barrier -- but it is
> > a much nicer lwsync or st.acq on ppc and ia64.
> > 
> > But: is the avoidance of the atomic RMW a big win? On x86 cores I've tested
> > IIRC mfence is about as costly as a locked instruction which includes the
> > mfence...
> > 
> > So long story short: it might be a small win but it is going to be very
> > arch specific and will require arch specific code to do the barriers and
> > things. The generic spinlock brlock isn't bad at all, so I'll just post
> > this as a curiosity for the time being.
> >  
> 
> fwiw, I rather like this implementation better, and adding lockdep
> annotations to this one shouldn't be hard.

OK, although there is nothing preventing us from using raw spinlocks
and a new lockdep object to annotate the other one, right?

The problem with this one is that firstly it is not suitable for a
generic implementation (see XXX, we technically need smp_mb in the
unlock rather than smp_wmb -- I don't know if any actual CPUs do
this but several architectures do allow for stores to pass loads)

So we _really_ need to do proper acquire and release barriers both
here in the unlock and in the lock as well for it to be competitive
with the spinlocks.

smp_mb is a nasty hammer especially for release barrier because it
prevents loads from being started early until the unlock store is
visible. For acquire barrier it theoretically is not so bad, but in
practice like on powerpc they do it with an instruction that has to
apparently go out to the interconnect.

