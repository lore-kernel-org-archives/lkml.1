Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbZATWws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbZATWws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZATWwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:52:38 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:46334 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbZATWwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:52:38 -0500
X-Trace: 130405508/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.170/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.170
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.2 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAKXOdUlQLLCq/2dsb2JhbACBbMg0hXM
X-IronPort-AV: E=Sophos;i="4.37,296,1231113600"; 
   d="scan'208";a="130405508"
Subject: Re: Bug: Latest (rc2 and beyond) kernel fails on Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <8b67d60901201240u37341a72oa33159a28f4db674@mail.gmail.com>
References: <8b67d60901181626l43a8728fh6f2a2ab146b45d90@mail.gmail.com>
	 <8b67d60901191433u51d062bgffa523c7da811cb8@mail.gmail.com>
	 <20090120004830.GA12965@linux-sh.org>
	 <8b67d60901201240u37341a72oa33159a28f4db674@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 21:20:21 +0000
Message-Id: <1232486421.6794.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 20:40 +0000, Adrian McMenamin wrote:
> 2009/1/20 Paul Mundt <lethal@linux-sh.org>:
> > On Mon, Jan 19, 2009 at 10:33:57PM +0000, Adrian McMenamin wrote:
> >> 2009/1/19 Adrian McMenamin <lkmladrian@gmail.com>:
> >> > I haven't had time to look at this, but the most up to date kernel
> >> > (and the one of around a week ago also) fails to boot, seemingly
> >> > seeking an IP address for the 8139too based NIC.
> >>
> >> > [    4.664236] Sending DHCP requests .<3>eth0: PCI Bus error 2200.
> >> > [    4.669582] eth0: PCI Bus error 2200.
> >>
> >> And the bisection reveals the following:
> >>
> >> adrian@bossclass:~/linux-2.6$ git bisect bad
> >> 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da is first bad commit
> >> commit 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da
> >> Author: Johannes Weiner <hannes@cmpxchg.org>
> >> Date:   Tue Jan 6 14:43:10 2009 -0800
> >>
> >>     dma-coherent: catch oversized requests to dma_alloc_from_coherent()
> >>
> 
> 
> 
> >
> > The dreamcast uses a 32kB coherent area for PCI DMA, which all of the
> > 8139too allocations should fit under just fine. What does
> > dma_alloc_from_coherent() say the requested size is, vs the per-device
> > memory size for each allocation?
> >
> 
> Hmmm...
> 
> >From printks I stuck in the code
> 
> [    3.641267] Size is 0x1800, mem->size is 0x8
> [    3.644996] Size is 0x2810, mem->size is 0x8
> 
> The sizes are correct - the first is the TX buffer, the second RX, but
> I have no idea why mem->size is set so low, I assume that is a bug
> somewhere else in the Dreamcast code. Any clues gratefully received.
> --


Actually, it looks to me that the patch was wrong.

This is from kernel/dma-coherent.c

dev->dma_mem->size = pages;

Yet this is the test applied in dma_alloc_from_coherent:

if (unlikely(size > mem->size))

Should surely be:

if (unlikely (size > (mem->size >> PAGE_SHIFT)))

Will patch that and try it




> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

