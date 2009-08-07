Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZHGJgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZHGJgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZHGJgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:36:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787AbZHGJg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:36:29 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com,
       bruce.w.allan@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, davem@davemloft.net
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] e1000e: fix use of pci_enable_pcie_error_reporting
Date: Fri,  7 Aug 2009 17:36:14 +0800
Message-Id: <1249637774-32419-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 111b9dc5 introduces pcie aer support for e1000e, but it is not
reasonable to disable it in e1000_remove but enable it in e1000_resume.
This patch enables aer support in e1000_probe.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 drivers/net/e1000e/netdev.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 63415bb..e2f0304 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4670,14 +4670,6 @@ static int e1000_resume(struct pci_dev *pdev)
 		return err;
 	}
 
-	/* AER (Advanced Error Reporting) hooks */
-	err = pci_enable_pcie_error_reporting(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
-		                    "0x%x\n", err);
-		/* non-fatal, continue */
-	}
-
 	pci_set_master(pdev);
 
 	pci_enable_wake(pdev, PCI_D3hot, 0);
@@ -4990,6 +4982,14 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_pci_reg;
 
+        /* AER (Advanced Error Reporting) hooks */
+        err = pci_enable_pcie_error_reporting(pdev);
+        if (err) {
+                dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
+                                    "0x%x\n", err);
+                /* non-fatal, continue */
+        }
+
 	pci_set_master(pdev);
 	/* PCI config space info */
 	err = pci_save_state(pdev);
-- 
1.6.2.5

