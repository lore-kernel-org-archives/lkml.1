Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbZJGBDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbZJGBDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbZJGBDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:03:16 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33826 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZJGBDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:03:14 -0400
Date: Tue, 6 Oct 2009 21:02:37 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes and updates, updated
Message-ID: <20091007010237.GA29630@havoc.gtf.org>
References: <20091006045949.GA30588@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006045949.GA30588@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 12:59:49AM -0400, Jeff Garzik wrote:
> 1) ahci: fixes for AMD/ATI SB600 and Aspire 3810T platforms
> 
> 2) ahci: print out more nifty hardware info at startup
> 
> 3) A patch from Dirk!  Thou shalt not "blit" about the tree,
>    apparently.  :)

Appended two more sets of fixes onto the same branch:

4) Bart's pata_atp867x fixes, for the recently-added pata_atp867x

5) link online fix from Tejun

If you already pulled via last night's pull request, you will only
get the new stuff (#4, #5).  Otherwise, you will get all commits listed
below.



Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c         |  193 ++++++++++++++++++++++++++++++--------------
 drivers/ata/libata-acpi.c  |   40 +++++-----
 drivers/ata/libata-core.c  |    3 +
 drivers/ata/libata-eh.c    |   50 +++++++----
 drivers/ata/libata.h       |    2 +
 drivers/ata/pata_ali.c     |    2 +-
 drivers/ata/pata_atp867x.c |  101 ++++++++++++++++-------
 include/linux/ata.h        |    9 ++-
 include/linux/libata.h     |   12 +++
 9 files changed, 280 insertions(+), 132 deletions(-)

Bartlomiej Zolnierkiewicz (3):
      pata_atp867x: fix it to not claim MWDMA support
      pata_atp867x: PIO support fixes
      pata_atp867x: add Power Management support

Dirk Hohndel (1):
      pata_ali: trivial fix of a very frequent spelling mistake

John(Jung-Ik) Lee (1):
      pata_atp867x: clarifications in timings calculations and cable detection

Robert Hancock (1):
      ahci: display all AHCI 1.3 HBA capability flags (v2)

Tejun Heo (6):
      ahci: disable 64bit DMA by default on SB600s
      libata: cosmetic updates
      libata: implement more acpi filtering options
      libata: make gtf_filter per-dev
      ahci: filter FPDMA non-zero offset enable for Aspire 3810T
      libata: fix incorrect link online check during probe

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index acd1162..4edca6e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -122,6 +122,7 @@ enum {
 	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
 	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
 	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
+	HOST_CAP2		= 0x24, /* host capabilities, extended */
 
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
@@ -129,16 +130,29 @@ enum {
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
+	HOST_CAP_SXS		= (1 << 5),  /* Supports External SATA */
 	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
-	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
+	HOST_CAP_CCC		= (1 << 7),  /* Command Completion Coalescing */
+	HOST_CAP_PART		= (1 << 13), /* Partial state capable */
+	HOST_CAP_SSC		= (1 << 14), /* Slumber state capable */
+	HOST_CAP_PIO_MULTI	= (1 << 15), /* PIO multiple DRQ support */
+	HOST_CAP_FBS		= (1 << 16), /* FIS-based switching support */
 	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
+	HOST_CAP_ONLY		= (1 << 18), /* Supports AHCI mode only */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_LED		= (1 << 25), /* Supports activity LED */
 	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
 	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
+	HOST_CAP_MPS		= (1 << 28), /* Mechanical presence switch */
 	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
 	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
 	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
 
+	/* HOST_CAP2 bits */
+	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
+	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
+	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
+
 	/* registers for each SATA port */
 	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
 	PORT_LST_ADDR_HI	= 0x04, /* command list DMA addr hi */
@@ -267,8 +281,10 @@ struct ahci_em_priv {
 struct ahci_host_priv {
 	unsigned int		flags;		/* AHCI_HFLAG_* */
 	u32			cap;		/* cap to use */
+	u32			cap2;		/* cap2 to use */
 	u32			port_map;	/* port map to use */
 	u32			saved_cap;	/* saved initial cap */
+	u32			saved_cap2;	/* saved initial cap2 */
 	u32			saved_port_map;	/* saved initial port_map */
 	u32 			em_loc; /* enclosure management location */
 };
@@ -331,12 +347,15 @@ static void ahci_init_sw_activity(struct ata_link *link);
 
 static ssize_t ahci_show_host_caps(struct device *dev,
 				   struct device_attribute *attr, char *buf);
+static ssize_t ahci_show_host_cap2(struct device *dev,
+				   struct device_attribute *attr, char *buf);
 static ssize_t ahci_show_host_version(struct device *dev,
 				      struct device_attribute *attr, char *buf);
 static ssize_t ahci_show_port_cmd(struct device *dev,
 				  struct device_attribute *attr, char *buf);
 
 DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
+DEVICE_ATTR(ahci_host_cap2, S_IRUGO, ahci_show_host_cap2, NULL);
 DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
 DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
 
@@ -345,6 +364,7 @@ static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_em_message_type,
 	&dev_attr_em_message,
 	&dev_attr_ahci_host_caps,
+	&dev_attr_ahci_host_cap2,
 	&dev_attr_ahci_host_version,
 	&dev_attr_ahci_port_cmd,
 	NULL
@@ -447,7 +467,8 @@ static const struct ata_port_info ahci_port_info[] = {
 	[board_ahci_sb600] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255),
+				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255 |
+				 AHCI_HFLAG_32BIT_ONLY),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
@@ -732,6 +753,16 @@ static ssize_t ahci_show_host_caps(struct device *dev,
 	return sprintf(buf, "%x\n", hpriv->cap);
 }
 
+static ssize_t ahci_show_host_cap2(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+
+	return sprintf(buf, "%x\n", hpriv->cap2);
+}
+
 static ssize_t ahci_show_host_version(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -771,7 +802,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 				     struct ahci_host_priv *hpriv)
 {
 	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
-	u32 cap, port_map;
+	u32 cap, cap2, vers, port_map;
 	int i;
 	int mv;
 
@@ -784,6 +815,14 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
 	hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);
 
+	/* CAP2 register is only defined for AHCI 1.2 and later */
+	vers = readl(mmio + HOST_VERSION);
+	if ((vers >> 16) > 1 ||
+	   ((vers >> 16) == 1 && (vers & 0xFFFF) >= 0x200))
+		hpriv->saved_cap2 = cap2 = readl(mmio + HOST_CAP2);
+	else
+		hpriv->saved_cap2 = cap2 = 0;
+
 	/* some chips have errata preventing 64bit use */
 	if ((cap & HOST_CAP_64) && (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)) {
 		dev_printk(KERN_INFO, &pdev->dev,
@@ -869,6 +908,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 
 	/* record values to use during operation */
 	hpriv->cap = cap;
+	hpriv->cap2 = cap2;
 	hpriv->port_map = port_map;
 }
 
@@ -887,6 +927,8 @@ static void ahci_restore_initial_config(struct ata_host *host)
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 
 	writel(hpriv->saved_cap, mmio + HOST_CAP);
+	if (hpriv->saved_cap2)
+		writel(hpriv->saved_cap2, mmio + HOST_CAP2);
 	writel(hpriv->saved_port_map, mmio + HOST_PORTS_IMPL);
 	(void) readl(mmio + HOST_PORTS_IMPL);	/* flush */
 }
@@ -2534,13 +2576,14 @@ static void ahci_print_info(struct ata_host *host)
 	struct ahci_host_priv *hpriv = host->private_data;
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 vers, cap, impl, speed;
+	u32 vers, cap, cap2, impl, speed;
 	const char *speed_s;
 	u16 cc;
 	const char *scc_s;
 
 	vers = readl(mmio + HOST_VERSION);
 	cap = hpriv->cap;
+	cap2 = hpriv->cap2;
 	impl = hpriv->port_map;
 
 	speed = (cap >> 20) & 0xf;
@@ -2583,25 +2626,29 @@ static void ahci_print_info(struct ata_host *host)
 		"flags: "
 		"%s%s%s%s%s%s%s"
 		"%s%s%s%s%s%s%s"
-		"%s\n"
+		"%s%s%s%s%s%s\n"
 		,
 
-		cap & (1 << 31) ? "64bit " : "",
-		cap & (1 << 30) ? "ncq " : "",
-		cap & (1 << 29) ? "sntf " : "",
-		cap & (1 << 28) ? "ilck " : "",
-		cap & (1 << 27) ? "stag " : "",
-		cap & (1 << 26) ? "pm " : "",
-		cap & (1 << 25) ? "led " : "",
-
-		cap & (1 << 24) ? "clo " : "",
-		cap & (1 << 19) ? "nz " : "",
-		cap & (1 << 18) ? "only " : "",
-		cap & (1 << 17) ? "pmp " : "",
-		cap & (1 << 15) ? "pio " : "",
-		cap & (1 << 14) ? "slum " : "",
-		cap & (1 << 13) ? "part " : "",
-		cap & (1 << 6) ? "ems ": ""
+		cap & HOST_CAP_64 ? "64bit " : "",
+		cap & HOST_CAP_NCQ ? "ncq " : "",
+		cap & HOST_CAP_SNTF ? "sntf " : "",
+		cap & HOST_CAP_MPS ? "ilck " : "",
+		cap & HOST_CAP_SSS ? "stag " : "",
+		cap & HOST_CAP_ALPM ? "pm " : "",
+		cap & HOST_CAP_LED ? "led " : "",
+		cap & HOST_CAP_CLO ? "clo " : "",
+		cap & HOST_CAP_ONLY ? "only " : "",
+		cap & HOST_CAP_PMP ? "pmp " : "",
+		cap & HOST_CAP_FBS ? "fbs " : "",
+		cap & HOST_CAP_PIO_MULTI ? "pio " : "",
+		cap & HOST_CAP_SSC ? "slum " : "",
+		cap & HOST_CAP_PART ? "part " : "",
+		cap & HOST_CAP_CCC ? "ccc " : "",
+		cap & HOST_CAP_EMS ? "ems " : "",
+		cap & HOST_CAP_SXS ? "sxs " : "",
+		cap2 & HOST_CAP2_APST ? "apst " : "",
+		cap2 & HOST_CAP2_NVMHCI ? "nvmp " : "",
+		cap2 & HOST_CAP2_BOH ? "boh " : ""
 		);
 }
 
@@ -2650,17 +2697,15 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 	}
 }
 
