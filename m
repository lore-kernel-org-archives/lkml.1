Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYE0QiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYE0QiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYE0Qhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:37:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51684 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349AbYE0Qhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:37:54 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: benh@kernel.crashing.org, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <adaprr721c6.fsf@cisco.com>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
	 <adaprr721c6.fsf@cisco.com>
Content-Type: text/plain
Date: Tue, 27 May 2008 11:37:48 -0500
Message-Id: <1211906268.3435.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 08:50 -0700, Roland Dreier wrote:
> > Though it's my understanding that at least ia64 does require the
>  > explicit barriers anyway, so we are still in a dodgy situation here
>  > where it's not clear what drivers should do and we end up with
>  > possibly excessive barriers on powerpc where I end up with both
>  > the wmb/rmb/mb that were added for ia64 -and- the ones I have in
>  > readl/writel to make them look synchronous... Not nice.
> 
> ia64 is a disaster with a slightly different ordering problem -- the
> mmiowb() issue.  I know Ben knows far too much about this, but for big
> SGI boxes, you sometimes need mmiowb() to avoid problems with driver
> code that does totally sane stuff like
> 
> 	spin_lock(&mmio_lock);
> 	writel(val1, reg1);
> 	writel(val2, reg2);
> 	spin_unlock(&mmio_lock);
> 
> If that snippet is called on two CPUs at the same time, then the device
> might see a sequence like
> 
> 	CPU1 -- write reg1
> 	CPU2 -- write reg1
> 	CPU1 -- write reg2
> 	CPU2 -- write reg2
> 
> in spite of the fact that everything is totally ordered on the CPUs by
> the spin lock.
> 
> The reason this is such a disaster is because the code looks right,
> makes sense, and works fine on 99.99% of all systems out there.  So I
> would bet that 99% of our drivers have missing mmiowb() "bugs" -- no one
> has plugged the hardware into an Altix box and cared enough to stress
> test it.
> 
> However for the issue at hand, my expectation as a driver writer is that
> readl()/writel() are ordered with respect to MMIO operations, but not
> necessarily with respect to normal writes to coherent CPU memory.  And
> I've included explicit wmb()s in code I've written like
> drivers/infiniband/hw/mthca.

Actually, this specifically should not be.  The need for mmiowb on altix
is because it explicitly violates some of the PCI rules that would
otherwise impede performance.   The compromise is that readX on altix
contains the needed dma flush but there's a variant operator,
readX_relaxed that doesn't (for drivers that know what they're doing).
The altix critical drivers have all been converted to use the relaxed
form for performance, and the unconverted ones should all operate just
fine (albeit potentially more slowly).

You can see all of this in include/asm-ia64/sn/io.h

It is confusing to me that sn_dma_flush() and sn_mmiowb() have different
implementations, but I think both fix the spinlock problem you allude to
by ensuring the DMA operation is completed before the CPU instruction is
executed.

James


