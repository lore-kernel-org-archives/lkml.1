Return-Path: <linux-kernel-owner+w=401wt.eu-S1762516AbXHVJDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762516AbXHVJDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbXHVIxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:34 -0400
Received: from 1wt.eu ([62.212.114.60]:2094 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXHVIxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:31 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084025.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:18 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Ayaz Abdulla <aabdulla@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 34/58] forcedeth bug fix: vitesse phy
Content-Disposition: inline; filename=0034-forcedeth-bug-fix-vitesse-phy.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains errata fixes for the vitesse phy. It only renamed the
defines to be phy specific.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/forcedeth.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 63f4c58..c383dc3 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -553,6 +553,7 @@ union ring_type {
 /* PHY defines */
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
+#define PHY_OUI_VITESSE	0x01c1
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00
@@ -566,6 +567,23 @@ union ring_type {
 #define PHY_CICADA_INIT4	0x0200
 #define PHY_CICADA_INIT5	0x0004
 #define PHY_CICADA_INIT6	0x02000
+#define PHY_VITESSE_INIT_REG1	0x1f
+#define PHY_VITESSE_INIT_REG2	0x10
+#define PHY_VITESSE_INIT_REG3	0x11
+#define PHY_VITESSE_INIT_REG4	0x12
+#define PHY_VITESSE_INIT_MSK1	0xc
+#define PHY_VITESSE_INIT_MSK2	0x0180
+#define PHY_VITESSE_INIT1	0x52b5
+#define PHY_VITESSE_INIT2	0xaf8a
+#define PHY_VITESSE_INIT3	0x8
+#define PHY_VITESSE_INIT4	0x8f8a
+#define PHY_VITESSE_INIT5	0xaf86
+#define PHY_VITESSE_INIT6	0x8f86
+#define PHY_VITESSE_INIT7	0xaf82
+#define PHY_VITESSE_INIT8	0x0100
+#define PHY_VITESSE_INIT9	0x8f82
+#define PHY_VITESSE_INIT10	0x0
+
 #define PHY_GIGABIT	0x0100
 
 #define PHY_TIMEOUT	0x1
@@ -1154,6 +1172,76 @@ static int phy_init(struct net_device *dev)
 			return PHY_ERROR;
 		}
 	}
+	if (np->phy_oui == PHY_OUI_VITESSE) {
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG1, PHY_VITESSE_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG2, PHY_VITESSE_INIT2)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		phy_reserved = mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG4, MII_READ);
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG4, phy_reserved)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		phy_reserved = mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG3, MII_READ);
+		phy_reserved &= ~PHY_VITESSE_INIT_MSK1;
+		phy_reserved |= PHY_VITESSE_INIT3;
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG3, phy_reserved)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG2, PHY_VITESSE_INIT4)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG2, PHY_VITESSE_INIT5)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		phy_reserved = mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG4, MII_READ);
+		phy_reserved &= ~PHY_VITESSE_INIT_MSK1;
+		phy_reserved |= PHY_VITESSE_INIT3;
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG4, phy_reserved)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		phy_reserved = mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG3, MII_READ);
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG3, phy_reserved)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG2, PHY_VITESSE_INIT6)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG2, PHY_VITESSE_INIT7)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		phy_reserved = mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG4, MII_READ);
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG4, phy_reserved)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		phy_reserved = mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG3, MII_READ);
+		phy_reserved &= ~PHY_VITESSE_INIT_MSK2;
+		phy_reserved |= PHY_VITESSE_INIT8;
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG3, phy_reserved)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG2, PHY_VITESSE_INIT9)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_VITESSE_INIT_REG1, PHY_VITESSE_INIT10)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+	}
 	/* some phys clear out pause advertisment on reset, set it back */
 	mii_rw(dev, np->phyaddr, MII_ADVERTISE, reg);
 
-- 
1.5.2.5

-- 
