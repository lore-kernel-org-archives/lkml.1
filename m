Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbXKOV1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbXKOV1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXKOV10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:27:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42684 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXKOV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:27:25 -0500
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
	Bugs)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm, riel <riel@redhat.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net>
	 <20071113110259.44c56d42.akpm@linux-foundation.org>
	 <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>
	 <20071113130411.26ccae12.akpm@linux-foundation.org>
	 <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
	 <20071115040708.GB15302@brong.net>
	 <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
	 <20071115052538.GA21522@brong.net>
	 <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
	 <20071115115049.GA8297@brong.net>
	 <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
	 <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy>
	 <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 22:26:54 +0100
Message-Id: <1195162015.22457.52.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-15 at 13:14 -0800, Linus Torvalds wrote:
> 
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

I think that (c) is doable. If its worth the effort, who knows,
apparently there still are people using 32bit kernels on boxen with
mucho memory.

> So it's just the "different writers look at the same dirty counts but then 
> interpret it to mean totally different things" that I think is so 
> fundamentally bogus. I'm not claiming that what we do now is the only way 
> to do things, I just don't think your approach is tenable.

Agreed, the per mapping thing was utter crap.

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

But this problem is already an issue, Anton recently had a case where a
12GB highmem box locked up due to NTFS running out of lowmem - or
something like that.

And I think that with the targeted slab reclaim (or slab defrag as its
apparently still called) we can properly fix this side of the problem. I
think Rik was looking into doing so.

