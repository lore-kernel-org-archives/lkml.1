Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZIKSyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZIKSyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZIKSyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:54:07 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45810 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZIKSx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:53:59 -0400
Date: Fri, 11 Sep 2009 14:54:01 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for .32
Message-ID: <20090911185401.GA31416@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/feature-removal-schedule.txt |   18 --
 arch/x86/pci/direct.c                      |    5 +-
 drivers/acpi/blacklist.c                   |    5 +-
 drivers/ata/Kconfig                        |   21 ++
 drivers/ata/Makefile                       |    1 +
 drivers/ata/ahci.c                         |  143 ++++++++---
 drivers/ata/libata-acpi.c                  |    7 +-
 drivers/ata/libata-core.c                  |   44 +++-
 drivers/ata/libata-eh.c                    |  146 ++++++++++-
 drivers/ata/libata-pmp.c                   |    2 +
 drivers/ata/libata-scsi.c                  |  159 ++++--------
 drivers/ata/libata.h                       |    1 +
 drivers/ata/pata_atiixp.c                  |    1 +
 drivers/ata/pata_cs5535.c                  |    3 +-
 drivers/ata/pata_octeon_cf.c               |    4 +-
 drivers/ata/pata_platform.c                |    8 +-
 drivers/ata/pata_rb532_cf.c                |    2 +-
 drivers/ata/pata_rdc.c                     |  400 ++++++++++++++++++++++++++++
 drivers/ata/pata_rz1000.c                  |    4 +-
 drivers/ata/sata_fsl.c                     |    1 +
 drivers/ata/sata_inic162x.c                |    2 +-
 drivers/ata/sata_mv.c                      |    2 +-
 drivers/ata/sata_sil.c                     |   13 +
 drivers/ata/sata_sil24.c                   |   11 +
 drivers/ata/sata_sis.c                     |   75 ++----
 drivers/firmware/dmi_scan.c                |   77 ++++--
 drivers/ide/atiixp.c                       |    1 +
 drivers/pci/quirks.c                       |    4 +-
 include/linux/ata.h                        |   36 +++-
 include/linux/dmi.h                        |   13 +-
 include/linux/libata.h                     |    3 +-
 include/linux/pci_ids.h                    |    4 +
 32 files changed, 946 insertions(+), 270 deletions(-)
 create mode 100644 drivers/ata/pata_rdc.c

Alan Cox (1):
      [libata] Add pata_rdc driver for RDC ATA devices

Ashish Kalra (1):
      sata_fsl: Defer non-ncq commands when ncq commands active

Jeff Garzik (2):
      [libata] EH: freeze port before aborting commands
      [libata] sata_sil: disable DMA engine in sil_freeze()

Joe Perches (1):
      drivers/ata: Remove unnecessary semicolons

Julia Lawall (1):
      drivers/ata: use resource_size

Marcin Slusarz (1):
      pata_rz1000: use printk_once

Martin K. Petersen (1):
      libata: Delegate nonrot flag setting to SCSI

Matthew Garrett (1):
      libata: Export AHCI capabilities

Otavio Salvador (1):
      pata_cs5535: add pci id for AMD based CS5535 controllers

Robert Hancock (2):
      libata: add command name parsing for error output
      sata_sil24: always set protocol override for non-ATAPI data commands

Shane Huang (3):
      libata: add SATA PMP revision information for spec 1.2
      ahci: Add AMD SB900 SATA/IDE controller device IDs
      ahci: kill @force_restart and refine CLO for ahci_kick_engine()

Shaohua Li (1):
      [libata] add DMA setup FIS auto-activate feature

Tejun Heo (9):
      libata: clear eh_info on reset completion
      libata: remove spindown skipping and warning
      sata_sis: convert to slave_link
      libata: unbreak TPM filtering by reorganizing ata_scsi_pass_thru()
      dmi: fix date handling in dmi_get_year()
      dmi: extend dmi_get_year() to dmi_get_date()
      ahci: make ahci_asus_m2a_vm_32bit_only() quirk more generic
      ahci: Gigabyte GA-MA69VM-S2 can't do 64bit DMA
      libata: fix off-by-one error in ata_tf_read_block()

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 09e031c..b3b6290 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -206,24 +206,6 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
-What: libata spindown skipping and warning
-When: Dec 2008
-Why:  Some halt(8) implementations synchronize caches for and spin
-      down libata disks because libata didn't use to spin down disk on
-      system halt (only synchronized caches).
-      Spin down on system halt is now implemented.  sysfs node
-      /sys/class/scsi_disk/h:c:i:l/manage_start_stop is present if
-      spin down support is available.
-      Because issuing spin down command to an already spun down disk
-      makes some disks spin up just to spin down again, libata tracks
-      device spindown status to skip the extra spindown command and
-      warn about it.
-      This is to give userspace tools the time to get updated and will
-      be removed after userspace is reasonably updated.
-Who:  Tejun Heo <htejun@gmail.com>
-
----------------------------
-
 What:	i386/x86_64 bzImage symlinks
 When:	April 2010
 
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index bd13c3e..347d882 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -192,13 +192,14 @@ struct pci_raw_ops pci_direct_conf2 = {
 static int __init pci_sanity_check(struct pci_raw_ops *o)
 {
 	u32 x = 0;
-	int devfn;
+	int year, devfn;
 
 	if (pci_probe & PCI_NO_CHECKS)
 		return 1;
 	/* Assume Type 1 works for newer systems.
 	   This handles machines that don't have anything on PCI Bus 0. */
-	if (dmi_get_year(DMI_BIOS_DATE) >= 2001)
+	dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL);
+	if (year >= 2001)
 		return 1;
 
 	for (devfn = 0; devfn < 0x100; devfn++) {
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index f6baa77..0c4ca4d 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -78,9 +78,10 @@ static struct acpi_blacklist_item acpi_blacklist[] __initdata = {
 
 static int __init blacklist_by_year(void)
 {
-	int year = dmi_get_year(DMI_BIOS_DATE);
+	int year;
+
 	/* Doesn't exist? Likely an old system */
-	if (year == -1) {
+	if (!dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL)) {
 		printk(KERN_ERR PREFIX "no DMI BIOS year, "
 			"acpi=force is required to enable ACPI\n" );
 		return 1;
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index b17c57f..ab2fa4e 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -26,6 +26,17 @@ config ATA_NONSTANDARD
        bool
        default n
 
+config ATA_VERBOSE_ERROR
+	bool "Verbose ATA error reporting"
+	default y
+	help
+	  This option adds parsing of ATA command descriptions and error bits
+	  in libata kernel output, making it easier to interpret.
+	  This option will enlarge the kernel by approx. 6KB. Disable it only
+	  if kernel size is more important than ease of debugging.
+
+	  If unsure, say Y.
+
 config ATA_ACPI
 	bool "ATA ACPI Support"
 	depends on ACPI && PCI
@@ -586,6 +597,16 @@ config PATA_RB532
 
 	  If unsure, say N.
 
+config PATA_RDC
+	tristate "RDC PATA support"
+	depends on PCI
+	help
+	  This option enables basic support for the later RDC PATA controllers
+	  controllers via the new ATA layer. For the RDC 1010, you need to
+	  enable the IT821X driver instead.
+
+	  If unsure, say N.
+
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 38906f9..463eb52 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
 obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
 obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
+obj-$(CONFIG_PATA_RDC)		+= pata_rdc.o
 obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_serverworks.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fe3eba5..d4cd9c2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -329,10 +329,24 @@ static ssize_t ahci_activity_store(struct ata_device *dev,
 				   enum sw_activity val);
 static void ahci_init_sw_activity(struct ata_link *link);
 
+static ssize_t ahci_show_host_caps(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+static ssize_t ahci_show_host_version(struct device *dev,
+				      struct device_attribute *attr, char *buf);
+static ssize_t ahci_show_port_cmd(struct device *dev,
+				  struct device_attribute *attr, char *buf);
+
+DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
+DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
+DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
+
 static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
 	&dev_attr_em_message_type,
 	&dev_attr_em_message,
+	&dev_attr_ahci_host_caps,
+	&dev_attr_ahci_host_version,
+	&dev_attr_ahci_port_cmd,
 	NULL
 };
 
@@ -539,6 +553,12 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ATI, 0x4394), board_ahci_sb700 }, /* ATI SB700/800 */
 	{ PCI_VDEVICE(ATI, 0x4395), board_ahci_sb700 }, /* ATI SB700/800 */
 
+	/* AMD */
+	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD SB900 */
+	/* AMD is using RAID class only for ahci controllers */
+	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
+
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
 	{ PCI_VDEVICE(VIA, 0x6287), board_ahci_vt8251 }, /* VIA VT8251 */
@@ -702,6 +722,36 @@ static void ahci_enable_ahci(void __iomem *mmio)
 	WARN_ON(1);
 }
 
+static ssize_t ahci_show_host_caps(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+
+	return sprintf(buf, "%x\n", hpriv->cap);
+}
+
+static ssize_t ahci_show_host_version(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+
+	return sprintf(buf, "%x\n", readl(mmio + HOST_VERSION));
+}
+
+static ssize_t ahci_show_port_cmd(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	void __iomem *port_mmio = ahci_port_base(ap);
+
+	return sprintf(buf, "%x\n", readl(port_mmio + PORT_CMD));
+}
+
 /**
  *	ahci_save_initial_config - Save and fixup initial config values
  *	@pdev: target PCI device
@@ -1584,7 +1634,7 @@ static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
 }
 
-static int ahci_kick_engine(struct ata_port *ap, int force_restart)
+static int ahci_kick_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1592,18 +1642,16 @@ static int ahci_kick_engine(struct ata_port *ap, int force_restart)
 	u32 tmp;
 	int busy, rc;
 
-	/* do we need to kick the port? */
-	busy = status & (ATA_BUSY | ATA_DRQ);
-	if (!busy && !force_restart)
-		return 0;
-
 	/* stop engine */
 	rc = ahci_stop_engine(ap);
 	if (rc)
 		goto out_restart;
 
-	/* need to do CLO? */
-	if (!busy) {
+	/* need to do CLO?
+	 * always do CLO if PMP is attached (AHCI-1.3 9.2)
+	 */
+	busy = status & (ATA_BUSY | ATA_DRQ);
+	if (!busy && !sata_pmp_attached(ap)) {
 		rc = 0;
 		goto out_restart;
 	}
@@ -1651,7 +1699,7 @@ static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 		tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
 					1, timeout_msec);
 		if (tmp & 0x1) {
-			ahci_kick_engine(ap, 1);
+			ahci_kick_engine(ap);
 			return -EBUSY;
 		}
 	} else
@@ -1674,7 +1722,7 @@ static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	DPRINTK("ENTER\n");
 
 	/* prepare for SRST (AHCI-1.1 10.4.1) */
-	rc = ahci_kick_engine(ap, 1);
+	rc = ahci_kick_engine(ap);
 	if (rc && rc != -EOPNOTSUPP)
 		ata_link_printk(link, KERN_WARNING,
 				"failed to reset engine (errno=%d)\n", rc);
@@ -1890,7 +1938,7 @@ static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 		rc = ata_wait_after_reset(link, jiffies + 2 * HZ,
 					  ahci_check_ready);
 		if (rc)
-			ahci_kick_engine(ap, 0);
+			ahci_kick_engine(ap);
 	}
 	return rc;
 }
