Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYLATHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYLATHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYLATGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:06:55 -0500
Received: from havoc.gtf.org ([69.61.125.42]:47729 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYLATGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:06:54 -0500
Date: Mon, 1 Dec 2008 14:06:53 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20081201190653.GA14848@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) pata_rb532_cf significant fixes
2) laptop- and drive-specific workarounds

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c      |   15 +++++++++++++++
 drivers/ata/libata-core.c   |   21 +++++++++++++++++++++
 drivers/ata/pata_rb532_cf.c |   15 ++++++++++-----
 include/linux/libata.h      |    1 +
 4 files changed, 47 insertions(+), 5 deletions(-)

Phil Sutter (2):
      [libata] pata_rb532_cf: fix and rename register definitions
      [libata] pata_rb532_cf: fix signature of the xfer function

Tejun Heo (2):
      ata_piix: add borked Tecra M4 to broken suspend list
      libata: blacklist Seagate drives which time out FLUSH_CACHE when used with NCQ

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 8e37be1..d6d97d8 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1066,6 +1066,21 @@ static int piix_broken_suspend(void)
 		if (dmi_find_device(DMI_DEV_TYPE_OEM_STRING, oemstrs[i], NULL))
 			return 1;
 
+	/* TECRA M4 sometimes forgets its identify and reports bogus
+	 * DMI information.  As the bogus information is a bit
+	 * generic, match as many entries as possible.  This manual
+	 * matching is necessary because dmi_system_id.matches is
+	 * limited to four entries.
+	 */
+	if (!strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
+	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
+	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
+	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
+	    !strcmp(dmi_get_system_info(DMI_BOARD_VENDOR), "TOSHIBA") &&
+	    !strcmp(dmi_get_system_info(DMI_BOARD_NAME), "Portable PC") &&
+	    !strcmp(dmi_get_system_info(DMI_BOARD_VERSION), "Version A0"))
+		return 1;
+
 	return 0;
 }
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4214bfb..5e2eb74 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2492,6 +2492,13 @@ int ata_dev_configure(struct ata_device *dev)
 		}
 	}
 
+	if ((dev->horkage & ATA_HORKAGE_FIRMWARE_WARN) && print_info) {
+		ata_dev_printk(dev, KERN_WARNING, "WARNING: device requires "
+			       "firmware update to be fully functional.\n");
+		ata_dev_printk(dev, KERN_WARNING, "         contact the vendor "
+			       "or visit http://ata.wiki.kernel.org.\n");
+	}
+
 	return 0;
 
 err_out_nosup:
@@ -4042,6 +4049,20 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
 	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
 
+	/* Seagate NCQ + FLUSH CACHE firmware bug */
+	{ "ST31500341AS",	"9JU138",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"9FZ136",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"9FZ164",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"9FZ134",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"9FZ182",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"9FZ162",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index f8b3ffc..c2e6fb9 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -39,9 +39,11 @@
 #define RB500_CF_MAXPORTS	1
 #define RB500_CF_IO_DELAY	400
 
-#define RB500_CF_REG_CMD	0x0800
+#define RB500_CF_REG_BASE	0x0800
+#define RB500_CF_REG_ERR	0x080D
 #define RB500_CF_REG_CTRL	0x080E
-#define RB500_CF_REG_DATA	0x0C00
+/* 32bit buffered data register offset */
+#define RB500_CF_REG_DBUF32	0x0C00
 
 struct rb532_cf_info {
 	void __iomem	*iobase;
@@ -72,11 +74,12 @@ static void rb532_pata_exec_command(struct ata_port *ap,
 	rb532_pata_finish_io(ap);
 }
 
-static void rb532_pata_data_xfer(struct ata_device *adev, unsigned char *buf,
+static unsigned int rb532_pata_data_xfer(struct ata_device *adev, unsigned char *buf,
 				unsigned int buflen, int write_data)
 {
 	struct ata_port *ap = adev->link->ap;
 	void __iomem *ioaddr = ap->ioaddr.data_addr;
+	int retlen = buflen;
 
 	if (write_data) {
 		for (; buflen > 0; buflen--, buf++)
@@ -87,6 +90,7 @@ static void rb532_pata_data_xfer(struct ata_device *adev, unsigned char *buf,
 	}
 
 	rb532_pata_finish_io(adev->link->ap);
+	return retlen;
 }
 
 static void rb532_pata_freeze(struct ata_port *ap)
@@ -146,13 +150,14 @@ static void rb532_pata_setup_ports(struct ata_host *ah)
 	ap->pio_mask	= 0x1f; /* PIO4 */
 	ap->flags	= ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO;
 
-	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_CMD;
+	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_BASE;
 	ap->ioaddr.ctl_addr	= info->iobase + RB500_CF_REG_CTRL;
 	ap->ioaddr.altstatus_addr = info->iobase + RB500_CF_REG_CTRL;
 
 	ata_sff_std_ports(&ap->ioaddr);
 
-	ap->ioaddr.data_addr	= info->iobase + RB500_CF_REG_DATA;
+	ap->ioaddr.data_addr	= info->iobase + RB500_CF_REG_DBUF32;
+	ap->ioaddr.error_addr	= info->iobase + RB500_CF_REG_ERR;
 }
 
 static __devinit int rb532_pata_driver_probe(struct platform_device *pdev)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 59b0f1c..ed3f26e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -375,6 +375,7 @@ enum {
 	ATA_HORKAGE_BRIDGE_OK	= (1 << 10),	/* no bridge limits */
 	ATA_HORKAGE_ATAPI_MOD16_DMA = (1 << 11), /* use ATAPI DMA for commands
 						    not multiple of 16 bytes */
+	ATA_HORKAGE_FIRMWARE_WARN = (1 << 12),	/* firwmare update warning */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
