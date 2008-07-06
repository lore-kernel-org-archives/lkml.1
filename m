Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbYGFRuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbYGFRuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbYGFRfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:03 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:50837 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbYGFRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=ACn9DvbXaJuvUMH6xYUfAe1ZCt/1e2SUmozuOPx0X+jNm/LwIh3GtdZEytWhsl0GcY
         8xyMJGPTHnvHsqWeTx3HNH6mLxq7HQqyxw8hDaKMGdKeeXbg9opWjRv4gRS6MqWPLA7K
         cXrA8kjuT6LtKy4VIcPssExdQuUg/sp063mI0=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:21 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/50] sc1200: convert to use ->host_priv
Content-Disposition: inline; filename=sc1200-convert-to-use-host_priv.patch
Message-ID: <4871023a.1ade660a.3458.627f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sc1200.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -234,21 +234,11 @@ static int sc1200_suspend (struct pci_de
 	 * we only save state when going from full power to less
 	 */
 	if (state.event == PM_EVENT_ON) {
-		struct sc1200_saved_state *ss;
+		struct ide_host *host = pci_get_drvdata(dev);
+		struct sc1200_saved_state *ss = host->host_priv;
 		unsigned int r;
 
 		/*
-		 * allocate a permanent save area, if not already allocated
-		 */
-		ss = (struct sc1200_saved_state *)pci_get_drvdata(dev);
-		if (ss == NULL) {
-			ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-			if (ss == NULL)
-				return -ENOMEM;
-			pci_set_drvdata(dev, ss);
-		}
-
-		/*
 		 * save timing registers
 		 * (this may be unnecessary if BIOS also does it)
 		 */
@@ -263,7 +253,8 @@ static int sc1200_suspend (struct pci_de
 
 static int sc1200_resume (struct pci_dev *dev)
 {
-	struct sc1200_saved_state *ss;
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct sc1200_saved_state *ss = host->host_priv;
 	unsigned int r;
 	int i;
 
@@ -271,16 +262,12 @@ static int sc1200_resume (struct pci_dev
 	if (i)
 		return i;
 
-	ss = (struct sc1200_saved_state *)pci_get_drvdata(dev);
-
 	/*
 	 * restore timing registers
 	 * (this may be unnecessary if BIOS also does it)
 	 */
-	if (ss) {
-		for (r = 0; r < 8; r++)
-			pci_write_config_dword(dev, 0x40 + r * 4, ss->regs[r]);
-	}
+	for (r = 0; r < 8; r++)
+		pci_write_config_dword(dev, 0x40 + r * 4, ss->regs[r]);
 
 	return 0;
 }
@@ -317,7 +304,19 @@ static const struct ide_port_info sc1200
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_pci_init_one(dev, &sc1200_chipset, NULL);
+	struct sc1200_saved_state *ss = NULL;
+	int rc;
+
+#ifdef CONFIG_PM
+	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
+	if (ss == NULL)
+		return -ENOMEM;
+#endif
+	rc = ide_pci_init_one(dev, &sc1200_chipset, ss);
+	if (rc)
+		kfree(ss);
+
+	return rc;
 }
 
 static const struct pci_device_id sc1200_pci_tbl[] = {

-- 

