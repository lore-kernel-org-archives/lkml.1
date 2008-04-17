Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbYDQOkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbYDQOkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbYDQOkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:40:09 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41960 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbYDQOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:40:08 -0400
Message-ID: <48076145.1080906@tiscali.nl>
Date: Thu, 17 Apr 2008 16:40:05 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: romieu@fr.zoreil.com
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] NET: r8169: fix past rtl_chip_info arraysize for unknown
 chipsets
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i is unsigned, so, with an unknown chip, for (;i >= 0;) fails and i
just keeps decrementing, underflowing past ARRAY_SIZE(rtl_chip_info).

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 3acfeea..7d6be1b 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1702,21 +1702,19 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Identify chip attached to board */
 	rtl8169_get_mac_version(tp, ioaddr);
-
 	rtl8169_print_mac_version(tp);
 
-	for (i = ARRAY_SIZE(rtl_chip_info) - 1; i >= 0; i--) {
-		if (tp->mac_version == rtl_chip_info[i].mac_version)
+	for (i = ARRAY_SIZE(rtl_chip_info) - 1;
+			tp->mac_version != rtl_chip_info[i].mac_version; i--) {
+		if (i == 0) {
+			/* Unknown chip: assume chipset 0: original RTL-8169 */
+			if (netif_msg_probe(tp)) {
+				dev_printk(KERN_DEBUG, &pdev->dev,
+					"unknown chip version, assuming %s\n",
+					rtl_chip_info[0].name);
+			}
 			break;
-	}
-	if (i < 0) {
-		/* Unknown chip: assume array element #0, original RTL-8169 */
-		if (netif_msg_probe(tp)) {
-			dev_printk(KERN_DEBUG, &pdev->dev,
-				"unknown chip version, assuming %s\n",
-				rtl_chip_info[0].name);
 		}
-		i++;
 	}
 	tp->chipset = i;
 
