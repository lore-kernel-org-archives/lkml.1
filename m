Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZITVGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZITVGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZITVGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:06:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:43216 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZITVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=bgSE7HXT+yaA+XbblULWHkuFgCq9/dj6GD5GnG6KeeAMibQRPKCTElk/hiag0KeG3O
         f2wpYwqIB2w7rCCk5aGsAhE7H4t2RWH3ow9Ebc+Xo3vDVLrxiacTIWOPsgpmJmxTR4T8
         mGprCxw7FPsOhsionfPElYwRK7Ljl/Ok6CKV8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: John Lee (Jung-Ik) <jilee@google.com>
Subject: [PATCH] pata_atp867x: add Power Management support
Date: Sun, 20 Sep 2009 23:05:10 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-04082-g1824090-dirty; KDE/4.3.1; i686; ; )
Cc: Grant Grundler <grundler@google.com>, Gwendal Gringo <gwendal@google.com>,
       Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200909202305.10118.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atp867x: add Power Management support

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
needs testing with the real hardware

 drivers/ata/pata_atp867x.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: b/drivers/ata/pata_atp867x.c
===================================================================
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -507,6 +507,23 @@ err_out:
 	return rc;
 }
 
+#ifdef CONFIG_PM
+static int atp867x_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	atp867x_fixup(host);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static struct pci_device_id atp867x_pci_tbl[] = {
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP867A),	0 },
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP867B),	0 },
@@ -518,6 +535,10 @@ static struct pci_driver atp867x_driver 
 	.id_table 	= atp867x_pci_tbl,
 	.probe 		= atp867x_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= atp867x_reinit_one,
+#endif
 };
 
 static int __init atp867x_init(void)
