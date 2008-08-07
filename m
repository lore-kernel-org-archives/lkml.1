Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYHGR6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYHGR6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYHGR6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:58:16 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:38965 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYHGR6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:58:15 -0400
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 13:58:14 EDT
Subject: [PATCH] ath5k: Don't fiddle with MSI on suspend/resume.
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, mickflemm@gmail.com,
       mcgrof@gmail.com
Content-Type: text/plain
Date: Thu, 07 Aug 2008 19:34:01 +0200
Message-Id: <1218130441.18466.150.camel@hermes2.karcher.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 160.45.35.69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 256b152b005e319f985f50f2a910a75ba0def74f has removed msi support,
but overlooked the suspend/resume code. This patch completes msi removal.

I don't consider this patch copyrightable, and thus put it into the
public domain. The result is of course a base.c file dual-licensed under
3-clause-BSD and GPL.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

---
 drivers/net/wireless/ath5k/base.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index ebf19bc..d092a23 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -589,7 +589,6 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	ath5k_stop_hw(sc);
 
 	free_irq(pdev->irq, sc);
-	pci_disable_msi(pdev);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -618,12 +617,10 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	pci_enable_msi(pdev);
-
 	err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
 	if (err) {
 		ATH5K_ERR(sc, "request_irq failed\n");
-		goto err_msi;
+		goto err_no_irq;
 	}
 
 	err = ath5k_init(sc);
@@ -644,8 +641,7 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	return 0;
 err_irq:
 	free_irq(pdev->irq, sc);
-err_msi:
-	pci_disable_msi(pdev);
+err_no_irq:
 	pci_disable_device(pdev);
 	return err;
 }
-- 
1.5.5.4

