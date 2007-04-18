Return-Path: <linux-kernel-owner+w=401wt.eu-S1422780AbXDRKF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780AbXDRKF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXDRKF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:05:59 -0400
Received: from av7.karneval.cz ([81.27.192.15]:57157 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422780AbXDRKF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:05:57 -0400
Message-id: <3175731021950218485@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 6/11] Char: cyclades, init card struct immediately
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:05:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, init card struct immediately

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 39e37f9c0e50657a546e20c2e37f58e0f260cdf6
tree f67e112b80d616e9d2fc57f35b6e39a45bea81a7
parent de8850dd6c04762688b19609b13cb16a1e6399a9
author Jiri Slaby <jirislaby@gmail.com> Mon, 02 Apr 2007 12:47:57 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:48:03 +0200

 drivers/char/cyclades.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index fe967be..2abe6f2 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4834,6 +4834,7 @@ static int __init cy_detect_isa(void)
 		cy_card[j].bus_index = 0;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_isa_nchan / 4;
+		cy_init_card(&cy_card[j], j);
 		nboard++;
 
 		/* print message */
@@ -4931,6 +4932,7 @@ static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
 	cy_card[j].pdev = pdev;
+	cy_init_card(&cy_card[j], j);
 	pci_set_drvdata(pdev, &cy_card[j]);
 
 	/* print message */
@@ -5080,6 +5082,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
 		cy_card[j].pdev = pdev;
+		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
 		/* enable interrupts in the PCI interface */
@@ -5263,6 +5266,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
 		cy_card[j].pdev = pdev;
+		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
 		/* print message */
@@ -5327,6 +5331,7 @@ static void __devexit cy_pci_release(struct pci_dev *pdev)
 {
 #ifdef CONFIG_PCI
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
+	unsigned int i;
 
 	pci_iounmap(pdev, cinfo->base_addr);
 	if (cinfo->ctl_addr)
@@ -5340,6 +5345,10 @@ static void __devexit cy_pci_release(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 
 	cinfo->base_addr = NULL;
+	for (i = cinfo->first_line; i < cinfo->first_line + cinfo->nports; i++){
+		cy_port[i].line = -1;
+		cy_port[i].magic = -1;
+	}
 #endif
 }
 
@@ -5483,6 +5492,12 @@ static int __init cy_init(void)
 		cy_card[i].base_addr = NULL;
 	}
 
+	/* invalidate remaining cy_port structures */
+	for (i = 0; i < NR_PORTS; i++) {
+		cy_port[i].line = -1;
+		cy_port[i].magic = -1;
+	}
+
 	/* the code below is responsible to find the boards. Each different
 	   type of board has its own detection routine. If a board is found,
 	   the next cy_card structure available is set by the detection
@@ -5498,29 +5513,7 @@ static int __init cy_init(void)
 
 	cy_nboard = cy_isa_nboard + cy_pci_nboard;
 
-	/* invalidate remaining cy_card structures */
-	for (i = 0; i < NR_CARDS; i++) {
-		if (cy_card[i].base_addr == 0) {
-			cy_card[i].first_line = -1;
-			cy_card[i].ctl_addr = NULL;
-			cy_card[i].irq = 0;
-			cy_card[i].bus_index = 0;
-			cy_card[i].first_line = 0;
-			cy_card[i].num_chips = 0;
-		}
-	}
-	/* invalidate remaining cy_port structures */
-	for (i = cy_next_channel; i < NR_PORTS; i++) {
-		cy_port[i].line = -1;
-		cy_port[i].magic = -1;
-	}
-
-	/* initialize per-port data structures for each valid board found */
-	for (i = 0; i < cy_nboard; i++)
-		cy_init_card(&cy_card[i], i);
-
 	return 0;
-
 }				/* cy_init */
 
 static void __exit cy_cleanup_module(void)
