Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbYCYXfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbYCYXfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYCYXfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:35:14 -0400
Received: from ozlabs.org ([203.10.76.45]:34653 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYCYXfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:35:13 -0400
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
References: <200803220259.48534.rjw@sisk.pl>
	 <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de>
	 <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de>
	 <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 10:33:25 +1100
Message-Id: <1206488005.10573.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-22 at 14:33 -0700, Linus Torvalds wrote:
> 
> On Sat, 22 Mar 2008, Stefan Richter wrote:
> > 
> > Can an MMIO region reside above 0x1'0000'0000 on x86-32? ... Apparently yes,
> > if CONFIG_RESOURCES_64BIT=y.
> 
> Hmm. It would only work if PAE (HIGHMEM64G) is enabled too.
> 
> And obviously the hardware has to have working 64-bit BAR's.

On other platforms however, you can have mmio above 32 bits without
support for 64 bits BARs: the entire PCI bus mmio region can be mapped
up there.

That happens for example with 4xx embedded PowerPC. We deal with it just
fine, provided that nothing tries to stick a resource value into an
unsigned long but uses resource_size_t instead. Unfortunately, it's a
common bug, I've fixing drivers regulary.

It also appears that the iomap code on various archs is buggy too,
including the generic lib/iomap.c, thus pci_iomap is broken for archs
that can have 64 bits resources and use the version in lib/.

The good news is that I have done a patch to fix it, which has been
in -mm for about a month: iomap-fix-64-bits-resources-on-32-bits.patch

Cheers,
Ben.