@@ -2271,7 +2319,7 @@ static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 
 	/* make DMA engine forget about the failed command */
 	if (qc->flags & ATA_QCFLAG_FAILED)
-		ahci_kick_engine(ap, 1);
+		ahci_kick_engine(ap);
 }
 
 static void ahci_pmp_attach(struct ata_port *ap)
@@ -2603,14 +2651,18 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 }
 
 /*
- * SB600 ahci controller on ASUS M2A-VM can't do 64bit DMA with older
- * BIOS.  The oldest version known to be broken is 0901 and working is
- * 1501 which was released on 2007-10-26.  Force 32bit DMA on anything
- * older than 1501.  Please read bko#9412 for more info.
+ * SB600 ahci controller on certain boards can't do 64bit DMA with
+ * older BIOS.
  */
-static bool ahci_asus_m2a_vm_32bit_only(struct pci_dev *pdev)
+static bool ahci_sb600_32bit_only(struct pci_dev *pdev)
 {
 	static const struct dmi_system_id sysids[] = {
+		/*
+		 * The oldest version known to be broken is 0901 and
+		 * working is 1501 which was released on 2007-10-26.
+		 * Force 32bit DMA on anything older than 1501.
+		 * Please read bko#9412 for more info.
+		 */
 		{
 			.ident = "ASUS M2A-VM",
 			.matches = {
@@ -2618,31 +2670,48 @@ static bool ahci_asus_m2a_vm_32bit_only(struct pci_dev *pdev)
 					  "ASUSTeK Computer INC."),
 				DMI_MATCH(DMI_BOARD_NAME, "M2A-VM"),
 			},
+			.driver_data = "20071026",	/* yyyymmdd */
+		},
+		/*
+		 * It's yet unknown whether more recent BIOS fixes the
+		 * problem.  Blacklist the whole board for the time
+		 * being.  Please read the following thread for more
+		 * info.
+		 *
+		 * http://thread.gmane.org/gmane.linux.ide/42326
+		 */
+		{
+			.ident = "Gigabyte GA-MA69VM-S2",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "Gigabyte Technology Co., Ltd."),
+				DMI_MATCH(DMI_BOARD_NAME, "GA-MA69VM-S2"),
+			},
 		},
 		{ }
 	};
-	const char *cutoff_mmdd = "10/26";
-	const char *date;
-	int year;
+	const struct dmi_system_id *match;
 
+	match = dmi_first_match(sysids);
 	if (pdev->bus->number != 0 || pdev->devfn != PCI_DEVFN(0x12, 0) ||
-	    !dmi_check_system(sysids))
+	    !match)
 		return false;
 
-	/*
-	 * Argh.... both version and date are free form strings.
-	 * Let's hope they're using the same date format across
-	 * different versions.
-	 */
-	date = dmi_get_system_info(DMI_BIOS_DATE);
-	year = dmi_get_year(DMI_BIOS_DATE);
-	if (date && strlen(date) >= 10 && date[2] == '/' && date[5] == '/' &&
-	    (year > 2007 ||
-	     (year == 2007 && strncmp(date, cutoff_mmdd, 5) >= 0)))
-		return false;
+	if (match->driver_data) {
+		int year, month, date;
+		char buf[9];
+
+		dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
+		snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
 
-	dev_printk(KERN_WARNING, &pdev->dev, "ASUS M2A-VM: BIOS too old, "
-		   "forcing 32bit DMA, update BIOS\n");
+		if (strcmp(buf, match->driver_data) >= 0)
+			return false;
+
+		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, "
+			   "forcing 32bit DMA, update BIOS\n", match->ident);
+	} else
+		dev_printk(KERN_WARNING, &pdev->dev, "%s: this board can't "
+			   "do 64bit DMA, forcing 32bit\n", match->ident);
 
 	return true;
 }
@@ -2857,8 +2926,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
 		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
 
-	/* apply ASUS M2A_VM quirk */
-	if (ahci_asus_m2a_vm_32bit_only(pdev))
+	/* apply sb600 32bit only quirk */
+	if (ahci_sb600_32bit_only(pdev))
 		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
 
 	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
@@ -2869,7 +2938,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* prepare host */
 	if (hpriv->cap & HOST_CAP_NCQ)
-		pi.flags |= ATA_FLAG_NCQ;
+		pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
 
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ac176da..01964b6 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -689,6 +689,7 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 	struct ata_taskfile tf, ptf, rtf;
 	unsigned int err_mask;
 	const char *level;
+	const char *descr;
 	char msg[60];
 	int rc;
 
@@ -736,11 +737,13 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 		snprintf(msg, sizeof(msg), "filtered out");
 		rc = 0;
 	}
+	descr = ata_get_cmd_descript(tf.command);
 
 	ata_dev_printk(dev, level,
-		       "ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x %s\n",
+		       "ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x (%s) %s\n",
 		       tf.command, tf.feature, tf.nsect, tf.lbal,
-		       tf.lbam, tf.lbah, tf.device, msg);
+		       tf.lbam, tf.lbah, tf.device,
+		       (descr ? descr : "unknown"), msg);
 
 	return rc;
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 072ba5e..df31dea 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -709,7 +709,13 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
 		head = tf->device & 0xf;
 		sect = tf->lbal;
 
-		block = (cyl * dev->heads + head) * dev->sectors + sect;
+		if (!sect) {
+			ata_dev_printk(dev, KERN_WARNING, "device reported "
+				       "invalid CHS sector 0\n");
+			sect = 1; /* oh well */
+		}
+
+		block = (cyl * dev->heads + head) * dev->sectors + sect - 1;
 	}
 
 	return block;
@@ -2299,29 +2305,49 @@ static inline u8 ata_dev_knobble(struct ata_device *dev)
 	return ((ap->cbl == ATA_CBL_SATA) && (!ata_id_is_sata(dev->id)));
 }
 
-static void ata_dev_config_ncq(struct ata_device *dev,
+static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
 	struct ata_port *ap = dev->link->ap;
 	int hdepth = 0, ddepth = ata_id_queue_depth(dev->id);
+	unsigned int err_mask;
+	char *aa_desc = "";
 
 	if (!ata_id_has_ncq(dev->id)) {
 		desc[0] = '\0';
-		return;
+		return 0;
 	}
 	if (dev->horkage & ATA_HORKAGE_NONCQ) {
 		snprintf(desc, desc_sz, "NCQ (not used)");
-		return;
+		return 0;
 	}
 	if (ap->flags & ATA_FLAG_NCQ) {
 		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
 		dev->flags |= ATA_DFLAG_NCQ;
 	}
 
+	if (!(dev->horkage & ATA_HORKAGE_BROKEN_FPDMA_AA) &&
+		(ap->flags & ATA_FLAG_FPDMA_AA) &&
+		ata_id_has_fpdma_aa(dev->id)) {
+		err_mask = ata_dev_set_feature(dev, SETFEATURES_SATA_ENABLE,
+			SATA_FPDMA_AA);
+		if (err_mask) {
+			ata_dev_printk(dev, KERN_ERR, "failed to enable AA"
+				"(error_mask=0x%x)\n", err_mask);
+			if (err_mask != AC_ERR_DEV) {
+				dev->horkage |= ATA_HORKAGE_BROKEN_FPDMA_AA;
+				return -EIO;
+			}
+		} else
+			aa_desc = ", AA";
+	}
+
 	if (hdepth >= ddepth)
-		snprintf(desc, desc_sz, "NCQ (depth %d)", ddepth);
+		snprintf(desc, desc_sz, "NCQ (depth %d)%s", ddepth, aa_desc);
 	else
-		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
+		snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
+			ddepth, aa_desc);
+	return 0;
 }
 
 /**
@@ -2461,7 +2487,7 @@ int ata_dev_configure(struct ata_device *dev)
 
 		if (ata_id_has_lba(id)) {
 			const char *lba_desc;
-			char ncq_desc[20];
+			char ncq_desc[24];
 
 			lba_desc = "LBA";
 			dev->flags |= ATA_DFLAG_LBA;
@@ -2475,7 +2501,9 @@ int ata_dev_configure(struct ata_device *dev)
 			}
 
 			/* config NCQ */
