Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbXJXXtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbXJXXtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXJXXs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:48:26 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36068 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbXJXXsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:48:25 -0400
To: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/3] drivers/ide/pci/sc1200.c: remove pointless hwif lookup loop
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>
Message-Id: <20071024234823.6D1461F819D@havoc.gtf.org>
Date: Wed, 24 Oct 2007 19:48:23 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Store our hwif indices at probe time, in order to eliminate a needless
and ugly loop across all hwifs, searching for our pci device.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ide/pci/sc1200.c |   76 +++++++++++++++++++++++++++++++---------------
 1 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index d2c8b55..17e58d6 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -41,6 +41,8 @@
 #define PCI_CLK_66	0x02
 #define PCI_CLK_33A	0x03
 
+#define SC1200_IFS	4
+
 static unsigned short sc1200_get_pci_clock (void)
 {
 	unsigned char chip_id, silicon_revision;
@@ -261,31 +263,32 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
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
-
 typedef struct sc1200_saved_state_s {
 	__u32		regs[4];
 } sc1200_saved_state_t;
 
+static unsigned int pack_hwif_idx(u8 *idx)
+{
+	return	(((unsigned int) idx[0]) << 0) |
+		(((unsigned int) idx[1]) << 8) |
+		(((unsigned int) idx[2]) << 16) |
+		(((unsigned int) idx[3]) << 24);
+}
+
+static ide_hwif_t *sc1200_hwif(struct pci_dev *pdev, unsigned int iface)
+{
+	unsigned int packed_hwifs, idx;
+
+	packed_hwifs = (unsigned long) pci_get_drvdata(pdev);
+	idx = (packed_hwifs >> (iface * 8)) & 0xff;
+
+	return (idx == 0xff) ? NULL : &ide_hwifs[idx];
+}
 
 static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 {
-	ide_hwif_t		*hwif = NULL;
+	ide_hwif_t		*hwif;
+	int			i;
 
 	printk("SC1200: suspend(%u)\n", state.event);
 
@@ -295,9 +298,14 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 		//
 		// Loop over all interfaces that are part of this PCI device:
 		//
-		while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
+		for (i = 0; i < SC1200_IFS; i++) {
 			sc1200_saved_state_t	*ss;
 			unsigned int		basereg, r;
+
+			hwif = sc1200_hwif(dev, i);
+			if (!hwif)
+				continue;
+
 			//
 			// allocate a permanent save area, if not already allocated
 			//
@@ -310,7 +318,7 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 			}
 			ss = (sc1200_saved_state_t *)hwif->config_data;
 			//
-			// Save timing registers:  this may be unnecessary if 
+			// Save timing registers:  this may be unnecessary if
 			// BIOS also does it
 			//
 			basereg = hwif->channel ? 0x50 : 0x40;
@@ -320,7 +328,7 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 		}
 	}
 
-	/* You don't need to iterate over disks -- sysfs should have done that for you already */ 
+	/* You don't need to iterate over disks -- sysfs should have done that for you already */
 
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
@@ -330,7 +338,8 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 
 static int sc1200_resume (struct pci_dev *dev)
 {
-	ide_hwif_t	*hwif = NULL;
+	ide_hwif_t		*hwif;
+	int			i;
 
 	pci_set_power_state(dev, PCI_D0);	// bring chip back from sleep state
 	dev->current_state = PM_EVENT_ON;
@@ -338,9 +347,15 @@ static int sc1200_resume (struct pci_dev *dev)
 	//
 	// loop over all interfaces that are part of this pci device:
 	//
-	while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
+	for (i = 0; i < SC1200_IFS; i++) {
 		unsigned int		basereg, r;
-		sc1200_saved_state_t	*ss = (sc1200_saved_state_t *)hwif->config_data;
+		sc1200_saved_state_t	*ss;
+
+		hwif = sc1200_hwif(dev, i);
+		if (!hwif)
+			continue;
+
+		ss = (sc1200_saved_state_t *)hwif->config_data;
 
 		//
 		// Restore timing registers:  this may be unnecessary if BIOS also does it
@@ -386,7 +401,18 @@ static const struct ide_port_info sc1200_chipset __devinitdata = {
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &sc1200_chipset);
+	unsigned int packed_hwifs;
+	int rc;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
+	rc = __ide_setup_pci_device(dev, &sc1200_chipset, &idx[0]);
+	if (rc)
+		return rc;
+	
+	packed_hwifs = pack_hwif_idx(&idx[0]);
+
+	pci_set_drvdata(dev, (void *)(unsigned long) packed_hwifs);
+	return 0;
 }
 
 static const struct pci_device_id sc1200_pci_tbl[] = {
-- 
1.5.2.4

