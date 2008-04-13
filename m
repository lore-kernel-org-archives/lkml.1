Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYDMAwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYDMAwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 20:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYDMAwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 20:52:37 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56768 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYDMAwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 20:52:35 -0400
Date: Sun, 13 Apr 2008 03:51:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: [mm patch] select ATA_SFF
Message-ID: <20080413005137.GD8849@cs181133002.pp.htv.fi>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411234345.GA4742@martell.zuzino.mipt.ru> <20080412005917.GA4742@martell.zuzino.mipt.ru> <20080412065248.GA8849@cs181133002.pp.htv.fi> <480088AD.1040904@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <480088AD.1040904@garzik.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 06:02:21AM -0400, Jeff Garzik wrote:
> Adrian Bunk wrote:
>> On Sat, Apr 12, 2008 at 04:59:17AM +0400, Alexey Dobriyan wrote:
>>> On Sat, Apr 12, 2008 at 03:43:45AM +0400, Alexey Dobriyan wrote:
>>>> Pekka fixed SLUB for me, and now core2 box survives up and including to
>>>> not finding / :
>>>>
>>>> Setup is SATA disk with plain old partitions, nothing lvmancy:
>>>>
>>>> 	/dev/sda2 on / type ext3 (rw,noatime)
>>>>
>>>> CONFIG_ATA=y
>>>> CONFIG_ATA_ACPI=y
>>>> CONFIG_SATA_AHCI=y
>>>> CONFIG_ATA_PIIX=y
>>>> CONFIG_PATA_JMICRON=y
>>>>
>>>> sda1 is for swap.
>>>>
>>>>
>>>> [    3.920000] NET: Registered protocol family 1
>>>> [    3.920000] VFS: Cannot open root device "sda2" or unknown-block(0,0)
>>> The winner is partly me, partly git-libata-all.
>>>
>>> The latter introduced CONFIG_ATA_SFF option and put more or less every
>>> SATA and PATA driver under it. The former honestly answered N to when
>>> ATA_SFF popped up and failed to check existence of ATA_PIIX and
>>> PATA_JMICRON in failing .config .
>>>
>>> Now raise hands those who knew that your ATA controller is SFF
>>> compliant.
>>
>> Is there any technical reason why we have to bother users with the  
>> ATA_SFF option at all?
>>
>> It sounds like a perfect canndidate for being select'ed.
>
> 'default y' is appropriate, but option that is used to disable a major  
> swath of legacy code unneeded on modern FIS-based SATA platforms like 
> AHCI.

I think you didn't understand my suggestion.

I didn't want to get the code enabled unconditionally, I want kconfig 
users to not needlessly being bothered with an option where we could 
determine automatically the correct setting.

The patch below implements what I have in mind.

> 	Jeff

cu
Adrian


<--  snip  -->


Making ATA_SFF a user-visible option with the drivers needing it 
depending on it caused the following problems:
- people lose their driver when accidentally disabling it
- people not requiring it needlessly enable it

Fortunately, we don't have to bother the user with this option at all 
since we can simply select it when it's required.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/Kconfig |   79 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 8 deletions(-)

--- linux-2.6.25-rc8-mm2/drivers/ata/Kconfig.old	2008-04-13 01:59:27.000000000 +0300
+++ linux-2.6.25-rc8-mm2/drivers/ata/Kconfig	2008-04-13 02:05:42.000000000 +0300
@@ -73,17 +73,12 @@
 	  If unsure, say N.
 
 config ATA_SFF
-	bool "ATA SFF support"
-	default y
-	help
-	  This option adds support for ATA controllers with SFF
-	  compliant or similar programming interface.
-
-if ATA_SFF
+	bool
 
 config SATA_SVW
 	tristate "ServerWorks Frodo / Apple K2 SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Broadcom/Serverworks/Apple K2
 	  SATA support.
@@ -93,6 +88,7 @@
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
 	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
@@ -103,6 +99,7 @@
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] chips.
@@ -112,6 +109,7 @@
 config SATA_NV
 	tristate "NVIDIA SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for NVIDIA Serial ATA.
 
@@ -120,6 +118,7 @@
 config PDC_ADMA
 	tristate "Pacific Digital ADMA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Pacific Digital ADMA controllers
 