-			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
+			rc = ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
+			if (rc)
+				return rc;
 
 			/* print device info to dmesg */
 			if (ata_msg_drv(ap) && print_info) {
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 79711b6..a04488f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -40,6 +40,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 #include "../scsi/scsi_transport_api.h"
 
 #include <linux/libata.h>
@@ -999,7 +1000,9 @@ static void __ata_port_freeze(struct ata_port *ap)
  *	ata_port_freeze - abort & freeze port
  *	@ap: ATA port to freeze
  *
- *	Abort and freeze @ap.
+ *	Abort and freeze @ap.  The freeze operation must be called
+ *	first, because some hardware requires special operations
+ *	before the taskfile registers are accessible.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -1013,8 +1016,8 @@ int ata_port_freeze(struct ata_port *ap)
 
 	WARN_ON(!ap->ops->error_handler);
 
-	nr_aborted = ata_port_abort(ap);
 	__ata_port_freeze(ap);
+	nr_aborted = ata_port_abort(ap);
 
 	return nr_aborted;
 }
@@ -2110,6 +2113,116 @@ void ata_eh_autopsy(struct ata_port *ap)
 }
 
 /**
+ *	ata_get_cmd_descript - get description for ATA command
+ *	@command: ATA command code to get description for
+ *
+ *	Return a textual description of the given command, or NULL if the
+ *	command is not known.
+ *
+ *	LOCKING:
+ *	None
+ */
+const char *ata_get_cmd_descript(u8 command)
+{
+#ifdef CONFIG_ATA_VERBOSE_ERROR
+	static const struct
+	{
+		u8 command;
+		const char *text;
+	} cmd_descr[] = {
+		{ ATA_CMD_DEV_RESET,		"DEVICE RESET" },
+		{ ATA_CMD_CHK_POWER, 		"CHECK POWER MODE" },
+		{ ATA_CMD_STANDBY, 		"STANDBY" },
+		{ ATA_CMD_IDLE, 		"IDLE" },
+		{ ATA_CMD_EDD, 			"EXECUTE DEVICE DIAGNOSTIC" },
+		{ ATA_CMD_DOWNLOAD_MICRO,   	"DOWNLOAD MICROCODE" },
+		{ ATA_CMD_NOP,			"NOP" },
+		{ ATA_CMD_FLUSH, 		"FLUSH CACHE" },
+		{ ATA_CMD_FLUSH_EXT, 		"FLUSH CACHE EXT" },
+		{ ATA_CMD_ID_ATA,  		"IDENTIFY DEVICE" },
+		{ ATA_CMD_ID_ATAPI, 		"IDENTIFY PACKET DEVICE" },
+		{ ATA_CMD_SERVICE, 		"SERVICE" },
+		{ ATA_CMD_READ, 		"READ DMA" },
+		{ ATA_CMD_READ_EXT, 		"READ DMA EXT" },
+		{ ATA_CMD_READ_QUEUED, 		"READ DMA QUEUED" },
+		{ ATA_CMD_READ_STREAM_EXT, 	"READ STREAM EXT" },
+		{ ATA_CMD_READ_STREAM_DMA_EXT,  "READ STREAM DMA EXT" },
+		{ ATA_CMD_WRITE, 		"WRITE DMA" },
+		{ ATA_CMD_WRITE_EXT, 		"WRITE DMA EXT" },
+		{ ATA_CMD_WRITE_QUEUED, 	"WRITE DMA QUEUED EXT" },
+		{ ATA_CMD_WRITE_STREAM_EXT, 	"WRITE STREAM EXT" },
+		{ ATA_CMD_WRITE_STREAM_DMA_EXT, "WRITE STREAM DMA EXT" },
+		{ ATA_CMD_WRITE_FUA_EXT,	"WRITE DMA FUA EXT" },
+		{ ATA_CMD_WRITE_QUEUED_FUA_EXT, "WRITE DMA QUEUED FUA EXT" },
+		{ ATA_CMD_FPDMA_READ,		"READ FPDMA QUEUED" },
+		{ ATA_CMD_FPDMA_WRITE,		"WRITE FPDMA QUEUED" },
+		{ ATA_CMD_PIO_READ,		"READ SECTOR(S)" },
+		{ ATA_CMD_PIO_READ_EXT,		"READ SECTOR(S) EXT" },
+		{ ATA_CMD_PIO_WRITE,		"WRITE SECTOR(S)" },
+		{ ATA_CMD_PIO_WRITE_EXT,	"WRITE SECTOR(S) EXT" },
+		{ ATA_CMD_READ_MULTI,		"READ MULTIPLE" },
+		{ ATA_CMD_READ_MULTI_EXT,	"READ MULTIPLE EXT" },
+		{ ATA_CMD_WRITE_MULTI,		"WRITE MULTIPLE" },
+		{ ATA_CMD_WRITE_MULTI_EXT,	"WRITE MULTIPLE EXT" },
+		{ ATA_CMD_WRITE_MULTI_FUA_EXT, 	"WRITE MULTIPLE FUA EXT" },
+		{ ATA_CMD_SET_FEATURES,		"SET FEATURES" },
+		{ ATA_CMD_SET_MULTI,		"SET MULTIPLE MODE" },
+		{ ATA_CMD_VERIFY,		"READ VERIFY SECTOR(S)" },
+		{ ATA_CMD_VERIFY_EXT,		"READ VERIFY SECTOR(S) EXT" },
+		{ ATA_CMD_WRITE_UNCORR_EXT,	"WRITE UNCORRECTABLE EXT" },
+		{ ATA_CMD_STANDBYNOW1,		"STANDBY IMMEDIATE" },
+		{ ATA_CMD_IDLEIMMEDIATE,	"IDLE IMMEDIATE" },
+		{ ATA_CMD_SLEEP,		"SLEEP" },
+		{ ATA_CMD_INIT_DEV_PARAMS,	"INITIALIZE DEVICE PARAMETERS" },
+		{ ATA_CMD_READ_NATIVE_MAX,	"READ NATIVE MAX ADDRESS" },
+		{ ATA_CMD_READ_NATIVE_MAX_EXT,	"READ NATIVE MAX ADDRESS EXT" },
+		{ ATA_CMD_SET_MAX,		"SET MAX ADDRESS" },
+		{ ATA_CMD_SET_MAX_EXT,		"SET MAX ADDRESS EXT" },
+		{ ATA_CMD_READ_LOG_EXT,		"READ LOG EXT" },
+		{ ATA_CMD_WRITE_LOG_EXT,	"WRITE LOG EXT" },
+		{ ATA_CMD_READ_LOG_DMA_EXT,	"READ LOG DMA EXT" },
+		{ ATA_CMD_WRITE_LOG_DMA_EXT, 	"WRITE LOG DMA EXT" },
+		{ ATA_CMD_TRUSTED_RCV,		"TRUSTED RECEIVE" },
+		{ ATA_CMD_TRUSTED_RCV_DMA, 	"TRUSTED RECEIVE DMA" },
+		{ ATA_CMD_TRUSTED_SND,		"TRUSTED SEND" },
+		{ ATA_CMD_TRUSTED_SND_DMA, 	"TRUSTED SEND DMA" },
+		{ ATA_CMD_PMP_READ,		"READ BUFFER" },
+		{ ATA_CMD_PMP_WRITE,		"WRITE BUFFER" },
+		{ ATA_CMD_CONF_OVERLAY,		"DEVICE CONFIGURATION OVERLAY" },
+		{ ATA_CMD_SEC_SET_PASS,		"SECURITY SET PASSWORD" },
+		{ ATA_CMD_SEC_UNLOCK,		"SECURITY UNLOCK" },
+		{ ATA_CMD_SEC_ERASE_PREP,	"SECURITY ERASE PREPARE" },
+		{ ATA_CMD_SEC_ERASE_UNIT,	"SECURITY ERASE UNIT" },
+		{ ATA_CMD_SEC_FREEZE_LOCK,	"SECURITY FREEZE LOCK" },
+		{ ATA_CMD_SEC_DISABLE_PASS,	"SECURITY DISABLE PASSWORD" },
+		{ ATA_CMD_CONFIG_STREAM,	"CONFIGURE STREAM" },
+		{ ATA_CMD_SMART,		"SMART" },
+		{ ATA_CMD_MEDIA_LOCK,		"DOOR LOCK" },
+		{ ATA_CMD_MEDIA_UNLOCK,		"DOOR UNLOCK" },
+		{ ATA_CMD_CHK_MED_CRD_TYP, 	"CHECK MEDIA CARD TYPE" },
+		{ ATA_CMD_CFA_REQ_EXT_ERR, 	"CFA REQUEST EXTENDED ERROR" },
+		{ ATA_CMD_CFA_WRITE_NE,		"CFA WRITE SECTORS WITHOUT ERASE" },
+		{ ATA_CMD_CFA_TRANS_SECT,	"CFA TRANSLATE SECTOR" },
+		{ ATA_CMD_CFA_ERASE,		"CFA ERASE SECTORS" },
+		{ ATA_CMD_CFA_WRITE_MULT_NE, 	"CFA WRITE MULTIPLE WITHOUT ERASE" },
+		{ ATA_CMD_READ_LONG,		"READ LONG (with retries)" },
+		{ ATA_CMD_READ_LONG_ONCE,	"READ LONG (without retries)" },
+		{ ATA_CMD_WRITE_LONG,		"WRITE LONG (with retries)" },
+		{ ATA_CMD_WRITE_LONG_ONCE,	"WRITE LONG (without retries)" },
+		{ ATA_CMD_RESTORE,		"RECALIBRATE" },
+		{ 0,				NULL } /* terminate list */
+	};
+
+	unsigned int i;
+	for (i = 0; cmd_descr[i].text; i++)
+		if (cmd_descr[i].command == command)
+			return cmd_descr[i].text;
+#endif
+
+	return NULL;
+}
+
+/**
  *	ata_eh_link_report - report error handling to user
  *	@link: ATA link EH is going on
  *
@@ -2175,6 +2288,7 @@ static void ata_eh_link_report(struct ata_link *link)
 			ata_link_printk(link, KERN_ERR, "%s\n", desc);
 	}
 
+#ifdef CONFIG_ATA_VERBOSE_ERROR
 	if (ehc->i.serror)
 		ata_link_printk(link, KERN_ERR,
 		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
@@ -2195,6 +2309,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		  ehc->i.serror & SERR_TRANS_ST_ERROR ? "TrStaTrns " : "",
 		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecFIS " : "",
 		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "");
+#endif
 
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
@@ -2226,14 +2341,23 @@ static void ata_eh_link_report(struct ata_link *link)
 				 dma_str[qc->dma_dir]);
 		}
 
-		if (ata_is_atapi(qc->tf.protocol))
-			snprintf(cdb_buf, sizeof(cdb_buf),
+		if (ata_is_atapi(qc->tf.protocol)) {
+			if (qc->scsicmd)
+				scsi_print_command(qc->scsicmd);
+			else
+				snprintf(cdb_buf, sizeof(cdb_buf),
 				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
 				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
 				 cdb[0], cdb[1], cdb[2], cdb[3],
 				 cdb[4], cdb[5], cdb[6], cdb[7],
 				 cdb[8], cdb[9], cdb[10], cdb[11],
 				 cdb[12], cdb[13], cdb[14], cdb[15]);
+		} else {
+			const char *descr = ata_get_cmd_descript(cmd->command);
+			if (descr)
+				ata_dev_printk(qc->dev, KERN_ERR,
+					"failed command: %s\n", descr);
+		}
 
 		ata_dev_printk(qc->dev, KERN_ERR,
 			"cmd %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
@@ -2252,6 +2376,7 @@ static void ata_eh_link_report(struct ata_link *link)
 			res->device, qc->err_mask, ata_err_string(qc->err_mask),
 			qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
 
+#ifdef CONFIG_ATA_VERBOSE_ERROR
 		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
 				    ATA_ERR)) {
 			if (res->command & ATA_BUSY)
@@ -2275,6 +2400,7 @@ static void ata_eh_link_report(struct ata_link *link)
 			  res->feature & ATA_UNC ? "UNC " : "",
 			  res->feature & ATA_IDNF ? "IDNF " : "",
 			  res->feature & ATA_ABORTED ? "ABRT " : "");
+#endif
 	}
 }
 
@@ -2574,11 +2700,17 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			postreset(slave, classes);
 	}
 
-	/* clear cached SError */
+	/*
+	 * Some controllers can't be frozen very well and may set
+	 * spuruious error conditions during reset.  Clear accumulated
+	 * error information.  As reset is the final recovery action,
+	 * nothing is lost by doing this.
+	 */
 	spin_lock_irqsave(link->ap->lock, flags);
