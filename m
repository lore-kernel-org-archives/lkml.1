Return-Path: <linux-kernel-owner+w=401wt.eu-S1031438AbXD2Ux0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031438AbXD2Ux0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031428AbXD2Ux0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:53:26 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:60000 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031438AbXD2UxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:53:25 -0400
Message-id: <1726067771982725064@wsc.cz>
Subject: [PATCH 1/21] Char: cyclades, use IS_CYC_Z macro
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:53:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, use IS_CYC_Z macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 167ae9073fef562913c9d68d32da883da5444fbc
tree 5d5795a789e6ce98a5a1226cf88e2b98b1d9a12a
parent b462f2fd89bff92e55be6a5317a3be0ad6a93ad8
author Jiri Slaby <jirislaby@gmail.com> Tue, 24 Apr 2007 21:40:00 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:14:54 +0200

 drivers/char/cyclades.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 9d22d58..d3b42e8 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -3616,11 +3616,6 @@ static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 			((status & CyCTS) ? TIOCM_CTS : 0);
 	} else {
 		base_addr = cy_card[card].base_addr;
-
-		if (cy_card[card].num_chips != -1) {
-			return -EINVAL;
-		}
-
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		if (ISZLOADED(cy_card[card])) {
 			zfw_ctrl = cy_card[card].base_addr +
@@ -4513,7 +4508,7 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo,
 	unsigned short chip_number;
 	int index, port;
 
-	if (cinfo->num_chips == -1) {	/* Cyclades-Z */
+	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
 		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
 				     cinfo->ctl_addr)->mail_box_0);
 		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
@@ -5346,12 +5341,12 @@ static void __devexit cy_pci_release(struct pci_dev *pdev)
 	unsigned int i;
 
 	/* non-Z with old PLX */
-	if (cinfo->num_chips != -1 && (readb(cinfo->base_addr + CyPLX_VER) &
-				0x0f) == PLX_9050)
+	if (!IS_CYC_Z(*cinfo) && (readb(cinfo->base_addr + CyPLX_VER) & 0x0f) ==
+			PLX_9050)
 		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
 	else
 #ifndef CONFIG_CYZ_INTR
-		if (cinfo->num_chips != -1)
+		if (!IS_CYC_Z(*cinfo))
 #endif
 		cy_writew(cinfo->ctl_addr + 0x68,
 				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
@@ -5361,7 +5356,7 @@ static void __devexit cy_pci_release(struct pci_dev *pdev)
 		pci_iounmap(pdev, cinfo->ctl_addr);
 	if (cinfo->irq
 #ifndef CONFIG_CYZ_INTR
-		&& cinfo->num_chips != -1 /* not a Z card */
+		&& !IS_CYC_Z(*cinfo)
 #endif /* CONFIG_CYZ_INTR */
 		)
 		free_irq(cinfo->irq, cinfo);
@@ -5582,7 +5577,7 @@ static void __exit cy_cleanup_module(void)
 				iounmap(cy_card[i].ctl_addr);
 			if (cy_card[i].irq
 #ifndef CONFIG_CYZ_INTR
-				&& cy_card[i].num_chips != -1 /* not a Z card */
+				&& !IS_CYC_Z(cy_card[i])
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(cy_card[i].irq, &cy_card[i]);
