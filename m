Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbXKSDyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbXKSDyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 22:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXKSDyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 22:54:24 -0500
Received: from paragon.brong.net ([74.52.187.94]:47612 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbXKSDyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 22:54:23 -0500
Date: Mon, 19 Nov 2007 14:54:20 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Bron Gondwana <brong@fastmail.fm>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
	Bugs)
Message-ID: <20071119035420.GB15954@brong.net>
References: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org> <20071115115049.GA8297@brong.net> <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:14:32PM -0800, Linus Torvalds wrote:
 
Sorry about not replying to this earlier.  I actually got a weekend
away from the computer pretty much last weekend - took the kids
swimming, helped a friend clear dead wood from around her house
before the fire season.  Shocking I know.
 
> On Thu, 15 Nov 2007, Linus Torvalds wrote:
> > 
> > Unacceptable. We used to do exactly what your patch does, and it got fixed 
> > once. We're not introducing that fundamentally broken concept again.
> 
> Examples of non-broken solutions:
>  (a) always use lowmem sizes (what we do now)
>  (b) always use total mem sizes (sane but potentially dangerous: but the 
>      VM pressure should work! It has serious bounce-buffer issues, though, 
>      which is why I think it's crazy even if it's otherwise consistent)
>  (c) make all dirty counting be *purely* per-bdi, so that everybody can 
>      disagree on what the limits are, but at least they also then use 
>      different counters
> 
> So it's just the "different writers look at the same dirty counts but then 
> interpret it to mean totally different things" that I think is so 
> fundamentally bogus. I'm not claiming that what we do now is the only way 
> to do things, I just don't think your approach is tenable.
> 
> Btw, I actually suspect that while (a) is what we do now, for the specific 
> case that Bron has, we could have a /proc/sys/vm option to just enable 
> (b). So we don't have to have just one consistent model, we can allow odd 
> users (and Bron sounds like one - sorry Bron ;) to just force other, odd, 
> but consistent models.

Hey, if Andrew Morton can tell us we find all the interesting bugs, you
can call me odd.  I've been called worse!

We also run ReiserFS (3 of course, I tried 4 and it et my laptop disk)
on all our production IMAP servers.  Tried ext3 and the performance was
so horrible that our users hated us (and I hated being woken in the
night by things timing out and paging me).  And I'm spending far too
long still writing C thanks to Cyrus having enough bugs to keep me busy
for the rest of my natural life if I don't break and go write my own
IMAP server at some point. *clears throat*

> I'd also like to point out that while the "bounce buffer" issue is not so 
> much a HIGHMEM issue on its own (it's really about the device DMA limits, 
> which are _independent_ of HIGHMEM, of course), the reason HIGHMEM is 
> special is that without HIGHMEM the bounce buffers generally work 
> perfectly fine.
> 
> The problem with HIGHMEM is that it causes various metadata (dentries, 
> inodes, page struct tables etc) to eat up memory "prime real estate" under 
> the same kind of conditions that also dirty a lot of memory. So the reason 
> we disallow HIGHMEM from dirty limits is only *partly* the per-device or 
> mapping DMA limits, and to a large degree the fact that non-highmem memory 
> is special in general, and it is usually the non-highmem areas that are 
> constrained - and need to be protected.

I'm going to finish off writing a decent test case so I can reliably
reproduce the problem first, and then go compile a small set of kernels
with the various patches that have been thrown around here and see if
they solve the problems for me.

Thankfully I don't have the same problem you do Linus - I don't care if
any particular patch isn't consistent - isn't fair in the general sense
- even "doesn't work for anyone else".  So long as it's stable and it
works on this machine I'm happy to support it through the next couple
of years until we either get a world facing 64 bit machine with the
spare capacity to run DCC or we drop DCC.

The only reason to upgrade the kernel there at all is keeping up-to-date
with security patches, and the relative tradeoffs of backporting (or
expecting Adrian Bunk to keep doing it for us) rather than maintaing
a small patch to keep the behaviour of one thing we like.

And to all of you in this thread (especially Linus and Peter) - thanks
heaps for grabbing on to a throw away line in an unrelated discussion
and putting the work in to:

a) explain the problem and the cause to me before I put in heaps of
   work tracking it down; and

b) putting together some patches for me to test.

I saw a couple of days ago someone posted an "Ask Slashdot" whether
6 weeks was an appropriate time for a software vendor to get a fix
out to a customer and implying that the customer was an unrealistic
whiner to expect anyone to be able to do better.  I'll be able to
point to this thread if anyone suggests that you can't get decent
support on Linux!

Bron.
