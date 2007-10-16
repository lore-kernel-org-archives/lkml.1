Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbXJPA5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbXJPA5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXJPA5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:57:13 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49297 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXJPA5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:57:12 -0400
Date: Mon, 15 Oct 2007 20:57:11 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sc1200 pci cleanup, resume improvement, bug fix
Message-ID: <20071016005711.GA14753@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch accomplishes the following goals:

* kill the 'pci_enable_device ret val not checked' warning

* eliminate the incorrect mucking with pci_dev::current_state

via the following changes:

* [minor bug fix] eliminate pci_set_power_state() call in resume,
  pci_enable_device() does so for us.

* [bug fix] do not touch dev->current_state, pci_set_power_state()
  and other PCI layer functions manage this for us.

* [minor bug fix, warning fix] check pci_enable_device() ret val in
  resume, and do not bring up interfaces if it fails (which it might)

* eliminate lookup_pci_dev(), a needless loop over a global list, by
  storing our associated hwif in a struct allocated at probe time.

* introduce __ide_setup_pci_device() to facilitate making PCI drivers
  aware of the hwifs created during IDE generic probe.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
WARNING WARNING WARNING

This is a drop-n-run patch, created ultimately because I was annoyed at
the [quite valid] pci_enable_device() build warning.

If someone likes this, please "take ownership" of the patch.

WARNING WARNING WARNING

 drivers/ide/pci/sc1200.c |   72 ++++++++++++++++++++++++++++++-----------------
 drivers/ide/setup-pci.c  |   12 +++++++
 include/linux/ide.h      |    2 +
 3 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index ee0e3f5..fa61550 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -41,6 +41,12 @@
 #define PCI_CLK_66	0x02
 #define PCI_CLK_33A	0x03
 
+#define SC1200_IFS	2
+
+struct sc1200_ifs {
+	ide_hwif_t	*iface[SC1200_IFS];
+};
+
 static unsigned short sc1200_get_pci_clock (void)
 {
 	unsigned char chip_id, silicon_revision;
@@ -274,22 +280,6 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 }
 
 #ifdef CONFIG_PM
-static ide_hwif_t *lookup_pci_dev (ide_hwif_t *prev, struct pci_dev *dev)
-{
-	int	h;
-
-	for (h = 0; h < MAX_HWIFS; h++) {
-		ide_hwif_t *hwif = &ide_hwifs[h];
-		if (prev) {
-			if (hwif == prev)
-				prev = NULL;	// found previous, now look for next match
-		} else {
-			if (hwif && hwif->pci_dev == dev)
-				return hwif;	// found next match
-		}
-	}
-	return NULL;	// not found
-}
 
 typedef struct sc1200_saved_state_s {
 	__u32		regs[4];
@@ -298,7 +288,9 @@ typedef struct sc1200_saved_state_s {
 
 static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 {
-	ide_hwif_t		*hwif = NULL;
+	struct sc1200_ifs	*ifs = pci_get_drvdata(dev);
+	ide_hwif_t		*hwif;
+	int			i;
 
 	printk("SC1200: suspend(%u)\n", state.event);
 
@@ -308,9 +300,14 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 		//
 		// Loop over all interfaces that are part of this PCI device:
 		//
-		while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
+		for (i = 0; i < SC1200_IFS; i++) {
 			sc1200_saved_state_t	*ss;
 			unsigned int		basereg, r;
+
+			hwif = ifs->iface[i];
+			if (!hwif)
+				continue;
+
 			//
 			// allocate a permanent save area, if not already allocated
 			//
@@ -337,23 +334,31 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
-	dev->current_state = state.event;
 	return 0;
 }
 
 static int sc1200_resume (struct pci_dev *dev)
 {
-	ide_hwif_t	*hwif = NULL;
+	struct sc1200_ifs	*ifs = pci_get_drvdata(dev);
+	ide_hwif_t		*hwif;
+	int			rc, i;
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
 
-	pci_set_power_state(dev, PCI_D0);	// bring chip back from sleep state
-	dev->current_state = PM_EVENT_ON;
-	pci_enable_device(dev);
 	//
 	// loop over all interfaces that are part of this pci device:
 	//
-	while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
+	for (i = 0; i < SC1200_IFS; i++) {
 		unsigned int		basereg, r;
-		sc1200_saved_state_t	*ss = (sc1200_saved_state_t *)hwif->config_data;
+		sc1200_saved_state_t	*ss;
+
+		hwif = ifs->iface[i];
+		if (!hwif)
+			continue;
+
+		ss = (sc1200_saved_state_t *)hwif->config_data;
 
 		//
 		// Restore timing registers:  this may be unnecessary if BIOS also does it
@@ -411,7 +416,22 @@ static ide_pci_device_t sc1200_chipset __devinitdata = {
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &sc1200_chipset);
+	struct sc1200_ifs *ifs;
+	int rc;
+
+	ifs = kzalloc(sizeof(*ifs), GFP_KERNEL);
+	if (!ifs)
+		return -ENOMEM;
+
+	rc = __ide_setup_pci_device(dev, &sc1200_chipset,
+				    &ifs->iface[0], &ifs->iface[1]);
+	if (rc) {
+		kfree(ifs);
+		return rc;
+	}
+	
+	pci_set_drvdata(dev, ifs);
+	return 0;
 }
 
 static struct pci_device_id sc1200_pci_tbl[] = {
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 1129f8c..fb6e29c 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -694,7 +694,8 @@ out:
 	return ret;
 }
 
-int ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d)
+int __ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d,
+			   ide_hwif_t **hwif_out, ide_hwif_t **mate_out)
 {
 	ide_hwif_t *hwif = NULL, *mate = NULL;
 	ata_index_t index_list;
@@ -719,9 +720,18 @@ int ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d)
 	if (mate)
 		ide_proc_register_port(mate);
 out:
+	if (hwif_out)
+		*hwif_out = hwif;
+	if (mate_out)
+		*mate_out = mate;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__ide_setup_pci_device);
 
+int ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d)
+{
+	return __ide_setup_pci_device(dev, d, NULL, NULL);
+}
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
 
 int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 02a27e8..19f6eac 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1283,6 +1283,8 @@ typedef struct ide_pci_device_s {
 } ide_pci_device_t;
 
 extern int ide_setup_pci_device(struct pci_dev *, ide_pci_device_t *);
+extern int __ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d,
+                           ide_hwif_t **hwif_out, ide_hwif_t **mate_out);
 extern int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, ide_pci_device_t *);
 
 void ide_map_sg(ide_drive_t *, struct request *);