-/*
- * SB600 ahci controller on certain boards can't do 64bit DMA with
- * older BIOS.
- */
-static bool ahci_sb600_32bit_only(struct pci_dev *pdev)
+/* only some SB600 ahci controllers can do 64bit DMA */
+static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 {
 	static const struct dmi_system_id sysids[] = {
 		/*
 		 * The oldest version known to be broken is 0901 and
 		 * working is 1501 which was released on 2007-10-26.
-		 * Force 32bit DMA on anything older than 1501.
+		 * Enable 64bit DMA on 1501 and anything newer.
+		 *
 		 * Please read bko#9412 for more info.
 		 */
 		{
@@ -2672,48 +2717,29 @@ static bool ahci_sb600_32bit_only(struct pci_dev *pdev)
 			},
 			.driver_data = "20071026",	/* yyyymmdd */
 		},
-		/*
-		 * It's yet unknown whether more recent BIOS fixes the
-		 * problem.  Blacklist the whole board for the time
-		 * being.  Please read the following thread for more
-		 * info.
-		 *
-		 * http://thread.gmane.org/gmane.linux.ide/42326
-		 */
-		{
-			.ident = "Gigabyte GA-MA69VM-S2",
-			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "Gigabyte Technology Co., Ltd."),
-				DMI_MATCH(DMI_BOARD_NAME, "GA-MA69VM-S2"),
-			},
-		},
 		{ }
 	};
 	const struct dmi_system_id *match;
