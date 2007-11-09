Return-Path: <linux-kernel-owner+w=401wt.eu-S1763813AbXKIXpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763813AbXKIXpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbXKIXow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:44:52 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57206 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763724AbXKIXov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:44:51 -0500
Message-id: <97452711637819007.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 3/13] Char: nozomi, fix fail paths
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:44:51 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, fix fail paths

Free resources on fail path in probe function properly (free_irq,
remove_sysfs_files, kfifo_free, kfree(dc->send_buf) and atomic_dec). Also
use kfifo_free instead of kfree on release function, because it leaked
fifo->buffer.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 14e887763c076e45f4f768348361a37c10709902
tree 67854b6ec0a6460d857b37379a2f0772b7f5a9f8
parent 29335b619cc5ee27417d50982f029d440570f67c
author Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 23:08:52 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 23:08:52 +0100

 drivers/char/nozomi.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 2e2cbc5..e33f21e 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1549,7 +1549,7 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 				      const struct pci_device_id *ent)
 {
 	resource_size_t start;
-	int ret = -EIO;
+	int ret = -ENOMEM;
 	struct nozomi *dc = NULL;
 	struct nozomi_devices *newdev = NULL;
 	struct nozomi_devices *first = NULL;
@@ -1563,13 +1563,12 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	dc = kzalloc(sizeof(struct nozomi), GFP_KERNEL);
 	if (unlikely(!dc)) {
 		dev_err(&pdev->dev, "Could not allocate memory\n");
-		return -ENOMEM;
+		goto err_free;
 	}
 	newdev = kzalloc(sizeof(struct nozomi_devices), GFP_KERNEL);
 	if (unlikely(!newdev)) {
 		dev_err(&pdev->dev, "Could not allocate memory\n");
-		kfree(dc);
-		return -ENOMEM;
+		goto err_free;
 	}
 
 	dc->pdev = pdev;
@@ -1581,9 +1580,7 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	if (pci_enable_device(dc->pdev)) {
 		dev_err(&pdev->dev, "Failed to enable PCI Device\n");
-		kfree(dc);
-		kfree(newdev);
-		return -ENODEV;
+		goto err_free;
 	}
 
 	start = pci_resource_start(dc->pdev, 0);
@@ -1604,17 +1601,18 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	nozomi_setup_private_data(dc);
 
-	if (pci_request_regions(dc->pdev, NOZOMI_NAME)) {
+	ret = pci_request_regions(dc->pdev, NOZOMI_NAME);
+	if (ret) {
 		dev_err(&pdev->dev, "I/O address 0x%04x already in use\n",
 			(int) /* nozomi_private.io_addr */ 0);
-		ret = -EIO;
-		goto err_disable_regions;
+		goto err_unmap;
 	}
 
 	dc->send_buf = kmalloc(SEND_BUF_MAX, GFP_KERNEL);
 	if (!dc->send_buf) {
 		dev_err(&pdev->dev, "Could not allocate send buffer?\n");
-		goto err_disable_regions;
+		ret = -ENOMEM;
+		goto err_free_sbuf;
 	}
 
 	/* Disable all interrupts */
@@ -1625,7 +1623,7 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 			NOZOMI_NAME, newdev);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "can't request irq\n");
-		goto err_disable_regions;
+		goto err_free_sbuf;
 	}
 
 	DBG1("base_addr: %p", dc->base_addr);
@@ -1636,13 +1634,17 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	if (new_index < 0) {
 		dev_err(&pdev->dev, "already reached maximum card count.\n");
 		ret = -EIO;
-		goto err_disable_regions;
+		goto err_free_irq;
 	}
 
 	make_sysfs_files(dc);
 
 	if (atomic_read(&cards_found) == 1) {
-		ntty_tty_init(dc);
+		ret = ntty_tty_init(dc);
+		if (ret) {
+			dev_err(&pdev->dev, "can't alloc ntty\n");
+			goto err_sysfs;
+		}
 	} else {
 		first = list_first_entry(&my_devices, struct nozomi_devices,
 									list);
@@ -1669,15 +1671,25 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	return 0;
 
-err_disable_regions:
+err_sysfs:
+	remove_sysfs_files(dc);
+err_free_irq:
+	free_irq(pdev->irq, newdev);
+	for (i = PORT_MDM; i < MAX_PORT; i++)	/* allocated in isr, might be */
+		if (dc->port[i].fifo_ul)	/* filled yet */
+			kfifo_free(dc->port[i].fifo_ul);
+err_free_sbuf:
+	kfree(dc->send_buf);
 	pci_release_regions(pdev);
+err_unmap:
 	iounmap(dc->base_addr);
 	dc->base_addr = NULL;
-
 err_disable_device:
 	pci_disable_device(pdev);
+err_free:
 	kfree(dc);
 	kfree(newdev);
+	atomic_dec(&cards_found);
 	return ret;
 }
 
@@ -1751,7 +1763,8 @@ static void __devexit nozomi_card_exit(struct pci_dev *pdev)
 	free_irq(pdev->irq, deventry);
 
 	for (i = PORT_MDM; i < MAX_PORT; i++)
-		kfree(dc->port[i].fifo_ul);
+		if (dc->port[i].fifo_ul)
+			kfifo_free(dc->port[i].fifo_ul);
 
 	kfree(dc->send_buf);
 