@@ -128,6 +127,7 @@
 config SATA_QSTOR
 	tristate "Pacific Digital SATA QStor support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Pacific Digital Serial ATA QStor.
 
@@ -136,6 +136,7 @@
 config SATA_PROMISE
 	tristate "Promise SATA TX2/TX4 support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Promise Serial ATA TX2/TX4.
 
@@ -144,6 +145,7 @@
 config SATA_SX4
 	tristate "Promise SATA SX4 support"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -152,6 +154,7 @@
 config SATA_SIL
 	tristate "Silicon Image SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Silicon Image Serial ATA.
 
@@ -161,6 +164,7 @@
 	tristate "SiS 964/965/966/180 SATA support"
 	depends on PCI
 	select PATA_SIS
+	select ATA_SFF
 	help
 	  This option enables support for SiS Serial ATA on
 	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
@@ -171,6 +175,7 @@
 config SATA_ULI
 	tristate "ULi Electronics SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for ULi Electronics SATA.
 
@@ -179,6 +184,7 @@
 config SATA_VIA
 	tristate "VIA SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for VIA Serial ATA.
 
@@ -187,6 +193,7 @@
 config SATA_VITESSE
 	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
 
@@ -195,12 +202,14 @@
 config SATA_INIC162X
 	tristate "Initio 162x SATA support (HIGHLY EXPERIMENTAL)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
 	depends on ATA_ACPI
+	select ATA_SFF
 	help
 	  This option enables an ACPI method driver which drives
 	  motherboard PATA controller interfaces through the ACPI
@@ -210,6 +219,7 @@
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -219,6 +229,7 @@
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the AMD and NVidia PATA
 	  interfaces found on the chipsets for Athlon/Athlon64.
@@ -228,6 +239,7 @@
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -236,6 +248,7 @@
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
 	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -245,6 +258,7 @@
 config PATA_ATIIXP
 	tristate "ATI PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the ATI ATA interfaces
 	  found on the many ATI chipsets.
@@ -254,6 +268,7 @@
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -264,6 +279,7 @@
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
@@ -273,6 +289,7 @@
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the Cyrix 5510/5520
 	  companion chip used with the MediaGX/Geode processor family.
@@ -282,6 +299,7 @@
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -291,6 +309,7 @@
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
 	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -300,6 +319,7 @@
 config PATA_CS5536
 	tristate "CS5536 PATA support (Experimental)"
 	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -309,6 +329,7 @@
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -318,6 +339,7 @@
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the EFAR SLC90E66
 	  IDE controller found on some older machines.
@@ -327,6 +349,7 @@
 config ATA_GENERIC
 	tristate "Generic ATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for generic BIOS configured
 	  ATA controllers via the new ATA layer
@@ -336,6 +359,7 @@
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
@@ -345,6 +369,7 @@
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -354,6 +379,7 @@
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
@@ -363,6 +389,7 @@
 config PATA_HPT3X3
 	tristate "HPT 343/363 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the HPT 343/363
 	  PATA controllers via the new ATA layer
@@ -372,6 +399,7 @@
 config PATA_HPT3X3_DMA
 	bool "HPT 343/363 DMA support (Experimental)"
 	depends on PATA_HPT3X3
+	select ATA_SFF
 	help
 	  This option enables DMA support for the HPT343/363
 	  controllers. Enable with care as there are still some
@@ -380,6 +408,7 @@
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
+	select ATA_SFF
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -389,6 +418,7 @@
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -399,6 +429,7 @@
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
@@ -408,6 +439,7 @@
 config PATA_JMICRON
 	tristate "JMicron PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  Enable support for the JMicron IDE controller, via the new
 	  ATA layer.
@@ -417,6 +449,7 @@
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
@@ -426,6 +459,7 @@
 config PATA_TRIFLEX
 	tristate "Compaq Triflex PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  Enable support for the Compaq 'Triflex' IDE controller as found
 	  on many Compaq Pentium-Pro systems, via the new ATA layer.
@@ -435,6 +469,7 @@
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables limited support for the Marvell 88SE6145 ATA
 	  controller.
@@ -444,6 +479,7 @@
 config PATA_MPC52xx
 	tristate "Freescale MPC52xx SoC internal IDE"
 	depends on PPC_MPC52xx
+	select ATA_SFF
 	help
 	  This option enables support for integrated IDE controller
 	  of the Freescale MPC52xx SoC.
