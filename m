Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYLFHiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYLFHiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYLFHhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:37:50 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:3523 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYLFHhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:message-id:date:from;
        b=ijKOgRVShbE80Ql6t0o8nXPPGQOPM5Rh+T1Lm1b8Zr2RXwhdFUiQNcKRQWCUA2sRvb
         1OAwWJ9JrLzryjWJJ30jKQOL3c5uGwuB3MPuYvhQpAIwrpSZCdqdXAEsXvhghLCFh85Y
         2kr6KkoHhejiQHiV+tRTGoIWEkJLRQP/aoZro=
To: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       sshtylyov@ru.mvista.com
Subject: [PATCHv2] Resurrect IT8172 IDE controller driver
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L8rjT-0008GS-4B@localhost>
Date: Sat, 06 Dec 2008 01:37:43 -0600
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
driver on a PMC-Sierra Xiao Hu board with the 2.6.28-rc7 kernel, and
I have had no problems with it in my configuration.  The attached patch
applies cleanly against 2.6.28-rc7.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
---
 drivers/ide/Kconfig     |    7 +
 drivers/ide/Makefile    |    1 
 drivers/ide/it8172.c    |  177 ++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    1 
 4 files changed, 186 insertions(+)

diff -uprN a/drivers/ide/Kconfig b/drivers/ide/Kconfig
--- a/drivers/ide/Kconfig	2008-12-06 01:15:52.000000000 -0600
+++ b/drivers/ide/Kconfig	2008-12-06 01:17:25.000000000 -0600
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
--- a/drivers/ide/Makefile	2008-12-06 01:16:07.000000000 -0600
+++ b/drivers/ide/Makefile	2008-12-06 01:17:39.000000000 -0600
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
+++ b/drivers/ide/it8172.c	2008-12-06 01:17:57.000000000 -0600
@@ -0,0 +1,177 @@
+/*
+ *
+ * BRIEF MODULE DESCRIPTION
+ *      IT8172 IDE controller support
+ *
+ * Copyright (C) 2000 MontaVista Software Inc.
+ * Copyright (C) 2008 Shane McDonald
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
+static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	int is_slave		= drive->dn & 1;
+	u16 drive_enables;
+	u32 drive_timing;
+
+	pci_read_config_word(dev, 0x40, &drive_enables);
+	pci_read_config_dword(dev, 0x44, &drive_timing);
+
+	/*
+	 * FIXME: The DIOR/DIOW pulse width and recovery times in port 0x44
+	 * are being left at the default values of 8 PCI clocks (240 nsec
+	 * for a 33 MHz clock). These can be safely shortened at higher
+	 * PIO modes. The DIOR/DIOW pulse width and recovery times only
+	 * apply to PIO modes and SW/MW DMA modes, not to the UDMA modes.
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
+		if (drive->media == ide_disk)
+			/* enable prefetch */
+			drive_enables |= 0x0040;
+		if (pio > 2 || ata_id_has_iordy(drive->id))
+			/* enable IORDY sample-point */
+			drive_enables |= 0x0020;
+	} else {
+		drive_enables &= 0xc060;
+		if (drive->media == ide_disk)
+			/* enable prefetch */
+			drive_enables |= 0x0004;
+		if (pio > 2 || ata_id_has_iordy(drive->id))
+			/* enable IORDY sample-point */
+			drive_enables |= 0x0002;
+	}
+
+	pci_write_config_word(dev, 0x40, drive_enables);
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
+	pci_read_config_byte(dev, 0x48, &reg48);
+	pci_read_config_byte(dev, 0x4a, &reg4a);
+
+	if (speed >= XFER_UDMA_0) {
+		u8 udma = speed - XFER_UDMA_0;
+		u_speed = min_t(u8, 2 - (udma & 1), udma) << (drive->dn * 4);
+
+		pci_write_config_byte(dev, 0x48, reg48 | u_flag);
+		reg4a &= ~a_speed;
+		pci_write_config_byte(dev, 0x4a, reg4a | u_speed);
+	} else {
+		const u8 mwdma_to_pio[] = { 0, 3, 4 };
+		u8 pio;
+
+		pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
+		pci_write_config_byte(dev, 0x4a, reg4a & ~a_speed);
+
+		if (speed >= XFER_MW_DMA_0)
+			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+		else
+			pio = 2;
+
+		it8172_set_pio_mode(drive, pio);
+	}
+}
+
+
+static const struct ide_port_ops it8172_port_ops = {
+	.set_pio_mode	= it8172_set_pio_mode,
+	.set_dma_mode	= it8172_set_dma_mode,
+};
+
+static const struct ide_port_info it8172_port_info __devinitdata = {
+	.name		= DRV_NAME,
+	.port_ops	= &it8172_port_ops,
+	.enablebits	= {{0x41, 0x80, 0x80}, {0x00, 0x00, 0x00} },
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4 & ~ATA_PIO0,
+	.swdma_mask	= ATA_SWDMA2,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA2,
+};
+
+static int __devinit it8172_init_one(struct pci_dev *dev,
+					const struct pci_device_id *id)
+{
+	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
+		return -ENODEV; /* IT8172 is more than an IDE controller */
+	return ide_pci_init_one(dev, &it8172_port_info, NULL);
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
+MODULE_AUTHOR("Shane McDonald");
+MODULE_DESCRIPTION("PCI driver module for ITE 8172 IDE");
+MODULE_LICENSE("GPL");
diff -uprN a/include/linux/pci_ids.h b/include/linux/pci_ids.h
--- a/include/linux/pci_ids.h	2008-12-06 01:16:57.000000000 -0600
+++ b/include/linux/pci_ids.h	2008-12-06 01:18:12.000000000 -0600
@@ -1658,6 +1658,7 @@
 #define PCI_VENDOR_ID_ROCKWELL		0x127A
 
 #define PCI_VENDOR_ID_ITE		0x1283
+#define PCI_DEVICE_ID_ITE_8172		0x8172
 #define PCI_DEVICE_ID_ITE_8211		0x8211
 #define PCI_DEVICE_ID_ITE_8212		0x8212
 #define PCI_DEVICE_ID_ITE_8213		0x8213
