Return-Path: <linux-kernel-owner+w=401wt.eu-S1030238AbXBTQlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbXBTQlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030248AbXBTQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:41:08 -0500
Received: from [81.2.110.250] ([81.2.110.250]:35962 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030238AbXBTQlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:41:07 -0500
Date: Tue, 20 Feb 2007 17:44:25 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_cs5520: suspend/resume
Message-ID: <20070220174425.43b8975d@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The CS5520 isn't just an ATA controller and we must not
pci_disable_device it as it turns into pci_disable_computer.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_cs5520.c linux-2.6.20-mm2/drivers/ata/pata_cs5520.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_cs5520.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_cs5520.c	2007-02-20 13:52:42.000000000 +0000
@@ -325,6 +325,30 @@
 		pci_write_config_byte(pdev, 0x60, pcicfg | 0x40);
 	return ata_pci_device_resume(pdev);
 }
+
+/**
+ *	cs5520_pci_device_suspend	-	device suspend
+ *	@pdev: PCI device
+ *
+ *	We have to cut and waste bits from the standard method because
+ *	the 5520 is a bit odd and not just a pure ATA device. As a result
+ *	we must not disable it. The needed code is short and this avoids
+ *	chip specific mess in the core code.
+ */
+
+static int cs5520_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc = 0;
+
+	rc = ata_host_suspend(host, mesg);
+	if (rc)
+		return rc;
+
+	pci_save_state(pdev);
+	return 0;
+}
+ 
 /* For now keep DMA off. We can set it for all but A rev CS5510 once the
    core ATA code can handle it */
 
@@ -340,7 +364,7 @@
 	.id_table	= pata_cs5520,
 	.probe 		= cs5520_init_one,
 	.remove		= cs5520_remove_one,
-	.suspend	= ata_pci_device_suspend,
+	.suspend	= cs5520_pci_device_suspend,
 	.resume		= cs5520_reinit_one,
 };
 
