Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYKGXJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYKGXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYKGXJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:09:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:40599 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbYKGXJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:09:10 -0500
Subject: Re: sparc/staging compile error
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Vijay Kumar <vijaykumar@bravegnu.org>
Cc: "J.R. Mauro" <jrm8005@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Greg KH <greg@kroah.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, jayakumar.lkml@gmail.com,
       sparclinux@vger.kernel.org
In-Reply-To: <4913FEE1.9030807@bravegnu.org>
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>
	 <20081106063709.GB7728@kroah.com>
	 <18706.51153.342079.586525@cargo.ozlabs.ibm.com>
	 <3aaafc130811060606p1dfbf12cr8c0dc8cd310d0279@mail.gmail.com>
	 <20081106173224.GA25767@infradead.org>
	 <3aaafc130811060936u371e8b9eyccd0c52693f4c433@mail.gmail.com>
	 <4913FEE1.9030807@bravegnu.org>
Content-Type: text/plain
Date: Sat, 08 Nov 2008 10:06:32 +1100
Message-Id: <1226099192.13603.78.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> May be the code is not doing what is supposed to do, but here is what the 
> driver is trying to achieve:
> 
> The driver allocates a set of buffers for DMA. These buffers are mapped 
> into user space, when the user does an mmap. In transmit, when the user 
> space writes to these buffers, the data has to reach physical memory so 
> that the device can access them. For receive, the cache has to be 
> invalidated before the user space reads the buffer.
> 
> Do let me know if further clarification is required. Any inputs and 
> suggestions are welcome.

Well, this is the wrong API to do that. First, some platforms are cache
coherent and thus don't need anything there other than maybe a barrier.

Then, the dma_* API is what you want to ensure cache coherency with DMA
transfers within the kernel.

If userspace can directly trigger DMA from pre-allocated buffers, then
doing an ioctl to sync is a major wastage, since most platforms are
cache coherent (and thus don't need it) and those who are not generally
provide user-space accessible ways of doing the flush to some extent
(not all, for example, BookE PPC cannot invalidate the data cache from
userspace, only flush it).

In any case, we would need to understand better your driver userspace
API and transfer model to find the right solution.

Ben.


