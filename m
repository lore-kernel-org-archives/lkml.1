Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbYBOW7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbYBOW7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764724AbYBOW4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:56:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:50837 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764777AbYBOW4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:56:14 -0500
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Tim Ellis <tim@ngndg.com>,
       linux-kernel@vger.kernel.org, jeff@garzik.org
In-Reply-To: <20080215222725.0af29563@core>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	 <1202850129.7410.22.camel@pasglop>
	 <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
	 <20080215155332.2b89c429@core> <1203111956.22915.24.camel@pasglop>
	 <20080215222725.0af29563@core>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 09:55:44 +1100
Message-Id: <1203116144.22915.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 22:27 +0000, Alan Cox wrote:
> > The dbdma start is mostly harmless (things don't get posted for -that-
> > long), though I suppose it's worth fixing. Would reading back dmactl do
> > in that case or do you foresee any kind of side effect ? (Maybe only
> > doing it for MMIO ?)
> 
> The dmactl read back should be just fine, or any other DMA register (eg
> status).
> 
> > As for SRST, I'm not totally confident how safe it is to read back
> > there while doing the reset sequence, so I'm tempted to really only
> > do it for MMIO and use altstat rather than ctl/stat (the later tends
> > to have side effects which we don't want here).
> 
> Agreed - we know some controllers crap themselves spectacularly on
> anything which causes a SATA data transfer to be needed during a reset so
> the status is probably safest. The fact its not fixed is because nobody
> has sat down to figure out what is safe.
> 
> > The main problem from here is that I don't know whether we are using
> > MMIO or PIO from libata-core. Maybe I can add a host flag indicate
> > that such flushing is needed ?
> 
> Easier to add that to the ioxxxx ops I suspect (ioispio/ioismmio say) ?

Maybe, though that will involve fixing all the arch versions which do
different things. In fact, I'm not even sure I can tell you 100% after
the fact on ppc64, I have to double check.

I'd rather stick a flag in there to be safe, also since altstatus isn't
always there (which is why I used nsect in the test patch I sent to
Guennadi). I'm pretty sure I can rely on all MMIO controllers having an
altstatus but I'd rather still make that explicit with a host flag to
avoid unintended consequences to others.

Ben.


