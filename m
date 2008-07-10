Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYGJOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYGJOXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYGJOXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:23:10 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:59878 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYGJOXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:23:09 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: isicom, enable/disable pci device
Date: Thu, 10 Jul 2008 16:20:12 +0200
Message-Id: <1215699612-17909-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to enable and disable PCI devices. The device
might be unusable without that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/isicom.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 4f3cefa..a1a67e3 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1736,6 +1736,12 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
 	if (card_count >= BOARD_COUNT)
 		goto err;
 
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "failed to enable\n");
+		goto err;
+	}
+
 	dev_info(&pdev->dev, "ISI PCI Card(Device ID 0x%x)\n", ent->device);
 
 	/* allot the first empty slot in the array */
@@ -1790,6 +1796,7 @@ errunrr:
 errdec:
 	board->base = 0;
 	card_count--;
+	pci_disable_device(pdev);
 err:
 	return retval;
 }
@@ -1806,6 +1813,7 @@ static void __devexit isicom_remove(struct pci_dev *pdev)
 	pci_release_region(pdev, 3);
 	board->base = 0;
 	card_count--;
+	pci_disable_device(pdev);
 }
 
 static int __init isicom_init(void)
-- 
1.5.6.1

