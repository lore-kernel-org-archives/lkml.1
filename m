Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYEWMhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYEWMhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYEWMhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:37:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:44252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYEWMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:37:21 -0400
Subject: MMIO and gcc re-ordering (Was: [PATCH] [POWERPC] Improve
	(in|out)_beXX() asm code)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
References: <4833524C.3040207@freescale.com>
	 <20080520.153947.84346222.davem@davemloft.net>
	 <4833542E.3040608@freescale.com>
	 <20080520.155326.195407196.davem@davemloft.net>
	 <1211516683.8297.271.camel@pasglop>
	 <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
Content-Type: text/plain
Date: Fri, 23 May 2008 08:36:37 -0400
Message-Id: <1211546197.8297.308.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > IE. Take an x86 version of that test, writing to memory, doing a writel
> > to some MMIO, then another memory write, can those be re-ordered with
> > the current x86 version of writel ?
> 
> Yes, the same thing can happen on x86.  As far as I could tell, this is
> something that all other arches can have happen.  Usually aliasing prevents
> it, but it's not hard to constuct a test case where it doesn't.

That brings us back to the old debate...

For consistent memory, should we mandate a wmb between write to some dma
data structure in consistent memory and the following mmio write that
trigger it, and the same goes with rmb and read ?

David, you remember we had those discussions a while back when I was
trying to relax a bit the barriers we have in our MMIO accessors on
powerpc, and the overwhelming answer was that x86 being in order, I have
to expect 90% of the drivers to not get any barrier right on any
platform, and thus I should make my MMIO accessors "look like" x86 and
thus ordered.

We did that, adding some barriers in the assembly of our readl/writel. 

However, I didn't change the clobber, it's still *addr, not a full
"memory" clobber, just like x86.

Now if it appears that gcc can indeed re-order things, then we have a
problem on both x86, ppc, and pretty much everybody else. (I'm not sure
about sparc but I don't see any explicit clobber in your accessors
there).

So that brings the whole subject back imho. What should be the approach
here ? I see several options:

	- mandate some kind of dma_sync_for_device/cpu on consistent memory.
Almost no driver do that currently tho. They only do that for non
consistent memory mapped with dma_map_*.

	- mandate the use of wmb,rmb,mb barriers for use between memory
accesses and MMIOs for ordering them. (ie. fix drivers that don't do
it). Advantage for powerpc is that I can remove (after some auditing of
course) the added heavy barriers in the MMIO accessors themselves.

	- stick a full memory clobber in all MMIO (and PIO) accessors on all
archs.

Any other idea ? preference ?

Cheers,
Ben.


