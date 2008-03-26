Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYCZWdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYCZWdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYCZWdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:33:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbYCZWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:33:06 -0400
Date: Wed, 26 Mar 2008 15:31:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <1206568675.6926.7.camel@pasglop>
Message-ID: <alpine.LFD.1.00.0803261524560.2775@woody.linux-foundation.org>
References: <20080325201125.GD15330@elte.hu>  <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de>  <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>  <20080326101450.GA9060@jurassic.park.msu.ru>  <20080326135458.GA27621@elte.hu>
 <20080326180701.GA6249@us.ibm.com>  <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>  <20080326203012.GB6249@us.ibm.com>  <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>  <20080326205828.GA15225@jurassic.park.msu.ru> 
 <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <1206568675.6926.7.camel@pasglop>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2008, Benjamin Herrenschmidt wrote:
> 
> > NOTE! This will also consider a bridge resource at 0 to be an invalid 
> > resource (since now the alignment will be zero), which is a bit odd and 
> > makes me worry a bit. I wouldn't be surprised if some non-PC architectures 
> > have PCI bridges at zero. But maybe they should be (or already are?) 
> > marked IORESOURCE_PCI_FIXED?
> 
> PCI bridges at zero is perfectly valid indeed and I'm sure we have that
> around at least for IO space. In fact, I'm surprised you don't have that
> on x86.

x86 has memory there, always has had, probably always will.

Also, the reason I *think* this issue is ok is that I think the only PCI 
bus resources we can see in the whole pdev_sort_resources() mess is the 
ones that are behind the bus that we're not sizing for, and they've been 
set up by pbus_size_mem().

And pbus_size_mem() has this special magic setup where it calculates the 
size and the alignment of the bus resource, and then makes

	r->start = alignment;
	r->end = r->start + size - 1;

so using "r->start" *should* be ok in this case because it really means 
"alignment" in this one case.

That said, I'm not going to be willing to bet my life on it.

I also wonder if we maybe should just add a separate "alignment" field to 
the resources. Rather than playing games like these (and having to compare 
the resource number to decide whether it is a bus resource or a normal PCI 
device resource), just adding the dang field would be a whole lot saner.

I dunno. I'm not going to do anything in this area before 2.6.25 is out 
because this *does* make me a bit nervous, but if somebody wants to think 
about this and perhaps write patches for testing, that would be good.

And once more: Ivan, can you again double-check my blatherings above?

			Linus
