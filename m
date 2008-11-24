Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbYKXGVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbYKXGVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKXGVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:21:39 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:52256 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKXGVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:message-id:date:from;
        b=VEUyOFTam6vmAr8W/fur4inWWvUjaAXl+edoHTvwfbL+9tT+cTjhSsv4hQs9T3LvJk
         aSNa9igGuBhatRBBJ3+wF21kio5rRPddpCg6GNGNX5qIAKNFMeOgI4YivbCX7cg+8Qd+
         H2o1Ppo7R8IOybe7Tra8JFTOoUZ5cgVZeveao=
To: bzolnier@gmail.com, linux-ide@vger.kernel.org
Subject: [PATCH] Resurrect IT8172 IDE controller driver
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L4UpB-0007ro-1g@localhost>
Date: Mon, 24 Nov 2008 00:21:33 -0600
From: Shane McDonald <mcdonald.shane@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the IT8172 IDE controller was removed from the kernel
sometime after 2.6.18.  Support for the only boards that used the IT8172
was removed from the kernel after 2.6.18, as they had never compiled
since 2.6.0.  However, there are a couple of platforms that use this
chip: the PMC-Sierra Xiao Hu thin-client computer, which is no longer
in production, and the Linksys NSS4000 Network Attached Storage box,
which is based on the Xiao Hu board.  I am attempting to add support
for the Xiao Hu to the kernel, and this IT8172 IDE controller is the
first bit of code in this effort.

This patch resurrects the IT8172 IDE controller code.  I began with
the 2.6.18 version of the it8172.c file, and have moved it forward so
that it works with the latest version of the kernel.  I have run this
driver on a PMC-Sierra Xiao Hu board with the 2.6.28-rc6 kernel, and
I have had no problems with it in my configuration.  The attached patch
applies cleanly against 2.6.28-rc6.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
---
 drivers/ide/Kconfig     |    7 +
 drivers/ide/Makefile    |    1 
 drivers/ide/it8172.c    |  205 ++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    1 
 4 files changed, 214 insertions(+)

diff -uprN a/drivers/ide/Kconfig b/drivers/ide/Kconfig
--- a/drivers/ide/Kconfig	2008-11-23 00:53:23.000000000 -0600
+++ b/drivers/ide/Kconfig	2008-11-23 00:54:13.000000000 -0600
@@ -524,6 +524,13 @@ config BLK_DEV_PIIX
 	  This allows the kernel to change PIO, DMA and UDMA speeds and to
 	  configure the chip to optimum performance.
 
+config BLK_DEV_IT8172
+	tristate "IT8172 IDE support"
+	select BLK_DEV_IDEDMA_PCI
+	help
+	  This driver adds support for the IDE controller on the
+	  IT8172 System Controller.
+
 config BLK_DEV_IT8213
 	tristate "IT8213 IDE support"
 	select BLK_DEV_IDEDMA_PCI
diff -uprN a/drivers/ide/Makefile b/drivers/ide/Makefile
--- a/drivers/ide/Makefile	2008-11-23 00:53:23.000000000 -0600
+++ b/drivers/ide/Makefile	2008-11-23 00:54:13.000000000 -0600
@@ -46,6 +46,7 @@ obj-$(CONFIG_BLK_DEV_SC1200)		+= sc1200.
 obj-$(CONFIG_BLK_DEV_CY82C693)		+= cy82c693.o
 obj-$(CONFIG_BLK_DEV_DELKIN)		+= delkin_cb.o
 obj-$(CONFIG_BLK_DEV_HPT366)		+= hpt366.o
+obj-$(CONFIG_BLK_DEV_IT8172)		+= it8172.o
 obj-$(CONFIG_BLK_DEV_IT8213)		+= it8213.o
 obj-$(CONFIG_BLK_DEV_IT821X)		+= it821x.o
 obj-$(CONFIG_BLK_DEV_JMICRON)		+= jmicron.o
diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
--- a/drivers/ide/it8172.c	1969-12-31 18:00:00.000000000 -0600
+++ b/drivers/ide/it8172.c	2008-11-23 01:06:01.000000000 -0600
@@ -0,0 +1,205 @@
+/*
+ *
+ * BRIEF MODULE DESCRIPTION
+ *      IT8172 IDE controller support
+ *
+ * Copyright 2000 MontaVista Software Inc.
+ * Author: MontaVista Software, Inc.
+ *              stevel@mvista.com or source@mvista.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#define DRV_NAME "IT8172"
+
+/*
+ * Prototypes
+ */
+
+static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	int is_slave		= (&hwif->drives[1] == drive);
+	unsigned long flags;
+	u16 drive_enables;
+	u32 drive_timing;
+
+	spin_lock_irqsave(&ide_lock, flags);
+	pci_read_config_word(dev, 0x40, &drive_enables);
+	pci_read_config_dword(dev, 0x44, &drive_timing);
+
+	/*
+	 * FIX! The DIOR/DIOW pulse width and recovery times in port 0x44
+	 * are being left at the default values of 8 PCI clocks (242 nsec
+	 * for a 33 MHz clock). These can be safely shortened at higher
+	 * PIO modes. The DIOR/DIOW pulse width and recovery times only
+	 * apply to PIO modes, not to the DMA modes.
+	 */
+
+	/*
+	 * Enable port 0x44. The IT8172 spec is confused; it calls
+	 * this register the "Slave IDE Timing Register", but in fact,
+	 * it controls timing for both master and slave drives.
+	 */
+	drive_enables |= 0x4000;
+
+	if (is_slave) {
+		drive_enables &= 0xc006;
+		if (pio > 1)
+			/* enable prefetch and IORDY sample-point */
+			drive_enables |= 0x0060;
+	} else {
+		drive_enables &= 0xc060;
+		if (pio > 1)
+			/* enable prefetch and IORDY sample-point */
+			drive_enables |= 0x0006;
+	}
+
+	pci_write_config_word(dev, 0x40, drive_enables);
+	spin_unlock_irqrestore(&ide_lock, flags);
+}
+
+static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	int a_speed		= 3 << (drive->dn * 4);
+	int u_flag		= 1 << drive->dn;
+	int u_speed		= 0;
+	u8 reg48, reg4a;
+
+	const u8 mwdma_to_pio[] = { 0, 3, 4 };
+	u8 pio;
+
+	pci_read_config_byte(dev, 0x48, &reg48);
+	pci_read_config_byte(dev, 0x4a, &reg4a);
+
+	if (speed >= XFER_UDMA_0) {
+
+		/* Setting the DMA cycle time to 2 or 3 PCI clocks
+		 * (60 and 91 nsec at 33 MHz PCI clock) seems to cause
+		 * BadCRC errors during DMA transfers on some drives,
+		 * even though both numbers meet the minimum ATAPI-4 spec
+		 * of 73 and 54 nsec for UDMA 1 and 2 respectively.
+		 * So the faster times are not implemented here.
+		 * The good news is that the slower cycle time has
+		 * very little affect on transfer performance.
+		 */
+
+		u_speed = 0 << (drive->dn * 4);
+
+		pci_write_config_byte(dev, 0x48, reg48 | u_flag);
+		reg4a &= ~a_speed;
+		pci_write_config_byte(dev, 0x4a, reg4a | u_speed);
+	} else {
+		pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
+		pci_write_config_byte(dev, 0x4a, reg4a & ~a_speed);
+	}
+
+	if (speed >= XFER_MW_DMA_0)
+		pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+	else
+		pio = 2;
+
+	it8172_set_pio_mode(drive, pio);
+}
+
+
+static unsigned int __devinit init_chipset_it8172(struct pci_dev *dev)
+{
+	unsigned char progif;
+
+	/*
+	 * Place both IDE interfaces into PCI "native" mode
+	 */
+	pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
+	pci_write_config_byte(dev, PCI_CLASS_PROG, progif | 0x05);
+
+	return dev->irq;
+}
+
+
+static const struct ide_port_ops it8172_port_ops = {
+	.set_pio_mode	= it8172_set_pio_mode,
+	.set_dma_mode	= it8172_set_dma_mode,
+};
+
+static const struct ide_port_info it8172_chipset __devinitdata = {
+	.name		= DRV_NAME,
+	.init_chipset	= init_chipset_it8172,
+	.port_ops	= &it8172_port_ops,
+	.enablebits	= {{0x00, 0x00, 0x00}, {0x40, 0x00, 0x01} },
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4,
+	.swdma_mask	= ATA_SWDMA2_ONLY,
+	.mwdma_mask	= ATA_MWDMA12_ONLY,
+	.udma_mask	= ATA_UDMA2,
+};
+
+static int __devinit it8172_init_one(struct pci_dev *dev,
+					const struct pci_device_id *id)
+{
+	if ((!(PCI_FUNC(dev->devfn) & 1) ||
+		(!((dev->class >> 8) == PCI_CLASS_STORAGE_IDE))))
+		return -ENODEV; /* IT8172 is more than an IDE controller */
+	return ide_pci_init_one(dev, &it8172_chipset, NULL);
+}
+
+static struct pci_device_id it8172_pci_tbl[] = {
+	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8172), 0 },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, it8172_pci_tbl);
+
+static struct pci_driver it8172_pci_driver = {
+	.name		= "IT8172_IDE",
+	.id_table	= it8172_pci_tbl,
+	.probe		= it8172_init_one,
+	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+};
+
+static int __init it8172_ide_init(void)
+{
+	return ide_pci_register_driver(&it8172_pci_driver);
+}
+
+static void __exit it8172_ide_exit(void)
+{
+	pci_unregister_driver(&it8172_pci_driver);
+}
+
+module_init(it8172_ide_init);
+module_exit(it8172_ide_exit);
+
+MODULE_AUTHOR("SteveL@mvista.com");
+MODULE_DESCRIPTION("PCI driver module for ITE 8172 IDE");
+MODULE_LICENSE("GPL");
diff -uprN a/include/linux/pci_ids.h b/include/linux/pci_ids.h
--- a/include/linux/pci_ids.h	2008-11-23 00:53:41.000000000 -0600
+++ b/include/linux/pci_ids.h	2008-11-23 01:03:59.000000000 -0600
@@ -1658,6 +1658,7 @@
 #define PCI_VENDOR_ID_ROCKWELL		0x127A
 
 #define PCI_VENDOR_ID_ITE		0x1283
+#define PCI_DEVICE_ID_ITE_8172		0x8172
 #define PCI_DEVICE_ID_ITE_8211		0x8211
 #define PCI_DEVICE_ID_ITE_8212		0x8212
 #define PCI_DEVICE_ID_ITE_8213		0x8213
