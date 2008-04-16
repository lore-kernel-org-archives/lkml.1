Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYDPXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYDPXBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYDPXBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:01:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61953 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYDPXBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KBjG+hIoJK1lJ2hKNpYsk/O0QTwaZ8Pwtbj3P+CApKIMRIt/YMCQ5ZVloUZlAhUt78c/zYhjJF6msoC+j+vOqS8Yecd1m4ZT+IZ3aIkVKRFI7Q5xr4WxtLp53JNRSerWim7KCzbyzlAlV6Er5i4Kdt6MY5MYMzt1U+Ij1u49s4g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Thu, 17 Apr 2008 01:15:34 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170115.35319.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/avr32/Kconfig                        |    1 -
 arch/mips/au1000/common/platform.c        |    2 +-
 drivers/ide/mips/au1xxx-ide.c             |   18 +++++++-----------
 drivers/ide/pci/it821x.c                  |    2 +-
 include/asm-mips/mach-au1x00/au1xxx_ide.h |   18 ------------------
 include/asm-mips/mach-db1x00/db1200.h     |    4 ++--
 include/asm-mips/mach-pb1x00/pb1200.h     |    4 ++--
 7 files changed, 13 insertions(+), 36 deletions(-)


Adrian Bunk (1):
      avr32 mustn't select HAVE_IDE

Paul Bolle (1):
      it821x: do not describe noraid parameter with its value

Sergei Shtylyov (3):
      Au1200: kill IDE driver function prototypes
      Au1200: IDE driver build fix
      Pb1200/DBAu1200: fix bad IDE resource size


diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index c75d708..28e0caf 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,7 +10,6 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
-	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	help
diff --git a/arch/mips/au1000/common/platform.c b/arch/mips/au1000/common/platform.c
index 841904c..39d6812 100644
--- a/arch/mips/au1000/common/platform.c
+++ b/arch/mips/au1000/common/platform.c
@@ -189,7 +189,7 @@ static struct resource au1200_lcd_resources[] = {
 static struct resource au1200_ide0_resources[] = {
 	[0] = {
 		.start		= AU1XXX_ATA_PHYS_ADDR,
-		.end 		= AU1XXX_ATA_PHYS_ADDR + AU1XXX_ATA_PHYS_LEN,
+		.end 		= AU1XXX_ATA_PHYS_ADDR + AU1XXX_ATA_PHYS_LEN - 1,
 		.flags		= IORESOURCE_MEM,
 	},
 	[1] = {
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 0f4bf5d..85c016b 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -32,19 +32,12 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-
 #include <linux/init.h>
 #include <linux/ide.h>
-#include <linux/sysdev.h>
-
-#include <linux/dma-mapping.h>
-
-#include "ide-timing.h"
+#include <linux/scatterlist.h>
 
-#include <asm/io.h>
 #include <asm/mach-au1x00/au1xxx.h>
 #include <asm/mach-au1x00/au1xxx_dbdma.h>
-
 #include <asm/mach-au1x00/au1xxx_ide.h>
 
 #define DRV_NAME	"au1200-ide"
@@ -56,6 +49,8 @@
 static _auide_hwif auide_hwif;
 static int dbdma_init_done;
 
+static int auide_ddma_init(_auide_hwif *auide);
+
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA)
 
 void auide_insw(unsigned long port, void *addr, u32 count)
@@ -591,13 +586,14 @@ static int au_ide_probe(struct device *dev)
 		goto out;
 	}
 
-	if (!request_mem_region (res->start, res->end-res->start, pdev->name)) {
+	if (!request_mem_region(res->start, res->end - res->start + 1,
+				pdev->name)) {
 		pr_debug("%s: request_mem_region failed\n", DRV_NAME);
 		ret =  -EBUSY;
 		goto out;
 	}
 
-	ahwif->regbase = (u32)ioremap(res->start, res->end-res->start);
+	ahwif->regbase = (u32)ioremap(res->start, res->end - res->start + 1);
 	if (ahwif->regbase == 0) {
 		ret = -ENOMEM;
 		goto out;
@@ -682,7 +678,7 @@ static int au_ide_remove(struct device *dev)
 	iounmap((void *)ahwif->regbase);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start);
+	release_mem_region(res->start, res->end - res->start + 1);
 
 	return 0;
 }
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 1597f0c..d8a1674 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -667,7 +667,7 @@ static int __init it821x_ide_init(void)
 module_init(it821x_ide_init);
 
 module_param_named(noraid, it8212_noraid, int, S_IRUGO);
-MODULE_PARM_DESC(it8212_noraid, "Force card into bypass mode");
+MODULE_PARM_DESC(noraid, "Force card into bypass mode");
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for the ITE 821x");
diff --git a/include/asm-mips/mach-au1x00/au1xxx_ide.h b/include/asm-mips/mach-au1x00/au1xxx_ide.h
index e4fe26c..89655c0 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -122,24 +122,6 @@ static const struct drive_list_entry dma_black_list [] = {
 };
 #endif
 
-/* function prototyping */
-u8 auide_inb(unsigned long port);
-u16 auide_inw(unsigned long port);
-u32 auide_inl(unsigned long port);
-void auide_insw(unsigned long port, void *addr, u32 count);
-void auide_insl(unsigned long port, void *addr, u32 count);
-void auide_outb(u8 addr, unsigned long port);
-void auide_outbsync(ide_drive_t *drive, u8 addr, unsigned long port);
-void auide_outw(u16 addr, unsigned long port);
-void auide_outl(u32 addr, unsigned long port);
-void auide_outsw(unsigned long port, void *addr, u32 count);
-void auide_outsl(unsigned long port, void *addr, u32 count);
-static void auide_tune_drive(ide_drive_t *drive, byte pio);
-static int auide_tune_chipset(ide_drive_t *drive, u8 speed);
-static int auide_ddma_init( _auide_hwif *auide );
-static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif);
-int __init auide_probe(void);
-
 /*******************************************************************************
 * PIO Mode timing calculation :                                                *
 *                                                                              *
diff --git a/include/asm-mips/mach-db1x00/db1200.h b/include/asm-mips/mach-db1x00/db1200.h
index a6bdac6..d2e28e6 100644
--- a/include/asm-mips/mach-db1x00/db1200.h
+++ b/include/asm-mips/mach-db1x00/db1200.h
@@ -173,8 +173,8 @@ static BCSR * const bcsr = (BCSR *)BCSR_KSEG1_ADDR;
 #define AU1XXX_SMC91111_IRQ			DB1200_ETH_INT
 
 #define AU1XXX_ATA_PHYS_ADDR		(0x18800000)
-#define AU1XXX_ATA_PHYS_LEN			(0x100)
-#define AU1XXX_ATA_REG_OFFSET	(5)
+#define AU1XXX_ATA_REG_OFFSET		(5)
+#define AU1XXX_ATA_PHYS_LEN		(16 << AU1XXX_ATA_REG_OFFSET)
 #define AU1XXX_ATA_INT			DB1200_IDE_INT
 #define AU1XXX_ATA_DDMA_REQ		DSCR_CMD0_DMA_REQ1;
 #define AU1XXX_ATA_RQSIZE		128
diff --git a/include/asm-mips/mach-pb1x00/pb1200.h b/include/asm-mips/mach-pb1x00/pb1200.h
index 72213e3..edaa489 100644
--- a/include/asm-mips/mach-pb1x00/pb1200.h
+++ b/include/asm-mips/mach-pb1x00/pb1200.h
@@ -186,8 +186,8 @@ static BCSR * const bcsr = (BCSR *)BCSR_KSEG1_ADDR;
 #define AU1XXX_SMC91111_IRQ			PB1200_ETH_INT
 
 #define AU1XXX_ATA_PHYS_ADDR		(0x0C800000)
-#define AU1XXX_ATA_PHYS_LEN			(0x100)
-#define AU1XXX_ATA_REG_OFFSET	(5)
+#define AU1XXX_ATA_REG_OFFSET		(5)
+#define AU1XXX_ATA_PHYS_LEN		(16 << AU1XXX_ATA_REG_OFFSET)
 #define AU1XXX_ATA_INT			PB1200_IDE_INT
 #define AU1XXX_ATA_DDMA_REQ		DSCR_CMD0_DMA_REQ1;
 #define AU1XXX_ATA_RQSIZE		128
