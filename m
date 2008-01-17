Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYAQW2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYAQW2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYAQW2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:28:24 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:33927 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYAQW2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:28:23 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, auke-jan.h.kok@intel.com,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       john.ronciak@intel.com, e1000-devel@lists.sourceforge.net,
       venkatesh.pallipadi@intel.com, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Net: e100, fix iomap mem accesses
Date: Thu, 17 Jan 2008 23:28:20 +0100
Message-Id: <1200608900-3507-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readX functions are not permitted on iomap-ped space change to ioreadX,
also pci_unmap pci_map-ped space on exit (instead of iounmap).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/e100.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 51cf577..47548ef 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1836,7 +1836,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 		if ((le16_to_cpu(rfd->command) & cb_el) &&
 		    (RU_RUNNING == nic->ru_running))
 
-			if (readb(&nic->csr->scb.status) & rus_no_res)
+			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
 		return -ENODATA;
 	}
@@ -1859,7 +1859,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 	if ((le16_to_cpu(rfd->command) & cb_el) &&
 	    (RU_RUNNING == nic->ru_running)) {
 
-	    if (readb(&nic->csr->scb.status) & rus_no_res)
+	    if (ioread8(&nic->csr->scb.status) & rus_no_res)
 		nic->ru_running = RU_SUSPENDED;
 	}
 
@@ -1958,7 +1958,7 @@ static void e100_rx_clean(struct nic *nic, unsigned int *work_done,
 
 	if(restart_required) {
 		// ack the rnr?
-		writeb(stat_ack_rnr, &nic->csr->scb.stat_ack);
+		iowrite8(stat_ack_rnr, &nic->csr->scb.stat_ack);
 		e100_start_receiver(nic, nic->rx_to_clean);
 		if(work_done)
 			(*work_done)++;
@@ -2774,7 +2774,7 @@ static void __devexit e100_remove(struct pci_dev *pdev)
 		struct nic *nic = netdev_priv(netdev);
 		unregister_netdev(netdev);
 		e100_free(nic);
-		iounmap(nic->csr);
+		pci_iounmap(pdev, nic->csr);
 		free_netdev(netdev);
 		pci_release_regions(pdev);
 		pci_disable_device(pdev);
-- 
1.5.3.7

