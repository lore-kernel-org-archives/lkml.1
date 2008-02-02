Return-Path: <linux-kernel-owner+w=401wt.eu-S1765335AbYBBAhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765335AbYBBAhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763168AbYBBAg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:36:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:55174 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762449AbYBBAgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:36:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pN6k21z+nwYiGPG5StGzXwVplNWsPRZnGzXBgUDqHB6ovnO0NHsXUHq2OrqchG4d/MEDN5cu2VuszcZl8bhqYLegrxj4sOaG44S+BJ5q2lX6GXukBxqrBRl8EdJf30nNqvPotH0y52lypJDK2lW+UATXd/6U6iHFz1YuLGsqSbc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] ide: remove ide_setup_ports()
Date: Sat, 2 Feb 2008 01:47:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020147.29467.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ide-cris.c:
* Add cris_setup_ports() helper and use it instead of ide_setup_ports()
  (fixes random value being set in ->io_ports[IDE_IRQ_OFFSET]).

buddha.c:
* Add buddha_setup_ports() helper and use it instead of ide_setup_ports().

falconide.c:
* Add falconide_setup_ports() helper and use it instead of ide_setup_ports(),
  also fix return value of falconide_init() while at it.

gayle.c:
* Add gayle_setup_ports() helper and use it instead of ide_setup_ports().

macide.c:
* Add macide_setup_ports() helper and use it instead of ide_setup_ports()
  (fixes incorrect value being set in ->io_ports[IDE_IRQ_OFFSET]).

q40ide.c:
* Fix q40_ide_setup_ports() comments.

ide.c:
* Remove no longer needed ide_setup_ports().

Cc: Mikael Starvik <starvik@axis.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cris/ide-cris.c    |   33 ++++++++++++------
 drivers/ide/ide.c              |   54 ------------------------------
 drivers/ide/legacy/buddha.c    |   72 +++++++++++++++++++++--------------------
 drivers/ide/legacy/falconide.c |   42 +++++++++++------------
 drivers/ide/legacy/gayle.c     |   39 +++++++++++-----------
 drivers/ide/legacy/macide.c    |   57 +++++++++++++++++---------------
 drivers/ide/legacy/q40ide.c    |    9 -----
 include/linux/ide.h            |   11 ------
 8 files changed, 133 insertions(+), 184 deletions(-)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -753,6 +753,25 @@ static void cris_set_dma_mode(ide_drive_
 		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
 }
 