+	int year, month, date;
+	char buf[9];
 
 	match = dmi_first_match(sysids);
 	if (pdev->bus->number != 0 || pdev->devfn != PCI_DEVFN(0x12, 0) ||
 	    !match)
 		return false;
 
-	if (match->driver_data) {
-		int year, month, date;
-		char buf[9];
-
-		dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
-		snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
-
-		if (strcmp(buf, match->driver_data) >= 0)
-			return false;
+	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
+	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
 
+	if (strcmp(buf, match->driver_data) >= 0) {
+		dev_printk(KERN_WARNING, &pdev->dev, "%s: enabling 64bit DMA\n",
+			   match->ident);
+		return true;
+	} else {
 		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, "
 			   "forcing 32bit DMA, update BIOS\n", match->ident);
-	} else
-		dev_printk(KERN_WARNING, &pdev->dev, "%s: this board can't "
-			   "do 64bit DMA, forcing 32bit\n", match->ident);
-
-	return true;
+		return false;
+	}
 }
 
 static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
@@ -2858,6 +2884,50 @@ static bool ahci_broken_online(struct pci_dev *pdev)
 	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
 }
 
+static void ahci_gtf_filter_workaround(struct ata_host *host)
+{
+	static const struct dmi_system_id sysids[] = {
+		/*
+		 * Aspire 3810T issues a bunch of SATA enable commands
+		 * via _GTF including an invalid one and one which is
+		 * rejected by the device.  Among the successful ones
+		 * is FPDMA non-zero offset enable which when enabled
+		 * only on the drive side leads to NCQ command
+		 * failures.  Filter it out.
+		 */
+		{
+			.ident = "Aspire 3810T",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3810T"),
+			},
+			.driver_data = (void *)ATA_ACPI_FILTER_FPDMA_OFFSET,
+		},
+		{ }
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	unsigned int filter;
+	int i;
+
+	if (!dmi)
+		return;
+
+	filter = (unsigned long)dmi->driver_data;
+	dev_printk(KERN_INFO, host->dev,
+		   "applying extra ACPI _GTF filter 0x%x for %s\n",
+		   filter, dmi->ident);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		struct ata_link *link;
+		struct ata_device *dev;
+
+		ata_for_each_link(link, ap, EDGE)
+			ata_for_each_dev(dev, link, ALL)
+				dev->gtf_filter |= filter;
+	}
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2926,9 +2996,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
 		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
 
