Return-Path: <linux-kernel-owner+w=401wt.eu-S1161110AbXD2UyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161110AbXD2UyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXD2UyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:54:07 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:49401 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161110AbXD2UyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:54:03 -0400
Message-id: <2881423131850617699@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 2/21] Char: cyclades, switch to pci probing
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:54:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, switch to pci probing

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit c5c2e708444ec573636733bb28ecd66d1753aa8f
tree 219a4d452e3e208c27031ed29506ee108feef833
parent 167ae9073fef562913c9d68d32da883da5444fbc
author Jiri Slaby <jirislaby@gmail.com> Tue, 24 Apr 2007 23:47:07 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:14:56 +0200

 drivers/char/cyclades.c |   65 ++++++++++++-----------------------------------
 1 files changed, 17 insertions(+), 48 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index d3b42e8..249f443 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5297,46 +5297,9 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 }
-#endif
 
-/*
- * ---------------------------------------------------------------------
- * cy_detect_pci() - Test PCI bus presence and Cyclom-Ye/PCI.
- * sets global variables and return the number of PCI boards found.
- * ---------------------------------------------------------------------
- */
-static int __init cy_detect_pci(void)
+static void __devexit cy_pci_remove(struct pci_dev *pdev)
 {
-#ifdef CONFIG_PCI
-	struct pci_dev *pdev = NULL;
-	unsigned int i, device_id, dev_index = 0;
-
-	for (i = 0; i < NR_CARDS; i++) {
-		/* look for a Cyclades card by vendor and device id */
-		while ((device_id = cy_pci_dev_id[dev_index].device) != 0) {
-			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
-						   device_id, pdev)) == NULL) {
-				dev_index++;	/* try next device id */
-			} else {
-				break;	/* found a board */
-			}
-		}
-
-		if (device_id == 0)
-			break;
-
-		i -= !!cy_pci_probe(pdev, &cy_pci_dev_id[dev_index]);
-	}
-
-	return i;
-#else
-	return 0;
-#endif				/* ifdef CONFIG_PCI */
-}				/* cy_detect_pci */
-
-static void __devexit cy_pci_release(struct pci_dev *pdev)
-{
-#ifdef CONFIG_PCI
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
 	unsigned int i;
 
@@ -5370,9 +5333,16 @@ static void __devexit cy_pci_release(struct pci_dev *pdev)
 	for (i = cinfo->first_line; i < cinfo->first_line +
 			cinfo->nports; i++)
 		tty_unregister_device(cy_serial_driver, i);
-#endif
 }
 
+static struct pci_driver cy_pci_driver = {
+	.name = "cyclades",
+	.id_table = cy_pci_dev_id,
+	.probe = cy_pci_probe,
+	.remove = __devexit_p(cy_pci_remove)
+};
+#endif
+
 /*
  * This routine prints out the appropriate serial driver version number
  * and identifies which options were configured into this driver.
@@ -5533,13 +5503,12 @@ static int __init cy_init(void)
 	/* look for isa boards */
 	nboards = cy_detect_isa();
 
+#ifdef CONFIG_PCI
 	/* look for pci boards */
-	nboards += cy_detect_pci();
-
-	if (nboards == 0) {
-		retval = -ENODEV;
+	retval = pci_register_driver(&cy_pci_driver);
+	if (retval && !nboards)
 		goto err_unr;
-	}
+#endif
 
 	return 0;
 err_unr:
@@ -5564,12 +5533,12 @@ static void __exit cy_cleanup_module(void)
 
 	put_tty_driver(cy_serial_driver);
 
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&cy_pci_driver);
+#endif
+
 	for (i = 0; i < NR_CARDS; i++) {
 		if (cy_card[i].base_addr) {
-			if (cy_card[i].pdev) {
-				cy_pci_release(cy_card[i].pdev);
-				continue;
-			}
 			/* clear interrupt */
 			cy_writeb(cy_card[i].base_addr + Cy_ClrIntr, 0);
 			iounmap(cy_card[i].base_addr);
