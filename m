Return-Path: <linux-kernel-owner+w=401wt.eu-S965775AbXCHIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965775AbXCHIIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965776AbXCHIIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:08:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:46078 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965775AbXCHIIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:08:52 -0500
Subject: Re: Linux v2.6.21-rc3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703070735240.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <1173263132.9349.47.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703070735240.5963@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 09:08:43 +0100
Message-Id: <1173341323.8635.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 07:39 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Mar 2007, Benjamin Herrenschmidt wrote:
> >
> > On Tue, 2007-03-06 at 20:59 -0800, Linus Torvalds wrote:
> > 
> > > Linus Torvalds (2):
> > >       Revert "[PATCH] LOG2: Alter get_order() so that it can make use of ilog2() on a constant"
> > >       Linux 2.6.21-rc3
> > 
> > Greg, I think we should revert that patch in 2.6.20.x stable serie too
> > as get_order is broken there as well, causing random kernel memory
> > corruption every now and then among others.
> 
> Did you confirm that that was indeed the cause of the problem you saw?

Well, at least one of the problem I caught with my ppc32 implementation
of DEBUG_PAGEALLOC yes. PowerPC dma_alloc_coherent, on machines with
cache consistent PCI DMA, would use get_order to allocate pages and then
memset over the size passed in. The ide-pmac driver, among others, would
trigger that bug by asking for 0x1020 bytes while get_order only
returned 0. (I should look into making the ide-pmac driver allocate <=
4K but that's a different matter).
 
I think it fixed David Woodhouse random crashes too.

> As far as I can tell, the bug (because it tested the wrong #define) would 
> only affect the constant-size case, and only for something larger than a 
> single page, and only for a non-power-of-two size. So it looked fairly 
> hard to trigger, if only because all the obvious constants I saw seemed 
> to already be powers-of-two..
> 
> So did you hunt it down to a particular cases where it triggers?

Yup, the above. Calls to dma_alloc_consistent with a constant size that
is not a multiple of the page size and larger than one page. (Our
dma_alloc_consistent implementation on 32 bits is inline).

Ben.

