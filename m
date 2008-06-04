Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYFDCGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYFDCGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYFDCGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:06:01 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:47591 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750803AbYFDCF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:05:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AacwMt5rByJZ7xlbBoiPdf8vkuq19c95Vdk13hiB1FagyzSw4rdBDWcBFb/WbKTmiiZ2Lv7nO8gvFFgl8lAU4Ha+n0nyThzO97FR5JJttoJ8RDZEwXvuciz3vx6dYZYJUARF2vrts47zFiFoGjlxQK2+k9QgLLtP81VxasaRfz8=  ;
X-YMail-OSG: BJM0gGAVM1ngaMKzuHrypH2z2guXm2kiA5U1Anw8iv3iBa.QT6piFDFJhqainJsjVaIYh0JawoQ43LvNnkpjXyxcfJqLhu8o._pLb_3kddz4lzxkfXg7vVDiKrY25OITSSc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: MMIO and gcc re-ordering issue
Date: Wed, 4 Jun 2008 12:05:45 +1000
User-Agent: KMail/1.9.5
Cc: Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp> <alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041205.45833.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 05:07, Linus Torvalds wrote:
> On Tue, 3 Jun 2008, Trent Piepho wrote:
> > On Tue, 3 Jun 2008, Linus Torvalds wrote:
> > > On Tue, 3 Jun 2008, Nick Piggin wrote:
> > > > Linus: on x86, memory operations to wc and wc+ memory are not ordered
> > > > with one another, or operations to other memory types (ie. load/load
> > > > and store/store reordering is allowed). Also, as you know, store/load
> > > > reordering is explicitly allowed as well, which covers all memory
> > > > types. So perhaps it is not quite true to say readl/writel is
> > > > strongly ordered by default even on x86. You would have to put in
> > > > some mfence instructions in them to make it so.
> >
> > So on x86, these could be re-ordered?
> >
> > writel(START_OPERATION, CONTROL_REGISTER);
> > status = readl(STATUS_REGISTER);
>
> With both registers in a WC+ area, yes. The write may be in the WC buffers
> until the WC buffers are flushed (short list: a fence, a serializing
> instruction, a read-write to uncached memory, or an interrupt. There are
> others, but those are the main ones).
>
> But if the status register is in uncached memory (which is the only *sane*
> thing to do), then it doesn't matter if the control register is in WC
> memory. Because the status register read is itself serializing with the WC
> buffer, it's actually fine.

Actually, according to the document I am looking at (the AMD one), a UC
store may pass a previous WC store.

So you could have some code that writes to some WC memory on the card,
and then stores to an UC control register to start up the operation on
that memory, couldn't you? Those can go out of order.
