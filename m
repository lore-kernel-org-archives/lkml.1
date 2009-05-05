Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZEEItn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZEEItn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZEEItd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:49:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51534 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZEEItb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:49:31 -0400
Date: Tue, 5 May 2009 09:49:28 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hartleys@visionengravers.com,
       mcrapet@gmail.com, fred99@carolina.rr.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] Double check memmap is actually valid with a memmap
	has unexpected holes
Message-ID: <20090505084928.GC25904@csn.ul.ie>
References: <20090505082944.GA25904@csn.ul.ie> <20090505083614.GA28688@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090505083614.GA28688@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 09:36:14AM +0100, Russell King - ARM Linux wrote:
> On Tue, May 05, 2009 at 09:29:44AM +0100, Mel Gorman wrote:
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index e02b893..6d79051 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -925,10 +925,9 @@ config OABI_COMPAT
> >  	  UNPREDICTABLE (in fact it can be predicted that it won't work
> >  	  at all). If in doubt say Y.
> >  
> > -config ARCH_FLATMEM_HAS_HOLES
> > +config ARCH_HAS_HOLES_MEMORYMODEL
> 
> Can we arrange for EP93xx to select this so we don't have it enabled for
> everyone.
> 
> The other user of this was RPC when it was flatmem only, but since it has
> been converted to sparsemem it's no longer an issue there.
> 

This problem is hitting SPARSEMEM, at least according to reports I have
been cc'd on so it's not a SPARSEMEM vs FLATMEM thing. From the leader --
"This was caught before for FLATMEM and hacked around but it hits again for
SPARSEMEM because the page_zone linkages can look ok where the PFN linkages
are totally screwed."

If you feel that this problem is only encountered on the EP93xx, then the
option could be made more conservative with the following (untested) patch
and then wait to see who complains.

==== CUT HERE ====

arm: Only select ARCH_HAS_HOLES_MEMORYMODEL on the EP93xx

ARM frees unused memmap to save memory but this can collide with the core
VM's view of the memory model when walking what it views to be valid PFNs in
the system. ARM selects ARCH_HAS_HOLES_MEMORYMODEL for all architectures to
double check the memmap being examined is valid but it has been asserted
that this may only be needed on EP93xx in practice. This patch selects
ARCH_HAS_HOLES_MEMORYMODEL only for that sub-architecture.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 arch/arm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 6d79051..a4c195c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -273,6 +273,7 @@ config ARCH_EP93XX
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_HAS_HOLES_MEMORYMODEL
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -927,7 +928,7 @@ config OABI_COMPAT
 
 config ARCH_HAS_HOLES_MEMORYMODEL
 	bool
-	default y
+	default n
 
 # Discontigmem is deprecated
 config ARCH_DISCONTIGMEM_ENABLE