-	link->eh_info.serror = 0;
+	memset(&link->eh_info, 0, sizeof(link->eh_info));
 	if (slave)
-		slave->eh_info.serror = 0;
+		memset(&slave->eh_info, 0, sizeof(link->eh_info));
+	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
 	/* Make sure onlineness and classification result correspond.
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 619f2c3..51f0ffb 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -221,6 +221,8 @@ static const char *sata_pmp_spec_rev_str(const u32 *gscr)
 {
 	u32 rev = gscr[SATA_PMP_GSCR_REV];
 
+	if (rev & (1 << 3))
+		return "1.2";
 	if (rev & (1 << 2))
 		return "1.1";
 	if (rev & (1 << 1))
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d0dfeef..b4ee28d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1119,10 +1119,6 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
-		if (ata_id_is_ssd(dev->id))
-			queue_flag_set_unlocked(QUEUE_FLAG_NONROT,
-						sdev->request_queue);
-
 		/* ATA devices must be sector aligned */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
@@ -1257,23 +1253,6 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 	return queue_depth;
 }
 
-/* XXX: for spindown warning */
-static void ata_delayed_done_timerfn(unsigned long arg)
-{
-	struct scsi_cmnd *scmd = (void *)arg;
-
-	scmd->scsi_done(scmd);
-}
-
-/* XXX: for spindown warning */
-static void ata_delayed_done(struct scsi_cmnd *scmd)
-{
-	static struct timer_list timer;
-
-	setup_timer(&timer, ata_delayed_done_timerfn, (unsigned long)scmd);
-	mod_timer(&timer, jiffies + 5 * HZ);
-}
-
 /**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
@@ -1338,32 +1317,6 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		     system_entering_hibernation())
 			goto skip;
 
-		/* XXX: This is for backward compatibility, will be
-		 * removed.  Read Documentation/feature-removal-schedule.txt
-		 * for more info.
-		 */
-		if ((qc->dev->flags & ATA_DFLAG_SPUNDOWN) &&
-		    (system_state == SYSTEM_HALT ||
-		     system_state == SYSTEM_POWER_OFF)) {
-			static unsigned long warned;
-
-			if (!test_and_set_bit(0, &warned)) {
-				ata_dev_printk(qc->dev, KERN_WARNING,
-					"DISK MIGHT NOT BE SPUN DOWN PROPERLY. "
-					"UPDATE SHUTDOWN UTILITY\n");
-				ata_dev_printk(qc->dev, KERN_WARNING,
-					"For more info, visit "
-					"http://linux-ata.org/shutdown.html\n");
-
-				/* ->scsi_done is not used, use it for
-				 * delayed completion.
-				 */
-				scmd->scsi_done = qc->scsidone;
-				qc->scsidone = ata_delayed_done;
-			}
-			goto skip;
-		}
-
 		/* Issue ATA STANDBY IMMEDIATE command */
 		tf->command = ATA_CMD_STANDBYNOW1;
 	}
@@ -1764,14 +1717,6 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 		}
 	}
 
-	/* XXX: track spindown state for spindown skipping and warning */
-	if (unlikely(qc->tf.command == ATA_CMD_STANDBY ||
-		     qc->tf.command == ATA_CMD_STANDBYNOW1))
-		qc->dev->flags |= ATA_DFLAG_SPUNDOWN;
-	else if (likely(system_state != SYSTEM_HALT &&
-			system_state != SYSTEM_POWER_OFF))
-		qc->dev->flags &= ~ATA_DFLAG_SPUNDOWN;
-
 	if (need_sense && !ap->ops->error_handler)
 		ata_dump_status(ap->print_id, &qc->result_tf);
 
@@ -2815,28 +2760,6 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 
 	/*
-	 * Filter TPM commands by default. These provide an
-	 * essentially uncontrolled encrypted "back door" between
-	 * applications and the disk. Set libata.allow_tpm=1 if you
-	 * have a real reason for wanting to use them. This ensures
-	 * that installed software cannot easily mess stuff up without
-	 * user intent. DVR type users will probably ship with this enabled
-	 * for movie content management.
-	 *
-	 * Note that for ATA8 we can issue a DCS change and DCS freeze lock
-	 * for this and should do in future but that it is not sufficient as
-	 * DCS is an optional feature set. Thus we also do the software filter
-	 * so that we comply with the TC consortium stated goal that the user
-	 * can turn off TC features of their system.
-	 */
-	if (tf->command >= 0x5C && tf->command <= 0x5F && !libata_allow_tpm)
-		goto invalid_fld;
-
-	/* We may not issue DMA commands if no DMA mode is set */
-	if (tf->protocol == ATA_PROT_DMA && dev->dma_mode == 0)
-		goto invalid_fld;
-
-	/*
 	 * 12 and 16 byte CDBs use different offsets to
 	 * provide the various register values.
 	 */
@@ -2885,6 +2808,41 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	tf->device = dev->devno ?
 		tf->device | ATA_DEV1 : tf->device & ~ATA_DEV1;
 
