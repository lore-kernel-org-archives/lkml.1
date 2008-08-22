Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYHVHEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYHVHEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYHVHEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:04:14 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45816 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbYHVHEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:04:12 -0400
Date: Fri, 22 Aug 2008 03:04:10 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080822070410.GA6193@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Main items of note:
* Tejun's error handling (soft/hard reset) fixes
* Tejun's sata_mv fix
* Alan's dma_mode fixes

pata_via is a cleanup not a fix, but it is cleaning up some
vendor mistakes, with a net decrease in code size.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/kernel-parameters.txt |    3 ++
 drivers/ata/ahci.c                  |    8 +++--
 drivers/ata/ata_piix.c              |    8 +++++
 drivers/ata/libata-core.c           |   60 +++++++++++++++++++++-------------
 drivers/ata/libata-eh.c             |   30 +++++++----------
 drivers/ata/pata_acpi.c             |    2 +-
 drivers/ata/pata_atiixp.c           |    2 +-
 drivers/ata/pata_cs5530.c           |    6 ++--
 drivers/ata/pata_it821x.c           |    2 +-
 drivers/ata/pata_oldpiix.c          |    2 +-
 drivers/ata/pata_sc1200.c           |    6 ++--
 drivers/ata/pata_via.c              |   59 ++++++----------------------------
 drivers/ata/sata_mv.c               |   37 +++++++--------------
 include/linux/libata.h              |   24 ++++++++++++++
 14 files changed, 123 insertions(+), 126 deletions(-)

Alan Cox (1):
      libata: Fix a large collection of DMA mode mismatches

Jeff Garzik (1):
      [libata] pata_it821x: fix warning

Saeed Bishara (1):
      sata_mv: add the Gen IIE flag to the SoC devices.

Seth Heasley (2):
      ahci: RAID mode SATA patch for Intel Ibex Peak DeviceIDs
      ata_piix: IDE Mode SATA patch for Intel Ibex Peak DeviceIDs

Tejun Heo (8):
      libata: implement no[hs]rst force params
      sata_mv: don't issue two DMA commands concurrently
      libata: fix EH action overwriting in ata_eh_reset()
      libata: always do follow-up SRST if hardreset returned -EAGAIN
      libata: use ata_link_printk() when printing SError
      libata: restore SControl on detach
      pata_via: clean up recent tf_load changes
      ahci: sis controllers actually can do PMP

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a897646..1150444 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1074,6 +1074,9 @@ and is between 256 and 4096 characters. It is defined in the file
 
 			* [no]ncq: Turn on or off NCQ.
 
+			* nohrst, nosrst, norst: suppress hard, soft
+                          and both resets.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ef3e552..c729e69 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -486,6 +486,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -575,9 +577,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */
 
 	/* SiS */
-	{ PCI_VDEVICE(SI, 0x1184), board_ahci_nopmp },		/* SiS 966 */
-	{ PCI_VDEVICE(SI, 0x1185), board_ahci_nopmp },		/* SiS 968 */
-	{ PCI_VDEVICE(SI, 0x0186), board_ahci_nopmp },		/* SiS 968 */
+	{ PCI_VDEVICE(SI, 0x1184), board_ahci },		/* SiS 966 */
+	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
+	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
 
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index c294121..b1d08a8 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -275,6 +275,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (ICH10) */
 	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 
 	{ }	/* terminate list */
 };
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5ba96c5..79e3a8e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -104,6 +104,7 @@ struct ata_force_param {
 	unsigned long	xfer_mask;
 	unsigned int	horkage_on;
 	unsigned int	horkage_off;
+	unsigned int	lflags;
 };
 
 struct ata_force_ent {
@@ -196,22 +197,23 @@ void ata_force_cbl(struct ata_port *ap)
 }
 
 /**
- *	ata_force_spd_limit - force SATA spd limit according to libata.force
+ *	ata_force_link_limits - force link limits according to libata.force
  *	@link: ATA link of interest
  *
- *	Force SATA spd limit according to libata.force and whine about
- *	it.  When only the port part is specified (e.g. 1:), the limit
- *	applies to all links connected to both the host link and all
- *	fan-out ports connected via PMP.  If the device part is
- *	specified as 0 (e.g. 1.00:), it specifies the first fan-out
- *	link not the host link.  Device number 15 always points to the
- *	host link whether PMP is attached or not.
+ *	Force link flags and SATA spd limit according to libata.force
+ *	and whine about it.  When only the port part is specified
+ *	(e.g. 1:), the limit applies to all links connected to both
+ *	the host link and all fan-out ports connected via PMP.  If the
+ *	device part is specified as 0 (e.g. 1.00:), it specifies the
+ *	first fan-out link not the host link.  Device number 15 always
+ *	points to the host link whether PMP is attached or not.
  *
  *	LOCKING:
  *	EH context.
  */
