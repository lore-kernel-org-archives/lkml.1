Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYCIPYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYCIPYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYCIPYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:24:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:14093 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYCIPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kVyOIiX3oK4Q06sFD4+V1yyO4deKUie/wDIfKqBxEbTy0ufD/Av+uOhlAhibEpUSr3FQkYwKbTc++lZLC8T5Ljp1TisjjKaGwL7yKfukF2NThzbnIhC9UuD7hOeW9K4up329EZNTKjCNJmL2upWFeElZvUFy8h0FC7EDs95j+j8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/7] au1xxx-ide: fix MWDMA support
Date: Sun, 9 Mar 2008 16:28:22 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091628.23094.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use "fast" MWDMA support and remove dma_{black,white}_list
(they were based on completely bogus ->ide_dma_check implementation
which didn't set neither the host controller timings nor the device
for the desired transfer mode).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/mips/AU1xxx_IDE.README      |   46 ----------------------------
 drivers/ide/mips/au1xxx-ide.c             |   49 +-----------------------------
 include/asm-mips/mach-au1x00/au1xxx_ide.h |   42 -------------------------
 3 files changed, 2 insertions(+), 135 deletions(-)

Index: b/Documentation/mips/AU1xxx_IDE.README
===================================================================
--- a/Documentation/mips/AU1xxx_IDE.README
+++ b/Documentation/mips/AU1xxx_IDE.README
@@ -46,8 +46,6 @@ Two files are introduced:
 
   a) 'include/asm-mips/mach-au1x00/au1xxx_ide.h'
      containes : struct _auide_hwif
-                 struct drive_list_entry dma_white_list
-                 struct drive_list_entry dma_black_list
                  timing parameters for PIO mode 0/1/2/3/4
                  timing parameters for MWDMA 0/1/2
 
@@ -63,12 +61,6 @@ Four configs variables are introduced:
   CONFIG_BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ - maximum transfer size
                                            per descriptor
 
-If MWDMA is enabled and the connected hard disc is not on the white list, the
-kernel switches to a "safe mwdma mode" at boot time. In this mode the IDE
-performance is substantial slower then in full speed mwdma. In this case
-please add your hard disc to the white list (follow instruction from 'ADD NEW
-HARD DISC TO WHITE OR BLACK LIST' section).
-
 
 SUPPORTED IDE MODES
 -------------------
@@ -120,44 +112,6 @@ CONFIG_IDEDMA_AUTO=y
 Also undefine 'IDE_AU1XXX_BURSTMODE' in 'drivers/ide/mips/au1xxx-ide.c' to
 disable the burst support on DBDMA controller.
 
-ADD NEW HARD DISC TO WHITE OR BLACK LIST
-----------------------------------------
-
-Step 1 : detect the model name of your hard disc
-
-  a) connect your hard disc to the AU1XXX
-
-  b) boot your kernel and get the hard disc model.
-
-     Example boot log:
-
-     --snipped--
-     Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
-     ide: Assuming 50MHz system bus speed for PIO modes; override with idebus=xx
-     Au1xxx IDE(builtin) configured for MWDMA2
-     Probing IDE interface ide0...
-     hda: Maxtor 6E040L0, ATA DISK drive
-     ide0 at 0xac800000-0xac800007,0xac8001c0 on irq 64
-     hda: max request size: 64KiB
-     hda: 80293248 sectors (41110 MB) w/2048KiB Cache, CHS=65535/16/63, (U)DMA
-     --snipped--
-
-     In this example 'Maxtor 6E040L0'.
-
-Step  2 : edit 'include/asm-mips/mach-au1x00/au1xxx_ide.h'
-
-  Add your hard disc to the dma_white_list or dma_black_list structur.
-
-Step 3 : Recompile the kernel
-
-  Enable MWDMA support in the kernel configuration. Recompile the kernel and
-  reboot.
-
-Step 4 : Tests
-
-  If you have add a hard disc to the white list, please run some stress tests
-  for verification.
-
 
 ACKNOWLEDGMENTS
 ---------------
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -54,7 +54,6 @@
 #define IDE_AU1XXX_BURSTMODE	1
 
 static _auide_hwif auide_hwif;
-static int dbdma_init_done;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA)
 
@@ -320,35 +319,6 @@ static int auide_dma_setup(ide_drive_t *
 	return 0;
 }
 
