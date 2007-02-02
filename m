Return-Path: <linux-kernel-owner+w=401wt.eu-S1945957AbXBBTbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945957AbXBBTbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 14:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945898AbXBBTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 14:31:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423079AbXBBTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 14:31:42 -0500
Date: Fri, 2 Feb 2007 11:28:46 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFT] sky2 auto negotiation PHY errata
Message-ID: <20070202112846.31acaa03@freekitty>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the Marvell errata before auto negotiation
(from drivers/phy/marvell.c).  The Yukon II chips have an internal
version of the same PHY, so perhaps this errata is necessary for them
as well.

For test only, but it may fix some of the hangs. It seems to fix
the PHY lockups I saw yesterday on Mac Mini.

---
 drivers/net/sky2.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 822dd0b..4f04ffa 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -387,6 +387,14 @@ static void sky2_phy_init(struct sky2_hw
 
 	if (sky2->autoneg == AUTONEG_ENABLE) {
 		if (sky2_is_copper(hw)) {
+			/* Errata setup */
+			gm_phy_write(hw, port, PHY_MARV_PAGE_ADDR, 0x1f);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_DATA, 0x200c);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_ADDR, 5);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_DATA, 0);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_DATA, 0x100);
+
+
 			if (sky2->advertising & ADVERTISED_1000baseT_Full)
 				ct1000 |= PHY_M_1000C_AFD;
 			if (sky2->advertising & ADVERTISED_1000baseT_Half)
-- 
1.4.1

