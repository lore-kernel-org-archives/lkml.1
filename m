Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYCZKPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYCZKPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYCZKOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:14:54 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:39170 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbYCZKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:14:53 -0400
Date: Wed, 26 Mar 2008 13:14:50 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, Ingo Molnar <mingo@elte.hu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gary Hade <garyhade@us.ibm.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
Message-ID: <20080326101450.GA9060@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 02:47:35PM -0700, Linus Torvalds wrote:
> On Tue, 25 Mar 2008, Thomas Meyer wrote:
> > 
> > and compare lspci -vv from 2.6.25 and 2.6.24:
> > 
> > 2.6.25:
> >
> >    Region 0: [virtual] Memory at 100000000 (32-bit, non-prefetchable) [size=4K]
> > 
> > 2.6.24:
> >
> >    Region 0: Memory at 8c000000 (32-bit, non-prefetchable) [size=4K]
> 
> Ok, so it didn't use to be at the 4GB mark.

Note that 'Memory at 100000000' is totally bogus as this is 32-bit BAR
and respective PCI bridge is 32-bit either.

Most interesting thing is that under 2.6.24 Tomas had

PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 8c000000-8c0fffff
  PREFETCH window: disabled.

but with 2.6.25

PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0x00000000-0x000fffff
  PREFETCH window: disabled.

I'm sure that MEM window was actually 0x100000000-0x1000fffff as that
printk shows only 8 hex digits.

> This seems to be a PCI and resource alloc issue. It would be really 
> interesting to see where the 4GB allocation started. Ie ignore anything 
> else (warnings, driver loadings etc), and _just_ look at lspci -vv output 
> for where the memory got allocated.

Yeah, it's resource issue for sure. The 00:1e.0 is a transparent bridge,
so I blame commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f
(PCI: remove transparent bridge sizing). It's wrong for two reasons:
- we cannot ignore standard windows of a transparent bridge as they
  always positive decode, so they are potential source of address conflicts;
- that patch just broke whole bridge setup logic in unpredictable way.

What confused me a lot initially is that the patch was already there
in 2.6.24. But I think that issue was somehow masked by 'unsigned
longs' used in setup-bus.c all over the place instead of resource_size_t,
which has been fixed by Ben in 2.6.25...
I think that's why Thomas has everything working again without
CONFIG_RESOURCES_64BIT.

Thomas, can you put CONFIG_RESOURCES_64BIT=y back and either
revert commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f, or
just comment out these two lines in drivers/pci/setup-bus.c:

		if (bus->self->transparent)
			break;

and check if it helps?

Ivan.
