Return-Path: <linux-kernel-owner+w=401wt.eu-S1030711AbXAZEA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030711AbXAZEA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030724AbXAZEA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:00:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030711AbXAZEA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:00:27 -0500
Date: Thu, 25 Jan 2007 20:00:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <1169782107.3593.219.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0701251932250.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain> 
 <1169741658.3593.98.camel@shinybook.infradead.org> 
 <20070125172739.0c990a9a@localhost.localdomain> 
 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> 
 <1169770985.3593.146.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org> 
 <1169778239.3593.195.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
 <1169782107.3593.219.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Jan 2007, David Woodhouse wrote:
> 
> It's not just "my laptop", I believe. It's the generic resource code,
> which is happy to assign address zero since it's never been taught that
> zero is now a special case. If we're not going to ask for the bug I
> observed to be fixed -- if we're going to declare that driver authors
> don't have to sober up and clean up their code -- then the resource code
> should be modified accordingly.

The resource code really is totally agnostic, and you're barking up the 
wrong tree there. In many ways, the resource code isn't even about "IO 
resources", it could do other things too.

[ In practice, of course, IO resources is all it does and what it was 
  designed for, since there really aren't a lot of hierarchical things 
  that need to be able to nest and handle byte-range-like things. ]

It's really up to the architecture-specific PCI initialization what the 
PCI resources look like. The resource code just takes whatever resource 
layout it is given. Yes, there's a "root" ioport_resource, but that's just 
the container for the whole PCI resource tree, and generally you'd show 
the different PCI domains exposed with their buses in that tree.

Of course, for all the historical reasons (a single domain, and it was 
written for a PC), on PC's, the root PCI bus just points directly to the 
root io port resource. But the way things work is that you cardbus card 
doesn't just allocate space from that "ioport_resource" itself. No, it 
allocates space from the cardbus controller resources, which in turn have 
allocated space from the PCI bridge controller resources, etc etc all the 
way up to whatever is the PCI root resource.

There *are* drivers that use the "ioport_resource" directly, but they are 
system devices (where "ISA" counts as a system device - augh: it's not 
enumerable or discoverable) which know where they go. But a normal driver 
never does in any modern world.

So the way to make sure that PCI devices get allocated in the proper area 
is not to change the resource manager, but to make sure that the 
architecture initializes the root bridges for all the domains properly.

(A lot of them do the "PC thing", of course: they just make the ioport 
resource the direct parent of the root bridge, and that's ok if the root 
really _is_ supposed to cover everything from zero. On a PC, that's 
actually the right thing to do, because the system devices will insert 
themselves into the low area, and then PCIBIOS_MIN_IO - 0x1000 on a PC - 
is used as the minimum for any *dynamic* allocation.)

PCI PIO/IOMEM resource allocation is actually fairly complicated, and most 
people really *really* never need to care. It should be considered a sign 
of how well the resource code works that it all usually works without most 
people ever really needing to understand it.

			Linus