-	/* apply sb600 32bit only quirk */
-	if (ahci_sb600_32bit_only(pdev))
-		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
+	/* only some SB600s can do 64bit DMA */
+	if (ahci_sb600_enable_64bit(pdev))
+		hpriv->flags &= ~AHCI_HFLAG_32BIT_ONLY;
 
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
@@ -3023,6 +3093,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* apply workaround for ASUS P5W DH Deluxe mainboard */
 	ahci_p5wdh_workaround(host);
 
+	/* apply gtf filter quirk */
+	ahci_gtf_filter_workaround(host);
+
 	/* initialize adapter */
 	rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
 	if (rc)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 01964b6..b0882cd 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -20,19 +20,9 @@
 
 #include <acpi/acpi_bus.h>
 
-enum {
-	ATA_ACPI_FILTER_SETXFER	= 1 << 0,
-	ATA_ACPI_FILTER_LOCK	= 1 << 1,
-	ATA_ACPI_FILTER_DIPM	= 1 << 2,
-
-	ATA_ACPI_FILTER_DEFAULT	= ATA_ACPI_FILTER_SETXFER |
-				  ATA_ACPI_FILTER_LOCK |
-				  ATA_ACPI_FILTER_DIPM,
-};
-
-static unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
+unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
 module_param_named(acpi_gtf_filter, ata_acpi_gtf_filter, int, 0644);
-MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze lock, 0x4=DIPM)");
+MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze lock, 0x4=DIPM, 0x8=FPDMA non-zero offset, 0x10=FPDMA DMA Setup FIS auto-activate)");
 
 #define NO_PORT_MULT		0xffff
 #define SATA_ADR(root, pmp)	(((root) << 16) | (pmp))
@@ -613,10 +603,11 @@ static void ata_acpi_gtf_to_tf(struct ata_device *dev,
 	tf->command = gtf->tf[6];	/* 0x1f7 */
 }
 
-static int ata_acpi_filter_tf(const struct ata_taskfile *tf,
+static int ata_acpi_filter_tf(struct ata_device *dev,
+			      const struct ata_taskfile *tf,
 			      const struct ata_taskfile *ptf)
 {
-	if (ata_acpi_gtf_filter & ATA_ACPI_FILTER_SETXFER) {
+	if (dev->gtf_filter & ATA_ACPI_FILTER_SETXFER) {
 		/* libata doesn't use ACPI to configure transfer mode.
 		 * It will only confuse device configuration.  Skip.
 		 */
@@ -625,7 +616,7 @@ static int ata_acpi_filter_tf(const struct ata_taskfile *tf,
 			return 1;
 	}
 
-	if (ata_acpi_gtf_filter & ATA_ACPI_FILTER_LOCK) {
+	if (dev->gtf_filter & ATA_ACPI_FILTER_LOCK) {
 		/* BIOS writers, sorry but we don't wanna lock
 		 * features unless the user explicitly said so.
 		 */
@@ -647,12 +638,23 @@ static int ata_acpi_filter_tf(const struct ata_taskfile *tf,
 			return 1;
 	}
 
-	if (ata_acpi_gtf_filter & ATA_ACPI_FILTER_DIPM) {
+	if (tf->command == ATA_CMD_SET_FEATURES &&
+	    tf->feature == SETFEATURES_SATA_ENABLE) {
 		/* inhibit enabling DIPM */
-		if (tf->command == ATA_CMD_SET_FEATURES &&
-		    tf->feature == SETFEATURES_SATA_ENABLE &&
+		if (dev->gtf_filter & ATA_ACPI_FILTER_DIPM &&
 		    tf->nsect == SATA_DIPM)
 			return 1;
+
+		/* inhibit FPDMA non-zero offset */
+		if (dev->gtf_filter & ATA_ACPI_FILTER_FPDMA_OFFSET &&
+		    (tf->nsect == SATA_FPDMA_OFFSET ||
+		     tf->nsect == SATA_FPDMA_IN_ORDER))
+			return 1;
+
+		/* inhibit FPDMA auto activation */
+		if (dev->gtf_filter & ATA_ACPI_FILTER_FPDMA_AA &&
+		    tf->nsect == SATA_FPDMA_AA)
+			return 1;
 	}
 
 	return 0;
@@ -704,7 +706,7 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 		pptf = &ptf;
 	}
 
-	if (!ata_acpi_filter_tf(&tf, pptf)) {
+	if (!ata_acpi_filter_tf(dev, &tf, pptf)) {
 		rtf = tf;
 		err_mask = ata_exec_internal(dev, &rtf, NULL,
 					     DMA_NONE, NULL, 0, 0);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0ddaf43..b525a09 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5591,6 +5591,9 @@ void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp)
 
 		dev->link = link;
 		dev->devno = dev - link->device;
+#ifdef CONFIG_ATA_ACPI
+		dev->gtf_filter = ata_acpi_gtf_filter;
+#endif
 		ata_dev_init(dev);
 	}
 }
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a04488f..0a97822 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2667,14 +2667,14 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		dev->pio_mode = XFER_PIO_0;
 		dev->flags &= ~ATA_DFLAG_SLEEPING;
 
-		if (!ata_phys_link_offline(ata_dev_phys_link(dev))) {
-			/* apply class override */
-			if (lflags & ATA_LFLAG_ASSUME_ATA)
-				classes[dev->devno] = ATA_DEV_ATA;
-			else if (lflags & ATA_LFLAG_ASSUME_SEMB)
-				classes[dev->devno] = ATA_DEV_SEMB_UNSUP;
-		} else
-			classes[dev->devno] = ATA_DEV_NONE;
+		if (ata_phys_link_offline(ata_dev_phys_link(dev)))
+			continue;
+
+		/* apply class override */
+		if (lflags & ATA_LFLAG_ASSUME_ATA)
+			classes[dev->devno] = ATA_DEV_ATA;
+		else if (lflags & ATA_LFLAG_ASSUME_SEMB)
+			classes[dev->devno] = ATA_DEV_SEMB_UNSUP;
 	}
 
 	/* record current link speed */
@@ -2713,34 +2713,48 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
-	/* Make sure onlineness and classification result correspond.
+	/*
+	 * Make sure onlineness and classification result correspond.
 	 * Hotplug could have happened during reset and some
 	 * controllers fail to wait while a drive is spinning up after
 	 * being hotplugged causing misdetection.  By cross checking
-	 * link onlineness and classification result, those conditions
-	 * can be reliably detected and retried.
+	 * link on/offlineness and classification result, those
+	 * conditions can be reliably detected and retried.
 	 */
 	nr_unknown = 0;
 	ata_for_each_dev(dev, link, ALL) {
-		/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
-		if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
-			classes[dev->devno] = ATA_DEV_NONE;
-			if (ata_phys_link_online(ata_dev_phys_link(dev)))
+		if (ata_phys_link_online(ata_dev_phys_link(dev))) {
+			if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
+				ata_dev_printk(dev, KERN_DEBUG, "link online "
+					       "but device misclassifed\n");
+				classes[dev->devno] = ATA_DEV_NONE;
 				nr_unknown++;
+			}
+		} else if (ata_phys_link_offline(ata_dev_phys_link(dev))) {
+			if (ata_class_enabled(classes[dev->devno]))
+				ata_dev_printk(dev, KERN_DEBUG, "link offline, "
+					       "clearing class %d to NONE\n",
+					       classes[dev->devno]);
+			classes[dev->devno] = ATA_DEV_NONE;
+		} else if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
+			ata_dev_printk(dev, KERN_DEBUG, "link status unknown, "
+				       "clearing UNKNOWN to NONE\n");
+			classes[dev->devno] = ATA_DEV_NONE;
 		}
 	}
 
 	if (classify && nr_unknown) {
 		if (try < max_tries) {
 			ata_link_printk(link, KERN_WARNING, "link online but "
-				       "device misclassified, retrying\n");
+					"%d devices misclassified, retrying\n",
+					nr_unknown);
 			failed_link = link;
 			rc = -EAGAIN;
 			goto fail;
 		}
 		ata_link_printk(link, KERN_WARNING,
-			       "link online but device misclassified, "
-			       "device detection might fail\n");
+				"link online but %d devices misclassified, "
+				"device detection might fail\n", nr_unknown);
 	}
 
 	/* reset successful, schedule revalidation */
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index be8e262..823e630 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -118,6 +118,8 @@ extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
+extern unsigned int ata_acpi_gtf_filter;
+
 extern void ata_acpi_associate_sata_port(struct ata_port *ap);
 extern void ata_acpi_associate(struct ata_host *host);
 extern void ata_acpi_dissociate(struct ata_host *host);
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index fc9c5d6..1432dc9 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -290,7 +290,7 @@ static void ali_warn_atapi_dma(struct ata_device *adev)
 
 	if (print_info && adev->class == ATA_DEV_ATAPI && !ali_atapi_dma) {
 		ata_dev_printk(adev, KERN_WARNING,
-			       "WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled\n");
+			       "WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled\n");
 		ata_dev_printk(adev, KERN_WARNING,
 			       "WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.\n");
 	}
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
index 7990de9..6fe7ded 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -118,20 +118,13 @@ struct atp867x_priv {
 	int		pci66mhz;
 };
 