+	/* READ/WRITE LONG use a non-standard sect_size */
+	qc->sect_size = ATA_SECT_SIZE;
+	switch (tf->command) {
+	case ATA_CMD_READ_LONG:
+	case ATA_CMD_READ_LONG_ONCE:
+	case ATA_CMD_WRITE_LONG:
+	case ATA_CMD_WRITE_LONG_ONCE:
+		if (tf->protocol != ATA_PROT_PIO || tf->nsect != 1)
+			goto invalid_fld;
+		qc->sect_size = scsi_bufflen(scmd);
+	}
+
+	/*
+	 * Set flags so that all registers will be written, pass on
+	 * write indication (used for PIO/DMA setup), result TF is
+	 * copied back and we don't whine too much about its failure.
+	 */
+	tf->flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	if (scmd->sc_data_direction == DMA_TO_DEVICE)
+		tf->flags |= ATA_TFLAG_WRITE;
+
+	qc->flags |= ATA_QCFLAG_RESULT_TF | ATA_QCFLAG_QUIET;
+
+	/*
+	 * Set transfer length.
+	 *
+	 * TODO: find out if we need to do more here to
+	 *       cover scatter/gather case.
+	 */
+	ata_qc_set_pc_nbytes(qc);
+
+	/* We may not issue DMA commands if no DMA mode is set */
+	if (tf->protocol == ATA_PROT_DMA && dev->dma_mode == 0)
+		goto invalid_fld;
+
 	/* sanity check for pio multi commands */
 	if ((cdb[1] & 0xe0) && !is_multi_taskfile(tf))
 		goto invalid_fld;
@@ -2901,18 +2859,6 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 				       multi_count);
 	}
 
-	/* READ/WRITE LONG use a non-standard sect_size */
-	qc->sect_size = ATA_SECT_SIZE;
-	switch (tf->command) {
-	case ATA_CMD_READ_LONG:
-	case ATA_CMD_READ_LONG_ONCE:
-	case ATA_CMD_WRITE_LONG:
-	case ATA_CMD_WRITE_LONG_ONCE:
-		if (tf->protocol != ATA_PROT_PIO || tf->nsect != 1)
-			goto invalid_fld;
-		qc->sect_size = scsi_bufflen(scmd);
-	}
-
 	/*
 	 * Filter SET_FEATURES - XFER MODE command -- otherwise,
 	 * SET_FEATURES - XFER MODE must be preceded/succeeded
@@ -2920,30 +2866,27 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 * controller (i.e. the reason for ->set_piomode(),
 	 * ->set_dmamode(), and ->post_set_mode() hooks).
 	 */
-	if ((tf->command == ATA_CMD_SET_FEATURES)
-	 && (tf->feature == SETFEATURES_XFER))
+	if (tf->command == ATA_CMD_SET_FEATURES &&
+	    tf->feature == SETFEATURES_XFER)
 		goto invalid_fld;
 
 	/*
-	 * Set flags so that all registers will be written,
-	 * and pass on write indication (used for PIO/DMA
-	 * setup.)
-	 */
-	tf->flags |= (ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE);
-
-	if (scmd->sc_data_direction == DMA_TO_DEVICE)
-		tf->flags |= ATA_TFLAG_WRITE;
-
-	/*
-	 * Set transfer length.
+	 * Filter TPM commands by default. These provide an
+	 * essentially uncontrolled encrypted "back door" between
+	 * applications and the disk. Set libata.allow_tpm=1 if you
+	 * have a real reason for wanting to use them. This ensures
+	 * that installed software cannot easily mess stuff up without
+	 * user intent. DVR type users will probably ship with this enabled
+	 * for movie content management.
 	 *
-	 * TODO: find out if we need to do more here to
-	 *       cover scatter/gather case.
+	 * Note that for ATA8 we can issue a DCS change and DCS freeze lock
+	 * for this and should do in future but that it is not sufficient as
+	 * DCS is an optional feature set. Thus we also do the software filter
+	 * so that we comply with the TC consortium stated goal that the user
+	 * can turn off TC features of their system.
 	 */
-	ata_qc_set_pc_nbytes(qc);
-
-	/* request result TF and be quiet about device error */
-	qc->flags |= ATA_QCFLAG_RESULT_TF | ATA_QCFLAG_QUIET;
+	if (tf->command >= 0x5C && tf->command <= 0x5F && !libata_allow_tpm)
+		goto invalid_fld;
 
 	return 0;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 89a1e00..be8e262 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -164,6 +164,7 @@ extern void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
 			unsigned int action);
 extern void ata_eh_autopsy(struct ata_port *ap);
+const char *ata_get_cmd_descript(u8 command);
 extern void ata_eh_report(struct ata_port *ap);
 extern int ata_eh_reset(struct ata_link *link, int classify,
 			ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 4591556..aa4b3f6 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -246,6 +246,7 @@ static const struct pci_device_id atiixp[] = {
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_SB900_IDE), },
 
 	{ },
 };
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index d33aa28..403f561 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -202,7 +202,8 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 }
 
 static const struct pci_device_id cs5535[] = {
-	{ PCI_VDEVICE(NS, 0x002D), },
+	{ PCI_VDEVICE(NS, PCI_DEVICE_ID_NS_CS5535_IDE), },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CS5535_IDE), },
 
 	{ },
 };
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index abdd19f..d6f6956 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -213,7 +213,7 @@ static void octeon_cf_set_dmamode(struct ata_port *ap, struct ata_device *dev)
 	 * This is tI, C.F. spec. says 0, but Sony CF card requires
 	 * more, we use 20 nS.
 	 */
-	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);;
+	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);
 	dma_tim.s.dmack_h = ns_to_tim_reg(tim_mult, dma_ackh);
 
 	dma_tim.s.dmarq = dma_arq;
