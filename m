Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYFJTVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYFJTVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYFJTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:21:13 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:22406 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbYFJTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=EwH/KIiPzW3p7nq6IrJgsPdLan5xlRQifnGv0K1WsRfK7fd9XmSN3r5Nd2FekZS21f
         XVL3Qy5DWXxF9I1SRpDM8AfgIta7ckG7gLZvbn51x9ya/oIGDFY/77XmAAINg9hzWPfU
         /A2uOGUT85hAODlcbW6Aolht12AtDyi9ToR34=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 10 Jun 2008 21:16:42 +0200
Message-Id: <200806102116.42861.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Pretty obvious stuff: fix for recent regression in few legacy
host drivers, build fixes from Adrian for ide-4drives/hd, various
delkin_cb fixes and palm_bk3710 warm-plug fix...


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 MAINTAINERS                    |    7 -------
 drivers/ide/Kconfig            |    1 +
 drivers/ide/arm/bast-ide.c     |    1 +
 drivers/ide/arm/ide_arm.c      |    1 +
 drivers/ide/arm/palm_bk3710.c  |    3 ---
 drivers/ide/ide-generic.c      |    1 +
 drivers/ide/ide-pnp.c          |    1 +
 drivers/ide/ide-probe.c        |    6 +++---
 drivers/ide/ide-proc.c         |    1 -
 drivers/ide/legacy/buddha.c    |    2 ++
 drivers/ide/legacy/falconide.c |    2 ++
 drivers/ide/legacy/gayle.c     |    6 ++++++
 drivers/ide/legacy/macide.c    |    2 ++
 drivers/ide/legacy/q40ide.c    |    2 ++
 drivers/ide/pci/cmd640.c       |    2 ++
 drivers/ide/pci/delkin_cb.c    |   28 +++++++++++-----------------
 drivers/ide/pci/sis5513.c      |    5 +++++
 drivers/ide/ppc/mpc8xx.c       |    4 ++++
 include/linux/ide.h            |    2 +-
 19 files changed, 45 insertions(+), 32 deletions(-)


Adrian Bunk (4):
      ide: remove the ide_etrax100 chipset type
      MAINTAINERS: remove SIS 5513 IDE entry
      ide: export ide_doubler
      fix BLK_DEV_HD_ONLY on ARM dependencies

Bartlomiej Zolnierkiewicz (8):
      sis5513: add missing pci_enable_device() call
      ide-generic: add missing hwif->chipset setup
      ide: fix host drivers missing hwif->chipset initialization
      delkin_cb: set proper hwif->gendev.parent value
      delkin_cb: use struct ide_port_info
      delkin_cb: add warm-plug support
      delkin_cb: add missing __init/__exit tags
      palm_bk3710: add warm-plug support


diff --git a/MAINTAINERS b/MAINTAINERS
index cb71eb4..e3560df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3658,13 +3658,6 @@ M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-SIS 5513 IDE CONTROLLER DRIVER
-P:	Lionel Bouton
-M:	Lionel.Bouton@inet6.fr
-W:	http://inet6.dyn.dhs.org/sponsoring/sis5513/index.html
-W:	http://gyver.homeip.net/sis5513/index.html
-S:	Maintained
-
 SIS 900/7016 FAST ETHERNET DRIVER
 P:	Daniele Venzano
 M:	venza@brownhat.org
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index b4f3aef..1607536 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1028,6 +1028,7 @@ endif
 
 config BLK_DEV_HD_ONLY
 	bool "Old hard disk (MFM/RLL/IDE) driver"
+	depends on !ARM || ARCH_RPC || ARCH_SHARK || BROKEN
 	help
 	  There are two drivers for MFM/RLL/IDE hard disks. Most people use
 	  the newer enhanced driver, but this old one is still around for two
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index 713cef2..8e8c281 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -42,6 +42,7 @@ static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 
 	hw.io_ports.ctl_addr = aux + (6 * 0x20);
 	hw.irq = irq;
