Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZJPK0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZJPK0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZJPK0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:26:38 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55407 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZJPK0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:26:37 -0400
Date: Fri, 16 Oct 2009 06:26:00 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Greg KH <greg@kroah.com>
Subject: [git patches] libata fixes
Message-ID: <20091016102600.GA17371@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note that this touches old-IDE and pci/quirks in trivial ways; vendor
patch, SB900 does not exist / will not exist as chip name.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    3 ++-
 drivers/ata/libata-core.c |   12 +++++++-----
 drivers/ata/libata-eh.c   |    6 ++++--
 drivers/ata/pata_atiixp.c |    2 +-
 drivers/ata/pata_sc1200.c |    3 +--
 drivers/ata/pata_via.c    |    2 +-
 drivers/ata/sata_mv.c     |   29 +++++++++++++++++++++++++++--
 drivers/ata/sata_nv.c     |   18 +++++++++++++++---
 drivers/ide/atiixp.c      |    2 +-
 drivers/pci/quirks.c      |    6 +++---
 include/linux/pci_ids.h   |    6 ++----
 11 files changed, 64 insertions(+), 25 deletions(-)

Alan Cox (1):
      pata_sc1200: Fix crash on boot

Gwendal Grignou (1):
      sata_mv: Prevent PIO commands to be defered too long if traffic in progress.

JosephChan@via.com.tw (1):
      pata_via: extend the rev_max for VT6330

Shane Huang (1):
      ahci / atiixp / pci quirks: rename AMD SB900 into Hudson-2

Tejun Heo (3):
      sata_nv: make sure link is brough up online when skipping hardreset
      libata: fix PMP initialization
      libata: fix internal command failure handling

peer chen (1):
      ahci: Add the AHCI controller Linux Device ID for NVIDIA chipsets.

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b1a2577..a06f5d6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -575,7 +575,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ATI, 0x4395), board_ahci_sb700 }, /* ATI SB700/800 */
 
 	/* AMD */
-	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD SB900 */
+	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
@@ -605,6 +605,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
 	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b525a09..d7f0f1b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5028,12 +5028,14 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 			qc->flags |= ATA_QCFLAG_FAILED;
 
 		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
-			if (!ata_tag_internal(qc->tag)) {
-				/* always fill result TF for failed qc */
-				fill_result_tf(qc);
+			/* always fill result TF for failed qc */
+			fill_result_tf(qc);
+
+			if (!ata_tag_internal(qc->tag))
 				ata_qc_schedule_eh(qc);
-				return;
-			}
+			else
+				__ata_qc_complete(qc);
+			return;
 		}
 
 		WARN_ON_ONCE(ap->pflags & ATA_PFLAG_FROZEN);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0a97822..bba2ae5 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2981,12 +2981,14 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 	 * device detection messages backwards.
 	 */
 	ata_for_each_dev(dev, link, ALL) {
-		if (!(new_mask & (1 << dev->devno)) ||
-		    dev->class == ATA_DEV_PMP)
+		if (!(new_mask & (1 << dev->devno)))
 			continue;
 
 		dev->class = ehc->classes[dev->devno];
 
+		if (dev->class == ATA_DEV_PMP)
+			continue;
+
 		ehc->i.flags |= ATA_EHI_PRINTINFO;
 		rc = ata_dev_configure(dev);
 		ehc->i.flags &= ~ATA_EHI_PRINTINFO;
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index aa4b3f6..ae4454d 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -246,7 +246,7 @@ static const struct pci_device_id atiixp[] = {
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), },
-	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_SB900_IDE), },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_HUDSON2_IDE), },
 
 	{ },
 };
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index f49814d..3bbed83 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -235,8 +235,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = ATA_UDMA2,
 		.port_ops = &sc1200_port_ops
 	};
