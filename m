Return-Path: <linux-kernel-owner+w=401wt.eu-S1764469AbZGABIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764469AbZGABIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760783AbZGAAfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:24 -0400
Received: from kroah.org ([198.145.64.141]:60556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761523AbZGAAfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:36 2009
Message-Id: <20090701002436.333343967@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jouni Malinen <jouni.malinen@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 074/108] ath9k: Fix PCI FATAL interrupts by restoring RETRY_TIMEOUT disabling
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-fix-pci-fatal-interrupts-by-restoring-retry_timeout-disabling.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jouni Malinen <jouni.malinen@atheros.com>

commit f0214843ba23d9bf6dc6b8ad2c6ee27b60f0322e upstream.

An earlier commit, 'ath9k: remove dummy PCI "retry timeout" fix', removed
code that was documented to disable RETRY_TIMEOUT register (PCI reg
0x41) since it was claimed to be a no-op. However, it turns out that
there are some combinations of hosts and ath9k-supported cards for
which this is not a no-op (reg 0x41 has value 0x80, not 0) and this
code (or something similar) is needed. In such cases, the driver may
be next to unusable due to very frequent PCI FATAL interrupts from the
card.

Reverting the earlier commit, i.e., restoring the RETRY_TIMEOUT
disabling, seems to resolve the issue. Since the removal of this code
was not based on any known issue and was purely a cleanup change, the
safest option here is to just revert that commit. Should there be
desire to clean this up in the future, the change will need to be
tested with a more complete coverage of cards and host systems.

http://bugzilla.kernel.org/show_bug.cgi?id=13483

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/pci.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -87,6 +87,7 @@ static int ath_pci_probe(struct pci_dev 
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
+	u32 val;
 	int ret = 0;
 	struct ath_hw *ah;
 
@@ -133,6 +134,14 @@ static int ath_pci_probe(struct pci_dev 
 
 	pci_set_master(pdev);
 
+	/*
+	 * Disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state.
+	 */
+	pci_read_config_dword(pdev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
+
 	ret = pci_request_region(pdev, 0, "ath9k");
 	if (ret) {
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
@@ -244,12 +253,21 @@ static int ath_pci_resume(struct pci_dev
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	u32 val;
 	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 	pci_restore_state(pdev);
+	/*
+	 * Suspend/Resume resets the PCI configuration space, so we have to
+	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state
+	 */
+	pci_read_config_dword(pdev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
 	/* Enable LED */
 	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,


