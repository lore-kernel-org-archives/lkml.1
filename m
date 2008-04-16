Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbYDPNZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbYDPNZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761176AbYDPNZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:25:33 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:1663 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438AbYDPNZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:25:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] net: let the MII driver inform a MAC about changed wire speed
Date: Wed, 16 Apr 2008 15:20:04 +0200
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301F22BDD@zuerich.BC-Int.NET>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net: let the MII driver inform a MAC about changed wire speed
Thread-Index: AcibJ86y7g67WgrMQ72dwykAarxd0A==
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: <linux-kernel@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 16 Apr 2008 13:25:32.0798 (UTC) FILETIME=[58D7F1E0:01C89FC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was tested on a ARM926 base SoC with an IP based ethernet MAC (10/100 MBit) together with a Realtek RTL8201 MII and a SMCSC
8700 RMII with kernel 2.6.24.

---
An Ethernet MAC needs to know the medium speed (10/100/1000 Mbps) of an RMII PHY in order to correctly interpret data originating
from that PHY. The function mii_check_media() has been extended to allow retrieval of the medium speed by a MAC driver. A trivial
modification to existing MAC drivers will allow them to cover operation with both MII and RMII PHYs.
Signed-off-by: Marcel Wappler <marcel.wappler@bridgeco.net>
---
Index: linux/include/linux/mii.h
--- linux/include/linux/mii.h	(revision 341)
+++ linux/include/linux/mii.h	(revision 342)
@@ -143,15 +143,25 @@ struct mii_ioctl_data {
 	__u16		val_out;
 };

-#ifdef __KERNEL__
+#ifdef __KERNEL__

 #include <linux/if.h>

+/* LINK speed is figured out in mii_check_media and needed by some MAC drivers */
+#define MII_LS_10HALF           0x01    /* MII links speed is 10HALF   */
+#define MII_LS_10FULL           0x02    /* MII links speed is 10FULL   */
+#define MII_LS_100HALF          0x04    /* MII links speed is 100HALF  */
+#define MII_LS_100FULL          0x08    /* MII links speed is 100FULL  */
+#define MII_LS_1000HALF         0x10    /* MII links speed is 1000HALF */
+#define MII_LS_1000FULL         0x20    /* MII links speed is 1000FULL */
+
+
 struct ethtool_cmd;

 struct mii_if_info {
 	int phy_id;
 	int advertising;
+	int link_speed;
 	int phy_id_mask;
 	int reg_num_mask;

Index: linux/drivers/net/mii.c
--- linux/drivers/net/mii.c	(revision 341)
+++ linux/drivers/net/mii.c	(revision 342)
@@ -297,12 +297,12 @@ void mii_check_link (struct mii_if_info
 }

 /**
- * mii_check_media - check the MII interface for a duplex change
+ * mii_check_media - check the MII interface for a speed and duplex change
  * @mii: the MII interface
  * @ok_to_print: OK to print link up/down messages
- * @init_media: OK to save duplex mode in @mii
+ * @init_media: OK to save speed and duplex mode in @mii
  *
- * Returns 1 if the duplex mode changed, 0 if not.
+ * Returns 1 if the speed or duplex mode changed, 0 if not.
  * If the media type is forced, always returns 0.
  */
 unsigned int mii_check_media (struct mii_if_info *mii,
@@ -310,7 +310,7 @@ unsigned int mii_check_media (struct mii
 			      unsigned int init_media)
 {
 	unsigned int old_carrier, new_carrier;
-	int advertise, lpa, media, duplex;
+	int advertise, lpa, media, duplex, link_speed;
 	int lpa2 = 0;

 	/* if forced media, go no further */
@@ -357,20 +357,34 @@ unsigned int mii_check_media (struct mii
 	if (lpa2 & LPA_1000FULL)
 		duplex = 1;

+    /* figure out  link speed */
+    if (lpa2 & LPA_1000FULL)
+        link_speed = MII_LS_1000FULL;
+    else if (lpa2 & LPA_1000HALF)
+        link_speed = MII_LS_1000HALF;
+    else if (media & ADVERTISE_100FULL)
+        link_speed = MII_LS_100FULL;
+    else if (media & ADVERTISE_100HALF)
+        link_speed = MII_LS_100HALF;
+    else if (media & ADVERTISE_10FULL)
+        link_speed = MII_LS_10FULL;
+        else link_speed = MII_LS_10HALF;
+
 	if (ok_to_print)
 		printk(KERN_INFO "%s: link up, %sMbps, %s-duplex, lpa 0x%04X\n",
 		       mii->dev->name,
-		       lpa2 & (LPA_1000FULL | LPA_1000HALF) ? "1000" :
-		       media & (ADVERTISE_100FULL | ADVERTISE_100HALF) ? "100" : "10",
+		       link_speed & (MII_LS_1000FULL | MII_LS_1000HALF) ? "1000" :
+		       link_speed & (MII_LS_100FULL  | MII_LS_100HALF) ? "100" : "10",
 		       duplex ? "full" : "half",
 		       lpa);

-	if ((init_media) || (mii->full_duplex != duplex)) {
+	if ((init_media) || (mii->full_duplex != duplex) || mii->link_speed != link_speed) {
 		mii->full_duplex = duplex;
-		return 1; /* duplex changed */
+		mii->link_speed = link_speed;
+		return 1; /* speed or duplex changed */
 	}

-	return 0; /* duplex did not change */
+	return 0; /* sped and duplex did not change */
 }

 /**

