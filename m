Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYHIMEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYHIMEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 08:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYHIMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 08:04:14 -0400
Received: from khc.piap.pl ([195.187.100.11]:51938 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYHIMEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 08:04:12 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	<m3sktfw1v5.fsf@maximus.localdomain>
	<alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	<20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 09 Aug 2008 14:04:06 +0200
In-Reply-To: <20080809103331.1d475d5c@lxorguk.ukuu.org.uk> (Alan Cox's message of "Sat\, 9 Aug 2008 10\:33\:31 +0100")
Message-ID: <m3zlnm75u1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> Alas it does not or we would have done so. A lot of the chips have things
> like 'two SATA one PATA' and some of them have SATA and PATA variants of
> the same chip. Then we have generic drivers like ata_generic which really
> don't care if its SATA or PATA ..

Then I would enable them if SATA _or_ PATA is selected. Something like
the following. Then the driver list (one common list) could be sorted,
ATA_SFF moved to the end etc.

It complicates the Kconfig, I don't know if users' experience is worth
it in the end.

I'm not sure about IXP4XX_CF (compact flash) case, it's essentially
PATA but the physical interface is a bit different and it may be
confusing(?). Also not sure about Pacific Digital ADMA, is it
PATA-only or both?

--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig ATA
-	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	tristate "Serial ATA and Parallel ATA drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
@@ -23,6 +23,21 @@ menuconfig ATA
 
 if ATA
 
+config ATA_PATA
+	bool "Parallel ATA (PATA) support"
+	depends on ATA
+	help
+	  Say Y here if you want support for Parallel ATA devices, previously
+	  known as IDE. This also includes Compact Flash slots.
+
+config ATA_SATA
+	bool "Serial ATA (SATA) support"
+	depends on ATA
+	help
+	  Say Y here if you want support for Parallel ATA devices.
+
+if ATA_PATA || ATA_SATA
+
 config ATA_NONSTANDARD
        bool
        default n
@@ -44,13 +59,14 @@ config ATA_ACPI
 config SATA_PMP
 	bool "SATA Port Multiplier support"
 	default y
+	depends on ATA_SATA
 	help
 	  This option adds support for SATA Port Multipliers
 	  (the SATA version of an ethernet hub, or SAS expander).
 
 config SATA_AHCI
 	tristate "AHCI SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
 	help
 	  This option enables support for AHCI Serial ATA.
 
@@ -58,7 +74,7 @@ config SATA_AHCI
 
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
 	help
 	  This option enables support for Silicon Image 3124/3132 Serial ATA.
 
@@ -66,7 +82,7 @@ config SATA_SIL24
 
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
-	depends on FSL_SOC
+	depends on FSL_SOC && ATA_SATA
 	help
 	  This option enables support for Freescale 3.0Gbps SATA controller.
 	  It can be found on MPC837x and MPC8315.
@@ -91,11 +107,10 @@ config ATA_SFF
 
 	  If unsure, say Y.
 
-if ATA_SFF
-
 config SATA_SVW
 	tristate "ServerWorks Frodo / Apple K2 SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for Broadcom/Serverworks/Apple K2
 	  SATA support.
@@ -105,6 +120,7 @@ config SATA_SVW
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
 	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
@@ -114,7 +130,8 @@ config ATA_PIIX
 
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] chips.
@@ -123,7 +140,8 @@ config SATA_MV
 
 config SATA_NV
 	tristate "NVIDIA SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for NVIDIA Serial ATA.
 
@@ -132,6 +150,7 @@ config SATA_NV
 config PDC_ADMA
 	tristate "Pacific Digital ADMA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Pacific Digital ADMA controllers
 
@@ -139,7 +158,8 @@ config PDC_ADMA
 
 config SATA_QSTOR
 	tristate "Pacific Digital SATA QStor support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for Pacific Digital Serial ATA QStor.
 
@@ -147,7 +167,8 @@ config SATA_QSTOR
 
 config SATA_PROMISE
 	tristate "Promise SATA TX2/TX4 support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for Promise Serial ATA TX2/TX4.
 
@@ -155,7 +176,8 @@ config SATA_PROMISE
 
 config SATA_SX4
 	tristate "Promise SATA SX4 support"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -163,7 +185,8 @@ config SATA_SX4
 
 config SATA_SIL
 	tristate "Silicon Image SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for Silicon Image Serial ATA.
 
@@ -171,8 +194,9 @@ config SATA_SIL
 
 config SATA_SIS
 	tristate "SiS 964/965/966/180 SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
 	select PATA_SIS
+	select ATA_SFF
 	help
 	  This option enables support for SiS Serial ATA on
 	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
@@ -182,7 +206,8 @@ config SATA_SIS
 
 config SATA_ULI
 	tristate "ULi Electronics SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for ULi Electronics SATA.
 
@@ -190,7 +215,8 @@ config SATA_ULI
 
 config SATA_VIA
 	tristate "VIA SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for VIA Serial ATA.
 
@@ -198,7 +224,8 @@ config SATA_VIA
 
 config SATA_VITESSE
 	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
 
@@ -206,13 +233,15 @@ config SATA_VITESSE
 
 config SATA_INIC162X
 	tristate "Initio 162x SATA support"
-	depends on PCI
+	depends on PCI && ATA_SATA
+	select ATA_SFF
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
-	depends on ATA_ACPI
+	depends on ATA_ACPI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables an ACPI method driver which drives
 	  motherboard PATA controller interfaces through the ACPI
@@ -221,7 +250,8 @@ config PATA_ACPI
 
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -230,7 +260,8 @@ config PATA_ALI
 
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the AMD and NVidia PATA
 	  interfaces found on the chipsets for Athlon/Athlon64.
@@ -239,7 +270,8 @@ config PATA_AMD
 
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -247,7 +279,8 @@ config PATA_ARTOP
 
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -256,7 +289,8 @@ config PATA_AT32
 
 config PATA_ATIIXP
 	tristate "ATI PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the ATI ATA interfaces
 	  found on the many ATI chipsets.
@@ -265,7 +299,8 @@ config PATA_ATIIXP
 
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -275,7 +310,8 @@ config PATA_CMD640_PCI
 
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
@@ -284,7 +320,8 @@ config PATA_CMD64X
 
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the Cyrix 5510/5520
 	  companion chip used with the MediaGX/Geode processor family.
@@ -293,7 +330,8 @@ config PATA_CS5520
 
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -302,7 +340,8 @@ config PATA_CS5530
 
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on PCI && X86 && !X86_64 && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -311,7 +350,8 @@ config PATA_CS5535
 
 config PATA_CS5536
 	tristate "CS5536 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on PCI && X86 && !X86_64 && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -320,7 +360,8 @@ config PATA_CS5536
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -329,7 +370,8 @@ config PATA_CYPRESS
 
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the EFAR SLC90E66
 	  IDE controller found on some older machines.
@@ -339,6 +381,7 @@ config PATA_EFAR
 config ATA_GENERIC
 	tristate "Generic ATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for generic BIOS configured
 	  ATA controllers via the new ATA layer
@@ -347,7 +390,8 @@ config ATA_GENERIC
 
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
@@ -356,7 +400,8 @@ config PATA_HPT366
 
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -365,7 +410,8 @@ config PATA_HPT37X
 
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
@@ -374,7 +420,8 @@ config PATA_HPT3X2N
 
 config PATA_HPT3X3
 	tristate "HPT 343/363 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the HPT 343/363
 	  PATA controllers via the new ATA layer
@@ -383,7 +430,8 @@ config PATA_HPT3X3
 
 config PATA_HPT3X3_DMA
 	bool "HPT 343/363 DMA support (Experimental)"
-	depends on PATA_HPT3X3
+	depends on PATA_HPT3X3 && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables DMA support for the HPT343/363
 	  controllers. Enable with care as there are still some
@@ -391,7 +439,8 @@ config PATA_HPT3X3_DMA
 
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
-	depends on EXPERIMENTAL && ISAPNP
+	depends on EXPERIMENTAL && ISAPNP && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -400,7 +449,8 @@ config PATA_ISAPNP
 
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -410,7 +460,8 @@ config PATA_IT821X
 
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
@@ -419,7 +470,8 @@ config PATA_IT8213
 
 config PATA_JMICRON
 	tristate "JMicron PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  Enable support for the JMicron IDE controller, via the new
 	  ATA layer.
@@ -428,7 +480,8 @@ config PATA_JMICRON
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ISA && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
@@ -437,7 +490,8 @@ config PATA_LEGACY
 
 config PATA_TRIFLEX
 	tristate "Compaq Triflex PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  Enable support for the Compaq 'Triflex' IDE controller as found
 	  on many Compaq Pentium-Pro systems, via the new ATA layer.
@@ -446,7 +500,8 @@ config PATA_TRIFLEX
 
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables limited support for the Marvell 88SE6145 ATA
 	  controller.
@@ -455,7 +510,8 @@ config PATA_MARVELL
 
 config PATA_MPC52xx
 	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx
+	depends on PPC_MPC52xx && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for integrated IDE controller
 	  of the Freescale MPC52xx SoC.
@@ -464,7 +520,8 @@ config PATA_MPC52xx
 
 config PATA_MPIIX
 	tristate "Intel PATA MPIIX support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for MPIIX PATA support.
 
@@ -472,7 +529,8 @@ config PATA_MPIIX
 
 config PATA_OLDPIIX
 	tristate "Intel PATA old PIIX support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for early PIIX PATA support.
 
@@ -480,7 +538,8 @@ config PATA_OLDPIIX
 
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the Netcell Revolution RAID
 	  PATA controller.
@@ -489,7 +548,8 @@ config PATA_NETCELL
 
 config PATA_NINJA32
 	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the Ninja32, Delkin and
 	  possibly other brands of Cardbus ATA adapter
@@ -498,7 +558,8 @@ config PATA_NINJA32
 
 config PATA_NS87410
 	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the National Semiconductor
 	  NS87410 PCI-IDE controller.
@@ -507,7 +568,8 @@ config PATA_NS87410
 
 config PATA_NS87415
 	tristate "Nat Semi NS87415 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the National Semiconductor
 	  NS87415 PCI-IDE controller.
@@ -516,7 +578,8 @@ config PATA_NS87415
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -525,7 +588,8 @@ config PATA_OPTI
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -535,7 +599,8 @@ config PATA_OPTIDMA
 
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
-	depends on PCMCIA
+	depends on PCMCIA && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for PCMCIA ATA interfaces, including
 	  compact flash card adapters via the new ATA layer.
@@ -544,7 +609,8 @@ config PATA_PCMCIA
 
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -553,13 +619,15 @@ config PATA_PDC_OLD
 
 config PATA_QDI
 	tristate "QDI VLB PATA support"
-	depends on ISA
+	depends on ISA && ATA_PATA
+	select ATA_SFF
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -568,7 +636,8 @@ config PATA_RADISYS
 
 config PATA_RB532
 	tristate "RouterBoard 532 PATA CompactFlash support"
-	depends on MIKROTIK_RB532
+	depends on MIKROTIK_RB532 && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the RouterBoard 532
 	  PATA CompactFlash controller.
@@ -577,7 +646,8 @@ config PATA_RB532
 
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables basic support for the PC Tech RZ1000/1
 	  PATA controllers via the new ATA layer
@@ -586,7 +656,8 @@ config PATA_RZ1000
 
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
@@ -595,7 +666,8 @@ config PATA_SC1200
 
 config PATA_SERVERWORKS
 	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
@@ -604,7 +676,8 @@ config PATA_SERVERWORKS
 
 config PATA_PDC2027X
 	tristate "Promise PATA 2027x support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
 
@@ -612,7 +685,8 @@ config PATA_PDC2027X
 
 config PATA_SIL680
 	tristate "CMD / Silicon Image 680 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for CMD / Silicon Image 680 PATA.
 
@@ -620,7 +694,8 @@ config PATA_SIL680
 
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for SiS PATA controllers
 
@@ -628,7 +703,8 @@ config PATA_SIS
 
 config PATA_VIA
 	tristate "VIA PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the VIA PATA interfaces
 	  found on the many VIA chipsets.
@@ -637,7 +713,8 @@ config PATA_VIA
 
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for SL82C105 PATA devices found in the
 	  Netwinder and some other systems
@@ -646,7 +723,8 @@ config PATA_WINBOND
 
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ISA && EXPERIMENTAL && ATA_PATA
+	select ATA_SFF
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
@@ -662,6 +740,8 @@ config HAVE_PATA_PLATFORM
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
 	depends on EMBEDDED || ARCH_RPC || PPC || HAVE_PATA_PLATFORM
+	depends on ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
@@ -670,7 +750,8 @@ config PATA_PLATFORM
 
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
-	depends on PATA_PLATFORM && PPC_OF
+	depends on PATA_PLATFORM && PPC_OF && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
@@ -680,7 +761,8 @@ config PATA_OF_PLATFORM
 
 config PATA_ICSIDE
 	tristate "Acorn ICS PATA support"
-	depends on ARM && ARCH_ACORN
+	depends on ARM && ARCH_ACORN && ATA_PATA
+	select ATA_SFF
 	help
 	  On Acorn systems, say Y here if you wish to use the ICS PATA
 	  interface card.  This is not required for ICS partition support.
@@ -688,7 +770,8 @@ config PATA_ICSIDE
 
 config PATA_IXP4XX_CF
 	tristate "IXP4XX Compact Flash support"
-	depends on ARCH_IXP4XX
+	depends on ARCH_IXP4XX && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for a Compact Flash connected on
 	  the ixp4xx expansion bus. This driver had been written for
@@ -698,7 +781,8 @@ config PATA_IXP4XX_CF
 
 config PATA_SCC
 	tristate "Toshiba's Cell Reference Set IDE support"
-	depends on PCI && PPC_CELLEB
+	depends on PCI && PPC_CELLEB && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the built-in IDE controller on
 	  Toshiba Cell Reference Board.
@@ -707,7 +791,8 @@ config PATA_SCC
 
 config PATA_SCH
 	tristate "Intel SCH PATA support"
-	depends on PCI
+	depends on PCI && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for Intel SCH PATA on the Intel
 	  SCH (US15W, US15L, UL11L) series host controllers.
@@ -716,12 +801,13 @@ config PATA_SCH
 
 config PATA_BF54X
 	tristate "Blackfin 54x ATAPI support"
-	depends on BF542 || BF548 || BF549
+	depends on (BF542 || BF548 || BF549) && ATA_PATA
+	select ATA_SFF
 	help
 	  This option enables support for the built-in ATAPI controller on
 	  Blackfin 54x family chips.
 
 	  If unsure, say N.
 
-endif # ATA_SFF
+endif # ATA_PATA || ATA_SATA
 endif # ATA

-- 
Krzysztof Halasa
