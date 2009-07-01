Return-Path: <linux-kernel-owner+w=401wt.eu-S1762555AbZGABMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555AbZGABMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbZGAAfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:43 -0400
Received: from kroah.org ([198.145.64.141]:60640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761544AbZGAAfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:40 2009
Message-Id: <20090701002440.327606088@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 088/108] ath5k: avoid PCI FATAL interrupts by restoring RETRY_TIMEOUT disabling
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath5k-avoid-pci-fatal-interrupts-by-restoring-retry_timeout-disabling.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jouni Malinen <jouni.malinen@atheros.com>

commit 8451d22dad40a66416b8d9c0952efa09ec5398c5 upstream.

This reverts 'ath5k: remove dummy PCI "retry timeout" fix' on the
same theory as in 'ath9k: Fix PCI FATAL interrupts by restoring
RETRY_TIMEOUT disabling'.

Reported-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/base.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -685,6 +685,13 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	if (err)
 		return err;
 
+	/*
+	 * Suspend/Resume resets the PCI configuration space, so we have to
+	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state
+	 */
+	pci_write_config_byte(pdev, 0x41, 0);
+
 	err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
 	if (err) {
 		ATH5K_ERR(sc, "request_irq failed\n");