+static void __init cris_setup_ports(hw_regs_t *hw, unsigned long base)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	for (i = 0; i <= 7; i++)
+		hw->io_ports[i] = base + cris_ide_reg_addr(i, 0, 1);
+
+	/*
+	 * the IDE control register is at ATA address 6,
+	 * with CS1 active instead of CS0
+	 */
+	hw->io_ports[IDE_CONTROL_OFFSET] = base + cris_ide_reg_addr(6, 1, 0);
+
+	hw->irq = ide_default_irq(0);
+	hw->ack_intr = cris_ide_ack_intr;
+}
+
 static const struct ide_port_info cris_port_info __initdata = {
 	.chipset		= ide_etrax100,
 	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
@@ -765,24 +784,16 @@ static const struct ide_port_info cris_p
 static int __init init_e100_ide(void)
 {
 	hw_regs_t hw;
-	int ide_offsets[IDE_NR_PORTS], h, i;
+	int h;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	printk("ide: ETRAX FS built-in ATA DMA controller\n");
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		ide_offsets[i] = cris_ide_reg_addr(i, 0, 1);
-
-	/* the IDE control register is at ATA address 6, with CS1 active instead of CS0 */
-	ide_offsets[IDE_CONTROL_OFFSET] = cris_ide_reg_addr(6, 1, 0);
-
 	for (h = 0; h < 4; h++) {
 		ide_hwif_t *hwif = NULL;
 
-		ide_setup_ports(&hw, cris_ide_base_address(h),
-		                ide_offsets,
-		                0, 0, cris_ide_ack_intr,
-		                ide_default_irq(0));
+		cris_setup_ports(&hw, cris_ide_base_address(h));
+
 		hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 		if (hwif == NULL)
 			continue;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -618,60 +618,6 @@ abort:
 
 EXPORT_SYMBOL(ide_unregister);
 
-
-/**
- *	ide_setup_ports 	-	set up IDE interface ports
- *	@hw: register descriptions
- *	@base: base register
- *	@offsets: table of register offsets
- *	@ctrl: control register
- *	@ack_irq: IRQ ack
- *	@irq: interrupt lie
- *
- *	Setup hw_regs_t structure described by parameters.  You
- *	may set up the hw structure yourself OR use this routine to
- *	do it for you. This is basically a helper
- *
- */
- 
-void ide_setup_ports (	hw_regs_t *hw,
-			unsigned long base, int *offsets,
-			unsigned long ctrl, unsigned long intr,
-			ide_ack_intr_t *ack_intr,
-/*
- *			ide_io_ops_t *iops,
- */
-			int irq)
-{
-	int i;
-
-	memset(hw, 0, sizeof(hw_regs_t));
-	for (i = 0; i < IDE_NR_PORTS; i++) {
-		if (offsets[i] == -1) {
-			switch(i) {
-				case IDE_CONTROL_OFFSET:
-					hw->io_ports[i] = ctrl;
-					break;
-#if defined(CONFIG_AMIGA) || defined(CONFIG_MAC)
-				case IDE_IRQ_OFFSET:
-					hw->io_ports[i] = intr;
-					break;
-#endif /* (CONFIG_AMIGA) || (CONFIG_MAC) */
-				default:
-					hw->io_ports[i] = 0;
-					break;
-			}
-		} else {
-			hw->io_ports[i] = base + offsets[i];
-		}
-	}
-	hw->irq = irq;
-	hw->ack_intr = ack_intr;
-/*
- *	hw->iops = iops;
- */
-}
-
 void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 {
 	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -56,31 +56,11 @@ static u_int xsurf_bases[XSURF_NUM_HWIFS
      XSURF_BASE1, XSURF_BASE2
 };
 
-
     /*
      *  Offsets from one of the above bases
      */
 
-#define BUDDHA_DATA	0x00
-#define BUDDHA_ERROR	0x06		/* see err-bits */
-#define BUDDHA_NSECTOR	0x0a		/* nr of sectors to read/write */
-#define BUDDHA_SECTOR	0x0e		/* starting sector */
-#define BUDDHA_LCYL	0x12		/* starting cylinder */
-#define BUDDHA_HCYL	0x16		/* high byte of starting cyl */
-#define BUDDHA_SELECT	0x1a		/* 101dhhhh , d=drive, hhhh=head */
-#define BUDDHA_STATUS	0x1e		/* see status-bits */
 #define BUDDHA_CONTROL	0x11a
-#define XSURF_CONTROL   -1              /* X-Surf has no CS1* (Control/AltStat) */
-
-static int buddha_offsets[IDE_NR_PORTS] __initdata = {
-    BUDDHA_DATA, BUDDHA_ERROR, BUDDHA_NSECTOR, BUDDHA_SECTOR, BUDDHA_LCYL,
-    BUDDHA_HCYL, BUDDHA_SELECT, BUDDHA_STATUS, BUDDHA_CONTROL, -1
-};
-
-static int xsurf_offsets[IDE_NR_PORTS] __initdata = {
-    BUDDHA_DATA, BUDDHA_ERROR, BUDDHA_NSECTOR, BUDDHA_SECTOR, BUDDHA_LCYL,
-    BUDDHA_HCYL, BUDDHA_SELECT, BUDDHA_STATUS, XSURF_CONTROL, -1
-};
 
     /*
      *  Other registers
@@ -140,6 +120,26 @@ static int xsurf_ack_intr(ide_hwif_t *hw
     return 1;
 }
 
+static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
+				      unsigned long ctl, unsigned long irq_port,
+				      ide_ack_intr_t *ack_intr)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	hw->io_ports[IDE_DATA_OFFSET] = base;
+
+	for (i = 1; i < 8; i++)
+		hw->io_ports[i] = base + 2 + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
+	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+
+	hw->irq = IRQ_AMIGA_PORTS;
+	hw->ack_intr = ack_intr;
+}
+
     /*
      *  Probe for a Buddha or Catweasel IDE interface
      */
@@ -202,22 +202,24 @@ fail_base2:
 		printk(KERN_INFO "ide: %s IDE controller\n",
 				 buddha_board_name[type]);
 
-		for(i=0;i<buddha_num_hwifs;i++) {
-			if(type != BOARD_XSURF) {
-				ide_setup_ports(&hw, (buddha_board+buddha_bases[i]),
-						buddha_offsets, 0,
-						(buddha_board+buddha_irqports[i]),
-						buddha_ack_intr,
-//						budda_iops,
-						IRQ_AMIGA_PORTS);
+		for (i = 0; i < buddha_num_hwifs; i++) {
+			unsigned long base, ctl, irq_port;
+			ide_ack_intr_t *ack_intr;
+
+			if (type != BOARD_XSURF) {
+				base = buddha_board + buddha_bases[i];
+				ctl = base + BUDDHA_CONTROL;
+				irq_port = buddha_board + buddha_irqports[i];
+				ack_intr = buddha_ack_intr;
 			} else {
-				ide_setup_ports(&hw, (buddha_board+xsurf_bases[i]),
-						xsurf_offsets, 0,
-						(buddha_board+xsurf_irqports[i]),
-						xsurf_ack_intr,
-//						xsurf_iops,
-						IRQ_AMIGA_PORTS);
-			}	
+				base = buddha_board + xsurf_bases[i];
+				/* X-Surf has no CS1* (Control/AltStat) */
+				ctl = 0;
+				irq_port = buddha_board + xsurf_irqports[i];
+				ack_intr = xsurf_ack_intr;
+			}
+
+			buddha_setup_ports(&hw, base, ctl, irq_port, ack_intr);
 
 			hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 			if (hwif) {
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -33,22 +33,8 @@
      *  Offsets from the above base
      */
 
-#define ATA_HD_DATA	0x00
-#define ATA_HD_ERROR	0x05		/* see err-bits */
-#define ATA_HD_NSECTOR	0x09		/* nr of sectors to read/write */
-#define ATA_HD_SECTOR	0x0d		/* starting sector */
-#define ATA_HD_LCYL	0x11		/* starting cylinder */
-#define ATA_HD_HCYL	0x15		/* high byte of starting cyl */
-#define ATA_HD_SELECT	0x19		/* 101dhhhh , d=drive, hhhh=head */
-#define ATA_HD_STATUS	0x1d		/* see status-bits */
 #define ATA_HD_CONTROL	0x39
 
-static int falconide_offsets[IDE_NR_PORTS] __initdata = {
-    ATA_HD_DATA, ATA_HD_ERROR, ATA_HD_NSECTOR, ATA_HD_SECTOR, ATA_HD_LCYL,
-    ATA_HD_HCYL, ATA_HD_SELECT, ATA_HD_STATUS, ATA_HD_CONTROL, -1
-};
-
-
     /*
      *  falconide_intr_lock is used to obtain access to the IDE interrupt,
      *  which is shared between several drivers.
@@ -57,6 +43,22 @@ static int falconide_offsets[IDE_NR_PORT
 int falconide_intr_lock;
 EXPORT_SYMBOL(falconide_intr_lock);
 
+static void __init falconide_setup_ports(hw_regs_t *hw)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	hw->io_ports[IDE_DATA_OFFSET] = ATA_HD_BASE;
+
+	for (i = 1; i < 8; i++)
+		hw->io_ports[i] = ATA_HD_BASE + 1 + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_CONTROL;
+
+	hw->irq = IRQ_MFP_IDE;
+	hw->ack_intr = NULL;
+}
 
     /*
      *  Probe for a Falcon IDE interface
@@ -64,16 +66,15 @@ EXPORT_SYMBOL(falconide_intr_lock);
 
 static int __init falconide_init(void)
 {
-    if (MACH_IS_ATARI && ATARIHW_PRESENT(IDE)) {
 	hw_regs_t hw;
 	ide_hwif_t *hwif;
 
+	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
+		return 0;
+
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
-	ide_setup_ports(&hw, ATA_HD_BASE, falconide_offsets,
-			0, 0, NULL,
-//			falconide_iops,
-			IRQ_MFP_IDE);
+	falconide_setup_ports(&hw);
 
 	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif) {
@@ -85,9 +86,8 @@ static int __init falconide_init(void)
 
 		ide_device_add(idx, NULL);
 	}
-    }
 
-    return 0;
+	return 0;
 }
 
 module_init(falconide_init);
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -34,22 +34,8 @@
      *  Offsets from one of the above bases
      */
 
-#define GAYLE_DATA	0x00
-#define GAYLE_ERROR	0x06		/* see err-bits */
-#define GAYLE_NSECTOR	0x0a		/* nr of sectors to read/write */
-#define GAYLE_SECTOR	0x0e		/* starting sector */
-#define GAYLE_LCYL	0x12		/* starting cylinder */
-#define GAYLE_HCYL	0x16		/* high byte of starting cyl */
-#define GAYLE_SELECT	0x1a		/* 101dhhhh , d=drive, hhhh=head */
-#define GAYLE_STATUS	0x1e		/* see status-bits */
 #define GAYLE_CONTROL	0x101a
 
-static int gayle_offsets[IDE_NR_PORTS] __initdata = {
-    GAYLE_DATA, GAYLE_ERROR, GAYLE_NSECTOR, GAYLE_SECTOR, GAYLE_LCYL,
-    GAYLE_HCYL, GAYLE_SELECT, GAYLE_STATUS, -1, -1
-};
-
-
     /*
      *  These are at different offsets from the base
      */
@@ -106,6 +92,26 @@ static int gayle_ack_intr_a1200(ide_hwif
     return 1;
 }
 
+static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
+				     unsigned long ctl, unsigned long irq_port,
+				     ide_ack_intr_t *ack_intr);
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	hw->io_ports[IDE_DATA_OFFSET] = base;
+
+	for (i = 1; i < 8; i++)
+		hw->io_ports[i] = base + 2 + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
+	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+
+	hw->irq = IRQ_AMIGA_PORTS;
+	hw->ack_intr = ack_intr;
+}
+
     /*
      *  Probe for a Gayle IDE interface (and optionally for an IDE doubler)
      */
@@ -167,10 +173,7 @@ found:
 	base = (unsigned long)ZTWO_VADDR(phys_base);
 	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
 
-	ide_setup_ports(&hw, base, gayle_offsets,
-			ctrlport, irqport, ack_intr,
-//			&gayle_iops,
-			IRQ_AMIGA_PORTS);
+	gayle_setup_ports(&hw, base, ctrlport, irqport, ack_intr);
 
 	hwif = ide_find_port(base);
 	if (hwif) {
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -31,14 +31,6 @@
  * These match MkLinux so they should be correct.
  */
 
-#define IDE_DATA	0x00
-#define IDE_ERROR	0x04	/* see err-bits */
-#define IDE_NSECTOR	0x08	/* nr of sectors to read/write */
-#define IDE_SECTOR	0x0c	/* starting sector */
-#define IDE_LCYL	0x10	/* starting cylinder */
-#define IDE_HCYL	0x14	/* high byte of starting cyl */
-#define IDE_SELECT	0x18	/* 101dhhhh , d=drive, hhhh=head */
-#define IDE_STATUS	0x1c	/* see status-bits */
 #define IDE_CONTROL	0x38	/* control/altstatus */
 
 /*
@@ -63,11 +55,6 @@
 
 volatile unsigned char *ide_ifr = (unsigned char *) (IDE_BASE + IDE_IFR);
 
-static int macide_offsets[IDE_NR_PORTS] = {
-    IDE_DATA, IDE_ERROR,  IDE_NSECTOR, IDE_SECTOR, IDE_LCYL,
-    IDE_HCYL, IDE_SELECT, IDE_STATUS,  IDE_CONTROL
-};
-
 int macide_ack_intr(ide_hwif_t* hwif)
 {
 	if (*ide_ifr & 0x20) {
@@ -77,6 +64,22 @@ int macide_ack_intr(ide_hwif_t* hwif)
 	return 0;
 }
 
+static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
+				      int irq, ide_ack_intr_t *ack_intr)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	for (i = 0; i < 8; i++)
+		hw->io_ports[i] = base + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = IDE_CONTROL;
+
+	hw->irq = irq;
+	hw->ack_intr = ack_intr;
+}
+
 static const char *mac_ide_name[] =
 	{ "Quadra", "Powerbook", "Powerbook Baboon" };
 
@@ -86,27 +89,27 @@ static const char *mac_ide_name[] =
 
 static int __init macide_init(void)
 {
-	hw_regs_t hw;
 	ide_hwif_t *hwif;
+	ide_ack_intr_t *ack_intr;
+	unsigned long base;
+	int irq;
+	hw_regs_t hw;
 
 	switch (macintosh_config->ide_type) {
 	case MAC_IDE_QUADRA:
-		ide_setup_ports(&hw, IDE_BASE, macide_offsets,
-				0, 0, macide_ack_intr,
-//				quadra_ide_iops,
-				IRQ_NUBUS_F);
+		base = IDE_BASE;
+		ack_intr = macide_ack_intr;
+		irq = IRQ_NUBUS_F;
 		break;
 	case MAC_IDE_PB:
-		ide_setup_ports(&hw, IDE_BASE, macide_offsets,
-				0, 0, macide_ack_intr,
-//				macide_pb_iops,
-				IRQ_NUBUS_C);
+		base = IDE_BASE;
+		ack_intr = macide_ack_intr;
+		irq = IRQ_NUBUS_C;
 		break;
 	case MAC_IDE_BABOON:
-		ide_setup_ports(&hw, BABOON_BASE, macide_offsets,
-				0, 0, NULL,
-//				macide_baboon_iops,
-				IRQ_BABOON_1);
+		base = BABOON_BASE;
+		ack_intr = NULL;
+		irq = IRQ_BABOON_1;
 		break;
 	default:
 		return -ENODEV;
@@ -115,6 +118,8 @@ static int __init macide_init(void)
 	printk(KERN_INFO "ide: Macintosh %s IDE controller\n",
 			 mac_ide_name[macintosh_config->ide_type - 1]);
 
+	macide_setup_ports(&hw, base, irq, ack_intr);
+
 	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif) {
 		u8 index = hwif->index;
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -66,16 +66,12 @@ static int q40ide_default_irq(unsigned l
 
 
 /*
- * This is very similar to ide_setup_ports except that addresses
- * are pretranslated for q40 ISA access
+ * Addresses are pretranslated for Q40 ISA access.
  */
 void q40_ide_setup_ports ( hw_regs_t *hw,
 			unsigned long base, int *offsets,
 			unsigned long ctrl, unsigned long intr,
 			ide_ack_intr_t *ack_intr,
-/*
- *			ide_io_ops_t *iops,
- */
 			int irq)
 {
 	int i;
@@ -92,9 +88,6 @@ void q40_ide_setup_ports ( hw_regs_t *hw
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
-/*
- *	hw->iops = iops;
- */
 }
 
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -194,17 +194,6 @@ struct ide_drive_s;
 int ide_register_hw(hw_regs_t *, void (*)(struct ide_drive_s *),
 		    struct hwif_s **);
 
-void ide_setup_ports(	hw_regs_t *hw,
-			unsigned long base,
-			int *offsets,
-			unsigned long ctrl,
-			unsigned long intr,
-			ide_ack_intr_t *ack_intr,
-#if 0
-			ide_io_ops_t *iops,
-#endif
-			int irq);
-
 static inline void ide_std_init_ports(hw_regs_t *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
