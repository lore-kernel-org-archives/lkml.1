Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbYA2Vtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbYA2Vtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbYA2VtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:49:21 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42123 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYA2VtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:49:19 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       <auke-jan.h.kok@intel.com>, <jesse.brandeburg@intel.com>,
       <jeffrey.t.kirsher@intel.com>, <john.ronciak@intel.com>,
       <e1000-devel@lists.sourceforge.net>, <venkatesh.pallipadi@intel.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Net: e100, fix iomap mem accesses
Date: Tue, 29 Jan 2008 22:49:16 +0100
Message-Id: <1201643356-28221-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <479F9E14.1070700@intel.com>
References: <479F9E14.1070700@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against netdev-2.6 follows.
--
writeX functions are not permitted on iomap-ped space change to iowriteX,
also pci_unmap pci_map-ped space on exit (instead of iounmap).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/e100.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 51cf577..47548ef 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1904,7 +1904,7 @@ static void e100_rx_clean(struct nic *nic, unsigned int *work_done,
 
 	if(restart_required) {
 		// ack the rnr?
-		writeb(stat_ack_rnr, &nic->csr->scb.stat_ack);
+		iowrite8(stat_ack_rnr, &nic->csr->scb.stat_ack);
 		e100_start_receiver(nic, rx_to_start);
 		if(work_done)
 			(*work_done)++;
@@ -2706,7 +2706,7 @@ static void __devexit e100_remove(struct pci_dev *pdev)
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

