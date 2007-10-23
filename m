Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXJWP0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXJWP0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXJWP0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:26:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbXJWP0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:26:20 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
Date: Tue, 23 Oct 2007 10:58:50 -0400
Message-Id: <11931515302013-git-send-email-ajax@redhat.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the EEPROM gets corrupted, you can fix it with ethtool, but only if
the module loads and creates a network device.  But, without this option,
if the EEPROM is corrupted, the driver will not create a network device.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/net/e1000/e1000_main.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index f1ce348..b308c32 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -255,6 +255,10 @@ static int debug = NETIF_MSG_DRV | NETIF_MSG_PROBE;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
+static int eeprom_bad_csum_allow = 0;
+module_param(eeprom_bad_csum_allow, int, 0);
+MODULE_PARM_DESC(eeprom_bad_csum_allow, "Allow bad eeprom checksums");
+
 /**
  * e1000_init_module - Driver Registration Routine
  *
@@ -1012,7 +1016,8 @@ e1000_probe(struct pci_dev *pdev,
 
 	if (e1000_validate_eeprom_checksum(&adapter->hw) < 0) {
 		DPRINTK(PROBE, ERR, "The EEPROM Checksum Is Not Valid\n");
-		goto err_eeprom;
+		if (!eeprom_bad_csum_allow)
+			goto err_eeprom;
 	}
 
 	/* copy the MAC address out of the EEPROM */
@@ -1024,7 +1029,8 @@ e1000_probe(struct pci_dev *pdev,
 
 	if (!is_valid_ether_addr(netdev->perm_addr)) {
 		DPRINTK(PROBE, ERR, "Invalid MAC Address\n");
-		goto err_eeprom;
+		if (!eeprom_bad_csum_allow)
+			goto err_eeprom;
 	}
 
 	e1000_get_bus_info(&adapter->hw);
-- 
1.5.2.4

