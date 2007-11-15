Return-Path: <linux-kernel-owner+w=401wt.eu-S1765047AbXKOVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765047AbXKOVO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbXKOVOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:14:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbXKOVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:14:49 -0500
Date: Thu, 15 Nov 2007 13:14:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
 Bugs)
In-Reply-To: <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net>  <20071113110259.44c56d42.akpm@linux-foundation.org>  <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>  <20071113130411.26ccae12.akpm@linux-foundation.org>  <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
  <20071115040708.GB15302@brong.net>  <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>  <20071115052538.GA21522@brong.net>  <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>  <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
  <20071115115049.GA8297@brong.net>  <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>  <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Linus Torvalds wrote:
> 
> Unacceptable. We used to do exactly what your patch does, and it got fixed 
> once. We're not introducing that fundamentally broken concept again.

Examples of non-broken solutions:
 (a) always use lowmem sizes (what we do now)
 (b) always use total mem sizes (sane but potentially dangerous: but the 
     VM pressure should work! It has serious bounce-buffer issues, though, 
     which is why I think it's crazy even if it's otherwise consistent)
 (c) make all dirty counting be *purely* per-bdi, so that everybody can 
     disagree on what the limits are, but at least they also then use 
     different counters

So it's just the "different writers look at the same dirty counts but then 
interpret it to mean totally different things" that I think is so 
fundamentally bogus. I'm not claiming that what we do now is the only way 
to do things, I just don't think your approach is tenable.

Btw, I actually suspect that while (a) is what we do now, for the specific 
case that Bron has, we could have a /proc/sys/vm option to just enable 
(b). So we don't have to have just one consistent model, we can allow odd 
users (and Bron sounds like one - sorry Bron ;) to just force other, odd, 
but consistent models.

I'd also like to point out that while the "bounce buffer" issue is not so 
much a HIGHMEM issue on its own (it's really about the device DMA limits, 
which are _independent_ of HIGHMEM, of course), the reason HIGHMEM is 
special is that without HIGHMEM the bounce buffers generally work 
perfectly fine.

The problem with HIGHMEM is that it causes various metadata (dentries, 
inodes, page struct tables etc) to eat up memory "prime real estate" under 
the same kind of conditions that also dirty a lot of memory. So the reason 
we disallow HIGHMEM from dirty limits is only *partly* the per-device or 
mapping DMA limits, and to a large degree the fact that non-highmem memory 
is special in general, and it is usually the non-highmem areas that are 
constrained - and need to be protected.

			Linus
