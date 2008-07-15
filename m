Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYGOPrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYGOPrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYGOPqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:46:43 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:59198 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYGOPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:46:41 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 5/5] Ath5k: suspend/resume fixes
Date: Tue, 15 Jul 2008 17:44:21 +0200
Message-Id: <1216136661-10930-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- free and re-request irq since it might have changed during suspend
- disable and enable msi
- don't set D0 state of the device, it's already done by the PCI layer
- do restore_state before enable_device, it's safer
- check ath5k_init return value

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/net/wireless/ath5k/base.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 713ee99..d58a883 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -593,6 +593,9 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	ath5k_led_off(sc);
 
 	ath5k_stop_hw(sc);
+
+	free_irq(pdev->irq, sc);
+	pci_disable_msi(pdev);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -608,15 +611,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	struct ath5k_hw *ah = sc->ah;
 	int i, err;
 
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err)
-		return err;
+	pci_restore_state(pdev);
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 
-	pci_restore_state(pdev);
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
@@ -624,7 +624,17 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	ath5k_init(sc);
+	pci_enable_msi(pdev);
+
+	err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
+	if (err) {
+		ATH5K_ERR(sc, "request_irq failed\n");
+		goto err_msi;
+	}
+
+	err = ath5k_init(sc);
+	if (err)
+		goto err_irq;
 	ath5k_led_enable(sc);
 
 	/*
@@ -638,6 +648,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		ath5k_hw_reset_key(ah, i);
 
 	return 0;
+err_irq:
+	free_irq(pdev->irq, sc);
+err_msi:
+	pci_disable_msi(pdev);
+	pci_disable_device(pdev);
+	return err;
 }
 #endif /* CONFIG_PM */
 
-- 
1.5.6.2