-static inline u8 atp867x_speed_to_mode(u8 speed)
-{
-	return speed - XFER_UDMA_0 + 1;
-}
-
 static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	struct atp867x_priv *dp = ap->private_data;
 	u8 speed = adev->dma_mode;
 	u8 b;
-	u8 mode;
-
-	mode = atp867x_speed_to_mode(speed);
+	u8 mode = speed - XFER_UDMA_0 + 1;
 
 	/*
 	 * Doc 6.6.9: decrease the udma mode value by 1 for safer UDMA speed
@@ -156,25 +149,38 @@ static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	iowrite8(b, dp->dma_mode);
 }
 
-static int atp867x_get_active_clocks_shifted(unsigned int clk)
+static int atp867x_get_active_clocks_shifted(struct ata_port *ap,
+	unsigned int clk)
 {
+	struct atp867x_priv *dp = ap->private_data;
 	unsigned char clocks = clk;
 
+	/*
+	 * Doc 6.6.9: increase the clock value by 1 for safer PIO speed
+	 * on 66MHz bus
+	 */
+	if (dp->pci66mhz)
+		clocks++;
+
 	switch (clocks) {
 	case 0:
 		clocks = 1;
 		break;
-	case 1 ... 7:
-		break;
-	case 8 ... 12:
-		clocks = 7;
+	case 1 ... 6:
 		break;
 	default:
 		printk(KERN_WARNING "ATP867X: active %dclk is invalid. "
-			"Using default 8clk.\n", clk);
-		clocks = 0;	/* 8 clk */
+			"Using 12clk.\n", clk);
+	case 9 ... 12:
+		clocks = 7;	/* 12 clk */
 		break;
