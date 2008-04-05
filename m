Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbYDEBPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbYDEBPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYDEBLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:20 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15451 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYDEBLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R6q+xRcuyg1ID4NyMDnkfPUiulMlp5R7h6Mw/JeCTbDNQfwNsDWsAMCHRVH3ShRYdtQcWZXUR6e/LrR1OaTwQZArak2svkV8sgzAlVhrscIK4/7y6CrdjlBsPZ41WsCs9uZeNGLTKTD6f9cypNkCoVGd3w13wSc4/wE8xiMWPWA=
Subject: Re: [PATCH]  jffs2 summary allocation
From: Josh Boyer <jwboyer@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Trimarchi <trimarchimichael@yahoo.it>, dwmw2@infradead.org,
       spi-devel-general@lists.sourceforge.net, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200804041658.38499.david-b@pacbell.net>
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com>
	 <200804041609.41092.david-b@pacbell.net>
	 <1207351282.3224.79.camel@vader.jdub.homelinux.org>
	 <200804041658.38499.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 20:11:10 -0500
Message-Id: <1207357870.3224.89.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 16:58 -0700, David Brownell wrote:
> On Friday 04 April 2008, Josh Boyer wrote:
> > 
> > >   ... This means specifically that you may _not_ use the
> > >   memory/addresses returned from vmalloc() for DMA.  ...
> > > 
> > > So I'm rather surprised to see *ANY* kernel code trying to do
> > > that.  That rule has been in effect for many, many years now.
> > 
> > I don't think it was intentional.  You're going through several layers
> > here:
> > 
> > JFFS2 -> mtd parts -> mtd dataflash -> atmel_spi.
> > 
> > Typically MTD drivers aren't doing DMAs to flash and JFFS2 has no idea
> > which particular chip driver is being used because it's abstracted by
> > MTD.
> 
> That's true ... although I can imagine using DMA to
> avoid dcache trashing if its setup cost is low enough,
> with either NAND or NOR chips.
> 
> Still:  in this context vmalloc() is wrong.

Agreed.  One issue is that the summary code allocates a buffer that
equals the eraseblock size of the underlying MTD device.  For larger
NAND chips, that may be up to 256KiB.  I believe this is within the
allowable kmalloc size for most architectures these days, but the
summary code is 3 years old and was likely expecting a smaller limit.
And there is always the question on whether finding that much contiguous
memory will be an issue.

I don't see much harm with the actual patch itself, assuming larger
kmallocs work as I think they should.  It does make me wonder if we have
other cases of vmalloc'd buffers being passed to lower drivers using DMA
though.

josh

