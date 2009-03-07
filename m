Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZCGEfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZCGEfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 23:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZCGEfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 23:35:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:36553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZCGEfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 23:35:41 -0500
Message-ID: <49B1F934.5050006@kernel.org>
Date: Fri, 06 Mar 2009 20:33:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: [PATCH] igb: fix kexec with igb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: could probe igb

Found one system with 82575EB, in the kernel that is kexeced, probe igb
failed with -2.

it looks like the same behavior happened on forcedeth.

try to check system_state to make sure if put it on D3

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/net/igb/igb_main.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/net/igb/igb_main.c
===================================================================
--- linux-2.6.orig/drivers/net/igb/igb_main.c
+++ linux-2.6/drivers/net/igb/igb_main.c
@@ -4358,14 +4358,22 @@ static int igb_suspend(struct pci_dev *p
 		wr32(E1000_WUFC, 0);
 	}
 
+	/*
+	 * Apparently it is not possible to reinitialise from D3 hot,
+	 * only put the device into D3 if we really go for poweroff.
+	 */
 	/* make sure adapter isn't asleep if manageability/wol is enabled */
 	if (wufc || adapter->en_mng_pt) {
-		pci_enable_wake(pdev, PCI_D3hot, 1);
-		pci_enable_wake(pdev, PCI_D3cold, 1);
+		if (system_state == SYSTEM_POWER_OFF) {
+			pci_enable_wake(pdev, PCI_D3hot, 1);
+			pci_enable_wake(pdev, PCI_D3cold, 1);
+		}
 	} else {
 		igb_shutdown_fiber_serdes_link_82575(hw);
-		pci_enable_wake(pdev, PCI_D3hot, 0);
-		pci_enable_wake(pdev, PCI_D3cold, 0);
+		if (system_state == SYSTEM_POWER_OFF) {
+			pci_enable_wake(pdev, PCI_D3hot, 0);
+			pci_enable_wake(pdev, PCI_D3cold, 0);
+		}
 	}
 
 	/* Release control of h/w to f/w.  If f/w is AMT enabled, this
@@ -4374,7 +4382,8 @@ static int igb_suspend(struct pci_dev *p
 
 	pci_disable_device(pdev);
 
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	if (system_state == SYSTEM_POWER_OFF)
+		pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
