Return-Path: <linux-kernel-owner+w=401wt.eu-S934536AbYBGVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536AbYBGVGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932901AbYBGUwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:42 -0500
Received: from ns.suse.de ([195.135.220.2]:45756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbYBGUwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:40 -0500
Date: Thu, 7 Feb 2008 12:47:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 30/45] sky2: fix for WOL on some devices
Message-ID: <20080207204749.GE16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-fix-for-wol-on-some-devices.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

patch 82637e808478087ce861129745fa60cc37e7929d in mainline

This patch disables config mode access after clearing PCI settings.
Without this change WOL won't work on some BIOS's

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -621,6 +621,7 @@ static void sky2_phy_power(struct sky2_h
 	static const u32 phy_power[] = { PCI_Y2_PHY1_POWD, PCI_Y2_PHY2_POWD };
 	static const u32 coma_mode[] = { PCI_Y2_PHY1_COMA, PCI_Y2_PHY2_COMA };
 
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
 	/* Turn on/off phy power saving */
 	if (onoff)
@@ -632,7 +633,8 @@ static void sky2_phy_power(struct sky2_h
 		reg1 |= coma_mode[port];
 
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
-	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
+	sky2_pci_read32(hw, PCI_DEV_REG1);
 
 	udelay(100);
 }
@@ -2427,6 +2429,7 @@ static void sky2_hw_intr(struct sky2_hw 
 	if (status & (Y2_IS_MST_ERR | Y2_IS_IRQ_STAT)) {
 		u16 pci_err;
 
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		pci_err = sky2_pci_read16(hw, PCI_STATUS);
 		if (net_ratelimit())
 			dev_err(&pdev->dev, "PCI hardware error (0x%x)\n",
@@ -2434,12 +2437,14 @@ static void sky2_hw_intr(struct sky2_hw 
 
 		sky2_pci_write16(hw, PCI_STATUS,
 				      pci_err | PCI_STATUS_ERROR_BITS);
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	}
 
 	if (status & Y2_IS_PCI_EXP) {
 		/* PCI-Express uncorrectable Error occurred */
 		u32 err;
 
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		err = sky2_read32(hw, Y2_CFG_AER + PCI_ERR_UNCOR_STATUS);
 		sky2_write32(hw, Y2_CFG_AER + PCI_ERR_UNCOR_STATUS,
 			     0xfffffffful);
@@ -2447,6 +2452,7 @@ static void sky2_hw_intr(struct sky2_hw 
 			dev_err(&pdev->dev, "PCI Express error (0x%x)\n", err);
 
 		sky2_read32(hw, Y2_CFG_AER + PCI_ERR_UNCOR_STATUS);
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	}
 
 	if (status & Y2_HWE_L1_MASK)
@@ -2812,6 +2818,7 @@ static void sky2_reset(struct sky2_hw *h
 	}
 
 	sky2_power_on(hw);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 
 	for (i = 0; i < hw->ports; i++) {
 		sky2_write8(hw, SK_REG(i, GMAC_LINK_CTRL), GMLC_RST_SET);

-- 