@@ -453,6 +489,7 @@
 config PATA_MPIIX
 	tristate "Intel PATA MPIIX support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for MPIIX PATA support.
 
@@ -461,6 +498,7 @@
 config PATA_OLDPIIX
 	tristate "Intel PATA old PIIX support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for early PIIX PATA support.
 
@@ -469,6 +507,7 @@
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the Netcell Revolution RAID
 	  PATA controller.
@@ -478,6 +517,7 @@
 config PATA_NINJA32
 	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Ninja32, Delkin and
 	  possibly other brands of Cardbus ATA adapter
@@ -487,6 +527,7 @@
 config PATA_NS87410
 	tristate "Nat Semi NS87410 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the National Semiconductor
 	  NS87410 PCI-IDE controller.
@@ -496,6 +537,7 @@
 config PATA_NS87415
 	tristate "Nat Semi NS87415 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the National Semiconductor
 	  NS87415 PCI-IDE controller.
@@ -505,6 +547,7 @@
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -514,6 +557,7 @@
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -524,6 +568,7 @@
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
 	depends on PCMCIA
+	select ATA_SFF
 	help
 	  This option enables support for PCMCIA ATA interfaces, including
 	  compact flash card adapters via the new ATA layer.
@@ -533,6 +578,7 @@
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -542,12 +588,14 @@
 config PATA_QDI
 	tristate "QDI VLB PATA support"
 	depends on ISA
+	select ATA_SFF
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -557,6 +605,7 @@
 config PATA_RB500
 	tristate "RouterBoard 500 PATA CompactFlash support"
 	depends on MIKROTIK_RB500
+	select ATA_SFF
 	help
 	  This option enables support for the RouterBoard 500
 	  PATA CompactFlash controller.
@@ -566,6 +615,7 @@
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables basic support for the PC Tech RZ1000/1
 	  PATA controllers via the new ATA layer
@@ -575,6 +625,7 @@
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
@@ -584,6 +635,7 @@
 config PATA_SERVERWORKS
 	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
@@ -593,6 +645,7 @@
 config PATA_PDC2027X
 	tristate "Promise PATA 2027x support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
 
@@ -601,6 +654,7 @@
 config PATA_SIL680
 	tristate "CMD / Silicon Image 680 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for CMD / Silicon Image 680 PATA.
 
@@ -609,6 +663,7 @@
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for SiS PATA controllers
 
@@ -617,6 +672,7 @@
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the VIA PATA interfaces
 	  found on the many VIA chipsets.
@@ -626,6 +682,7 @@
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for SL82C105 PATA devices found in the
 	  Netwinder and some other systems
@@ -635,6 +692,7 @@
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
@@ -642,6 +700,7 @@
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
 	depends on EMBEDDED || ARCH_RPC || PPC
+	select ATA_SFF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
@@ -651,6 +710,7 @@
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
 	depends on PATA_PLATFORM && PPC_OF
+	select ATA_SFF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
@@ -661,6 +721,7 @@
 config PATA_ICSIDE
 	tristate "Acorn ICS PATA support"
 	depends on ARM && ARCH_ACORN
+	select ATA_SFF
 	help
 	  On Acorn systems, say Y here if you wish to use the ICS PATA
 	  interface card.  This is not required for ICS partition support.
@@ -669,6 +730,7 @@
 config PATA_IXP4XX_CF
 	tristate "IXP4XX Compact Flash support"
 	depends on ARCH_IXP4XX
+	select ATA_SFF
 	help
 	  This option enables support for a Compact Flash connected on
 	  the ixp4xx expansion bus. This driver had been written for
@@ -679,6 +741,7 @@
 config PATA_SCC
 	tristate "Toshiba's Cell Reference Set IDE support"
 	depends on PCI && PPC_CELLEB
+	select ATA_SFF
 	help
 	  This option enables support for the built-in IDE controller on
 	  Toshiba Cell Reference Board.
@@ -688,11 +751,11 @@
 config PATA_BF54X
 	tristate "Blackfin 54x ATAPI support"
 	depends on BF542 || BF548 || BF549
+	select ATA_SFF
 	help
 	  This option enables support for the built-in ATAPI controller on
 	  Blackfin 54x family chips.
 
 	  If unsure, say N.
 
-endif # ATA_SFF
 endif # ATA

