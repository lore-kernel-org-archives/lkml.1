Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYC0RVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYC0RVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbYC0RVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:21:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180AbYC0RVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:21:02 -0400
Date: Thu, 27 Mar 2008 10:12:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803271004380.2775@woody.linux-foundation.org>
References: <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
 <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <20080326232922.GA15784@jurassic.park.msu.ru>
 <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Mar 2008, Linus Torvalds wrote:
> On Thu, 27 Mar 2008, Ivan Kokshaysky wrote:
> > 
> > If the new "align" field (and then, maybe, "size" instead of "end"?)
> > is OK, then I'm definitely willing to give it a try.
> 
> Adding an alignment field should be a non-issue: the size of this 
> structure is not likely to be a big deal (yeah, we have something like 12 
> of them in each PCI device etc, so smaller is better, but it's still not 
> going to be something anybody really notices).

Actually, before we go any further, there might be a less intrusive 
alternative: add just a couple of flags to the resource flags field (we 
still have something like 8 unused bits on 32-bit), and use those to 
implement a generic "resource_alignment()" routine.

Two flags would do it:

 - IORESOURCE_SIZEALIGN: size indicates alignment (regular PCI device 
   resources)

 - IORESOURCE_STARTALIGN: start field is alignment (PCI bus resources 
   during probing)

and then the case of both flags zero (or both bits set) would actually be 
"invalid", and we would also clear the IORESOURCE_STARTALIGN flag when we 
actually allocate the resource (so that we don't use the "start" field as 
alignment incorrectly when it no longer indicates alignment).

That wouldn't be totally generic, but it would have the nice property of 
automatically at least add sanity checking for that whole "res->start has 
the odd meaning of 'alignment' during probing" and remove the need for a 
new field, and it would allow us to have a generic "resource_alignment()" 
routine that just gets a resource pointer.

			Linus
