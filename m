Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbYJVRqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbYJVRqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757774AbYJVRgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:36:16 -0400
Received: from kroah.org ([198.145.64.141]:50450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757317AbYJVRgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:36:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/42] Staging: sxg: fix up unused function warnings
Date: Wed, 22 Oct 2008 10:29:16 -0700
Message-Id: <1224696563-5170-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions aren't used yet, so put them behind the
proper #define so the compiler doesn't complain about them.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/sxg/sxg.c |  155 +++++++++++++++++++++++----------------------
 1 files changed, 78 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/sxg/sxg.c b/drivers/staging/sxg/sxg.c
index 3b05acf..fe935e2 100644
--- a/drivers/staging/sxg/sxg.c
+++ b/drivers/staging/sxg/sxg.c
@@ -112,12 +112,16 @@ static bool sxg_mac_filter(p_adapter_t adapter,
 static struct net_device_stats *sxg_get_stats(p_net_device dev);
 #endif
 
+#define XXXTODO 0
+
+#if XXXTODO
 static int sxg_mac_set_address(p_net_device dev, void *ptr);
+static void sxg_mcast_set_list(p_net_device dev);
+#endif
 
 static void sxg_adapter_set_hwaddr(p_adapter_t adapter);
 
 static void sxg_unmap_mmio_space(p_adapter_t adapter);
-static void sxg_mcast_set_mask(p_adapter_t adapter);
 
 static int sxg_initialize_adapter(p_adapter_t adapter);
 static void sxg_stock_rcv_buffers(p_adapter_t adapter);
@@ -132,9 +136,6 @@ static int sxg_write_mdio_reg(p_adapter_t adapter,
 			      u32 DevAddr, u32 RegAddr, u32 Value);
 static int sxg_read_mdio_reg(p_adapter_t adapter,
 			     u32 DevAddr, u32 RegAddr, u32 *pValue);
-static void sxg_mcast_set_list(p_net_device dev);
-
-#define XXXTODO 0
 
 static unsigned int sxg_first_init = 1;
 static char *sxg_banner =
@@ -2668,38 +2669,6 @@ static int sxg_read_mdio_reg(p_adapter_t adapter,
 }
 
 /*
- *  Allocate a mcast_address structure to hold the multicast address.
- *  Link it in.
- */
-static int sxg_mcast_add_list(p_adapter_t adapter, char *address)
-{
-	p_mcast_address_t mcaddr, mlist;
-	bool equaladdr;
-
-	/* Check to see if it already exists */
-	mlist = adapter->mcastaddrs;
-	while (mlist) {
-		ETHER_EQ_ADDR(mlist->address, address, equaladdr);
-		if (equaladdr) {
-			return (STATUS_SUCCESS);
-		}
-		mlist = mlist->next;
-	}
-
-	/* Doesn't already exist.  Allocate a structure to hold it */
-	mcaddr = kmalloc(sizeof(mcast_address_t), GFP_ATOMIC);
-	if (mcaddr == NULL)
-		return 1;
-
-	memcpy(mcaddr->address, address, 6);
-
-	mcaddr->next = adapter->mcastaddrs;
-	adapter->mcastaddrs = mcaddr;
-
-	return (STATUS_SUCCESS);
-}
-
-/*
  * Functions to obtain the CRC corresponding to the destination mac address.
  * This is a standard ethernet CRC in that it is a 32-bit, reflected CRC using
  * the polynomial:
@@ -2710,7 +2679,6 @@ static int sxg_mcast_add_list(p_adapter_t adapter, char *address)
  *
  */
 static u32 sxg_crc_table[256];	/* Table of CRC's for all possible byte values */
-static u32 sxg_crc_init;	/* Is table initialized                        */
 
 /*
  *  Contruct the CRC32 table
@@ -2737,6 +2705,8 @@ static void sxg_mcast_init_crc32(void)
 	}
 }
 
+#if XXXTODO
+static u32 sxg_crc_init;	/* Is table initialized */
 /*
  *  Return the MAC hast as described above.
  */
@@ -2765,6 +2735,74 @@ static unsigned char sxg_mcast_get_mac_hash(char *macaddr)
 	return (machash);
 }
 
