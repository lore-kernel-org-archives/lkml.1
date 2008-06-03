Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYFCGyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYFCGyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYFCGyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:54:12 -0400
Received: from ozlabs.org ([203.10.76.45]:44667 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYFCGyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:54:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18500.60032.989380.864674@cargo.ozlabs.ibm.com>
Date: Tue, 3 Jun 2008 16:53:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: benh@kernel.crashing.org, Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <200806031611.13817.nickpiggin@yahoo.com.au>
References: <1211852026.3286.36.camel@pasglop>
	<200806031416.18195.nickpiggin@yahoo.com.au>
	<1212467551.9496.23.camel@pasglop>
	<200806031611.13817.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:

> So your readl can pass an earlier cacheable store or earlier writel?

No.  It's quite gross at the moment, it has a sync before the access
(i.e. a full mb()) and a twi; isync sequence after the access that
stalls execution until the data comes back.

> > We don't provide meaningless ones like writel + cacheable store for
> > example. (PCI posting would defeat it anyway).
> 
> What do you mean by meaningless? Ordering of writel followed by a
> cacheable store  is meaningful eg. for retaining io operations within
> locks. OK, you explicitly have some extra code for spin_unlock, but
> not for bit locks, mutexes, etc. It would make sense to have the
> default operations _very_ strongly ordered IMO, and then move drivers
> to be more relaxed when they are verified.

It's meaningless in the sense that nothing guarantees that the writel
has actually hit the device, even if we put a full mb() barrier in
between the writel and the cacheable write.  That would guarantee that
the writel had got to the PCI host bridge, and couldn't be reordered
with other accesses to the device, but not that the device had
actually seen it.

I don't mind adding code to the mutex unlock to do the same as
spin_unlock, but I really don't want to have *two* sync instructions
for every MMIO write.  One is bad enough.

Paul.