-static void ata_force_spd_limit(struct ata_link *link)
+static void ata_force_link_limits(struct ata_link *link)
 {
+	bool did_spd = false;
 	int linkno, i;
 
 	if (ata_is_host_link(link))
@@ -228,13 +230,22 @@ static void ata_force_spd_limit(struct ata_link *link)
 		if (fe->device != -1 && fe->device != linkno)
 			continue;
 
-		if (!fe->param.spd_limit)
-			continue;
+		/* only honor the first spd limit */
+		if (!did_spd && fe->param.spd_limit) {
+			link->hw_sata_spd_limit = (1 << fe->param.spd_limit) - 1;
+			ata_link_printk(link, KERN_NOTICE,
+					"FORCE: PHY spd limit set to %s\n",
+					fe->param.name);
+			did_spd = true;
+		}
 
-		link->hw_sata_spd_limit = (1 << fe->param.spd_limit) - 1;
-		ata_link_printk(link, KERN_NOTICE,
-			"FORCE: PHY spd limit set to %s\n", fe->param.name);
-		return;
+		/* let lflags stack */
+		if (fe->param.lflags) {
+			link->flags |= fe->param.lflags;
+			ata_link_printk(link, KERN_NOTICE,
+					"FORCE: link flag 0x%x forced -> 0x%x\n",
+					fe->param.lflags, link->flags);
+		}
 	}
 }
 
@@ -3277,7 +3288,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 		dev->dma_mode = ata_xfer_mask2mode(dma_mask);
 
 		found = 1;
-		if (dev->dma_mode != 0xff)
+		if (ata_dma_enabled(dev))
 			used_dma = 1;
 	}
 	if (!found)
@@ -3302,7 +3313,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 
 	/* step 3: set host DMA timings */
 	ata_link_for_each_dev(dev, link) {
-		if (!ata_dev_enabled(dev) || dev->dma_mode == 0xff)
+		if (!ata_dev_enabled(dev) || !ata_dma_enabled(dev))
 			continue;
 
 		dev->xfer_mode = dev->dma_mode;
@@ -5188,19 +5199,18 @@ void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp)
  */
 int sata_link_init_spd(struct ata_link *link)
 {
-	u32 scontrol;
 	u8 spd;
 	int rc;
 
-	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
+	rc = sata_scr_read(link, SCR_CONTROL, &link->saved_scontrol);
 	if (rc)
 		return rc;
 
-	spd = (scontrol >> 4) & 0xf;
+	spd = (link->saved_scontrol >> 4) & 0xf;
 	if (spd)
 		link->hw_sata_spd_limit &= (1 << spd) - 1;
 
-	ata_force_spd_limit(link);
+	ata_force_link_limits(link);
 
 	link->sata_spd_limit = link->hw_sata_spd_limit;
 
@@ -5783,9 +5793,10 @@ static void ata_port_detach(struct ata_port *ap)
 	ata_port_wait_eh(ap);
 
 	/* EH is now guaranteed to see UNLOADING - EH context belongs
-	 * to us.  Disable all existing devices.
+	 * to us.  Restore SControl and disable all existing devices.
 	 */
-	ata_port_for_each_link(link, ap) {
+	__ata_port_for_each_link(link, ap) {
+		sata_scr_write(link, SCR_CONTROL, link->saved_scontrol);
 		ata_link_for_each_dev(dev, link)
 			ata_dev_disable(dev);
 	}
@@ -5991,6 +6002,9 @@ static int __init ata_parse_force_one(char **cur,
 		{ "udma133",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 6) },
 		{ "udma/133",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 6) },
 		{ "udma7",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 7) },
+		{ "nohrst",	.lflags		= ATA_LFLAG_NO_HRST },
+		{ "nosrst",	.lflags		= ATA_LFLAG_NO_SRST },
+		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 58bdc53..c1db2f2 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2040,7 +2040,7 @@ static void ata_eh_link_report(struct ata_link *link)
 	}
 
 	if (ehc->i.serror)
