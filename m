Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYEADgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYEADgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYEADgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:36:36 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:38921 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754274AbYEADgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:36:35 -0400
Date: Thu, 1 May 2008 13:35:34 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010335.m413ZYTk004618@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: fix ColdFire 5272 fec driver hash registers
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed the 5272 hash_table registers to match the "grp" hash_table
registers of the other ColdFire parts. They are actually a group hash.
The makes for consistent setup across all ColdFire parts.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/drivers/net/fec.h linux-2.6.25-uc0/drivers/net/fec.h
--- linux-2.6.25/drivers/net/fec.h	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/drivers/net/fec.h	2008-02-05 17:23:17.000000000 +1000
@@ -88,8 +88,8 @@ typedef struct fec {
 	unsigned long	fec_reserved7[158];
 	unsigned long	fec_addr_low;		/* Low 32bits MAC address */
 	unsigned long	fec_addr_high;		/* High 16bits MAC address */
-	unsigned long	fec_hash_table_high;	/* High 32bits hash table */
-	unsigned long	fec_hash_table_low;	/* Low 32bits hash table */
+	unsigned long	fec_grp_hash_table_high;/* High 32bits hash table */
+	unsigned long	fec_grp_hash_table_low;	/* Low 32bits hash table */
 	unsigned long	fec_r_des_start;	/* Receive descriptor ring */
 	unsigned long	fec_x_des_start;	/* Transmit descriptor ring */
 	unsigned long	fec_r_buff_size;	/* Maximum receive buff size */
diff -Naurp linux-2.6.25/drivers/net/fec.c linux-2.6.25-uc0/drivers/net/fec.c
--- linux-2.6.25/drivers/net/fec.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/drivers/net/fec.c	2008-05-01 13:30:39.000000000 +1000
@@ -2243,13 +2243,13 @@ static void set_multicast_list(struct ne
 			/* Catch all multicast addresses, so set the
 			 * filter to all 1's.
 			 */
-			ep->fec_hash_table_high = 0xffffffff;
-			ep->fec_hash_table_low = 0xffffffff;
+			ep->fec_grp_hash_table_high = 0xffffffff;
+			ep->fec_grp_hash_table_low = 0xffffffff;
 		} else {
 			/* Clear filter and add the addresses in hash register.
 			*/
-			ep->fec_hash_table_high = 0;
-			ep->fec_hash_table_low = 0;
+			ep->fec_grp_hash_table_high = 0;
+			ep->fec_grp_hash_table_low = 0;
 
 			dmi = dev->mc_list;
 
@@ -2280,9 +2280,9 @@ static void set_multicast_list(struct ne
 				hash = (crc >> (32 - HASH_BITS)) & 0x3f;
 
 				if (hash > 31)
-					ep->fec_hash_table_high |= 1 << (hash - 32);
+					ep->fec_grp_hash_table_high |= 1 << (hash - 32);
 				else
-					ep->fec_hash_table_low |= 1 << hash;
+					ep->fec_grp_hash_table_low |= 1 << hash;
 			}
 		}
 	}
@@ -2430,11 +2430,15 @@ int __init fec_enet_init(struct net_devi
 	*/
 	fec_request_intrs(dev);
 
-	fecp->fec_hash_table_high = 0;
-	fecp->fec_hash_table_low = 0;
+	fecp->fec_grp_hash_table_high = 0;
+	fecp->fec_grp_hash_table_low = 0;
 	fecp->fec_r_buff_size = PKT_MAXBLR_SIZE;
 	fecp->fec_ecntrl = 2;
 	fecp->fec_r_des_active = 0;
+#ifndef CONFIG_M5272
+	fecp->fec_hash_table_high = 0;
+	fecp->fec_hash_table_low = 0;
+#endif
 
 	dev->base_addr = (unsigned long)fecp;
 
@@ -2500,8 +2504,8 @@ fec_restart(struct net_device *dev, int 
 
 	/* Reset all multicast.
 	*/
-	fecp->fec_hash_table_high = 0;
-	fecp->fec_hash_table_low = 0;
+	fecp->fec_grp_hash_table_high = 0;
+	fecp->fec_grp_hash_table_low = 0;
 
 	/* Set maximum receive buffer size.
 	*/
