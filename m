Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbZJBBpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbZJBBpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZJBBpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:45:40 -0400
Received: from kroah.org ([198.145.64.141]:33344 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752AbZJBBdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:20 2009
Message-Id: <20091002012420.235682094@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [086/136] ath5k: do not release irq across suspend/resume
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ath5k-do-not-release-irq-across-suspend-resume.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bob Copeland <me@bobcopeland.com>

commit 0d0cd72fa1e6bfd419c99478ec70b4877ed0ef86 upstream.

Paraphrasing Rafael J. Wysocki: "drivers should not release PCI IRQs
in suspend."  Doing so causes a warning during suspend/resume on some
platforms.

Cc: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -666,7 +666,6 @@ ath5k_pci_suspend(struct pci_dev *pdev, 
 
 	ath5k_led_off(sc);
 
-	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -694,18 +693,8 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
-	if (err) {
-		ATH5K_ERR(sc, "request_irq failed\n");
-		goto err_no_irq;
-	}
-
 	ath5k_led_enable(sc);
 	return 0;
-
-err_no_irq:
-	pci_disable_device(pdev);
-	return err;
 }
 #endif /* CONFIG_PM */
 


