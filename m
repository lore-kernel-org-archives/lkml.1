Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZDDVmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZDDVmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZDDVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:41:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946AbZDDVlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:41:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NetDev <netdev@vger.kernel.org>
Subject: [RFT][PATCH 3/3] NET/ixgbe: Fix powering off during shutdown
Date: Sat, 4 Apr 2009 23:41:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200904042337.31706.rjw@sisk.pl>
In-Reply-To: <200904042337.31706.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904042341.57942.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Impact: Fix

Prevent ixgbe from putting the adapter into D3 during shutdown
except when we're going to power off the system, since doing that may
generally cause problems with kexec to happen (such problems were
observed for igb and forcedeth).  For this purpose seperate
ixgbe_shutdown() from ixgbe_suspend() and use the appropriate PCI
PM callbacks in both of them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/ixgbe/ixgbe_main.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/net/ixgbe/ixgbe_main.c
===================================================================
--- linux-2.6.orig/drivers/net/ixgbe/ixgbe_main.c
+++ linux-2.6/drivers/net/ixgbe/ixgbe_main.c
@@ -3611,9 +3611,9 @@ static int ixgbe_resume(struct pci_dev *
 
 	return 0;
 }
-
 #endif /* CONFIG_PM */
-static int ixgbe_suspend(struct pci_dev *pdev, pm_message_t state)
+
+static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
@@ -3672,18 +3672,46 @@ static int ixgbe_suspend(struct pci_dev 
 		pci_enable_wake(pdev, PCI_D3cold, 0);
 	}
 
+	*enable_wake = !!wufc;
+
 	ixgbe_release_hw_control(adapter);
 
 	pci_disable_device(pdev);
 
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ixgbe_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int retval;
+	bool wake;
+
+	retval = __ixgbe_shutdown(pdev, &wake);
+	if (retval)
+		return retval;
+
+	if (wake) {
+		pci_prepare_to_sleep(pdev);
+	} else {
+		pci_wake_from_d3(pdev, false);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
 
 	return 0;
 }
+#endif /* CONFIG_PM */
 
 static void ixgbe_shutdown(struct pci_dev *pdev)
 {
-	ixgbe_suspend(pdev, PMSG_SUSPEND);
+	bool wake;
+
+	__ixgbe_shutdown(pdev, &wake);
+
+	if (system_state == SYSTEM_POWER_OFF) {
+		pci_wake_from_d3(pdev, wake);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
 }
 
 /**