+	case 7:
+	case 8:	/* default 8 clk */
+		clocks = 0;
+		goto active_clock_shift_done;
 	}
+
+active_clock_shift_done:
 	return clocks << ATP867X_IO_PIOSPD_ACTIVE_SHIFT;
 }
 
@@ -188,20 +194,20 @@ static int atp867x_get_recover_clocks_shifted(unsigned int clk)
 		break;
 	case 1 ... 11:
 		break;
-	case 12:
-		clocks = 0;
-		break;
-	case 13: case 14:
-		--clocks;
+	case 13:
+	case 14:
+		--clocks;	/* by the spec */
 		break;
 	case 15:
 		break;
 	default:
 		printk(KERN_WARNING "ATP867X: recover %dclk is invalid. "
-			"Using default 15clk.\n", clk);
-		clocks = 0;	/* 12 clk */
+			"Using default 12clk.\n", clk);
+	case 12:	/* default 12 clk */
+		clocks = 0;
 		break;
 	}
+
 	return clocks << ATP867X_IO_PIOSPD_RECOVER_SHIFT;
 }
 
@@ -230,25 +236,38 @@ static void atp867x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK);
 	iowrite8(b, dp->dma_mode);
 
-	b = atp867x_get_active_clocks_shifted(t.active) |
-		atp867x_get_recover_clocks_shifted(t.recover);
-	if (dp->pci66mhz)
-		b += 0x10;
+	b = atp867x_get_active_clocks_shifted(ap, t.active) |
+	    atp867x_get_recover_clocks_shifted(t.recover);
 
 	if (adev->devno & 1)
 		iowrite8(b, dp->slave_piospd);
 	else
 		iowrite8(b, dp->mstr_piospd);
 
-	/*
-	 * use the same value for comand timing as for PIO timimg
-	 */
+	b = atp867x_get_active_clocks_shifted(ap, t.act8b) |
+	    atp867x_get_recover_clocks_shifted(t.rec8b);
+
 	iowrite8(b, dp->eightb_piospd);
 }
 
