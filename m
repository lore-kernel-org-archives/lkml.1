Return-Path: <linux-kernel-owner+w=401wt.eu-S1422791AbXDRKIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422791AbXDRKIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422803AbXDRKIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:08:04 -0400
Received: from av7.karneval.cz ([81.27.192.15]:63194 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422791AbXDRKIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:08:01 -0400
Message-id: <4488267294095310@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 10/11] Char: cyclades, clear interrupts before releasing
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:07:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, clear interrupts before releasing

Without this patch, the driver sometimes causes "IRQXX: Nobody cares". Fix
it by turning off irqs when releasing.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 0156510dee9d326af2ec52cf8b1a388ce9a839e9
tree 29d863d5eca58913c306bc8cd9a6b3a5dcef01fe
parent ad4f792b92f8e6350a62b61442bb6812969bfd73
author Jiri Slaby <jirislaby@gmail.com> Thu, 05 Apr 2007 18:26:08 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:48:09 +0200

 drivers/char/cyclades.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 0c2c120..5a9e7d6 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5341,6 +5341,17 @@ static void __devexit cy_pci_release(struct pci_dev *pdev)
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
 	unsigned int i;
 
+	/* non-Z with old PLX */
+	if (cinfo->num_chips != -1 && (readb(cinfo->base_addr + CyPLX_VER) &
+				0x0f) == PLX_9050)
+		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
+	else
+#ifndef CONFIG_CYZ_INTR
+		if (cinfo->num_chips != -1)
+#endif
+		cy_writew(cinfo->ctl_addr + 0x68,
+				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
+
 	pci_iounmap(pdev, cinfo->base_addr);
 	if (cinfo->ctl_addr)
 		pci_iounmap(pdev, cinfo->ctl_addr);
@@ -5560,6 +5571,8 @@ static void __exit cy_cleanup_module(void)
 				cy_pci_release(cy_card[i].pdev);
 				continue;
 			}
+			/* clear interrupt */
+			cy_writeb(cy_card[i].base_addr + Cy_ClrIntr, 0);
 			iounmap(cy_card[i].base_addr);
 			if (cy_card[i].ctl_addr)
 				iounmap(cy_card[i].ctl_addr);
