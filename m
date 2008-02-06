Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbYBFKmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbYBFKmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYBFKmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:42:47 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57347 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbYBFKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:42:46 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: <linux-kernel@vger.kernel.org>, ath5k-devel@lists.ath5k.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFT 1/1] single_chip test
Date: Wed,  6 Feb 2008 11:42:40 +0100
Message-Id: <1202294560-7313-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080206014131.9d489a34.akpm@linux-foundation.org>
References: <20080206014131.9d489a34.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2008 11:57 PM, Tino Keitel wrote:
> Hi,
> 
> I tried the current git (9ef9dc69d4167276c04590d67ee55de8380bc1ad) and
> got the following error message from ath5k:
> 
> ath5k_pci 0000:02:00.0: registered as 'phy0'
> ath5k phy0: failed to resume the MAC Chip
> ath5k_pci: probe of 0000:02:00.0 failed with error -5

We failed to resume after a hardware reset here for a whole second. Is there any 
version of ath5k which worked for you (is this a regression)?

> Here is the lspci -vnn output:
> 
> 02:00.0 Ethernet controller [0200]: Atheros Communications, Inc.
> AR5006EG 802.11 b/g Wireless PCI Express Adapter [168c:001c] (rev 01)
> 	Subsystem: Apple Computer Inc. Unknown device [106b:0086]
> 	Flags: fast devsel, IRQ 17
> 	Memory at 90100000 (64-bit, non-prefetchable) [disabled]
> 	[size=64K]
> 	Capabilities: [40] Power Management version 2
> 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
> 	Queue=0/0 Enable-
> 	Capabilities: [60] Express Legacy Endpoint, MSI 00
> 	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
> 	Capabilities: [100] Advanced Error Reporting <?>
> 	Capabilities: [140] Virtual Channel <?>
> 	Kernel modules: ath5k
> 
> The same device works with madwifi:
> 
> ath_rate_sample: 1.2 (svn r3339)
> MadWifi: ath_attach: Switching per-packet transmit power control off
> wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
> wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps
> 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: H/W encryption support: WEP AES AES_CCM TKIP
> wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
> wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
> wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
> wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
> wifi0: ath_announce: Use hw queue 8 for CAB traffic
> wifi0: ath_announce: Use hw queue 9 for beacons
> ath_pci: wifi0: Atheros 5424/2424: mem=0x90100000, irq=17
> 
> I can also set the interface up and use iwlist ath0 scan.

Hmm, I guess madwif-old-openhal doesn't work either.

I suspect ath5k_hw_nic_wakeup being called before setting ah_single_chip in 
ath5k_hw_attach. Could you test the attached patch?

--

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/ath5k/hw.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 3a4bf40..b56d239 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -181,11 +181,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	else if (ah->ah_version <= AR5K_AR5211)
 		ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
 
-	/* Bring device out of sleep and reset it's units */
-	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
-	if (ret)
-		goto err_free;
-
 	/* Get MAC, PHY and RADIO revisions */
 	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
 	ah->ah_mac_srev = srev;
@@ -210,12 +205,16 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	}
 
 	/* Identify single chip solutions */
-	if((srev <= AR5K_SREV_VER_AR5414) &&
-	(srev >= AR5K_SREV_VER_AR2424)) {
-		ah->ah_single_chip = true;
-	} else {
-		ah->ah_single_chip = false;
-	}
+	ah->ah_single_chip = !!(srev >= AR5K_SREV_VER_AR2424 &&
+			srev <= AR5K_SREV_VER_AR5414);
+
+	printk(KERN_INFO "SINGLE: %d, srev: %x, phy:\n",
+			ah->ah_single_chip, srev, ah->ah_phy_revision);
+
+	/* Bring device out of sleep and reset it's units */
+	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
+	if (ret)
+		goto err_free;
 
 	/* Single chip radio */
 	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
-- 
1.5.3.8

