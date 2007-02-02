Return-Path: <linux-kernel-owner+w=401wt.eu-S1945994AbXBBQ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945994AbXBBQ6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945992AbXBBQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:58:45 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42853 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945989AbXBBQ6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:58:44 -0500
Date: Fri, 2 Feb 2007 11:58:42 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070202165842.GA6412@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Brian and Tejun's patches fix really ugly bugs, Alan's are of less
importance

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c  |    1 +
 drivers/ata/pata_atiixp.c  |   11 +++++++++--
 drivers/ata/pata_jmicron.c |   18 +++++-------------
 drivers/ata/pata_via.c     |    3 ++-
 drivers/pci/quirks.c       |    4 ++--
 include/linux/libata.h     |    2 ++
 6 files changed, 21 insertions(+), 18 deletions(-)

Alan (3):
      pata_atiixp: propogate cable detection hack from drivers/ide to the new driver
      pata_via: Correct missing comments
      libata: Fix ata_busy_wait() kernel docs

Brian King (1):
      libata: Initialize nbytes for internal sg commands

Tejun Heo (1):
      ahci/pata_jmicron: fix JMicron quirk

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cf70702..667acd2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1250,6 +1250,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 		ata_sg_init(qc, sg, n_elem);
 		qc->nsect = buflen / ATA_SECT_SIZE;
+		qc->nbytes = buflen;
 	}
 
 	qc->private_data = &wait;
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 6f6672c..504e1db 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -36,15 +36,22 @@ enum {
 static int atiixp_pre_reset(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static struct pci_bits atiixp_enable_bits[] = {
+	static const struct pci_bits atiixp_enable_bits[] = {
 		{ 0x48, 1, 0x01, 0x00 },
 		{ 0x48, 1, 0x08, 0x00 }
 	};
+	u8 udma;
 
 	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	ap->cbl = ATA_CBL_PATA80;
+	/* Hack from drivers/ide/pci. Really we want to know how to do the
+	   raw detection not play follow the bios mode guess */
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
+	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
+		ap->cbl = ATA_CBL_PATA80;
+	else
+		ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 }
 
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 2d661cb..d50264a 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -204,20 +204,12 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 	u32 reg;
 
-	if (id->driver_data != 368) {
-		/* Put the controller into AHCI mode in case the AHCI driver
-		   has not yet been loaded. This can be done with either
-		   function present */
+	/* PATA controller is fn 1, AHCI is fn 0 */
+	if (id->driver_data != 368 && PCI_FUNC(pdev->devfn) != 1)
+		return -ENODEV;
 
-		/* FIXME: We may want a way to override this in future */
-		pci_write_config_byte(pdev, 0x41, 0xa1);
-
-		/* PATA controller is fn 1, AHCI is fn 0 */
-		if (PCI_FUNC(pdev->devfn) != 1)
-			return -ENODEV;
-	}
-	if ( id->driver_data == 365 || id->driver_data == 366) {
-		/* The 365/66 have two PATA channels, redirect the second */
+	/* The 365/66 have two PATA channels, redirect the second */
+	if (id->driver_data == 365 || id->driver_data == 366) {
 		pci_read_config_dword(pdev, 0x80, &reg);
 		reg |= (1 << 24);	/* IDE1 to PATA IDE secondary */
 		pci_write_config_dword(pdev, 0x80, reg);
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 0219419..f0b6c3b 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -23,6 +23,7 @@
  *	VIA VT8233c	-	UDMA100
  *	VIA VT8235	-	UDMA133
  *	VIA VT8237	-	UDMA133
+ *	VIA VT8237S	-	UDMA133
  *	VIA VT8251	-	UDMA133
  *
  *	Most registers remain compatible across chips. Others start reserved
@@ -61,7 +62,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.2.0"
+#define DRV_VERSION "0.2.1"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dcc0c1a..c913ea4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1262,8 +1262,8 @@ static void quirk_jmicron_dualfn(struct pci_dev *pdev)
 			pci_read_config_dword(pdev, 0x40, &conf);
 			/* Enable dual function mode, AHCI on fn 0, IDE fn1 */
 			/* Set the class codes correctly and then direct IDE 0 */
-			conf &= ~0x000F0200;	/* Clear bit 9 and 16-19 */
-			conf |=  0x00C20002;	/* Set bit 1, 17, 22, 23 */
+			conf &= ~0x000FF200; /* Clear bit 9 and 12-19 */
+			conf |=  0x00C2A102; /* Set 1, 8, 13, 15, 17, 22, 23 */
 			pci_write_config_dword(pdev, 0x40, conf);
 
 			/* Reconfigure so that the PCI scanner discovers the
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 22aa69e..91bb8ce 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1054,6 +1054,8 @@ static inline void ata_pause(struct ata_port *ap)
 /**
  *	ata_busy_wait - Wait for a port status register
  *	@ap: Port to wait for.
+ *	@bits: bits that must be clear
+ *	@max: number of 10uS waits to perform
  *
  *	Waits up to max*10 microseconds for the selected bits in the port's
  *	status register to be cleared.