-	/* Can't enable port 2 yet, see top comments */
-	const struct ata_port_info *ppi[] = { &info, };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
 }
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 45657ca..88984b8 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -111,7 +111,7 @@ static const struct via_isa_bridge {
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
+	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
 	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 17f9ff9..6f5093b 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1382,6 +1382,25 @@ static int mv_qc_defer(struct ata_queued_cmd *qc)
 	 */
 	if (pp->pp_flags & MV_PP_FLAG_DELAYED_EH)
 		return ATA_DEFER_PORT;
+
+	/* PIO commands need exclusive link: no other commands [DMA or PIO]
+	 * can run concurrently.
+	 * set excl_link when we want to send a PIO command in DMA mode
+	 * or a non-NCQ command in NCQ mode.
+	 * When we receive a command from that link, and there are no
+	 * outstanding commands, mark a flag to clear excl_link and let
+	 * the command go through.
+	 */
+	if (unlikely(ap->excl_link)) {
+		if (link == ap->excl_link) {
+			if (ap->nr_active_links)
+				return ATA_DEFER_PORT;
+			qc->flags |= ATA_QCFLAG_CLEAR_EXCL;
+			return 0;
+		} else
+			return ATA_DEFER_PORT;
+	}
+
 	/*
 	 * If the port is completely idle, then allow the new qc.
 	 */
@@ -1395,8 +1414,14 @@ static int mv_qc_defer(struct ata_queued_cmd *qc)
 	 * doesn't allow it.
 	 */
 	if ((pp->pp_flags & MV_PP_FLAG_EDMA_EN) &&
-	    (pp->pp_flags & MV_PP_FLAG_NCQ_EN) && ata_is_ncq(qc->tf.protocol))
-		return 0;
+	    (pp->pp_flags & MV_PP_FLAG_NCQ_EN)) {
+		if (ata_is_ncq(qc->tf.protocol))
+			return 0;
+		else {
+			ap->excl_link = link;
+			return ATA_DEFER_PORT;
+		}
+	}
 
 	return ATA_DEFER_PORT;
 }
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 86a4058..1eb4e02 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1594,9 +1594,21 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
 	    !ata_dev_enabled(link->device))
 		sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
 				    NULL, NULL);
-	else if (!(ehc->i.flags & ATA_EHI_QUIET))
-		ata_link_printk(link, KERN_INFO,
-				"nv: skipping hardreset on occupied port\n");
+	else {
+		const unsigned long *timing = sata_ehc_deb_timing(ehc);
+		int rc;
+
+		if (!(ehc->i.flags & ATA_EHI_QUIET))
+			ata_link_printk(link, KERN_INFO, "nv: skipping "
+					"hardreset on occupied port\n");
+
+		/* make sure the link is online */
+		rc = sata_link_resume(link, timing, deadline);
+		/* whine about phy resume failure but proceed */
+		if (rc && rc != -EOPNOTSUPP)
+			ata_link_printk(link, KERN_WARNING, "failed to resume "
+					"link (errno=%d)\n", rc);
+	}
 
 	/* device signature acquisition is unreliable */
 	return -EAGAIN;
diff --git a/drivers/ide/atiixp.c b/drivers/ide/atiixp.c
index 6396c3a..837322b 100644
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -177,7 +177,7 @@ static const struct pci_device_id atiixp_pci_tbl[] = {
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), 0 },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), 1 },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), 0 },
-	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_SB900_IDE), 0 },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_HUDSON2_IDE), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a790b17..245d2cd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1009,7 +1009,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,
 
 static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
 {
-	/* set SBX00 SATA in IDE mode to AHCI mode */
+	/* set SBX00/Hudson-2 SATA in IDE mode to AHCI mode */
 	u8 tmp;
 
 	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
@@ -1028,8 +1028,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SB900_SATA_IDE, quirk_amd_ide_mode);
-DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SB900_SATA_IDE, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f490e7a..86257a4 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -379,9 +379,6 @@
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
 #define PCI_DEVICE_ID_ATI_IXP700_SATA	0x4390
 #define PCI_DEVICE_ID_ATI_IXP700_IDE	0x439c
-/* AMD SB Chipset */
-#define PCI_DEVICE_ID_AMD_SB900_IDE	 0x780c
-#define PCI_DEVICE_ID_AMD_SB900_SATA_IDE 0x7800
 
 #define PCI_VENDOR_ID_VLSI		0x1004
 #define PCI_DEVICE_ID_VLSI_82C592	0x0005
@@ -553,9 +550,10 @@
 #define PCI_DEVICE_ID_AMD_CS5536_UDC    0x2096
 #define PCI_DEVICE_ID_AMD_CS5536_UOC    0x2097
 #define PCI_DEVICE_ID_AMD_CS5536_IDE    0x209A
-
 #define PCI_DEVICE_ID_AMD_LX_VIDEO  0x2081
 #define PCI_DEVICE_ID_AMD_LX_AES    0x2082
+#define PCI_DEVICE_ID_AMD_HUDSON2_IDE		0x780c
+#define PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE	0x7800
 
 #define PCI_VENDOR_ID_TRIDENT		0x1023
 #define PCI_DEVICE_ID_TRIDENT_4DWAVE_DX	0x2000