-static u8 auide_mdma_filter(ide_drive_t *drive)
-{
-	/*
-	 * FIXME: ->white_list and ->black_list are based on completely bogus
-	 * ->ide_dma_check implementation which didn't set neither the host
-	 * controller timings nor the device for the desired transfer mode.
-	 *
-	 * They should be either removed or 0x00 MWDMA mask should be
-	 * returned for devices on the ->black_list.
-	 */
-
-	if (dbdma_init_done == 0) {
-		auide_hwif.white_list = ide_in_drive_list(drive->id,
-							  dma_white_list);
-		auide_hwif.black_list = ide_in_drive_list(drive->id,
-							  dma_black_list);
-		auide_hwif.drive = drive;
-		auide_ddma_init(&auide_hwif);
-		dbdma_init_done = 1;
-	}
-
-	/* Is the drive in our DMA black list? */
-	if (auide_hwif.black_list)
-		printk(KERN_WARNING "%s: Disabling DMA for %s (blacklisted)\n",
-				    drive->name, drive->id->model);
-
-	return drive->hwif->mwdma_mask;
-}
-
 static int auide_dma_test_irq(ide_drive_t *drive)
 {	
 	if (drive->waiting_for_dma == 0)
@@ -425,17 +395,8 @@ static int auide_ddma_init(_auide_hwif *
 
 	dev_id   = AU1XXX_ATA_DDMA_REQ;
 
-	if (auide->white_list || auide->black_list) {
-		tsize    = 8;
-		devwidth = 32;
-	}
-	else { 
-		tsize    = 1;
-		devwidth = 16;
-		
-		printk(KERN_ERR "au1xxx-ide: %s is not on ide driver whitelist.\n",auide_hwif.drive->id->model);
-		printk(KERN_ERR "            please read 'Documentation/mips/AU1xxx_IDE.README'");
-	}
+	tsize    =  8; /*  1 */
+	devwidth = 32; /* 16 */
 
 #ifdef IDE_AU1XXX_BURSTMODE 
 	flags = DEV_FLAGS_SYNC | DEV_FLAGS_BURSTABLE;
@@ -551,9 +512,6 @@ static void auide_setup_ports(hw_regs_t 
 static const struct ide_port_ops au1xxx_port_ops = {
 	.set_pio_mode		= au1xxx_set_pio_mode,
 	.set_dma_mode		= auide_set_dma_mode,
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-	.mdma_filter		= auide_mdma_filter,
-#endif
 };
 
 static const struct ide_port_info au1xxx_port_info = {
@@ -652,10 +610,7 @@ static int au_ide_probe(struct device *d
 	auide_hwif.hwif                 = hwif;
 	hwif->hwif_data                 = &auide_hwif;
 
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA           
 	auide_ddma_init(&auide_hwif);
-	dbdma_init_done = 1;
-#endif
 
 	idx[0] = hwif->index;
 
Index: b/include/asm-mips/mach-au1x00/au1xxx_ide.h
===================================================================
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -70,7 +70,6 @@ typedef struct
         ide_hwif_t              *hwif;
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
         ide_drive_t             *drive;
-        u8                      white_list, black_list;
         struct dbdma_cmd        *dma_table_cpu;
         dma_addr_t              dma_table_dma;
 #endif
@@ -81,47 +80,6 @@ typedef struct
 #endif
 } _auide_hwif;
 
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-/* HD white list */
-static const struct drive_list_entry dma_white_list [] = {
-/*
- * Hitachi
- */
-        { "HITACHI_DK14FA-20"    ,       NULL            },
-        { "HTS726060M9AT00"      ,       NULL            },
-/*
- * Maxtor
- */
-        { "Maxtor 6E040L0"      ,       NULL            },
-        { "Maxtor 6Y080P0"      ,       NULL            },
-        { "Maxtor 6Y160P0"      ,       NULL            },
-/*
- * Seagate
- */
-        { "ST3120026A"          ,       NULL            },
-        { "ST320014A"           ,       NULL            },
-        { "ST94011A"            ,       NULL            },
-        { "ST340016A"           ,       NULL            },
-/*
- * Western Digital
- */
-        { "WDC WD400UE-00HCT0"  ,       NULL            },
-        { "WDC WD400JB-00JJC0"  ,       NULL            },
-        { NULL                  ,       NULL            }
-};
-
-/* HD black list */
-static const struct drive_list_entry dma_black_list [] = {
-/*
- * Western Digital
- */
-        { "WDC WD100EB-00CGH0"  ,       NULL            },
-        { "WDC WD200BB-00AUA1"  ,       NULL            },
-        { "WDC AC24300L"        ,       NULL            },
-        { NULL                  ,       NULL            }
-};
-#endif
-
 /* function prototyping */
 u8 auide_inb(unsigned long port);
 u16 auide_inw(unsigned long port);