@@ -841,7 +841,7 @@ static int __devinit octeon_cf_probe(struct platform_device *pdev)
 	ocd = pdev->dev.platform_data;
 
 	cs0 = devm_ioremap_nocache(&pdev->dev, res_cs0->start,
-				   res_cs0->end - res_cs0->start + 1);
+				   resource_size(res_cs0));
 
 	if (!cs0)
 		return -ENOMEM;
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index d8d743a..3f6ebc6 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -151,14 +151,14 @@ int __devinit __pata_platform_probe(struct device *dev,
 	 */
 	if (mmio) {
 		ap->ioaddr.cmd_addr = devm_ioremap(dev, io_res->start,
-				io_res->end - io_res->start + 1);
+				resource_size(io_res));
 		ap->ioaddr.ctl_addr = devm_ioremap(dev, ctl_res->start,
-				ctl_res->end - ctl_res->start + 1);
+				resource_size(ctl_res));
 	} else {
 		ap->ioaddr.cmd_addr = devm_ioport_map(dev, io_res->start,
-				io_res->end - io_res->start + 1);
+				resource_size(io_res));
 		ap->ioaddr.ctl_addr = devm_ioport_map(dev, ctl_res->start,
-				ctl_res->end - ctl_res->start + 1);
+				resource_size(ctl_res));
 	}
 	if (!ap->ioaddr.cmd_addr || !ap->ioaddr.ctl_addr) {
 		dev_err(dev, "failed to map IO/CTL base\n");
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 8e3cdef..45f1e10 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -151,7 +151,7 @@ static __devinit int rb532_pata_driver_probe(struct platform_device *pdev)
 	info->irq = irq;
 
 	info->iobase = devm_ioremap_nocache(&pdev->dev, res->start,
-				res->end - res->start + 1);
+				resource_size(res));
 	if (!info->iobase)
 		return -ENOMEM;
 
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
new file mode 100644
index 0000000..c843a1e
--- /dev/null
+++ b/drivers/ata/pata_rdc.c
@@ -0,0 +1,400 @@
+/*
+ *  pata_rdc		-	Driver for later RDC PATA controllers
+ *
+ *  This is actually a driver for hardware meeting
+ *  INCITS 370-2004 (1510D): ATA Host Adapter Standards
+ *
+ *  Based on ata_piix.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <scsi/scsi_host.h>
+#include <linux/libata.h>
+#include <linux/dmi.h>
+
+#define DRV_NAME	"pata_rdc"
+#define DRV_VERSION	"0.01"
+
+struct rdc_host_priv {
+	u32 saved_iocfg;
+};
+
+/**
+ *	rdc_pata_cable_detect - Probe host controller cable detect info
+ *	@ap: Port for which cable detect info is desired
+ *
+ *	Read 80c cable indicator from ATA PCI device's PCI config
+ *	register.  This register is normally set by firmware (BIOS).
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static int rdc_pata_cable_detect(struct ata_port *ap)
+{
+	struct rdc_host_priv *hpriv = ap->host->private_data;
+	u8 mask;
+
+	/* check BIOS cable detect results */
+	mask = 0x30 << (2 * ap->port_no);
+	if ((hpriv->saved_iocfg & mask) == 0)
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+/**
+ *	rdc_pata_prereset - prereset for PATA host controller
+ *	@link: Target link
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+static int rdc_pata_prereset(struct ata_link *link, unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	static const struct pci_bits rdc_enable_bits[] = {
+		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
+		{ 0x43U, 1U, 0x80UL, 0x80UL },	/* port 1 */
+	};
+
+	if (!pci_test_config_bits(pdev, &rdc_enable_bits[ap->port_no]))
+		return -ENOENT;
+	return ata_sff_prereset(link, deadline);
+}
+
+/**
+ *	rdc_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: um
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned int is_slave	= (adev->devno != 0);
+	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
+	unsigned int slave_port	= 0x44;
+	u16 master_data;
+	u8 slave_data;
+	u8 udma_enable;
+	int control = 0;
+
+	static const	 /* ISP  RTC */
+	u8 timings[][2]	= { { 0, 0 },
+			    { 0, 0 },
+			    { 1, 0 },
+			    { 2, 1 },
+			    { 2, 3 }, };
+
+	if (pio >= 2)
+		control |= 1;	/* TIME1 enable */
+	if (ata_pio_need_iordy(adev))
+		control |= 2;	/* IE enable */
+
+	if (adev->class == ATA_DEV_ATA)
+		control |= 4;	/* PPE enable */
+
+	/* PIO configuration clears DTE unconditionally.  It will be
+	 * programmed in set_dmamode which is guaranteed to be called
+	 * after set_piomode if any DMA mode is available.
+	 */
+	pci_read_config_word(dev, master_port, &master_data);
+	if (is_slave) {
+		/* clear TIME1|IE1|PPE1|DTE1 */
+		master_data &= 0xff0f;
+		/* Enable SITRE (separate slave timing register) */
+		master_data |= 0x4000;
+		/* enable PPE1, IE1 and TIME1 as needed */
+		master_data |= (control << 4);
+		pci_read_config_byte(dev, slave_port, &slave_data);
+		slave_data &= (ap->port_no ? 0x0f : 0xf0);
+		/* Load the timing nibble for this slave */
+		slave_data |= ((timings[pio][0] << 2) | timings[pio][1])
+						<< (ap->port_no ? 4 : 0);
+	} else {
+		/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
+		master_data &= 0xccf0;
+		/* Enable PPE, IE and TIME as appropriate */
+		master_data |= control;
+		/* load ISP and RCT */
+		master_data |=
+			(timings[pio][0] << 12) |
+			(timings[pio][1] << 8);
+	}
+	pci_write_config_word(dev, master_port, master_data);
+	if (is_slave)
+		pci_write_config_byte(dev, slave_port, slave_data);
+
+	/* Ensure the UDMA bit is off - it will be turned back on if
+	   UDMA is selected */
+
+	pci_read_config_byte(dev, 0x48, &udma_enable);
+	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
+	pci_write_config_byte(dev, 0x48, udma_enable);
+}
+
+/**
+ *	rdc_set_dmamode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Drive in question
+ *
+ *	Set UDMA mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	u8 master_port		= ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
+	u8 speed		= adev->dma_mode;
+	int devid		= adev->devno + 2 * ap->port_no;
+	u8 udma_enable		= 0;
+
+	static const	 /* ISP  RTC */
+	u8 timings[][2]	= { { 0, 0 },
+			    { 0, 0 },
+			    { 1, 0 },
+			    { 2, 1 },
+			    { 2, 3 }, };
+
+	pci_read_config_word(dev, master_port, &master_data);
+	pci_read_config_byte(dev, 0x48, &udma_enable);
+
+	if (speed >= XFER_UDMA_0) {
+		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
+		u16 udma_timing;
+		u16 ideconf;
+		int u_clock, u_speed;
+
+		/*
+		 * UDMA is handled by a combination of clock switching and
+		 * selection of dividers
+		 *
+		 * Handy rule: Odd modes are UDMATIMx 01, even are 02
+		 *	       except UDMA0 which is 00
+		 */
+		u_speed = min(2 - (udma & 1), udma);
+		if (udma == 5)
+			u_clock = 0x1000;	/* 100Mhz */
+		else if (udma > 2)
+			u_clock = 1;		/* 66Mhz */
+		else
+			u_clock = 0;		/* 33Mhz */
+
+		udma_enable |= (1 << devid);
+
+		/* Load the CT/RP selection */
+		pci_read_config_word(dev, 0x4A, &udma_timing);
+		udma_timing &= ~(3 << (4 * devid));
+		udma_timing |= u_speed << (4 * devid);
+		pci_write_config_word(dev, 0x4A, udma_timing);
+
+		/* Select a 33/66/100Mhz clock */
+		pci_read_config_word(dev, 0x54, &ideconf);
+		ideconf &= ~(0x1001 << devid);
+		ideconf |= u_clock << devid;
+		pci_write_config_word(dev, 0x54, ideconf);
+	} else {
+		/*
+		 * MWDMA is driven by the PIO timings. We must also enable
+		 * IORDY unconditionally along with TIME1. PPE has already
+		 * been set when the PIO timing was set.
+		 */
+		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
+		unsigned int control;
+		u8 slave_data;
+		const unsigned int needed_pio[3] = {
+			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
+		};
+		int pio = needed_pio[mwdma] - XFER_PIO_0;
+
+		control = 3;	/* IORDY|TIME1 */
+
+		/* If the drive MWDMA is faster than it can do PIO then
+		   we must force PIO into PIO0 */
+
+		if (adev->pio_mode < needed_pio[mwdma])
+			/* Enable DMA timing only */
+			control |= 8;	/* PIO cycles in PIO0 */
+
+		if (adev->devno) {	/* Slave */
+			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
+			master_data |= control << 4;
+			pci_read_config_byte(dev, 0x44, &slave_data);
+			slave_data &= (ap->port_no ? 0x0f : 0xf0);
+			/* Load the matching timing */
+			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
+			pci_write_config_byte(dev, 0x44, slave_data);
+		} else { 	/* Master */
+			master_data &= 0xCCF4;	/* Mask out IORDY|TIME1|DMAONLY
+						   and master timing bits */
+			master_data |= control;
+			master_data |=
+				(timings[pio][0] << 12) |
+				(timings[pio][1] << 8);
+		}
+
+		udma_enable &= ~(1 << devid);
+		pci_write_config_word(dev, master_port, master_data);
+	}
+	pci_write_config_byte(dev, 0x48, udma_enable);
+}
+
+static struct ata_port_operations rdc_pata_ops = {
+	.inherits		= &ata_bmdma32_port_ops,
+	.cable_detect		= rdc_pata_cable_detect,
+	.set_piomode		= rdc_set_piomode,
+	.set_dmamode		= rdc_set_dmamode,
+	.prereset		= rdc_pata_prereset,
+};
+
+static struct ata_port_info rdc_port_info = {
+
+	.flags		= ATA_FLAG_SLAVE_POSS,
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA5,
+	.port_ops	= &rdc_pata_ops,
+};
+
+static struct scsi_host_template rdc_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+/**
+ *	rdc_init_one - Register PIIX ATA PCI device with kernel services
+ *	@pdev: PCI device to register
+ *	@ent: Entry in rdc_pci_tbl matching with @pdev
+ *
+ *	Called from kernel PCI layer.  We probe for combined mode (sigh),
+ *	and then hand over control to libata, for it to do the rest.
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, or -ERRNO value.
+ */
+
+static int __devinit rdc_init_one(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
+{
+	static int printed_version;
+	struct device *dev = &pdev->dev;
+	struct ata_port_info port_info[2];
+	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
+	unsigned long port_flags;
+	struct ata_host *host;
+	struct rdc_host_priv *hpriv;
+	int rc;
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev,
+			   "version " DRV_VERSION "\n");
+
+	port_info[0] = rdc_port_info;
+	port_info[1] = rdc_port_info;
+
+	port_flags = port_info[0].flags;
+
+	/* enable device and prepare host */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+
+	/* Save IOCFG, this will be used for cable detection, quirk
+	 * detection and restoration on detach.
+	 */
+	pci_read_config_dword(pdev, 0x54, &hpriv->saved_iocfg);
+
+	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+	host->private_data = hpriv;
+
+	pci_intx(pdev, 1);
+
+	host->flags |= ATA_HOST_PARALLEL_SCAN;
+
+	pci_set_master(pdev);
+	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &rdc_sht);
+}
+
+static void rdc_remove_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct rdc_host_priv *hpriv = host->private_data;
+
+	pci_write_config_dword(pdev, 0x54, hpriv->saved_iocfg);
+
+	ata_pci_remove_one(pdev);
+}
+
+static const struct pci_device_id rdc_pci_tbl[] = {
+	{ PCI_DEVICE(0x17F3, 0x1011), },
+	{ PCI_DEVICE(0x17F3, 0x1012), },
+	{ }	/* terminate list */
+};
+
+static struct pci_driver rdc_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= rdc_pci_tbl,
+	.probe			= rdc_init_one,
+	.remove			= rdc_remove_one,
+};
+
+
+static int __init rdc_init(void)
+{
+	return pci_register_driver(&rdc_pci_driver);
+}
+
+static void __exit rdc_exit(void)
+{
+	pci_unregister_driver(&rdc_pci_driver);
+}
+
+module_init(rdc_init);
+module_exit(rdc_exit);
+
+MODULE_AUTHOR("Alan Cox (based on ata_piix)");
+MODULE_DESCRIPTION("SCSI low-level driver for RDC PATA controllers");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, rdc_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 0c574c0..a5e4dfe 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -85,7 +85,6 @@ static int rz1000_fifo_disable(struct pci_dev *pdev)
 
 static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
