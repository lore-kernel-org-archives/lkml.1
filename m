Return-Path: <linux-kernel-owner+w=401wt.eu-S1764173AbYCFAyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764173AbYCFAyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbYCFAy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:54:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:40144 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104AbYCFAy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:54:28 -0500
Subject: Re: [BUG] 2.6.25-rc3-mm1 kernel panic while bootup on powerpc ()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikey@neuling.org, kamalesh@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, willy@debian.org
In-Reply-To: <20080305164438.fff7bb7c.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	 <47CD4AB3.3080409@linux.vnet.ibm.com> <20778.1204641656@neuling.org>
	 <20080304103350.12d26560.akpm@linux-foundation.org>
	 <1204761811.21545.238.camel@pasglop>
	 <20080305164438.fff7bb7c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 11:52:42 +1100
Message-Id: <1204764762.21545.243.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-05 at 16:44 -0800, Andrew Morton wrote:
> On Thu, 06 Mar 2008 11:03:31 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > 
> > > Yes, we are - it's the semaphore rewrite which is doing this in
> > > start_kernel().  It's being discussed.
> > > 
> > > Enabling interrupts too early on powerpc was discovered to be fatal on
> > > powerpc years ago.  It looks like that remains the case.
> > 
> > Regarding these issues. I could make it non fatal and just WARN_ON,
> > provided that I have a way to differentiate legal vs. illegal calls
> > to local_irq_enable().
> 
> And local_irq_restore() and various other things.

Yes, on powerpc 64 bits, they all go down to one C function that does
the lazy enable/disable, so it would be easy to deal with. 32 bits
doesn't have it that simple tho.

> I'd have thought that the way to do this would be to add it to lockdep -
> lockdep already has all the infrastructure and code sites to do this.
> 
> Set some special flag saying its-ok-to-enable-interrupts-now and test that
> in lockdep.

Ok.

> akpm:/usr/src/25> grep LOCKDEP arch/powerpc/Kconfig 
> akpm:/usr/src/25> 
> 
> losers ;)

I have lockdep patches for powerpc 32 and 64 bits. They aren't upstream
yet as they need a bit more beating up and there's at least one machine
that doesn't seem to like them, so I'm working on just that. That's a
good idea to add the test to lockdep tho, I'll see what I can do.

> Still, doing it for
> 
> akpm:/usr/src/25> grep -l LOCKDEP arch/*/Kconfig 
> arch/arm/Kconfig
> arch/avr32/Kconfig
> arch/mips/Kconfig
> arch/s390/Kconfig
> arch/sh/Kconfig
> arch/sparc64/Kconfig
> arch/um/Kconfig
> arch/x86/Kconfig
> 
> should give pretty good coverage.

Ben.


