Return-Path: <linux-kernel-owner+w=401wt.eu-S936640AbZAPS2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936640AbZAPS2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZAPS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:28:07 -0500
Received: from nxgate.netxen.com ([38.99.60.130]:54448 "EHLO unm84.unmin.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751399AbZAPS2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:28:06 -0500
From: Dhananjay Phadke <dhananjay@netxen.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] netxen: avoid invalid iounmap
Date: Fri, 16 Jan 2009 10:28:03 -0800
Message-Id: <1232130484-25188-2-git-send-email-dhananjay@netxen.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232130484-25188-1-git-send-email-dhananjay@netxen.com>
References: <1232130484-25188-1-git-send-email-dhananjay@netxen.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For NX3031 only one I/O range is mapped, so unmapping other
two which are used by older chips, causes this warning on
ppc64.

"Attempt to iounmap early bolted mapping at 0x0000000000000000"

Signed-off-by: Dhananjay Phadke <dhananjay@netxen.com>
---
 drivers/net/netxen/netxen_nic_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 8686740..f8e2629 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -1004,8 +1004,10 @@ static void __devexit netxen_nic_remove(struct pci_dev *pdev)
 
 	iounmap(adapter->ahw.db_base);
 	iounmap(adapter->ahw.pci_base0);
-	iounmap(adapter->ahw.pci_base1);
-	iounmap(adapter->ahw.pci_base2);
+	if (adapter->ahw.pci_base1 != NULL)
+		iounmap(adapter->ahw.pci_base1);
+	if (adapter->ahw.pci_base2 != NULL)
+		iounmap(adapter->ahw.pci_base2);
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
1.6.0.2

