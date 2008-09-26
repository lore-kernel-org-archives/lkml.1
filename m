Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYIZCNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYIZCNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYIZCMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:12:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:60289 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbYIZCMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:12:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="443798288"
Date: Thu, 25 Sep 2008 19:12:12 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251912020.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e1000e: allow bad checksum

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

currently if the driver notices a bad checksum it will fail to
load.  This patch allows the driver load process to continue with
an invalid mac address and could allow the user to use ethtool or
another app to fix the eeprom.

copied from implementation in e1000

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/netdev.c |   80 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 89ca272..ad026d0 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4338,6 +4338,52 @@ static void e1000_eeprom_checks(struct e1000_adapter *adapter)
 }
 
 /**
+ * e1000e_dump_eeprom - write the eeprom to kernel log
+ * @adapter: our adapter struct
+ *
+ * Dump the eeprom for users having checksum issues
+ **/
+static void e1000e_dump_eeprom(struct e1000_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct ethtool_eeprom eeprom;
+	const struct ethtool_ops *ops = netdev->ethtool_ops;
+	u8 *data;
+	int i;
+	u16 csum_old, csum_new = 0;
+
+	eeprom.len = ops->get_eeprom_len(netdev);
+	eeprom.offset = 0;
+
+	data = kzalloc(eeprom.len, GFP_KERNEL);
+	if (!data) {
+		printk(KERN_ERR "Unable to allocate memory to dump EEPROM"
+		       " data\n");
+		return;
+	}
+
+	ops->get_eeprom(netdev, &eeprom, data);
+
+	csum_old = (data[NVM_CHECKSUM_REG * 2]) +
+		   (data[NVM_CHECKSUM_REG * 2 + 1] << 8);
+	for (i = 0; i < NVM_CHECKSUM_REG * 2; i += 2)
+		csum_new += data[i] + (data[i + 1] << 8);
+	csum_new = NVM_SUM - csum_new;
+
+	printk(KERN_ERR "/*********************/\n");
+	printk(KERN_ERR "Current EEPROM Checksum : 0x%04x\n", csum_old);
+	printk(KERN_ERR "Calculated              : 0x%04x\n", csum_new);
+
+	printk(KERN_ERR "Offset    Values\n");
+	printk(KERN_ERR "========  ======\n");
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1, data, 128, 0);
+
+	printk(KERN_ERR "/*********************/\n");
+
+	kfree(data);
+}
+
+/**
  * e1000_probe - Device Initialization Routine
  * @pdev: PCI device information struct
  * @ent: entry in e1000_pci_tbl
@@ -4530,31 +4576,38 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	 * attempt. Let's give it a few tries
 	 */
 	for (i = 0;; i++) {
-		if (e1000_validate_nvm_checksum(&adapter->hw) >= 0)
+		if (e1000_validate_nvm_checksum(hw) >= 0) {
+			/* copy the MAC address out of the NVM */
+			if (e1000e_read_mac_addr(&adapter->hw))
+				e_err("NVM Read Error reading MAC address\n");
 			break;
+		}
 		if (i == 2) {
 			e_err("The NVM Checksum Is Not Valid\n");
-			err = -EIO;
-			goto err_eeprom;
+			e1000e_dump_eeprom(adapter);
+			/*
+			 * set MAC address to all zeroes to invalidate and
+			 * temporary disable this device for the user. This
+			 * blocks regular traffic while still permitting
+			 * ethtool ioctls from reaching the hardware as well as
+			 * allowing the user to run the interface after
+			 * manually setting a hw addr using
+			 * `ip link set address`
+			 */
+			memset(hw->mac.addr, 0, netdev->addr_len);
 		}
 	}
 
 	e1000_eeprom_checks(adapter);
 
-	/* copy the MAC address out of the NVM */
-	if (e1000e_read_mac_addr(&adapter->hw))
-		e_err("NVM Read Error while reading MAC address\n");
-
+	/* don't block initalization here due to bad MAC address */
 	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
 	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
 
 	if (!is_valid_ether_addr(netdev->perm_addr)) {
-		e_err("Invalid MAC Address: %02x:%02x:%02x:%02x:%02x:%02x\n",
-		      netdev->perm_addr[0], netdev->perm_addr[1],
-		      netdev->perm_addr[2], netdev->perm_addr[3],
-		      netdev->perm_addr[4], netdev->perm_addr[5]);
-		err = -EIO;
-		goto err_eeprom;
+		DECLARE_MAC_BUF(mac);
+		e_err("Invalid MAC Address: %s\n",
+		      print_mac(mac, netdev->perm_addr));
 	}
 
 	init_timer(&adapter->watchdog_timer);
@@ -4643,7 +4696,6 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 err_register:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000_release_hw_control(adapter);
-err_eeprom:
 	if (!e1000_check_reset_block(&adapter->hw))
 		e1000_phy_hw_reset(&adapter->hw);
 err_hw_init:
