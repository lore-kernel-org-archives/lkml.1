Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZK0Qd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZK0Qd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 11:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZK0Qd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 11:33:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52003 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZK0Qd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 11:33:56 -0500
Date: Fri, 27 Nov 2009 16:33:58 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Add Kconfig dependency on PCI_MSI for XICS and
	select for PSERIES
Message-ID: <20091127163358.GP13095@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie> <1258524332.2140.663.camel@pasglop> <20091118170510.GA1119@csn.ul.ie> <1259289626.2076.1.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1259289626.2076.1.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 01:40:26PM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-11-18 at 17:05 +0000, Mel Gorman wrote:
> 
> > 
> > diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
> > index 04a8061..a82c470 100644
> > --- a/arch/powerpc/platforms/Kconfig
> > +++ b/arch/powerpc/platforms/Kconfig
> > @@ -52,9 +52,9 @@ config PPC_UDBG_BEAT
> >  	default n
> >  
> >  config XICS
> > -	depends on PPC_PSERIES
> > +	depends on PCI_MSI
> >  	bool
> > -	default y
> > +	default n
> 
> Why the above ? XICS only exist on PSERIES and select bypass depends in
> nasty ways anyways.
> 

You're right. When I made that change, I assumed that a "select foo"
would also resolve the dependencies. It doesn't but I failed to back
this out as being unnecessary.

> >  config IPIC
> >  	bool
> > diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
> > index f0e6f28..81c2289 100644
> > --- a/arch/powerpc/platforms/pseries/Kconfig
> > +++ b/arch/powerpc/platforms/pseries/Kconfig
> > @@ -5,6 +5,8 @@ config PPC_PSERIES
> >  	select PPC_I8259
> >  	select PPC_RTAS
> >  	select RTAS_ERROR_LOGGING
> > +	select PCI_MSI
> > +	select XICS
> >  	select PPC_UDBG_16550
> >  	select PPC_NATIVE
> >  	select PPC_PCI_CHOICE if EMBEDDED
> 
> The above bits look plenty enough. Can you also stick it next to the
> MPIC one ?
> 

They are. I can.

==== CUT HERE ====
powerpc: Add Kconfig dependency on PCI_MSI for XICS and select for PSERIES

It's possible to set CONFIG_XICS without CONFIG_PCI_MSI. When that happens,
the kernel fails to build with

arch/powerpc/platforms/built-in.o: In function `.xics_startup':
xics.c:(.text+0x12f60): undefined reference to `.unmask_msi_irq' make: ***
[.tmp_vmlinux1] Error 1

Furthermore, as noted by Benjamin Herrenschmidt, "CONFIG_XICS should be
made invisible and selected by PSERIES."

This patch adds the dependency in KConfig for XICS on PCI_MSI. When PSERIES
support is being configured, both options are silently selected.

Signed-off-by: Mel Gorman <mel[at]csn.ul.ie>
---
 arch/powerpc/platforms/pseries/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index f0e6f28..60d53ed 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -2,6 +2,8 @@ config PPC_PSERIES
 	depends on PPC64 && PPC_BOOK3S
 	bool "IBM pSeries & new (POWER5-based) iSeries"
 	select MPIC
+	select PCI_MSI
+	select XICS
 	select PPC_I8259
 	select PPC_RTAS
 	select RTAS_ERROR_LOGGING
