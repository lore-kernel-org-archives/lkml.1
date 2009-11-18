Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZKRRFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZKRRFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZKRRFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:05:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38388 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749AbZKRRFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:05:08 -0500
Date: Wed, 18 Nov 2009 17:05:10 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] powerpc: Fix minor build issues on 2.6.32-rc7
	without CONFIG_XICS set
Message-ID: <20091118170510.GA1119@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie> <1258524332.2140.663.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1258524332.2140.663.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 05:05:32PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> > KConfig doesn't require CONFIG_XICS to be set with CONFIG_PSERIES but if
> > it's not set, there are numerous small build errors. This is a small series
> > of patches to allow CONFIG_XICS to be unset in the config.
> > 
> > XICS appears to be some sort of interrupt controller but I'm not sure how
> > common it is on systems that require CONFIG_PSERIES. If CONFIG_PSERIES
> > universally requires CONFIG_XICS, the better path might be to force it to
> > be set.
> > 
> > Testing was building with make oldconfig a configuration from 2.6.31 on
> > a PPC970.
> 
> CONFIG_XICS should be made invisible and selected by PSERIES.
> 

Like so?

==== CUT HERE ====

powerpc: Add Kconfig dependency on PCI_MSI for XICS and select for PSERIES

It's possible to set CONFIG_XICS without CONFIG_PCI_MSI. When that
happens, the kernel fails to build with

arch/powerpc/platforms/built-in.o: In function `.xics_startup':
xics.c:(.text+0x12f60): undefined reference to `.unmask_msi_irq'
make: *** [.tmp_vmlinux1] Error 1

Furthermore, as noted by Benjamin Herrenschmidt, "CONFIG_XICS should be
made invisible and selected by PSERIES."

This patch adds the dependency in KConfig for XICS on PCI_MSI. When
PSERIES support is being configured, both options are silently selected.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 arch/powerpc/platforms/Kconfig         |    4 ++--
 arch/powerpc/platforms/pseries/Kconfig |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 04a8061..a82c470 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -52,9 +52,9 @@ config PPC_UDBG_BEAT
 	default n
 
 config XICS
-	depends on PPC_PSERIES
+	depends on PCI_MSI
 	bool
-	default y
+	default n
 
 config IPIC
 	bool
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index f0e6f28..81c2289 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -5,6 +5,8 @@ config PPC_PSERIES
 	select PPC_I8259
 	select PPC_RTAS
 	select RTAS_ERROR_LOGGING
+	select PCI_MSI
+	select XICS
 	select PPC_UDBG_16550
 	select PPC_NATIVE
 	select PPC_PCI_CHOICE if EMBEDDED
