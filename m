Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZFHWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZFHWHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZFHWHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:07:18 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:46627 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZFHWHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:07:15 -0400
Message-ID: <4A2D8B8B.80905@gmail.com>
Date: Tue, 09 Jun 2009 00:07:07 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Linux Netdev List <netdev@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: [patch] r8169: fix crash when large packets are received
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 09 Jun 2009 00:07:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev reported receiving a large packet could crash
a machine with RTL8169 NIC.
( original thread at http://lkml.org/lkml/2009/6/8/192 )

Problem is this driver tells that NIC frames up to 16383 bytes
can be received but provides skb to rx ring allocated with
smaller sizes (1536 bytes in case standard 1500 bytes MTU is used)

When a frame larger than what was allocated by driver is received,
dma transfert can occurs past the end of buffer and corrupt
kernel memory.

Fix is to tell to NIC what is the maximum size a frame can be.

This bug is very old, (before git introduction, linux-2.6.10), and 
should be backported to stable versions.

Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Michael Tokarev <mjt@tls.msk.ru>
---
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 8247a94..3b19e0c 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -66,7 +66,6 @@ static const int multicast_filter_limit = 32;
 #define RX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
 #define TX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
 #define EarlyTxThld	0x3F	/* 0x3F means NO early transmit */
-#define RxPacketMaxSize	0x3FE8	/* 16K - 1 - ETH_HLEN - VLAN - CRC... */
 #define SafeMtu		0x1c20	/* ... actually life sucks beyond ~7k */
 #define InterFrameGap	0x03	/* 3 means InterFrameGap = the shortest one */
 
@@ -2357,10 +2356,10 @@ static u16 rtl_rw_cpluscmd(void __iomem *ioaddr)
 	return cmd;
 }
 
-static void rtl_set_rx_max_size(void __iomem *ioaddr)
+static void rtl_set_rx_max_size(void __iomem *ioaddr, unsigned int rx_buf_sz)
 {
 	/* Low hurts. Let's disable the filtering. */
-	RTL_W16(RxMaxSize, 16383);
+	RTL_W16(RxMaxSize, rx_buf_sz);
 }
 
 static void rtl8169_set_magic_reg(void __iomem *ioaddr, unsigned mac_version)
@@ -2407,7 +2406,7 @@ static void rtl_hw_start_8169(struct net_device *dev)
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	if ((tp->mac_version == RTL_GIGA_MAC_VER_01) ||
 	    (tp->mac_version == RTL_GIGA_MAC_VER_02) ||
@@ -2668,7 +2667,7 @@ static void rtl_hw_start_8168(struct net_device *dev)
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	tp->cp_cmd |= RTL_R16(CPlusCmd) | PktCntrDisable | INTT_1;
 
@@ -2846,7 +2845,7 @@ static void rtl_hw_start_8101(struct net_device *dev)
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	tp->cp_cmd |= rtl_rw_cpluscmd(ioaddr) | PCIMulRW;
 
