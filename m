Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0AYEqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0AYEqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 23:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857Ab0AYEqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 23:46:34 -0500
Received: from mail.vyatta.com ([76.74.103.46]:35186 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab0AYEqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 23:46:32 -0500
Date: Sun, 24 Jan 2010 20:46:06 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "David S. Miller" <davem@davemloft.net>
Cc: Tino Keitel <tino.keitel@gmx.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] sky2: revert config space change
Message-ID: <20100124204606.2760d34e@nehalam>
In-Reply-To: <201001242135.29309.rjw@sisk.pl>
References: <20100115091053.GA5477@mac.home>
	<20100119105105.184c3f01@nehalam>
	<20100119193745.GA5797@x61.home>
	<201001242135.29309.rjw@sisk.pl>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously, this register had some other impact that is causing
the regression.  Either it is masking some other access or needs
to be reset in some path.

Either, way it is best to just revert the change for 2.6.33


This reverts commit 166a0fd4c788ec7f10ca8194ec6d526afa12db75.
---
 drivers/net/sky2.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index f8f50f7..64b441c 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -644,6 +644,7 @@ static void sky2_phy_power_up(struct sky2_hw *hw, unsigned port)
 {
 	u32 reg1;
 
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
 	reg1 &= ~phy_power[port];
 
@@ -651,6 +652,7 @@ static void sky2_phy_power_up(struct sky2_hw *hw, unsigned port)
 		reg1 |= coma_mode[port];
 
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	sky2_pci_read32(hw, PCI_DEV_REG1);
 
 	if (hw->chip_id == CHIP_ID_YUKON_FE)
@@ -707,9 +709,11 @@ static void sky2_phy_power_down(struct sky2_hw *hw, unsigned port)
 		gm_phy_write(hw, port, PHY_MARV_CTRL, PHY_CT_PDOWN);
 	}
 
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
 	reg1 |= phy_power[port];		/* set PHY to PowerDown/COMA Mode */
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 }
 
 /* Force a renegotiation */
@@ -2149,7 +2153,9 @@ static void sky2_qlink_intr(struct sky2_hw *hw)
 
 	/* reset PHY Link Detect */
 	phy = sky2_pci_read16(hw, PSM_CONFIG_REG4);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	sky2_pci_write16(hw, PSM_CONFIG_REG4, phy | 1);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 
 	sky2_link_up(sky2);
 }
@@ -2640,6 +2646,7 @@ static void sky2_hw_intr(struct sky2_hw *hw)
 	if (status & (Y2_IS_MST_ERR | Y2_IS_IRQ_STAT)) {
 		u16 pci_err;
 
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		pci_err = sky2_pci_read16(hw, PCI_STATUS);
 		if (net_ratelimit())
 			dev_err(&pdev->dev, "PCI hardware error (0x%x)\n",
@@ -2647,12 +2654,14 @@ static void sky2_hw_intr(struct sky2_hw *hw)
 
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
@@ -2660,6 +2669,7 @@ static void sky2_hw_intr(struct sky2_hw *hw)
 			dev_err(&pdev->dev, "PCI Express error (0x%x)\n", err);
 
 		sky2_read32(hw, Y2_CFG_AER + PCI_ERR_UNCOR_STATUS);
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	}
 
 	if (status & Y2_HWE_L1_MASK)
@@ -3038,6 +3048,7 @@ static void sky2_reset(struct sky2_hw *hw)
 	}
 
 	sky2_power_on(hw);
+	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 
 	for (i = 0; i < hw->ports; i++) {
 		sky2_write8(hw, SK_REG(i, GMAC_LINK_CTRL), GMLC_RST_SET);
@@ -3074,6 +3085,7 @@ static void sky2_reset(struct sky2_hw *hw)
 		reg <<= PSM_CONFIG_REG4_TIMER_PHY_LINK_DETECT_BASE;
 
 		/* reset PHY Link Detect */
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 		sky2_pci_write16(hw, PSM_CONFIG_REG4,
 				 reg | PSM_CONFIG_REG4_RST_PHY_LINK_DETECT);
 		sky2_pci_write16(hw, PSM_CONFIG_REG4, reg);
@@ -3091,6 +3103,7 @@ static void sky2_reset(struct sky2_hw *hw)
 			/* restore the PCIe Link Control register */
 			sky2_pci_write16(hw, cap + PCI_EXP_LNKCTL, reg);
 		}
+		sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 
 		/* re-enable PEX PM in PEX PHY debug reg. 8 (clear bit 12) */
 		sky2_write32(hw, Y2_PEX_PHY_DATA, PEX_DB_ACCESS | (0x08UL << 16));
-- 
1.6.3.3

