Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbXKOGss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbXKOGss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762153AbXKOGnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:43:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55161 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbXKOGnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:43:01 -0500
Date: Wed, 14 Nov 2007 22:41:03 -0800
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
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/16] sky2: fix power settings on Yukon XL
Message-ID: <20071115064103.GL18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-phy-power.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

patch ff35164e72648e0bf0b10ec4410c195e8607e88b in mainline.

Make sure PCI register for PHY power gets set correctly.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/sky2.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -603,21 +603,22 @@ static void sky2_phy_init(struct sky2_hw
 static void sky2_phy_power(struct sky2_hw *hw, unsigned port, int onoff)
 {
 	u32 reg1;
-	static const u32 phy_power[]
-		= { PCI_Y2_PHY1_POWD, PCI_Y2_PHY2_POWD };
-
-	/* looks like this XL is back asswards .. */
-	if (hw->chip_id == CHIP_ID_YUKON_XL && hw->chip_rev > 1)
-		onoff = !onoff;
+	static const u32 phy_power[] = { PCI_Y2_PHY1_POWD, PCI_Y2_PHY2_POWD };
+	static const u32 coma_mode[] = { PCI_Y2_PHY1_COMA, PCI_Y2_PHY2_COMA };
 
 	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
 	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
+
 	if (onoff)
 		/* Turn off phy power saving */
 		reg1 &= ~phy_power[port];
 	else
 		reg1 |= phy_power[port];
 
+	if (onoff && hw->chip_id == CHIP_ID_YUKON_XL && hw->chip_rev > 1)
+		reg1 |= coma_mode[port];
+
+
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
 	sky2_pci_read32(hw, PCI_DEV_REG1);
 	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);

-- 
