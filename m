Return-Path: <linux-kernel-owner+w=401wt.eu-S936963AbXHGVQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936963AbXHGVQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964896AbXHGUy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:54:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59685 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbXHGUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:54:57 -0400
Date: Tue, 7 Aug 2007 13:47:52 -0700
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
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: [2.6.22.2 review 56/84] forcedeth bug fix: realtek phy
Message-ID: <20070807204752.GF23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="forcedeth-bug-fix-realtek-phy.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch contains errata fixes for the realtek phy. It only renamed the
defines to be phy specific.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -551,6 +551,7 @@ union ring_type {
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
 #define PHY_OUI_VITESSE	0x01c1
+#define PHY_OUI_REALTEK	0x01c1
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00
@@ -580,6 +581,13 @@ union ring_type {
 #define PHY_VITESSE_INIT8	0x0100
 #define PHY_VITESSE_INIT9	0x8f82
 #define PHY_VITESSE_INIT10	0x0
+#define PHY_REALTEK_INIT_REG1	0x1f
+#define PHY_REALTEK_INIT_REG2	0x19
+#define PHY_REALTEK_INIT_REG3	0x13
+#define PHY_REALTEK_INIT1	0x0000
+#define PHY_REALTEK_INIT2	0x8e00
+#define PHY_REALTEK_INIT3	0x0001
+#define PHY_REALTEK_INIT4	0xad17
 
 #define PHY_GIGABIT	0x0100
 
@@ -1114,6 +1122,28 @@ static int phy_init(struct net_device *d
 			return PHY_ERROR;
 		}
 	}
+	if (np->phy_oui == PHY_OUI_REALTEK) {
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG2, PHY_REALTEK_INIT2)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT3)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG3, PHY_REALTEK_INIT4)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+	}
 
 	/* set advertise register */
 	reg = mii_rw(dev, np->phyaddr, MII_ADVERTISE, MII_READ);
@@ -1250,6 +1280,30 @@ static int phy_init(struct net_device *d
 			return PHY_ERROR;
 		}
 	}
+	if (np->phy_oui == PHY_OUI_REALTEK) {
+		/* reset could have cleared these out, set them back */
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG2, PHY_REALTEK_INIT2)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT3)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG3, PHY_REALTEK_INIT4)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+	}
+
 	/* some phys clear out pause advertisment on reset, set it back */
 	mii_rw(dev, np->phyaddr, MII_ADVERTISE, reg);
 

-- 
