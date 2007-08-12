Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXHLKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXHLKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXHLKZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:25:18 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:46751 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXHLKZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:25:16 -0400
Date: Sun, 12 Aug 2007 12:24:59 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, jdike@karaya.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] Introduce CONFIG_CHECK_SIGNATURE (was: Re: uninline
 check_signature())
In-Reply-To: <alpine.LFD.0.999.0707171338290.27353@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708121153160.16526@anakin>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin>
 <20070717163328.GG7965@c2.user-mode-linux.org> <Pine.LNX.4.64.0707171842590.10600@anakin>
 <alpine.LFD.0.999.0707171102040.19166@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707172225260.23024@anakin>
 <alpine.LFD.0.999.0707171338290.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

On Tue, 17 Jul 2007, Linus Torvalds wrote:
> On Tue, 17 Jul 2007, Geert Uytterhoeven wrote:
> > OR I'll have to disable HAS_IOMEM on m68k, and invent a new Kconfig
> > symbol for lots of other stuff that currently depends on HAS_IOMEM...
> 
> Well, as far as I'm concerned, you could also make all drivers that 
> actually need "check_signature()" do a Kconfig level
> 
> 	select CHECK_SIGNATURE
> 
> along with a
> 
> 	config CHECK_SIGNATURE
> 		bool
> 		default n
> 
> in lib/Kconfig, and thus make it totally independent of any hw/bus 
> features at all, and simply depend on whether it is needed or not. I'd be 
> ok with that, and it's certainly "correct" too.
> 
> Hmm?

So here it is...

---
Subject: Introduce CONFIG_CHECK_SIGNATURE

Introduce CONFIG_CHECK_SIGNATURE to control inclusion of check_signature()
and avoid problems on platforms that don't have readb().

Let the few legacy (ISA || PCI || X86) drivers that need check_signature()
select CONFIG_CHECK_SIGNATURE.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/Kconfig      |    1 +
 drivers/input/misc/Kconfig |    1 +
 drivers/scsi/Kconfig       |    6 ++++++
 lib/Kconfig                |    3 +++
 lib/Makefile               |    3 ++-
 5 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -62,6 +62,7 @@ config AMIGA_Z2RAM
 config BLK_DEV_XD
 	tristate "XT hard disk support"
 	depends on ISA && ISA_DMA_API
+	select CHECK_SIGNATURE
 	help
 	  Very old 8 bit hard disk controllers used in the IBM XT computer
 	  will be supported if you say Y here.
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -68,6 +68,7 @@ config INPUT_WISTRON_BTNS
 	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
+	select CHECK_SIGNATURE
 	help
 	  Say Y here for support of Winstron laptop button interface, used on
 	  laptops of various brands, including Acer and Fujitsu-Siemens. If
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -367,6 +367,7 @@ config SCSI_3W_9XXX
 config SCSI_7000FASST
 	tristate "7000FASST SCSI support"
 	depends on ISA && SCSI && ISA_DMA_API
+	select CHECK_SIGNATURE
 	help
 	  This driver supports the Western Digital 7000 SCSI host adapter
 	  family.  Some information is in the source:
@@ -388,6 +389,7 @@ config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
 	depends on ISA && SCSI && !64BIT
 	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
 	  SCSI host adapters. It also works for the AVA-1505, but the IRQ etc.
@@ -583,6 +585,7 @@ config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
 	help
 	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
 	  the SCSI-HOWTO, available from
@@ -657,6 +660,7 @@ config SCSI_EATA_PIO
 config SCSI_FUTURE_DOMAIN
 	tristate "Future Domain 16xx SCSI/AHA-2920A support"
 	depends on (ISA || PCI) && SCSI
+	select CHECK_SIGNATURE
 	---help---
 	  This is support for Future Domain's 16-bit SCSI host adapters
 	  (TMC-1660/1680, TMC-1650/1670, TMC-3260, TMC-1610M/MER/MEX) and
@@ -1324,6 +1328,7 @@ config SCSI_LPFC
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
 	depends on X86 && ISA && SCSI
+	select CHECK_SIGNATURE
 	---help---
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
 	  this driver.  It is explained in section 3.9 of the SCSI-HOWTO,
@@ -1397,6 +1402,7 @@ config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
 	---help---
 	  This is support for a SCSI host adapter. It is explained in section
 	  3.11 of the SCSI-HOWTO, available from
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -138,4 +138,7 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
 
+config CHECK_SIGNATURE
+	bool
+
 endmenu
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,8 @@ CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
-obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o check_signature.o
+obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
+obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
