Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYATSeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYATSeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYATSd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:33:56 -0500
Received: from vsmtp2.tin.it ([212.216.176.222]:58863 "EHLO vsmtp2.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbYATSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:33:56 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 13:33:55 EST
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/tlan.c: compilation warning fix
Date: Sun, 20 Jan 2008 19:28:29 +0100
User-Agent: KMail/1.9.7
Cc: chessman@tux.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801201928.29446.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Added a check for the pci_register_driver() return value.
Removed unused variable pad_allocated.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---

The aim of this patch is to remove the following warning messages:
drivers/net/tlan.c: In function 'tlan_probe':
drivers/net/tlan.c:486: warning: ignoring return value of 'pci_register_driver', declared with attribute warn_unused_result

--- linux-2.6.orig/drivers/net/tlan.c
+++ linux-2.6/drivers/net/tlan.c
@@ -465,7 +465,7 @@ static struct pci_driver tlan_driver = {
 
 static int __init tlan_probe(void)
 {
-	static int	pad_allocated;
+	int rc = -ENODEV;
 
 	printk(KERN_INFO "%s", tlan_banner);
 
@@ -473,17 +473,22 @@ static int __init tlan_probe(void)
 
 	if (TLanPadBuffer == NULL) {
 		printk(KERN_ERR "TLAN: Could not allocate memory for pad buffer.\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto err_out;
 	}
 
 	memset(TLanPadBuffer, 0, TLAN_MIN_FRAME_SIZE);
-	pad_allocated = 1;
 
 	TLAN_DBG(TLAN_DEBUG_PROBE, "Starting PCI Probe....\n");
 
 	/* Use new style PCI probing. Now the kernel will
 	   do most of this for us */
-	pci_register_driver(&tlan_driver);
+	rc = pci_register_driver(&tlan_driver);
+
+	if (rc != 0) {
+		printk(KERN_ERR "TLAN: Could not register pci driver.\n");
+		goto err_out_pci_free;
+	}
 
 	TLAN_DBG(TLAN_DEBUG_PROBE, "Starting EISA Probe....\n");
 	TLan_EisaProbe();
@@ -493,11 +498,17 @@ static int __init tlan_probe(void)
 		 tlan_have_pci, tlan_have_eisa);
 
 	if (TLanDevicesInstalled == 0) {
-		pci_unregister_driver(&tlan_driver);
-		pci_free_consistent(NULL, TLAN_MIN_FRAME_SIZE, TLanPadBuffer, TLanPadBufferDMA);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto  err_out_pci_unreg;
 	}
 	return 0;
+
+err_out_pci_unreg:
+	pci_unregister_driver(&tlan_driver);
+err_out_pci_free:
+	pci_free_consistent(NULL, TLAN_MIN_FRAME_SIZE, TLanPadBuffer, TLanPadBufferDMA);
+err_out:
+	return rc;
 }
 
 
