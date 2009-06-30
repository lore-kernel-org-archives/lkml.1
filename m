Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbZGAAcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbZGAAcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759652AbZGAAaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:06 -0400
Received: from kroah.org ([198.145.64.141]:34327 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759633AbZGAAaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:57 2009
Message-Id: <20090701000357.604995676@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 16:59:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 09/30] r8169: fix crash when large packets are received
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=r8169-fix-crash-when-large-packets-are-received.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit fdd7b4c3302c93f6833e338903ea77245eb510b4 upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -65,7 +65,6 @@ static const int multicast_filter_limit 
 #define RX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
 #define TX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
 #define EarlyTxThld	0x3F	/* 0x3F means NO early transmit */
-#define RxPacketMaxSize	0x3FE8	/* 16K - 1 - ETH_HLEN - VLAN - CRC... */
 #define SafeMtu		0x1c20	/* ... actually life sucks beyond ~7k */
 #define InterFrameGap	0x03	/* 3 means InterFrameGap = the shortest one */
 
@@ -1976,10 +1975,10 @@ static u16 rtl_rw_cpluscmd(void __iomem 
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
@@ -2026,7 +2025,7 @@ static void rtl_hw_start_8169(struct net
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	if ((tp->mac_version == RTL_GIGA_MAC_VER_01) ||
 	    (tp->mac_version == RTL_GIGA_MAC_VER_02) ||
@@ -2090,7 +2089,7 @@ static void rtl_hw_start_8168(struct net
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	rtl_set_rx_tx_config_registers(tp);
 
@@ -2142,7 +2141,7 @@ static void rtl_hw_start_8101(struct net
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	tp->cp_cmd |= rtl_rw_cpluscmd(ioaddr) | PCIMulRW;
 


