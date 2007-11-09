Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXKIXrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXKIXrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764407AbXKIXqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:46:54 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57225 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764290AbXKIXqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:46:53 -0500
Message-id: <29761185991768728185.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 6/13] Char: nozomi, reorder and cleanup probe, remove
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:46:53 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, reorder and cleanup probe, remove

- remap space after requesting region, to not map something we cannot use
  anyway
- init spin lock before request_irq, because due to shared irq debug, isr
  might be called immediately, where the lock is being held
- remove INIT_LIST_HEAD before list_add, it's useless, because list_add
  re-sets prev and next
- reorder cleanup to be the same as fail path of probe (or in other words,
  the reverse of probe)
- no need to call nozomi_setup_private_data in remove, pointers are set in
  probe

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 662a9d19654d8d79fbaeab13d7afe7fe021e6b42
tree 3c73690a8715ce52b8125413b94ea24b8f0013d3
parent 2470e477561f2577137d557aa4dcf92b0229a745
author Jiri Slaby <jirislaby@gmail.com> Fri, 02 Nov 2007 09:29:38 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 23:20:25 +0100

 drivers/char/nozomi.c |   52 ++++++++++++++++++++-----------------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 3f4ae3d..eaa65fc 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1579,7 +1579,6 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	dc->pdev = pdev;
 	newdev->my_dev = dc;
-	pci_set_drvdata(pdev, newdev);
 
 	/* Find out what card type it is */
 	nozomi_get_card_type(dc);
@@ -1596,22 +1595,18 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 		goto err_disable_device;
 	}
 
-	dc->base_addr = ioremap(start, dc->card_type);
-	if (!dc->base_addr) {
-		dev_err(&pdev->dev, "Unable to map card MMIO\n");
-		ret = -ENODEV;
-		goto err_disable_device;
-	}
-
-	dc->open_ttys = 0;
-
-	nozomi_setup_private_data(dc);
-
 	ret = pci_request_regions(dc->pdev, NOZOMI_NAME);
 	if (ret) {
 		dev_err(&pdev->dev, "I/O address 0x%04x already in use\n",
 			(int) /* nozomi_private.io_addr */ 0);
-		goto err_unmap;
+		goto err_disable_device;
+	}
+
+	dc->base_addr = ioremap(start, dc->card_type);
+	if (!dc->base_addr) {
+		dev_err(&pdev->dev, "Unable to map card MMIO\n");
+		ret = -ENODEV;
+		goto err_rel_regs;
 	}
 
 	dc->send_buf = kmalloc(SEND_BUF_MAX, GFP_KERNEL);
@@ -1621,6 +1616,10 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 		goto err_free_sbuf;
 	}
 
+	spin_lock_init(&dc->spin_mutex);
+
+	nozomi_setup_private_data(dc);
+
 	/* Disable all interrupts */
 	dc->last_ier = 0;
 	writew(dc->last_ier, dc->reg_ier);
@@ -1634,8 +1633,6 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	DBG1("base_addr: %p", dc->base_addr);
 
-	spin_lock_init(&dc->spin_mutex);
-
 	new_index = get_free_index();
 	if (new_index < 0) {
 		dev_err(&pdev->dev, "already reached maximum card count.\n");
@@ -1670,7 +1667,6 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	dc->last_ier = RESET;
 	writew(dc->last_ier, dc->reg_ier);
 
-	INIT_LIST_HEAD(&newdev->list);
 	list_add_tail(&newdev->list, &my_devices);
 
 	pci_set_drvdata(pdev, newdev);
@@ -1686,10 +1682,9 @@ err_free_irq:
 			kfifo_free(dc->port[i].fifo_ul);
 err_free_sbuf:
 	kfree(dc->send_buf);
-	pci_release_regions(pdev);
-err_unmap:
 	iounmap(dc->base_addr);
-	dc->base_addr = NULL;
+err_rel_regs:
+	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
 err_free:
@@ -1753,18 +1748,12 @@ static void __devexit nozomi_card_exit(struct pci_dev *pdev)
 	DBG1("sending flow control 0x%04X", *((u16 *)&ctrl));
 
 	/* Setup dc->reg addresses to we can use defines here */
-	nozomi_setup_private_data(dc);
 	write_mem32(dc->port[PORT_CTRL].ul_addr[0], (u32 *)&ctrl, 2);
 	writew(CTRL_UL, dc->reg_fcr);	/* push the token to the card. */
 
-	DBG1("pci_release_regions");
-	pci_release_regions(pdev);
-
-	if (dc->base_addr)
-		iounmap(dc->base_addr);
+	list_del(&deventry->list);
 
-	DBG1("pci_disable_device");
-	pci_disable_device(pdev);
+	remove_sysfs_files(dc);
 
 	free_irq(pdev->irq, deventry);
 
@@ -1774,12 +1763,13 @@ static void __devexit nozomi_card_exit(struct pci_dev *pdev)
 
 	kfree(dc->send_buf);
 
-	remove_sysfs_files(dc);
+	iounmap(dc->base_addr);
 
-	kfree(dc);
-	deventry->my_dev = 0;
+	pci_release_regions(pdev);
 
-	list_del(&deventry->list);
+	pci_disable_device(pdev);
+
+	kfree(dc);
 	kfree(deventry);
 
 	atomic_dec(&cards_found);