+	hw.chipset = ide_generic;
 
 	hwif = ide_find_port();
 	if (hwif == NULL)
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index 4263ffd..2f311da 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -49,6 +49,7 @@ static int __init ide_arm_init(void)
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = IDE_ARM_IRQ;
+	hw.chipset = ide_generic;
 
 	hwif = ide_find_port();
 	if (hwif) {
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 96378eb..d024ac8 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -409,9 +409,6 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 
 	ide_device_add(idx, &palm_bk3710_port_info);
 
-	if (!hwif->present)
-		goto out;
-
 	return 0;
 out:
 	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index a6073e2..9134488 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -125,6 +125,7 @@ static int __init ide_generic_init(void)
 			memset(&hw, 0, sizeof(hw));
 			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 			hw.irq = ide_default_irq(io_addr);
+			hw.chipset = ide_generic;
 			ide_init_port_hw(hwif, &hw);
 
 			idx[i] = i;
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 6a8953f..adbd017 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -55,6 +55,7 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = pnp_irq(dev, 0);
+	hw.chipset = ide_generic;
 
 	hwif = ide_find_port();
 	if (hwif) {
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 655ec7e..380fa0c 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1333,8 +1333,7 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 			  const struct ide_port_info *d)
 {
-	if (d->chipset != ide_etrax100)
-		hwif->channel = port;
+	hwif->channel = port;
 
 	if (d->chipset)
 		hwif->chipset = d->chipset;
@@ -1519,7 +1518,7 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 			continue;
 		}
 
-		if (d->chipset != ide_etrax100 && (i & 1) && mate) {
+		if ((i & 1) && mate) {
 			hwif->mate = mate;
 			mate->mate = hwif;
 		}
@@ -1665,6 +1664,7 @@ static void ide_legacy_init_one(u8 *idx, hw_regs_t *hw, u8 port_no,
 
 	ide_std_init_ports(hw, base, ctl);
 	hw->irq = irq;
+	hw->chipset = d->chipset;
 
 	hwif = ide_find_port_slot(d);
 	if (hwif) {
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 8d6ad81..55ec7f7 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -63,7 +63,6 @@ static int proc_ide_read_imodel
 	case ide_pmac:		name = "mac-io";	break;
 	case ide_au1xxx:	name = "au1xxx";	break;
 	case ide_palm3710:      name = "palm3710";      break;
-	case ide_etrax100:	name = "etrax100";	break;
 	case ide_acorn:		name = "acorn";		break;
 	default:		name = "(unknown)";	break;
 	}
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 5c730e4..9a1d27e 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -138,6 +138,8 @@ static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
     /*
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 9e449a0..af11028 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -81,6 +81,8 @@ static void __init falconide_setup_ports(hw_regs_t *hw)
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
+
+	hw->chipset = ide_generic;
 }
 
     /*
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index a9c2593..fed7d81 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -16,6 +16,7 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/zorro.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/amigahw.h>
@@ -62,7 +63,10 @@
 					       GAYLE_NUM_HWIFS-1)
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
 #define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
+
 int ide_doubler = 0;	/* support IDE doublers? */
+EXPORT_SYMBOL_GPL(ide_doubler);
+
 module_param_named(doubler, ide_doubler, bool, 0);
 MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */
@@ -112,6 +116,8 @@ static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
     /*
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index caa2632..2e84290 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -78,6 +78,8 @@ static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
 static const char *mac_ide_name[] =
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 6f535d0..8ff6e2d 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -70,6 +70,8 @@ static void q40_ide_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
 static void q40ide_input_data(ide_drive_t *drive, struct request *rq,
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index aaf3810..b38a198 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -747,9 +747,11 @@ static int __init cmd640x_init(void)
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
 	hw[0].irq = 14;
+	hw[0].chipset = ide_cmd640;
 
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
+	hw[1].chipset = ide_cmd640;
 
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index b9e4579..af0f300 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -47,13 +47,18 @@ static const struct ide_port_ops delkin_cb_port_ops = {
 	.quirkproc		= ide_undecoded_slave,
 };
 
+static const struct ide_port_info delkin_cb_port_info = {
+	.port_ops		= &delkin_cb_port_ops,
+	.host_flags		= IDE_HFLAG_IO_32BIT | IDE_HFLAG_UNMASK_IRQS |
+				  IDE_HFLAG_NO_DMA,
+};
+
 static int __devinit
 delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 {
 	unsigned long base;
 	hw_regs_t hw;
 	ide_hwif_t *hwif = NULL;
-	ide_drive_t *drive;
 	int i, rc;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
@@ -79,6 +84,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base + 0x10, base + 0x1e);
 	hw.irq = dev->irq;
+	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
 	hwif = ide_find_port();
@@ -89,26 +95,16 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 
 	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
-	hwif->port_ops = &delkin_cb_port_ops;
 
 	idx[0] = i;
 
-	ide_device_add(idx, NULL);
-
-	if (!hwif->present)
-		goto out_disable;
+	ide_device_add(idx, &delkin_cb_port_info);
 
 	pci_set_drvdata(dev, hwif);
-	hwif->dev = &dev->dev;
-	drive = &hwif->drives[0];
-	if (drive->present) {
-		drive->io_32bit = 1;
-		drive->unmask   = 1;
-	}
+
 	return 0;
 
 out_disable:
-	printk(KERN_ERR "delkin_cb: no IDE devices found\n");
 	pci_release_regions(dev);
 	pci_disable_device(dev);
 	return -ENODEV;
@@ -139,14 +135,12 @@ static struct pci_driver driver = {
 	.remove		= delkin_cb_remove,
 };
 
-static int
-delkin_cb_init (void)
+static int __init delkin_cb_init(void)
 {
 	return pci_register_driver(&driver);
 }
 
-static void
-delkin_cb_exit (void)
+static void __exit delkin_cb_exit(void)
 {
 	pci_unregister_driver(&driver);
 }
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 4b0b85d..e127eb2 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -569,6 +569,11 @@ static int __devinit sis5513_init_one(struct pci_dev *dev, const struct pci_devi
 {
 	struct ide_port_info d = sis5513_chipset;
 	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
+	int rc;
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
 
 	if (sis_find_family(dev) == 0)
 		return -ENOTSUPP;
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index f0e638d..236f9c3 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -303,6 +303,8 @@ static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 	pcmp->pcmc_per = 0x100000 >> (16 * _slot_);
 #endif	/* CONFIG_IDE_8xx_PCCARD */
 
+	hw->chipset = ide_generic;
+
 	return 0;
 }
 #endif /* CONFIG_IDE_8xx_PCCARD || CONFIG_IDE_8xx_DIRECT */
@@ -377,6 +379,8 @@ static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 	((immap_t *) IMAP_ADDR)->im_siu_conf.sc_siel |=
 			(0x80000000 >> ioport_dsc[data_port].irq);
 
+	hw->chipset = ide_generic;
+
 	return 0;
 }
 #endif	/* CONFIG_IDE_8xx_DIRECT */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index f8f195c..9918772 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -153,7 +153,7 @@ enum {		ide_unknown,	ide_generic,	ide_pci,
 		ide_qd65xx,	ide_umc8672,	ide_ht6560b,
 		ide_rz1000,	ide_trm290,
 		ide_cmd646,	ide_cy82c693,	ide_4drives,
-		ide_pmac,	ide_etrax100,	ide_acorn,
+		ide_pmac,	ide_acorn,
 		ide_au1xxx,	ide_palm3710
 };
 
