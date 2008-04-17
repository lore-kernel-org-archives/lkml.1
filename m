Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbYDQKEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbYDQKEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934288AbYDQJiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:38:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49361 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934613AbYDQJiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:38:03 -0400
Date: Thu, 17 Apr 2008 12:37:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: [2.6 patch] ARM: always select HAVE_IDE
Message-ID: <20080417093753.GF1677@cs181133002.pp.htv.fi>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080415221002.GL1677@cs181133002.pp.htv.fi> <20080415223928.GH5676@flint.arm.linux.org.uk> <200804160126.11116.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804160126.11116.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 01:26:10AM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 16 April 2008, Russell King wrote:
> > On Wed, Apr 16, 2008 at 01:10:02AM +0300, Adrian Bunk wrote:
> > > On Tue, Apr 15, 2008 at 11:03:45PM +0100, Russell King wrote:
> > > > On Wed, Apr 16, 2008 at 12:52:23AM +0300, Adrian Bunk wrote:
> > > >...
> > > > So this is a only impacting ARM wrt. PCMCIA, and given that ARM supplies
> > > > an asm/ide.h, it's _entirely_ reasonable that if a platform has PCMCIA
> > > > then it supports IDE.
> > > > 
> > > > > We could simply always select HAVE_IDE on arm instead of manually 
> > > > > setting which platforms could possibly get IDE support (e.g. are there
> > > > > any boards with PCI slots for which HAVE_IDE is currently not 
> > > > > selected?).
> > > > 
> > > > You could, if there was a demand for it.  As no one has added that,
> > > > I conclude that its less common for people to stick an IDE controller
> > > > into a PCI backplane.
> > > 
> > > People can always enable code for stuff they don't use.
> > > 
> > > But instead of having 14 ARM platforms plus PCMCIA (which is offered 
> > > unconditionally on all ARM platforms...) select HAVE_IDE it's simpler
> > > to select it once for all ARM platforms.
> 
> Please send me a patch doing this, it should be safe for current IDE tree.
> 
> > That would seem logical, but Bart objects to that idea.
> 
> I don't remember the background but I think it was needed because of badly
> perplexed ide_init_hwif_ports() and friends in <asm/ide.h> vs <linux/ide.h>
> (almost all this stuff is gone in IDE tree for 2.6.26)...
> 
> Ok, I found the patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=4b3b8ee5db374b76608537e061f2efd90e21179d
> 
> [ tglx's history tree since it is from May 2004. ]
> 
> > However, consider that we're gradually transitioning over to being
> > exclusively libata only.
> > 
> > > > In fact, there are only three classes of ARM platforms which have PCI
> > > > selected but not HAVE_IDE - IOP13xx, IXP2000, and Orion.  I suspect
> > > > the only reason they don't select it because they now use the ATA code
> > > > rather than the old IDE code - that's certainly true of Orion.
> > > 
> > > The libata options are offered unconditionally on all platforms...
> > 
> > It wasn't *my* choice to restrict IDE on ARM.  See Bart for that
> > decision.
> 
> It could be that I did the poor job of explaining things back then
> but I also didn't like the fact that I needed to restrict the IDE
> choice on ARM - the change in question was _necessary_ to start
> converting IDE drivers to become real, independent, modular host
> drivers and as a preparation for adding proper warm-plug support.

Any objections against the patch below?

> Thanks,
> Bart

cu
Adrian


<--  snip  -->


It's plain wrong for PCMCIA to select HAVE_IDE that implies e.g. the
availability of an asm/ide.h

It turns out this was done for ARM, and we can simply always select 
HAVE_IDE on ARM instead of manually tracking which platforms might 
possible have an IDE controller directly or indirectly.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/arm/Kconfig       |   15 +--------------
 drivers/pcmcia/Kconfig |    1 -
 2 files changed, 1 insertion(+), 15 deletions(-)

40d8b054ee277ee1d66e4379621e26d18926ed9d diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4039a13..6808136 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux Kernel Configuration"
 config ARM
 	bool
 	default y
+	select HAVE_IDE
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	select HAVE_OPROFILE
@@ -223,7 +224,6 @@ config ARCH_CLPS7500
 	select TIMER_ACORN
 	select ISA
 	select NO_IOPORT
-	select HAVE_IDE
 	help
 	  Support for the Cirrus Logic PS7500FE system-on-a-chip.
 
@@ -236,7 +236,6 @@ config ARCH_CO285
 	bool "Co-EBSA285"
 	select FOOTBRIDGE
 	select FOOTBRIDGE_ADDIN
-	select HAVE_IDE
 	help
 	  Support for Intel's EBSA285 companion chip.
 
@@ -261,7 +260,6 @@ config ARCH_EP93XX
 config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select FOOTBRIDGE
-	select HAVE_IDE
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@ -300,7 +298,6 @@ config ARCH_IOP32X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
-	select HAVE_IDE
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -310,14 +307,12 @@ config ARCH_IOP33X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
-	select HAVE_IDE
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
 config ARCH_IXP23XX
  	bool "IXP23XX-based"
 	depends on MMU
-	select HAVE_IDE
  	select PCI
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
@@ -335,14 +330,12 @@ config ARCH_IXP4XX
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
-	select HAVE_IDE
 	help
 	  Support for Intel's IXP4XX (XScale) family of processors.
 
 config ARCH_L7200
 	bool "LinkUp-L7200"
 	select FIQ
-	select HAVE_IDE
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -397,7 +390,6 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
-	select HAVE_IDE
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -413,7 +405,6 @@ config ARCH_RPC
 	select ARCH_MAY_HAVE_PC_FDC
 	select ISA_DMA_API
 	select NO_IOPORT
-	select HAVE_IDE
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -425,14 +416,12 @@ config ARCH_SA1100
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
 	select GENERIC_TIME
-	select HAVE_IDE
 	help
 	  Support for StrongARM 11x0 based boards.
 
 config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
 	select GENERIC_GPIO
-	select HAVE_IDE
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -440,7 +429,6 @@ config ARCH_S3C2410
 
 config ARCH_SHARK
 	bool "Shark"
-	select HAVE_IDE
 	select ISA
 	select ISA_DMA
 	select PCI
@@ -450,7 +438,6 @@ config ARCH_SHARK
 
 config ARCH_LH7A40X
 	bool "Sharp LH7A40X"
-	select HAVE_IDE
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 8b22281..519b4ff 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -38,7 +38,6 @@ config PCMCIA_DEBUG
 config PCMCIA
 	tristate "16-bit PCMCIA support"
 	select CRC32
-	select HAVE_IDE
 	default y
 	---help---
 	   This option enables support for 16-bit PCMCIA cards. Most older

