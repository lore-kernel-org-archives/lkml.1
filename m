Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbXJXXsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbXJXXsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXJXXsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:48:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36268 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbXJXXsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:48:21 -0400
To: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/3] [IDE] Add helper __ide_setup_pci_device()
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>
Message-Id: <20071024234820.D91351F81A1@havoc.gtf.org>
Date: Wed, 24 Oct 2007 19:48:20 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Like ide_setup_pci_device(), except with additional array argument
'u8 *idx' that permits low-level driver to become aware of its assigned
hwifs.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ide/setup-pci.c |   17 ++++++++++++-----
 include/linux/ide.h     |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 02d14bf..4960b9f 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -666,12 +666,10 @@ out:
 	return ret;
 }
 
-int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+int __ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d,
+			   u8 *idx)
 {
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	int ret;
-
-	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
+	int ret = do_ide_setup_pci_device(dev, d, idx, 1);
 
 	if (ret >= 0)
 		ide_device_add(idx);
@@ -679,6 +677,15 @@ int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 	return ret;
 }
 
+EXPORT_SYMBOL_GPL(__ide_setup_pci_device);
+
+int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+{
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
+	return __ide_setup_pci_device(dev, d, &idx[0]);
+}
+
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
 
 int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 4ed4777..3404fb9 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1244,6 +1244,7 @@ struct ide_port_info {
 	u8			udma_mask;
 };
 
+int __ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *, u8 *);
 int ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *);
 int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, const struct ide_port_info *);
 
-- 
1.5.2.4

