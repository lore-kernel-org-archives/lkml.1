Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYHNQb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYHNQb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbYHNQbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:31:43 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39856 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbYHNQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:31:43 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, R.E.Wolff@BitWizard.nl
Subject: [PATCH 3/3] Char: sx, remove bogus iomap
Date: Thu, 14 Aug 2008 18:25:54 +0200
Message-Id: <1218731154-32692-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1218731154-32692-2-git-send-email-jirislaby@gmail.com>
References: <1218731154-32692-1-git-send-email-jirislaby@gmail.com>
 <1218731154-32692-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readl/writel are not expected to accept iomap return value. Replace
bogus mapping by standard ioremap.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: R.E.Wolff@BitWizard.nl
---
 drivers/char/sx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 5b8d7a1..ba4e862 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2504,7 +2504,7 @@ static void __devexit sx_remove_card(struct sx_board *board,
 		del_timer(&board->timer);
 		if (pdev) {
 #ifdef CONFIG_PCI
-			pci_iounmap(pdev, board->base2);
+			iounmap(board->base2);
 			pci_release_region(pdev, IS_CF_BOARD(board) ? 3 : 2);
 #endif
 		} else {
@@ -2677,7 +2677,7 @@ static int __devinit sx_pci_probe(struct pci_dev *pdev,
 	}
 	board->hw_base = pci_resource_start(pdev, reg);
 	board->base2 =
-	board->base = pci_iomap(pdev, reg, WINDOW_LEN(board));
+	board->base = ioremap_nocache(board->hw_base, WINDOW_LEN(board));
 	if (!board->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		goto err_reg;
@@ -2703,7 +2703,7 @@ static int __devinit sx_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 err_unmap:
-	pci_iounmap(pdev, board->base2);
+	iounmap(board->base2);
 err_reg:
 	pci_release_region(pdev, reg);
 err_flag:
-- 
1.5.6.5

