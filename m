Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYFCEeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYFCEeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYFCEeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:34:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:41474 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYFCEeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:34:05 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
In-Reply-To: <200806031416.18195.nickpiggin@yahoo.com.au>
References: <1211852026.3286.36.camel@pasglop>
	 <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org>
	 <20080602072403.GA20222@flint.arm.linux.org.uk>
	 <200806031416.18195.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 14:32:31 +1000
Message-Id: <1212467551.9496.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This whole thread also ties in with my posts about mmiowb (which IMO
> should go away).
> 
> readl/writel:  strongly ordered wrt one another and other stores
>                to cacheable RAM, byteswapping
> __readl/__writel:  not ordered (needs mb/rmb/wmb to order with
>                    other readl/writel and cacheable operations, or
>                    io_*mb to order with one another)
> raw_readl/raw_writel:  strongly ordered, no byteswapping
> __raw_readl/__raw_writel:  not ordered, no byteswapping
> 
> then get rid of *relaxed* variants.

In addition, some archs like powerpc also provide readl_be/writel_be as
being defined as big endian (ie. byteswap on LE archs, no byteswap on BE
archs).

As of today, powerpc lacks the raw_readl/raw_writel and __readl/__writel
variants (ie, we only provide fully ordered + byteswap and no ordering +
no byteswap variants).

If we agree on the above semantics, I'll do a patch providing the
missing ones.

> Linus: on x86, memory operations to wc and wc+ memory are not ordered
> with one another, or operations to other memory types (ie. load/load
> and store/store reordering is allowed). Also, as you know, store/load
> reordering is explicitly allowed as well, which covers all memory
> types. So perhaps it is not quite true to say readl/writel is strongly
> ordered by default even on x86. You would have to put in some
> mfence instructions in them to make it so.
> 
> So, what *exact* definition are you going to mandate for readl/writel?
> Anything less than strict ordering then we also need to ensure drivers
> use the correct barriers (to implement strict ordering, we could either
> put mfence instructions in, or explicitly disallow readl/writel to be
> used on wc/wc+ memory).

The ordering guarantees that I provide on powerpc for "ordered" variants
are:

	- cacheable store + writel stays ordered (ie, write to some
          DMA stuff and then a register to trigger the DMA).

	- readl + cacheable read stays ordered (ie. read some status
          register, for example, after an interrupt, and then read the
          resulting data in memory).

	- any of these ordered vs. spin_lock and spin_unlock (with the
          exception that stores done before the spin_lock 
          could potentially leak into the lock).

	- readl is synchronous (ie, makes the CPU think the
          data was actually used before executing subsequent
          instructions, thus waits for the data to come back,
          for example to ensure that a read used to push out
          post buffers followed by a delay will indeed happen
          with the right delay).

We don't provide meaningless ones like writel + cacheable store for
example. (PCI posting would defeat it anyway).

> The other way we can go is just say that they have x86 semantics,
> although that would be a bit sad IMO: we should have strong ops, in
> which case driver writers never need to use a single barrier provided
> they have locking right, and weak ops, in which case they should match
> up with the weak Linux memory ordering model for system RAM.

Ben.


