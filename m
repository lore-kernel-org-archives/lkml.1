Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYBPQZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYBPQZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbYBPQYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:24:41 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:40552 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963AbYBPQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tD2CP2DSqCKUtuv15w2cFVFFEUmz2eM2I8Xv3AYgcf/NH11i3dEjI3wEE8nKJURUkCzx60e+ZhvtjD38K9My3G2vRF1D3prrhLn3va79JsBNgEzmY9MrXA6lnuKoNpOYohQFQk0mCZHQ9hdWR26O3A2hfnkEtZsQ5Hw6MAr08x4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 17:39:11 +0100
Message-Id: <20080216163911.10174.58246.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/12] ide: add ide-4drives host driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_BLK_DEV_4DRIVES deserves its own host driver:

* Add drivers/ide/legacy/ide-4drives.c and move "4drives" support there.

* Add ide-4drives.o in the link order after all other legacy host
  drivers enabled by "ide0=" options (they all are mutually exclusive).

* Make ide-4drives host driver probe itself for IDE devices instead of
  indirectly depending on ide_generic host driver.

* Add "probe" module parameter to ide-4drives and update documentation.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide.txt            |    5 ++--
 drivers/ide/Kconfig              |    4 +--
 drivers/ide/ide.c                |   15 ++----------
 drivers/ide/legacy/Makefile      |    1 
 drivers/ide/legacy/ide-4drives.c |   46 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 55 insertions(+), 16 deletions(-)

Index: b/Documentation/ide.txt
===================================================================
--- a/Documentation/ide.txt
+++ b/Documentation/ide.txt
@@ -242,8 +242,6 @@ Summary of ide driver parameters for ker
 			  both the respective primary and secondary channel
 			  to take effect.
 
- "idex=four"		: four drives on idex and ide(x^1) share same ports
-			
  "idex=reset"		: reset interface after probe
 
  "idex=ata66"		: informs the interface that it has an 80c cable
@@ -276,6 +274,9 @@ Also for legacy CMD640 host driver (cmd6
 kernel paremeter to enable probing for VLB version of the chipset (PCI ones
 are detected automatically).
 
+You also need to use "probe" kernel paramater for ide-4drives driver
+(support for IDE generic chipset with four drives on one port).
+
 ================================================================================
 
 IDE ATAPI streaming tape driver
Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1042,8 +1042,8 @@ config BLK_DEV_4DRIVES
 	  Certain older chipsets, including the Tekram 690CD, use a single set
 	  of I/O ports at 0x1f0 to control up to four drives, instead of the
 	  customary two drives per port. Support for this can be enabled at
-	  runtime using the "ide0=four" kernel boot parameter if you say Y
-	  here.
+	  runtime using the "ide_4drives.probe" kernel boot parameter if you
+	  say Y here.
 
 config BLK_DEV_ALI14XX
 	tristate "ALI M14xx support"
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -989,6 +989,7 @@ extern int probe_dtc2278;
 extern int probe_ht6560b;
 extern int probe_qd65xx;
 extern int cmd640_vlb;
+extern int probe_4drives;
 
 static int __initdata is_chipset_set[MAX_HWIFS];
 
@@ -1213,19 +1214,9 @@ static int __init ide_setup(char *s)
 #endif
 #ifdef CONFIG_BLK_DEV_4DRIVES
 			case -11: /* "four" drives on one set of ports */
-			{
-				ide_hwif_t *mate = &ide_hwifs[hw^1];
-				mate->drives[0].select.all ^= 0x20;
-				mate->drives[1].select.all ^= 0x20;
-				hwif->chipset = mate->chipset = ide_4drives;
-				mate->irq = hwif->irq;
-				memcpy(mate->io_ports, hwif->io_ports, sizeof(hwif->io_ports));
-				hwif->mate = mate;
-				mate->mate = hwif;
-				hwif->serialized = mate->serialized = 1;
+				probe_4drives = 1;
 				goto obsolete_option;
-			}
-#endif /* CONFIG_BLK_DEV_4DRIVES */
+#endif
 			case -10: /* minus10 */
 			case -9: /* minus9 */
 			case -8: /* minus8 */
Index: b/drivers/ide/legacy/Makefile
===================================================================
--- a/drivers/ide/legacy/Makefile
+++ b/drivers/ide/legacy/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc867
 obj-$(CONFIG_BLK_DEV_DTC2278)		+= dtc2278.o
 obj-$(CONFIG_BLK_DEV_HT6560B)		+= ht6560b.o
 obj-$(CONFIG_BLK_DEV_QD65XX)		+= qd65xx.o
+obj-$(CONFIG_BLK_DEV_4DRIVES)		+= ide-4drives.o
 
 obj-$(CONFIG_BLK_DEV_GAYLE)		+= gayle.o
 obj-$(CONFIG_BLK_DEV_FALCON_IDE)	+= falconide.o
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- /dev/null
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -0,0 +1,46 @@
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/ide.h>
+
+int probe_4drives = 0;
+
+module_param_named(probe, probe_4drives, bool, 0);
+MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
+
+static int __init ide_4drives_init(void)
+{
+	ide_hwif_t *hwif, *mate;
+	u8 idx[4] = { 0, 1, 0xff, 0xff };
+
+	if (probe_4drives == 0)
+		return -ENODEV;
+
+	hwif = &ide_hwifs[0];
+	mate = &ide_hwifs[1];
+
+	memcpy(mate->io_ports, hwif->io_ports, sizeof(hwif->io_ports));
+
+	mate->irq = hwif->irq;
+
+	mate->chipset = hwif->chipset = ide_4drives;
+
+	mate->drives[0].select.all ^= 0x20;
+	mate->drives[1].select.all ^= 0x20;
+
+	hwif->mate = mate;
+	mate->mate = hwif;
+
+	hwif->serialized = mate->serialized = 1;
+
+	ide_device_add(idx, NULL);
+
+	return 0;
+}
+
+module_init(ide_4drives_init);
+
+MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
+MODULE_DESCRIPTION("generic IDE chipset with 4 drives/port support");
+MODULE_LICENSE("GPL");
