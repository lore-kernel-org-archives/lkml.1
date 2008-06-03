Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYFCVde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYFCVde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFCVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:33:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58301 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYFCVd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:33:28 -0400
Date: Tue, 3 Jun 2008 15:33:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080603213310.GC3549@parisc-linux.org>
References: <1211852026.3286.36.camel@pasglop> <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org> <20080602072403.GA20222@flint.arm.linux.org.uk> <200806031416.18195.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0806031154050.3242@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806031154050.3242@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 12:43:21PM -0700, Trent Piepho wrote:
> IOW, there are four ways one can defined endianness/swapping:
> 1) Little-endian
> 2) Big-endian
> 3) Native-endian aka non-byte-swapping
> 4) Foreign-endian aka byte-swapping
> 
> 1 and 2 are by far the most used.  Some code wants 3.  No one wants 4.  Yet
> our API is providing 3 & 4, the two which are the least useful.

You've fundamentally misunderstood.

readX/writeX and __readX/__writeX provide little-endian access.
__raw_readX provide native-endian.

If you want 2 or 4, define your own accessors.  Some architectures define
other accessors (eg gsc_readX on parisc is native (big) endian, and
works on physical addresses that haven't been ioremapped.  sbus_readX on
sparc64 also seems to be native (big) endian).

> Is it enough to provide only "all or none" for ordering strictness?  For
> instance on powerpc, one can get a speedup by dropping strict ordering for 
> IO
> vs cacheable memory, but still keeping ordering for IO vs IO and IO vs 
> locks. This is much easier to program for than no ordering at all.  In 
> fact, if one
> doesn't use coherent DMA, it's basically the same as fully strict ordering.

I don't understand why you keep talking about DMA.  Are you talking
about ordering between readX() and DMA?  PCI proides those guarantees.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