@@ -93,8 +92,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	if (!printed_version++)
-		printk(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
+	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
 	if (rz1000_fifo_disable(pdev) == 0)
 		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL);
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 94eaa43..d344db4 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1257,6 +1257,7 @@ static struct scsi_host_template sata_fsl_sht = {
 static struct ata_port_operations sata_fsl_ops = {
 	.inherits		= &sata_pmp_port_ops,
 
+	.qc_defer = ata_std_qc_defer,
 	.qc_prep = sata_fsl_qc_prep,
 	.qc_issue = sata_fsl_qc_issue,
 	.qc_fill_rtf = sata_fsl_qc_fill_rtf,
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 8d890cc..4406902 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -405,7 +405,7 @@ static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	struct inic_host_priv *hpriv = host->private_data;
 	u16 host_irq_stat;
-	int i, handled = 0;;
+	int i, handled = 0;
 
 	host_irq_stat = readw(hpriv->mmio_base + HOST_IRQ_STAT);
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index c19417e..17f9ff9 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4013,7 +4013,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 
 	host->iomap = NULL;
 	hpriv->base = devm_ioremap(&pdev->dev, res->start,
-				   res->end - res->start + 1);
+				   resource_size(res));
 	hpriv->base -= SATAHC0_REG_BASE;
 
 	/*
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 35bd5cc..3cb69d5 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -565,6 +565,19 @@ static void sil_freeze(struct ata_port *ap)
 	tmp |= SIL_MASK_IDE0_INT << ap->port_no;
 	writel(tmp, mmio_base + SIL_SYSCFG);
 	readl(mmio_base + SIL_SYSCFG);	/* flush */
+
+	/* Ensure DMA_ENABLE is off.
+	 *
+	 * This is because the controller will not give us access to the
+	 * taskfile registers while a DMA is in progress
+	 */
+	iowrite8(ioread8(ap->ioaddr.bmdma_addr) & ~SIL_DMA_ENABLE,
+		 ap->ioaddr.bmdma_addr);
+
+	/* According to ata_bmdma_stop, an HDMA transition requires
+	 * on PIO cycle. But we can't read a taskfile register.
+	 */
+	ioread8(ap->ioaddr.bmdma_addr);
 }
 
 static void sil_thaw(struct ata_port *ap)
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 77aa8d7..e6946fc 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -846,6 +846,17 @@ static void sil24_qc_prep(struct ata_queued_cmd *qc)
 	if (!ata_is_atapi(qc->tf.protocol)) {
 		prb = &cb->ata.prb;
 		sge = cb->ata.sge;
+		if (ata_is_data(qc->tf.protocol)) {
+			u16 prot = 0;
+			ctrl = PRB_CTRL_PROTOCOL;
+			if (ata_is_ncq(qc->tf.protocol))
+				prot |= PRB_PROT_NCQ;
+			if (qc->tf.flags & ATA_TFLAG_WRITE)
+				prot |= PRB_PROT_WRITE;
+			else
+				prot |= PRB_PROT_READ;
+			prb->prot = cpu_to_le16(prot);
+		}
 	} else {
 		prb = &cb->atapi.prb;
 		sge = cb->atapi.sge;
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 8f98332..f8a91bf 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -109,8 +109,9 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sis_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
+static unsigned int get_scr_cfg_addr(struct ata_link *link, unsigned int sc_reg)
 {
+	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int addr = SIS_SCR_BASE + (4 * sc_reg);
 	u8 pmr;
@@ -131,6 +132,9 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 			break;
 		}
 	}
+	if (link->pmp)
+		addr += 0x10;
+
 	return addr;
 }
 
@@ -138,24 +142,12 @@ static u32 sis_scr_cfg_read(struct ata_link *link,
 			    unsigned int sc_reg, u32 *val)
 {
 	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
-	u32 val2 = 0;
-	u8 pmr;
+	unsigned int cfg_addr = get_scr_cfg_addr(link, sc_reg);
 
 	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
 		return -EINVAL;
 
-	pci_read_config_byte(pdev, SIS_PMR, &pmr);
-
 	pci_read_config_dword(pdev, cfg_addr, val);
-
-	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
-	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
-		pci_read_config_dword(pdev, cfg_addr+0x10, &val2);
-
-	*val |= val2;
-	*val &= 0xfffffffb;	/* avoid problems with powerdowned ports */
-
 	return 0;
 }
 
@@ -163,28 +155,16 @@ static int sis_scr_cfg_write(struct ata_link *link,
 			     unsigned int sc_reg, u32 val)
 {
 	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
-	u8 pmr;
-
-	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
-		return -EINVAL;
-
-	pci_read_config_byte(pdev, SIS_PMR, &pmr);
+	unsigned int cfg_addr = get_scr_cfg_addr(link, sc_reg);
 
 	pci_write_config_dword(pdev, cfg_addr, val);
-
-	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
-	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
-		pci_write_config_dword(pdev, cfg_addr+0x10, val);
-
 	return 0;
 }
 
 static int sis_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 pmr;
+	void __iomem *base = ap->ioaddr.scr_addr + link->pmp * 0x10;
 
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
@@ -192,39 +172,23 @@ static int sis_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 	if (ap->flags & SIS_FLAG_CFGSCR)
 		return sis_scr_cfg_read(link, sc_reg, val);
 
-	pci_read_config_byte(pdev, SIS_PMR, &pmr);
-
-	*val = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
-
-	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
-	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
-		*val |= ioread32(ap->ioaddr.scr_addr + (sc_reg * 4) + 0x10);
-
-	*val &= 0xfffffffb;
-
+	*val = ioread32(base + sc_reg * 4);
 	return 0;
 }
 
 static int sis_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 pmr;
+	void __iomem *base = ap->ioaddr.scr_addr + link->pmp * 0x10;
 
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
 
-	pci_read_config_byte(pdev, SIS_PMR, &pmr);
-
 	if (ap->flags & SIS_FLAG_CFGSCR)
 		return sis_scr_cfg_write(link, sc_reg, val);
-	else {
-		iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
-		if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
-		    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
-			iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4)+0x10);
-		return 0;
-	}
+
+	iowrite32(val, base + (sc_reg * 4));
+	return 0;
 }
 
 static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
@@ -236,7 +200,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	u32 genctl, val;
 	u8 pmr;
 	u8 port2_start = 0x20;
