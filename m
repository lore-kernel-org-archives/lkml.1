Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYBVOsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYBVOsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYBVOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:30 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42257 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYBVOr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:28 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 03/19] Char: moxa, pci io space fixup
Date: Fri, 22 Feb 2008 15:46:30 +0100
Message-Id: <1203691606-9310-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- request region before remapping pci io space
- use ioremap, iounmap istead of iomap interface, because we use
  readX/writeX for accessing this space because of isa support

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 2701f7c..f841b1f 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -290,10 +290,17 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 	}
 
 	board = &moxa_boards[i];
-	board->basemem = pci_iomap(pdev, 2, 0x4000);
+
+	retval = pci_request_region(pdev, 2, "moxa-base");
+	if (retval) {
+		dev_err(&pdev->dev, "can't request pci region 2\n");
+		goto err;
+	}
+
+	board->basemem = ioremap(pci_resource_start(pdev, 2), 0x4000);
 	if (board->basemem == NULL) {
 		dev_err(&pdev->dev, "can't remap io space 2\n");
-		goto err;
+		goto err_reg;
 	}
 
 	board->boardType = board_type;
@@ -315,6 +322,8 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, board);
 
 	return (0);
+err_reg:
+	pci_release_region(pdev, 2);
 err:
 	return retval;
 }
@@ -323,8 +332,9 @@ static void __devexit moxa_pci_remove(struct pci_dev *pdev)
 {
 	struct moxa_board_conf *brd = pci_get_drvdata(pdev);
 
-	pci_iounmap(pdev, brd->basemem);
+	iounmap(brd->basemem);
 	brd->basemem = NULL;
+	pci_release_region(pdev, 2);
 }
 
 static struct pci_driver moxa_pci_driver = {
-- 
1.5.4.1

