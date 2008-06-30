Return-Path: <linux-kernel-owner+w=401wt.eu-S1763779AbYF3SUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763779AbYF3SUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763544AbYF3SUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:20:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:7105 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763219AbYF3SUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :content-type:content-transfer-encoding:message-id;
        b=ZNP6H/Ok9NT3hPc7pHMgtSPgQt1jgGNgWNgBn7uEgLg60Hnd2JYZfV2T/dnoqWAVud
         QD5teGwu+jGd0nEek9lRZzjn1WuyT8+9BhwPOEp6zzCu2UaJepliMh0RQT/H/3kEvT5J
         pf/KX7sOHOUMlbXVbeACNWHCut8nq/3W7Fqqs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 30 Jun 2008 20:21:22 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806302021.23969.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

* bast-ide removal was premature, bring it back
  (thanks to Russell King for noticing it)

* /proc/ide/ide?/mate needs a "warm-plug compliance" fix


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig        |    7 +++
 drivers/ide/arm/Makefile   |    1 +
 drivers/ide/arm/bast-ide.c |   90 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-proc.c     |    2 +-
 4 files changed, 99 insertions(+), 1 deletions(-)
 create mode 100644 drivers/ide/arm/bast-ide.c


Bartlomiej Zolnierkiewicz (2):
      Revert "BAST: Remove old IDE driver"
      ide: fix /proc/ide/ide?/mate reporting


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 8e07de2..1607536 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -823,6 +823,13 @@ config BLK_DEV_IDE_RAPIDE
 	  Say Y here if you want to support the Yellowstone RapIDE controller
 	  manufactured for use with Acorn computers.
 
+config BLK_DEV_IDE_BAST
+	tristate "Simtec BAST / Thorcom VR1000 IDE support"
+	depends on ARM && (ARCH_BAST || MACH_VR1000)
+	help
+	  Say Y here if you want to support the onboard IDE channels on the
+	  Simtec BAST or the Thorcom VR1000
+
 config IDE_H8300
 	tristate "H8300 IDE support"
 	depends on H8300
diff --git a/drivers/ide/arm/Makefile b/drivers/ide/arm/Makefile
index 5bc2605..936e7b0 100644
--- a/drivers/ide/arm/Makefile
+++ b/drivers/ide/arm/Makefile
@@ -1,6 +1,7 @@
 
 obj-$(CONFIG_BLK_DEV_IDE_ICSIDE)	+= icside.o
 obj-$(CONFIG_BLK_DEV_IDE_RAPIDE)	+= rapide.o
+obj-$(CONFIG_BLK_DEV_IDE_BAST)		+= bast-ide.o
 obj-$(CONFIG_BLK_DEV_PALMCHIP_BK3710)	+= palm_bk3710.o
 
 ifeq ($(CONFIG_IDE_ARM), m)
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
new file mode 100644
index 0000000..8e8c281
--- /dev/null
+++ b/drivers/ide/arm/bast-ide.c
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2003-2004 Simtec Electronics
+ *  Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#include <asm/mach-types.h>
+
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/arch/map.h>
+#include <asm/arch/bast-map.h>
+#include <asm/arch/bast-irq.h>
+
+#define DRV_NAME "bast-ide"
+
+static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
+{
+	ide_hwif_t *hwif;
+	hw_regs_t hw;
+	int i;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
+	memset(&hw, 0, sizeof(hw));
+
+	base += BAST_IDE_CS;
+	aux  += BAST_IDE_CS;
+
+	for (i = 0; i <= 7; i++) {
+		hw.io_ports_array[i] = (unsigned long)base;
+		base += 0x20;
+	}
+
+	hw.io_ports.ctl_addr = aux + (6 * 0x20);
+	hw.irq = irq;
+	hw.chipset = ide_generic;
+
+	hwif = ide_find_port();
+	if (hwif == NULL)
+		goto out;
+
+	i = hwif->index;
+
+	ide_init_port_data(hwif, i);
+	ide_init_port_hw(hwif, &hw);
+	hwif->port_ops = NULL;
+
+	idx[0] = i;
+
+	ide_device_add(idx, NULL);
+out:
+	return 0;
+}
+
+static int __init bastide_init(void)
+{
+	unsigned long base = BAST_VA_IDEPRI + BAST_IDE_CS;
+
+	/* we can treat the VR1000 and the BAST the same */
+
+	if (!(machine_is_bast() || machine_is_vr1000()))
+		return 0;
+
+	printk("BAST: IDE driver, (c) 2003-2004 Simtec Electronics\n");
+
+	if (!request_mem_region(base, 0x400000, DRV_NAME)) {
+		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+		return -EBUSY;
+	}
+
+	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0);
+	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1);
+
+	return 0;
+}
+
+module_init(bastide_init);
+
+MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Simtec BAST / Thorcom VR1000 IDE driver");
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 55ec7f7..8af88bf 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -76,7 +76,7 @@ static int proc_ide_read_mate
 	ide_hwif_t	*hwif = (ide_hwif_t *) data;
 	int		len;
 
-	if (hwif && hwif->mate && hwif->mate->present)
+	if (hwif && hwif->mate)
 		len = sprintf(page, "%s\n", hwif->mate->name);
 	else
 		len = sprintf(page, "(none)\n");