-	int rc;
+	int i, rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
@@ -319,6 +283,17 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
+	for (i = 0; i < 2; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap->flags & ATA_FLAG_SATA &&
+		    ap->flags & ATA_FLAG_SLAVE_POSS) {
+			rc = ata_slave_link_init(ap);
+			if (rc)
+				return rc;
+		}
+	}
+
 	if (!(pi.flags & SIS_FLAG_CFGSCR)) {
 		void __iomem *mmio;
 
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 24c84ae..938100f 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -568,35 +568,76 @@ const struct dmi_device * dmi_find_device(int type, const char *name,
 EXPORT_SYMBOL(dmi_find_device);
 
 /**
- *	dmi_get_year - Return year of a DMI date
- *	@field:	data index (like dmi_get_system_info)
+ *	dmi_get_date - parse a DMI date
+ *	@field:	data index (see enum dmi_field)
+ *	@yearp: optional out parameter for the year
+ *	@monthp: optional out parameter for the month
+ *	@dayp: optional out parameter for the day
  *
- *	Returns -1 when the field doesn't exist. 0 when it is broken.
+ *	The date field is assumed to be in the form resembling
+ *	[mm[/dd]]/yy[yy] and the result is stored in the out
+ *	parameters any or all of which can be omitted.
+ *
+ *	If the field doesn't exist, all out parameters are set to zero
+ *	and false is returned.  Otherwise, true is returned with any
+ *	invalid part of date set to zero.
+ *
+ *	On return, year, month and day are guaranteed to be in the
+ *	range of [0,9999], [0,12] and [0,31] respectively.
  */
-int dmi_get_year(int field)
+bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp)
 {
-	int year;
-	const char *s = dmi_get_system_info(field);
+	int year = 0, month = 0, day = 0;
+	bool exists;
+	const char *s, *y;
+	char *e;
 
-	if (!s)
-		return -1;
-	if (*s == '\0')
-		return 0;
-	s = strrchr(s, '/');
-	if (!s)
-		return 0;
+	s = dmi_get_system_info(field);
+	exists = s;
+	if (!exists)
+		goto out;
 
-	s += 1;
-	year = simple_strtoul(s, NULL, 0);
-	if (year && year < 100) {	/* 2-digit year */
+	/*
+	 * Determine year first.  We assume the date string resembles
+	 * mm/dd/yy[yy] but the original code extracted only the year
+	 * from the end.  Keep the behavior in the spirit of no
+	 * surprises.
+	 */
+	y = strrchr(s, '/');
+	if (!y)
+		goto out;
+
+	y++;
+	year = simple_strtoul(y, &e, 10);
+	if (y != e && year < 100) {	/* 2-digit year */
 		year += 1900;
 		if (year < 1996)	/* no dates < spec 1.0 */
 			year += 100;
 	}
+	if (year > 9999)		/* year should fit in %04d */
+		year = 0;
+
+	/* parse the mm and dd */
+	month = simple_strtoul(s, &e, 10);
+	if (s == e || *e != '/' || !month || month > 12) {
+		month = 0;
+		goto out;
+	}
 
-	return year;
+	s = e + 1;
+	day = simple_strtoul(s, &e, 10);
+	if (s == y || s == e || *e != '/' || day > 31)
+		day = 0;
+out:
+	if (yearp)
+		*yearp = year;
+	if (monthp)
+		*monthp = month;
+	if (dayp)
+		*dayp = day;
+	return exists;
 }
-EXPORT_SYMBOL(dmi_get_year);
+EXPORT_SYMBOL(dmi_get_date);
 
 /**
  *	dmi_walk - Walk the DMI table and get called back for every record
diff --git a/drivers/ide/atiixp.c b/drivers/ide/atiixp.c
index 923cbfe..6396c3a 100644
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -177,6 +177,7 @@ static const struct pci_device_id atiixp_pci_tbl[] = {
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), 0 },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), 1 },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), 0 },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_SB900_IDE), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 06b9656..85ce239 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -992,7 +992,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,
 
 static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
 {
-	/* set sb600/sb700/sb800 sata to ahci mode */
+	/* set SBX00 SATA in IDE mode to AHCI mode */
 	u8 tmp;
 
 	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
@@ -1011,6 +1011,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SB900_SATA_IDE, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SB900_SATA_IDE, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 9c75921..6299a25 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -210,15 +210,25 @@ enum {
 	ATA_CMD_STANDBY		= 0xE2, /* place in standby power mode */
 	ATA_CMD_IDLE		= 0xE3, /* place in idle power mode */
 	ATA_CMD_EDD		= 0x90,	/* execute device diagnostic */
+	ATA_CMD_DOWNLOAD_MICRO  = 0x92,
+	ATA_CMD_NOP		= 0x00,
 	ATA_CMD_FLUSH		= 0xE7,
 	ATA_CMD_FLUSH_EXT	= 0xEA,
 	ATA_CMD_ID_ATA		= 0xEC,
 	ATA_CMD_ID_ATAPI	= 0xA1,
+	ATA_CMD_SERVICE		= 0xA2,
 	ATA_CMD_READ		= 0xC8,
 	ATA_CMD_READ_EXT	= 0x25,
+	ATA_CMD_READ_QUEUED	= 0x26,
+	ATA_CMD_READ_STREAM_EXT	= 0x2B,
+	ATA_CMD_READ_STREAM_DMA_EXT = 0x2A,
 	ATA_CMD_WRITE		= 0xCA,
 	ATA_CMD_WRITE_EXT	= 0x35,
+	ATA_CMD_WRITE_QUEUED	= 0x36,
+	ATA_CMD_WRITE_STREAM_EXT = 0x3B,
+	ATA_CMD_WRITE_STREAM_DMA_EXT = 0x3A,
 	ATA_CMD_WRITE_FUA_EXT	= 0x3D,
+	ATA_CMD_WRITE_QUEUED_FUA_EXT = 0x3E,
 	ATA_CMD_FPDMA_READ	= 0x60,
 	ATA_CMD_FPDMA_WRITE	= 0x61,
 	ATA_CMD_PIO_READ	= 0x20,
@@ -235,6 +245,7 @@ enum {
 	ATA_CMD_PACKET		= 0xA0,
 	ATA_CMD_VERIFY		= 0x40,
 	ATA_CMD_VERIFY_EXT	= 0x42,
+	ATA_CMD_WRITE_UNCORR_EXT = 0x45,
 	ATA_CMD_STANDBYNOW1	= 0xE0,
 	ATA_CMD_IDLEIMMEDIATE	= 0xE1,
 	ATA_CMD_SLEEP		= 0xE6,
@@ -243,15 +254,34 @@ enum {
 	ATA_CMD_READ_NATIVE_MAX_EXT = 0x27,
 	ATA_CMD_SET_MAX		= 0xF9,
 	ATA_CMD_SET_MAX_EXT	= 0x37,
-	ATA_CMD_READ_LOG_EXT	= 0x2f,
+	ATA_CMD_READ_LOG_EXT	= 0x2F,
+	ATA_CMD_WRITE_LOG_EXT	= 0x3F,
+	ATA_CMD_READ_LOG_DMA_EXT = 0x47,
+	ATA_CMD_WRITE_LOG_DMA_EXT = 0x57,
+	ATA_CMD_TRUSTED_RCV	= 0x5C,
+	ATA_CMD_TRUSTED_RCV_DMA = 0x5D,
+	ATA_CMD_TRUSTED_SND	= 0x5E,
+	ATA_CMD_TRUSTED_SND_DMA = 0x5F,
 	ATA_CMD_PMP_READ	= 0xE4,
 	ATA_CMD_PMP_WRITE	= 0xE8,
 	ATA_CMD_CONF_OVERLAY	= 0xB1,
+	ATA_CMD_SEC_SET_PASS	= 0xF1,
+	ATA_CMD_SEC_UNLOCK	= 0xF2,
+	ATA_CMD_SEC_ERASE_PREP	= 0xF3,
+	ATA_CMD_SEC_ERASE_UNIT	= 0xF4,
 	ATA_CMD_SEC_FREEZE_LOCK	= 0xF5,
+	ATA_CMD_SEC_DISABLE_PASS = 0xF6,
+	ATA_CMD_CONFIG_STREAM	= 0x51,
 	ATA_CMD_SMART		= 0xB0,
 	ATA_CMD_MEDIA_LOCK	= 0xDE,
 	ATA_CMD_MEDIA_UNLOCK	= 0xDF,
 	ATA_CMD_DSM		= 0x06,
+	ATA_CMD_CHK_MED_CRD_TYP = 0xD1,
+	ATA_CMD_CFA_REQ_EXT_ERR = 0x03,
+	ATA_CMD_CFA_WRITE_NE	= 0x38,
+	ATA_CMD_CFA_TRANS_SECT	= 0x87,
+	ATA_CMD_CFA_ERASE	= 0xC0,
+	ATA_CMD_CFA_WRITE_MULT_NE = 0xCD,
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
 
@@ -306,6 +336,7 @@ enum {
 	/* SETFEATURE Sector counts for SATA features */
 	SATA_AN			= 0x05,  /* Asynchronous Notification */
 	SATA_DIPM		= 0x03,  /* Device Initiated Power Management */
+	SATA_FPDMA_AA		= 0x02,  /* DMA Setup FIS Auto-Activate */
 
 	/* feature values for SET_MAX */
 	ATA_SET_MAX_ADDR	= 0x00,
@@ -525,6 +556,9 @@ static inline int ata_is_data(u8 prot)
 #define ata_id_has_atapi_AN(id)	\
 	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
 	  ((id)[78] & (1 << 5)) )
+#define ata_id_has_fpdma_aa(id)	\
+	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
+	  ((id)[78] & (1 << 2)) )
 #define ata_id_iordy_disable(id) ((id)[ATA_ID_CAPABILITY] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[ATA_ID_CAPABILITY] & (1 << 11))
 #define ata_id_u32(id,n)	\
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index bb5489c..a8a3e1a 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -43,7 +43,7 @@ extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
 extern void dmi_scan_machine(void);
-extern int dmi_get_year(int field);
+extern bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp);
 extern int dmi_name_in_vendors(const char *str);
 extern int dmi_name_in_serial(const char *str);
 extern int dmi_available;
@@ -58,7 +58,16 @@ static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from) { return NULL; }
 static inline void dmi_scan_machine(void) { return; }
-static inline int dmi_get_year(int year) { return 0; }
+static inline bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp)
+{
+	if (yearp)
+		*yearp = 0;
+	if (monthp)
+		*monthp = 0;
+	if (dayp)
+		*dayp = 0;
+	return false;
+}
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
 static inline int dmi_name_in_serial(const char *s) { return 0; }
 #define dmi_available 0
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e5b6e33..76319bf 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -143,7 +143,6 @@ enum {
 
 	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
 	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
 	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
@@ -190,6 +189,7 @@ enum {
 	ATA_FLAG_NO_POWEROFF_SPINDOWN = (1 << 11), /* don't spindown before poweroff */
 	ATA_FLAG_NO_HIBERNATE_SPINDOWN = (1 << 12), /* don't spindown before hibernation */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
+	ATA_FLAG_FPDMA_AA		= (1 << 14), /* driver supports Auto-Activate */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
@@ -386,6 +386,7 @@ enum {
 	ATA_HORKAGE_FIRMWARE_WARN = (1 << 12),	/* firmware update warning */
 	ATA_HORKAGE_1_5_GBPS	= (1 << 13),	/* force 1.5 Gbps */
 	ATA_HORKAGE_NOSETXFER	= (1 << 14),	/* skip SETXFER, SATA only */
+	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 73b46b6..c8fdcad 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -376,6 +376,9 @@
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
 #define PCI_DEVICE_ID_ATI_IXP700_SATA	0x4390
 #define PCI_DEVICE_ID_ATI_IXP700_IDE	0x439c
+/* AMD SB Chipset */
+#define PCI_DEVICE_ID_AMD_SB900_IDE	 0x780c
+#define PCI_DEVICE_ID_AMD_SB900_SATA_IDE 0x7800
 
 #define PCI_VENDOR_ID_VLSI		0x1004
 #define PCI_DEVICE_ID_VLSI_82C592	0x0005
@@ -537,6 +540,7 @@
 #define PCI_DEVICE_ID_AMD_8131_BRIDGE	0x7450
 #define PCI_DEVICE_ID_AMD_8131_APIC	0x7451
 #define PCI_DEVICE_ID_AMD_8132_BRIDGE	0x7458
+#define PCI_DEVICE_ID_AMD_CS5535_IDE    0x208F
 #define PCI_DEVICE_ID_AMD_CS5536_ISA    0x2090
 #define PCI_DEVICE_ID_AMD_CS5536_FLASH  0x2091
 #define PCI_DEVICE_ID_AMD_CS5536_AUDIO  0x2093
