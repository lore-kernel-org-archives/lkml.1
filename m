Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbYGFRw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbYGFRw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbYGFRge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:49197 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283AbYGFRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=xYxdFrnq8MM4HyXlytyqXGZsnHINjKVwSkLE/QC5tJ/cT0nATJnL7QdnzHlkImzN2/
         +6868Onhg/IVfjqtK4GNsiefNzCMfTaPJPzr94VSjb9g90C15eDGO6XGB2B0k/fVHffk
         T5ViTMtWo9xyIlNAdWuoFVL2nmI8JlP6bPT54=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:28 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/50] ide: add ide_pci_remove() helper
Content-Disposition: inline; filename=ide-add-ide_pci_remove-helper.patch
Message-ID: <48710242.1ade660a.3458.6293@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'unsigned long host_flags' field to struct ide_host.

* Set ->host_flags in ide_host_alloc_all().

* Always set PCI dev's ->driver_data in ide_pci_init_{one,two}().

* Add ide_pci_remove() helper (the default implementation for
  struct pci_driver's ->remove method).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    3 +++
 drivers/ide/setup-pci.c |   39 +++++++++++++++++++++++++++++++++------
 include/linux/ide.h     |    2 ++
 3 files changed, 38 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1613,6 +1613,9 @@ struct ide_host *ide_host_alloc_all(cons
 	if (hws[0])
 		host->dev[0] = hws[0]->dev;
 
+	if (d)
+		host->host_flags = d->host_flags;
+
 	return host;
 }
 EXPORT_SYMBOL_GPL(ide_host_alloc_all);
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -547,8 +547,7 @@ int ide_pci_init_one(struct pci_dev *dev
 
 	host->host_priv = priv;
 
-	if (priv)
-		pci_set_drvdata(dev, host);
+	pci_set_drvdata(dev, host);
 
 	ret = do_ide_setup_pci_device(dev, d, 1);
 	if (ret < 0)
@@ -592,10 +591,8 @@ int ide_pci_init_two(struct pci_dev *dev
 
 	host->host_priv = priv;
 
-	if (priv) {
-		pci_set_drvdata(pdev[0], host);
-		pci_set_drvdata(pdev[1], host);
-	}
+	pci_set_drvdata(pdev[0], host);
+	pci_set_drvdata(pdev[1], host);
 
 	for (i = 0; i < 2; i++) {
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
@@ -618,3 +615,33 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ide_pci_init_two);
+
+void ide_pci_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;
+	int bars;
+
+	if (host->host_flags & IDE_HFLAG_SINGLE)
+		bars = (1 << 2) - 1;
+	else
+		bars = (1 << 4) - 1;
+
+	if ((host->host_flags & IDE_HFLAG_NO_DMA) == 0) {
+		if (host->host_flags & IDE_HFLAG_CS5520)
+			bars |= (1 << 2);
+		else
+			bars |= (1 << 4);
+	}
+
+	ide_host_remove(host);
+
+	if (dev2)
+		pci_release_selected_regions(dev2, bars);
+	pci_release_selected_regions(dev, bars);
+
+	if (dev2)
+		pci_disable_device(dev2);
+	pci_disable_device(dev);
+}
+EXPORT_SYMBOL_GPL(ide_pci_remove);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -616,6 +616,7 @@ struct ide_host {
 	ide_hwif_t	*ports[MAX_HWIFS];
 	unsigned int	n_ports;
 	struct device	*dev[2];
+	unsigned long	host_flags;
 	void		*host_priv;
 };
 
@@ -1198,6 +1199,7 @@ struct ide_port_info {
 int ide_pci_init_one(struct pci_dev *, const struct ide_port_info *, void *);
 int ide_pci_init_two(struct pci_dev *, struct pci_dev *,
 		     const struct ide_port_info *, void *);
+void ide_pci_remove(struct pci_dev *);
 
 void ide_map_sg(ide_drive_t *, struct request *);
 void ide_init_sg_cmd(ide_drive_t *, struct request *);

-- 