+static void sxg_mcast_set_mask(p_adapter_t adapter)
+{
+	PSXG_UCODE_REGS sxg_regs = adapter->UcodeRegs;
+
+	DBG_ERROR("%s ENTER (%s) macopts[%x] mask[%llx]\n", __func__,
+		  adapter->netdev->name, (unsigned int)adapter->MacFilter,
+		  adapter->MulticastMask);
+
+	if (adapter->MacFilter & (MAC_ALLMCAST | MAC_PROMISC)) {
+		/* Turn on all multicast addresses. We have to do this for promiscuous
+		 * mode as well as ALLMCAST mode.  It saves the Microcode from having
+		 * to keep state about the MAC configuration.
+		 */
+/*              DBG_ERROR("sxg: %s macopts = MAC_ALLMCAST | MAC_PROMISC\n      SLUT MODE!!!\n",__func__); */
+		WRITE_REG(sxg_regs->McastLow, 0xFFFFFFFF, FLUSH);
+		WRITE_REG(sxg_regs->McastHigh, 0xFFFFFFFF, FLUSH);
+/*        DBG_ERROR("%s (%s) WRITE to slic_regs slic_mcastlow&high 0xFFFFFFFF\n",__func__, adapter->netdev->name); */
+
+	} else {
+		/* Commit our multicast mast to the SLIC by writing to the multicast
+		 * address mask registers
+		 */
+		DBG_ERROR("%s (%s) WRITE mcastlow[%lx] mcasthigh[%lx]\n",
+			  __func__, adapter->netdev->name,
+			  ((ulong) (adapter->MulticastMask & 0xFFFFFFFF)),
+			  ((ulong)
+			   ((adapter->MulticastMask >> 32) & 0xFFFFFFFF)));
+
+		WRITE_REG(sxg_regs->McastLow,
+			  (u32) (adapter->MulticastMask & 0xFFFFFFFF), FLUSH);
+		WRITE_REG(sxg_regs->McastHigh,
+			  (u32) ((adapter->
+				  MulticastMask >> 32) & 0xFFFFFFFF), FLUSH);
+	}
+}
+
+/*
+ *  Allocate a mcast_address structure to hold the multicast address.
+ *  Link it in.
+ */
+static int sxg_mcast_add_list(p_adapter_t adapter, char *address)
+{
+	p_mcast_address_t mcaddr, mlist;
+	bool equaladdr;
+
+	/* Check to see if it already exists */
+	mlist = adapter->mcastaddrs;
+	while (mlist) {
+		ETHER_EQ_ADDR(mlist->address, address, equaladdr);
+		if (equaladdr) {
+			return (STATUS_SUCCESS);
+		}
+		mlist = mlist->next;
+	}
+
+	/* Doesn't already exist.  Allocate a structure to hold it */
+	mcaddr = kmalloc(sizeof(mcast_address_t), GFP_ATOMIC);
+	if (mcaddr == NULL)
+		return 1;
+
+	memcpy(mcaddr->address, address, 6);
+
+	mcaddr->next = adapter->mcastaddrs;
+	adapter->mcastaddrs = mcaddr;
+
+	return (STATUS_SUCCESS);
+}
+
 static void sxg_mcast_set_bit(p_adapter_t adapter, char *address)
 {
 	unsigned char crcpoly;
@@ -2783,7 +2821,6 @@ static void sxg_mcast_set_bit(p_adapter_t adapter, char *address)
 
 static void sxg_mcast_set_list(p_net_device dev)
 {
-#if XXXTODO
 	p_adapter_t adapter = (p_adapter_t) netdev_priv(dev);
 	int status = STATUS_SUCCESS;
 	int i;
@@ -2835,45 +2872,9 @@ static void sxg_mcast_set_list(p_net_device dev)
 			sxg_mcast_set_mask(adapter);
 		}
 	}
-#endif
 	return;
 }
-
-static void sxg_mcast_set_mask(p_adapter_t adapter)
-{
-	PSXG_UCODE_REGS sxg_regs = adapter->UcodeRegs;
-
-	DBG_ERROR("%s ENTER (%s) macopts[%x] mask[%llx]\n", __func__,
-		  adapter->netdev->name, (unsigned int)adapter->MacFilter,
-		  adapter->MulticastMask);
-
-	if (adapter->MacFilter & (MAC_ALLMCAST | MAC_PROMISC)) {
-		/* Turn on all multicast addresses. We have to do this for promiscuous
-		 * mode as well as ALLMCAST mode.  It saves the Microcode from having
-		 * to keep state about the MAC configuration.
-		 */
-/*              DBG_ERROR("sxg: %s macopts = MAC_ALLMCAST | MAC_PROMISC\n      SLUT MODE!!!\n",__func__); */
-		WRITE_REG(sxg_regs->McastLow, 0xFFFFFFFF, FLUSH);
-		WRITE_REG(sxg_regs->McastHigh, 0xFFFFFFFF, FLUSH);
-/*        DBG_ERROR("%s (%s) WRITE to slic_regs slic_mcastlow&high 0xFFFFFFFF\n",__func__, adapter->netdev->name); */
-
-	} else {
-		/* Commit our multicast mast to the SLIC by writing to the multicast
-		 * address mask registers
-		 */
-		DBG_ERROR("%s (%s) WRITE mcastlow[%lx] mcasthigh[%lx]\n",
-			  __func__, adapter->netdev->name,
-			  ((ulong) (adapter->MulticastMask & 0xFFFFFFFF)),
-			  ((ulong)
-			   ((adapter->MulticastMask >> 32) & 0xFFFFFFFF)));
-
-		WRITE_REG(sxg_regs->McastLow,
-			  (u32) (adapter->MulticastMask & 0xFFFFFFFF), FLUSH);
-		WRITE_REG(sxg_regs->McastHigh,
-			  (u32) ((adapter->
-				  MulticastMask >> 32) & 0xFFFFFFFF), FLUSH);
-	}
-}
+#endif
 
 static void sxg_unmap_mmio_space(p_adapter_t adapter)
 {
@@ -3267,9 +3268,9 @@ static void sxg_adapter_set_hwaddr(p_adapter_t adapter)
 
 }
 
+#if XXXTODO
 static int sxg_mac_set_address(p_net_device dev, void *ptr)
 {
-#if XXXTODO
 	p_adapter_t adapter = (p_adapter_t) netdev_priv(dev);
 	struct sockaddr *addr = ptr;
 
@@ -3295,9 +3296,9 @@ static int sxg_mac_set_address(p_net_device dev, void *ptr)
 		  adapter->currmacaddr[5]);
 
 	sxg_config_set(adapter, TRUE);
-#endif
 	return 0;
 }
+#endif
 
 /*****************************************************************************/
 /*************  SXG DRIVER FUNCTIONS  (below) ********************************/
-- 
1.6.0.2