+static int atp867x_cable_override(struct pci_dev *pdev)
+{
+	if (pdev->subsystem_vendor == PCI_VENDOR_ID_ARTOP &&
+		(pdev->subsystem_device == PCI_DEVICE_ID_ARTOP_ATP867A ||
+		 pdev->subsystem_device == PCI_DEVICE_ID_ARTOP_ATP867B)) {
+		return 1;
+	}
+	return 0;
+}
+
 static int atp867x_cable_detect(struct ata_port *ap)
 {
-	return ATA_CBL_PATA40_SHORT;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (atp867x_cable_override(pdev))
+		return ATA_CBL_PATA40_SHORT;
+
+	return ATA_CBL_PATA_UNK;
 }
 
 static struct scsi_host_template atp867x_sht = {
@@ -471,7 +490,6 @@ static int atp867x_init_one(struct pci_dev *pdev,
 	static const struct ata_port_info info_867x = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA6,
 		.port_ops	= &atp867x_ops,
 	};
@@ -515,6 +533,23 @@ err_out:
 	return rc;
 }
 
+#ifdef CONFIG_PM
+static int atp867x_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	atp867x_fixup(host);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static struct pci_device_id atp867x_pci_tbl[] = {
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP867A),	0 },
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP867B),	0 },
@@ -526,6 +561,10 @@ static struct pci_driver atp867x_driver = {
 	.id_table 	= atp867x_pci_tbl,
 	.probe 		= atp867x_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= atp867x_reinit_one,
+#endif
 };
 
 static int __init atp867x_init(void)
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 6299a25..4fb3573 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -334,9 +334,12 @@ enum {
 	SETFEATURES_SATA_DISABLE = 0x90, /* Disable use of SATA feature */
 
 	/* SETFEATURE Sector counts for SATA features */
-	SATA_AN			= 0x05,  /* Asynchronous Notification */
-	SATA_DIPM		= 0x03,  /* Device Initiated Power Management */
-	SATA_FPDMA_AA		= 0x02,  /* DMA Setup FIS Auto-Activate */
+	SATA_FPDMA_OFFSET	= 0x01,	/* FPDMA non-zero buffer offsets */
+	SATA_FPDMA_AA		= 0x02, /* FPDMA Setup FIS Auto-Activate */
+	SATA_DIPM		= 0x03,	/* Device Initiated Power Management */
+	SATA_FPDMA_IN_ORDER	= 0x04,	/* FPDMA in-order data delivery */
+	SATA_AN			= 0x05,	/* Asynchronous Notification */
+	SATA_SSP		= 0x06,	/* Software Settings Preservation */
 
 	/* feature values for SET_MAX */
 	ATA_SET_MAX_ADDR	= 0x00,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 76319bf..8769864 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -418,6 +418,17 @@ enum {
 				  ATA_TIMING_ACTIVE | ATA_TIMING_RECOVER |
 				  ATA_TIMING_DMACK_HOLD | ATA_TIMING_CYCLE |
 				  ATA_TIMING_UDMA,
+
+	/* ACPI constants */
+	ATA_ACPI_FILTER_SETXFER	= 1 << 0,
+	ATA_ACPI_FILTER_LOCK	= 1 << 1,
+	ATA_ACPI_FILTER_DIPM	= 1 << 2,
+	ATA_ACPI_FILTER_FPDMA_OFFSET = 1 << 3,	/* FPDMA non-zero offset */
+	ATA_ACPI_FILTER_FPDMA_AA = 1 << 4,	/* FPDMA auto activate */
+
+	ATA_ACPI_FILTER_DEFAULT	= ATA_ACPI_FILTER_SETXFER |
+				  ATA_ACPI_FILTER_LOCK |
+				  ATA_ACPI_FILTER_DIPM,
 };
 
 enum ata_xfer_mask {
@@ -587,6 +598,7 @@ struct ata_device {
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
 	union acpi_object	*gtf_cache;
+	unsigned int		gtf_filter;
 #endif
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