-		ata_port_printk(ap, KERN_ERR,
+		ata_link_printk(link, KERN_ERR,
 		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
 		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
 		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
@@ -2171,18 +2171,12 @@ static int ata_do_reset(struct ata_link *link, ata_reset_fn_t reset,
 }
 
 static int ata_eh_followup_srst_needed(struct ata_link *link,
-				       int rc, int classify,
-				       const unsigned int *classes)
+				       int rc, const unsigned int *classes)
 {
 	if ((link->flags & ATA_LFLAG_NO_SRST) || ata_link_offline(link))
 		return 0;
-	if (rc == -EAGAIN) {
-		if (classify)
-			return 1;
-		rc = 0;
-	}
-	if (rc != 0)
-		return 0;
+	if (rc == -EAGAIN)
+		return 1;
 	if (sata_pmp_supported(link->ap) && ata_is_host_link(link))
 		return 1;
 	return 0;
@@ -2210,6 +2204,10 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 */
 	while (ata_eh_reset_timeouts[max_tries] != ULONG_MAX)
 		max_tries++;
+	if (link->flags & ATA_LFLAG_NO_HRST)
+		hardreset = NULL;
+	if (link->flags & ATA_LFLAG_NO_SRST)
+		softreset = NULL;
 
 	now = jiffies;
 	deadline = ata_deadline(ehc->last_reset, ATA_EH_RESET_COOL_DOWN);
@@ -2247,10 +2245,10 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ehc->i.action &= ~ATA_EH_RESET;
 	if (hardreset) {
 		reset = hardreset;
-		ehc->i.action = ATA_EH_HARDRESET;
+		ehc->i.action |= ATA_EH_HARDRESET;
 	} else if (softreset) {
 		reset = softreset;
-		ehc->i.action = ATA_EH_SOFTRESET;
+		ehc->i.action |= ATA_EH_SOFTRESET;
 	}
 
 	if (prereset) {
@@ -2305,9 +2303,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			ehc->i.flags |= ATA_EHI_DID_SOFTRESET;
 
 		rc = ata_do_reset(link, reset, classes, deadline);
+		if (rc && rc != -EAGAIN)
+			goto fail;
 
 		if (reset == hardreset &&
-		    ata_eh_followup_srst_needed(link, rc, classify, classes)) {
+		    ata_eh_followup_srst_needed(link, rc, classes)) {
 			/* okay, let's do follow-up softreset */
 			reset = softreset;
 
@@ -2322,10 +2322,6 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
 			rc = ata_do_reset(link, reset, classes, deadline);
 		}
-
-		/* -EAGAIN can happen if we skipped followup SRST */
-		if (rc && rc != -EAGAIN)
-			goto fail;
 	} else {
 		if (verbose)
 			ata_link_printk(link, KERN_INFO, "no reset method "
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index fbe6057..eb919c1 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -181,7 +181,7 @@ static unsigned int pacpi_qc_issue(struct ata_queued_cmd *qc)
 
 	if (adev != acpi->last) {
 		pacpi_set_piomode(ap, adev);
-		if (adev->dma_mode)
+		if (ata_dma_enabled(adev))
 			pacpi_set_dmamode(ap, adev);
 		acpi->last = adev;
 	}
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index d7de7ba..e8a0d99 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -183,7 +183,7 @@ static void atiixp_bmdma_start(struct ata_queued_cmd *qc)
 	u16 tmp16;
 
 	pci_read_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
-	if (adev->dma_mode >= XFER_UDMA_0)
+	if (ata_using_udma(adev))
 		tmp16 |= (1 << dn);
 	else
 		tmp16 &= ~(1 << dn);
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 744beeb..0c4b271 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -149,10 +149,10 @@ static unsigned int cs5530_qc_issue(struct ata_queued_cmd *qc)
 	struct ata_device *prev = ap->private_data;
 
 	/* See if the DMA settings could be wrong */
-	if (adev->dma_mode != 0 && adev != prev && prev != NULL) {
+	if (ata_dma_enabled(adev) && adev != prev && prev != NULL) {
 		/* Maybe, but do the channels match MWDMA/UDMA ? */
-		if ((adev->dma_mode >= XFER_UDMA_0 && prev->dma_mode < XFER_UDMA_0) ||
-		    (adev->dma_mode < XFER_UDMA_0 && prev->dma_mode >= XFER_UDMA_0))
+		if ((ata_using_udma(adev) && !ata_using_udma(prev)) ||
+		    (ata_using_udma(prev) && !ata_using_udma(adev)))
 		    	/* Switch the mode bits */
 		    	cs5530_set_dmamode(ap, adev);
 	}
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 27843c7..0221c9a 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -606,7 +606,7 @@ static void it821x_display_disk(int n, u8 *buf)
 {
 	unsigned char id[41];
 	int mode = 0;
-	char *mtype;
+	char *mtype = "";
 	char mbuf[8];
 	char *cbl = "(40 wire cable)";
 
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index e678af3..df64f24 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -198,7 +198,7 @@ static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
 
 	if (adev != ap->private_data) {
 		oldpiix_set_piomode(ap, adev);
-		if (adev->dma_mode)
+		if (ata_dma_enabled(adev))
 			oldpiix_set_dmamode(ap, adev);
 	}
 	return ata_sff_qc_issue(qc);
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index cbab397..0278fd2 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -167,10 +167,10 @@ static unsigned int sc1200_qc_issue(struct ata_queued_cmd *qc)
 	struct ata_device *prev = ap->private_data;
 
 	/* See if the DMA settings could be wrong */
-	if (adev->dma_mode != 0 && adev != prev && prev != NULL) {
+	if (ata_dma_enabled(adev) && adev != prev && prev != NULL) {
 		/* Maybe, but do the channels match MWDMA/UDMA ? */
-		if ((adev->dma_mode >= XFER_UDMA_0 && prev->dma_mode < XFER_UDMA_0) ||
-		    (adev->dma_mode < XFER_UDMA_0 && prev->dma_mode >= XFER_UDMA_0))
+		if ((ata_using_udma(adev) && !ata_using_udma(prev)) ||
+		    (ata_using_udma(prev) && !ata_using_udma(adev)))
 		    	/* Switch the mode bits */
 		    	sc1200_set_dmamode(ap, adev);
 	}
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 57d951b..8fdb2ce 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -324,62 +324,26 @@ static void via_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	via_ata_sff_tf_load - send taskfile registers to host controller
+ *	via_tf_load - send taskfile registers to host controller
  *	@ap: Port to which output is sent
  *	@tf: ATA taskfile register set
  *
  *	Outputs ATA taskfile to standard ATA host controller.
  *
  *	Note: This is to fix the internal bug of via chipsets, which
- *  will reset the device register after changing the IEN bit on
- *  ctl register
+ *	will reset the device register after changing the IEN bit on
+ *	ctl register
  */
-static void via_ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+static void via_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 {
-	struct ata_ioports *ioaddr = &ap->ioaddr;
-	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
-
-	if (tf->ctl != ap->last_ctl) {
-		iowrite8(tf->ctl, ioaddr->ctl_addr);
-		iowrite8(tf->device, ioaddr->device_addr);
-		ap->last_ctl = tf->ctl;
-		ata_wait_idle(ap);
-	}
-
-	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
-		iowrite8(tf->hob_feature, ioaddr->feature_addr);
-		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
-		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
-		iowrite8(tf->hob_lbam, ioaddr->lbam_addr);
-		iowrite8(tf->hob_lbah, ioaddr->lbah_addr);
-		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
-			tf->hob_feature,
-			tf->hob_nsect,
-			tf->hob_lbal,
-			tf->hob_lbam,
-			tf->hob_lbah);
-	}
+	struct ata_taskfile tmp_tf;
 
-	if (is_addr) {
-		iowrite8(tf->feature, ioaddr->feature_addr);
-		iowrite8(tf->nsect, ioaddr->nsect_addr);
-		iowrite8(tf->lbal, ioaddr->lbal_addr);
-		iowrite8(tf->lbam, ioaddr->lbam_addr);
-		iowrite8(tf->lbah, ioaddr->lbah_addr);
-		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
-			tf->feature,
-			tf->nsect,
-			tf->lbal,
-			tf->lbam,
-			tf->lbah);
+	if (ap->ctl != ap->last_ctl && !(tf->flags & ATA_TFLAG_DEVICE)) {
+		tmp_tf = *tf;
+		tmp_tf.flags |= ATA_TFLAG_DEVICE;
+		tf = &tmp_tf;
 	}
-
-	if (tf->flags & ATA_TFLAG_DEVICE) {
-		iowrite8(tf->device, ioaddr->device_addr);
-		VPRINTK("device 0x%X\n", tf->device);
-	}
-
-	ata_wait_idle(ap);
+	ata_sff_tf_load(ap, tf);
 }
 
 static struct scsi_host_template via_sht = {
@@ -392,13 +356,12 @@ static struct ata_port_operations via_port_ops = {
 	.set_piomode	= via_set_piomode,
 	.set_dmamode	= via_set_dmamode,
 	.prereset	= via_pre_reset,
-	.sff_tf_load = via_ata_tf_load,
+	.sff_tf_load	= via_tf_load,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {
 	.inherits	= &via_port_ops,
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
-	.sff_tf_load = via_ata_tf_load,
 };
 
 /**
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index ad169ff..13c1d2a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1134,30 +1134,16 @@ static int mv_qc_defer(struct ata_queued_cmd *qc)
 	if (ap->nr_active_links == 0)
 		return 0;
 
-	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
-		/*
-		 * The port is operating in host queuing mode (EDMA).
-		 * It can accomodate a new qc if the qc protocol
-		 * is compatible with the current host queue mode.
-		 */
-		if (pp->pp_flags & MV_PP_FLAG_NCQ_EN) {
-			/*
-			 * The host queue (EDMA) is in NCQ mode.
-			 * If the new qc is also an NCQ command,
-			 * then allow the new qc.
-			 */
-			if (qc->tf.protocol == ATA_PROT_NCQ)
-				return 0;
-		} else {
-			/*
-			 * The host queue (EDMA) is in non-NCQ, DMA mode.
-			 * If the new qc is also a non-NCQ, DMA command,
-			 * then allow the new qc.
-			 */
-			if (qc->tf.protocol == ATA_PROT_DMA)
-				return 0;
-		}
-	}
+	/*
+	 * The port is operating in host queuing mode (EDMA) with NCQ
+	 * enabled, allow multiple NCQ commands.  EDMA also allows
+	 * queueing multiple DMA commands but libata core currently
+	 * doesn't allow it.
+	 */
+	if ((pp->pp_flags & MV_PP_FLAG_EDMA_EN) &&
+	    (pp->pp_flags & MV_PP_FLAG_NCQ_EN) && ata_is_ncq(qc->tf.protocol))
+		return 0;
+
 	return ATA_DEFER_PORT;
 }
 
@@ -3036,7 +3022,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 	case chip_soc:
 		hpriv->ops = &mv_soc_ops;
-		hp_flags |= MV_HP_FLAG_SOC | MV_HP_ERRATA_60X1C0;
+		hp_flags |= MV_HP_FLAG_SOC | MV_HP_GEN_IIE |
+			MV_HP_ERRATA_60X1C0;
 		break;
 
 	default:
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 06b8033..225bfc5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -163,6 +163,7 @@ enum {
 	ATA_DEV_NONE		= 9,	/* no device */
 
 	/* struct ata_link flags */
+	ATA_LFLAG_NO_HRST	= (1 << 1), /* avoid hardreset */
 	ATA_LFLAG_NO_SRST	= (1 << 2), /* avoid softreset */
 	ATA_LFLAG_ASSUME_ATA	= (1 << 3), /* assume ATA class */
 	ATA_LFLAG_ASSUME_SEMB	= (1 << 4), /* assume SEMB class */
@@ -646,6 +647,7 @@ struct ata_link {
 
 	unsigned int		flags;		/* ATA_LFLAG_xxx */
 
+	u32			saved_scontrol;	/* SControl on probe */
 	unsigned int		hw_sata_spd_limit;
 	unsigned int		sata_spd_limit;
 	unsigned int		sata_spd;	/* current SATA PHY speed */
@@ -1427,6 +1429,28 @@ static inline unsigned long ata_deadline(unsigned long from_jiffies,
 	return from_jiffies + msecs_to_jiffies(timeout_msecs);
 }
 
+/* Don't open code these in drivers as there are traps. Firstly the range may
+   change in future hardware and specs, secondly 0xFF means 'no DMA' but is
+   > UDMA_0. Dyma ddreigiau */
+
+static inline int ata_using_mwdma(struct ata_device *adev)
+{
+	if (adev->dma_mode >= XFER_MW_DMA_0 && adev->dma_mode <= XFER_MW_DMA_4)
+		return 1;
+	return 0;
+}
+
+static inline int ata_using_udma(struct ata_device *adev)
+{
+	if (adev->dma_mode >= XFER_UDMA_0 && adev->dma_mode <= XFER_UDMA_7)
+		return 1;
+	return 0;
+}
+
+static inline int ata_dma_enabled(struct ata_device *adev)
+{
+	return (adev->dma_mode == 0xFF ? 0 : 1);
+}
 
 /**************************************************************************
  * PMP - drivers/ata/libata-pmp.c
