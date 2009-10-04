Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbZJDWvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbZJDWvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbZJDWvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:51:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43159 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041AbZJDWvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:51:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ath5k-devel@venema.h4ckr.net
Subject: [PATCH] Wireless / ath5k: Simplify suspend and resume callbacks
Date: Mon, 5 Oct 2009 00:52:09 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910050052.09085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Simplify the suspend and resume callbacks of ath5k by converting the
driver to struct dev_pm_ops and allowing the PCI PM core to do the
PCI-specific suspend/resume handling.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/wireless/ath/ath5k/base.c |   35 ++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

Index: linux-2.6/drivers/net/wireless/ath/ath5k/base.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath/ath5k/base.c
+++ linux-2.6/drivers/net/wireless/ath/ath5k/base.c
@@ -195,12 +195,13 @@ static int __devinit	ath5k_pci_probe(str
 				const struct pci_device_id *id);
 static void __devexit	ath5k_pci_remove(struct pci_dev *pdev);
 #ifdef CONFIG_PM
-static int		ath5k_pci_suspend(struct pci_dev *pdev,
-					pm_message_t state);
-static int		ath5k_pci_resume(struct pci_dev *pdev);
+static int		ath5k_pci_suspend(struct device *dev);
+static int		ath5k_pci_resume(struct device *dev);
+
+SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
+#define ATH5K_PM_OPS	(&ath5k_pm_ops)
 #else
-#define ath5k_pci_suspend NULL
-#define ath5k_pci_resume NULL
+#define ATH5K_PM_OPS	NULL
 #endif /* CONFIG_PM */
 
 static struct pci_driver ath5k_pci_driver = {
@@ -208,8 +209,7 @@ static struct pci_driver ath5k_pci_drive
 	.id_table	= ath5k_pci_id_table,
 	.probe		= ath5k_pci_probe,
 	.remove		= __devexit_p(ath5k_pci_remove),
-	.suspend	= ath5k_pci_suspend,
-	.resume		= ath5k_pci_resume,
+	.driver.pm	= ATH5K_PM_OPS,
 };
 
 
@@ -669,33 +669,20 @@ ath5k_pci_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM
-static int
-ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ath5k_pci_suspend(struct device *dev)
 {
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(to_pci_dev(dev));
 	struct ath5k_softc *sc = hw->priv;
 
 	ath5k_led_off(sc);
-
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 
-static int
-ath5k_pci_resume(struct pci_dev *pdev)
+static int ath5k_pci_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
-	int err;
-
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
 
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
