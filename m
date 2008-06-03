Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYFCToo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYFCToo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYFCToU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:44:20 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:54013 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbYFCToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:44:19 -0400
Date: Tue, 3 Jun 2008 12:43:21 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <200806031416.18195.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0806031154050.3242@t2.domain.actdsltmp>
References: <1211852026.3286.36.camel@pasglop>
 <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org>
 <20080602072403.GA20222@flint.arm.linux.org.uk> <200806031416.18195.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Nick Piggin wrote:
> On Monday 02 June 2008 17:24, Russell King wrote:
>> So, can the semantics of what's expected from these IO accessor
>> functions be documented somewhere.  Please?  Before this thread gets
>> lost in the depths of time?
>
> This whole thread also ties in with my posts about mmiowb (which IMO
> should go away).
>
> readl/writel:  strongly ordered wrt one another and other stores
>               to cacheable RAM, byteswapping
> __readl/__writel:  not ordered (needs mb/rmb/wmb to order with
>                   other readl/writel and cacheable operations, or
>                   io_*mb to order with one another)
> raw_readl/raw_writel:  strongly ordered, no byteswapping
> __raw_readl/__raw_writel:  not ordered, no byteswapping

Byte-swapping vs not byte-swapping is not usually what the programmer wants. 
Usually your device's registers are defined as being big-endian or
little-endian and you want whatever is needed to give you that.

I believe that on some archs that can be either byte order, some built-in
devices will change their registers to match, and so you want "native endian"
or no swapping for these.  Though that's definitely in the minority.

An accessors that always byte-swaps regardless of the endianness of the host
is never something I've seen a driver want.

IOW, there are four ways one can defined endianness/swapping:
1) Little-endian
2) Big-endian
3) Native-endian aka non-byte-swapping
4) Foreign-endian aka byte-swapping

1 and 2 are by far the most used.  Some code wants 3.  No one wants 4.  Yet
our API is providing 3 & 4, the two which are the least useful.

Is it enough to provide only "all or none" for ordering strictness?  For
instance on powerpc, one can get a speedup by dropping strict ordering for IO
vs cacheable memory, but still keeping ordering for IO vs IO and IO vs locks. 
This is much easier to program for than no ordering at all.  In fact, if one
doesn't use coherent DMA, it's basically the same as fully strict ordering.
